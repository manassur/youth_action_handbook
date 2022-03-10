import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/course_with_language_response.dart';
import 'package:youth_action_handbook/models/news_response.dart';
import 'package:youth_action_handbook/repository/api_client.dart';
import 'package:youth_action_handbook/services/database.dart';

class ApiService {
  // this will fetch recommended courses
  ApiClient _apiClient = ApiClient();
  var coursesUrl = 'https://dev.silbaka.com/courses-new.json';
  var coursesUrlEn = 'https://greatlakesyouth.africa/api/v2/pages/?fields=*&locale=en&type=courses.CoursePage&format=json';
  var coursesUrlFr = 'https://greatlakesyouth.africa/api/v2/pages/?fields=*&locale=fr&type=courses.CoursePage&format=json';
  DateTime currentTime = DateTime.now();

  Future<Map<String, dynamic>> getAllCourseUrlData() async{
    File file1 = await DefaultCacheManager().getSingleFile(coursesUrlEn);
    File file2 = await DefaultCacheManager().getSingleFile(coursesUrlFr);
    final contents1 = await file1.readAsString();
    final contents2 = await file2.readAsString();
    Map<String, dynamic> data = {};
    data['en'] = json.decode(contents1);
    data['fr'] = json.decode(contents2);
    return data;
  }
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
    //RECENT LESSONS DISABLED IN FRENCH BECAUSE IDS ARE DIFFERENT
    var prefs = await SharedPreferences.getInstance();

    final data = await getAllCourseUrlData();

    CourseWithLanguageResponse  res = CourseWithLanguageResponse.fromJson(data);
 
    // String languageCode = prefs.getString('languageCode') ?? Localizations.localeOf(AppWrapper.navigatorKey.currentContext!).toString().split("_")[0];
    CourseResponse result = res.en!;
    // if(languageCode == 'fr') result = res.fr!;
    // print('AKBR GETTING RECENTS NOW LOCAL IS :'+languageCode);
    final course = result.courses!.firstWhere((Courses element) => element.id==courseId);
    return course.lessons!.firstWhere((Lessons element) => element.id==lessonId);
  }


  //  Future<CourseWithLanguageResponse> newApiFetchCourses() async {
   Future<CourseWithLanguageResponse> fetchCoursesFromServer() async {

    // try {
      Map<String, dynamic> data = await getAllCourseUrlData();
      CourseWithLanguageResponse res = CourseWithLanguageResponse.fromJson(data);
      print('AKBR Res Returned: '+res.en!.courses!.first.title.toString());
      return res;
    // } catch(e, stacktrace){
    //   print('AKBR api ERROR THROWN: '+e.toString() + ' at: '+stacktrace.toString());
    //   throw e;
    //   // return CourseWithLanguageResponse();
    // }
  }


  Future<bool> checkForCourseUpdates() async {
    var onlineVersion;
    String offlineVersion;
    var prefs = await SharedPreferences.getInstance();
    
    DateTime lastCheckTime = DateTime.parse(prefs.getString('lastCheckTime') ?? '2022-01-02 03:04:05');
    offlineVersion = prefs.getString('offlineVersion') ?? ('');

    try{
      if(currentTime.difference(lastCheckTime).inHours >= 1){
        //Course Version shown below is what is used to know if content has changed on server.
        final response = await http.get(Uri.parse('https://greatlakesyouth.africa/api/v2/pages/?fields=date_updated&format=json&id=313&type=courses.CoursePage'));
        onlineVersion = json.decode(response.body)['items'][0]['date_updated'];
        print('AKBR TIME PASSED SICNE LAST CHECK is: '+ currentTime.difference(lastCheckTime).inSeconds.toString());
        prefs.setString('lastCheckTime', currentTime.toString());
      }else{
        print('AKBR NO TIME HAS PASSED');
        onlineVersion = offlineVersion;
      }
    }catch(e){
      print('AKBR TIME CHECK FAILED :'+ e.toString());
      onlineVersion = offlineVersion;
    }

    try {
      print('AKBR SEE THE VERSIONS:\tonline = '+onlineVersion+'\toffline = '+offlineVersion);
      if (offlineVersion == onlineVersion){
        print('AKBR VERSIONS MATCH');
        // file = await DefaultCacheManager().getSingleFile(coursesUrl);
        return false;
      }else{
        print('AKBR Ditching Old Courses');
        await DefaultCacheManager().removeFile(coursesUrlEn).then((value) async=> await DefaultCacheManager().downloadFile(coursesUrlEn));
        await DefaultCacheManager().removeFile(coursesUrlFr).then((value) async=> await DefaultCacheManager().downloadFile(coursesUrlFr));
         prefs.setString('offlineVersion', onlineVersion);
         prefs.setBool('notFirstLaunch',false);
        return true;
      }
    } on Exception catch (e) {
      print('AKBR ERROR in SECOND HALF'+e.toString());
      throw e;
    }
  }

  Future<CourseWithLanguageResponse> fetchCoursesFromServerOld() async {
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

