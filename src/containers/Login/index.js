import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom"; // Untuk navigasi setelah login
import "./styles.scss";

const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate(); // Hook navigasi

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Email:", email, "Password:", password);
    // Tambahkan logika autentikasi di sini
    navigate("/online-courses"); // Redirect setelah login
  };

  useEffect(() => {
    document.title = "Login - CampK12"; // Mengubah title halaman
  }, []);

  return (
    <div className="login-container">
      <div className="login-card">
        <h2 className="login-title">Log In</h2>
        <form className="login-form" onSubmit={handleSubmit}>
          <div className="input-group">
            <label>Email</label>
            <input 
              type="email" 
              placeholder="Enter your email" 
              required 
              value={email} 
              onChange={(e) => setEmail(e.target.value)} 
            />
          </div>
          <div className="input-group">
            <label>Password</label>
            <input 
              type="password" 
              placeholder="Enter your password" 
              required 
              value={password} 
              onChange={(e) => setPassword(e.target.value)} 
            />
          </div>
          <button type="submit" className="login-button">Log In</button>
        </form>
        <p className="register-link">
          Don't have an account? <span onClick={() => navigate('/SignUp')}>Sign Up</span>
        </p>
      </div>
    </div>
  );
};

export default Login;
