import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/popular_category_model.dart';
import 'package:youth_action_handbook/models/topic_model.dart';
import 'package:youth_action_handbook/models/updates_model.dart';

class TopicCard extends StatelessWidget {
  final TopicModel? topicModel;
  const TopicCard( {Key? key,this.topicModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 150,
      margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: topicModel!.color,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: topicModel!.color!.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(4,6)
              )
            ]
        ),
      padding: EdgeInsets.symmetric(vertical: 25,horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(topicModel!.title!,style: TextStyle(color:  topicModel!.textColor,fontWeight: FontWeight.w900,fontSize: 20),),
          Text(topicModel!.count!+' Posts',style: TextStyle(color:  topicModel!.textColor,fontWeight: FontWeight.w100))

        ],
      ));
  }
}
