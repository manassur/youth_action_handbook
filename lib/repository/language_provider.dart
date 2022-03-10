import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/course_with_language_response.dart';
import 'package:youth_action_handbook/repository/cache_helper.dart';
import 'package:youth_action_handbook/services/api_service.dart';

class LanguageProvider extends ChangeNotifier {
  CacheHelper cacheHelper = CacheHelper();
  ApiService apiService = ApiService();
  bool isLoading = false,hasError = false;
  String errorText = '';
  CourseWithLanguageResponse? _courseWithLanguageResponse;
  var _language = 'en';
  String get getLanguage {
    return _language;
  }

  void refresh(){
    notifyListeners();
  }

  CourseWithLanguageResponse get getLanguageCourses {
    return _courseWithLanguageResponse!;
  }

  CourseResponse get getCourseByLanguage {
    if(_language=='en') {
      return _courseWithLanguageResponse!.en!;
    } else {
      return _courseWithLanguageResponse!.fr!;
    }
  }

  void changeLanguage(String lang) {
    cacheHelper.saveAnyStringToCache(lang, 'lang');
    _language= lang;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading= value;
    notifyListeners();
  }

  void setHasError(bool value) {
    hasError= value;
    notifyListeners();
  }


  void setError(String value) {
    errorText= value;
    notifyListeners();
  }

  void setupCourseLanguages() async {
    
    try{
      print('AKBR setup is happening');
      var prefs = await SharedPreferences.getInstance();
      bool notFirstLaunch = prefs.getBool('notFirstLaunch') ?? false;
      if(_courseWithLanguageResponse == null) notFirstLaunch = false;
      print('AKBR setup is happening 2. NotFirstLaunch is:'+notFirstLaunch.toString());
      // print('AKBR setup is happening 2. _courseWithLanguageResponse is:'+_courseWithLanguageResponse!.en!.courses.toString());
      if(notFirstLaunch) return;
      setHasError(false);
      setLoading(true);
      print('AKBR setup is happening 3');
      CourseWithLanguageResponse courseWithLanguageResponse = await apiService.fetchCoursesFromServer();
      _courseWithLanguageResponse= courseWithLanguageResponse;
      print('AKBR setup is happening 4');
      prefs.setBool('notFirstLaunch',true);
      setLoading(false);
    }catch(e, st){
      print('AKBR steup ERROR IS HERE:'+ st.toString());
      setHasError(true);
      setError('Could not load courses, error: '+ e.toString());
      setLoading(false);

    }
    notifyListeners();
  }
}