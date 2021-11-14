import 'package:flutter/material.dart';
import 'package:youth_action_handbook/models/course_response.dart';

class OpenTrainingCard extends StatefulWidget {
  final Courses? courseModel;
  const OpenTrainingCard({Key? key,required this.courseModel}) : super(key: key);

  @override
  _OpenTrainingCardState createState() => _OpenTrainingCardState();
}

class _OpenTrainingCardState extends State<OpenTrainingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color:  Color( widget.courseModel!.color!).withOpacity(0.4),
          borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                    color:Color( widget.courseModel!.color!),
                    shape: BoxShape.circle
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left:20),
                  child: Image.network(widget.courseModel!.image!,width: 200,height: 200,)),
            ],
          ),
         const SizedBox(height: 10,),
          Text(widget.courseModel!.title!,
            textAlign: TextAlign.center,
            style:const  TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black87),),
          // Text(widget.textCount!,style: const TextStyle(fontSize: 11)),
        const  SizedBox(height: 10,),

        ],
      ),
    );
  }
}
