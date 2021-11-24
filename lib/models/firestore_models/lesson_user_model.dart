import 'package:cloud_firestore/cloud_firestore.dart';

class LessonUser {
  final String? courseId;
  final String? lessonId;
  final String? courseName;
  final String? uid;
  final int? viewCount;
  final int? percentage;
  final Timestamp? timestamp;
  final String? id;



  LessonUser({
    this.courseId,
    this.courseName,
    this.viewCount,
    this.timestamp,
    this.percentage,
    this.lessonId,
    this.uid,
    this.id
  });

  factory LessonUser.fromDoc(DocumentSnapshot? doc) {
    return LessonUser(
      id: doc!.id,
      courseId: doc['courseId'],
      courseName: doc['courseName'],
      timestamp: doc['timestamp'],
      viewCount: doc['viewCount'] ,
      lessonId: doc['lessonId'],
      percentage: doc['percentage'],
      uid: doc['uid'],
    );
  }
}
