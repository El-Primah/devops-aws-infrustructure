console.log('Loading function');

const signUpTemplate = (email, codeParameter) => `
<!DOCTYPE html>
`;

const forgotPasswordTemplate = (email, codeParameter) => `
<!DOCTYPE html>
`;

exports.handler = (event, context, callback) => {
  const signUpTriggers = [
      "CustomMessage_SignUp", 
      "CustomMessage_AdminCreateUser", 
      "CustomMessage_ResendCode", 
      "CustomMessage_UpdateUserAttribute", 
      "CustomMessage_VerifyUserAttribute", 
      "CustomMessage_Authentication"
  ];

  if (event.triggerSource === "CustomMessage_ForgotPassword") {
      event.response.emailMessage = forgotPasswordTemplate(event.request.userAttributes.email, event.request.codeParameter);
  } else if (signUpTriggers.includes(event.triggerSource)) {
      event.response.emailMessage = signUpTemplate(event.request.userAttributes.email, event.request.codeParameter);
  }

  callback(null, event);
};
