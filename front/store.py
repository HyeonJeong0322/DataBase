import tkinter as tk
from tkinter import messagebox, ttk
from datetime import datetime
from tkcalendar import Calendar
import pymysql
import connectDB

# 판매 기록 관리 화면
def sales_record_screen():
    sales_window = tk.Toplevel(root)
    sales_window.title("판매 기록 관리 화면")

    def show_sales_records():
        tree.delete(*tree.get_children())
        # sales 테이블에서 고객 이름, 판매 일자, 총 금액을 조회
        query = """
        SELECT s.id, c.name AS customer_name, s.sale_date, s.total_amount
        FROM sales s
        JOIN customers c ON s.customer_id = c.id
        ORDER BY s.id ASC
        """
        rows = connectDB.fetch_data(query)
        for row in rows:
            tree.insert("", "end", values=row)

    # Treeview 위젯 생성
    tree = ttk.Treeview(sales_window, columns=("ID", "고객 이름", "판매 일자", "총 금액"), show="headings")
    tree.heading("ID", text="ID")
    tree.heading("고객 이름", text="고객 이름")
    tree.heading("판매 일자", text="판매 일자")
    tree.heading("총 금액", text="총 금액")
    tree.pack(pady=10)

    show_sales_records()  # 판매 기록 조회

# 저장 재고 관리 화면
def stock_screen():
    stock_window = tk.Toplevel(root)
    stock_window.title("재고 관리 화면")

    def get_food_ingredients(food_name):
        """음식에 필요한 재료 및 수량 조회"""
        try:
            conn = connectDB.connect_to_db()
            cursor = conn.cursor()
            cursor.execute("""
            SELECT i.name, fi.quantity, i.unit
            FROM food_ingredients fi
            JOIN ingredients i ON fi.ingredient_id = i.id
            JOIN foods f ON fi.food_id = f.id
            WHERE f.name = %s
            """, (food_name,))
            ingredients = cursor.fetchall()
            conn.close()
            return ingredients
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            return []

    def show_ingredients_for_food():
        """음식 선택 시 필요한 재료와 수량 표시"""
        food_name = menu_combobox.get()
        if not food_name:
            return

        ingredients = get_food_ingredients(food_name)
        
        # 재료 리스트 업데이트
        for widget in frame_ingredients.winfo_children():
            widget.destroy()  # 이전 목록 지우기
        
        tk.Label(frame_ingredients, text="필요한 재료와 수량:").pack()
        
        for ingredient_name, quantity, unit in ingredients:
            label = tk.Label(frame_ingredients, text=f"{ingredient_name}: {quantity} {unit}")
            label.pack()

    def is_valid_ingredient_id(ingredient_id):
        """식자재 ID가 유효한지 확인"""
        try:
            conn = connectDB.connect_to_db()
            cursor = conn.cursor()
            cursor.execute("SELECT id FROM ingredients WHERE id = %s", (ingredient_id,))
            result = cursor.fetchone()
            conn.close()
            return result is not None
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            return False

    def add_stock():
        """재고 추가"""
        ingredient_id = entry_ingredient_id.get()
        quantity = entry_quantity.get()
        received_date = cal_received.get_date()
        expiration_date = cal_expiration.get_date()

        if not all([ingredient_id, quantity, received_date, expiration_date]):
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return

        query = "CALL add_stock_procedure(%s, %s, %s, %s)"
        params = (ingredient_id, quantity, received_date, expiration_date)

            # 프로시저 실행
        connectDB.execute_query(query, params)
            
        show_stock()  # 재고 목록 갱신


    def show_stock():
        """재고 목록 표시"""
        tree.delete(*tree.get_children())

        # MySQL 프로시저 호출
        query = "CALL get_stock_list()"
        rows = connectDB.fetch_data(query)

        for row in rows:
            tree.insert("", "end", values=row)


    # UI 구성
    tk.Label(stock_window, text="음식 선택:").pack()
    menu_combobox = ttk.Combobox(stock_window, values=["Tomato Salad", "Chicken Pizza", "Olive Oil Dressing"])
    menu_combobox.pack()
    
    # 음식에 대한 재료와 수량 표시
    frame_ingredients = tk.Frame(stock_window)
    frame_ingredients.pack(pady=10)

    # 음식 선택 시 필요한 재료와 수량 보여주기
    menu_combobox.bind("<<ComboboxSelected>>", lambda event: show_ingredients_for_food())

    tk.Label(stock_window, text="식자재 ID:").pack()
    entry_ingredient_id = tk.Entry(stock_window)
    entry_ingredient_id.pack()

    tk.Label(stock_window, text="수량:").pack()
    entry_quantity = tk.Entry(stock_window)
    entry_quantity.pack()

    # 좌우 배치를 위해 Frame 추가
    frame_dates = tk.Frame(stock_window)
    frame_dates.pack(pady=5)

    # 입고 날짜와 유통기한을 좌우로 배치
    # 입고 날짜 레이블
    tk.Label(frame_dates, text="입고 날짜:").pack(side="left", padx=5)

    cal_received = Calendar(frame_dates, date_pattern="y-mm-dd")
    
    cal_received.pack(side="left", padx=5)

    # 유통기한 레이블
    tk.Label(frame_dates, text="유통기한:").pack(side="left", padx=5)

    cal_expiration = Calendar(frame_dates, date_pattern="y-mm-dd")
    cal_expiration.pack(side="left", padx=5)

    tk.Button(stock_window, text="재고 추가", command=add_stock).pack(pady=5)

    # Treeview
    tree = ttk.Treeview(stock_window, columns=("ID", "식자재 ID", "재료명", "수량", "입고 날짜", "유통기한", "공급자"), show="headings")
    tree.heading("ID", text="재고 ID")
    tree.heading("식자재 ID", text="식자재 ID")
    tree.heading("재료명", text="재료명")
    tree.heading("수량", text="수량")
    tree.heading("입고 날짜", text="입고 날짜")
    tree.heading("유통기한", text="유통기한")
    tree.heading("공급자", text="공급자")
    tree.pack(pady=10)

    show_stock()

# 사용 기록 관리 화면
def usage_screen():
    usage_window = tk.Toplevel(root)
    usage_window.title("사용 기록 관리 화면")

    def show_usage():
        tree.delete(*tree.get_children())
        # usage_records 테이블에서 데이터를 가져와서 표시
        rows = connectDB.fetch_data("SELECT ur.id, ur.ingredient_id, ur.usage_date, ur.quantity, ur.purpose, ur.created_at "
                          "FROM usage_records ur "
                          "JOIN ingredients i ON ur.ingredient_id = i.id "
                          "ORDER BY ur.id ASC")
        for row in rows:
            tree.insert("", "end", values=row)

    # Treeview 위젯을 먼저 생성하고, 그 후에 데이터를 표시
    tree = ttk.Treeview(usage_window, columns=("ID", "식자재 ID", "사용일", "수량", "목적", "시간"), show="headings")
    tree.heading("ID", text="ID")
    tree.heading("식자재 ID", text="식자재 ID")
    tree.heading("사용일", text="사용일")
    tree.heading("수량", text="수량")
    tree.heading("목적", text="목적")
    tree.heading("시간", text="시간")
    tree.pack(pady=10)

    show_usage()  # 데이터를 화면에 표시하는 함수 호출

# 음식 레시피 화면
def food_recipe_screen():
    food_recipe_window = tk.Toplevel(root)
    food_recipe_window.title("음식 레시피 관리")

    def get_food_recipes(food_name):
        """음식과 해당 재료 목록을 가져옵니다."""
        if not food_name:
            return []

        query = "CALL GetFoodRecipes(%s)"
        return connectDB.fetch_data(query, (food_name,))


    def show_food_recipes():
        """음식 레시피와 재고 상태를 표시"""
        food_name = food_combobox.get()
        if not food_name:
            return

        # 음식 레시피 표시
        ingredients = get_food_recipes()
        
        # 레시피 업데이트
        for widget in frame_recipes.winfo_children():
            widget.destroy()  # 기존 레시피 지우기
        
        tk.Label(frame_recipes, text="음식에 필요한 재료와 수량:").pack()
        
        for ingredient_name, quantity, unit in ingredients:
            label = tk.Label(frame_recipes, text=f"{ingredient_name}: {quantity} {unit}")
            label.pack()

        # 재고 상태 표시
        query = """
        SELECT s.ingredient_id, i.name, s.quantity, s.expiration_date
        FROM stock s
        JOIN ingredients i ON s.ingredient_id = i.id
        WHERE i.name IN (SELECT i.name 
                         FROM food_ingredients fi 
                         JOIN ingredients i ON fi.ingredient_id = i.id
                         JOIN foods f ON fi.food_id = f.id
                         WHERE f.name = %s)
        ORDER BY s.ingredient_id ASC
        """
        stock_data = connectDB.fetch_data(query, (food_name,))
        
        # 재고 리스트 업데이트
        for widget in frame_stock.winfo_children():
            widget.destroy()  # 기존 재고 지우기
        
        tk.Label(frame_stock, text="재고 상태:").pack()
        
        for ingredient_id, ingredient_name, stock_quantity, expiration_date in stock_data:
            label = tk.Label(frame_stock, text=f"{ingredient_name}: {stock_quantity} (유통기한: {expiration_date})")
            label.pack()

    def add_recipe():
        """음식 레시피 추가"""
        food_name = food_combobox.get()
        ingredient_id = entry_ingredient_id.get()
        quantity = entry_quantity.get()

        if not all([food_name, ingredient_id, quantity]):
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return

        query = "CALL AddRecipe(%s, %s, %s)"
        params = (food_name, ingredient_id, quantity)
        if connectDB.execute_query(query, params):
            messagebox.showinfo("성공", "음식 레시피가 추가되었습니다.")
            show_food_recipes()

    def update_recipe():
        """음식 레시피 수정"""
        food_name = food_combobox.get()
        ingredient_id = entry_ingredient_id.get()
        quantity = entry_quantity.get()

        if not all([food_name, ingredient_id, quantity]):
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return

        query = "CALL UpdateRecipe(%s, %s, %s)"
        params = (food_name, ingredient_id, quantity)
        if connectDB.execute_query(query, params):
            messagebox.showinfo("성공", "음식 레시피가 수정되었습니다.")
            show_food_recipes()

    def add_food():
        """새로운 음식을 추가"""
        food_name = entry_food_name.get()
        price = entry_price.get()
        description = entry_description.get()

        if not all([food_name, price, description]):
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return
        
        query = "CALL AddFood(%s, %s, %s)"
        params = (food_name, price, description)
        if connectDB.execute_query(query, params):
            messagebox.showinfo("성공", f"{food_name} 음식이 추가되었습니다.")
            # 음식 추가 후, 콤보박스에 새로운 음식 추가
            food_combobox['values'] = food_combobox['values'] + (food_name,)
            food_combobox.set(food_name)  # 추가된 음식으로 자동 설정
            show_food_recipes()


    def get_food_list():
        """음식 목록을 데이터베이스에서 가져옴"""
        query = "SELECT name FROM foods ORDER BY name ASC"
        return connectDB.fetch_data(query)

    # 음식 목록을 가져와서 콤보박스에 설정
    food_list = get_food_list()
    food_names = [food[0] for food in food_list]  # 음식 이름만 추출
    food_combobox = ttk.Combobox(food_recipe_window, values=food_names)
    
    food_combobox.pack()

    frame_recipes = tk.Frame(food_recipe_window)
    frame_recipes.pack(pady=10)

    frame_stock = tk.Frame(food_recipe_window)
    frame_stock.pack(pady=10)

    food_combobox.bind("<<ComboboxSelected>>", lambda event: show_food_recipes())

    tk.Label(food_recipe_window, text="식자재 ID:").pack()
    entry_ingredient_id = tk.Entry(food_recipe_window)
    entry_ingredient_id.pack()

    tk.Label(food_recipe_window, text="수량:").pack()
    entry_quantity = tk.Entry(food_recipe_window)
    entry_quantity.pack()

    tk.Button(food_recipe_window, text="레시피 추가", command=add_recipe).pack(pady=5)
    tk.Button(food_recipe_window, text="레시피 수정", command=update_recipe).pack(pady=5)

    # 음식 추가 UI 구성
    tk.Label(food_recipe_window, text="새 음식 추가:").pack(pady=10)

    tk.Label(food_recipe_window, text="음식 이름:").pack()
    entry_food_name = tk.Entry(food_recipe_window)
    entry_food_name.pack()

    tk.Label(food_recipe_window, text="가격:").pack()
    entry_price = tk.Entry(food_recipe_window)
    entry_price.pack()

    tk.Label(food_recipe_window, text="설명:").pack()
    entry_description = tk.Entry(food_recipe_window)
    entry_description.pack()

    tk.Button(food_recipe_window, text="음식 추가", command=add_food).pack(pady=5)

    show_food_recipes()


# 메인 화면
root = tk.Tk()
root.title("음식점 관리 시스템")

menu_bar = tk.Menu(root)
root.config(menu=menu_bar)

menu = tk.Menu(menu_bar, tearoff=0)
menu.add_command(label="재고 관리", command=stock_screen)
menu.add_command(label="재료 사용 기록", command=usage_screen)
menu.add_command(label="판매 기록 관리", command=sales_record_screen)
menu.add_command(label="음식 레시피", command=food_recipe_screen)
menu.add_separator()

menu.add_command(label="종료", command=root.quit)
# 메뉴에 "판매 기록 관리" 항목 추가

menu_bar.add_cascade(label="메뉴", menu=menu)

root.mainloop()
