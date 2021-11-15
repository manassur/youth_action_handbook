import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:youth_action_handbook/models/news_response.dart';

abstract class NewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewsInitialState extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoadingState extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoadedState extends NewsState {
 final List<News>? news;
 final  String? message;
  NewsLoadedState({@required this.news, this.message});

  @override
  List<Object> get props => [];
}

class NewsLoadFailureState extends NewsState {
  final String? error;
  NewsLoadFailureState({@required this.error});

  @override
  List<Object> get props => [error.toString()];
}
