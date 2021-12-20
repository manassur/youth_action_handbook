import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/bloc/courses/courses_bloc.dart';
import 'package:youth_action_handbook/bloc/courses/courses_event.dart';
import 'package:youth_action_handbook/bloc/courses/courses_state.dart';
import 'package:youth_action_handbook/bloc/news/news_bloc.dart';
import 'package:youth_action_handbook/bloc/news/news_event.dart';
import 'package:youth_action_handbook/bloc/news/news_state.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/repository/language_provider.dart';
import 'package:youth_action_handbook/screens/individual_course.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';

import 'topic_posts.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  CoursesBloc? coursesBloc;
  NewsBloc? newsBloc;
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<Topic>>? topicFuture;

  @override
  void initState() {
    coursesBloc= BlocProvider.of<CoursesBloc>(context);
    coursesBloc!.add(FetchCoursesEvent());

    newsBloc= BlocProvider.of<NewsBloc>(context);
    newsBloc!.add(FetchNewsEvent());

    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);

    topicFuture =  dbservice!.getTopics();

    //dbservice!.createTopic('Family');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
          icon: SvgPicture.asset('assets/menu_alt_03.svg',color: Colors.black54,), // set your color here
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                builder: (builder){
                  return const LanguagePicker();
                }
            );
          },
    ),
    actions: [
      MenuForAppBar(),
    ],
    ),
      body:  (appUser==null)? const Loading() : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Good Morning, ',
                    style: const TextStyle(
                        color: Colors.black, fontSize: 25,fontWeight: FontWeight.w900),
                    children: <TextSpan>[
                      TextSpan(text: (appUser.name).split(" ")[0],
                        style: TextStyle(
                            color: AppColors.colorGreenPrimary, fontSize: 25,fontWeight: FontWeight.w900),
                      ),
                    ]
                ),
              ),
              const SizedBox(height: 10,),
              const Text("it's a great day to learn something new.",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 12,color: Colors.black87),),
              const SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    flex: 9,
                      child: (  Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextFormField(
                              style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w100),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "Search Anything",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset('assets/search.svg',color: Colors.grey,width: 20,height: 20,),
                                ),
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle:  TextStyle(color: Colors.grey.shade400,fontSize: 15,fontWeight: FontWeight.w100),

                              )))))),
                    Expanded(
                      flex: 2,
                      child: SvgPicture.asset('assets/slider_03.svg'))
                ],
              ),
            const  SizedBox(height: 25,),
              Text("Recommended courses",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
             const SizedBox(height: 10,),
              SizedBox(
                height: 300,
                child: BlocListener<CoursesBloc, CoursesState>(
                  listener: (context, state){
                    if ( state is CoursesLoadedState && state.message != null ) {
                        }
                    else if ( state is CoursesLoadFailureState ) {
                      Scaffold.of ( context ).showSnackBar ( const SnackBar (
                        content: Text ( "Could not load courses  at this time" ) , ) );
                    }
                  },
                  child: BlocBuilder<CoursesBloc, CoursesState>(
                    builder: (context, state) {
                      if ( state is CoursesInitialState ) {
                        return buildLoading ( );
                      } else if ( state is CoursesLoadingState ) {
                        return buildLoading ( );
                      } else if ( state is CoursesLoadedState ) {

                        return Consumer<LanguageProvider>(
                              builder: (context, lang, child) {
                              lang.setupCourseLanguages(state.courseWithLanguageResponse!);
                              var courseResponse =lang!.getCourseByLanguage;
                          return ListView.builder(
                                shrinkWrap: true,
                                itemCount: courseResponse.courses!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx,pos){
                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                       IndividualCourseScreen(courses: courseResponse.courses![pos],)));
                                    },
                                      child: OpenTrainingCard(courseModel:courseResponse.courses![pos]));
                                });
    }
                          );
                      } else if ( state is CoursesLoadFailureState ) {
                        return buildErrorUi ("Oops! Could not load courses at this time" );
                      }
                      else {
                        return buildErrorUi ( "Something went wrong!" );
                      }
                    },
                  ),
                ),
              ),

             const SizedBox(height: 25,),
              Text("Popular topics",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
             const SizedBox(height: 10,),

              SizedBox(
                height: 150,
                child:
                FutureBuilder<List<Topic>>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.hasData == null) {
                      return Container();
                    }else if( snapshot.connectionState == ConnectionState.waiting){
                      return  const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError)
                    { return Center(child: Text('Could not fetch topics at this time'+snapshot.error.toString()));}

                    return   GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 1.0,
                            mainAxisSpacing: 3.0,
                            childAspectRatio: 0.3,


                        ),
                    shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx,pos){
                          return InkWell(
                            onTap:(){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      TopicPosts(topic: snapshot.data![pos])));

                            },
                            child: TopicCard(
                              topicModel: snapshot.data![pos],
                              scaleFactor: 0.9,
                            ),
                          );
                        }
                    );
                  },
                  future: topicFuture,
                ),

              ),
              // GridView.builder(
              //   itemBuilder: (ctx,pos){
              //     return PopularItemCard(popularcategoryModel: AppTexts.popularCategoryItems[pos]);
              //   },
              //   padding: const EdgeInsets.all(10.0),
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       crossAxisSpacing: 15.0,
              //       mainAxisSpacing: 15.0,
              //       childAspectRatio: 2.5
              //   ),
              //   itemCount: AppTexts.popularCategoryItems.length,
              //
              // ),
              const SizedBox(height: 25,),
              Text("Updates",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary,),),
              const SizedBox(height: 10,),

              BlocListener<NewsBloc, NewsState>(
                listener: (context, state){
                  if ( state is NewsLoadedState && state.message != null ) {
                  }
                  else if ( state is NewsLoadFailureState ) {
                    Scaffold.of ( context ).showSnackBar ( const SnackBar (
                      content: Text ( "Could not load news update at this time" )) );
                  }
                },
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if ( state is NewsInitialState ) {
                      return buildLoading ( );
                    } else if ( state is NewsLoadingState ) {
                      return buildLoading ( );
                    } else if ( state is NewsLoadedState ) {
                      return
                        ListView.separated(
                            separatorBuilder: (ctx,pos){
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(),
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.news!.length,
                            itemBuilder: (ctx,pos){
                              return UpdatesCard(newsUpdate:state.news![pos] ,
                              );
                            }
                        );
                    } else if ( state is NewsLoadFailureState ) {
                      return buildErrorUi (state.error.toString() );
                    }
                    else {
                      return buildErrorUi ( "Something went wrong!" );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget buildLoading ( ) {
    return const Center (
      child: CircularProgressIndicator () ,
    );
  }

  Widget buildErrorUi ( String message ) {
    return Center (
      child: Text ( message , style: const  TextStyle ( color: Colors.black, fontSize: 15 ) ,
      ) ,
    );
  }

}
