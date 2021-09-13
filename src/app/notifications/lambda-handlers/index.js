var aws = require("@aws-sdk/client-dynamodb");
var ses = new aws.SES({ region: "us-east-1" });

exports.handler = async function (email, quote) {
  var params = {
    Destination: {
      ToAddresses: [email],
    },
    Message: {
      Body: {
        Text: { Data: quote },
      },

      Subject: { Data: "Quote" },
    },
    Source: "sergei.krn@gmail.com",
  };

  return ses.sendEmail(params).promise()
};
