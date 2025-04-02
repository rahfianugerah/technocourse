import streamlit as st
from core.database import create_users_table
from core.auth import register_user, login_user
from core.crud import manage_courses, manage_enrollments, manage_instructors, manage_payments, manage_reviews, manage_students
from core.visualizations import show_visualizations

# Initialize session state keys immediately if not set
if "logged_in" not in st.session_state:
    st.session_state["logged_in"] = False
if "username" not in st.session_state:
    st.session_state["username"] = ""

def login_view():
    st.subheader("Login")
    username = st.text_input("Username", key="username_input")
    password = st.text_input("Password", type="password", key="password_input")
    if st.button("Login"):
        user = login_user(username, password)
        if user:
            st.session_state["logged_in"] = True
            st.session_state["username"] = username
            st.success("Logged in successfully!")
        else:
            st.error("Invalid credentials")

def register_view():
    st.subheader("Register")
    username = st.text_input("Username", key="reg_username")
    email = st.text_input("Email", key="reg_email")
    password = st.text_input("Password", type="password", key="reg_password")
    if st.button("Register"):
        register_user(username, password, email)
        st.success("Registration successful! You can now log in.")

def dashboard():
    st.sidebar.image("assets/technocourse-logo.png", use_container_width=False)

    # Sidebar for navigation (without a separate Visualizations option)
    st.sidebar.title(f"Welcome, {st.session_state['username']} 👋")
    pages = [
        "🏠 Home", 
        "📚 Manage Courses", 
        "📝 Manage Enrollments",
        "👩‍🏫 Manage Instructors", 
        "💳 Manage Payments", 
        "⭐ Manage Reviews", 
        "🎓 Manage Students"
    ]
    choice = st.sidebar.radio("Navigation", pages)
    
    # Main content area based on choice
    if choice == "🏠 Home":
        st.subheader("Dashboard Home")
        if st.button("Logout"):
            st.session_state["logged_in"] = False
            st.session_state["username"] = ""
            st.success("Logged out successfully!")
        st.write("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        # Call the visualizations here so they appear on the home page
        from core.visualizations import show_visualizations  # Import if not already imported
        show_visualizations()
        # Logout button placed on the Home page

    elif choice == "📚 Manage Courses":
        manage_courses()
    elif choice == "📝 Manage Enrollments":
        manage_enrollments()
    elif choice == "👩‍🏫 Manage Instructors":
        manage_instructors()
    elif choice == "💳 Manage Payments":
        manage_payments()
    elif choice == "⭐ Manage Reviews":
        manage_reviews()
    elif choice == "🎓 Manage Students":
        manage_students()

def main():
    st.markdown("<h1><span style='color: purple;'>Techno</span>course.com Management System</h1>", unsafe_allow_html=True)
    st.image("assets/technocourse-bg.png", use_container_width=False)
    create_users_table()  # Ensure the users table exists

    # Render dashboard if logged in, otherwise show login/register tabs.
    if st.session_state["logged_in"]:
        dashboard()
    else:
        # Use tabs for separate Login and Register forms
        tab1, tab2 = st.tabs(["Login", "Register"])
        with tab1:
            login_view()
        with tab2:
            register_view()

if __name__ == "__main__":
    main()