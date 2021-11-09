import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class QuizzCard extends StatelessWidget {
  final String? title,subtitle,score;
  final bool? isDone,isAvailable;
  const QuizzCard({Key? key,this.title,this.subtitle,this.score,this.isDone,this.isAvailable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:30,horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: isDone!?Colors.white: AppColors.colorGreenPrimary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color:isDone!?Colors.grey.shade200: AppColors.colorGreenPrimary.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(4,6)
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: isDone!? AppColors.colorBluePrimary:Colors.white),),
             SizedBox(height:5),
              Text(subtitle!,style: TextStyle(fontWeight: FontWeight.w100,fontSize: 12,color: isDone!? AppColors.colorBluePrimary:Colors.white),),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: isDone!?Color(0xff4CD964):Color(0xFF2DF0E0),
                  radius: 20,
                  child: Text(score!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17),)),
              Text("score",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color:isDone!?Colors.black87: Colors.white),),
            ],
          ),
         isDone!? CircleAvatar(
            radius:12 ,
            backgroundColor: Color(0xff4CD964),
            child: Icon(Icons.done,color: Colors.white,),
          ):
         CircleAvatar(
           radius:13 ,
           backgroundColor: Color(0xFF2DF0E0),
           child:  CircleAvatar(
             radius:12 ,
             backgroundColor: AppColors.colorGreenPrimary,
             child: Icon(Icons.lock_outline_rounded,color: Colors.white,size: 12,),
           )
         )


        ],
      ),
    );
  }
}
