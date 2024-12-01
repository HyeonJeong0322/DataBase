import tkinter as tk
from tkinter import messagebox, ttk
from datetime import datetime
import pymysql
import connectDB

# 공급업체 리스트 화면
def supplier_list_screen():
    supplier_window = tk.Toplevel(root)
    supplier_window.title("공급업체 화면")

    def add_supplier():
        name = entry_name.get()
        contact = entry_contact.get()
        address = entry_address.get()
        email = entry_email.get()

        if not all([name, contact, address, email]):
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return

        sql = """
        INSERT INTO suppliers (name, contact, address, email, created_at)
        VALUES (%s, %s, %s, %s, %s)
        """
        params = (name, contact, address, email, datetime.now())
        if connectDB.execute_query(sql, params):
            messagebox.showinfo("성공", "공급업체가 추가되었습니다.")
            show_suppliers()

    def show_suppliers():
        """공급업체 목록 표시"""
        tree.delete(*tree.get_children())
        rows = connectDB.fetch_data("SELECT id, name, contact, address, email FROM suppliers ORDER BY id ASC")
        for row in rows:
            tree.insert("", "end", values=row)

    def delete_supplier():
        """선택한 공급업체 삭제"""
        selected_item = tree.selection()
        if not selected_item:
            messagebox.showwarning("선택 오류", "삭제할 공급업체를 선택해주세요.")
            return

        supplier_id = tree.item(selected_item, "values")[0]  # 선택된 공급업체 ID
        confirm = messagebox.askyesno("삭제 확인", f"정말로 공급업체 ID {supplier_id}를 삭제하시겠습니까?")
        if confirm:
            sql = "DELETE FROM suppliers WHERE id = %s"
            params = (supplier_id,)
            if connectDB.execute_query(sql, params):
                messagebox.showinfo("성공", f"공급업체 ID {supplier_id}가 삭제되었습니다.")
                show_suppliers()

    # UI 구성
    tk.Label(supplier_window, text="공급업체 이름:").pack()
    entry_name = tk.Entry(supplier_window)
    entry_name.pack()

    tk.Label(supplier_window, text="연락처:").pack()
    entry_contact = tk.Entry(supplier_window)
    entry_contact.pack()

    tk.Label(supplier_window, text="주소:").pack()
    entry_address = tk.Entry(supplier_window)
    entry_address.pack()

    tk.Label(supplier_window, text="이메일:").pack()
    entry_email = tk.Entry(supplier_window)
    entry_email.pack()

    tk.Button(supplier_window, text="공급업체 추가", command=add_supplier).pack(pady=5)
    tk.Button(supplier_window, text="선택된 공급업체 삭제", command=delete_supplier).pack(pady=5)

    # Treeview
    tree = ttk.Treeview(supplier_window, columns=("ID", "이름", "연락처", "주소", "이메일"), show="headings")
    tree.heading("ID", text="ID")
    tree.heading("이름", text="이름")
    tree.heading("연락처", text="연락처")
    tree.heading("주소", text="주소")
    tree.heading("이메일", text="이메일")
    tree.pack(pady=10)

    show_suppliers()

# 공급업체 재료 관리 화면
def supplier_screen():
    supplier_window = tk.Toplevel(root)
    supplier_window.title("공급자 재료 관리 화면")

    def get_supplied_ingredients(supplier_id):
        """공급자가 공급하는 재료 목록 조회"""
        try:
            conn = connectDB.connect_to_db()
            cursor = conn.cursor()
            cursor.execute("""
            SELECT i.name, i.category, si.unit_price, si.id, si.ingredient_id
            FROM supplier_ingredients si
            JOIN ingredients i ON si.ingredient_id = i.id
            WHERE si.supplier_id = %s
            """, (supplier_id,))
            ingredients = cursor.fetchall()
            conn.close()
            return ingredients
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            return []

    def show_supplied_ingredients():
        """선택한 공급자가 공급하는 재료 목록을 표시"""
        supplier_name = supplier_combobox.get()
        if not supplier_name:
            return
        
        # 공급자 ID 조회
        try:
            conn = connectDB.connect_to_db()
            cursor = conn.cursor()
            cursor.execute("SELECT id FROM suppliers WHERE name = %s", (supplier_name,))
            supplier_id = cursor.fetchone()[0]
            conn.close()
            
            ingredients = get_supplied_ingredients(supplier_id)
            
            # 재료 목록 표시
            for widget in frame_ingredients.winfo_children():
                widget.destroy()
            
            tk.Label(frame_ingredients, text="공급하는 재료:").pack()
            
            # 재료 목록을 추가하고 각 재료에 대해 가격 수정 버튼과 삭제 버튼을 추가
            for ingredient_name, category, unit_price, si_id, ingredient_id in ingredients:
                label = tk.Label(frame_ingredients, text=f"{ingredient_name} ({category}) - 단가: {unit_price}")
                label.pack()
                
                # 단가 수정 버튼
                edit_button = tk.Button(frame_ingredients, text="단가 수정", command=lambda si_id=si_id, unit_price=unit_price: edit_price(si_id, unit_price))
                edit_button.pack()
                
                # 재료 삭제 버튼
                delete_button = tk.Button(frame_ingredients, text="재료 삭제", command=lambda si_id=si_id, ingredient_name=ingredient_name, ingredient_id=ingredient_id: delete_ingredient(si_id, ingredient_id, ingredient_name))
                delete_button.pack()

            # 재료 추가 폼을 항상 표시
            add_ingredient_frame.pack(pady=10)
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")

    def add_ingredient_to_supplier():
        """새로운 재료를 공급자에 추가"""
        ingredient_name = entry_ingredient_name.get()
        category = entry_category.get()
        unit_price = entry_unit_price.get()
        unit = entry_unit.get()  # 단위 입력 받기
        storage_method = entry_storage_method.get()  # 보관 방법 입력 받기
        
        if not all([ingredient_name, category, unit_price, unit, storage_method]):
            messagebox.showwarning("입력 오류", "모든 필드를 입력해주세요.")
            return
        
        
        # ingredients 테이블에 재료 추가
        try:
            conn = connectDB.connect_to_db()
            cursor = conn.cursor()
            cursor.execute("INSERT INTO ingredients (name, category, unit, storage_method) VALUES (%s, %s, %s, %s)", 
                        (ingredient_name, category, unit, storage_method))
            conn.commit()
            
            # 새로 추가된 재료의 ID 가져오기
            cursor.execute("SELECT id FROM ingredients WHERE name = %s", (ingredient_name,))
            ingredient_id = cursor.fetchone()[0]
            
            # 공급자 ID 가져오기
            supplier_name = supplier_combobox.get()
            cursor.execute("SELECT id FROM suppliers WHERE name = %s", (supplier_name,))
            supplier_id = cursor.fetchone()[0]
            
            # supplier_ingredients 테이블에 공급자와 재료 관계 추가
            cursor.execute("INSERT INTO supplier_ingredients (supplier_id, ingredient_id, unit_price) VALUES (%s, %s, %s)", 
                        (supplier_id, ingredient_id, unit_price))
            conn.commit()
            
            conn.close()
            
            messagebox.showinfo("성공", f"{ingredient_name}이(가) 추가되었습니다.")
            show_supplied_ingredients()  # 공급자가 공급하는 재료 목록 갱신
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")
            conn.rollback()

    

    def edit_price(si_id, current_unit_price):
        """단가 수정 기능"""
        def update_price():
            """단가 업데이트"""
            new_unit_price = entry_new_unit_price.get()
            if not new_unit_price:
                messagebox.showwarning("입력 오류", "단가를 입력해주세요.")
                return
            
            try:
                conn = connectDB.connect_to_db()
                cursor = conn.cursor()
                cursor.execute("""
                UPDATE supplier_ingredients
                SET unit_price = %s
                WHERE id = %s
                """, (new_unit_price, si_id))
                conn.commit()
                conn.close()
                
                messagebox.showinfo("성공", "단가가 수정되었습니다.")
                edit_window.destroy()
                show_supplied_ingredients()  # 재료 목록 갱신
            except pymysql.MySQLError as e:
                messagebox.showerror("오류", f"데이터베이스 오류: {e}")
                conn.rollback()

        # 단가 수정 입력창 팝업
        edit_window = tk.Toplevel(supplier_window)
        edit_window.title("단가 수정")
        
        tk.Label(edit_window, text=f"현재 단가: {current_unit_price}").pack(pady=5)
        
        tk.Label(edit_window, text="새로운 단가:").pack(pady=5)
        entry_new_unit_price = tk.Entry(edit_window)
        entry_new_unit_price.pack(pady=5)
        
        tk.Button(edit_window, text="단가 수정", command=update_price).pack(pady=10)

    def delete_ingredient(si_id, ingredient_id, ingredient_name):
        """재료 삭제 기능"""
        def confirm_delete():
            """삭제 확인"""
            try:
                conn = connectDB.connect_to_db()
                cursor = conn.cursor()
                
                
                # ingredients 테이블에서 해당 재료 삭제
                cursor.execute("""DELETE FROM ingredients WHERE id = %s""", (ingredient_id,))
                
                # supplier_ingredients 테이블에서 해당 공급자의 재료 삭제
                cursor.execute("""DELETE FROM supplier_ingredients WHERE id = %s""", (si_id,))
                
                conn.commit()
                conn.close()
                
                messagebox.showinfo("성공", f"{ingredient_name}이(가) 삭제되었습니다.")
                delete_window.destroy()
                show_supplied_ingredients()  # 재료 목록 갱신
            except pymysql.MySQLError as e:
                messagebox.showerror("오류", f"데이터베이스 오류: {e}")
                conn.rollback()

        # 재료 삭제 확인 창
        delete_window = tk.Toplevel(supplier_window)
        delete_window.title("재료 삭제")
        
        tk.Label(delete_window, text=f"정말로 {ingredient_name}을(를) 삭제하시겠습니까?").pack(pady=10)
        
        tk.Button(delete_window, text="삭제", command=confirm_delete).pack(pady=5)
        tk.Button(delete_window, text="취소", command=delete_window.destroy).pack(pady=5)

    
    
    def load_supplier_list():
        """공급자 목록을 데이터베이스에서 가져오기"""
        try:
            conn = connectDB.connect_to_db()
            cursor = conn.cursor()
            cursor.execute("SELECT name FROM suppliers")
            suppliers = cursor.fetchall()
            conn.close()
            
            # 공급자 목록에서 'any'를 제외한 유효한 값만 추가
            supplier_combobox['values'] = [supplier[0] for supplier in suppliers]
        except pymysql.MySQLError as e:
            messagebox.showerror("오류", f"데이터베이스 오류: {e}")

    # UI 구성
    tk.Label(supplier_window, text="공급자 선택:").pack()
    supplier_combobox = ttk.Combobox(supplier_window)
    supplier_combobox.pack()
    
    load_supplier_list()  # 공급자 목록 로드
    
    tk.Button(supplier_window, text="공급하는 재료 보기", command=show_supplied_ingredients).pack(pady=5)
    
    # 공급하는 재료 목록 표시
    frame_ingredients = tk.Frame(supplier_window)
    frame_ingredients.pack(pady=10)
    
    # 재료 추가 폼
    add_ingredient_frame = tk.Frame(supplier_window)
    tk.Label(add_ingredient_frame, text="재료 이름:").pack()
    entry_ingredient_name = tk.Entry(add_ingredient_frame)
    entry_ingredient_name.pack()
    
    tk.Label(add_ingredient_frame, text="카테고리:").pack()
    entry_category = tk.Entry(add_ingredient_frame)
    entry_category.pack()
    
    tk.Label(add_ingredient_frame, text="단가:").pack()
    entry_unit_price = tk.Entry(add_ingredient_frame)
    entry_unit_price.pack()
    
    tk.Label(add_ingredient_frame, text="단위:").pack()  # 단위 입력 필드 추가
    entry_unit = tk.Entry(add_ingredient_frame)
    entry_unit.pack()

    tk.Label(add_ingredient_frame, text="보관 방법:").pack()  # 보관 방법 입력 필드 추가
    entry_storage_method = tk.Entry(add_ingredient_frame)
    entry_storage_method.pack()
    
    tk.Button(add_ingredient_frame, text="재료 추가", command=add_ingredient_to_supplier).pack(pady=5)

# 메인 화면
root = tk.Tk()
root.title("공급자 관리 시스템")

menu_bar = tk.Menu(root)
root.config(menu=menu_bar)

menu = tk.Menu(menu_bar, tearoff=0)
menu.add_command(label="공급업체 리스트 추가", command=supplier_list_screen)
menu.add_command(label="공급업체-재료 추가", command=supplier_screen)
menu.add_separator()
menu.add_command(label="종료", command=root.quit)
# 메뉴에 "판매 기록 관리" 항목 추가

menu_bar.add_cascade(label="메뉴", menu=menu)

root.mainloop()
