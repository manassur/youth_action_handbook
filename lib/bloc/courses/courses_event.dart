import 'package:equatable/equatable.dart';

abstract class CoursesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCoursesEvent extends CoursesEvent {
   @override
  List<Object> get props => [];
}

class FetchUserCoursesEvent extends CoursesEvent {
  final  String? uid;
  FetchUserCoursesEvent({required this.uid});

  @override
  List<Object> get props => [];
}

