import React from 'react';
import './App.scss';

import {
  HashRouter,
  Routes,
  Route,
  Navigate,
} from 'react-router-dom';

import CampK12 from './containers/CampK12';
import Navbar from './containers/Navbar';
import Login from './containers/Login/Login';
import SignUp from './containers/SignUp';

function App() {
  return (
    <HashRouter>
      <Navbar />
      <Routes>
        <Route path="/online-courses" element={<CampK12 />} />
        <Route path="/offline-camp" element={<h1>WIP</h1>} />
        <Route path="/refer-n-earn" element={<h1>WIP</h1>} />
        <Route path="/Login" element={<Login />} /> 
        <Route path="/SignUp" element={<SignUp />} />
        <Route path="/" element={<Navigate to="/online-courses" />} />
      </Routes>
    </HashRouter>
  );
}

export default App;
