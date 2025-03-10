import React, { useState } from "react";
import axios from "axios";
import { toast } from "react-hot-toast";

type FormData = {
  name: string;
  email: string;
  password: string;
};

type SignupResponse = {
  message: string;
  status: number;
};

const Signupbox: React.FC = () => {
  const [formData, setFormData] = useState<FormData>({
    name: "",
    email: "",
    password: "",
  });

  const [error, setError] = useState<string | null>(null); // State to store error messages

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
    setError(null); // Clear error when user starts typing
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    try {
      toast.loading("Signing up...", { id: "signup" });
      setError(null); // Clear any existing error messages

      const response = await axios.post<SignupResponse>(
        "http://localhost:8000/api/v1/user/signup",
        formData
      );

      if (response.status === 201) {
        toast.success("Signup successful!", { id: "signup" });
      }
    } catch (error: unknown) {
      if (axios.isAxiosError(error)) {
        const errorMessage = error.response?.data?.message || "Signup failed. Try again.";
        setError(errorMessage); // Update the error state with the server message
        toast.error(errorMessage, { id: "signup" });
      } else {
        setError("An unexpected error occurred.");
        toast.error("An unexpected error occurred.", { id: "signup" });
      }
    }
  };

  return (
    <div className="absolute flex justify-center items-center transform -translate-x-1/2 -translate-y-1/2 w-[350px] p-5 bg-[linear-gradient(135deg,_#61ACEF,_#9987ED,_#B679E1,_#9791DB,_#74BDCC,_#59D2BF)] rounded-lg shadow-lg z-50 h-[350px] max-w-[350px] ">
      <form onSubmit={handleSubmit}>
        <label className="block text-left font-inder text-3xl text-black font-bold mb-4">
          Sign up
        </label>

        <div className="input-box">
          <input
            type="text"
            name="name"
            placeholder="Name"
            required
            value={formData.name}
            onChange={handleChange}
            className="w-full p-2 mb-4 border-none rounded-full focus:outline-none text-black"
          />
        </div>

        <div className="input-box">
          <input
            type="email"
            name="email"
            placeholder="Email"
            required
            value={formData.email}
            onChange={handleChange}
            className="w-full p-2 mb-4 border-none rounded-full focus:outline-none text-black"
          />
        </div>

        <div className="input-box">
          <input
            type="password"
            name="password"
            placeholder="Password"
            required
            value={formData.password}
            onChange={handleChange}
            className="w-full p-2 mb-4 border-none rounded-full focus:outline-none text-black"
          />
        </div>

        {/* Display error message if it exists */}
        {error && <p className="text-red-500 text-sm mt-2">{error}</p>}

        <button
          type="submit"
          className="w-full p-3 bg-white text-black border border-solid rounded-lg cursor-pointer mb-4"
        >
          Sign up
        </button>
      </form>
    </div>
  );
};

export default Signupbox;
