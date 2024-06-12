import test from 'ava';
import {paramNames, policies, setHeaders} from '../app.js'

test('paramNames test', t => {
    const names = paramNames.Names
    t.is(names.length, 8)
    for (const policy of policies) {
        t.true(names.includes(`/test/app-lambda/content-security-policy/${policy}`))
    }
});

test('setHeaders() test', t => {
    const response = {'headers': {}};
    const contentSecurityPolicy = 'fake content security policy';
    const modifiedResponse = setHeaders(response, contentSecurityPolicy);

    t.is(modifiedResponse.headers['content-security-policy'][0].value, contentSecurityPolicy);
    t.is(modifiedResponse.headers['referrer-policy'][0].value, "same-origin");
});
