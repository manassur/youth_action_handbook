import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/trending_post_card.dart';

import 'induvidual_post.dart';

class TopicPosts extends StatefulWidget {
  final Topic? topic;
  const TopicPosts({Key? key,this.topic}) : super(key: key);

  @override
  _TopicPostsState createState() => _TopicPostsState();
}

class _TopicPostsState extends State<TopicPosts> {
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<Post>>? topicsPostFuture;
  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);
    topicsPostFuture = dbservice!.getTopicPosts(widget.topic!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
          ), 
        title: Text('#${widget.topic!.topic}',style: TextStyle(color: AppColors.colorBluePrimary,fontSize: 15,fontWeight: FontWeight.bold),),

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<Post>>(
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
            { return Center(child: Text('Could not fetch topics at this time'+snapshot.error.toString()));}

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
          future: topicsPostFuture,
        ),
      ),
    );
  }
}
