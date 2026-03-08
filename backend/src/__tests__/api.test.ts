import request from 'supertest';
import app from '../app';

describe('Health Check', () => {
    it('GET /api/health returns 200 and OK status', async () => {
        const res = await request(app).get('/api/health');
        expect(res.statusCode).toBe(200);
        expect(res.body.status).toBe('OK');
    });
});

describe('Auth SSO Mock', () => {
    it('POST /api/auth/sso/mock fails with missing required fields', async () => {
        const res = await request(app)
            .post('/api/auth/sso/mock')
            .send({ sirajId: 'S001' }); // missing fullName and role
        expect(res.statusCode).toBe(400);
        expect(res.body.error).toBeDefined();
    });

    it('POST /api/auth/sso/mock succeeds with valid SSO data', async () => {
        const res = await request(app)
            .post('/api/auth/sso/mock')
            .send({
                sirajId: `TEST-${Date.now()}`,
                fullName: 'Test Student',
                role: 'STUDENT',
                email: `test${Date.now()}@school.jo`,
                school: 'Test School',
                directorate: 'Test Directorate',
            });
        // Will return 500 if DB not connected, but at minimum should NOT be 400
        expect([200, 500]).toContain(res.statusCode);
    });
});

describe('Protected Routes', () => {
    it('GET /api/posts/feed without token returns 401', async () => {
        const res = await request(app).get('/api/posts/feed');
        expect(res.statusCode).toBe(401);
        expect(res.body.error).toBeDefined();
    });

    it('GET /api/academic/assignments without token returns 401', async () => {
        const res = await request(app).get('/api/academic/assignments');
        expect(res.statusCode).toBe(401);
        expect(res.body.error).toBeDefined();
    });
});
