import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { COOKIE_NAME } from './constants.js';

export const createToken = (id: string, email: string, expiresIn: string) => {
  try {
    return jwt.sign({ id, email }, process.env.JWT_SECRET, { expiresIn });
  } catch (error) {
    console.error('Error creating token:', error);
    throw new Error('Token creation failed');
  }
};

export const verifyToken = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Check both cookie and Authorization header
    const token = req.signedCookies[COOKIE_NAME] || req.headers.authorization?.split(' ')[1];
    
    if (!token || token.trim() === '') {
      return res.status(401).json({ message: 'Token not received' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    res.locals.jwtData = decoded;
    next();
  } catch (error) {
    console.error('Error verifying token:', error);
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};
