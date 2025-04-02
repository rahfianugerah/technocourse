# crud_courses.py
import streamlit as st
import pandas as pd
from core.database import get_connection

def manage_courses():
    st.subheader("Manage Courses")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Display current courses
    cursor.execute("SELECT * FROM courses")
    courses = cursor.fetchall()
    if courses:
        df = pd.DataFrame(courses)
        st.dataframe(df)
    else:
        st.info("No courses found.")
    
    st.markdown("### Add New Course")
    title = st.text_input("Title", key="course_title")
    instructorid = st.number_input("Instructor ID", min_value=0, step=1, key="course_instructorid")
    description = st.text_area("Description", key="course_description")
    category = st.text_input("Category", key="course_category")
    price = st.number_input("Price", min_value=0.0, step=0.01, key="course_price")
    capacity = st.number_input("Capacity", min_value=0, step=1, key="course_capacity")
    start_date = st.text_input("Start Date (YYYY-MM-DD HH:MM:SS)", key="course_start_date")
    end_date = st.text_input("End Date (YYYY-MM-DD HH:MM:SS)", key="course_end_date")
    if st.button("Add Course"):
        query = """INSERT INTO courses 
                   (instructorid, title, description, category, price, capacity, start_date, end_date)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
        cursor.execute(query, (instructorid, title, description, category, price, capacity, start_date, end_date))
        conn.commit()
        st.success("Course added!")
        st.experimental_rerun()
    
    st.markdown("### Delete Course")
    if courses:
        course_ids = [course['courseid'] for course in courses]
        delete_id = st.selectbox("Select Course ID to Delete", course_ids, key="del_course")
        if st.button("Delete Course"):
            cursor.execute("DELETE FROM courses WHERE courseid=%s", (delete_id,))
            conn.commit()
            st.success("Course deleted!")
            st.experimental_rerun()
    
    cursor.close()
    conn.close()
