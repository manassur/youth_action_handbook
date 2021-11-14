import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth_action_handbook/bloc/courses/courses_bloc.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/screens/course.dart';
import 'package:youth_action_handbook/screens/forum.dart';
import 'package:youth_action_handbook/services/api_service.dart';
import 'package:youth_action_handbook/widgets/custom_bottom_nav_item.dart';

import 'about.dart';
import 'home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex= 0;
  List<Widget> screen = [

    BlocProvider<CoursesBloc>(
      create: (context) =>
      CoursesBloc(apiService: ApiService()),
        child: HomeFragment()
    ),
    CourseFragment(),
    ForumFragment(),
    AboutFragment(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.white,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: AppColors.colorBluePrimary,
          unselectedItemColor: Colors.grey[400],
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w200,fontSize: 12),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w400,color: AppColors.colorBluePrimary,fontSize: 12),
          showUnselectedLabels: true,
          showSelectedLabels: true,
          iconSize: 24,
          onTap: (index){
            setState(() {
              currentIndex=index;
            });
          },
          items: [
            BottomNavigationBarItem(label:'Home',icon: CustomBottomNavItem(icon:'assets/home.svg',isSelected:currentIndex==0)),
            BottomNavigationBarItem(label:'Study',icon: CustomBottomNavItem(icon:'assets/note.svg',isSelected:currentIndex==1)),
            BottomNavigationBarItem(label:'Forum',icon:CustomBottomNavItem(icon:'assets/comment.svg',isSelected:currentIndex==2)),
            BottomNavigationBarItem(label:'About',icon:CustomBottomNavItem(icon:'assets/info_circle_outline.svg',isSelected:currentIndex==3)),
          ],
        ),
      )
    );
  }
}
