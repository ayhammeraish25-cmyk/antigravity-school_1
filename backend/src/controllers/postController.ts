import { Response } from 'express';
import { PostType, Role } from '@prisma/client';
import  prisma  from '../lib/prisma';
import { AuthRequest } from '../middleware/auth';

/**
 * Create a new educational post
 * Rule: Only teachers can upload long educational videos
 */
export const createPost = async (req: AuthRequest, res: Response) => {
  try {
    const { title, content, mediaUrl, type } = req.body;
    const user = req.user!;

    // Validate required fields
    if (!content || !type) {
      return res.status(400).json({
        error: 'Content and type are required'
      });
    }

    // Validate PostType
    if (!Object.values(PostType).includes(type)) {
      return res.status(400).json({
        error: 'Invalid post type'
      });
    }

    // Teachers only for video
    if (type === PostType.VIDEO && user.role !== Role.TEACHER) {
      return res.status(403).json({
        error: 'Only teachers can upload educational videos'
      });
    }

    // Story expiration (24h)
    const expiresAt =
      type === PostType.STORY
        ? new Date(Date.now() + 24 * 60 * 60 * 1000)
        : null;

    const post = await prisma.post.create({
      data: {
        title,
        content,
        mediaUrl,
        type,
        authorId: user.id,
        expiresAt
      }
    });

    return res.status(201).json(post);

  } catch (error) {
    console.error('Create Post Error:', error);
    return res.status(500).json({
      error: 'Failed to create post'
    });
  }
};

/**
 * Get educational feed
 * Stories expire automatically
 */
export const getFeed = async (req: AuthRequest, res: Response) => {
  try {
    const posts = await prisma.post.findMany({
      where: {
        OR: [
          { expiresAt: null },
          { expiresAt: { gt: new Date() } }
        ]
      },
      orderBy: {
        createdAt: 'desc'
      },
      include: {
        author: {
          select: {
            fullName: true,
            role: true,
            school: true
          }
        },
        _count: {
          select: {
            comments: true
          }
        }
      }
    });

    return res.status(200).json(posts);

  } catch (error) {
    console.error('Get Feed Error:', error);
    return res.status(500).json({
      error: 'Failed to fetch feed'
    });
  }
};