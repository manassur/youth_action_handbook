import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class CustomBottomNavItem extends StatelessWidget {
 final String? icon;
 final bool? isSelected;
  const CustomBottomNavItem({Key? key,this.icon,this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon!,
      width: 20,
      height: 20,
      color: isSelected!?AppColors.colorBluePrimary:Colors.grey[400],
    );
  }
}
