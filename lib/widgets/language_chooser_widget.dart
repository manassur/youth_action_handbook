import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/repository/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}


class _LanguagePickerState extends State<LanguagePicker> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, data, child) =>
       Container(
        height: 200.0,
        padding: EdgeInsets.all(20.0),
        color: Colors.transparent, //could change this to Color(0xFF737373),
        //so you don't have to change MaterialApp canvasColor
        child: ListView(
          children: [
            Center(child: Text(AppLocalizations.of(context)!.changeLanguage,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: AppColors.colorBlueSecondary),)),
            SizedBox(height: 20,),
            GestureDetector(
                onTap: (){
                  data.changeLanguage('en');
                  setState(() {
                          AppWrapper.setLocale(context, Locale('en', ""));
                        });
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.english,style: TextStyle(fontSize: 18),)),
           Divider(),
        GestureDetector(
          onTap: (){
            data.changeLanguage('fr');
            setState(() {
                          AppWrapper.setLocale(context, Locale('fr', ""));
                        });
            Navigator.of(context).pop();
          },child: Text(AppLocalizations.of(context)!.french,style: TextStyle(fontSize: 18),)),

          ],
        ),
      ),
    );
  }
}