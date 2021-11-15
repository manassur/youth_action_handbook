import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youth_action_handbook/bloc/news/news_event.dart';
import 'package:youth_action_handbook/bloc/news/news_state.dart';
import 'package:youth_action_handbook/models/news_response.dart';
import 'package:youth_action_handbook/services/api_service.dart';

class NewsBloc extends Bloc<NewsEvent,NewsState>{
 final ApiService apiService;

  NewsBloc( {required this.apiService}) : super(NewsInitialState());

NewsState get initialState => NewsInitialState();

@override
Stream<NewsState> mapEventToState(NewsEvent event) async* {
  if (event is FetchNewsEvent) {
    yield NewsLoadingState();
    try{
     NewsResponse newsResponse = await apiService.fetchNewsUpdate();
      yield NewsLoadedState(news:newsResponse.news, message: "News Updated");
    }catch(e){
      yield NewsLoadFailureState(error: e.toString());
    }
  }
}

}