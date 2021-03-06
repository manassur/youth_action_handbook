import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/comment_model.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/induvidual_post_card.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InduvidualPostScreen extends StatefulWidget {
  final Post? post;
  const InduvidualPostScreen({Key? key,this.post}) : super(key: key);

  @override
  _InduvidualPostScreenState createState() => _InduvidualPostScreenState();
}

class _InduvidualPostScreenState extends State<InduvidualPostScreen> {

  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<Comment>>? postComments;
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);

    postComments = dbservice!.getPostComments(widget.post!.id!);

  }

  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _postComment() async {
    final filter = ProfanityFilter();
    FocusScope.of(context).unfocus();
    if (!(_captionController.text.trim().isNotEmpty)) {
      yahSnackBar(context, AppLocalizations.of(context)!.commentCannotBeEmpty_);
    }
    else if(filter.hasProfanity(_captionController.text.trim())){
      // toast that fields cannot be empty
      yahSnackBar(context, AppLocalizations.of(context)!.sorryProfanityWasDetectedInYourTextPleaseEditAndTrySubmittingAgain);
    }
    else {
      if (!_isLoading) {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        //Create new Post
        Comment comment = Comment(
          parentId: widget.post!.id,
          parentAuthorId: widget.post!.authorId,
          caption: _captionController.text.trim(),
          replyCount: 0,
          authorName: appUser!.name,
          authorImg: appUser!.profilePicture,
          authorId: _currentUserId,
          timestamp: Timestamp.fromDate(DateTime.now()),
          isParentComment: true,
        );

        dbservice!.addComment(comment).whenComplete(() =>
        {
          setState(() {
            _isLoading = false;
          }),
        postComments = dbservice!.getPostComments(widget.post!.id!),
          _captionController.clear(),
            Navigator.pop(context)
        }).catchError((e) {
          setState(() {
            _isLoading = false;
          });
          print(AppLocalizations.of(context)!.couldNotPostCommentAtThisTime);
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.comments,style: TextStyle(color: AppColors.colorBluePrimary,fontSize: 15,fontWeight: FontWeight.bold),),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: AppColors.colorBluePrimary,), // set your color here
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          MenuForAppBar(),
        ],
      ),
      body:_isLoading? Loading():
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( widget.post!.caption!,style: TextStyle(color: AppColors.colorBluePrimary,fontSize: 17,fontWeight: FontWeight.bold),),
        ),
        // SizedBox(height: 1,),
        Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text( widget.post!.description!,style: TextStyle(color: Colors.black,fontSize: 16),),
        ),
        Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text( widget.post!.authorName!,style: TextStyle(color: Colors.grey,fontSize: 14),),
            Text('| '+ convertDate(widget.post!.timestamp!),style: TextStyle(color: Colors.grey.shade500,fontSize: 14),),
            // SizedBox(width: 10,),
          ],
        ),
        ),
          SizedBox(height: 20,),
          FutureBuilder<List<Comment>>(
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
            else  if (snapshot.hasError)
              { return Center(child: Text(AppLocalizations.of(context)!.couldNotFetchCommentsAtThisTime+ ' ' +snapshot.error.toString()));}

             else if(snapshot.hasData){
               return  Expanded(
                 child: ListView.builder(
                    itemCount:  snapshot.data!.length,
                    itemBuilder: (ctx,pos){
                      return InduvidualPostCard(induvidualCommentModel:snapshot.data![pos]);
                    }
              ),
               );}

             else {
               return Container();
             }
            },
            future: postComments,
          ),
        ],
      ),



      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorGreenPrimary,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
             return   Padding(
                  padding: const EdgeInsets.only(left:15.0,top:20,right:15),
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

                                controller: _captionController,
                                  style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w100),
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLines: 8,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                  _postComment();
                                  },
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.typeYourThoughts,
                                    border: InputBorder.none,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    hintStyle:  TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w100),

                                  )))),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                              child:!_isLoading?Text(AppLocalizations.of(context)!.postComment,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)
                              : const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),

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
                );
              });
        },

        child: Icon(Icons.mode_comment_outlined,color: Colors.white,),
      ),


    );
  }
}