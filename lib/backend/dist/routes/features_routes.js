import { Router } from "express";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import { verifyToken } from "../utils/token_manager.js";
import { readPdf, talkWithPdfContent, createPdf, scanImageText, editImageText, } from "../controllers/feature_controllers.js"; // Import the controllers
import multer from "multer";
// Calculate __dirname from import.meta.url
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
// File upload setup using Multer
const upload = multer({ dest: join(__dirname, "..", "uploads") }); // Destination folder for uploaded files
const featuresRoutes = Router();
// PDF Routes
featuresRoutes.post("/pdf/r", verifyToken, upload.single("pdf"), readPdf); // Route for reading PDF
featuresRoutes.post("/pdf/t", verifyToken, talkWithPdfContent); // Route for interacting with PDF content
featuresRoutes.post("/pdf/c", verifyToken, createPdf); // Route for generating a PDF
// Image Routes
featuresRoutes.post("/image/s", verifyToken, upload.single("image"), scanImageText); // Route for scanning image text
featuresRoutes.post("/image/e", verifyToken, upload.single("image"), editImageText); // Route for editing image text
export default featuresRoutes;
//# sourceMappingURL=features_routes.js.map