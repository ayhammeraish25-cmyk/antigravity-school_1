import 'dotenv/config';
import prisma from '../src/lib/prisma';
import bcrypt from 'bcrypt';

async function main() {

    const testNationalId = "1234567890";
    const testPassword = "123456";

    const hashedPassword = await bcrypt.hash(testPassword, 10);

    const existingUser = await prisma.user.findUnique({
        where: { nationalId: testNationalId }
    });

    if (!existingUser) {
        await prisma.user.create({
            data: {
                nationalId: testNationalId,
                password: hashedPassword,
                fullName: 'Test User',
                username: 'testuser',
                email: 'testuser@school.jo',
                dob: '2000-01-01',
                role: 'STUDENT',
            }
        });

        console.log(`Test user created
National ID: 1234567890
Password: 123456`);
    } else {
        console.log('Test user already exists.');
    }
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });