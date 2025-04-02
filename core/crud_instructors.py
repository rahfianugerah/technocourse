# crud_instructors.py
import streamlit as st
import pandas as pd
from core.database import get_connection

def manage_instructors():
    st.subheader("Manage Instructors")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM instructors")
    instructors = cursor.fetchall()
    if instructors:
        df = pd.DataFrame(instructors)
        st.dataframe(df)
    else:
        st.info("No instructors found.")
    
    st.markdown("### Add New Instructor")
    firstname = st.text_input("First Name", key="instr_firstname")
    lastname = st.text_input("Last Name", key="instr_lastname")
    email = st.text_input("Email", key="instr_email")
    bio = st.text_area("Bio", key="instr_bio")
    if st.button("Add Instructor"):
        query = """INSERT INTO instructors (firstname, lastname, email, bio)
                   VALUES (%s, %s, %s, %s)"""
        cursor.execute(query, (firstname, lastname, email, bio))
        conn.commit()
        st.success("Instructor added!")
        st.experimental_rerun()
    
    st.markdown("### Delete Instructor")
    if instructors:
        instructor_ids = [instr['instructorid'] for instr in instructors]
        delete_id = st.selectbox("Select Instructor ID to Delete", instructor_ids, key="del_instructor")
        if st.button("Delete Instructor"):
            cursor.execute("DELETE FROM instructors WHERE instructorid=%s", (delete_id,))
            conn.commit()
            st.success("Instructor deleted!")
            st.experimental_rerun()
    
    cursor.close()
    conn.close()
