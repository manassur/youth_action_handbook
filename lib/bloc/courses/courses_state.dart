import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/course_with_language_response.dart';

abstract class CoursesState extends Equatable {
  @override
  List<Object> get props => [];
}

class CoursesInitialState extends CoursesState {

  @override
  List<Object> get props => [];
}

class CoursesLoadingState extends CoursesState {
  @override
  List<Object> get props => [];
}

class CoursesLoadedState extends CoursesState {
 final List<Courses>? courses;
 final CourseWithLanguageResponse? courseWithLanguageResponse;
 final  String? message;
  CoursesLoadedState({@required this.courses, this.message,this.courseWithLanguageResponse});
  @override
  List<Object> get props => [];
}

class CoursesLoadFailureState extends CoursesState {
  final String? error;

  CoursesLoadFailureState({@required this.error});

  @override
  List<Object> get props => [error.toString()];
}
