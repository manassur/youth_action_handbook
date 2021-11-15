// import 'package:flutter/material.dart';
// import 'package:youth_action_handbook/data/app_colors.dart';
// import 'package:youth_action_handbook/widgets/custom_tab.dart';
//
// import 'induvidual_course_about.dart';
// import 'induvidual_course_evaluation.dart';
//
// class Test extends StatefulWidget {
//
//   @override
//   _TestState createState() => _TestState();
// }
//
// class _TestState extends State<Test>  with TickerProviderStateMixin  {
//   int selected = 0;
//   late TabController tabController;
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(
//       initialIndex: 0,
//       length: 3,
//       vsync: this,
//     );
//   }
//   List<String> categoriesList =[
//     "Lessons",
//     "About",
//     "Evaluation"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData queryData;
//     queryData = MediaQuery.of(context);
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (context, value) {
//           return [
//             SliverAppBar(
//               floating: true,
//               pinned: true,
//               backgroundColor: Color(0xFFF7FBFe),
//                 expandedHeight: 350,
//                 elevation: 0,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Column(
//                     children: [
//                       Expanded(
//                         child: Stack(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage(
//                                       'assets/group_img.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                             Container(color: Colors.black54.withOpacity(0.3),),
//                             Center(child: Icon(Icons.play_circle_fill,color:Colors.white,size: 60,)),
//                             Positioned.fill(
//                               child: Align(
//                                 alignment: Alignment.bottomLeft,
//                                 child:  Container(
//                                     margin: EdgeInsets.only(right: 150),
//                                     height:13,color:AppColors.colorGreenPrimary),
//
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 80,)
//                     ],
//                   ),
//                 ),
//                 bottom: PreferredSize(
//                 preferredSize:Size(queryData.size.width,60),
//                 child: SizedBox(
//                   height: 60,
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: categoriesList.length,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (ctx,pos){
//                         return GestureDetector(
//                           onTap: (){
//                             setState(() {
//                               selected = pos;
//                             });
//                             tabController.animateTo(selected);
//                           },
//                           child: CustomTab(
//                               title: categoriesList[pos],
//                               isSelected:pos==selected
//                           ),
//                         );
//                       }
//                   ),
//                 ),
//               )
//             ),
//           ];
//         },
//         body: TabBarView(
//             controller: tabController,
//             children: [
//               IndividualCourseAbout(),
//               Container(),
//               IndividualCourseEvaluation(),
//             ]),
//       ),
//     );
//
//   }
// }