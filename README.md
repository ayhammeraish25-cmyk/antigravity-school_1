# سراج — Siraj Educational Social Learning Platform
### الهاشمية الأردنية | Hashemite Kingdom of Jordan

A secure, teacher-governed digital learning ecosystem integrated with the **Siraj Educational Platform** of the Jordanian Ministry of Education.

---

## 📁 Project Structure
```
Antigravith@school_11/
├── backend/          # Node.js + Express + TypeScript + Prisma 7 + PostgreSQL
└── frontend/         # Flutter (Android + iOS)
```

## 🚀 Getting Started

### Backend
```bash
cd backend

# Copy and configure environment
cp .env .env.local
# Edit DATABASE_URL in .env

# Run database migrations (requires PostgreSQL running)
npx prisma migrate dev --name init

# Start development server (port 8000)
npm run dev
```

### Frontend
```bash
cd frontend

# Run on connected device / emulator
flutter run
```

---

## 🔐 API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/auth/sso/mock` | None | Siraj SSO login mock |
| `POST` | `/api/posts/` | Required | Create post/story/video |
| `GET`  | `/api/posts/feed` | Required | Get educational feed |
| `POST` | `/api/academic/assignments` | Teacher | Create assignment |
| `GET`  | `/api/academic/assignments` | Required | List assignments |
| `POST` | `/api/academic/assignments/submit` | Student | Submit assignment |
| `POST` | `/api/academic/assignments/grade` | Teacher | Grade submission |
| `POST` | `/api/academic/quizzes` | Teacher | Create MCQ quiz |
| `GET`  | `/api/academic/quizzes` | Required | List quizzes |
| `GET`  | `/api/academic/quizzes/:id` | Required | Take quiz |

---

## 🧪 Running Tests
```bash
cd backend
npm test
```

---

## 🎨 Brand Identity

| Token | Value |
|-------|-------|
| Primary | `#0A2342` (Dark Blue) |
| Secondary | `#000000` (Black) |
| Background | `#FFFFFF` (White) |

---

## 🔒 Security

- JWT-based session tokens (8h expiry)
- Rate limiting: 100 req/15min (API), 10 req/15min (Auth)
- Input sanitization (XSS protection)
- RBAC: `STUDENT`, `TEACHER`, `ADMIN`
- TLS 1.3 in transit (infrastructure-level)
- AES-256 for storage (infrastructure-level)
