import https from 'https';

// Helper function to make an HTTPS GET request
function verifyTokenWithAPI(token, username) {
    return new Promise((resolve, reject) => {
        const url = `https://api.staging.comp.accept/verify-token?token=${encodeURIComponent(token)}&username=${encodeURIComponent(username)}`;

        https.get(url, (res) => {
            let data = '';

            // A chunk of data has been received.
            res.on('data', (chunk) => {
                data += chunk;
            });

            // The whole response has been received. Print out the result.
            res.on('end', () => {
                resolve(JSON.parse(data));
            });
        }).on('error', (err) => {
            reject(err);
        });
    });
}

export async function handler(event) {
    let userProvidedToken;
    let username;

    try {
        // Parse the JSON string to extract token and username
        const challengeResponse = JSON.parse(event.request.challengeAnswer);
        userProvidedToken = challengeResponse.token;
        username = challengeResponse.username;
        
        // Verify the token and username with your external API
        const verificationResult = await verifyTokenWithAPI(userProvidedToken, username);
       
        
        if (verificationResult.success) {
            // If the API verifies the token as valid, allow the authentication
            event.response.answerCorrect = true;
        } else {
            // If the token is invalid or expired, reject the authentication
            event.response.answerCorrect = false;
        }
    } catch (error) {
        console.error('Error verifying token with API:', error);
        // Consider how you want to handle errors. This example treats them as failed verifications.
        event.response.answerCorrect = false;
    }

    return event;
}
