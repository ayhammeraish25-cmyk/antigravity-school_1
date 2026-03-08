async function testLogin() {
    try {
        const res = await fetch('http://127.0.0.1:8000/api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                national_id: '1234567890',
                password: '123456'
            })
        });
        const data = await res.json();
        console.log("Status:", res.status);
        console.log("Response:", JSON.stringify(data, null, 2));
    } catch (err) {
        console.error("Fetch error:", err);
    }
}
testLogin();
