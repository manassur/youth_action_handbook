import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle(
        //           statusBarBrightness: Brightness.light,
        //           statusBarIconBrightness: Brightness.light,
        //   statusBarColor: AppColors.colorBluePrimary,
        //         ),
        //         toolbarHeight: 0, shadowColor: Colors.transparent, ),
        backgroundColor: AppColors.colorBluePrimary,
        body:Padding(
          padding: const EdgeInsets.only(left:40,right:40,top:70),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:CrossAxisAlignment.center ,
              children: [

                // Image.asset( 'assets/logo.png',width: 200,),
                
                CircleAvatar(child: Image.asset('assets/hands-meet.png',width: 200),backgroundColor: AppColors.colorYellow,maxRadius:100),

                SizedBox(
                    width: 200,
                    child: Text(AppLocalizations.of(context)!.youthActionHandbook,
                      style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      )
                ),
                RichText(
                  text: TextSpan(
                      text: AppLocalizations.of(context)!.our,
                      style: TextStyle(
                          color: Colors.white, fontSize: 13,fontWeight: FontWeight.w200),
                      children: <TextSpan>[
                        TextSpan(text: AppLocalizations.of(context)!.diversity,
                            style: TextStyle(
                                color: Colors.white, fontSize: 12,fontWeight: FontWeight.w700),
                        ),
                  TextSpan(
                      text: AppLocalizations.of(context)!.our,
                      style: TextStyle(
                          color: Colors.white, fontSize: 13,fontWeight: FontWeight.w200),
                  ),
                        TextSpan(text: AppLocalizations.of(context)!.opportunity,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12,fontWeight: FontWeight.w700),
                        ),
                      ]
                  ),
                ),

                SizedBox( //Register
                width: 200.0,
                height: 50,
                child:ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.register),
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.signUpScreen);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                                 
                ),
              ),


                SizedBox(
                      width: 200.0,
                      height: 50,
                      child: OutlinedButton( //*********LOGIN BUTTON*********
                        onPressed: ()=> Navigator.pushNamed(context, RouteNames.loginScreen),
                        child: Text(AppLocalizations.of(context)!.login,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w400)),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.colorGreenPrimary),
                            shape: const StadiumBorder(),
                        ),
                      ),
                    ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/union_logo.png'),
                        const SizedBox(width: 5,),
                        SizedBox(
                            width: 100,
                            child: Text(AppLocalizations.of(context)!.coFoundedByTheEuropeanUnion,style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),))
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: const Text(
                          'Great Lakes Youth Dialogue Network for Dialogue and Peace',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100,fontSize: 12),))
                  ],
                ),
          
              ],
            ),
          ),
        );
  }
}

