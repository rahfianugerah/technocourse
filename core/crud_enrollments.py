# crud_enrollments.py
import streamlit as st
import pandas as pd
from core.database import get_connection

def manage_enrollments():
    st.subheader("Manage Enrollments")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM enrollments")
    enrollments = cursor.fetchall()
    if enrollments:
        df = pd.DataFrame(enrollments)
        st.dataframe(df)
    else:
        st.info("No enrollments found.")
    
    st.markdown("### Add New Enrollment")
    studentid = st.number_input("Student ID", min_value=0, step=1, key="enroll_studentid")
    courseid = st.number_input("Course ID", min_value=0, step=1, key="enroll_courseid")
    payment_status = st.text_input("Payment Status", key="enroll_payment_status")
    if st.button("Add Enrollment"):
        query = """INSERT INTO enrollments (studentid, courseid, payment_status)
                   VALUES (%s, %s, %s)"""
        cursor.execute(query, (studentid, courseid, payment_status))
        conn.commit()
        st.success("Enrollment added!")
        st.experimental_rerun()
    
    st.markdown("### Delete Enrollment")
    if enrollments:
        enrollment_ids = [enroll['enrollmentid'] for enroll in enrollments]
        delete_id = st.selectbox("Select Enrollment ID to Delete", enrollment_ids, key="del_enrollment")
        if st.button("Delete Enrollment"):
            cursor.execute("DELETE FROM enrollments WHERE enrollmentid=%s", (delete_id,))
            conn.commit()
            st.success("Enrollment deleted!")
            st.experimental_rerun()
    
    cursor.close()
    conn.close()