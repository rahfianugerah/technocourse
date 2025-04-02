# visualizations.py
import streamlit as st
import pandas as pd
from core.database import get_connection

def show_visualizations():
    conn = get_connection()
    
    # Visualization 1: Courses per Category
    query1 = "SELECT category, COUNT(*) as count FROM courses GROUP BY category"
    df_cat = pd.read_sql(query1, conn)
    st.markdown("#### Courses per Category")
    if not df_cat.empty:
        st.bar_chart(df_cat.set_index("category"))
    else:
        st.info("No data available for Courses per Category.")
    
    # Visualization 2: Enrollments per Course
    query2 = """
        SELECT c.title, COUNT(e.enrollmentid) as enrollments 
        FROM courses c 
        LEFT JOIN enrollments e ON c.courseid = e.courseid 
        GROUP BY c.title
    """
    df_enroll = pd.read_sql(query2, conn)
    st.markdown("#### Enrollments per Course")
    if not df_enroll.empty:
        st.bar_chart(df_enroll.set_index("title"))
    else:
        st.info("No data available for Enrollments per Course.")
    
    conn.close()
