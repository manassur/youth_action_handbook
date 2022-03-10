import 'package:youth_action_handbook/models/course_response.dart';

class CourseWithLanguageResponse {
  CourseResponse? en;
  CourseResponse? fr;

  CourseWithLanguageResponse({this.en, this.fr});

  CourseWithLanguageResponse.fromJsonOld(Map<String, dynamic> json) {
    en = json['en'] != null ? new CourseResponse.fromJson(json['en']) : null;
    fr = json['fr'] != null ? new CourseResponse.fromJson(json['fr']) : null;
  }

  CourseWithLanguageResponse.fromJson(Map<String, dynamic> json) {
    try {
      en = json['en'] != null ? new CourseResponse.fromJson(json['en']) : CourseResponse.fromJson(json);
      fr = json['fr'] != null ? new CourseResponse.fromJson(json['fr']) : CourseResponse.fromJson(json);
    } on Exception catch (e, stacktrace) {
      print('AKBR ERROR CREATING CLANGRESPONSE : '+e.toString()+' at:'+stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.en != null) {
      data['en'] = this.en!.toJson();
    }
    if (this.fr != null) {
      data['fr'] = this.fr!.toJson();
    }
    return data;
  }
}


