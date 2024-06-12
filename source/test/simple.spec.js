import test from 'ava';
import {paramNames} from "../app";

test('paramNames length test', t => {
    t.is(paramNames.Names.length, 8)
});
