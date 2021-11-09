import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/screens/induvidual_course_about.dart';
import 'package:youth_action_handbook/screens/induvidual_course_evaluation.dart';
import 'package:youth_action_handbook/widgets/custom_tab.dart';
import 'package:youth_action_handbook/widgets/topic_category_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class IndividualCourseScreen extends StatefulWidget {
  const IndividualCourseScreen({Key? key}) : super(key: key);

  @override
  _IndividualCourseScreenState createState() => _IndividualCourseScreenState();
}

class _IndividualCourseScreenState extends State<IndividualCourseScreen> with TickerProviderStateMixin {
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
  List<String> categoriesList =[
    "Lessons",
    "About",
    "Evaluation"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(300),
            child:  AppBar(
              leading: IconButton(
                icon:Icon(Icons.keyboard_backspace,color:Colors.white),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              flexibleSpace: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/group_img.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(color: Colors.black54.withOpacity(0.3),),
                    Center(child: Icon(Icons.play_circle_fill,color:Colors.white,size: 60,)),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child:  Container(
                            margin: EdgeInsets.only(right: 150),
                            height:13,color:AppColors.colorGreenPrimary),

                      ),
                    ),

                  ],
                ),
            ),
          ),
          body: Scaffold(
          backgroundColor: Color(0xFFF7FBFe),
            appBar:AppBar(
              toolbarHeight: 80,
              leading: Container(),
              elevation: 0,
              backgroundColor: Color(0xFFF7FBFe),
            bottom:PreferredSize(
                preferredSize:Size.fromHeight(50),
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
            body: TabBarView(
              controller: tabController,
                children: [
              IndividualCourseAbout(),
              Container(),
              IndividualCourseEvaluation(),
            ]),
          ));


  }
}
