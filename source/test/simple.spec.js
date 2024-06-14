import test from 'ava';
import {parseLambdaFunctionName, paramNames, policies, setHeaders} from '../app.js'

test('paramNames test', t => {
    const names = paramNames.Names
    t.is(names.length, 8)
    for (const policy of policies) {
        t.true(names.includes(`/test/xyz-app-lambda/content-security-policy/${policy}`))
    }
});

test('setHeaders() test', t => {
    const response = {'headers': {}};
    const contentSecurityPolicy = 'fake content security policy';
    const modifiedResponse = setHeaders(response, contentSecurityPolicy);

    t.is(modifiedResponse.headers['content-security-policy'][0].value, contentSecurityPolicy);
    t.is(modifiedResponse.headers['referrer-policy'][0].value, "same-origin");
});

test('parseLambdaFunctionName() test', t => {
    let parsed = parseLambdaFunctionName('not-a-region.test-xyz-edge-lambda-use1')
    t.deepEqual(parsed, {environmentName: 'test', uniqueId: 'xyz-'})

    parsed = parseLambdaFunctionName('not-a-region.test-edge-lambda-use1')
    t.deepEqual(parsed, {environmentName: 'test', uniqueId: ''})
});
