import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/models/induvidual_comment_model.dart';
import 'package:youth_action_handbook/widgets/induvidual_post_card.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/topic_category_card.dart';
import 'package:youth_action_handbook/widgets/trending_post_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InduvidualPostScreen extends StatefulWidget {
  const InduvidualPostScreen({Key? key}) : super(key: key);

  @override
  _InduvidualPostScreenState createState() => _InduvidualPostScreenState();
}

class _InduvidualPostScreenState extends State<InduvidualPostScreen> {
  int selected = 0;
    List<InduvidualCommentModel> induvidualPostComments = [
    InduvidualCommentModel(job: ' UNHCR',name: 'Amanda komuhangi',image:'assets/user4.png',isReply: false),
    InduvidualCommentModel(job: ' Europoean Union',name: 'John Otim',image:'assets/user5.png',isReply:true),
    InduvidualCommentModel(job: ' Documentary developer',name: 'Simon Mutuku',image:'assets/user6.png',isReply:false),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('#GBV',style: TextStyle(color: AppColors.colorBluePrimary,fontSize: 25,fontWeight: FontWeight.bold),),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: AppColors.colorBluePrimary,), // set your color here
          onPressed: () {
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
      body:   ListView.builder(
          itemCount: induvidualPostComments.length,
          itemBuilder: (ctx,pos){
            return InduvidualPostCard(induvidualCommentModel:induvidualPostComments[pos] ,
            );
          }
      ),


    );
  }
}
