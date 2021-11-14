import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/news_response.dart';

class ApiService {

  Future<CourseResponse> fetchCourses() async {
    final String response = await rootBundle.loadString('assets/json/courses.json');
    final data = await json.decode(response);
    print("this is courses json " + response);
    CourseResponse result = CourseResponse.fromJson(data);
    return result;
  }


  Future<NewsResponse> fetchNewsUpdate() async {
    final String response = await rootBundle.loadString('assets/json/news.json');
    final data = await json.decode(response);
    NewsResponse result = NewsResponse.fromJson(data);
    return result;
  }
}

