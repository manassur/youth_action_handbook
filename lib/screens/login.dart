import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  bool loading = false;
  //user deets
  String email = '';
  String password = '';
  bool error = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light,
          statusBarColor: AppColors.colorBluePrimary,
                ),
                backgroundColor: AppColors.colorBluePrimary,
                toolbarHeight: 0, elevation: 0, ),
        backgroundColor: AppColors.colorBluePrimary,
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          width: 150,
                        ),
                        RichText(
                          text: TextSpan(
                              text: AppLocalizations.of(context)!.our + ' ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w200),
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppLocalizations.of(context)!.diversity + ' ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.our + ' ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w200),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.opportunity,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorBlueSecondary,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                    //EMAIL
                                    controller: emailController,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.email,
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: AppColors.colorGreenPrimary,
                                      ),
                                      border: InputBorder.none,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      hintStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w100),
                                    )))),
                        const SizedBox(height: 10),
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
                                        color: Colors.white, fontSize: 15),
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.password,
                                      prefixIcon: Icon(
                                        Icons.lock_outlined,
                                        color: AppColors.colorGreenPrimary,
                                      ),
                                      border: InputBorder.none,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      hintStyle: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )))),

                        !error
                            ? const Text("")
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    TextButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, RouteNames.signUpScreen),
                                        child:
                                            Text(AppLocalizations.of(context)!.signUpPrompt)),
                                    const Text('|'),
                                    TextButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, RouteNames.resetPassword),
                                        child:
                                            Text(AppLocalizations.of(context)!.forgotPassword))
                                  ]),

                        // const SizedBox(height:20,),

                        loading
                            ? const Loading()
                            : Column(
                                children: [
                                  SizedBox(
                                    width: 200.0,
                                    height: 50,
                                    child: OutlinedButton(
                                      //*********LOGIN BUTTON*********
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() => loading = true);
                                          dynamic result = await _auth
                                              .signInWithEmailandPassword(
                                                  emailController.text.trim(),
                                                  passwordController.text,
                                                  context);
                                          if (result == null) {
                                            setState(() {
                                              error = true;
                                              loading = false;
                                            });
                                          } else {
                                            setState(() {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  RouteNames.dashboard,
                                                  (route) => false);
                                            });
                                          }
                                        }
                                      },
                                      child: Text(AppLocalizations.of(context)!.login,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: AppColors.colorGreenPrimary),
                                        shape: const StadiumBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 200.0,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        if (true) {
                                          setState(() => loading = true);
                                          dynamic result = await _auth
                                              .signInWithGoogle(context);
                                          if (result == null) {
                                            setState(() => error = true);
                                            loading = false;
                                          } else {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouteNames.dashboard,
                                                (route) => false);
                                          }
                                          print(result);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SvgPicture.asset('assets/google.svg'),
                                          Text(AppLocalizations.of(context)!.loginWithGoogle,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: AppColors.colorGreenPrimary),
                                        shape: const StadiumBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 200.0,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        if (true) {
                                          setState(() => loading = true);
                                          dynamic result = await _auth
                                              .signInWithApple(context);
                                          if (result == null) {
                                            setState(() => error = true);
                                            loading = false;
                                          } else {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouteNames.dashboard,
                                                (route) => false);
                                          }
                                          print(result);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SvgPicture.asset('assets/apple.svg'),
                                          Text(AppLocalizations.of(context)!.loginWithApple,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: AppColors.colorGreenPrimary),
                                        shape: const StadiumBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/union_logo.png'),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 120,
                                child: Text(
                                  AppLocalizations.of(context)!.coFoundedByTheEuropeanUnion,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        const SizedBox(height: 10),

                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: const Text(
                              'Great Lakes Youth Dialogue Network for Dialogue and Peace',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 12),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            })));
  }
}
