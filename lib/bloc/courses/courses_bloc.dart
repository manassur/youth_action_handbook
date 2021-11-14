import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youth_action_handbook/bloc/courses/courses_event.dart';
import 'package:youth_action_handbook/bloc/courses/courses_state.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/services/api_service.dart';

class CoursesBloc extends Bloc<CoursesEvent,CoursesState>{
 final ApiService apiService;

  CoursesBloc( {required this.apiService}) : super(CoursesInitialState());

CoursesState get initialState => CoursesInitialState();

@override
Stream<CoursesState> mapEventToState(CoursesEvent event) async* {
  if (event is FetchCoursesEvent) {
    yield CoursesLoadingState();
    try{
     CourseResponse courseResponse = await apiService.fetchCourses();
      yield CoursesLoadedState(courses:courseResponse.courses, message: "Courses Updated");
    }catch(e){
      yield CoursesLoadFailureState(error: e.toString());
    }
  }
}

}