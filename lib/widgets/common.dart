// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitChasingDots(
        color: Colors.blue,
        size: 50.0,
      ),
    );
  }
}

yahSnackBar(context, e, {Color? color, Color? textColor}) {
  final msg;
  if(e is String){
    msg = e;
  }
  else if(e is FirebaseException || e is FirebaseAuthException){
    msg = e.message;
  }
  else{
    msg = e.toString();
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: (color != null)? color :AppColors.colorYellow,
      content: Text(
        msg ?? AppLocalizations.of(AppWrapper.navigatorKey.currentContext!)!.anErrorOccurredPleaseTryAgain,
        style: TextStyle(fontSize: 15.0, color: (textColor != null)? textColor : Colors.black),
      ),
    ),
  );
  return null;
}

class MenuForAppBar extends StatelessWidget {
  MenuForAppBar({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    void onSelected(BuildContext context, int item) async {
      switch (item) {
        case 0:
          Navigator.pushNamed(context, RouteNames.editProfile);
          break;
        case 1:
          Navigator.pushNamed(context, RouteNames.editLogin);
          break;
        case 2:
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.initialScreen, (route) => false);
          await _auth.signOut(context);
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton<int>(
        child:   CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 20,
          // backgroundImage:  NetworkImage(appUser!.profilePicture??''),
          backgroundImage:  CachedNetworkImageProvider((appUser!.profilePicture == null || appUser.profilePicture == '')?'https://studio.rtl.ug/yah/user.png':appUser.profilePicture!),
        ),
        color: Colors.indigo,
        onSelected: (item) => onSelected(context, item),
        itemBuilder: (context) => [
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  AppLocalizations.of(AppWrapper.navigatorKey.currentContext!)!.editProfile,
                  style: TextStyle(color: Colors.white),
                ),
                // CircleAvatar(
                //   backgroundColor: Colors.black87,
                //   radius: 20,
                //   backgroundImage:  NetworkImage(appUser!.photoURL!),
                // )
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  AppLocalizations.of(AppWrapper.navigatorKey.currentContext!)!.editLoginInfo,
                  style: TextStyle(color: Colors.white),
                ),
                // CircleAvatar(
                //   backgroundColor: Colors.black87,
                //   radius: 20,
                //   backgroundImage:  NetworkImage(appUser!.photoURL!),
                // )
              ],
            ),
          ),
          const PopupMenuDivider(),
          
          PopupMenuItem<int>(
            value: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(AppWrapper.navigatorKey.currentContext!)!.signOut,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                Icon(Icons.logout),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final String? url;

  const Avatar({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((url == '') || (url == null)) {
      return Hero(
          tag: 'Default User Avatar Image',
          child: CircleAvatar(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset('assets/user.png'),
            ),
          ));
    }
    return Hero(
      tag: 'User Avatar Image',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: url!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          )),
    );
  }
}

class TopLangMenu extends StatelessWidget {
  TopLangMenu({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void onSelected(BuildContext context, int item) async {
      switch (item) {
        case 0:
          Navigator.pushNamed(context, RouteNames.editProfile);
          break;
        case 1:
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.loginScreen, (route) => false);
          await _auth.signOut(context);
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton<int>(
        child: const Avatar(url: "https://studio.rtl.ug/yah/user.png"),
        color: Colors.indigo,
        onSelected: (item) => onSelected(context, item),
        itemBuilder: (context) => [
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(AppWrapper.navigatorKey.currentContext!)!.settings,
                  style: TextStyle(color: Colors.white),
                ),
                Avatar()
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(AppWrapper.navigatorKey.currentContext!)!.signOut,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                Icon(Icons.logout),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}


launchURL(context, url) async {
  // const url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    yahSnackBar(context, AppLocalizations.of(AppWrapper.navigatorKey.currentContext!)!.cantOpenWebsite);
    // throw 'Could not launch $url';
  }
}

String convertDate(Timestamp timeStamp, {String newFormat='d MMM y'}) {
    String formattedDate = DateFormat(newFormat).format(timeStamp.toDate());
    return formattedDate;
  }