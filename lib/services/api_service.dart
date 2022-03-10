import 'dart:convert';
import 'package:flutter_cache_manager/file.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/course_with_language_response.dart';
import 'package:youth_action_handbook/models/news_response.dart';
import 'package:youth_action_handbook/repository/api_client.dart';
import 'package:youth_action_handbook/services/database.dart';

class ApiService {
  // this will fetch recommended courses
  ApiClient _apiClient = ApiClient();
  var coursesUrl = 'https://dev.silbaka.com/courses-new.json';
  var coursesUrlNew = 'https://greatlakesyouth.africa/api/v2/pages/?fields=*&locale=en&type=courses.CoursePage&format=json';
  DateTime currentTime = DateTime.now();

  // Future<CourseResponse> fetchCourses() async {
  //   final String response = await rootBundle.loadString('assets/json/courses-new.json');
  //   final data = await json.decode(response);
  //   print("this is courses json " + response);
  //   CourseResponse result = CourseResponse.fromJson(data);
  //   return result;
  // }

  // this fetches news updates
  Future<NewsResponse> fetchNewsUpdate() async {
    var url = 'https://dev.silbaka.com/news.json';
   

    final response = await http.get(Uri.parse('https://dev.silbaka.com/news.json'));
    var body = response.body;
    // final String response = await rootBundle.loadString('assets/json/news.json');
    final data = await json.decode(body);
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
    final file = await DefaultCacheManager().getSingleFile(coursesUrl);
    final contents = await file.readAsString();
    final data = await json.decode(contents);
    CourseResponse result = CourseResponse.fromJson(data);
    return result;
  }

  Future<Lessons> getCourseByCourseId(String courseId,lessonId) async {
    //TODO: CHECK TO SEE IF ENGLISH OR FRENCH CAN BE FETCHED Depneding on language 
    final file = await DefaultCacheManager().getSingleFile(coursesUrl);
    final contents = await file.readAsString();
    
    final data = await json.decode(contents);
    CourseWithLanguageResponse  res = CourseWithLanguageResponse.fromJson(data);
    CourseResponse result = res.en!;
    final course = result.courses!.firstWhere((Courses element) => element.id==courseId);
    return course.lessons!.firstWhere((Lessons element) => element.id==lessonId);
  }


  // service methods calling from the hosted json
    Future<CourseWithLanguageResponse> fetchCoursesFromServerold() async {
    // final response = await _apiClient.get('https://apprant.com/yah/index.html');
    final response = await _apiClient.get('https://dev.silbaka.com/courses-new.json');
    var data = json.decode(response);
    CourseWithLanguageResponse  res = CourseWithLanguageResponse.fromJson(data);
    return res;
  }



   Future newApiFetchCourses() async {
     print('AKBR FUNCTION FIRED');
    File file;

    try {
      print('AKBR TRY STARTED');
      // print('AKBR SEE THE VERSIONS:\tonline = '+onlineVersion+'\toffline = '+courseVersion);
      
      // await DefaultCacheManager().removeFile(coursesUrlNew).then((value) async=> file = await DefaultCacheManager().getSingleFile(coursesUrlNew));
      file = await DefaultCacheManager().getSingleFile(coursesUrlNew);
      
      final contents = await file.readAsString();

      Map<String, dynamic> data = json.decode(contents);
      // CourseWithLanguageResponse  res = CourseWithLanguageResponse.fromJson(data);
      print('AKBR data: example title 1 is: '+data['items'][0]['title'].toString());
      CourseResponse res = CourseResponse.fromJsonNew(data);
      print('AKBR correct answer id: '+res.courses![0].quiz!.first.questions!.first.answers!.first.option .toString());
      print('AKBR IT FINISHED');
    } catch(e, stacktrace){
      print('AKBR api ERROR THROWN: '+e.toString() + ' at: '+stacktrace.toString());
    }
  }


  Future<CourseWithLanguageResponse> fetchCoursesFromServer() async {
    newApiFetchCourses();
    var onlineVersion;
    String courseVersion;
    File file;
    
    var prefs = await SharedPreferences.getInstance();
    DateTime lastCheckTime = DateTime.parse(prefs.getString('lastCheckTime') ?? '2022-01-02 03:04:05');
    courseVersion = prefs.getString('courseVersion') ?? ('');

    try{
      if(currentTime.difference(lastCheckTime).inMinutes >= 1){
        final response = await http.get(Uri.parse('https://dev.silbaka.com/CourseVersion'));
        onlineVersion = response.body;
        prefs.setString('lastCheckTime', currentTime.toString());
      }else{
        onlineVersion = courseVersion;
      }

    }catch(e){
      onlineVersion = courseVersion;
    }

    try {
      // print('AKBR SEE THE VERSIONS:\tonline = '+onlineVersion+'\toffline = '+courseVersion);
      if (courseVersion == onlineVersion){
        file = await DefaultCacheManager().getSingleFile(coursesUrl);
      }else{
        DefaultCacheManager().removeFile(coursesUrl).then((value) {
          prefs.setString('courseVersion', onlineVersion);
        }).onError((error, stackTrace) {
          // print(error);
        });
        file = await DefaultCacheManager().getSingleFile(coursesUrl);  
      }
      final contents = await file.readAsString();

      var data = json.decode(contents);
      CourseWithLanguageResponse  res = CourseWithLanguageResponse.fromJson(data);
      return res;
    } on Exception catch (e) {
      throw e;
    }
  }

}

