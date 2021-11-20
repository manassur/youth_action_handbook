import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String? topicId;
  final String? caption;
  final String? description;
  final int? likeCount;
  final int? replyCount;
  final String? authorId;
  final String? authorName;
  final String? authorImg;
  final Timestamp? timestamp;
  final bool? commentsAllowed;

  Post({
    this.id,
    this.topicId,
    this.caption,
    this.description,
    this.likeCount,
    this.replyCount,
    this.authorId,
    this.authorName,
    this.authorImg,
    this.timestamp,
    this.commentsAllowed,
  });

  factory Post.fromDoc(DocumentSnapshot? doc) {
    return Post(
      id: doc!.id,
      topicId: doc['topicId'],
      caption: doc['caption'],
      description: doc['description']??'',
      likeCount: doc['likeCount']??0,
      replyCount: doc['replyCount']??0,
      authorId: doc['authorId']??'',
      authorName: doc['authorName']??'',
      authorImg: doc['authorImg']??'',
      timestamp: doc['timestamp'],
      commentsAllowed: doc['commentsAllowed'] ?? true,
    );
  }
}
