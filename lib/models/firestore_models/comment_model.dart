import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? id;
  final String? parentId;
  final String? parentAuthorId;
  final String? caption;
  final int? replyCount;
  final String? authorId;
  final String? authorName;
  final String? authorImg;
  final Timestamp? timestamp;
  final bool? isParentComment;

  Comment({
    this.id,
    this.parentId,
    this.parentAuthorId,
    this.caption,
    this.replyCount,
    this.authorId,
    this.authorName,
    this.authorImg,
    this.timestamp,
    this.isParentComment,
  });

  factory Comment.fromDoc(DocumentSnapshot? doc) {
    return Comment(
      id: doc!.id,
      parentId: doc['parentId'],
      parentAuthorId: doc['parentAuthorId'],
      caption: doc['caption'],
      replyCount: doc['replyCount']??0,
      authorId: doc['authorId']??'',
      authorName: doc['authorName']??'',
      authorImg: doc['authorImg']??'',
      timestamp: doc['timestamp'],
      isParentComment: doc['isParentComment'] ?? true,
    );
  }
}
