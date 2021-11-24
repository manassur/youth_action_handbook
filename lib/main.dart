import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/screens/dashboard.dart';
import 'package:youth_action_handbook/screens/edit_login.dart';
import 'package:youth_action_handbook/screens/initial_screen.dart';
import 'package:youth_action_handbook/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/screens/partners.dart';
import 'package:youth_action_handbook/screens/reset_password.dart';
import 'package:youth_action_handbook/screens/edit_profile.dart';
import 'package:youth_action_handbook/screens/sign_up.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("42349d73-616f-4579-afbd-4ba2c7df76c0");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });
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

class AppWrapper extends StatelessWidget {
  AppWrapper({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: (user == null)? null : DatabaseService().appUserStream(user),
      builder: (context, snapshot) {
        return MaterialApp(
            title: 'Youth Action Handbook',
            debugShowCheckedModeBanner: false,
            // supportedLocales: AppTexts.supportedLocales,
            // localizationsDelegates: const [
            //   CountryLocalizations.delegate,
            // ],
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
