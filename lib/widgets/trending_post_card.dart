import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/trending_post_model.dart';

class TrendingPostsCard extends StatelessWidget {
  final TrendingPostModel? trendingPostModel;
  const TrendingPostsCard({Key? key,this.trendingPostModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Image.asset("assets/user.png"),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 240,
                      child: Text(trendingPostModel!.question!,style: TextStyle(color: AppColors.colorBluePrimary,fontSize: 14,fontWeight: FontWeight.bold))),
                 SizedBox(height: 5,),
                  Text(trendingPostModel!.name!,style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),

                ],
              ),
              Icon(Icons.favorite,color:Color(0xFF2E3A59)),
            ],
          ),
          SizedBox(height: 10,),

          Text(trendingPostModel!.description!,style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black54,fontSize: 12),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_off_alt,color: Colors.grey.shade400,size:16),
                    SizedBox(width: 5,),
                    Text('120 Likes',style: TextStyle(color: Colors.grey.shade500,fontSize: 11),)
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline,color: Colors.grey.shade400,size: 16,),
                    SizedBox(width: 5,),
                    Text('20 Replies',style: TextStyle(color: Colors.grey.shade500,fontSize: 11),)
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.visibility_outlined,color: Colors.grey.shade400,size: 16,),
                    SizedBox(width: 5,),
                    Text('200 Views',style: TextStyle(color: Colors.grey.shade500,fontSize: 11),)
                  ],
                ),

              ],
            ),
        ],
      ),
    );
  }
}
