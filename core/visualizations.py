# visualizations.py
import streamlit as st
import pandas as pd
import plotly.express as px
from core.database import get_connection
from textblob import TextBlob

def show_visualizations():
    conn = get_connection()
    
    # Visualization 1: Courses per Category
    query1 = "SELECT category, COUNT(*) as count FROM courses GROUP BY category"
    df_cat = pd.read_sql(query1, conn)
    st.markdown("#### Courses per Category")
    if not df_cat.empty:
        fig1 = px.bar(
            df_cat,
            x="category",
            y="count",
            title="Courses per Category",
            labels={"count": "Number of Courses", "category": "Category"},
            template="plotly_white"
        )
        st.plotly_chart(fig1, use_container_width=True)
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
        fig2 = px.bar(
            df_enroll,
            x="title",
            y="enrollments",
            title="Enrollments per Course",
            labels={"enrollments": "Enrollments", "title": "Course Title"},
            template="plotly_white"
        )
        st.plotly_chart(fig2, use_container_width=True)
    else:
        st.info("No data available for Enrollments per Course.")
    
    # Visualization 3: Enrollments Over Time (Time Series)
    query3 = """
        SELECT DATE(enrollment_date) as date, COUNT(*) as enrollments 
        FROM enrollments 
        GROUP BY DATE(enrollment_date) 
        ORDER BY date
    """
    df_enrollment_ts = pd.read_sql(query3, conn)
    st.markdown("#### Enrollments Over Time")
    if not df_enrollment_ts.empty:
        df_enrollment_ts['date'] = pd.to_datetime(df_enrollment_ts['date'])
        fig3 = px.line(
            df_enrollment_ts,
            x="date",
            y="enrollments",
            title="Enrollments Over Time",
            labels={"enrollments": "Enrollments", "date": "Date"},
            template="plotly_white"
        )
        st.plotly_chart(fig3, use_container_width=True)
    else:
        st.info("No data available for enrollments over time.")
    
    # Visualization 4: Review Sentiment Analysis (Time Series)
    query4 = "SELECT review_date, comment FROM reviews"
    df_reviews = pd.read_sql(query4, conn)
    st.markdown("#### Average Review Sentiment Over Time")
    if not df_reviews.empty:
        # Compute sentiment polarity for each review using TextBlob
        df_reviews['sentiment'] = df_reviews['comment'].apply(lambda x: TextBlob(x).sentiment.polarity)
        df_reviews['review_date'] = pd.to_datetime(df_reviews['review_date'])
        df_reviews_sorted = df_reviews.sort_values('review_date')
        # Aggregate average sentiment by day
        sentiment_ts = df_reviews_sorted.groupby(df_reviews_sorted['review_date'].dt.date)['sentiment'].mean().reset_index()
        sentiment_ts['review_date'] = pd.to_datetime(sentiment_ts['review_date'])
        fig4 = px.line(
            sentiment_ts,
            x="review_date",
            y="sentiment",
            title="Average Review Sentiment Over Time",
            labels={"sentiment": "Average Sentiment", "review_date": "Date"},
            template="plotly_white"
        )
        st.plotly_chart(fig4, use_container_width=True)
    else:
        st.info("No review data available for sentiment analysis.")
    
    conn.close()
