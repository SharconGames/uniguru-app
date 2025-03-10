import nodemailer from 'nodemailer';
const transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});
/**
 * Sends a password reset email to the user
 * @param to - recipient email address
 * @param resetToken - password reset token
 */
export const sendResetPasswordEmail = async (to, resetToken) => {
    const resetLink = `${process.env.FRONTEND_URL}/reset-password?token=${resetToken}`;
    const mailOptions = {
        from: process.env.EMAIL_USER,
        to,
        subject: 'Password Reset Request',
        text: `Click the following link to reset your password: ${resetLink}`,
        html: `<p>Click the following link to reset your password:</p>
           <a href="${resetLink}">${resetLink}</a>`,
    };
    try {
        await transporter.sendMail(mailOptions);
        console.log('Password reset email sent successfully');
    }
    catch (error) {
        console.error('Error sending password reset email:', error);
        throw new Error('Error sending email');
    }
};
//# sourceMappingURL=email_service.js.map