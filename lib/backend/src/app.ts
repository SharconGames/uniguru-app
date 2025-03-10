import express from "express";
import { config } from "dotenv";
import appRouter from "./routes/index.js";
import cookieParser from "cookie-parser";
import cors from "cors";
import router from "./routes/auth_Google_routes.js";
import passportUtil from "./utils/passportjs.js";

config();
const app = express();

// Middleware
app.use(express.json()); // Add this for parsing JSON bodies
app.use(express.urlencoded({ extended: true })); // Add this for parsing URL-encoded bodies
app.use(cookieParser(process.env.COOKIE_SECRET));
app.use(cors({ origin: "*", credentials: true }));

// Passport configuration
passportUtil(app);

// Routes
app.use("/api/v1", appRouter); // General app routes
app.use("/auth", router);      // Google auth routes

export default app;
