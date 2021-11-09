import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class TypeAnswerWidget extends StatelessWidget {
  const TypeAnswerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25,),
        Container(
            height: 170,
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
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 300,
              child:TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary),
                    shadowColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary.withOpacity(0.4)),
                    elevation: MaterialStateProperty.all(5), //Defines Elevation
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
                child: Text('Submit',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                onPressed: () {

                },
              ),
            ),
          ],
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}
