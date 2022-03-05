import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:youth_action_handbook/widgets/common.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('userData');


//auth change user stream: tell if someone is logged in or out
  Stream<User?> get user{
    // return _auth.authStateChanges().map((user) => _appUserFromUser(user));
    // return _auth.authStateChanges();
    return _auth.idTokenChanges();
  }

  //sign in with google
  Future signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser =
        await GoogleSignIn().signIn() as GoogleSignInAccount;

    try {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential results = await _auth.signInWithCredential(credential);
      User user = results.user as User;
      
      if (results.additionalUserInfo!.isNewUser) {
        //create new doc for new user
        await DatabaseService(uid: user.uid)
            .createUserData(user.displayName ??  'Anon.', '', 'en', 'UG','','','',googleUser.photoUrl?? '');
      }

      // return _appUserFromUser(user);
      return user;
    } on FirebaseException catch (e) {
      yahSnackBar(context, e.message);
    } catch (e) {
      yahSnackBar(context, e);
    }
  }

  //sign in with apple
  Future signInWithApple(context) async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we include a nonce in the credential request. When signing in with Firebase, the nonce in the id token returned by Apple, is expected to match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does not match the nonce in `appleCredential.identityToken`, sign in will fail.
      // Once signed in, return the UserCredential
      UserCredential results =
          await _auth.signInWithCredential(oauthCredential);
      User user = results.user as User;
      if (results.additionalUserInfo!.isNewUser) {
        //create new doc for new user
        await DatabaseService(uid: user.uid)
            .createUserData(user.displayName ?? 'Anon', '', 'en', 'UG','','','','');
      }

      // return _appUserFromUser(user);
      return user;
    } on SignInWithAppleAuthorizationException catch (e) {
      print(e.toString());
      yahSnackBar(context, e.message);
      return null;
    } catch (e) {
      print(e.toString());
      yahSnackBar(context, e.toString());
      return null;
    }
  }

  // Determine if Apple SignIn is available
  Future<bool> get appleSignInAvailable => SignInWithApple.isAvailable();

  //sign in with email and password
  Future signInWithEmailandPassword(
      String email, String password, context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user as User;

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.message == 'Given String is empty or null') {
        yahSnackBar(context, "email and password can't be empty.");
      } else if (e.code == 'user-not-found') {
        yahSnackBar(context,
            'User not found, please enter the right email or press sign up to make a new account');
      } else if (e.code == 'wrong-password') {
        yahSnackBar(context, 'Wrong password or email. Please try again.');
      } else {
        yahSnackBar(context, e.message);
      }
      print(e);
    } catch (e) {
      yahSnackBar(context, e);
    }
  }

  //register with email and password
  Future registerWithEmailandPassword(
      String email,
      String password,
      String name,
      String organisation,
      String language,
      String country,
      String profilePicture,
      BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user as User;

      //create new doc for new user
      await DatabaseService(uid: user.uid)
          .createUserData(name, organisation, language, country,'','','','');

      return AppUser.fromEmailSignUp(
          user: user,
          name: name,
          language: language,
          organisation: organisation,
          country: country,
          gender: 'O',
          dateOfBirth: '',
          profilePicture: '',
          education: '');
    } on FirebaseAuthException catch (e) {
      yahSnackBar(context, e.message);
    } catch (e) {
      yahSnackBar(context, e);
    }
  }

  //signout
  Future signOut(context) async {
    try {
      await _auth.signOut();
      print('signed out of auth');
    } catch (e) {
      yahSnackBar(context, e);
    }
  }

  //change password
   Future changePassword(String currentPassword, String newPassword) async{
    String message = '';
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

   await user.reauthenticateWithCredential(cred).then((value) async{
      print('reauthentication worked');
      await user.updatePassword(newPassword).then((_) {
        message = 'Successfully updated password';
      }).catchError((error) {
        print(error);
        if(error is FirebaseException){
          message = error.message ?? 'Sorry, an error occured. Please Try Again';
        }else{
          message = 'Sorry, an error occured. Please Try Again';
        }
      });
    }).catchError((error) {
      print('reauthentication error caught');
      message = 'reauthentication error caught';
        if(error is FirebaseException){
          message = 'reauth error: ' +( error.message ?? 'Sorry, an error occured. Please Try Again');
        }else{
          message = 'Sorry, an error occured. Please Try Again';
        }
        print(error);
    });
    
    return message;
    }

  //try2
  Future changeEmail(String currentPassword, String newEmail) async {
    String message = '';
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updateEmail(newEmail).then((_) {
        message = 'Successfully updated Email';
        print('email updated. New email :'+user.email!);
      }).catchError((error) {
        print(error);
        if(error is FirebaseException){
          message = error.message ?? 'Sorry, an error occured. Please Try Again';
        }else{
          message = 'Sorry, an error occured. Please Try Again';
        }
      });
    }).catchError((error) {
      print(error);
         if(error is FirebaseException){
          message = error.message ?? 'Sorry, an error occured. Please Try Again';
        }else{
          message = 'Sorry, an error occured. Please Try Again';
        }
    });
    
    return message;
    }


  
  //Verify Email Feb 2022 Akbr
  Future verifyEmail(String currentPassword) async {
    String message = '';
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    await user.reauthenticateWithCredential(cred).then((value) async {
      // await user.updateEmail(newEmail).then((_) {
      await user.sendEmailVerification().then((_) {
        message = 'Please check your email for an email with a verification link';
        print('email verified :'+user.email!);
      }).catchError((error) {
        print(error);
        if(error is FirebaseException){
          message = error.message ?? 'Sorry, an error occured. Please Try Again';
        }else{
          message = 'Sorry, an error occured. Please Try Again';
        }
      });
    }).catchError((error) {
      print(error);
         if(error is FirebaseException){
          message = error.message ?? 'Sorry, an error occured. Please Try Again';
        }else{
          message = 'Sorry, an error occured. Please Try Again';
        }
    });
    
    return message;
    }

  // reset password CURRENTLY NOT USED!!! ERROR HANDLING DONE ON PAGE
  Future resetPasswordWithEmail(String email, context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      yahSnackBar(context, 'Please check your email for a password reset link');
    } on FirebaseException catch (e) {
      yahSnackBar(context, e.message);
    } catch (e) {
      yahSnackBar(context, e);
    }
  }

  // Reset Password


//sign in with phone functions

  Future<void> verifyPhoneNumber(
    String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent = (String verificationID, int? forceResnedingtoken) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
    String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      showSnackBar(context, "logged In");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// sign in whth apple extra functions
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
