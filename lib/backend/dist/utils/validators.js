import { body, param, validationResult } from "express-validator";
import { isValidObjectId } from "mongoose"; // To validate MongoDB ObjectId
// General validation utility function
export const validate = (validations) => {
    return async (req, res, next) => {
        for (let validation of validations) {
            const result = await validation.run(req);
            if (!result.isEmpty()) {
                break;
            }
        }
        const errors = validationResult(req);
        if (errors.isEmpty()) {
            return next();
        }
        return res.status(422).json({ errors: errors.array() });
    };
};
// Login validation
export const loginValidator = [
    body("email").trim().isEmail().withMessage("Email is required"),
    body("password")
        .trim()
        .isLength({ min: 6 })
        .withMessage("Password should contain at least 6 characters"),
];
// Signup validation
export const signupValidator = [
    body("name").notEmpty().withMessage("Name is required"),
    ...loginValidator,
];
// Chat completion validation (for messages)
export const chatCompletionValidator = [
    body("message").notEmpty().withMessage("Message is required"),
];
// Chat ID validation
export const chatIdValidator = [
    param("chatId")
        .custom((value) => isValidObjectId(value))
        .withMessage("Invalid chat ID"),
];
// User ID validation
export const userIdValidator = [
    body("userId")
        .custom((value) => isValidObjectId(value))
        .withMessage("Invalid user ID"),
];
//# sourceMappingURL=validators.js.map