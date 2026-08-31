

export async function handler(event) {

    // Check if there is a session. The session is used to keep track of the state in the auth flow
    if (event.request.session && event.request.session.length) {
        // Get the last challenge in the session to determine the user's progress
        const lastChallenge = event.request.session[event.request.session.length - 1];
        
        // If the user successfully completed the previous challenge, issue tokens
        if (lastChallenge.challengeName === 'CUSTOM_CHALLENGE' && lastChallenge.challengeResult === true) {
            event.response.issueTokens = true;
            event.response.failAuthentication = false;
        } else {
            // If the previous challenge was not completed successfully, fail the authentication
            event.response.issueTokens = false;
            event.response.failAuthentication = true;
        }
    } else {
        // This is the start of a new auth session
        // Issue a custom challenge to initiate the passwordless auth flow
        event.response.issueTokens = false;
        event.response.failAuthentication = false;
        event.response.challengeName = 'CUSTOM_CHALLENGE';
    }

    // Return to Amazon Cognito
    return event;
}
