import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  bool loading = false;
  //user deets
  String error = '';
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: 170,
                                  child: Text(
                                    AppLocalizations.of(context)!.resetPassword,
                                    style: TextStyle(
                                        color: AppColors.colorYellow,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                color: AppColors.colorYellow,
                                height: 3,
                                width: 200,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 200,
                              child: Text(
                                AppLocalizations.of(context)!.enterYourEmailAddress,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )),
                        ],
                      ),
                      SizedBox(
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
                                  //EMAIL
                                  controller: emailController,
                                  validator: (val1) => val1!.isEmpty
                                      ? AppLocalizations.of(context)!.enterYourEmailAddress
                                      : null,
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
                      const SizedBox(height: 20),
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
                                        dynamic result =
                                            await _auth.resetPasswordWithEmail(
                                                emailController.text, context);
                                        if (result == null) {
                                          setState(() {
                                            error =
                                                AppLocalizations.of(context)!.pleaseTryAgainWithaValidEmailAddress;
                                            loading = false;
                                          });
                                        } else {
                                          setState(() {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteNames.loginScreen);
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.sendPasswordResetEmail,
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
                                TextButton(
                                    onPressed: () => Navigator.pop(
                                        context, RouteNames.loginScreen),
                                    child: Text(AppLocalizations.of(context)!.login))
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
                              width: 150,
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
              ));
            })));
  }
}
