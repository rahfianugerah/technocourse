import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "./styles.scss";

const SignUp = () => {
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [gender, setGender] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  useEffect(() => {
    document.title = "Sign Up - CampK12";
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();

    // Validasi password & konfirmasi password
    if (password !== confirmPassword) {
      setError("Passwords do not match!");
      return;
    }

    // Simpan data pengguna atau kirim ke backend (simulasi)
    console.log({
      fullName,
      email,
      phone,
      gender,
      password
    });

    // Reset form setelah berhasil registrasi
    setFullName("");
    setEmail("");
    setPhone("");
    setPassword("");
    setConfirmPassword("");
    setGender("");
    setError("");

    // Redirect ke halaman login
    navigate("/login");
  };

  return (
    <div className="signup-container">
      <div className="signup-card">
        <h2 className="signup-title">Sign Up</h2>
        
        {error && <p className="error-message">{error}</p>}

        <form className="signup-form" onSubmit={handleSubmit}>
          <div className="input-group">
            <label>Full Name</label>
            <input 
              type="text" 
              placeholder="Enter your full name" 
              required 
              value={fullName}
              onChange={(e) => setFullName(e.target.value)}
            />
          </div>
          
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
            <label>Phone Number</label>
            <input 
              type="tel" 
              placeholder="Enter your phone number" 
              required 
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
          </div>

          <div className="input-group">
            <label>Gender</label>
            <select required value={gender} onChange={(e) => setGender(e.target.value)}>
              <option value="">Select gender</option>
              <option value="male">Male</option>
              <option value="female">Female</option>
              <option value="other">Other</option>
            </select>
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

          <div className="input-group">
            <label>Confirm Password</label>
            <input 
              type="password" 
              placeholder="Confirm your password" 
              required 
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
            />
          </div>

          <button type="submit" className="signup-button">Sign Up</button>
        </form>

        <p className="login-link">
          Already have an account? <span onClick={() => navigate('/login')}>Log In</span>
        </p>
      </div>
    </div>
  );
};

export default SignUp;
