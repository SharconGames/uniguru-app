import './index.css';
import App from './App';
import { BrowserRouter } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { GuruProvider } from './context/GuruContext';
import { SocketProvider } from './context/socketProvider';
import axios from 'axios';
import ReactDOM from 'react-dom/client';
import React from 'react';

// Set axios defaults
axios.defaults.baseURL = 'http://localhost:8010/api/v1';
axios.defaults.withCredentials = true;

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <AuthProvider>
      <BrowserRouter>
        <GuruProvider>
          <SocketProvider>
            <App />
          </SocketProvider>
        </GuruProvider>
      </BrowserRouter>
    </AuthProvider>
  </React.StrictMode>
);
