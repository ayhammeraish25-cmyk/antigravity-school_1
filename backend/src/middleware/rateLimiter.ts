import rateLimit from 'express-rate-limit';

/**
 * General API rate limiter per SOP security requirements.
 * Protects against brute-force and DoS attacks.
 */
export const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100,
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: 'Too many requests, please try again later.' },
});

/**
 * Strict limiter for auth endpoints to prevent brute-force attacks.
 * SOP: Multi-Factor Authentication + strong password policy.
 */
export const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 10,
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: 'Too many login attempts, please try again in 15 minutes.' },
});
