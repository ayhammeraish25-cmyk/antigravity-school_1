import { Router } from 'express';
import { createPost, getFeed } from '../controllers/postController';
import { requireAuth } from '../middleware/auth';

const router = Router();

// All content routes require authentication via Siraj SSO
router.use(requireAuth);

router.post('/', createPost);
router.get('/feed', getFeed);

export default router;
