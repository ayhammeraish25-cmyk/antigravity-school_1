import { Request, Response } from "express";
import prisma from "../lib/prisma";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";

// Register user
export const register = async (req: Request, res: Response) => {
  try {
    const { fullName, dob, username, email, password } = req.body;
    const nationalId = req.body.national_id || req.body.nationalId;

    if (!nationalId || !password || !fullName || !username) {
      return res.status(400).json({
        message: "Required fields are missing",
      });
    }

    const existingUser = await prisma.user.findFirst({
      where: {
        OR: [
          { nationalId: nationalId },
          { username },
          { email }
        ]
      },
    });

    if (existingUser) {
      return res.status(400).json({
        message: "User with this National ID, Username, or Email already exists",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        nationalId: nationalId,
        fullName,
        username,
        dob,
        email,
        password: hashedPassword,
      },
    });

    return res.status(201).json({
      message: "User created successfully",
      user,
    });
  } catch (error) {
    console.error("Register error:", error);
    return res.status(500).json({ message: "Server error" });
  }
};

// Login user
export const login = async (req: Request, res: Response) => {
  try {
    const nationalId = req.body.national_id || req.body.nationalId;
    const { password } = req.body;

    if (!nationalId || !password) {
      return res.status(400).json({
        message: "National ID and password are required",
      });
    }

    const user = await prisma.user.findUnique({
      where: { nationalId: nationalId },
    });

    if (!user) {
      return res.status(401).json({ error: "User not found" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: "Incorrect password" });
    }

    const token = jwt.sign(
      { id: user.id, nationalId: user.nationalId, role: user.role },
      process.env.JWT_SECRET || 'fallback_secret',
      { expiresIn: '8h' }
    );

    return res.json({
      message: "Login successful",
      token,
      user: {
        name: user.fullName
      },
    });
  } catch (error) {
    console.error("Login error:", error);
    return res.status(500).json({ message: "Server error" });
  }
};
