import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/news_response.dart';

class UpdatesCard extends StatelessWidget {
  final News? newsUpdate;
  const UpdatesCard({Key? key, this.newsUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              newsUpdate!.image!,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, exception,stackTrace) {
                return Container( height: 80,
                  width: 80,
                  color:Colors.grey.shade100
                );
              },
            ),
          ),
         const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(newsUpdate!.title!,
                    style: TextStyle(
                      color: AppColors.colorBluePrimary, fontSize: 12,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Gilroy',
                    )),
                 Text(
                  newsUpdate!.blurb!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style:  const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w300),
                ),
               const SizedBox(
                  height: 10,
                ),
                Text(
                  'see more',
                  style: TextStyle(
                      color: AppColors.colorPurple,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
