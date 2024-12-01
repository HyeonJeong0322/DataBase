from tkinter import messagebox
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
