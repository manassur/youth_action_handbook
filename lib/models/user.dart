import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_action_handbook/models/country_model.dart';
import 'package:youth_action_handbook/services/database.dart';

class AppUser{
  

  final String uid;

  //sign up fields
  final String name;
  final String organisation;
  final String language;
  final String country;

  //optional user fields
  final String gender,dateOfBirth,education;

  //auth fields
  final String? displayName,email,phoneNumber,photoURL,refreshToken;
  final bool? emailVerified;

  AppUser({required this.uid, required this.name, required this.organisation, required this.language, required this.country, required this.gender, required this.dateOfBirth, required this.education, this.displayName, this.email, this.emailVerified, this.phoneNumber, this.photoURL, this.refreshToken});

  factory AppUser.fromEmailSignUp({required User user, required name,required language,required organisation,required country,required gender, required dateOfBirth, required education }){

   
    return AppUser(
      uid: user.uid,
      name: name,
      organisation: organisation,
      language: language,
      country: country,
      gender: gender,
      dateOfBirth: dateOfBirth,
      education: education,
      displayName: user.displayName,
      email: user.email,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      refreshToken: user.refreshToken
      ); 
  }

  operator [] (String key) {
    switch(key) {
      case 'name' : return name;
      case 'organisation' : return organisation;
      case 'language' : return language;
      case 'country' : return country;
      case 'displayName' : return displayName;
      case 'email' : return email;
      case 'emailVerified' : return emailVerified;
      case 'phoneNumber' : return phoneNumber;
      case 'photoURL' : return photoURL;
      case 'refreshToken' : return refreshToken;
      case 'gender' : return gender;
      case 'dateOfBirth' : return dateOfBirth;
      case 'education' : return education;
      default: return name; 
    }
  }

  getField(String field){
    return this[field];
  }

}

// User(displayName: null, email: a@rtl.ug, emailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2021-09-15 15:47:31.473, lastSignInTime: 2021-09-18 14:50:10.993), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: a@rtl.ug, phoneNumber: null, photoURL: null, providerId: password, uid: a@rtl.ug)], refreshToken: , tenantId: null, uid: UZWYYpONMqS4rHmtXQtDOJfWm3S2)

class UserData{
  final String uid;
  final String name;
  final String organisation;
  final String language;
  final String country;

  UserData({required this.uid, required this.name, required this.organisation, required this.language, required this.country,});
}