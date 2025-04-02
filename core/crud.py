# crud.py
import streamlit as st
import pandas as pd
import datetime
from core.database import get_connection

# ---------------------------
# Manage Students
# ---------------------------
def manage_students():
    st.subheader("Manage Students")
    
    data_placeholder = st.empty()
    
    def show_students():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM students")
        students = cursor.fetchall()
        cursor.close()
        conn.close()
        data_placeholder.empty()
        if students:
            df = pd.DataFrame(students)
            data_placeholder.dataframe(df)
        else:
            data_placeholder.info("No students found.")
    
    show_students()
    
    if st.button("Refresh Students", key="refresh_students"):
        show_students()
    
    st.markdown("### Add New Student")
    firstname = st.text_input("First Name", key="student_firstname")
    lastname = st.text_input("Last Name", key="student_lastname")
    email = st.text_input("Email", key="student_email")
    if st.button("Add Student"):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = "INSERT INTO students (firstname, lastname, email) VALUES (%s, %s, %s)"
        cursor.execute(query, (firstname, lastname, email))
        conn.commit()
        cursor.close()
        conn.close()
        st.success("Student added!")
        show_students()
    
    st.markdown("### Update Student")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM students")
    student_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if student_list:
        student_options = {f"{stu['studentid']}: {stu['firstname']} {stu['lastname']}": stu for stu in student_list}
        selected_student_str = st.selectbox("Select Student to Update", list(student_options.keys()), key="update_student_select")
        selected_student = student_options[selected_student_str]
        new_firstname = st.text_input("New First Name", value=selected_student['firstname'], key="update_student_firstname")
        new_lastname = st.text_input("New Last Name", value=selected_student['lastname'], key="update_student_lastname")
        new_email = st.text_input("New Email", value=selected_student['email'], key="update_student_email")
        if st.button("Update Student"):
            conn = get_connection()
            cursor = conn.cursor()
            update_query = "UPDATE students SET firstname=%s, lastname=%s, email=%s WHERE studentid=%s"
            cursor.execute(update_query, (new_firstname, new_lastname, new_email, selected_student['studentid']))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Student updated!")
            show_students()
    else:
        st.info("No students available for update.")
    
    st.markdown("### Delete Student")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM students")
    student_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if student_list:
        student_ids = [stu['studentid'] for stu in student_list]
        delete_id = st.selectbox("Select Student ID to Delete", student_ids, key="del_student")
        if st.button("Delete Student"):
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM students WHERE studentid=%s", (delete_id,))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Student deleted!")
            show_students()

# ---------------------------
# Manage Payments
# ---------------------------
def manage_payments():
    st.subheader("Manage Payments")
    
    data_placeholder = st.empty()
    
    def show_payments():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM payments")
        payments = cursor.fetchall()
        cursor.close()
        conn.close()
        data_placeholder.empty()
        if payments:
            df = pd.DataFrame(payments)
            data_placeholder.dataframe(df)
        else:
            data_placeholder.info("No payments found.")
    
    show_payments()
    
    if st.button("Refresh Payments", key="refresh_payments"):
        show_payments()
    
    st.markdown("### Add New Payment")
    enrollmentid = st.number_input("Enrollment ID", min_value=0, step=1, key="payment_enrollmentid")
    amount = st.number_input("Amount", min_value=0.0, step=0.01, key="payment_amount")
    payment_method = st.text_input("Payment Method", key="payment_method")
    payment_status = st.selectbox("Payment Status", ["Completed", "Not Completed"], key="payment_status")
    if st.button("Add Payment"):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = "INSERT INTO payments (enrollmentid, amount, payment_method, payment_status) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (enrollmentid, amount, payment_method, payment_status))
        conn.commit()
        cursor.close()
        conn.close()
        st.success("Payment added!")
        show_payments()
    
    st.markdown("### Update Payment")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM payments")
    payment_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if payment_list:
        payment_options = {f"{pay['paymentid']}: Enrollment {pay['enrollmentid']}": pay for pay in payment_list}
        selected_payment_str = st.selectbox("Select Payment to Update", list(payment_options.keys()), key="update_payment_select")
        selected_payment = payment_options[selected_payment_str]
        new_enrollmentid = st.number_input("New Enrollment ID", value=selected_payment['enrollmentid'], key="update_payment_enrollmentid")
        new_amount = st.number_input("New Amount", value=selected_payment['amount'], min_value=0.0, step=0.01, key="update_payment_amount")
        new_payment_method = st.text_input("New Payment Method", value=selected_payment['payment_method'], key="update_payment_method")
        new_payment_status = st.selectbox("New Payment Status", ["Completed", "Not Completed"], index=["Completed", "Not Completed"].index(selected_payment['payment_status']), key="update_payment_status")
        if st.button("Update Payment"):
            conn = get_connection()
            cursor = conn.cursor()
            update_query = "UPDATE payments SET enrollmentid=%s, amount=%s, payment_method=%s, payment_status=%s WHERE paymentid=%s"
            cursor.execute(update_query, (new_enrollmentid, new_amount, new_payment_method, new_payment_status, selected_payment['paymentid']))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Payment updated!")
            show_payments()
    else:
        st.info("No payments available for update.")
    
    st.markdown("### Delete Payment")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM payments")
    payment_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if payment_list:
        payment_ids = [pay['paymentid'] for pay in payment_list]
        delete_id = st.selectbox("Select Payment ID to Delete", payment_ids, key="del_payment")
        if st.button("Delete Payment"):
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM payments WHERE paymentid=%s", (delete_id,))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Payment deleted!")
            show_payments()

# ---------------------------
# Manage Reviews
# ---------------------------
def manage_reviews():
    st.subheader("Manage Reviews")
    
    data_placeholder = st.empty()
    
    def show_reviews():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM reviews")
        reviews = cursor.fetchall()
        cursor.close()
        conn.close()
        data_placeholder.empty()
        if reviews:
            df = pd.DataFrame(reviews)
            data_placeholder.dataframe(df)
        else:
            data_placeholder.info("No reviews found.")
    
    show_reviews()
    
    if st.button("Refresh Reviews", key="refresh_reviews"):
        show_reviews()
    
    st.markdown("### Add New Review")
    courseid = st.number_input("Course ID", min_value=0, step=1, key="review_courseid")
    studentid = st.number_input("Student ID", min_value=0, step=1, key="review_studentid")
    rating = st.number_input("Rating (1-5)", min_value=1, max_value=5, step=1, key="review_rating")
    comment = st.text_area("Comment", key="review_comment")
    if st.button("Add Review"):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = "INSERT INTO reviews (courseid, studentid, rating, comment) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (courseid, studentid, rating, comment))
        conn.commit()
        cursor.close()
        conn.close()
        st.success("Review added!")
        show_reviews()
    
    st.markdown("### Update Review")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM reviews")
    review_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if review_list:
        review_options = {f"{rev['reviewid']}: Course {rev['courseid']}, Student {rev['studentid']}": rev for rev in review_list}
        selected_review_str = st.selectbox("Select Review to Update", list(review_options.keys()), key="update_review_select")
        selected_review = review_options[selected_review_str]
        new_courseid = st.number_input("New Course ID", value=selected_review['courseid'], key="update_review_courseid")
        new_studentid = st.number_input("New Student ID", value=selected_review['studentid'], key="update_review_studentid")
        new_rating = st.number_input("New Rating (1-5)", value=selected_review['rating'], min_value=1, max_value=5, step=1, key="update_review_rating")
        new_comment = st.text_area("New Comment", value=selected_review['comment'], key="update_review_comment")
        if st.button("Update Review"):
            conn = get_connection()
            cursor = conn.cursor()
            update_query = "UPDATE reviews SET courseid=%s, studentid=%s, rating=%s, comment=%s WHERE reviewid=%s"
            cursor.execute(update_query, (new_courseid, new_studentid, new_rating, new_comment, selected_review['reviewid']))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Review updated!")
            show_reviews()
    else:
        st.info("No reviews available for update.")
    
    st.markdown("### Delete Review")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM reviews")
    review_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if review_list:
        review_ids = [rev['reviewid'] for rev in review_list]
        delete_id = st.selectbox("Select Review ID to Delete", review_ids, key="del_review")
        if st.button("Delete Review"):
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM reviews WHERE reviewid=%s", (delete_id,))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Review deleted!")
            show_reviews()

# ---------------------------
# Manage Instructors
# ---------------------------
def manage_instructors():
    st.subheader("Manage Instructors")
    
    data_placeholder = st.empty()
    
    def show_instructors():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM instructors")
        instructors = cursor.fetchall()
        cursor.close()
        conn.close()
        data_placeholder.empty()
        if instructors:
            df = pd.DataFrame(instructors)
            data_placeholder.dataframe(df)
        else:
            data_placeholder.info("No instructors found.")
    
    show_instructors()
    
    if st.button("Refresh Instructors", key="refresh_instructors"):
        show_instructors()
    
    st.markdown("### Add New Instructor")
    firstname = st.text_input("First Name", key="instr_firstname")
    lastname = st.text_input("Last Name", key="instr_lastname")
    email = st.text_input("Email", key="instr_email")
    bio = st.text_area("Bio", key="instr_bio")
    if st.button("Add Instructor"):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = "INSERT INTO instructors (firstname, lastname, email, bio) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (firstname, lastname, email, bio))
        conn.commit()
        cursor.close()
        conn.close()
        st.success("Instructor added!")
        show_instructors()
    
    st.markdown("### Update Instructor")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM instructors")
    instructor_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if instructor_list:
        instructor_options = {f"{inst['instructorid']}: {inst['firstname']} {inst['lastname']}": inst for inst in instructor_list}
        selected_inst_str = st.selectbox("Select Instructor to Update", list(instructor_options.keys()), key="update_inst_select")
        selected_inst = instructor_options[selected_inst_str]
        new_firstname = st.text_input("New First Name", value=selected_inst['firstname'], key="update_inst_firstname")
        new_lastname = st.text_input("New Last Name", value=selected_inst['lastname'], key="update_inst_lastname")
        new_email = st.text_input("New Email", value=selected_inst['email'], key="update_inst_email")
        new_bio = st.text_area("New Bio", value=selected_inst['bio'], key="update_inst_bio")
        if st.button("Update Instructor"):
            conn = get_connection()
            cursor = conn.cursor()
            update_query = "UPDATE instructors SET firstname=%s, lastname=%s, email=%s, bio=%s WHERE instructorid=%s"
            cursor.execute(update_query, (new_firstname, new_lastname, new_email, new_bio, selected_inst['instructorid']))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Instructor updated!")
            show_instructors()
    else:
        st.info("No instructors available for update.")
        
    st.markdown("### Delete Instructor")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM instructors")
    instructor_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if instructor_list:
        instructor_ids = [inst['instructorid'] for inst in instructor_list]
        delete_id = st.selectbox("Select Instructor ID to Delete", instructor_ids, key="del_instructor")
        if st.button("Delete Instructor"):
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM instructors WHERE instructorid=%s", (delete_id,))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Instructor deleted!")
            show_instructors()

# ---------------------------
# Manage Courses
# ---------------------------
def manage_courses():
    st.subheader("Manage Courses")
    
    data_placeholder = st.empty()
    def show_courses():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM courses")
        courses = cursor.fetchall()
        cursor.close()
        conn.close()
        data_placeholder.empty()
        if courses:
            df = pd.DataFrame(courses)
            data_placeholder.dataframe(df)
        else:
            data_placeholder.info("No courses found.")
    
    show_courses()
    if st.button("Refresh Courses", key="refresh_courses"):
        show_courses()
    
    st.markdown("### Add New Course")
    title = st.text_input("Title", key="course_title")
    
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT instructorid, firstname, lastname FROM instructors")
    instructors = cursor.fetchall()
    cursor.close()
    conn.close()
    if instructors:
        instructor_mapping = {
            f"{row['instructorid']}: {row['firstname']} {row['lastname']}": row['instructorid']
            for row in instructors
        }
        selected_instructor = st.selectbox("Instructor", list(instructor_mapping.keys()))
        instructorid = instructor_mapping[selected_instructor]
    else:
        st.error("No instructors available.")
        instructorid = 0
    
    description = st.text_area("Description", key="course_description")
    category = st.text_input("Category", key="course_category")
    price = st.number_input("Price", min_value=0.0, step=0.01, key="course_price")
    capacity = st.number_input("Capacity", min_value=0, step=1, key="course_capacity")
    
    st.markdown("#### Start Date and Time")
    start_date = st.date_input("Start Date", key="course_start_date")
    start_time = st.time_input("Start Time", key="course_start_time")
    start_datetime = datetime.datetime.combine(start_date, start_time)
    start_datetime_str = start_datetime.strftime("%Y-%m-%d %H:%M:%S")
    
    st.markdown("#### End Date and Time")
    end_date = st.date_input("End Date", key="course_end_date")
    end_time = st.time_input("End Time", key="course_end_time")
    end_datetime = datetime.datetime.combine(end_date, end_time)
    end_datetime_str = end_datetime.strftime("%Y-%m-%d %H:%M:%S")
    
    if st.button("Add Course"):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = """INSERT INTO courses 
                   (instructorid, title, description, category, price, capacity, start_date, end_date)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
        cursor.execute(query, (instructorid, title, description, category, price, capacity, start_datetime_str, end_datetime_str))
        conn.commit()
        cursor.close()
        conn.close()
        st.success("Course added!")
        show_courses()
    
    st.markdown("### Update Course")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM courses")
    course_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if course_list:
        course_options = {f"{course['courseid']}: {course['title']}": course for course in course_list}
        selected_course_str = st.selectbox("Select Course to Update", list(course_options.keys()), key="update_course_select")
        selected_course = course_options[selected_course_str]
        
        new_title = st.text_input("New Title", value=selected_course['title'], key="update_course_title")
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT instructorid, firstname, lastname FROM instructors")
        instructors = cursor.fetchall()
        cursor.close()
        conn.close()
        if instructors:
            instructor_mapping = {
                f"{row['instructorid']}: {row['firstname']} {row['lastname']}": row['instructorid']
                for row in instructors
            }
            new_instructor_str = st.selectbox("New Instructor", list(instructor_mapping.keys()), key="update_course_instructor")
            new_instructorid = instructor_mapping[new_instructor_str]
        else:
            st.error("No instructors available.")
            new_instructorid = selected_course['instructorid']
        
        new_description = st.text_area("New Description", value=selected_course['description'], key="update_course_description")
        new_category = st.text_input("New Category", value=selected_course['category'], key="update_course_category")
        # Convert Decimal to float for new_price
        new_price = st.number_input("New Price", value=float(selected_course['price']), min_value=0.0, step=0.01, key="update_course_price")
        new_capacity = st.number_input("New Capacity", value=selected_course['capacity'], min_value=0, step=1, key="update_course_capacity")
        
        st.markdown("#### New Start Date and Time")
        # Use .date() and .time() since the fields are datetime objects
        new_start_date = st.date_input("New Start Date", value=selected_course['start_date'].date(), key="update_course_start_date")
        new_start_time = st.time_input("New Start Time", value=selected_course['start_date'].time(), key="update_course_start_time")
        new_start_datetime = datetime.datetime.combine(new_start_date, new_start_time)
        new_start_datetime_str = new_start_datetime.strftime("%Y-%m-%d %H:%M:%S")
        
        st.markdown("#### New End Date and Time")
        new_end_date = st.date_input("New End Date", value=selected_course['end_date'].date(), key="update_course_end_date")
        new_end_time = st.time_input("New End Time", value=selected_course['end_date'].time(), key="update_course_end_time")
        new_end_datetime = datetime.datetime.combine(new_end_date, new_end_time)
        new_end_datetime_str = new_end_datetime.strftime("%Y-%m-%d %H:%M:%S")
        
        if st.button("Update Course"):
            conn = get_connection()
            cursor = conn.cursor()
            update_query = """UPDATE courses 
                              SET instructorid=%s, title=%s, description=%s, category=%s, price=%s, capacity=%s, start_date=%s, end_date=%s 
                              WHERE courseid=%s"""
            cursor.execute(update_query, (new_instructorid, new_title, new_description, new_category, new_price, new_capacity, new_start_datetime_str, new_end_datetime_str, selected_course['courseid']))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Course updated!")
            show_courses()
    else:
        st.info("No courses available for update.")
    
    st.markdown("### Delete Course")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM courses")
    course_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if course_list:
        course_ids = [course['courseid'] for course in course_list]
        delete_id = st.selectbox("Select Course ID to Delete", course_ids, key="del_course")
        if st.button("Delete Course"):
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM courses WHERE courseid=%s", (delete_id,))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Course deleted!")
            show_courses()

# ---------------------------
# Manage Enrollments
# ---------------------------
def manage_enrollments():
    st.subheader("Manage Enrollments")
    
    data_placeholder = st.empty()
    
    def show_enrollments():
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM enrollments")
        enrollments = cursor.fetchall()
        cursor.close()
        conn.close()
        data_placeholder.empty()
        if enrollments:
            df = pd.DataFrame(enrollments)
            data_placeholder.dataframe(df)
        else:
            data_placeholder.info("No enrollments found.")
    
    show_enrollments()
    if st.button("Refresh Enrollments", key="refresh_enrollments"):
        show_enrollments()
    
    st.markdown("### Add New Enrollment")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT studentid, firstname, lastname FROM students")
    students = cursor.fetchall()
    cursor.close()
    conn.close()
    if students:
        student_mapping = {
            f"{row['studentid']}: {row['firstname']} {row['lastname']}": row['studentid']
            for row in students
        }
        selected_student = st.selectbox("Student", list(student_mapping.keys()))
        studentid = student_mapping[selected_student]
    else:
        st.error("No students available.")
        studentid = 0
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT courseid, title FROM courses")
    courses = cursor.fetchall()
    cursor.close()
    conn.close()
    if courses:
        course_mapping = {
            f"{row['courseid']}: {row['title']}": row['courseid']
            for row in courses
        }
        selected_course = st.selectbox("Course", list(course_mapping.keys()))
        courseid = course_mapping[selected_course]
    else:
        st.error("No courses available.")
        courseid = 0
    payment_status = st.selectbox("Payment Status", ["Completed", "Not Completed"], key="enroll_payment_status")
    if st.button("Add Enrollment"):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        query = "INSERT INTO enrollments (studentid, courseid, payment_status) VALUES (%s, %s, %s)"
        cursor.execute(query, (studentid, courseid, payment_status))
        conn.commit()
        cursor.close()
        conn.close()
        st.success("Enrollment added!")
        show_enrollments()
    
    st.markdown("### Update Enrollment")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM enrollments")
    enrollment_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if enrollment_list:
        enrollment_options = {f"{enr['enrollmentid']}: Student {enr['studentid']}, Course {enr['courseid']}": enr for enr in enrollment_list}
        selected_enrollment_str = st.selectbox("Select Enrollment to Update", list(enrollment_options.keys()), key="update_enrollment_select")
        selected_enrollment = enrollment_options[selected_enrollment_str]
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT studentid, firstname, lastname FROM students")
        students = cursor.fetchall()
        cursor.close()
        conn.close()
        if students:
            student_mapping = {
                f"{row['studentid']}: {row['firstname']} {row['lastname']}": row['studentid']
                for row in students
            }
            new_student_str = st.selectbox("New Student", list(student_mapping.keys()), key="update_enrollment_student")
            new_studentid = student_mapping[new_student_str]
        else:
            new_studentid = selected_enrollment['studentid']
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT courseid, title FROM courses")
        courses = cursor.fetchall()
        cursor.close()
        conn.close()
        if courses:
            course_mapping = {
                f"{row['courseid']}: {row['title']}": row['courseid']
                for row in courses
            }
            new_course_str = st.selectbox("New Course", list(course_mapping.keys()), key="update_enrollment_course")
            new_courseid = course_mapping[new_course_str]
        else:
            new_courseid = selected_enrollment['courseid']
        new_payment_status = st.selectbox("New Payment Status", ["Completed", "Not Completed"], index=["Completed", "Not Completed"].index(selected_enrollment['payment_status']), key="update_enrollment_status")
        if st.button("Update Enrollment"):
            conn = get_connection()
            cursor = conn.cursor()
            update_query = "UPDATE enrollments SET studentid=%s, courseid=%s, payment_status=%s WHERE enrollmentid=%s"
            cursor.execute(update_query, (new_studentid, new_courseid, new_payment_status, selected_enrollment['enrollmentid']))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Enrollment updated!")
            show_enrollments()
    else:
        st.info("No enrollments available for update.")
        
    st.markdown("### Delete Enrollment")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM enrollments")
    enrollment_list = cursor.fetchall()
    cursor.close()
    conn.close()
    if enrollment_list:
        enrollment_ids = [enr['enrollmentid'] for enr in enrollment_list]
        delete_id = st.selectbox("Select Enrollment ID to Delete", enrollment_ids, key="del_enrollment")
        if st.button("Delete Enrollment"):
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM enrollments WHERE enrollmentid=%s", (delete_id,))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Enrollment deleted!")
            show_enrollments()

