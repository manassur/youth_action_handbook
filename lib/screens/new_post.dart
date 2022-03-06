import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/firestore_models/post_model.dart';
import 'package:youth_action_handbook/models/firestore_models/topic_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  Topic? _selectedTopic;
  TextEditingController _captionController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AppUser? appUser;
  bool _isLoading = false;
  String? _currentUserId;
  DatabaseService? dbservice;
  List<Topic>? topics = [];
  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);

    dbservice!.getTopics().then((value) => {
    setState((){
    topics = value;
    })

    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _submit() async {
    final filter = ProfanityFilter();
    String _theCaption= _captionController.text.trim();
    String _theDescription = _descriptionController.text.trim();

    FocusScope.of(context).unfocus();
    if (!(_theCaption.isNotEmpty) || !(_theDescription.isNotEmpty) || _selectedTopic == null) {
      // toast that fields cannot be empty
      yahSnackBar(context, AppLocalizations.of(context)!.pleaseFillInAllFieldsBeforeSubmitting);
    }
    else if(filter.hasProfanity(_theCaption) || filter.hasProfanity(_theDescription)){
      yahSnackBar(context,AppLocalizations.of(context)!.sorryProfanityWasDetectedInYourTextPleaseEditAndTrySubmittingAgain);
    }
    else {
      if (!_isLoading) {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        //Create new Post
        Post post = Post(
          topicId: _selectedTopic!.id,
          caption: _theCaption,
          description: _theDescription,
          likeCount: 0,
          replyCount: 0,
          authorName: appUser!.name,
          authorImg: appUser!.profilePicture,
          authorId: _currentUserId,
          timestamp: Timestamp.fromDate(DateTime.now()),
          commentsAllowed: true,
        );

        dbservice!.createPost(post).whenComplete(() =>
        {
          setState(() {
            _isLoading = false;
          }),
          yahSnackBar(context, AppLocalizations.of(context)!.successfullyPosted),
          Navigator.pop(context,true)
        }).catchError((e) {
          setState(() {
            _isLoading = false;
          });
          yahSnackBar(context,AppLocalizations.of(context)!.couldNotCreatePostAtThisTime);
        });
      }
      }
    
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
          ), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: AppColors.colorBluePrimary,), // set your color here
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions:  [
          MenuForAppBar(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: AppLocalizations.of(context)!.makeaPost,
                        style: TextStyle(
                            color: AppColors.colorBluePrimary, fontSize: 25,fontWeight: FontWeight.w900),
                        children: const <TextSpan>[

                        ]
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 250,
                    child: Text(AppLocalizations.of(context)!.findTopicsYouLikeToReadEngageWithCommunitiesAndAskQuestions,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey[500]),),
                  ),




                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade100,
                                      spreadRadius: 4,
                                      blurRadius: 5
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left:50,top:15,bottom: 15,right:15),
                              child: DropdownButton<Topic>(
                                focusColor:Colors.white,
                                isExpanded: true,
                                value: _selectedTopic,
                                //elevation: 5,
                                style: TextStyle(color: Colors.white),
                                iconEnabledColor:Colors.black,
                                underline: SizedBox(),
                                items: topics!.map<DropdownMenuItem<Topic>>((Topic value) {
                                  return DropdownMenuItem<Topic>(
                                    value: value,
                                    child: Text(value.topic!,style:TextStyle(color:Colors.black),),
                                  );
                                }).toList(),
                                hint:Text(
                                  AppLocalizations.of(context)!.chooseaTopic,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                onChanged: (Topic? value) {
                                  setState(() {
                                    _selectedTopic = value;
                                  });
                                },
                              ),)),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Text(AppLocalizations.of(context)!.postYourQuestionOrStartaDiscussion,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey[500]),),
                  SizedBox(height: 25,),
                  Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal:10),
                          child: TextFormField(
                            controller: _captionController,
                              maxLines: 2,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value){
                                _submit;
                              },
                              style: const TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w100),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.title,
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle:  TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w100),
                              )))),
                  SizedBox(height: 25,),
                  Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                              controller: _descriptionController,
                              maxLines: 6,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w100),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.description,
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle:  TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w100),
                              )))),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child:TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary),
                                shadowColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary.withOpacity(0.4)),
                                elevation: MaterialStateProperty.all(5), //Defines Elevation
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                            child:
                            !_isLoading? Text(AppLocalizations.of(context)!.makeaPost,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),):
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Center(
                                child: SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            onPressed:  _submit ,

                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            ),




          ],
        ),
      ),


    );
  }
}
