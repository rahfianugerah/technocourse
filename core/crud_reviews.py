import streamlit as st
import pandas as pd
from core.database import get_connection

def manage_reviews():
    st.subheader("Manage Reviews")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM reviews")
    reviews = cursor.fetchall()
    if reviews:
        df = pd.DataFrame(reviews)
        st.dataframe(df)
    else:
        st.info("No reviews found.")
    
    st.markdown("### Add New Review")
    courseid = st.number_input("Course ID", min_value=0, step=1, key="review_courseid")
    studentid = st.number_input("Student ID", min_value=0, step=1, key="review_studentid")
    rating = st.number_input("Rating (1-5)", min_value=1, max_value=5, step=1, key="review_rating")
    comment = st.text_area("Comment", key="review_comment")
    if st.button("Add Review"):
        query = """INSERT INTO reviews (courseid, studentid, rating, comment)
                   VALUES (%s, %s, %s, %s)"""
        cursor.execute(query, (courseid, studentid, rating, comment))
        conn.commit()
        st.success("Review added!")
        st.experimental_rerun()
    
    st.markdown("### Delete Review")
    if reviews:
        review_ids = [review['reviewid'] for review in reviews]
        delete_id = st.selectbox("Select Review ID to Delete", review_ids, key="del_review")
        if st.button("Delete Review"):
            cursor.execute("DELETE FROM reviews WHERE reviewid=%s", (delete_id,))
            conn.commit()
            st.success("Review deleted!")
            st.experimental_rerun()
    
    cursor.close()
    conn.close()
