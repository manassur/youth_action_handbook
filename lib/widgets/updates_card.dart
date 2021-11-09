import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/popular_category_model.dart';
import 'package:youth_action_handbook/models/updates_model.dart';

class UpdatesCard extends StatelessWidget {
  final UpdatesModel? updatesModel;
  const UpdatesCard({Key? key, this.updatesModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              updatesModel!.icon!,
              height: 80,
              width: 80,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(updatesModel!.textHeader!,
                    style: TextStyle(
                      color: AppColors.colorBluePrimary, fontSize: 12,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Gilroy',
                    )),
                Container(
                  child: Text(
                    'Lorem ipsum dolor sit ameta cursh qqoe or qsome othe tews to bw set for now us telit a Pellentesque mollis',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
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
