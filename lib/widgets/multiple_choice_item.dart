import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultipleChoiceItem extends StatefulWidget {
  final Answers? answer;
  final String? selectedAnswer; 
  final String? correctAnswer; 
  bool changeColor = false;
  Function? changeColorfn;
  
  MultipleChoiceItem({Key? key, this.answer,this.selectedAnswer, this.correctAnswer, this.changeColor = false, this.changeColorfn}) : super(key: key);

  @override
  State<MultipleChoiceItem> createState() => _MultipleChoiceItemState();
}

class _MultipleChoiceItemState extends State<MultipleChoiceItem> {
    Color ansColor = AppColors.colorBluePrimary;

  @override
  Widget build(BuildContext context) {
    print('AKBR change color: '+ widget.changeColor.toString());
    // print('AKBR RED CHOSEN ');
    // if(widget.changeColor == true){
    //   if(widget.answer!.id == widget.selectedAnswer ){
    //     ansColor = Colors.red;

    //   }
    //   if(widget.answer!.id == widget.correctAnswer){
    //     ansColor = Colors.green;
    //   }
      
    // }
    ansColor = widget.changeColorfn!();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:   Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              SizedBox(
                  child:
                  Text(
                      AppLocalizations.of(context)!.answer,
                      style: TextStyle(
                          color: ansColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),

              SizedBox(height: 5),
              Text(
                widget.answer!.option!,
                style: TextStyle(
                    color: ansColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w200),
              ),
            ],
          ),
          const  Spacer(),
          widget.selectedAnswer==widget.answer!.id?
          const CircleAvatar(
            radius:15 ,
            backgroundColor: Color(0xff4CD964),
            child: Icon(Icons.done,color: Colors.white,),
          )
              :CircleAvatar(
            radius:15 ,
            backgroundColor: Colors.grey.shade400,
          )
        ],
      ),

    );
  }
}
