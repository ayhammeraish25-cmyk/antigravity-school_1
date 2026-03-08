import { Response } from "express";
import { Role } from "@prisma/client";
import prisma from "../lib/prisma";
import { AuthRequest } from "../middleware/auth";

/**
 * Create a new quiz (Teacher only)
 */
export const createQuiz = async (req: AuthRequest, res: Response) => {
  try {
    const user = req.user;

    if (!user || user.role !== Role.TEACHER) {
      return res.status(403).json({
        error: "Only teachers can create quizzes",
      });
    }

    const { title, questions } = req.body;

    if (!title || !questions || questions.length === 0) {
      return res.status(400).json({
        error: "Title and questions are required",
      });
    }

    const quiz = await prisma.quiz.create({
      data: {
        title,
        teacherId: user.id,
        questions: {
          create: questions.map((q: any) => ({
            text: q.text,
            options: q.options,
            correctAnswer: q.correctAnswer,
          })),
        },
      },
      include: {
        questions: true,
      },
    });

    res.status(201).json({
      message: "Quiz created successfully",
      quiz,
    });
  } catch (error) {
    console.error("Create Quiz Error:", error);
    res.status(500).json({
      error: "Failed to create quiz",
    });
  }
};

/**
 * Get all quizzes
 */
export const getQuizzes = async (req: AuthRequest, res: Response) => {
  try {
    const quizzes = await prisma.quiz.findMany({
      orderBy: {
        createdAt: "desc",
      },
      include: {
        teacher: {
          select: {
            fullName: true,
          },
        },
        _count: {
          select: {
            questions: true,
          },
        },
      },
    });

    res.status(200).json(quizzes);
  } catch (error) {
    console.error("Get Quizzes Error:", error);
    res.status(500).json({
      error: "Failed to fetch quizzes",
    });
  }
};

/**
 * Get quiz by ID
 */
export const getQuizById = async (req: AuthRequest, res: Response) => {
  try {
    const id = req.params.id as string;

    const quiz = await prisma.quiz.findUnique({
      where: {
        id,
      },
      include: {
        questions: {
          select: {
            id: true,
            text: true,
            options: true,
          },
        },
      },
    });

    if (!quiz) {
      return res.status(404).json({
        error: "Quiz not found",
      });
    }

    res.status(200).json(quiz);
  } catch (error) {
    console.error("Get Quiz Error:", error);
    res.status(500).json({
      error: "Failed to fetch quiz",
    });
  }
};