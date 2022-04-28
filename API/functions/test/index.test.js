
const test = require('firebase-functions-test')();

// Mock functions config values
test.mockConfig({ messaging: { key: '23wr42ewr34' }});


// If index.js calls admin.initializeApp at the top of the file,
// we need to stub it out before requiring index.js. This is because the
// functions will be executed as a part of the require process.
// Here we stub admin.initializeApp to be a dummy function that doesn't do anything.
const adminInitStub = sinon.stub(admin, 'initializeApp');
// Now we can require index.js and save the exports inside a namespace called messaging_api.
const messaging_api = require('../index.js');


//Test getUsers endpoint
const getUsersWrapped = test.wrap(messaging_api.getUsers);

// A fake request object, with req.query.text set to 'input'
const req = { query: {} };

// A fake response object, with a stubbed redirect function which asserts that it is called
// with parameters 303, 'new_ref'.
const res = {
    redirect: (code, url) => {
        assert.equal(code, 303);
        assert.equal(url, 'new_ref');
        done();
      }
};

// Invoke addMessage with our fake request and response objects. This will cause the
// assertions in the response object to be evaluated.
messaging_api.messaging_api.getUsers(req, res);


test.cleanup();