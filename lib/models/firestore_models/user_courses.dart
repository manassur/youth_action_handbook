import 'package:cloud_firestore/cloud_firestore.dart';

class UserCourses {
  final String? courseId;
  final String? courseName;
  final Timestamp? timestamp;
  final String? id;



  UserCourses({
    this.courseId,
    this.courseName,
    this.timestamp,
    this.id
  });

  factory UserCourses.fromDoc(DocumentSnapshot? doc) {
    return UserCourses(
      id: doc!.id,
      courseId: doc['courseId'],
      courseName: doc['courseName'],
      timestamp: doc['timestamp'],

    );
  }
}
