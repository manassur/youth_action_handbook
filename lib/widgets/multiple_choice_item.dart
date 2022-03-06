import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultipleChoiceItem extends StatefulWidget {
  final Answers? answer;
  final String? selectedAnswer;
  const MultipleChoiceItem({Key? key, this.answer,this.selectedAnswer }) : super(key: key);

  @override
  State<MultipleChoiceItem> createState() => _MultipleChoiceItemState();
}

class _MultipleChoiceItemState extends State<MultipleChoiceItem> {

  @override
  Widget build(BuildContext context) {
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
                          color: AppColors.colorBluePrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),

              SizedBox(height: 5),
              Text(
                widget.answer!.option!,
                style: TextStyle(
                    color: AppColors.colorBluePrimary,
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
