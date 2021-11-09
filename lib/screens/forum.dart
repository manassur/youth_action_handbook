import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/screens/induvidual_post.dart';
import 'package:youth_action_handbook/screens/new_post.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/topic_category_card.dart';
import 'package:youth_action_handbook/widgets/trending_post_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ForumFragment extends StatefulWidget {
  const ForumFragment({Key? key}) : super(key: key);

  @override
  _ForumFragmentState createState() => _ForumFragmentState();
}

class _ForumFragmentState extends State<ForumFragment> {
  int selected = 0;
  List<String> categoriesList =[
    "Popular",
  "Recommended",
  "New Topic"
  ];
  ScrollController? _scrollController;
  double kExpandedHeight = 120;

  double get _horizontalTitlePadding {
    const kBasePadding = 15.0;
    const kMultiplier = 0.5;

    if (_scrollController!.hasClients) {
      if (_scrollController!.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        return kBasePadding;
      }

      if (_scrollController!.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        return (kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding+40;
      }

      // In case 0%-50% of the expanded height is viewed
      return (_scrollController!.offset - (kExpandedHeight / 2)) * kMultiplier +
          kBasePadding+40;
    }

    return kBasePadding;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBluePrimary,
      body:  NestedScrollView(
        controller:  _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: AppColors.colorBluePrimary,
                elevation: 0,
                expandedHeight: kExpandedHeight,
                leading: IconButton(
                  icon: SvgPicture.asset('assets/menu_alt_03.svg',color: Colors.white,), // set your color here
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
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: _horizontalTitlePadding),
                  title:   RichText(
                    text: TextSpan(
                        text: 'Forum',
                        style: TextStyle(
                            color: AppColors.colorYellow, fontSize: 20,fontWeight: FontWeight.w900),
                        children: const <TextSpan>[

                        ]
                    ),
                  ),
                )
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(
                      width: 250,
                      child: Text("Find topics you like to read, engage with communities and ask questions.",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.white),),
                    ),
                    SizedBox(height: 25,),
                     Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.colorGreenPrimary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: TextFormField(
                                style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w100),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: "Search Anything",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset('assets/search.svg',color: Colors.white70,width: 20,height: 20,),
                                  ),
                                  border: InputBorder.none,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  hintStyle:  TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w100),

                                )))),
                    SizedBox(height: 10,),



                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF2F7FA),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                  ),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categoriesList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx,pos){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selected = pos;
                                  });
                                },
                                child: TopicCategoryCard(
                                  title: categoriesList[pos],
                                  isSelected:pos==selected
                                  ),
                              );
                            }
                        ),
                      ),
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
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: AppTexts.topicItems.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx,pos){
                             return InkWell(
                                onTap:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => InduvidualPostScreen()),
                                  );
                                },
                                child: TopicCard(
                                    topicModel: AppTexts.topicItems[pos],
                                ),
                              );
                            }
                        ),
                      ),
                      SizedBox(height:20),
                      RichText(
                        text: TextSpan(
                            text: 'Trending Posts',
                            style: TextStyle(
                                color: AppColors.colorBluePrimary, fontSize: 20,fontWeight: FontWeight.w900),
                            children: const <TextSpan>[

                            ]
                        ),
                      ),
                      SizedBox(height:10),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: AppTexts.trendingItems.length,
                          itemBuilder: (ctx,pos){
                            return InkWell(
                              onTap:(){

                              },
                              child: TrendingPostsCard(trendingPostModel:AppTexts.trendingItems[pos] ,
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorBluePrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostScreen()),
          );
        },

        child: Icon(Icons.add,color: Colors.white,),
      ),

    );
  }
}
