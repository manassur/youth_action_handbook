import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/screens/individual_course.dart';
import 'package:youth_action_handbook/screens/test.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));

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
              Text("Continue from where you stopped?", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorBluePrimary,
                  fontSize: 20),),
              SizedBox(height: 10,),
              Text("Course: Peace Education", style: TextStyle(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.play_circle_fill_outlined,
                        color: Colors.white),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("What is Peace Education?", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),),
                        Text("2:30", style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                            color: Colors.white),),
                      ],
                    ),
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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: AppTexts.trainingItems.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, pos) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Test()),
                          );
                        },
                        // child: OpenTrainingCard(
                        //   color: AppTexts.trainingItems[pos].color,
                        //   icon: AppTexts.trainingItems[pos].icon,
                        //   textCount: AppTexts.trainingItems[pos].textCount,
                        //   textHeader: AppTexts.trainingItems[pos]
                        //       .textHeader,
                        // ),
                      );
                    }
                ),
              ),

            ],
          ),
        ),
      ),),
    );
  }
}
