import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_action_handbook/services/auth_service.dart';

class DatabaseService {
  final String? uid;
  final _auth = AuthService();
  final _fauth = FirebaseAuth.instance;

  DatabaseService({this.uid});
  final CollectionReference userDataCollection =FirebaseFirestore.instance.collection('userData');

  //Create user Data AT registration
  Future createUserData(String name, String organisation, String language, String country,String? gender, String? education, String? dateOfBirth) async {
    return await userDataCollection
        .doc(uid)
        .set({'name': name, 'organisation': organisation, 'language': language, 'country': country,'gender':gender , 'education':education, 'dateOfBirth':dateOfBirth});
  }

  //update any NON_SENSITIVE user field. email and password are handled by the authService
  Future updateField(String name, value) async{
    String message = '';
    try{
      
    await userDataCollection
        .doc(uid)
        .update({name : value}).then(
          (val) => message = 'Success',
        );
    }on FirebaseException catch(e){
      message = e.message?? 'an error occured';
    }
    return message;
  }

  // Future upd

 Stream<AppUser?> appUserStream(user){
    return userDataCollection.doc(user.uid).snapshots().map((snapshot) => appUserfromSnapshot(user, snapshot));
  }

  //get appUser  from snapshot
  AppUser? appUserfromSnapshot(User? user,DocumentSnapshot snapshot){
    if(user == null){
      return null;
    }
    
    return AppUser(
      uid: user.uid,
      name: snapshot.get('name') ?? 'Anon.',
      organisation: snapshot.get('organisation') ?? '',
      language: snapshot.get('language') ?? 'en',
      country: snapshot.get('country') ?? '',
      gender: snapshot.get('gender') ?? '',
      education: snapshot.get('education') ?? '',
      dateOfBirth: snapshot.get('dateOfBirth') ?? '',
      displayName: user.displayName,
      email: user.email,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      refreshToken: user.refreshToken
      ); 
  }

  
}
