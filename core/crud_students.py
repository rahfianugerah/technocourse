# crud_students.py
import streamlit as st
import pandas as pd
from core.database import get_connection

def manage_students():
    st.subheader("Manage Students")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM students")
    students = cursor.fetchall()
    if students:
        df = pd.DataFrame(students)
        st.dataframe(df)
    else:
        st.info("No students found.")
    
    st.markdown("### Add New Student")
    firstname = st.text_input("First Name", key="student_firstname")
    lastname = st.text_input("Last Name", key="student_lastname")
    email = st.text_input("Email", key="student_email")
    if st.button("Add Student"):
        query = """INSERT INTO students (firstname, lastname, email)
                   VALUES (%s, %s, %s)"""
        cursor.execute(query, (firstname, lastname, email))
        conn.commit()
        st.success("Student added!")
        st.experimental_rerun()
    
    st.markdown("### Delete Student")
    if students:
        student_ids = [student['studentid'] for student in students]
        delete_id = st.selectbox("Select Student ID to Delete", student_ids, key="del_student")
        if st.button("Delete Student"):
            cursor.execute("DELETE FROM students WHERE studentid=%s", (delete_id,))
            conn.commit()
            st.success("Student deleted!")
            st.experimental_rerun()
    
    cursor.close()
    conn.close()
