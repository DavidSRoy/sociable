# Firebase Tips & Shortcuts

 Data is organized in the Document/Collection model, where a document is the basic unit and a Collection is a group of documents.Think of a document as a file or report you have about something or someone; each individual person may have different fields that are important, but you still have a collection of documents where each document represents a person (or object).

 ## Get data from Firestore Document
 `const data = await firestore.collection(COLLECTION_NAME).doc(<ID>).get().data()`
