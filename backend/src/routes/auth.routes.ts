import { Router } from 'express';
import { register, login } from '../controllers/authController';

const router = Router();

// Endpoint simulating the callback from Siraj Platform SSO
router.post("/login", login);
router.post("/register", register);

export default router;
