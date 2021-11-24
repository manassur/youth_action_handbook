import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';

class LessonItemCard extends StatefulWidget {
  final Lessons? lesson;
  final String? courseId,courseName;
  const LessonItemCard({Key? key, this.lesson,this.courseId,this.courseName}) : super(key: key);

  @override
  _LessonItemCardState createState() => _LessonItemCardState();
}

class _LessonItemCardState extends State<LessonItemCard> {
  VideoPlayerController? _controller;
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  bool? _hasViewed;

  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);
    _hasViewedLesson();
    _initializeVideoPlayer();
  }

  _initializeVideoPlayer() async{
    if(widget.lesson!.video!.isNotEmpty){
      _controller = VideoPlayerController.network(widget.lesson!.video!)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      // _controller!.addListener(() {
      //   setState(() {});
      // });
    }
  }


  @override
  void dispose() {
    super.dispose();
    if(widget.lesson!.video!.isNotEmpty){
      _controller!.dispose();}
  }

  _hasViewedLesson() async {
    bool hasViewed = await dbservice!.hasViewedLesson(widget.lesson!.id!,widget.courseId!);
    if (mounted) {
      setState(() {
        _hasViewed = hasViewed;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        dbservice!.addLessonForUser(widget.lesson!,widget.courseId!,widget.courseName!);

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
                 { return  FractionallySizedBox(
                  heightFactor: 0.95,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent
                        ),
                        child:Center(child: Text(widget.lesson!.title!,style:TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: AppColors.colorBluePrimary)))
                      ),
                      Stack(
                        children: [
                          widget.lesson!.video!.isNotEmpty? Center(
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
                                        visible:widget.lesson!.video!.isNotEmpty,
                                        child:widget.lesson!.video!.isNotEmpty? Center(child:_controller!.value.isPlaying?Icon(Icons.pause_circle_filled_sharp,color:Colors.white,size: 60,): Icon(Icons.play_circle_fill,color:Colors.white,size: 60,)):Container())),
                            )
                          ),

                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child:  Container(
                                  child: widget.lesson!.video!.isNotEmpty? Container(
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
                                data: widget.lesson!.lesson,
                                tagsList: Html.tags..remove(Platform.isAndroid ? "iframe" : "video")
                            )
                        ),
                      ),
                    ],
                  ),
                );}
              );
            });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(4, 6)
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           widget.lesson!.video!.isNotEmpty? IconButton(
              icon: Icon(Icons.play_circle_fill_outlined,
                  color: AppColors.colorPurple),
              onPressed: (){
              },
            ):Container(),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // "What is Peace Education?",
                    widget.lesson!.title!,
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorBluePrimary),),
                  SizedBox(height: 10,),

                  Text(
                    widget.lesson!.duration!,
                    style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 15,
                        color: AppColors.colorBluePrimary),),
                ],
              ),
            ),

           _hasViewed==true? Icon(Icons.check_circle,color: AppColors.colorYellow,): CircularPercentIndicator(
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
    );
  }
}
