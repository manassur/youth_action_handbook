import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youth_action_handbook/bloc/courses/courses_bloc.dart';
import 'package:youth_action_handbook/bloc/courses/courses_event.dart';
import 'package:youth_action_handbook/bloc/courses/courses_state.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/firestore_models/lesson_user_model.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/models/firestore_models/recently_viewed_lessons_model.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/screens/individual_course.dart';
import 'package:youth_action_handbook/screens/test.dart';
import 'package:youth_action_handbook/services/api_service.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CourseFragment extends StatefulWidget {
  const CourseFragment({Key? key}) : super(key: key);

  @override
  _CourseFragmentState createState() => _CourseFragmentState();
}

class _CourseFragmentState extends State<CourseFragment> {
  ScrollController? _scrollController;
  double kExpandedHeight = 120;

  double get _horizontalTitlePadding {
    const kBasePadding = 15.0;
    const kMultiplier = 0.5;

    if (_scrollController!.hasClients) {
      if (_scrollController!.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        return kBasePadding;
      }

      if (_scrollController!.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        return (kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding+40;
      }

      // In case 0%-50% of the expanded height is viewed
      return (_scrollController!.offset - (kExpandedHeight / 2)) * kMultiplier +
          kBasePadding+40;
    }

    return kBasePadding;
  }
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<RecentlyViewedLesson>>? recentlyViewedFuture;
  CoursesBloc? coursesBloc;
  ApiService? _apiService;
  Future<Lessons>? courseFuture;
  VideoPlayerController? _controller;

  _initializeVideoPlayer(String url) async{
    if(url.isNotEmpty){
      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      // _controller!.addListener(() {
      //   setState(() {});
      // });
    }
  }


  // @override
  // void dispose() {
  //   super.dispose();
  //   if(widget.lesson!.video!.isNotEmpty){
  //     _controller!.dispose();}
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);

    recentlyViewedFuture = dbservice!.getMostRecentCourse();

    // use this to populate topics
    // dbservice!.createTopic('Facts');
    coursesBloc= BlocProvider.of<CoursesBloc>(context);
    coursesBloc!.add(FetchUserCoursesEvent(uid: _currentUserId));

    _apiService= ApiService();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller:  _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              expandedHeight: kExpandedHeight,
              leading: IconButton(
                icon: SvgPicture.asset('assets/menu_alt_03.svg',color: Colors.black54,), // set your color here
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      builder: (builder){
                        return LanguagePicker();
                      }
                  );
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                  titlePadding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: _horizontalTitlePadding),
                title: RichText(
                  text: TextSpan(
                      text: 'Study',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                      children: const <TextSpan>[
                      ]
                  ),
                ),
              )
            ),
          ];
        }, body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("it's a great day to learn something new.",
                style: TextStyle(fontWeight: FontWeight.w100,
                    fontSize: 12,
                    color: Colors.black87),),
              SizedBox(height: 25,),
              Text("Recently viewed", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorBluePrimary,
                  fontSize: 20),),
              FutureBuilder<List<RecentlyViewedLesson>>(
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
                  { return Center(child: Text('Could not fetch recent lessons at this time'+snapshot.error.toString()));}

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx,pos){
                        return GestureDetector(
                          onTap: () {
                            courseFuture =  _apiService!.getCourseByCourseId(snapshot.data![pos].courseId!,snapshot.data![pos].lessonId!);
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.white,
                                builder: (context) {

                                  return  StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState )
                                      {
                                      return  FutureBuilder<Lessons>(
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
                                            { return Center(child: Text('Could not fetch recent lessons at this time'+snapshot.error.toString()));}
                                            _initializeVideoPlayer(snapshot.data!.video!);
                                             return  FractionallySizedBox(
                                              heightFactor: 0.95,
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 50,
                                                      decoration: const BoxDecoration(
                                                          color: Colors.transparent
                                                      ),
                                                      child:Center(child: Text(snapshot.data!.title!,style:TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: AppColors.colorBluePrimary)))
                                                  ),
                                                  Stack(
                                                    children: [
                                                      snapshot.data!.video!.isNotEmpty? Center(
                                                        child: _controller!.value.isInitialized
                                                            ? AspectRatio(
                                                          aspectRatio: _controller!.value.aspectRatio,
                                                          child: VideoPlayer(_controller!),
                                                        )
                                                            : Container(),
                                                      ):Container(),
                                                      Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment.center,
                                                            child:  InkWell(
                                                                onTap:(){
                                                                  setState(() {
                                                                    _controller!.value.isPlaying
                                                                        ? _controller!.pause()
                                                                        : _controller!.play();
                                                                  });
                                                                },
                                                                child: Visibility(
                                                                    visible:snapshot.data!.video!.isNotEmpty,
                                                                    child:snapshot.data!.video!.isNotEmpty? Center(child:_controller!.value.isPlaying?Icon(Icons.pause_circle_filled_sharp,color:Colors.white,size: 60,): Icon(Icons.play_circle_fill,color:Colors.white,size: 60,)):Container())),
                                                          )
                                                      ),

                                                      Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment.bottomCenter,
                                                            child:  Container(
                                                              child: snapshot.data!.video!.isNotEmpty? Container(
                                                                child: _controller!.value.isInitialized?

                                                                VideoProgressIndicator(_controller!, allowScrubbing: true,colors: VideoProgressColors(
                                                                    backgroundColor: Colors.grey.shade200,
                                                                    bufferedColor: Colors.grey,
                                                                    playedColor: AppColors.colorGreenPrimary
                                                                ) ,
                                                                ):Container(),
                                                              ):Container(),
                                                            )
                                                        ),
                                                      ),

                                                    ],
                                                  ),

                                                  Expanded(
                                                    child: Container(
                                                        height: double.infinity,
                                                        child: Html(
                                                            data: snapshot.data!.lesson,
                                                            tagsList: Html.tags..remove(Platform.isAndroid ? "iframe" : "video")
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          future: courseFuture,
                                        );

                                      }
                                  );
                                });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Course: ${snapshot.data![pos].courseName!}", style: const TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 12,
                                  color: Colors.black54),),
                              SizedBox(height: 15,),
                              Container(
                                padding: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                    color: AppColors.colorGreenPrimary,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.colorGreenPrimary.withOpacity(
                                              0.2),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: Offset(4, 6)
                                      )
                                    ]
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.play_circle_fill_outlined,
                                        color: Colors.white),
                                    SizedBox(width:20),
                                    Expanded(
                                      flex: 5,
                                      child: Text(snapshot.data![pos].lessonTitle!, style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                    ),
                                    Spacer(),
                                    CircularPercentIndicator(
                                      radius: 20.0,
                                      lineWidth: 1.0,
                                      percent: 0.8,
                                      center: Text(""),
                                      progressColor: Colors.white,
                                      backgroundColor: Colors.grey.shade300,
                                    )

                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  );
                },
                future: recentlyViewedFuture,
              ),


              SizedBox(height: 25,),
              Text("My Courses", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorBluePrimary),),
              SizedBox(height: 10,),
              Text("Continue from where you stopped", style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 12,
                  color: Colors.black54),),
              SizedBox(height: 10,),
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
                        return
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.courses!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx,pos){
                                return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                          IndividualCourseScreen(courses: state.courses![pos],)));
                                    },
                                    child: OpenTrainingCard(courseModel:state.courses![pos]));
                              });
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


            ],
          ),
        ),
      ),),
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
