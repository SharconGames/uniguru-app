import { Router } from "express";
import {
    getAllUsers,
    userLogin,
    userLogout,
    userSignup,
    verifyUser,
} from "../controllers/user_controllers.js";
import {
    loginValidator,
    signupValidator,
    validate,
} from "../utils/validators.js";
import { verifyToken } from "../utils/token_manager.js";

const userRoutes = Router();



userRoutes.get("/", getAllUsers);
userRoutes.post("/signup", validate(signupValidator), userSignup);
userRoutes.post("/login", validate(loginValidator), userLogin);
userRoutes.get("/auth-status", verifyToken, verifyUser);
// In user_routes.ts
userRoutes.post("/logout", verifyToken, userLogout); // Change from GET to POST
export default userRoutes;