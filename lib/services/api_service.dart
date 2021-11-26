import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/firestore_models/user_courses.dart';
import 'package:youth_action_handbook/models/news_response.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:provider/provider.dart';

class ApiService {
  // this will fetch recommended courses
  Future<CourseResponse> fetchCourses() async {
    final String response = await rootBundle.loadString('assets/json/courses.json');
    final data = await json.decode(response);
    print("this is courses json " + response);
    CourseResponse result = CourseResponse.fromJson(data);
    return result;
  }

  // this fetches news updates
  Future<NewsResponse> fetchNewsUpdate() async {
    final String response = await rootBundle.loadString('assets/json/news.json');
    final data = await json.decode(response);
    NewsResponse result = NewsResponse.fromJson(data);
    return result;
  }

  // this will fetch user courses
  Future<CourseResponse> fetchUserCourses(String uid) async {
    DatabaseService db = DatabaseService(uid:uid);
    // fetch all courseIds the user has viewed
    var userCourses =await db.getUserCourses();

    //just to make susre duplicates aren't being sent to the server
    var idSet = <String>{}; // an array to hold distinct course id's
    userCourses.forEach((element) {
      if(!idSet.contains(element.id)){
        idSet.add(element.id.toString());
      }
    });

    /*
    *TODO: the idSet should be passed as seperated commas to the api
    * for now we will just return the regular courses
     */

    final String response = await rootBundle.loadString('assets/json/courses.json');
    final data = await json.decode(response);
    print("this is courses json " + response);
    CourseResponse result = CourseResponse.fromJson(data);
    return result;
  }


  // this extracts the course from the already fetched courses with the courseid
  Future<Lessons> getCourseByCourseId(String courseId,lessonId) async {
    final String response = await rootBundle.loadString('assets/json/courses.json');
    final data = await json.decode(response);
    print("this is courses json " + response);
    CourseResponse result = CourseResponse.fromJson(data);
    var course = result.courses!.firstWhere((Courses element) => element.id==courseId);
    return course.lessons!.firstWhere((Lessons element) => element.id==lessonId);
  }
}

