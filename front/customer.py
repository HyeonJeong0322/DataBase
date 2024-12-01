import tkinter as tk
from tkinter import messagebox, ttk
from datetime import datetime
import pymysql

# 데이터베이스 연결 설정
def connect_to_db():
    return pymysql.connect(
        host='localhost', user='tester01', password='123456', db='new1', charset='utf8'
    )

# 공통: 데이터 조회 함수
def fetch_data(query, params=()):
    try:
        conn = connect_to_db()
        cursor = conn.cursor()
        cursor.execute(query, params)
        return cursor.fetchall()
    except pymysql.MySQLError as e:
        messagebox.showerror("오류", f"데이터베이스 오류: {e}")
        return []
    finally:
        if conn:
            conn.close()

# 공통: 데이터 삽입/수정 함수
def execute_query(query, params):
    try:
        conn = connect_to_db()
        cursor = conn.cursor()
        cursor.execute(query, params)
        conn.commit()
        return True
    except pymysql.MySQLError as e:
        messagebox.showerror("오류", f"데이터베이스 오류: {e}")
        return False
    finally:
        if conn:
            conn.close()

# 고객 화면 (음식 주문)
def customer_screen():
    customer_window = tk.Toplevel(root)
    customer_window.title("소비자 화면")

    def get_food_id(food_name):
        try:
            conn = connect_to_db()
            cursor = conn.cursor()
            cursor.execute("SELECT id FROM foods WHERE name = %s", (food_name,))
            result = cursor.fetchone()
            conn.close()
            if result:
                return result[0]  # ID 값 반환
            else:
                raise ValueError(f"음식 '{food_name}'을(를) 찾을 수 없습니다.")
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            return None

    def get_max_order_quantity(food_id):
        try:
            conn = connect_to_db()
            cursor = conn.cursor()

            # 음식에 필요한 재료 및 수량을 조회
            cursor.execute("""
            SELECT fi.ingredient_id, fi.quantity
            FROM food_ingredients fi
            WHERE fi.food_id = %s
            """, (food_id,))
            food_ingredients = cursor.fetchall()

            # 각 재료의 재고 수량을 조회
            max_quantity = float('inf')  # 최대 주문 수량을 무한대로 시작

            for ingredient_id, required_quantity in food_ingredients:
                cursor.execute("""
                SELECT s.quantity
                FROM stock s
                WHERE s.ingredient_id = %s
                """, (ingredient_id,))
                stock_quantity = cursor.fetchone()

                if stock_quantity:
                    stock_quantity = stock_quantity[0]
                    # 해당 재료로 주문할 수 있는 최대 수량 계산
                    max_for_ingredient = stock_quantity // required_quantity
                    max_quantity = min(max_quantity, max_for_ingredient)

            conn.close()
            return int(max_quantity) if max_quantity != float('inf') else 0
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            return 0

    def get_customer_id_by_name(customer_name):
        """고객 이름으로 고객 ID 조회, 없으면 None 반환"""
        try:
            conn = connect_to_db()
            cursor = conn.cursor()
            cursor.execute("SELECT id FROM customers WHERE name = %s", (customer_name,))
            result = cursor.fetchone()
            conn.close()
            return result[0] if result else None
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            return None

    def add_new_customer(customer_name):
        """새 고객 추가 후 고객 ID 반환"""
        try:
            conn = connect_to_db()
            cursor = conn.cursor()
            cursor.execute("INSERT INTO customers (name) VALUES (%s)", (customer_name,))
            conn.commit()
            cursor.execute("SELECT id FROM customers WHERE name = %s", (customer_name,))
            result = cursor.fetchone()
            conn.close()
            return result[0] if result else None
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            return None

    def place_order():
        menu_item = menu_combobox.get()
        quantity = entry_quantity.get()
        customer_name = entry_customer_name.get()  # 고객 이름 입력 받기

        if not all([menu_item, quantity, customer_name]):
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return

        try:
            # 고객 ID 조회, 없다면 새로 추가
            customer_id = get_customer_id_by_name(customer_name)
            if not customer_id:
                # 고객이 없으면 새로 추가
                customer_id = add_new_customer(customer_name)
                if not customer_id:
                    messagebox.showerror("오류", "고객 추가 실패")
                    return

            # 음식 ID 조회
            food_id = get_food_id(menu_item)
            if food_id is None:
                return

            # 음식 가격 조회
            conn = connect_to_db()
            cursor = conn.cursor()
            cursor.execute("SELECT price FROM foods WHERE id = %s", (food_id,))
            food_price = cursor.fetchone()[0]  # 음식 가격

            # 총 금액 계산
            total_amount = food_price * int(quantity)

            # 최대 주문 가능 수량 조회
            max_quantity = get_max_order_quantity(food_id)
            if int(quantity) > max_quantity:
                messagebox.showwarning("주문 불가", f"최대 주문 수량은 {max_quantity}개입니다.")
                return

            # 음식에 필요한 재료 및 수량 조회
            cursor.execute("""
            SELECT fi.ingredient_id, fi.quantity
            FROM food_ingredients fi
            WHERE fi.food_id = %s
            """, (food_id,))
            food_ingredients = cursor.fetchall()

            # 재료 사용 기록을 `usage_records` 테이블에 추가
            for ingredient_id, required_quantity in food_ingredients:
                sql = """
                INSERT INTO usage_records (ingredient_id, usage_date, quantity, purpose, created_at)
                VALUES (%s, %s, %s, %s, %s)
                """
                params = (ingredient_id, datetime.now().date(), required_quantity * int(quantity), "음식 주문", datetime.now())
                execute_query(sql, params)

            # 주문 처리 후, `sales` 테이블에 기록 추가
            sql = """
            INSERT INTO sales (customer_id, total_amount, sale_date)
            VALUES (%s, %s, %s)
            """
            if execute_query(sql, (customer_id, total_amount, datetime.now().date())):
                messagebox.showinfo("성공", f"{menu_item} 주문이 완료되었습니다.")
                return

        except ValueError as ve:
            messagebox.showerror("오류", str(ve))
        except Exception as e:
            messagebox.showerror("오류", f"예기치 않은 오류: {e}")

    # UI 구성
    tk.Label(customer_window, text="음식 선택:").pack()
    menu_combobox = ttk.Combobox(customer_window, values=["Tomato Salad", "Chicken Pizza", "Olive Oil Dressing"])
    menu_combobox.pack()

    tk.Label(customer_window, text="고객 이름:").pack()
    entry_customer_name = tk.Entry(customer_window)
    entry_customer_name.pack()

    tk.Label(customer_window, text="수량:").pack()
    entry_quantity = tk.Entry(customer_window)
    entry_quantity.pack()

    tk.Button(customer_window, text="주문하기", command=place_order).pack(pady=5)


# 손님 리스트 관리 화면
def customer_list_screen():
    customer_list_window = tk.Toplevel(root)
    customer_list_window.title("손님 리스트")

    # 손님 추가 함수
    def add_customer():
        name = entry_name.get()
        phone = entry_phone.get()
        email = entry_email.get()

        if not name or not phone or not email:
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return

        try:
            query = "INSERT INTO customers (name, phone, email) VALUES (%s, %s, %s)"
            params = (name, phone, email)
            if execute_query(query, params):
                messagebox.showinfo("성공", f"{name}님이 추가되었습니다.")
                load_customers()  # 새로 추가된 손님 리스트 갱신
            else:
                messagebox.showerror("오류", "손님 추가 실패")
        except Exception as e:
            messagebox.showerror("오류", f"예기치 않은 오류: {e}")

    # 손님 삭제 함수
    def delete_customer():
        selected_item = customer_treeview.selection()
        if not selected_item:
            messagebox.showwarning("선택 오류", "삭제할 손님을 선택해주세요.")
            return

        customer_id = customer_treeview.item(selected_item)['values'][0]
        try:
            query = "DELETE FROM customers WHERE id = %s"
            if execute_query(query, (customer_id,)):
                messagebox.showinfo("성공", "손님이 삭제되었습니다.")
                load_customers()  # 삭제 후 리스트 갱신
            else:
                messagebox.showerror("오류", "손님 삭제 실패")
        except Exception as e:
            messagebox.showerror("오류", f"예기치 않은 오류: {e}")

    # 손님 리스트 불러오기
    def load_customers():
        for item in customer_treeview.get_children():
            customer_treeview.delete(item)

        query = "SELECT id, name, phone, email, membership_status FROM customers"
        customers = fetch_data(query)

        for customer in customers:
            customer_treeview.insert("", "end", values=customer)

    # UI 구성
    tk.Label(customer_list_window, text="이름:").pack(pady=5)
    entry_name = tk.Entry(customer_list_window)
    entry_name.pack(pady=5)

    tk.Label(customer_list_window, text="전화번호:").pack(pady=5)
    entry_phone = tk.Entry(customer_list_window)
    entry_phone.pack(pady=5)

    tk.Label(customer_list_window, text="이메일:").pack(pady=5)
    entry_email = tk.Entry(customer_list_window)
    entry_email.pack(pady=5)

    tk.Button(customer_list_window, text="손님 추가", command=add_customer).pack(pady=10)

    # 손님 목록 표시
    columns = ("ID", "이름", "전화번호", "이메일", "회원 상태")
    customer_treeview = ttk.Treeview(customer_list_window, columns=columns, show="headings")
    for col in columns:
        customer_treeview.heading(col, text=col)
    customer_treeview.pack(pady=20)

    # 손님 삭제 버튼
    tk.Button(customer_list_window, text="손님 삭제", command=delete_customer).pack(pady=10)

    # 손님 목록 로드
    load_customers()

# 메인 화면
root = tk.Tk()
root.title("소비자 관리 시스템")

menu_bar = tk.Menu(root)
root.config(menu=menu_bar)

menu = tk.Menu(menu_bar, tearoff=0)
menu.add_command(label="소비자 화면", command=customer_screen)
menu.add_command(label="손님 리스트", command=customer_list_screen)  # 손님 리스트 메뉴 추가
menu.add_separator()
menu.add_command(label="종료", command=root.quit)
menu_bar.add_cascade(label="메뉴", menu=menu)

root.mainloop()
