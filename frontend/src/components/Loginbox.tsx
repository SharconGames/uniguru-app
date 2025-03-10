import React, { useState } from "react";
import { useNavigate } from "react-router-dom"; // Import the hook for navigation
import { useAuth } from "../context/AuthContext"; // Import the useAuth hook

interface LoginboxProps {
  onLoginSuccess: () => void;
}

const Loginbox: React.FC<LoginboxProps> = ({ onLoginSuccess }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate(); // Initialize the navigation hook
  const { login } = useAuth(); // Use the login function from the context

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
  
    try {
      console.log(email)
      const { navigateUrl } = await login(email, password);
      onLoginSuccess();
      navigate(navigateUrl || "/");
    } catch (err) {
      setError("Invalid username or password. Please try again.");
    }
  };
  

  return (
    <div
      className="absolute flex justify-center items-center transform -translate-x-1/2 -translate-y-1/2 w-[350px] p-5 rounded-lg shadow-lg z-50 h-[350px] max-w-[350px]"
      style={{
        background:
          "linear-gradient(135deg, rgba(97, 172, 239, 0.75), rgba(153, 135, 237, 0.75), rgba(182, 121, 225, 0.75), rgba(151, 145, 219, 0.75), rgba(116, 189, 204, 0.75), rgba(89, 210, 191, 0.75))",
      }}
    >
      <form className="flex flex-col w-full" onSubmit={handleSubmit}>
        <label className="text-left font-bold text-black text-[5vh] cursor-pointer transition-colors duration-500 ease-in-out mb-4">
          Login
        </label>
        <div className="mb-4">
          <input
            type="text"
            placeholder="Username"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full p-2 border-none rounded-full outline-none text-black"
            required
          />
        </div>
        <div className="mb-4">
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full p-2 border-none rounded-full outline-none text-black"
            required
          />
        </div>
        <button
          type="submit"
          className="w-full py-2 bg-white text-black rounded-lg font-semibold cursor-pointer hover:bg-gray-100 transition"
        >
          Login
        </button>
        {error && <p className="text-red-500 text-sm mt-2">{error}</p>}
      </form>
    </div>
  );
};

export default Loginbox;