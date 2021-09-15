var aws = require("aws-sdk");
var ses = new aws.SES({ region: "us-east-1" });

exports.handler = async function (email, quote) {
  var params = {
    Destination: {
      ToAddresses: [email],
    },
    Message: {
      Body: {
        Text: { Data: JSON.stringify(quote) },
      },

      Subject: { Data: "Quote" },
    },
    Source: "sergei.krn@gmail.com",
  };

  return ses.sendEmail(params).promise()
};
