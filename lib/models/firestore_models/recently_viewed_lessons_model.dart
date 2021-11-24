import 'package:cloud_firestore/cloud_firestore.dart';

class RecentlyViewedLesson {
  final String? courseId;
  final String? lessonId;
  final String? courseName;
  final String? lessonTitle;
  final Timestamp? timestamp;
  final String? id;



  RecentlyViewedLesson({
    this.courseId,
    this.courseName,
    this.timestamp,
    this.lessonId,
    this.lessonTitle,
    this.id
  });

  factory RecentlyViewedLesson.fromDoc(DocumentSnapshot? doc) {
    return RecentlyViewedLesson(
      id: doc!.id,
      courseId: doc['courseId'],
      courseName: doc['courseName'],
      timestamp: doc['timestamp'],
      lessonId: doc['lessonId'],
      lessonTitle: doc['lessonTitle'],
    );
  }
}
