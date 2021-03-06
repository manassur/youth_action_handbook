
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/screens/GetInTouch.dart';
import 'package:youth_action_handbook/screens/web_view.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AboutFragment extends StatefulWidget {
  @override
  _AboutFragmentState createState() => _AboutFragmentState();
}

class _AboutFragmentState extends State<AboutFragment> {


  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    String locale = Localizations.localeOf(context).toString().split("_")[0];
    String about = (locale == 'fr')? '/about-1':'/about';

    //SETTINGS DATA
    List settingItems = [
      {
        "leading_icon": Icons.person_outline,
        "title": AppLocalizations.of(context)!.editProfile,
        "trailing_icon": Icons.chevron_right,
        "page": RouteNames.editProfile,
      },

      {
        "leading_icon": Icons.email_outlined,
        "title": AppLocalizations.of(context)!.editLoginInformation,
        "trailing_icon": Icons.chevron_right,
        "page": RouteNames.editLogin,
      },
    ];

  //PROJECT DATA
  List projectItems = [
    {
      "leading_icon": Icons.person_outline,
      "title": AppLocalizations.of(context)!.aboutTheProject,
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://greatlakesyouth.africa/"+locale+about+"/",
    },
    {
      "leading_icon": Icons.people,
      "title": AppLocalizations.of(context)!.team,
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://greatlakesyouth.africa/"+locale+about+"/team/",
    },
    {
      "leading_icon": Icons.check_circle,
      "title": AppLocalizations.of(context)!.partners,
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://greatlakesyouth.africa/"+locale+about+"/partners/",
    },
    {
      "leading_icon": Icons.add_business,
      "title": AppLocalizations.of(context)!.youthInitiatives,
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://greatlakesyouth.africa/"+locale+"/initiatives/",
    },
    {
      "leading_icon": Icons.info_outline,
      "title": AppLocalizations.of(context)!.appVersion,
      "app_version": "1.1.0" ,
      "page": "",
    },

  ];

  //SOCIAL DATA
  List socialItems = [
    {
      "leading_icon": 'assets/social/fb.svg',
      "title": "Facebook",
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://www.facebook.com/4youthdialogue/",
    },
    {
      "leading_icon": 'assets/social/tw.svg',
      "title": "Twitter",
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://twitter.com/4youthdialogue",
    },
    {
      "leading_icon": 'assets/social/ln.svg',
      "title": "LinkedIn",
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://www.linkedin.com/company/great-lakes-youth-network-for-dialogue-and-peace-our-diversity-our-opportunity",
    },
    {
      "leading_icon": 'assets/social/ig.svg',
      "title": "Instagram",
      "trailing_icon": Icons.keyboard_arrow_right_sharp,
      "page": "https://www.instagram.com/4youthdialogue/",
    }
  ];
 
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorBluePrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: AppColors.colorBluePrimary,
        ), 
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
              text: AppLocalizations.of(context)!.about,
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
                  child: Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppLocalizations.of(context)!.settings,
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
                            settingItems[index]['trailing_icon'],color: Colors.black87, size: 27,
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, settingItems[index]['page']);
                            ;
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
                        padding:  EdgeInsets.only(left: 35.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context)!.theProject,
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
                      return Column(
                        children: [
                          SizedBox(
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
                                  :Text(projectItems[index]['app_version']),

                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebViewScreen(link:projectItems[index]['page'],title: projectItems[index]['title'],)));
                                  // Navigator.pushNamed(context, projectItems[index]['page']);
                                  launchDrop() async {
                                    String url = projectItems[index]['page'];
                                    if (await canLaunch(url)) {
                                      // await launch(url, forceWebView: true, forceSafariVC: true, );
                                      await launch(url, forceWebView: true, forceSafariVC: true,);
                                    } else {
                                      yahSnackBar(context, AppLocalizations.of(context)!.cantOpenWebsite);
                                    }
                                  }
                                  // launchDrop();
                                }
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,);
                    },
                  ),
                ),

              ],
            ),

            //Social Media
          Column(
              children: [
                Container(
                      color: AppColors.colorBlueSecondary,
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      child: Padding(
                        padding:  EdgeInsets.only(left: 35.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context)!.socialMedia,
                            style: TextStyle(color: Colors.white),),
                        ),
                      )),

                Padding(
                  padding: const EdgeInsets.only(left:15.0, right: 15.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: socialItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: ListTile(
                              leading: SvgPicture.asset(
                                socialItems[index]['leading_icon'], color: AppColors.colorPurple,width:27,
                                ),
                              title: Text(
                                socialItems[index]['title'],
                              ),
                              trailing: socialItems[index]['trailing_icon']!=null?
                              Icon(
                                socialItems[index]['trailing_icon'], color: Colors.black, size: 27,
                              )
                                  :Text(socialItems[index]['app_version']),

                                onTap: (){
                                  // Navigator.pushNamed(context, socialItems[index]['page']);
                                  socialDrop() async {
                                    String url = socialItems[index]['page'];
                                    if (await canLaunch(url)) {
                                      // await launch(url, forceWebView: true, forceSafariVC: true, );
                                      await launch(url);
                                    } else {
                                      if(socialItems[index]['title'] == 'App Version'){
                                        yahSnackBar(context, socialItems[index]['page']);
                                      }
                                      yahSnackBar(context, AppLocalizations.of(context)!.cantOpenWebsite);
                                    }
                                  }
                                  socialDrop();
                                }
                            ),
                          ),
                        ],
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
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    color: AppColors.colorBlueSecondary,
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context)!.other,
                          style: TextStyle(color: Colors.white),),
                      ),
                    )),
                
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GetInTouch()));
                      
                    },
                    leading: Icon(Icons.link, color: AppColors.colorPurple),
                    title: Text(AppLocalizations.of(context)!.impressum),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp,color: Colors.black, size: 27),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,),
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebViewScreen(link:"https://studio.rtl.ug/yah-privacy-policy")));
                      
                    },
                    leading: Icon(Icons.check_circle, color: AppColors.colorPurple),
                    title: Text(AppLocalizations.of(context)!.privacyPolicy),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp,color: Colors.black, size: 27),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebViewScreen(link:"https://studio.rtl.ug/yah-terms-conditions")));
                      
                    },
                    leading: Icon(Icons.info_outline, color: AppColors.colorPurple),
                    title: Text(AppLocalizations.of(context)!.termsAndConditions),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp,color: Colors.black, size: 27),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListTile(
                    onTap: () async{
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setBool('notFirstLaunch',false);
                        await DefaultCacheManager().emptyCache().then((value) => yahSnackBar(context, AppLocalizations.of(context)!.appCacheCleared));
                    },
                    leading: Icon(Icons.cached, color: AppColors.colorPurple),
                    title: Text(AppLocalizations.of(context)!.clearCache),
                    // trailing: Icon(Icons.keyboard_arrow_right_sharp,color: Colors.black, size: 27),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListTile(
                    onTap: () async{
                        final AuthService _auth = AuthService();
                        Navigator.pushNamedAndRemoveUntil(
                                    context, RouteNames.initialScreen, (route) => false);
                                await _auth.signOut(context);
                    },
                    leading: Icon(Icons.login_outlined, color: AppColors.colorPurple),
                    title: Text(AppLocalizations.of(context)!.signOut),
                    // trailing: Icon(Icons.keyboard_arrow_right_sharp,color: Colors.black, size: 27),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}
