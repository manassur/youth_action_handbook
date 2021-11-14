
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/screens/edit_profile.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:url_launcher/url_launcher.dart';




class AboutFragment extends StatefulWidget {
  @override
  _AboutFragmentState createState() => _AboutFragmentState();
}

class _AboutFragmentState extends State<AboutFragment> {

  _launchhURL() async {
    const url = 'https://punchng.com/advertise-with-us';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  launchAdvertise(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  //PROJECT COLUMN
  List projectItems = [
    {
      "leading_icon": Icons.person_outline,
      "title": "About the project",
      "trailing_icon": Icons.keyboard_arrow_down_sharp,
      "page": AboutFragment(),
    },
    {
      "leading_icon": Icons.notifications_none,
      "title": "Project",
      "trailing_icon": Icons.keyboard_arrow_down_sharp,
      "page": AboutFragment(),
    },
    {
      "leading_icon": Icons.notifications_none,
      "title": "Objectives",
      "trailing_icon": Icons.keyboard_arrow_down_sharp,
      "page": AboutFragment(),
    },
    {
      "leading_icon": Icons.check_circle,
      "title": "Partners",
      "trailing_icon": Icons.keyboard_arrow_down_sharp,
      "page": AboutFragment(),
    },
    {
      "leading_icon": Icons.info_outline,
      "title": "App version",
      "app_version": "1.1.0" ,
      "page": AboutFragment(),
    },

  ];


  //OTHER COLUMN
  List otherItems = [
    {
      "leading_icon": Icons.check_circle,
      "title": "Privacy Policy",
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      // "page":  launchAdvertise(),
    },
    {
      "leading_icon": Icons.info_outline,
      "title": "Terms & Conditions",
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": AboutFragment(),
    },
    {
      "leading_icon": Icons.login_outlined,
      "title": "Sign Out",
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": AboutFragment(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

      //SETTINGS COLUMN
    List settingItems = [
      {
        "leading_icon": Icons.person_outline,
        "title": 'Edit Profile',
        "trailing_icon": Icons.chevron_right,
        "page": RouteNames.editProfile,
      },

      {
        "leading_icon": Icons.email_outlined,
        "title": 'Edit Login Information',
        "trailing_icon": Icons.chevron_right,
        "page": RouteNames.editLogin,
      },
    ];

  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorBluePrimary,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/menu_alt_03.svg',color: Colors.white,), // set your color here
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
        title:  RichText(
          text: TextSpan(
              text: 'About',
              style: TextStyle(
                  color: AppColors.colorYellow, fontSize: 20,fontWeight: FontWeight.w900),
              children: const <TextSpan>[

              ]
          ),
        ),
        actions:  [
          MenuForAppBar(),
        ],
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[

          //SETTINGS COLUMN
          Column(
            children: [
              Container(
                  color: AppColors.colorBlueSecondary,
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("SETTINGS",
                        style: TextStyle(color: Colors.white),),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15.0,),
                child: SizedBox(
                  // height: 210,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: settingItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            settingItems[index]['leading_icon'], color: AppColors.colorPurple,
                          ),
                          title: Text(
                            settingItems[index]['title'],
                          ),
                          trailing: Icon(
                            settingItems[index]['trailing_icon'],color: Colors.black87, size: 18,
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, settingItems[index]['page']);
                          }
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,);
                    },
                  ),
                ),
              ),
            ],
          ),


       
            //PROJECT COLUMN
            Column(
              children: [
                Container(
                      color: AppColors.colorBlueSecondary,
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("THE PROJECT",
                            style: TextStyle(color: Colors.white),),
                        ),
                      )),

                Padding(
                  padding: const EdgeInsets.only(left:15.0, right: 15.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: projectItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            projectItems[index]['leading_icon'], color: AppColors.colorPurple,
                          ),
                          title: Text(
                            projectItems[index]['title'],
                          ),
                          trailing: projectItems[index]['trailing_icon']!=null?
                          Icon(
                            projectItems[index]['trailing_icon'], color: Colors.black, size: 27,
                          )
                              :Text(projectItems[index]['app_version'])
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,);
                    },
                  ),
                ),

              ],
            ),

            //OTHER COLUMN
            Column(
              children: [
                Container(
                    color: AppColors.colorBlueSecondary,
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 35.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("OTHER",
                          style: TextStyle(color: Colors.white),),
                      ),
                    )),

                Padding(
                  padding: const EdgeInsets.only(left:15.0, right: 15.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: otherItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            otherItems[index]['leading_icon'], color: AppColors.colorPurple,
                          ),
                          title: Text(
                            otherItems[index]['title'],
                          ),
                          trailing: Icon(
                            otherItems[index]['trailing_icon'],color: Colors.black, size: 27,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,);
                    },
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}
