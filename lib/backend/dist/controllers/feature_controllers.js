import { createWorker } from 'tesseract.js';
import fs from 'fs';
import sharp from 'sharp';
import path from 'path';
import pdfParse from 'pdf-parse';
import PDFDocument from 'pdfkit';
import Groq from 'groq-sdk';
// PDF-related functionalities
export const readPdf = async (req, res, next) => {
    try {
        const file = req.file;
        if (!file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }
        const data = await pdfParse(file.buffer);
        const extractedText = data.text;
        const pdfPath = path.join(__dirname, 'uploads', file.originalname);
        fs.writeFileSync(pdfPath, file.buffer);
        res.json({
            message: 'PDF content successfully processed',
            extractedText,
            pdfUrl: `/uploads/${file.originalname}` // URL for the saved PDF
        });
    }
    catch (error) {
        console.error('Error reading PDF:', error);
        res.status(500).json({ error: 'Error reading PDF' });
    }
};
export const talkWithPdfContent = async (req, res, next) => {
    try {
        const extractedText = req.body.extractedText;
        const userMessage = req.body.message;
        const configGroq = new Groq({ apiKey: process.env.GROQ_API_KEY });
        const chatResponse = await configGroq.chat.completions.create({
            messages: [
                {
                    role: "system",
                    content: `You are an assistant with the following information: ${extractedText}`
                },
                {
                    role: "user",
                    content: userMessage
                }
            ],
            model: "llama3-8b-8192",
            max_tokens: 1000,
            temperature: 0.7,
        });
        return res.status(200).json({
            message: "Response from PDF content",
            response: chatResponse.choices[0]?.message?.content
        });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
export const createPdf = async (req, res, next) => {
    try {
        const { title, content } = req.body;
        const doc = new PDFDocument();
        const filePath = path.join(__dirname, '..', 'output.pdf');
        doc.pipe(fs.createWriteStream(filePath));
        doc.fontSize(25).text(title, { align: 'center' });
        doc.moveDown().fontSize(14).text(content);
        doc.end();
        return res.status(200).json({ message: "PDF created successfully", file: filePath });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
// Function to scan and extract text from an image using Tesseract.js
export const scanImageText = async (req, res, next) => {
    try {
        const filePath = req.file.path; // Path of the uploaded image
        const worker = createWorker();
        // Start the worker and perform OCR on the image
        await (await worker).load(); // Load the tesseract worker
        await (await worker).recognize(filePath); // Perform OCR directly
        // Perform OCR and extract text from the image
        const { data } = await (await worker).recognize(filePath); // Perform OCR
        await (await worker).terminate(); // Terminate the worker after use
        // Return the extracted text
        return res.status(200).json({
            message: "Text extracted from image",
            text: data.text // Extracted text from the image
        });
    }
    catch (error) {
        console.error(error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
// Function to edit image text using Sharp
export const editImageText = async (req, res, next) => {
    try {
        const filePath = req.file.path; // Path of the uploaded image
        if (!fs.existsSync(filePath)) {
            throw new Error(`File not found: ${filePath}`);
        }
        const newText = req.body.text; // Text to overlay on the image
        const image = sharp(filePath);
        const metadata = await image.metadata();
        const textOverlay = Buffer.from(`<svg width="${metadata.width}" height="${metadata.height}">
                <text x="50" y="50" font-size="30" fill="white">${newText}</text>
             </svg>`);
        const outputFilePath = path.join(__dirname, '..', 'edited-image.png');
        await image
            .composite([{ input: textOverlay, gravity: 'northwest' }])
            .toFile(outputFilePath);
        return res.status(200).json({
            message: "Image edited successfully",
            file: outputFilePath // Return the file path of the edited image
        });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: "ERROR", cause: error.message });
    }
};
//# sourceMappingURL=feature_controllers.js.map