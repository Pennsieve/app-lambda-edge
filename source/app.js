'use strict';

var AWS = require('aws-sdk');
var ssm = new AWS.SSM({region: 'us-east-1'});

// Parse the environment name from the lambda function name: us-east-1.dev-app-lambda-use1
var environmentName = process.env.AWS_LAMBDA_FUNCTION_NAME.split(".")[1].split("-")[0];

// If lambda name contains a uniq-id, get it. Eg. us-east-1.dev-edc-app-lambda-use1
if (process.env.AWS_LAMBDA_FUNCTION_NAME.split(".")[1].split("-").length == 5) {
  var uniqId = process.env.AWS_LAMBDA_FUNCTION_NAME.split(".")[1].split("-")[1] + "-";
} else {
  var uniqId = "";
};

var paramName = '/' + environmentName + '/' + uniqId + 'app-lambda/content-security-policy';

const policies = ['script', 'style' ,'worker', 'img', 'font', 'media', 'frame', 'connect']

var paramNames = {
    Names: policies.map(p => paramName + '/' + p)
};

// only exported for use in test
exports.paramNames = paramNames
exports.policies = policies

function setHeaders(event, contentSecurityPolicy, callback) {
    // if no response, just short circuit
    const records = event && event.Records && event.Records[0];
    const response = records && records.cf && records.cf.response;

    if (!response || event && event['detail-type'] == 'Scheduled Event') {
        return;
    }

    const headers = response.headers;

    headers['strict-transport-security'] = [{key:'Strict-Transport-Security', value: "max-age=31536000; includeSubdomains; preload"}];
    headers['x-frame-options']           = [{key:'X-Frame-Options', value:"DENY"}];
    headers['x-xss-protection']          = [{key:'X-XSS-Protection', value:"1; mode=block"}];
    headers['referrer-policy']           = [{key:'Referrer-Policy', value:"same-origin"}];
    headers['content-security-policy']   = [{key: 'Content-Security-Policy', value: contentSecurityPolicy}];

    callback(null, response);
};

exports.handler = (event, context, callback) => {
    ssm.getParameters(paramNames, function(err, data) {
        if (err) {
            console.log(err, err.stack);
        } else if (data.InvalidParameters && data.InvalidParameters.length > 0) {
            console.log("invalid parameters", data.InvalidParameters)
        } else {
           var contentSecurityPolicy = data.Parameters.map(p => p.Value).join(' ')
           setHeaders(event, contentSecurityPolicy, callback);
        }
    })
};
