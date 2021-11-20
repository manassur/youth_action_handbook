import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String? id;
  final String? topic;
  final int? postCount;
  final Timestamp? timestamp;
  final bool? isRecommended;
  final bool? isActive;


  Topic({
    this.id,
    this.topic,
    this.postCount,
    this.timestamp,
    this.isRecommended,
    this.isActive
  });

  factory Topic.fromDoc(DocumentSnapshot? doc) {
    return Topic(
      id: doc!.id,
      topic: doc['topic'],
      postCount: doc['postCount'],
      timestamp: doc['timestamp'],
      isRecommended: doc['isRecommended'] ?? false,
      isActive: doc['isActive'] ?? true,
    );
  }
}
