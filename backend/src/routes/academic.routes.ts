import { Router } from 'express';
import { createAssignment, submitAssignment, gradeSubmission, getAssignments } from '../controllers/assignmentController';
import { createQuiz, getQuizzes, getQuizById } from '../controllers/quizController';
import { requireAuth } from '../middleware/auth';

const router = Router();

// All academic routes require authentication
router.use(requireAuth);

// Assignment endpoints
router.post('/assignments', createAssignment);
router.get('/assignments', getAssignments);
router.post('/assignments/submit', submitAssignment);
router.post('/assignments/grade', gradeSubmission);

// Quiz endpoints
router.post('/quizzes', createQuiz);
router.get('/quizzes', getQuizzes);
router.get('/quizzes/:id', getQuizById);

export default router;
