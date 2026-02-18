exports.handler = async (event) => {
    // On utilisera PostgreSQL avec hash bcrypt en production à la place de ces credentials simulés
    const validUsers = {
        'admin': { password: 'admin123', role: 'admin' },
        'user1': { password: 'user123', role: 'user' }
    };

    const headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*' // Allow all origins (CORS frontend)
    };

    console.log('Event received:', JSON.stringify(event, null, 2));
    
    try {
        // Parsing body request & destructuring
        const body = typeof event.body === 'string' 
            ? JSON.parse(event.body) 
            : event.body || {};
        const { username, password } = body;
        
        if (!username || !password) {
            return {
                statusCode: 400,
                headers: headers,
                body: JSON.stringify({
                    success: false,
                    message: 'Username and password required'
                })
            };
        }
        
        if (validUsers[username] && validUsers[username].password === password) {
            console.log(`Login successful: ${username} (${validUsers[username].role})`);
            return {
                statusCode: 200,
                headers: headers,
                body: JSON.stringify({
                    success: true,
                    message: 'Login successful',
                    user: {
                        username: username,
                        role: validUsers[username].role
                    }
                })
            };

        } else {
            console.log(`Login failed: ${username}`);
            return {
                statusCode: 401,
                headers: headers,
                body: JSON.stringify({
                    success: false,
                    message: 'Invalid credentials'
                })
            };
        }

    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            headers: headers,
            body: JSON.stringify({
                success: false,
                message: 'Server error'
            })
        };
    }
};
