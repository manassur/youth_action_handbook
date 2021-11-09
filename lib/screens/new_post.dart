import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/topic_category_card.dart';
import 'package:youth_action_handbook/widgets/trending_post_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String? _chosenValue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: AppColors.colorBluePrimary,), // set your color here
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor:AppColors.colorBluePrimary,
              radius: 30,
              child: CircleAvatar(
                radius: 40,
                child: Image.asset("assets/user.png"),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Make a Post',
                        style: TextStyle(
                            color: AppColors.colorBluePrimary, fontSize: 25,fontWeight: FontWeight.w900),
                        children: const <TextSpan>[

                        ]
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 250,
                    child: Text("Find topics you like to read, engage with communities and ask questions.",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey[500]),),
                  ),




                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade100,
                                      spreadRadius: 4,
                                      blurRadius: 5
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left:50,top:15,bottom: 15,right:15),
                              child: DropdownButton<String>(
                                focusColor:Colors.white,
                                isExpanded: true,
                                value: _chosenValue,
                                //elevation: 5,
                                style: TextStyle(color: Colors.white),
                                iconEnabledColor:Colors.black,
                                underline: SizedBox(),
                                items: <String>[
                                  'Topic 1',
                                  'topic 2',
                                  'Topic 3',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style:TextStyle(color:Colors.black),),
                                  );
                                }).toList(),
                                hint:Text(
                                  "Choose a Topic",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _chosenValue = value;
                                  });
                                },
                              ),)),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Text("Post your question or start a discussion.",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey[500]),),
                  SizedBox(height: 25,),
                  Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                              style: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w100),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "Type Something",

                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle:  TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w100),

                              )))),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child:TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary),
                                shadowColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary.withOpacity(0.4)),
                                elevation: MaterialStateProperty.all(5), //Defines Elevation
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                            child: Text('Make a Post',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            onPressed: () {

                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),




          ],
        ),
      ),


    );
  }
}
