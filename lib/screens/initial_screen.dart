import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/screens/login.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/widgets/common.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorBluePrimary,
        body:Padding(
          padding: const EdgeInsets.only(left:40,right:40,top:70),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:CrossAxisAlignment.center ,
              children: [

                // Image.asset( 'assets/logo.png',width: 200,),
                
                CircleAvatar(child: Image.asset('assets/hands-meet.png',width: 200),backgroundColor: AppColors.colorYellow,maxRadius:100),

                const SizedBox(
                    width: 200,
                    child: Text(AppTexts.youthActionHandbook,
                      style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      )
                ),
                RichText(
                  text: const TextSpan(
                      text: 'Our ',
                      style: TextStyle(
                          color: Colors.white, fontSize: 13,fontWeight: FontWeight.w200),
                      children: <TextSpan>[
                        TextSpan(text: 'Diversity.',
                            style: TextStyle(
                                color: Colors.white, fontSize: 12,fontWeight: FontWeight.w700),
                        ),
                  TextSpan(
                      text: ' Our ',
                      style: TextStyle(
                          color: Colors.white, fontSize: 13,fontWeight: FontWeight.w200),
                  ),
                        TextSpan(text: 'Opportunity',
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
                  child: const Text('Register'),
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
                        child: const Text(AppTexts.login,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w400)),
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
                        const SizedBox(
                            width: 100,
                            child: Text('Co Founded by the European Union',style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),))
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

