import { Router } from 'express';
import authRoutes from './auth.routes';
import postRoutes from './post.routes';
import academicRoutes from './academic.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/posts', postRoutes);
router.use('/academic', academicRoutes);

router.get('/', (req, res) => {
    res.json({ message: 'Welcome to the Educational Social Learning API' });
});

export default router;
