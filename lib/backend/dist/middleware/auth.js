import jwt from "jsonwebtoken";
const auth = async (req, res, next) => {
    try {
        const token = req.header("x-auth-token");
        if (!token)
            return res.status(401).json({ msg: 'No auth token,access denied.' });
        const verified = jwt.verify(token, "passwordKey");
        if (!verified)
            return res.status(401).json({ msg: 'Token verfication failed' });
        req.user = verified.indexOf;
        req.token = token;
        next();
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
};
export default auth;
//# sourceMappingURL=auth.js.map