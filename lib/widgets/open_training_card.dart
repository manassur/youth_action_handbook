import 'package:flutter/material.dart';

class OpenTrainingCard extends StatefulWidget {
 final String? icon;
 final Color? color;
 final String? textHeader;
 final String? textCount;
  const OpenTrainingCard({Key? key,this.icon,this.color,this.textHeader,this.textCount}) : super(key: key);

  @override
  _OpenTrainingCardState createState() => _OpenTrainingCardState();
}

class _OpenTrainingCardState extends State<OpenTrainingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color:widget.color!.withOpacity(0.4),
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
                    color:widget.color,
                    shape: BoxShape.circle
                ),
              ),
              Container(
                margin: EdgeInsets.only(left:20),
                  child: Image.asset(widget.icon!,width: 200,height: 200,)),

            ],
          ),
          SizedBox(height: 10,),
          Text(widget.textHeader!,textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black87),),
          Text(widget.textCount!,style: TextStyle(fontSize: 11)),
          SizedBox(height: 10,),

        ],
      ),
    );
  }
}
