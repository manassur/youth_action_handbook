import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/comment_model.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';

class ReplyCard extends StatefulWidget {
  final Comment? induvidualCommentModel;
  const ReplyCard({Key? key,this.induvidualCommentModel}) : super(key: key);

  @override
  _ReplyCardState createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  bool isReplyBoxOpen=false;
  AppUser? appUser;
  String? _currentUserId;
  bool _isLoading = false;
  @override
  initState() {
    super.initState();

  }

  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Container(
                margin: EdgeInsets.only(left: 20),
                color: Colors.grey.shade200,width: 1,height: 100,
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        backgroundImage:NetworkImage(widget.induvidualCommentModel!.authorImg!,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:!widget.induvidualCommentModel!.isParentComment!?200: 240,
                              child: Text(widget.induvidualCommentModel!.authorName!,style: TextStyle(color:Colors.black87,fontSize: 14,fontWeight: FontWeight.bold))),
                         SizedBox(height: 5,),
                          // Text(widget.induvidualCommentModel!.job!,style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Text(widget.induvidualCommentModel!.caption!,style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black54,fontSize: 15),),
                    ],
                  ),
                    SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(widget.induvidualCommentModel!.timestamp!.toDate().day.toString()+'-'+widget.induvidualCommentModel!.timestamp!.toDate().month.toString()+'-'+widget.induvidualCommentModel!.timestamp!.toDate().year.toString(),style: TextStyle(color: Colors.grey.shade500,fontSize: 11),),
                    ],
                  ),

                ],
              ),
            ],
          ),

          SizedBox(height: 20,),

        ],
      ),
    );
  }
}
