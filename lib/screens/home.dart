import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
          icon: SvgPicture.asset('assets/menu_alt_03.svg',color: Colors.black54,), // set your color here
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                builder: (builder){
                  return LanguagePicker();
                }
            );
          },
    ),
    actions: [
      MenuForAppBar(),
    ],
    ),
      body:  (appUser==null)? const Loading() : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Good Morning, ',
                    style: const TextStyle(
                        color: Colors.black, fontSize: 25,fontWeight: FontWeight.w900),
                    children: <TextSpan>[
                      TextSpan(text: (appUser.name).split(" ")[0],
                        style: TextStyle(
                            color: AppColors.colorGreenPrimary, fontSize: 25,fontWeight: FontWeight.w900),
                      ),

                    ]
                ),
              ),
              const SizedBox(height: 10,),
              const Text("it's a great day to learn something new.",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 12,color: Colors.black87),),
              const SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    flex: 9,
                      child: (  Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w100),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "Search Anything",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset('assets/search.svg',color: Colors.grey,width: 20,height: 20,),
                                ),
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle:  TextStyle(color: Colors.grey.shade400,fontSize: 15,fontWeight: FontWeight.w100),

                              )))))),
                  Expanded(
                    flex: 2,
                      child: SvgPicture.asset('assets/slider_03.svg'))
                ],
              ),
              SizedBox(height: 25,),
              Text("Open Training courses",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
              SizedBox(height: 10,),
             SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppTexts.trainingItems.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx,pos){
                    return OpenTrainingCard(
                      color:AppTexts.trainingItems[pos].color ,
                      icon: AppTexts.trainingItems[pos].icon,
                      textCount: AppTexts.trainingItems[pos].textCount,
                      textHeader: AppTexts.trainingItems[pos].textHeader,
                    );
                    }
                    ),
              ),
              SizedBox(height: 25,),
              Text("Popular topics",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
              SizedBox(height: 10,),
              GridView.builder(
                itemBuilder: (ctx,pos){
                  return PopularItemCard(popularcategoryModel: AppTexts.popularCategoryItems[pos]);
                },
                padding: EdgeInsets.all(10.0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 2.5
                ),
                itemCount: AppTexts.popularCategoryItems.length,

              ),
              const SizedBox(height: 25,),
              Text("Updates",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary,),),
              const SizedBox(height: 10,),
              ListView.separated(
                  separatorBuilder: (ctx,pos){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: AppTexts.updateItems.length,
                  itemBuilder: (ctx,pos){
                    return UpdatesCard(updatesModel:AppTexts.updateItems[pos] ,
                    );
                  }
              ),

            ],
          ),
        ),
      ),

    );
  }
}
