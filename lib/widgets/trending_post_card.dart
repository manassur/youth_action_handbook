import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/models/trending_post_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/screens/induvidual_post.dart';
import 'package:youth_action_handbook/services/database.dart';

class TrendingPostsCard extends StatefulWidget {
  final Post? trendingPostModel;
  const TrendingPostsCard({Key? key,this.trendingPostModel}) : super(key: key);


  @override
  State<TrendingPostsCard> createState() => _TrendingPostsCardState();
}

class _TrendingPostsCardState extends State<TrendingPostsCard> {
  bool _isLiked = false;
  int? _likeCount;
  DatabaseService? db;
  AppUser? appUser;
  bool? isDeleted=false;
  @override
  initState(){
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    db=DatabaseService(uid:appUser!.uid );
    _initPostLiked();
  }

  _initPostLiked() async {
    _likeCount =widget.trendingPostModel!.likeCount!;
    bool isLiked = await db!.didLikePost(widget.trendingPostModel!.id!);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }



  _likePost() {
    if (_isLiked) {
      // Unlike Post
      db!.unlikePost(widget.trendingPostModel!);
      setState(() {
        _isLiked = false;
        _likeCount=_likeCount!-1;
      });
    } else {
      // Like Post
      db!.likePost(widget.trendingPostModel!);
      setState(() {
        _isLiked = true;
        _likeCount=_likeCount!+1;
      });

    }
  }

  _deletePost(){
    db!.deletePost(widget.trendingPostModel!);
    Navigator.of(context).pop();
    setState(() {
      isDeleted=true;
    });
    Flushbar(
      title: "Deleted",
      message: "Your post has been deleted",
      backgroundColor: AppColors.colorYellow,
      duration: Duration(seconds: 2),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InduvidualPostScreen(post: widget.trendingPostModel,)),
        );
      },
      child:isDeleted==true?Container(): Container(
        margin: EdgeInsets.only(bottom:15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                CircleAvatar(
                  backgroundImage:  NetworkImage(widget.trendingPostModel!.authorImg!),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.trendingPostModel!.caption!,style: TextStyle(color: AppColors.colorBluePrimary,fontSize: 14,fontWeight: FontWeight.bold)),
                     SizedBox(height: 5,),
                      Text(widget.trendingPostModel!.authorName!,style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Spacer(),

                IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return  StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState )
                              { return  FractionallySizedBox(
                                heightFactor: 0.25,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height:5,
                                        width: 50,
                                        color: Colors.grey,
                                      ),
                                     ListTile(
                                       title: Text('Share'),
                                       trailing: Icon(Icons.share),
                                       onTap: (){
                                         Share.share(widget.trendingPostModel!.description!, subject: widget.trendingPostModel!.caption);

                                       },
                                     ),
                                      widget.trendingPostModel!.authorId==appUser!.uid ?       ListTile(
                                        title: Text('Delete'),
                                        trailing: Icon(Icons.delete),
                                        onTap: (){
                                        _deletePost();

                                        },
                                      ):Container()
                                    ],
                                  ),
                                ),
                              );}
                          );
                        });
                  },
                  icon: Icon(Icons.more_horiz_outlined,color:Color(0xFF2E3A59)),
                )
              ],
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(widget.trendingPostModel!.description!,style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black54,fontSize: 12),)),
              ],
            ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thumb_up_off_alt,color: Colors.grey.shade400,size:16),
                      SizedBox(width: 5,),
                      Text(_likeCount.toString()+' Likes',style: TextStyle(color: Colors.grey.shade500,fontSize: 11),)
                    ],
                  ),
                  SizedBox(width: 30,),
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline,color: Colors.grey.shade400,size: 16,),
                      SizedBox(width: 5,),
                      Text(widget.trendingPostModel!.replyCount.toString()+' Replies',style: TextStyle(color: Colors.grey.shade500,fontSize: 11),)
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: (){
                      _likePost();
                    },
                    icon: _isLiked?Icon(Icons.favorite,color:Color(0xFF2E3A59)):Icon(Icons.favorite_border,color:Color(0xFF2E3A59)),
                  )
                  // Row(
                  //   children: [
                  //     Icon(Icons.visibility_outlined,color: Colors.grey.shade400,size: 16,),
                  //     SizedBox(width: 5,),
                  //     Text('200 Views',style: TextStyle(color: Colors.grey.shade500,fontSize: 11),)
                  //   ],
                  // ),

                ],
              ),
          ],
        ),
      ),
    );
  }
}
