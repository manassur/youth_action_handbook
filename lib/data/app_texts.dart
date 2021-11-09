import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/induvidual_comment_model.dart';
import 'package:youth_action_handbook/models/open_training_model.dart';
import 'package:youth_action_handbook/models/popular_category_model.dart';
import 'package:youth_action_handbook/models/single_choice_model.dart';
import 'package:youth_action_handbook/models/topic_model.dart';
import 'package:youth_action_handbook/models/trending_post_model.dart';
import 'package:youth_action_handbook/models/updates_model.dart';

class AppTexts{
  static const String youthActionHandbook ='Youth Action Handbook';
  static const String next ='Next';
  static const String save ='Save';
  static const String email ='Email';
  static const String password ='Password';
  static const String login ='Log in';
  static const String loginWithGoogle ='Log with Google';
  static const String loginWithApple ='Log with Apple';
  static const String signUpPrompt ='New User? Sign Up here';
  static const String signUp ='Sign Up';
  static const String forgotPassword ='forgot password?';
  static const String sendPasswordResetEmail ='Send Password Reset Email';
  static const String gettingStarted ='Getting Started';


  static const String enterCurrentPassword ='Enter current Password to confirm change:';

  static const String english = 'English';
  static const String french = 'French';

  static const String female = 'Female';
  static const String male = 'Male'; 
  static const String other = 'Other';

  static  List<OpenTrainingModel> trainingItems = [
    OpenTrainingModel(icon: 'assets/saly1.png',color: AppColors.colorYellow,textHeader: 'Project management while working remotely',textCount: '1,250 Enrolled'),
    OpenTrainingModel(icon: 'assets/saly2.png',color: AppColors.colorGreenPrimary,textHeader: 'Peace Ecucation',textCount: '1,250 Enrolled')

  ];

  static  List<PopularcategoryModel> popularCategoryItems = [
    PopularcategoryModel(icon: 'assets/saly-21.png',color: AppColors.colorGreenPrimary,textHeader: 'Peace',textCount: '35 Courses'),
    PopularcategoryModel(icon: 'assets/saly-25.png',color: AppColors.colorBluePrimary,textHeader: 'Finance',textCount: '21 Courses'),
    PopularcategoryModel(icon: 'assets/saly-26.png',color: AppColors.colorPurple,textHeader: 'Management',textCount: '25 Courses'),
    PopularcategoryModel(icon: 'assets/saly-28.png',color: AppColors.colorYellow,textHeader: 'Development',textCount: '20 Courses')

  ];

  static  List<UpdatesModel> updateItems = [
    UpdatesModel(icon: 'assets/img1.png',textHeader: 'Fund the girl child campaign 2021 launched'),
    UpdatesModel(icon: 'assets/img2.png',textHeader: 'Peace talks commence in DRC'),
    UpdatesModel(icon: 'assets/img3.png',textHeader: 'UN women sponsor 2000 girls every year'),
  ];

  static  List<TopicModel> topicItems = [
    TopicModel(count: '30',title: 'GBV',color: AppColors.colorYellow,textColor: AppColors.colorBluePrimary),
    TopicModel(count: '32',title: '#Peace',color: AppColors.colorGreenPrimary,textColor: AppColors.colorBluePrimary),
    TopicModel(count: '32',title: 'Rape',color: AppColors.colorBluePrimary,textColor: Colors.white),
  ];

  static  List<TrendingPostModel> trendingItems = [
    TrendingPostModel(question: 'What are the policies on peace in western kenya ?',name: 'John Muhereza',description:'My name is john and i have been doing some research on peace policy in kenya , but i can;t seem to find any'),
    TrendingPostModel(question: 'What are the policies on peace in western kenya ?',name: 'John Muhereza',description:'My name is john and i have been doing some research on peace policy in kenya , but i can;t seem to find any'),
    TrendingPostModel(question: 'What are the policies on peace in western kenya ?',name: 'John Muhereza',description:'My name is john and i have been doing some research on peace policy in kenya , but i can;t seem to find any'),
    TrendingPostModel(question: 'What are the policies on peace in western kenya ?',name: 'John Muhereza',description:'My name is john and i have been doing some research on peace policy in kenya , but i can;t seem to find any'),

  ];

  static List<Locale> supportedLocales = [
              const Locale("af"),
              const Locale("am"),
              const Locale("ar"),
              const Locale("az"),
              const Locale("be"),
              const Locale("bg"),
              const Locale("bn"),
              const Locale("bs"),
              const Locale("ca"),
              const Locale("cs"),
              const Locale("da"),
              const Locale("de"),
              const Locale("el"),
              const Locale("en"),
              const Locale("es"),
              const Locale("et"),
              const Locale("fa"),
              const Locale("fi"),
              const Locale("fr"),
              const Locale("gl"),
              const Locale("ha"),
              const Locale("he"),
              const Locale("hi"),
              const Locale("hr"),
              const Locale("hu"),
              const Locale("hy"),
              const Locale("id"),
              const Locale("is"),
              const Locale("it"),
              const Locale("ja"),
              const Locale("ka"),
              const Locale("kk"),
              const Locale("km"),
              const Locale("ko"),
              const Locale("ku"),
              const Locale("ky"),
              const Locale("lt"),
              const Locale("lv"),
              const Locale("mk"),
              const Locale("ml"),
              const Locale("mn"),
              const Locale("ms"),
              const Locale("nb"),
              const Locale("nl"),
              const Locale("nn"),
              const Locale("no"),
              const Locale("pl"),
              const Locale("ps"),
              const Locale("pt"),
              const Locale("ro"),
              const Locale("ru"),
              const Locale("sd"),
              const Locale("sk"),
              const Locale("sl"),
              const Locale("so"),
              const Locale("sq"),
              const Locale("sr"),
              const Locale("sv"),
              const Locale("ta"),
              const Locale("tg"),
              const Locale("th"),
              const Locale("tk"),
              const Locale("tr"),
              const Locale("tt"),
              const Locale("uk"),
              const Locale("ug"),
              const Locale("ur"),
              const Locale("uz"),
              const Locale("vi"),
              const Locale("zh")
            ];

}