// types.d.ts
import { Request } from "express";

// Extend the Request interface to include 'file'
export interface MulterRequest extends Request {
    file?: Express.Multer.File; // Optional, since file might not be present in every request
}
