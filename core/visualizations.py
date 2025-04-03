# visualizations.py
import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from core.database import get_connection
from textblob import TextBlob
import numpy as np
from sklearn.linear_model import LinearRegression
from datetime import timedelta

def show_visualizations():
    conn = get_connection()
    
    # 1. Courses per Category
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
    
    # 2. Enrollments per Course
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
    
    # 3. Enrollments Over Time (Time Series)
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
            labels={"enrollments": "Number of Enrollments", "date": "Date"},
            template="plotly_white"
        )
        st.plotly_chart(fig3, use_container_width=True)
    else:
        st.info("No data available for enrollments over time.")
    
    # 4. Review Sentiment Analysis (Time Series)
    query4 = "SELECT review_date, comment FROM reviews"
    df_reviews = pd.read_sql(query4, conn)
    st.markdown("#### Average Review Sentiment Over Time")
    if not df_reviews.empty:
        # Compute sentiment polarity using TextBlob
        df_reviews['sentiment'] = df_reviews['comment'].apply(lambda x: TextBlob(x).sentiment.polarity)
        df_reviews['review_date'] = pd.to_datetime(df_reviews['review_date'])
        df_reviews_sorted = df_reviews.sort_values('review_date')
        # Calculate average sentiment per day
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
    
    # 5. Enrollment Forecast (Predict 7 Days Ahead)
    st.markdown("#### Enrollment Forecast for Next 7 Days")
    if not df_enrollment_ts.empty:
        df_enrollment_ts = df_enrollment_ts.sort_values('date')
        # Convert dates to numerical values (ordinal)
        df_enrollment_ts['date_ordinal'] = df_enrollment_ts['date'].apply(lambda x: x.toordinal())
        X = df_enrollment_ts[['date_ordinal']]
        y = df_enrollment_ts['enrollments']
        
        # Train a linear regression model
        model = LinearRegression()
        model.fit(X, y)
        
        # Predict enrollments for the next 7 days
        last_date = df_enrollment_ts['date'].max()
        future_dates = [last_date + timedelta(days=i) for i in range(1, 8)]
        future_ordinals = np.array([d.toordinal() for d in future_dates]).reshape(-1, 1)
        predictions = model.predict(future_ordinals)
        
        # DataFrame for predictions
        df_future = pd.DataFrame({
            'date': future_dates,
            'predicted_enrollments': predictions
        })
        
        # Combine actual data with predictions
        df_actual = df_enrollment_ts[['date', 'enrollments']]
        fig5 = go.Figure()
        fig5.add_trace(go.Scatter(x=df_actual['date'], y=df_actual['enrollments'],
                                  mode='lines+markers',
                                  name='Actual'))
        fig5.add_trace(go.Scatter(x=df_future['date'], y=df_future['predicted_enrollments'],
                                  mode='lines+markers',
                                  name='Forecast'))
        fig5.update_layout(
            title="Enrollment Forecast for Next 7 Days",
            xaxis_title="Date",
            yaxis_title="Number of Enrollments",
            template="plotly_white"
        )
        st.plotly_chart(fig5, use_container_width=True)
    else:
        st.info("No data available for enrollment forecasting.")
    
    # 6. Pie Chart for Payment Method Distribution
    query6 = "SELECT payment_method, COUNT(*) as count FROM payments GROUP BY payment_method"
    df_payments = pd.read_sql(query6, conn)
    st.markdown("#### Payment Method Distribution")
    if not df_payments.empty:
        fig6 = px.pie(
            df_payments,
            values="count",
            names="payment_method",
            title="Payment Method Distribution",
            template="plotly_white"
        )
        st.plotly_chart(fig6, use_container_width=True)
    else:
        st.info("No data available for payment methods.")
    
    # 7. Histogram of Review Ratings
    query7 = "SELECT rating FROM reviews"
    df_rating = pd.read_sql(query7, conn)
    st.markdown("#### Review Ratings Distribution")
    if not df_rating.empty:
        fig7 = px.histogram(
            df_rating,
            x="rating",
            nbins=5,
            title="Review Ratings Distribution",
            labels={"rating": "Rating"},
            template="plotly_white"
        )
        st.plotly_chart(fig7, use_container_width=True)
    else:
        st.info("No review ratings data available.")
    
    # 8. Scatter Plot of Course Price vs. Capacity
    query8 = "SELECT price, capacity FROM courses"
    df_courses = pd.read_sql(query8, conn)
    st.markdown("#### Course Price vs. Capacity")
    if not df_courses.empty:
        fig8 = px.scatter(
            df_courses,
            x="price",
            y="capacity",
            title="Course Price vs. Capacity",
            labels={"price": "Course Price", "capacity": "Capacity"},
            template="plotly_white"
        )
        st.plotly_chart(fig8, use_container_width=True)
    else:
        st.info("No data available for Course Price vs. Capacity.")
    
    conn.close()
