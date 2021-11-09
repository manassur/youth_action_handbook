import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/screens/evaluation.dart';

class EvaluationCard extends StatelessWidget {
  final String? title,subtitle,score;
  final bool? isDone,isAvailable;
  const EvaluationCard({Key? key,this.title,this.subtitle,this.score,this.isDone,this.isAvailable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EvaluationScreen()),
        );
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft:Radius.circular(20),
              topRight:Radius.circular(20),
              bottomLeft:Radius.circular(20),

            ),
            boxShadow: [
              BoxShadow(
                  color:Colors.grey.shade200,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(4,6)
              )
            ]
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
                     SizedBox(height:5),
                      Text(subtitle!,style: TextStyle(fontWeight: FontWeight.w100,fontSize: 12,color: AppColors.colorBluePrimary)),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: isDone!?Color(0xff4CD964):Colors.grey.shade400,
                          radius: 20,
                          child: Text(score!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17),)),
                      Text("score",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color:isDone!?Colors.black87: Colors.grey),),
                    ],
                  ),
                 isDone!? CircleAvatar(
                    radius:12 ,
                    backgroundColor: Color(0xff4CD964),
                    child: Icon(Icons.done,color: Colors.white,),
                  ):
                 CircleAvatar(
                   radius:13 ,
                   backgroundColor: Colors.grey.shade400,
                   child:  CircleAvatar(
                     radius:12 ,
                     backgroundColor: Colors.white,
                     child: Icon(Icons.lock_outline_rounded,color: Colors.grey,size: 12,),
                   )
                 )


                ],
              ),
            ),
            Positioned.fill(
              child:  Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: isDone!?Color(0xff4CD964):Colors.grey.shade500,
                      borderRadius: BorderRadius.only(
                        topLeft:Radius.circular(15),
                        topRight:Radius.circular(15),
                        bottomLeft:Radius.circular(15),

                      ),)),
              )
            )


          ],
        ),
      ),
    );
  }
}
