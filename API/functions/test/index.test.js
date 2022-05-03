import functions from "firebase-functions-test";
import jest from 'jest';
import * as admin from "firebase-admin";
import { messaging_api } from "../index.js";

const testEnv = functions();

/**
* mock setup
*/
const mockSet = jest.fn();



jest.mock("firebase-admin", () => ({
  initializeApp: jest.fn(),
  database: () => ({
    ref: jest.fn(path => ({
      set: mockSet
    }))
  })
}));

// mockSet.mockReturnValue(true);

it("should test `getUsers`", async () => {
    const wrapped = testEnv.wrap(messaging_api.getMessages);
    const testUser = {
      uid: "yo"
    };
  
    await wrapped(testUser)
        .then(async (createdUser) => {
            expect(createdUser.status).toBe('OK')
            done()
        })
        .catch((error) => {
            fail('createUserByAdmin failed with the following ' + error)
        });
  
    // generate user returns newUser object below
    /*
      const newUser = {
        uid,
        displayName,
        points: 0,
        questType: "view", // enum { view, sub }
        questGoal: 30,
        questActual: 10,
        // valid for next 24 hours
        questValidUntil: Date.now() + dayInMs
      };
    */
    // const newUser = generateNewUser(testUser);
  
    // // check our db set function is called with expected parameter
    // expect(admin.database().ref(`/users/${testUser.uid}`).set).toBeCalledWith(newUser);
  
    // check it returns mocked value as expected
    expect(wrapped(testUser)).toBe(true);
  });
  