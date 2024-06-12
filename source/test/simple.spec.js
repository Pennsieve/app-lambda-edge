const test = require('ava');
const app = require('../app')

test('paramNames test', t => {
    const names = app.paramNames.Names
    t.is(names.length, 8)
    for (const policy of app.policies) {
        t.true(names.includes(`/test/app-lambda/content-security-policy/${policy}`))
    }
});
