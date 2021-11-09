import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/induvidual_comment_model.dart';
import 'package:youth_action_handbook/models/trending_post_model.dart';

class InduvidualPostCard extends StatefulWidget {
  final InduvidualCommentModel? induvidualCommentModel;
  const InduvidualPostCard({Key? key,this.induvidualCommentModel}) : super(key: key);

  @override
  _InduvidualPostCardState createState() => _InduvidualPostCardState();
}

class _InduvidualPostCardState extends State<InduvidualPostCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.induvidualCommentModel!.isReply!?Container(
                margin: EdgeInsets.only(left: 20),
                color: Colors.grey.shade200,width: 1,height: 200,
              ):Container(),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Image.asset(widget.induvidualCommentModel!.image!),
                      ),
                      SizedBox(width: 30,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:widget.induvidualCommentModel!.isReply!?200: 240,
                              child: Text(widget.induvidualCommentModel!.name!,style: TextStyle(color:Colors.black87,fontSize: 14,fontWeight: FontWeight.bold))),
                         SizedBox(height: 5,),
                          Text(widget.induvidualCommentModel!.job!,style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w300),),

                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),

                  SizedBox(
                     width:widget.induvidualCommentModel!.isReply!? size *0.80:size*0.85,
                      child: Text('lorem ismur text that serves as a template holder for long texts, to show a certain information about a certain item in the UI desigin.',style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black54,fontSize: 14),)),
                    SizedBox(height: 20,),
                  Row(
                    children: [
                      Text('14d',style: TextStyle(color: Colors.grey.shade500,fontSize: 11),),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            widget.induvidualCommentModel!.isReplyBoxOpen=!widget.induvidualCommentModel!.isReplyBoxOpen!;

                          });
                        },
                          child: Text('Reply',style: TextStyle(color: Color(0xFF007AFF),fontSize: 11,fontWeight: FontWeight.w900),))
                    ],
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          Visibility(
            visible: widget.induvidualCommentModel!.isReplyBoxOpen!,
            child: Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Column(
                children: [
                  Container(
                      height: 200,
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
                    children: [
                      SizedBox(
                        height: 40,
                        width: 200,
                        child:TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary),
                              shadowColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary.withOpacity(0.4)),
                              elevation: MaterialStateProperty.all(5), //Defines Elevation
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ))),
                          child: Text('Send Reply',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          onPressed: () {

                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
