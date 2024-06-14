import test from 'ava';
import {mockClient} from 'aws-sdk-client-mock';
import {GetParametersCommand, SSMClient} from "@aws-sdk/client-ssm";
import {handler, paramNames} from "../app.js";

const ssmMock = mockClient(SSMClient)

test.beforeEach(t => {
    ssmMock.reset()
});
test('handler() test', async t => {
    const mockParams = paramNames.Names.map(n => {
        return {Name: n, Value: `policy for ${n}`}
    })
    ssmMock.on(GetParametersCommand, paramNames)
        .resolves({Parameters: mockParams})

    const expectedCSP = mockParams.map(p => p.Value).join(' ')

    const event = {
        Records: [
            {
                cf: {
                    response: {
                        headers: {}
                    }
                }
            }
        ]
    }

    const modifiedResponse = await handler(event)


    t.is(modifiedResponse.headers['referrer-policy'][0].value, "same-origin");
    t.is(modifiedResponse.headers['content-security-policy'][0].value, expectedCSP);

});
