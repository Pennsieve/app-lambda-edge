'use strict';

import {SSMClient, GetParametersCommand} from "@aws-sdk/client-ssm";

const ssm = new SSMClient({
    region: 'us-east-1'
});

export function parseLambdaFunctionName(name) {
    // Parse the environment name from the lambda function name: us-east-1.dev-app-lambda-use1
    const splitFunctionName = name.split(".")[1].split("-")
    const environmentName = splitFunctionName[0];

    // If lambda name contains a uniq-id, get it. Eg. us-east-1.dev-edc-app-lambda-use1
    const uniqueId = splitFunctionName.length === 5 ? splitFunctionName[1] + "-" : ""
    return {environmentName, uniqueId}
}

const {environmentName, uniqueId} = parseLambdaFunctionName(process.env.AWS_LAMBDA_FUNCTION_NAME)

const paramName = '/' + environmentName + '/' + uniqueId + 'app-lambda/content-security-policy/';

// exported for testing
export const policies = ['script', 'style', 'worker', 'img', 'font', 'media', 'frame', 'connect']

// exported for testing
export const paramNames = {
    Names: policies.map(p => paramName + p)
};

const command = new GetParametersCommand(paramNames)

// exported for testing
export function setHeaders(response, contentSecurityPolicy) {
    const headers = response.headers;

    headers['strict-transport-security'] = [{
        key: 'Strict-Transport-Security',
        value: "max-age=31536000; includeSubdomains; preload"
    }];
    headers['x-frame-options'] = [{key: 'X-Frame-Options', value: "DENY"}];
    headers['x-xss-protection'] = [{key: 'X-XSS-Protection', value: "1; mode=block"}];
    headers['referrer-policy'] = [{key: 'Referrer-Policy', value: "same-origin"}];
    headers['content-security-policy'] = [{key: 'Content-Security-Policy', value: contentSecurityPolicy}];

    return response
};

export const handler = async (event, context) => {
    // if no response, just short circuit
    const records = event && event.Records && event.Records[0];
    const response = records && records.cf && records.cf.response;

    if (!response || event && event['detail-type'] == 'Scheduled Event') {
        return;
    }
    try {
        const parametersResponse = await ssm.send(command)
        if (parametersResponse.InvalidParameters && parametersResponse.InvalidParameters.length > 0) {
            console.log("invalid parameters", parametersResponse.InvalidParameters)
            return response
        } else {
            const contentSecurityPolicy = parametersResponse.Parameters.map(p => p.Value).join(' ')
            return setHeaders(response, contentSecurityPolicy);
        }
    } catch (err) {
        console.log(err, err.stack);
        return response
    }
};
