// Convert require statements to import statements
import https from 'https';
import querystring from 'querystring';
import crypto from 'crypto'; 

// Environment variables for the Lambda function
const LARAVEL_BACKEND_ENDPOINT = 'https://cognitotest.free.beeceptor.com';
const LARAVEL_BACKEND_API_KEY = '';

export async function handler(event) {


    return new Promise((resolve, reject) => {
   
        let ChallengeResult;

        event.request.challengeName="CUSTOM_CHALLENGE";
        event.request.session= ChallengeResult;
        event.response.publicChallengeParameters = {
            answer: 'one'
        };
        resolve(event);
    });
};
