import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final  userDataCollection =_firestore.collection('userData');

final postsRef = _firestore.collection('posts');
final topicsRef = _firestore.collection('topics');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final commentsRef = _firestore.collection('comments');
final activitiesRef = _firestore.collection('activities');
final archivedPostsRef = _firestore.collection('archivedPosts');

enum PostStatus {
  feedPost,
  deletedPost,
  archivedPost,
}

enum SearchFrom {
  messagesScreen,
  homeScreen,
  createStoryScreen,
}

enum TopicCategory {
  popularTopics,
  recommendedTopics,
  newTopics,
}