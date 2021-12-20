import 'package:flutter/material.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/course_with_language_response.dart';
import 'package:youth_action_handbook/repository/cache_helper.dart';

class LanguageProvider extends ChangeNotifier {
  CacheHelper cacheHelper = CacheHelper();
  CourseWithLanguageResponse? _courseWithLanguageResponse;
  var _language = 'en';
  String get getLanguage {
    return _language;
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

  void setupCourseLanguages(CourseWithLanguageResponse courseWithLanguageResponse) {
    _courseWithLanguageResponse= courseWithLanguageResponse;
    notifyListeners();
  }
}