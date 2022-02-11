import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';

class LessonContent extends StatefulWidget {
  final Lessons? lesson;
  final String? courseId,courseName;
  const LessonContent({Key? key, this.lesson,this.courseId,this.courseName}) : super(key: key);


  @override
  _LessonContentState createState() => _LessonContentState();
}

class _LessonContentState extends State<LessonContent> {
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
    // _hasViewedLesson();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
            icon: Icon(Icons.arrow_back_ios,color: Colors.black87,)),
        title: Text('Lesson Content',style: TextStyle(color: Colors.black87),),
      ),
      body: Column(
        children: [
          Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                child: SingleChildScrollView(
                  child: Html(
                    data: widget.lesson!.lesson,

                    // tagsList: Html.tags..remove(Platform.isAndroid ? "iframe" : "video")
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
