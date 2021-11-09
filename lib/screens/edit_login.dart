
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:youth_action_handbook/widgets/language_chooser_widget.dart';

class EditLoginScreen extends StatefulWidget {
  @override
  _EditLoginScreenState createState() => _EditLoginScreenState();
}

class _EditLoginScreenState extends State<EditLoginScreen> {
  
  List controllers = [];
  
  // final _formKey = GlobalKey<FormState>();
  bool _isSet = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData size = MediaQuery.of(context);
    final appUser = Provider.of<AppUser?>(context);

     //EditLogin COLUMN
    List settingItems = [
      {
        "leading_icon": Icons.email_outlined,
        "value": appUser!.email,
        "display_value": appUser.email,
        "leading": "Email Address",
        "name": "email",
        "trailing_icon": Icons.edit,
        "index":0
      },
      {
        "leading_icon": Icons.mark_email_read_outlined,
        "value": appUser.emailVerified,
        "display_value": appUser.emailVerified.toString(),
        "leading": "Email Verified?",
        "name": "emailVerified",
        "trailing_icon": Icons.edit,
        "index":1
      },
      {
        "leading_icon": Icons.lock_outline,
        "value": '      ',
        "display_value": '******',
        "leading": "Password",
        "name": "password",
        "trailing_icon": Icons.edit,
        "index":2
      },
      
    ];
    
      itemEdit(item, context) async{
        String message = '';
        final chosenIndex = item['index'];
        bool loading = false;
       
        
        await showDialog(context: context, builder: (BuildContext context) {
          return  SimpleDialog(
              title:  Text("Edit " + item['leading'].toString()),
                contentPadding: const EdgeInsets.all(12),
                children: loading? [const Loading()]: [

                    if(chosenIndex==1)
                        DropDownEditWidget(
                          title: item['leading'],
                          icon: item['leading_icon'],
                          initialValue: item['value'] ,
                          values: 
                          (chosenIndex == 2) ? const [
                            DropdownMenuItem(child: Text(AppTexts.english),value: 'en',),
                            DropdownMenuItem(child: Text(AppTexts.french),value: 'FR',),] :
                          const [
                            DropdownMenuItem(child: Text(AppTexts.female),value:'F',),
                            DropdownMenuItem(child: Text(AppTexts.male),value:'M',),
                            DropdownMenuItem(child: Text(AppTexts.other),value:'O',)

                          ],

                          setValue:  (index,value) async{
                            try{
                              loading = true;
                              message = await DatabaseService(uid: appUser.uid).updateField(item['name'], value);
                            }on FirebaseException catch(e){
                              message = e.message ?? 'An Error Occured';
                            }catch (e){
                              message = e.toString();
                            }
                            setState((){
                              // message = message;
                              yahSnackBar(context, message);
                              Navigator.pop(context);
                              loading = false;
                            });
                          }),


                    if(chosenIndex == 4)
                      CountryWidget(initialValue: item['value'], setValue:  (index,value) async{
                                      try{
                                        loading = true;
                                        message = await DatabaseService(uid: appUser.uid).updateField(item['name'], value);
                                      }on FirebaseException catch(e){
                                        message = e.message ?? 'An Error Occured';
                                      }catch (e){
                                        message = e.toString();
                                      }
                                      setState((){
                                        // message = message;
                                        yahSnackBar(context, message);
                                        Navigator.pop(context);
                                        loading = false;
                                      });
                                    }, size: size),
              
                  
                    if(chosenIndex ==0)
                    LoginTextEditWidget(title: item['leading'],icon:item['leading_icon'], initialValue: item['value'] ,setValue:  (value,currrentEmail) async{
                      final AuthService _auth = AuthService();
                      try{
                        loading = true;
                        message = await _auth.changeEmail(currrentEmail, value);
                        
                      }on FirebaseException catch(e){
                        message = e.message ?? 'An Error Occured';
                      }catch (e){
                        message = e.toString();
                      }
                      setState((){
                        message = message;
                        yahSnackBar(context, message);
                        Navigator.pop(context);
                        loading = false;
                      });
                    }),
                    
                    if(chosenIndex ==3)
                    LoginTextEditWidget(title: item['leading'],icon:item['leading_icon'], initialValue: item['value'] ,setValue:  (value,currrentPassword) async{
                      final AuthService _auth = AuthService();
                      try{
                        loading = true;
                        message = await _auth.changePassword(currrentPassword, value);
                        
                      }on FirebaseException catch(e){
                        message = e.message ?? 'An Error Occured';
                      }catch (e){
                        message = e.toString();
                      }
                      setState((){
                        message = message;
                        yahSnackBar(context, message);
                        Navigator.pop(context);
                        loading = false;
                      });
                    }),
                    
                  ]
            );
          });

    }



    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorBluePrimary,
        elevation: 0,
        title:  RichText(
          text: TextSpan(
              text: 'Edit Login Information',
              style: TextStyle(
                  color: AppColors.colorYellow, fontSize: 20,fontWeight: FontWeight.w900),
              children: const <TextSpan>[

              ]
          ),
        ),
        actions:  [
          MenuForAppBar(),
        ],
      ),

      body:ListView(
          children: <Widget>[
             Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15.0,),
                child:ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: settingItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            settingItems[index]['leading_icon'], color: AppColors.colorPurple,
                          ),
                          title: Text(
                            settingItems[index]['leading'] +' : '+ settingItems[index]['display_value'],
                          ),
                          trailing: Icon(
                            settingItems[index]['trailing_icon'],color: Colors.black87, size: 18,
                          ),
                          onTap: () => itemEdit(settingItems[index],context),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 1, color: Colors.grey, indent: 15, endIndent: 10,);
                    },
                  ),
                ),
            
          ],
        ),
    );
  }

    // oitemEdit(item, context) async{ await yahSnackBar(context, 'WORKING');}
   
}


enum EditEnum {
name,
organisation,
language,
country,
displayName,
email,
emailVerified,
phoneNumber,
}


class LoginTextEditWidget extends StatefulWidget {
  final Function setValue;
  final String initialValue;
  final String title;
  final IconData icon;

  LoginTextEditWidget({
    Key? key,
    required this.setValue,
    required this.initialValue,
    required this.title,
    required this.icon,
  }) : super(key: key);


  @override
  State<LoginTextEditWidget> createState() => _LoginTextEditWidgetState();
}

class _LoginTextEditWidgetState extends State<LoginTextEditWidget> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  void initState() {
    // TODO: implement initState

    super.initState();
    nameController.text = widget.initialValue;
    // passwordController.text = widget.initialValue;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(
                  color: AppColors.colorBlueSecondary,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                        controller: nameController,
                        obscureText: (widget.title == 'Password')? true :false,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            widget.icon,
                            color: AppColors.colorGreenPrimary,
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w100),
                        )))),
            const SizedBox(
              height: 20,
            ),
            const Text(AppTexts.enterCurrentPassword),
            Container(
                decoration: BoxDecoration(
                  color: AppColors.colorBlueSecondary,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.colorGreenPrimary,
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w100),
                        )))),
          
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 200.0,
          height: 50,
          child: ElevatedButton(
            child: const Text(AppTexts.save),
            onPressed: () {
              if (passwordController.text == '' || nameController.text == '') {
                yahSnackBar(context, 'Fields cannot be blank');
              } else {
                setState(() {
                  widget.setValue(nameController.text, passwordController.text);
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
    );
  }
}


class DropDownEditWidget extends StatefulWidget {
  final Function setValue;
  final String initialValue;
  final String title;
  final IconData icon;
  final List<DropdownMenuItem<String>>? values;

  DropDownEditWidget({
    Key? key,
    required this.setValue,
    required this.initialValue,
    required this.values,
    required this.title,
    required this.icon,
  }) : super(key: key);


  @override
  State<DropDownEditWidget> createState() => _DropDownEditWidgetState();
}

class _DropDownEditWidgetState extends State<DropDownEditWidget> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _currentValue = widget.initialValue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
           
            const SizedBox(
              height: 20,
            ),
           
            Container(
                decoration: BoxDecoration(
                  color: AppColors.colorBlueSecondary,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: DropdownButtonFormField(
                      value: _currentValue,
                      onChanged: (val2)=> _currentValue = val2 as String,
                      items: widget.values,
                      dropdownColor: AppColors.colorBlueSecondary,
                      style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            widget.icon,
                            color: AppColors.colorGreenPrimary,
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w100),
                        )
                    )
                  )
        ),
          ]),
        const SizedBox(
          height: 30,
        ),
        
        SizedBox(
          width: 200.0,
          height: 50,
          child: ElevatedButton(
            child: const Text(AppTexts.save),
            onPressed: () {
              if (_currentValue == null || _currentValue == '') {
                yahSnackBar(context, 'Field cannot be blank');
              } else {
                setState(() {
                  widget.setValue(0, _currentValue);
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
    );
  }
}



class CountryWidget extends StatefulWidget {
  final Function setValue;
  final String initialValue;
  const CountryWidget({
    Key? key,
    required this.size,
    required this.setValue,
    required this.initialValue,
  }) : super(key: key);

  final MediaQueryData size;

  @override
  State<CountryWidget> createState() => _CountryWidgetState();
}

class _CountryWidgetState extends State<CountryWidget> {
  String country = '';


  void _onCountryChange(CountryCode countryCode) {
    country = countryCode.code.toString();
  }

  @override
  Widget build(BuildContext context) {
    country = widget.initialValue;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.colorBlueSecondary,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: CountryCodePicker(
                            onChanged: _onCountryChange,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: country,
                            favorite: const ['UG', 'RW', 'CD'],
                            textStyle: const TextStyle(color: Colors.white),
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: true,
                            // optional. aligns the flag and the Text left
                            alignLeft: true,
                            dialogSize: Size(widget.size.size.width / 1.2,
                                widget.size.size.height / 1.2),
                          ),
                        ),
                        const Expanded(
                            flex: 2,
                            child: Icon(Icons.arrow_drop_down,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 200.0,
          height: 50,
          child: ElevatedButton(
            child: const Text(AppTexts.save),
            onPressed: () {
              widget.setValue(2, country);
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
    );
  }
}


