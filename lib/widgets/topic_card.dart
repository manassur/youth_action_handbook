import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/popular_category_model.dart';
import 'package:youth_action_handbook/models/topic_model.dart';
import 'package:youth_action_handbook/models/updates_model.dart';

class TopicCard extends StatelessWidget {
  final Topic? topicModel;
 final double? scaleFactor;
  const TopicCard( {Key? key,this.topicModel,this.scaleFactor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: AppColors.colorGreenPrimary,
            borderRadius: BorderRadius.circular(15*scaleFactor!),
            boxShadow: [
              BoxShadow(
                  color: AppColors.colorGreenPrimary.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(4,6)
              )
            ]
        ),
      padding: EdgeInsets.symmetric(vertical: 10*scaleFactor!,horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('#'+topicModel!.topic!,style: TextStyle(color:  Colors.white,fontWeight: FontWeight.w900,fontSize: 13*scaleFactor!),),
          Text(topicModel!.postCount!.toString()+' Posts',style: TextStyle(color:  Colors.white,fontWeight: FontWeight.w100))

        ],
      ));
  }
}
