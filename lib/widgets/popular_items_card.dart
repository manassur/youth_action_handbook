import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/popular_category_model.dart';

class PopularItemCard extends StatelessWidget {
  final PopularcategoryModel? popularcategoryModel;
  const PopularItemCard( {Key? key,this.popularcategoryModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
      padding: EdgeInsets.only(left: 10),

      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(15.0),
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color:popularcategoryModel!.color!,
                borderRadius: BorderRadius.circular(5)
            ),
            child: Image.asset(popularcategoryModel!.icon!),
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(popularcategoryModel!.textHeader!,style: TextStyle(color: AppColors.colorBluePrimary,fontSize: 12,fontWeight: FontWeight.bold)),
              Text(popularcategoryModel!.textCount!,style: TextStyle(color: Colors.grey,fontSize: 10),),

            ],
          )
        ],
      ),
    );
  }
}
