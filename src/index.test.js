const { describe, it } = require('node:test');
const assert = require('node:assert');
const { greet } = require('./index.js');
describe('greet', () => {
  it('works', () => assert.equal(greet('insights'), 'Hello, insights'));
});
