# crud_payments.py
import streamlit as st
import pandas as pd
from core.database import get_connection

def manage_payments():
    st.subheader("Manage Payments")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM payments")
    payments = cursor.fetchall()
    if payments:
        df = pd.DataFrame(payments)
        st.dataframe(df)
    else:
        st.info("No payments found.")
    
    st.markdown("### Add New Payment")
    enrollmentid = st.number_input("Enrollment ID", min_value=0, step=1, key="payment_enrollmentid")
    amount = st.number_input("Amount", min_value=0.0, step=0.01, key="payment_amount")
    payment_method = st.text_input("Payment Method", key="payment_method")
    payment_status = st.text_input("Payment Status", key="payment_status")
    if st.button("Add Payment"):
        query = """INSERT INTO payments (enrollmentid, amount, payment_method, payment_status)
                   VALUES (%s, %s, %s, %s)"""
        cursor.execute(query, (enrollmentid, amount, payment_method, payment_status))
        conn.commit()
        st.success("Payment added!")
        st.experimental_rerun()
    
    st.markdown("### Delete Payment")
    if payments:
        payment_ids = [payment['paymentid'] for payment in payments]
        delete_id = st.selectbox("Select Payment ID to Delete", payment_ids, key="del_payment")
        if st.button("Delete Payment"):
            cursor.execute("DELETE FROM payments WHERE paymentid=%s", (delete_id,))
            conn.commit()
            st.success("Payment deleted!")
            st.experimental_rerun()
    
    cursor.close()
    conn.close()
