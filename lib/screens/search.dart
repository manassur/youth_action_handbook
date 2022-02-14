import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/bloc/courses/courses_bloc.dart';
import 'package:youth_action_handbook/bloc/courses/courses_event.dart';
import 'package:youth_action_handbook/bloc/courses/courses_state.dart';
import 'package:youth_action_handbook/bloc/news/news_bloc.dart';
import 'package:youth_action_handbook/bloc/news/news_event.dart';
import 'package:youth_action_handbook/bloc/news/news_state.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/repository/language_provider.dart';
import 'package:youth_action_handbook/screens/individual_course.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';
import 'package:youth_action_handbook/widgets/open_training_card.dart';
import 'package:youth_action_handbook/widgets/popular_items_card.dart';
import 'package:youth_action_handbook/widgets/topic_card.dart';
import 'package:youth_action_handbook/widgets/updates_card.dart';

import 'topic_posts.dart';

class Search extends StatefulWidget {
  final String? query;
  const Search({Key? key,this.query}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  CoursesBloc? coursesBloc;
  NewsBloc? newsBloc;
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  Future<List<Topic>>? topicFuture;
  LanguageProvider? langProvider;
  TextEditingController? searchController;
  String? searchQuery;
  CourseResponse? courseBank;
  List<Courses>? searchResults=[];

  @override
  void initState() {
    coursesBloc= BlocProvider.of<CoursesBloc>(context);
    langProvider= Provider.of<LanguageProvider>(context,listen:false);

    coursesBloc!.add(FetchCoursesEvent());
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);


    searchController = TextEditingController();
    searchController!.text = widget.query!;



    super.initState();
  }

  void performSearch(){
    if(searchController!.text.isNotEmpty) {
        searchResults = courseBank!.courses!.where((element) =>
            element.title!.toLowerCase().contains(searchController!.text.toLowerCase()) ||  element.description!.toLowerCase().contains(searchController!.text.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: Colors.white,
         systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
          ), 
          elevation: 0,
          title: Text('Search',style: TextStyle(color: Colors.black),),
          leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,), // set your color here
          onPressed: () {
         Navigator.pop(context);
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

              Row(
                children: [
                  Expanded(
                    flex: 9,
                      child: GestureDetector(
                        onTap: (){},
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
                                onChanged: (value){
                                performSearch();
                                langProvider!.refresh();

                                },
                                style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w100),
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

                                ))))),
                      )),
                    // Expanded(
                    //   flex: 2,
                    //   child: SvgPicture.asset('assets/slider_03.svg'))
                ],
              ),
            const  SizedBox(height: 25,),
              Text("Search Results",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.colorBluePrimary),),
             const SizedBox(height: 10,),
              SizedBox(
                height: 300,
                child:      Consumer<LanguageProvider>(
                  builder: (context, lang, child) {
                    var courseResponse = langProvider!.getCourseByLanguage;
                    courseBank = courseResponse;
                    searchResults = courseBank!.courses;
                    performSearch();

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, pos) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IndividualCourseScreen(
                                              courses: searchResults![pos],)));
                              },
                              child: OpenTrainingCard(
                                  courseModel: searchResults![pos]));
                        });
                  }),
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
