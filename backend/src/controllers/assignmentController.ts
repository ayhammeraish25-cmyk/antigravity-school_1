import { Response } from 'express';
import prisma from '../lib/prisma';
import { Role } from "@prisma/client";
import { AuthRequest } from '../middleware/auth';

/**
 * Create a new assignment (Teacher only).
 */
export const createAssignment = async (req: AuthRequest, res: Response) => {
    try {
        const user = req.user!;

        if (user.role !== Role.TEACHER) {
            return res.status(403).json({ error: 'Only teachers can create assignments' });
        }

        const { title, description, dueDate } = req.body;

        const assignment = await prisma.assignment.create({
            data: {
                title,
                description,
                dueDate: new Date(dueDate),
                teacherId: user.id,
            },
        });

        res.status(201).json(assignment);

    } catch (error) {
        console.error('Create Assignment Error:', error);
        res.status(500).json({ error: 'Failed to create assignment' });
    }
};

/**
 * Submit an assignment (Student only).
 */
export const submitAssignment = async (req: AuthRequest, res: Response) => {
    try {
        const user = req.user!;

        if (user.role !== Role.STUDENT) {
            return res.status(403).json({ error: 'Only students can submit assignments' });
        }

        const { assignmentId, content } = req.body;

        const submission = await prisma.submission.create({
            data: {
                content,
                studentId: user.id,
                assignmentId,
            },
        });

        res.status(201).json(submission);

    } catch (error) {
        console.error('Submit Assignment Error:', error);
        res.status(500).json({ error: 'Failed to submit assignment' });
    }
};

/**
 * Grade a submission (Teacher only).
 */
export const gradeSubmission = async (req: AuthRequest, res: Response) => {
    try {
        const user = req.user!;

        if (user.role !== Role.TEACHER) {
            return res.status(403).json({ error: 'Only teachers can grade submissions' });
        }

        const { submissionId, grade, feedback } = req.body;

        const updated = await prisma.submission.update({
            where: { id: submissionId },
            data: {
                grade,
                feedback
            },
        });

        res.status(200).json(updated);

    } catch (error) {
        console.error('Grade Submission Error:', error);
        res.status(500).json({ error: 'Failed to grade submission' });
    }
};

/**
 * Get assignments list.
 */
export const getAssignments = async (req: AuthRequest, res: Response) => {
    try {

        const assignments = await prisma.assignment.findMany({
            orderBy: { dueDate: 'asc' },
            include: {
                teacher: {
                    select: { fullName: true }
                },
                _count: {
                    select: { submissions: true }
                }
            }
        });

        res.status(200).json(assignments);

    } catch (error) {
        console.error('Get Assignments Error:', error);
        res.status(500).json({ error: 'Failed to fetch assignments' });
    }
};