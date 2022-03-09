import 'dart:io';

import 'package:flutter/material.dart';
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
      setHasError(false);
      setLoading(true);
      CourseWithLanguageResponse courseWithLanguageResponse = await apiService.fetchCoursesFromServer();
      _courseWithLanguageResponse= courseWithLanguageResponse;
      setLoading(false);
    }on SocketException catch(e){
      setHasError(true);
      setError('Could not load courses, error: '+ e.message.toString());
      setLoading(false);

    }catch(e){
      setHasError(true);
      setError('Could not load courses, error: '+ e.toString());
      setLoading(false);

    }
    notifyListeners();
  }
}