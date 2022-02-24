import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/screens/individual_course_lesson.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/custom_tab.dart';

import 'induvidual_course_about.dart';
import 'induvidual_course_evaluation.dart';

class IndividualCourseScreen extends StatefulWidget {

  final Courses? courses;

  const IndividualCourseScreen({Key? key, required this.courses,}) : super(key: key);
  @override
  _IndividualCourseScreenState createState() => _IndividualCourseScreenState();
}

class _IndividualCourseScreenState extends State<IndividualCourseScreen>  with TickerProviderStateMixin  {
  int selected = 0;
  late TabController tabController;


  @override
  void initState() {
    super.initState();


    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );


  }
  @override
  void dispose() {
    super.dispose();
  }
  List<String> categoriesList =[
    "Lessons",
    "About",
    "Evaluation"
  ];
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Color(0xFFF7FBFe),
                expandedHeight: 350,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    // image: NetworkImage(widget.courses!.image!),
                                    image: CachedNetworkImageProvider((widget.courses!.image! == null || widget.courses!.image! == '')?'https://dev.silbaka.com/laptop.png':widget.courses!.image!),
                                    fit: BoxFit.fill,
                                  ),
                                )
                            ),

                          ],
                        ),
                      ),
                      //  _ControlsOverlay(controller: _controller),
                      SizedBox(height: 80,)
                    ],
                  ),
                ),

                bottom: PreferredSize(
                  preferredSize:Size(queryData.size.width,60),
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categoriesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx,pos){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                selected = pos;
                              });
                              tabController.animateTo(selected);
                            },
                            child: CustomTab(
                                title: categoriesList[pos],
                                isSelected:pos==selected
                            ),
                          );
                        }
                    ),
                  ),
                )
            ),
          ];
        },
        body: TabBarView(
            controller: tabController,
            children: [
              IndividualCourseLesson(courses: widget.courses!,),
              IndividualCourseAbout( courses: widget.courses!,),
              IndividualCourseEvaluation(courses: widget.courses!),
            ]),
      )
    );

  }
}