import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:youth_action_handbook/models/firestore_models/comment_model.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
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
  Future createUserData(String name, String organisation, String language, String country,String? gender, String? education, String? dateOfBirth) async {
    return await userDataCollection
        .doc(uid)
        .set({'name': name, 'organisation': organisation, 'language': language, 'country': country,'gender':gender , 'education':education, 'dateOfBirth':dateOfBirth});
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

  void createTopic(String topic) {

    try {
      topicsRef.add({
        'topic': Timestamp.fromDate(DateTime.now()),
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

  static void deletePost(Post post, PostStatus postStatus) {
    postsRef
        .doc(post.authorId)
        .collection('deletedPosts')
        .doc(post.id)
        .set({
      'imageUrl': post.topicId,
      'caption': post.caption,
      'likeCount': post.likeCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp
    });
    String collection;
    postStatus == PostStatus.feedPost
        ? collection = 'userPosts'
        : collection = 'archivedPosts';
    postsRef
        .doc(post.authorId)
        .collection(collection)
        .doc(post.id)
        .delete();
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

   Future<List<Post>> getTopicPosts(String topicId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .doc(topicId)
        .collection('topicPosts')
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


  Future<Post> getSingleUserPost(String authorId,String postId) async{
    DocumentSnapshot<Map<String, dynamic>> userPostSnapshot = await postsRef
        .doc(authorId)
        .collection('userPosts')
        .doc(postId)
        .get();
    return Post.fromDoc(userPostSnapshot);
  }
}
