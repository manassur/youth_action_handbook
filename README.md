# Youth Handbook Breakdown
A short overview of the units within the app. These descriptions are not final, and are just guides to help with the process.
We can split up the app into 5 key modules:
- Learn
- Forum
- Updates
- User Auth
- About

## Learn
----------
This includes everything required for the learning modules, their classes, and functions.  It includes 2 main :
- Courses
-Evaluation Quiz

### Course modules
This follows the handbook design and has fields reflecting the handbook. It's data might come either directly from the website, or pass through a firestore document (implementation still to be decided)

###Quiz
Standard quiz with questions coming from same source as course modules. each course module is linked to a quiz that can be accessed on it's page, testing content from that course module. It shows a score after the quiz, and also shows a short explanation after each question is answered. , and shows a  includes:
- Questions
-score screen after quiz is taken
each question has:
- answers
-correct answer
- short explanation to display with correct answer
 
quiz results could be linked to user profiles to show which ones have been completed and which ones have't if possible


## Updates (+ Notifications)
--------------------------------
Updates shall lives in a short section in the homepage, and can hold content from the blog on the website. We could use the same module to handle notifications sent to the app, and have them display in the updates section too. This could also use cloud firestore to enable offline caching



## User Auth + Preferences
-------------------------------
This handles sign in, sign up, sign out, and forgot password user flows. it also covers handling of user preferences and all related functions. This shall rely on a stream from firestore to update profile changes in realtime. 


## About
-----------
This handles the pages containing information about the app and the partners, so most of the content in the about Tab. This is mostly static content, so it might be the fastest to implement.



## Forum
--------------
This has not been finalised, but would ideally include the page that shows forum posts, topics, and more. This could rely on a firestore document that holds all posts and the content within.

# Data Model
--------------
We can use classes matching the data areas we have, including these:
- user Class -> this links to the user firebase object, and the userdata firestore document

- Module - links to the modules firestore document or the json api straight from the website

- Quiz 
- 

## Other Notes
- We can use Provider to handle state, shared_prefs to handle preferences, streams for data from firestore
- Streams from Firestore shall be used to ensure caching and offline functionality
- screens
