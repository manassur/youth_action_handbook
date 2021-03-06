import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/bloc/courses/courses_bloc.dart';
import 'package:youth_action_handbook/bloc/courses/courses_event.dart';
import 'package:youth_action_handbook/bloc/courses/courses_state.dart';
import 'package:youth_action_handbook/bloc/news/news_bloc.dart';
import 'package:youth_action_handbook/bloc/news/news_event.dart';
import 'package:youth_action_handbook/bloc/news/news_state.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/course_with_language_response.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/repository/language_provider.dart';
import 'package:youth_action_handbook/screens/individual_course.dart';
import 'package:youth_action_handbook/services/api_service.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'search.dart';
import 'topic_posts.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  CoursesBloc? coursesBloc;
  NewsBloc? newsBloc;
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<Topic>>? topicFuture;
  LanguageProvider? langProvider;
  TextEditingController? searchController;
  CourseResponse? courseResponse;
  
  bool showAlert = false;

  @override
  void initState() {
    coursesBloc= BlocProvider.of<CoursesBloc>(context);
    langProvider= Provider.of<LanguageProvider>(context,listen:false);
    langProvider!.setupCourseLanguages();

    newsBloc= BlocProvider.of<NewsBloc>(context);
    newsBloc!.add(FetchNewsEvent());

    dbservice = DatabaseService();
    topicFuture =  dbservice!.getTopics();

    searchController = TextEditingController();



    //dbservice!.createTopic('Family');

    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, ()async{
      // Exists to nullify existing course cache if changes are detected
      final ApiService apiService = ApiService();
      showAlert = await apiService.checkForCourseUpdates();
      if(showAlert) yahSnackBar(context, 'New Course Content Loaded');
      });
    });
  }

 

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: Colors.white,
         systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
          ), 
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
                  return const LanguagePicker();
                }
            );
          },
    ),
    actions: [
      appUser==null?SizedBox():MenuForAppBar(),
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
                    // text: 'Good Morning, ',
                    text: AppLocalizations.of(context)!.hello + ", ",
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
              Text( AppLocalizations.of(context)!.itsaGreatDayToLearnSomethingNew ,style: TextStyle(fontWeight: FontWeight.w100,fontSize: 12,color: Colors.black87),),
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
                          padding: const EdgeInsets.all(5),
                          child: TextFormField(
                            controller: searchController,
                              style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w100),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.searchAnything,
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
                      child: IconButton(icon:Icon(Icons.search,color: AppColors.colorBluePrimary,),
                        onPressed: (){

                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider<CoursesBloc>(
                                          create: (context) =>
                                              CoursesBloc(apiService: ApiService()),
                                          child: Search(query: searchController!.text,)))
                          ).then((value) => searchController!.clear());




                        },))
                ],
              ),
            const  SizedBox(height: 25,),
              Text(AppLocalizations.of(context)!.recommendedCourses,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
             const SizedBox(height: 10,),
              SizedBox(
                height: 300,
                child:      Consumer<LanguageProvider>(
                  builder: (context, lang, child) {

                    if(lang.isLoading){
                      return buildLoading();
                    }else if(lang.hasError){
                      return Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lang.errorText),
                          SizedBox(height: 20,),
                           SizedBox(
                            width: 150.0,
                            height: 50,
                            child: ElevatedButton(
                              child: Text(AppLocalizations.of(context)!.tapToReload),
                              onPressed: () {
                                {
                                  setState(() {
                                    langProvider!.setupCourseLanguages();
                                    yahSnackBar(context, AppLocalizations.of(context)!.tryingToReloadIfItFailsTryRestartingTheApp);
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      AppColors.colorGreenPrimary),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ))),
                            ),
                          ),
                      
                        ],
                      ));
                    }else{
                      return  ListView.builder(
                          shrinkWrap: true,
                          itemCount: lang.getCourseByLanguage.courses!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, pos) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IndividualCourseScreen(
                                                courses: lang.getCourseByLanguage
                                                    .courses![pos],)));
                                },
                                child: OpenTrainingCard(
                                    courseModel: lang.getCourseByLanguage
                                        .courses![pos]));
                          });
                    }

                  }),
              ),

             const SizedBox(height: 25,),
              Text(AppLocalizations.of(context)!.popularTopics,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
             const SizedBox(height: 10,),

              SizedBox(
                height: 150,
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
                    { return Center(child: Text(AppLocalizations.of(context)!.couldNotFetchPostsAtThisTime +snapshot.error.toString()));}

                    return   GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 1.0,
                            mainAxisSpacing: 3.0,
                            childAspectRatio: 0.3,


                        ),
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
                              scaleFactor: 0.9,
                            ),
                          );
                        }
                    );
                  },
                  future: topicFuture,
                ),

              ),
              const SizedBox(height: 25,),
              Text(AppLocalizations.of(context)!.updates,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary,),),
              const SizedBox(height: 10,),

              BlocListener<NewsBloc, NewsState>(
                listener: (context, state){
                  if ( state is NewsLoadedState && state.message != null ) {
                  }
                  else if ( state is NewsLoadFailureState ) {
                    yahSnackBar(context, AppLocalizations.of(context)!.couldNotLoadNewsUpdateAtThisTime);
                    
                  }
                },
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if ( state is NewsInitialState ) {
                      return buildLoading ( );
                    } else if ( state is NewsLoadingState ) {
                      return buildLoading ( );
                    } else if ( state is NewsLoadedState ) {
                      return
                        ListView.separated(
                            separatorBuilder: (ctx,pos){
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(),
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.news!.length,
                            itemBuilder: (ctx,pos){
                              return UpdatesCard(newsUpdate:state.news![pos] ,
                              );
                            }
                        );
                    } else if ( state is NewsLoadFailureState ) {
                      return buildErrorUi (state.error.toString() );
                    }
                    else {
                      return buildErrorUi ( AppLocalizations.of(context)!.somethingWentWrong );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget buildLoading ( ) {
    return const Center (
      child: CircularProgressIndicator () ,
    );
  }

  Widget buildErrorUi ( String message ) {
    return Center (
      child: Text ( message , style: const  TextStyle ( color: Colors.black, fontSize: 15 ) ,
      ) ,
    );
  }

}
