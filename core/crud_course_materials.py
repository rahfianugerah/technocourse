# crud_course_materials.py
import streamlit as st
import pandas as pd
from core.database import get_connection

def manage_course_materials():
    st.subheader("Manage Course Materials")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM course_materials")
    materials = cursor.fetchall()
    if materials:
        df = pd.DataFrame(materials)
        st.dataframe(df)
    else:
        st.info("No course materials found.")
    
    st.markdown("### Add New Material")
    courseid = st.number_input("Course ID", min_value=0, step=1, key="material_courseid")
    title = st.text_input("Title", key="material_title")
    content_url = st.text_input("Content URL", key="material_url")
    material_type = st.text_input("Material Type (pdf, video, quiz)", key="material_type")
    if st.button("Add Material"):
        query = """INSERT INTO course_materials (courseid, title, content_url, material_type)
                   VALUES (%s, %s, %s, %s)"""
        cursor.execute(query, (courseid, title, content_url, material_type))
        conn.commit()
        st.success("Material added!")
        st.experimental_rerun()
    
    st.markdown("### Delete Material")
    if materials:
        material_ids = [material['materialid'] for material in materials]
        delete_id = st.selectbox("Select Material ID to Delete", material_ids, key="del_material")
        if st.button("Delete Material"):
            cursor.execute("DELETE FROM course_materials WHERE materialid=%s", (delete_id,))
            conn.commit()
            st.success("Material deleted!")
            st.experimental_rerun()
    
    cursor.close()
    conn.close()
