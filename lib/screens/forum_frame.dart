import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/screens/topic_posts.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/trending_post_card.dart';

import 'induvidual_post.dart';

class ForumFrame extends StatefulWidget {
  final int? selectedIndex;

  const ForumFrame({Key? key,this.selectedIndex}) : super(key: key);

  @override
  _ForumFrameState createState() => _ForumFrameState();
}

class _ForumFrameState extends State<ForumFrame> {
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<Topic>>? topicFuture;
  Future<List<Post>>? trendingPostFuture;
  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);

    topicFuture = widget.selectedIndex==0? dbservice!.getTopics():widget.selectedIndex==1?dbservice!.getRecommendedTopics():dbservice!.getNewTopics();
    trendingPostFuture = widget.selectedIndex==0?
    dbservice!.getTrendingPosts():
    widget.selectedIndex==1?dbservice!.getRecommendedPosts():dbservice!.getNewPosts();

    // use this to populate topics
    // dbservice!.createTopic('Facts');


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height:20),
        RichText(
          text: TextSpan(
              text: 'Topics',
              style: TextStyle(
                  color: AppColors.colorBluePrimary, fontSize: 20,fontWeight: FontWeight.w900),
              children: const <TextSpan>[

              ]
          ),
        ),
        SizedBox(height:10),
        SizedBox(
          height: 120,
          child:
          FutureBuilder<List<Topic>>(
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
              {
                print(snapshot.error.toString());
                return Center(child: Text('Could not fetch topics at this time'+snapshot.error.toString()));
              }


              return   ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx,pos){
                    return InkWell(
                      onTap:(){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                TopicPosts(topic: snapshot.data![pos])));
                      },
                      child: TopicCard(
                        topicModel: snapshot.data![pos],
                            scaleFactor: 1.7,
                      ),
                    );
                  }
              );
            },
            future: topicFuture,
          ),

        ),
        SizedBox(height:20),
        RichText(
          text: TextSpan(
              text: widget.selectedIndex==0?'Trending Posts':widget.selectedIndex==1?'Recommended Posts':'New Posts',
              style: TextStyle(
                  color: AppColors.colorBluePrimary, fontSize: 17,fontWeight: FontWeight.w900),

          ),
        ),
        FutureBuilder<List<Post>>(
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
            {   print(snapshot.error.toString());

            return Center(child: Text('Could not fetch posts at this time'+snapshot.error.toString()));}

            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx,pos){
                  return InkWell(
                    onTap:(){


                    },
                    child: TrendingPostsCard(trendingPostModel:snapshot.data![pos] ,
                    ),
                  );
                }
            );
          },
          future: trendingPostFuture,
        ),

      ],
    );
  }
}
