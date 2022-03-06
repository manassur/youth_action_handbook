import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/repository/language_provider.dart';
import 'package:youth_action_handbook/screens/dashboard.dart';
import 'package:youth_action_handbook/screens/edit_login.dart';
import 'package:youth_action_handbook/screens/initial_screen.dart';
import 'package:youth_action_handbook/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/screens/partners.dart';
import 'package:youth_action_handbook/screens/reset_password.dart';
import 'package:youth_action_handbook/screens/edit_profile.dart';
import 'package:youth_action_handbook/screens/sign_up.dart';
import 'package:youth_action_handbook/screens/web_view.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youth_action_handbook/widgets/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("fdf6a04d-2f10-4e6b-9b8f-3a50584d5f38");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //   print('AKBR THIS ONE WORKED');
  //   // Will be called whenever a notification is opened/button pressed.
  // });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
     return StreamProvider<User?>.value(
       value: AuthService().user,
       initialData: null,
       child: AppWrapper(),
     );
  }
}

class AppWrapper extends StatefulWidget {
  AppWrapper({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey = 
  GlobalKey<NavigatorState>();

   /*
  To Change Locale of App
   */
  static void setLocale(BuildContext context, Locale newLocale) async {
    _AppWrapperState? state = context.findAncestorStateOfType<_AppWrapperState>();

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', newLocale.languageCode);

    state?.setState(() {
      state._locale = newLocale;
    });
    
  }

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {

  Locale _locale = Locale('en');

  @override
  void initState() {
    super.initState();
    // OneSignalWrapper.handleClickNotification(context);
    this._fetchLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
  }


  /*
  To get local from SharedPreferences if exists
   */
  Future<Locale> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    //get device locale to use as default if there is none, but only if it is french or enlgish
    // String deviceLocale = Localizations.localeOf(context).languageCode;
    findSystemLocale();
    String deviceLocale= Intl.systemLocale.split("_")[0];
    deviceLocale = (deviceLocale == 'en' || deviceLocale == 'fr')? deviceLocale : 'en';

    String languageCode = prefs.getString('languageCode') ?? (deviceLocale);

    return Locale(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: (user == null)? null : DatabaseService().appUserStream(user),
      builder: (context, snapshot) {
        return  ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
          child: MaterialApp(
              title: 'Youth Action Handbook',
              debugShowCheckedModeBanner: false,
              // supportedLocales: AppTexts.supportedLocales,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                CountryLocalizations .delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: _locale,
              // locale: Locale("fr"),
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: GoogleFonts.latoTextTheme()
              ),
              routes:{
                RouteNames.signUpScreen: (context) => const SignUpScreen(),
                RouteNames.initialScreen: (context) => const InitialScreen(),
                RouteNames.loginScreen: (context) => const LoginScreen(),
                RouteNames.resetPassword: (context) => const ResetPassword(),
                RouteNames.dashboard: (context) => const Dashboard(),
                RouteNames.editProfile: (context) => EditProfileScreen(),
                RouteNames.editLogin: (context) => EditLoginScreen(),
                RouteNames.partners: (context) => PartnersScreen(),
                RouteNames.launch : (context) => (user != null)? const Dashboard() : const InitialScreen(),

              },
              home: (user != null)? const Dashboard() : const InitialScreen(),
              navigatorKey: AppWrapper.navigatorKey,

            ),
        );
      }
    );
  }
}

class RouteNames{
  static const signUpScreen = '/SignUpScreen';
  static const loginScreen = '/Login'; 
  static const initialScreen = '/initialScreen';
  static const resetPassword = '/resetPassword'; 
  static const dashboard = '/Dashboard'; 
  static const editProfile = '/EditProfile'; 
  static const editLogin = '/EditLogin'; 
  static const launch = '/launch';
  static const partners = '/partners';

}


class OneSignalWrapper{
  static void handleClickNotification(BuildContext context) {
    print('AKBR IT WORKED');
      try {
        OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
          final launchUrl = await result.notification.launchUrl;
          print('AKBR THE LAUNCHURL IS: '+ launchUrl.toString());

          if(launchUrl != null){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebViewScreen(link:launchUrl))); 
          }else{
            yahSnackBar(context, 'NO URL to VISIT');
          }
        });
      } catch (e) {
        print('AKBR OneSignal:'+ e.toString());
        yahSnackBar(context, e);
      }
  }
}