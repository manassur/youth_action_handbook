import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/firestore_models/comment_model.dart';
import 'package:youth_action_handbook/models/firestore_models/lesson_user_model.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/models/firestore_models/quiz_answers_model.dart';
import 'package:youth_action_handbook/models/firestore_models/recently_viewed_lessons_model.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/firestore_models/user_courses.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/data/constants.dart';

class DatabaseService {
  final String? uid;
  final _auth = AuthService();
  final _fauth = FirebaseAuth.instance;

  DatabaseService({this.uid});

  //Create user Data AT registration
  Future createUserData(String name, String organisation, String language, String country,String? gender, String? education, String? dateOfBirth,String? profilePicture) async {
    return await userDataCollection
        .doc(uid)
        .set({'name': name, 'organisation': organisation, 'language': language, 'country': country,'gender':gender , 'education':education, 'dateOfBirth':dateOfBirth,'profilePicture':profilePicture});
  }

  //update any NON_SENSITIVE user field. email and password are handled by the authService
  Future updateField(String name, value) async{
    String message = '';
    try{
      
    await userDataCollection
        .doc(uid)
        .update({name : value}).then(
          (val) => message = 'Success',
        );
    }on FirebaseException catch(e){
      message = e.message?? 'an error occured';
    }
    return message;
  }

  // Future upd

 Stream<AppUser?> appUserStream(user){
    return userDataCollection.doc(user.uid).snapshots().map((snapshot) => appUserfromSnapshot(user, snapshot));
  }

  //get appUser  from snapshot
  AppUser? appUserfromSnapshot(User? user,DocumentSnapshot snapshot){
    if(user == null){
      return null;
    }
    
    return AppUser(
      uid: user.uid,
      name: snapshot.get('name') ?? 'Anon.',
      organisation: snapshot.get('organisation') ?? '',
      language: snapshot.get('language') ?? 'en',
      country: snapshot.get('country') ?? '',
      gender: snapshot.get('gender') ?? '',
      education: snapshot.get('education') ?? '',
      dateOfBirth: snapshot.get('dateOfBirth') ?? '',
      profilePicture: snapshot.get('profilePicture') ?? '',
      displayName: user.displayName,
      email: user.email,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      refreshToken: user.refreshToken
      ); 
  }

   Future<void> createPost(Post post) async {

    postsRef.doc(post.authorId).collection('userPosts').add({
        'topicId': post.topicId,
        'caption': post.caption,
        'description':post.description,
        'likeCount': post.likeCount,
        'replyCount':post.replyCount,
        'authorId': post.authorId,
        'authorName':post.authorName,
        'authorImg':post.authorImg,
        'timestamp': post.timestamp,
        'commentsAllowed':true,
      }).then((doc){

      topicsRef.doc(post.topicId).collection('topicPosts').doc(doc.id).set({
        'authorId': post.authorId,
        'postId': doc.id,
        'timestamp': post.timestamp,
      });
      //show the id of the post that just got saved
      print('post id of the new post '+ doc.id);
      print('user id of the new post '+ post.authorId!);

    });




     // update the post count for the topic
      DocumentReference topicRef = topicsRef.doc(post.topicId);
      topicRef.get().then((doc) {
        int postCount = doc['postCount'];
        topicRef.update({'postCount': postCount + 1});}
        );
  }

   void deletePost(Post post) async {

    postsRef.doc(post.authorId).
    collection('userPosts').doc(post.id).delete().then((doc){

      topicsRef.doc(post.topicId)
          .collection('topicPosts')
          .doc(post.id)
          .delete();
    });

    // update the post count for the topic
    DocumentReference topicRef = topicsRef.doc(post.topicId);
    topicRef.get().then((doc) {
      int postCount = doc['postCount'];
      topicRef.update({'postCount': postCount - 1});}
    );
  }


  Future<void> addLessonForUser(Lessons lesson,String courseId,String courseName) async {
    var lessonUserRef =   coursesRef.doc(courseId)
        .collection('courseLessons')
        .doc(lesson.id)
        .collection('lessonUsers');

        lessonUserRef
        .where('uid',isEqualTo: uid)
        .limit(1)
        .get()
        .then((doc) {
      if (doc.docs.isEmpty) {
        lessonUserRef.add({
          'lessonId': lesson.id,
          'courseId': courseId,
          'courseName': courseName,
          'percentage': 0,
          'viewCount':0,
          'uid': uid,
          'timestamp': Timestamp.fromDate(DateTime.now()),
        });
      } else {
        DocumentReference userLessonRef =
            lessonUserRef
            .doc(doc.docs[0].id);
        int viewCount = doc.docs[0]['viewCount'];
        userLessonRef.update({'viewCount': viewCount + 1});
      }
    });

    recentlyViewedRef.doc(uid).collection('lessons').add({
      'lessonId': lesson.id,
      'lessonTitle': lesson.title,
      'courseId': courseId,
      'courseName': courseName,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });

    userCourseRef.doc(uid).collection('courses').add({
      'courseId': courseId,
      'courseName': courseName,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> addRating(String courseId,double rating) async {
    ratingRef.doc(courseId)
        .collection('userRating')
        .add({
      'value':rating,
      'uid':uid,
      'timestamp': Timestamp.fromDate(DateTime.now())}
    );
  }

  Future<double> getCourseRating(String courseId) async {
    var myRating = await ratingRef.doc(courseId)
        .collection('userRating')
        .where('field',isEqualTo:courseId)
        .get();
    double ratingCount=0;
    double ratingTotal= 0;
     myRating.docs.forEach((element) {
       ratingCount++;
       ratingTotal+=element['value'];
     });
    return ratingTotal/ratingCount;
  }


  Future<void> addUserQuizRecord(String courseId,String quizId,String questionId,String chosenOptionId,double score) async {
   print('call to add record with score :' + score.toString());
    userQuizRef.doc(uid)
        .collection('course')
        .doc(courseId)
        .collection('quiz')
        .doc(quizId)
        .collection('quizAnswers')
        .add({
      'score':score,
      'questionId':questionId,
      'chosenOptionId':chosenOptionId,
    }
    );
  }

  Future<List<QuizAnswer>> getUserQuizAnswers(String courseId,String quizId) async {
    QuerySnapshot snapshot = await userQuizRef
        .doc(uid)
        .collection('course')
        .doc(courseId)
        .collection('quiz')
        .doc(quizId)
        .collection('quizAnswers')
        .get();
    List<QuizAnswer> data =
    snapshot.docs.map((doc) => QuizAnswer.fromDoc(doc)).toList();
    return data;
  }

  // if the user has taken the sum of scores
  // returns -1 if theres no record found
  Future<double> getQuizScore(String courseId,String quizId) async {

   var doc = await userQuizRef.doc(uid)
        .collection('course')
        .doc(courseId)
        .collection('quiz')
        .doc(quizId)
       .collection('quizAnswers').get();

    if(doc.docs.isNotEmpty){
      print('docs is empty');
      double score = 0;
       doc.docs.forEach(( element) {
         score+= QuizAnswer.fromDoc(element).score!;
       });
     return score;
   }else{
     return -1;
  }
  }

  Future<bool> hasViewedLesson(String lessonId,String courseId) async {
    var lessonUserRef =   coursesRef.doc(courseId)
        .collection('courseLessons')
        .doc(lessonId)
        .collection('lessonUsers');

  var doc = await lessonUserRef
        .where('uid',isEqualTo: uid)
        .limit(1)
        .get();

    return doc.docs.isNotEmpty;
  }

  Future<void> addComment(Comment post) async {

    replyRef.add({
      'parentId': post.parentId,
      'parentAuthorId':post.parentAuthorId,
      'caption': post.caption,
      'replyCount':post.replyCount,
      'authorId': post.authorId,
      'authorName':post.authorName,
      'authorImg':post.authorImg,
      'timestamp': post.timestamp,
      'isParentComment':post.isParentComment,
    }).then((doc){
      // update the post count for the post only when it is a parent comment
      if(post.isParentComment==true) {
        DocumentReference postRef = postsRef
            .doc(post.parentAuthorId)
            .collection('userPosts')
            .doc(post.parentId);
        postRef.get().then((doc) {
          int postCount = doc['replyCount'];
          postRef.update({'replyCount': postCount + 1});
        }
        );
      }
    });
  }
  void deleteComment(Comment comment) async {

    replyRef
        .doc(comment.id)
        .delete()
        .then((doc){
      // update the post count for the post only when it is a parent comment
      if(comment.isParentComment==true) {
        DocumentReference postRef = postsRef
            .doc(comment.parentAuthorId)
            .collection('userPosts')
            .doc(comment.parentId);
        postRef.get().then((doc) {
          int postCount = doc['replyCount'];
          postRef.update({'replyCount': postCount - 1});
        }
        );
      }
    });
  }

  void createTopic(String topic) {

    try {
      topicsRef.add({
        'topic': topic,
        'postCount': 0,
        'isRecommended': false,
        'isActive':true,
        'timestamp': Timestamp.fromDate(DateTime.now())
      });
    } catch (e) {
      print(e);
    }
  }


   void clearCollection(CollectionReference collectionReference) {
    collectionReference.doc().delete();
  }


  void likePost(Post post) async{
    print('the author of the post we want to like  '+post.authorId!);
    print('the id of the post we want to like '+post.id!);

    DocumentReference postRef = postsRef
        .doc(post.authorId)
        .collection('userPosts')
       .doc(post.id);
    postRef.get().then((doc) {
      print('doc data '+doc.data().toString());
      if(doc.exists){
        print('doc exists while trying to like'+doc.data().toString());
        int likeCount = doc['likeCount'];
      postRef.update({'likeCount': likeCount + 1});
      likesRef
          .doc(post.id)
          .collection('postLikes')
          .doc(uid)
          .set({});
      }else{
        print('doc does  not exist while trying to like');

      }
    });
  }

   void unlikePost(Post post) {
    DocumentReference postRef = postsRef
        .doc(post.authorId)
        .collection('userPosts')
        .doc(post.id);
    postRef.get().then((doc) {
      int likeCount = doc['likeCount'];
      postRef.update({'likeCount': likeCount + -1});
      likesRef
          .doc(post.id)
          .collection('postLikes')
          .doc(uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });

  }

    Future<bool> didLikePost(String postId) async {
    DocumentSnapshot? userDoc = await likesRef
        .doc(postId)
        .collection('postLikes')
        .doc(uid)
        .get();
    return userDoc.exists;
  }

   void commentOnPost(
      { Post? post, String? comment, String? recieverToken}) {
    commentsRef.doc(post!.id).collection('postComments').add({
      'content': comment,
      'authorId': uid,
      'timestamp': Timestamp.fromDate(DateTime.now())
    });

  }


   Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .doc(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
    userPostsSnapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  Future<List<Post>> getTrendingPosts() async {
    List<Post> posts =[];
    // get the most trending topic
    QuerySnapshot topicSnapshot = await topicsRef
        .orderBy('postCount', descending: true)
        . limit(1)
        .get();
    if(topicSnapshot.docs.isNotEmpty) {
      print(topicSnapshot.docs[0].data());

      List<Topic> topics =
      topicSnapshot.docs.map((doc) => Topic.fromDoc(doc)).toList();
      // use the trending topic to get the most trending post

      // use this to reset data manually
      print('the trending topic ' + topics[0].id!);
      //  topicsRef.doc(topics[0].id!).delete();

      /* get the 10 latest trending post */
      QuerySnapshot topicPostSnapshot = await topicsRef
          .doc(topics[0].id!)
          .collection('topicPosts')
          .orderBy('timestamp',descending: true)
          .limit(10)
          .get();

      // use each of the author id and post id to fetch the post
      for(DocumentSnapshot element  in topicPostSnapshot.docs){
        Post userPost = await  getSingleUserPost(element['authorId'], element['postId']);
        // add the post to the list
        posts.add(userPost);
      }
    }
    return posts;

  }

  Future<List<Post>> getNewPosts() async {
    List<Post> posts =[];
    // get the most trending topic
    QuerySnapshot topicSnapshot = await topicsRef
        .where('isActive',isEqualTo:true)
        .orderBy('timestamp', descending: true)
        . limit(5)
        .get();
    if(topicSnapshot.docs.isNotEmpty) {
     // print(topicSnapshot.docs[0].data());

      List<Topic> topics =
      topicSnapshot.docs.map((doc) => Topic.fromDoc(doc)).toList();

      // for each topic fetch the 5 latest posts
      for(var topic in topics){
        var topicPosts = await getTopicPosts(topic.id!);
        print(topic.id!+'pay');
        posts.addAll(topicPosts);
      }


    }
    return posts;

  }

  Future<List<Post>> getRecommendedPosts() async {
    List<Post> posts =[];
    // get the most trending topic
    QuerySnapshot topicSnapshot = await topicsRef
        .where('isActive',isEqualTo:true)
        .where('isRecommended',isEqualTo:true)
        .orderBy('timestamp', descending: true)
        . limit(5)
        .get();
    if(topicSnapshot.docs.isNotEmpty) {
      print(topicSnapshot.docs[0].data());

      List<Topic> topics =
      topicSnapshot.docs.map((doc) => Topic.fromDoc(doc)).toList();

      // for each topic fetch the 5 latest posts

      // for each topic fetch the 5 latest posts
      for(var topic in topics){
        var topicPosts = await getTopicPosts(topic.id!);
        print(topic.id!+'pay');
        posts.addAll(topicPosts);
      }

    }
    return posts;

  }



  Future<List<Post>> getTopicPosts(String topicId) async {
    List<Post> posts =[];


      /* get the 10 latest trending post */
      QuerySnapshot topicPostSnapshot = await topicsRef
          .doc(topicId)
          .collection('topicPosts')
          .orderBy('timestamp',descending: true)
          .limit(10)
          .get();

      // use each of the author id and post id to fetch the post
     for(DocumentSnapshot element  in topicPostSnapshot.docs){
        Post userPost = await  getSingleUserPost(element['authorId'], element['postId']);
       // add the post to the list
       posts.add(userPost);
     }

    return posts;

  }
  Future<List<Comment>> getPostComments(String postId) async {
    List<Comment> posts =[];
    QuerySnapshot replySnapshot = await replyRef
        .where('parentId',isEqualTo: postId)
        .limit(20)
        .get();
    if(replySnapshot.docs.isNotEmpty) {
      posts =
      replySnapshot.docs.map((doc) => Comment.fromDoc(doc)).toList();
    }
    return posts;

  }


  Future<List<Topic>> getTopics() async {
    QuerySnapshot topicSnapshot = await topicsRef
        .where('isActive', isEqualTo: true)
        .limit(5)
        .get();
    List<Topic> topics =
    topicSnapshot.docs.map((doc) => Topic.fromDoc(doc)).toList();
    return topics;
  }

  Future<List<Topic>> getRecommendedTopics() async {
    QuerySnapshot topicSnapshot = await topicsRef
        .where('isActive', isEqualTo: true)
        .where('isRecommended',isEqualTo:true)
        .limit(5)
        .get();
    List<Topic> topics =
    topicSnapshot.docs.map((doc) => Topic.fromDoc(doc)).toList();
    return topics;
  }
  Future<List<Topic>> getNewTopics() async {
    QuerySnapshot topicSnapshot = await topicsRef
        .where('isActive', isEqualTo: true)
        .orderBy('timestamp',descending: true)
        .limit(5)
        .get();
    List<Topic> topics =
    topicSnapshot.docs.map((doc) => Topic.fromDoc(doc)).toList();
    return topics;
  }
  Future<List<RecentlyViewedLesson>> getMostRecentCourse() async {
    var lessonUserSnapShot =  await recentlyViewedRef.doc(uid)
        .collection('lessons')
        .orderBy('timestamp',descending:true )
        .limit(1).get();
    List<RecentlyViewedLesson> recentViews =
    lessonUserSnapShot.docs.map((doc) => RecentlyViewedLesson.fromDoc(doc)).toList();
    return recentViews;
  }
  Future<List<UserCourses>> getUserCourses() async {
    var lessonUserSnapShot =  await recentlyViewedRef.doc(uid)
        .collection('courses')
        .orderBy('timestamp')
        .limit(1).get();
    List<UserCourses> userCourses =
    lessonUserSnapShot.docs.map((doc) => UserCourses.fromDoc(doc)).toList();
    return userCourses;
  }

  Future<Post> getSingleUserPost(String authorId,String postId) async{
    DocumentSnapshot<Map<String, dynamic>> userPostSnapshot = await postsRef
        .doc(authorId)
        .collection('userPosts')
        .doc(postId)
        .get();
    return Post.fromDoc(userPostSnapshot);
  }


}
