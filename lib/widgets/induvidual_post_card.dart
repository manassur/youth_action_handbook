import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/comment_model.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/reply_card.dart';

class InduvidualPostCard extends StatefulWidget {
  final Comment? induvidualCommentModel;
  const InduvidualPostCard({Key? key,this.induvidualCommentModel}) : super(key: key);

  @override
  _InduvidualPostCardState createState() => _InduvidualPostCardState();
}

class _InduvidualPostCardState extends State<InduvidualPostCard> {
  bool isReplyBoxOpen=false;
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<Comment>>? commentReplies;
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  Widget? replyBody;
  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);
    replyBody = Container();

  }

  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _postComment() async {
    FocusScope.of(context).unfocus();
    if ((_captionController.text.trim().isNotEmpty)) {
      if (!_isLoading) {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        //Create new Post
        Comment comment = Comment(
          parentId: widget.induvidualCommentModel!.parentId,
          parentAuthorId: widget.induvidualCommentModel!.parentAuthorId,
          caption: _captionController.text,
          replyCount: 0,
          authorName: appUser!.name,
          authorImg: appUser!.photoURL,
          authorId: _currentUserId,
          timestamp: Timestamp.fromDate(DateTime.now()),
          isParentComment: false,
        );

        dbservice!.addComment(comment).whenComplete(() =>
        {
          setState(() {
            _isLoading = false;
            isReplyBoxOpen=false;
            _captionController.clear();
          }),

        }).catchError((e) {
          setState(() {
            _isLoading = false;
          });
          print('could not post comment at this time');
        });
      }
    }else{
      // toast that fields cannot be empty
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Image.network(widget.induvidualCommentModel!.authorImg!,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
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

                  SizedBox(
                     width:!widget.induvidualCommentModel!.isParentComment!? size *0.80:size*0.85,
                      child: Text(widget.induvidualCommentModel!.caption!,style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black54,fontSize: 15),)),
                    SizedBox(height: 20,),
                  Row(
                    children: [
                      Text(widget.induvidualCommentModel!.timestamp!.toDate().day.toString()+'-'+widget.induvidualCommentModel!.timestamp!.toDate().month.toString()+'-'+widget.induvidualCommentModel!.timestamp!.toDate().year.toString(),style: TextStyle(color: Colors.grey.shade500,fontSize: 11),),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isReplyBoxOpen=!isReplyBoxOpen;
                          });
                        },
                          child: Text('Reply',style: TextStyle(color: Color(0xFF007AFF),fontSize: 12,fontWeight: FontWeight.w900),)),
                      SizedBox(width: 10,),
                      GestureDetector(
                          onTap: (){
                            commentReplies = dbservice!.getPostComments(widget.induvidualCommentModel!.id!);
                            setState(() {
                              isReplyBoxOpen=false;
                              replyBody =  Visibility(
                                visible:!isReplyBoxOpen,
                                child: FutureBuilder<List<Comment>>(
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.none &&
                                        snapshot.hasData == null) {
                                      return Container();
                                    }else if( snapshot.connectionState == ConnectionState.waiting){
                                      return  const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Center(
                                          child: SizedBox(
                                            child: CircularProgressIndicator(),
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError)
                                    { return Center(child: Text('Could not fetch replies at this time'+snapshot.error.toString()));}

                                    return  ListView.builder(
                                      shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:  snapshot.data!.length,
                                        itemBuilder: (ctx,pos){
                                          print(snapshot.data![pos].parentId.toString());
                                          return ReplyCard(induvidualCommentModel:snapshot.data![pos]);
                                        }
                                    );
                                  },
                                  future: commentReplies,
                                ),
                              );
                            });



                          },
                          child: const Text('View  Replies',style: TextStyle(color: Color(0xFF007AFF),fontSize: 12,fontWeight: FontWeight.w900),)),

                    ],
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          replyBody!,
          SizedBox(height: 20,),
          Visibility(
            visible: isReplyBoxOpen,
            child: Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Column(
                children: [
                  Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller:_captionController,
                            maxLines: 5,
                              style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w100),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "Type Something",
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle:  TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w100),

                              )))),
                  SizedBox(height: 10,),
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
                          child: !_isLoading?Text('Send Reply',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),):
                      const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          width: 20,
                          height: 20,
                        ),
                      )),
                          onPressed: () {
                                _postComment();

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
