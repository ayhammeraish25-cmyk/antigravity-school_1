import { Request, Response, NextFunction } from 'express';

/**
 * Input sanitization middleware.
 * SOP: Security framework - protect against injection attacks.
 * Strips common XSS patterns from request body strings.
 */
export const sanitizeInput = (req: Request, _res: Response, next: NextFunction) => {
    const sanitizeValue = (val: unknown): unknown => {
        if (typeof val === 'string') {
            return val
                .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
                .replace(/javascript:/gi, '')
                .trim();
        }
        if (typeof val === 'object' && val !== null) {
            return sanitizeObject(val as Record<string, unknown>);
        }
        return val;
    };

    const sanitizeObject = (obj: Record<string, unknown>): Record<string, unknown> => {
        const result: Record<string, unknown> = {};
        for (const key of Object.keys(obj)) {
            result[key] = sanitizeValue(obj[key]);
        }
        return result;
    };

    if (req.body && typeof req.body === 'object') {
        req.body = sanitizeObject(req.body as Record<string, unknown>);
    }

    next();
};
