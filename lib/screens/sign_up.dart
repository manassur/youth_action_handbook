import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/main.dart';
import 'package:youth_action_handbook/services/auth_service.dart';
import 'package:youth_action_handbook/widgets/common.dart';
//network imports
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();

  String email = '',
      name = '',
      organisation = '',
      language = 'en',
      country = '',
      password = '';
  int viewIndex = 0;
  void setValue(int index, String value) async {
    setState(() {
      viewIndex = index + 1;
    });
    switch (index) {
      case 0:
        name = value;
        break;
      case 1:
        email = value;
        break;
      case 2:
        country = value;
        break;
      case 3:
        password = value;
        dynamic result = await _auth.registerWithEmailandPassword(
            email, password, name, organisation, language, country,'' ,context);
        if (result == null) {
          setState(() => viewIndex = 0);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.dashboard, (route) => false);
        }
        break;
      default:
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData size;
    size = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: AppColors.colorBluePrimary,
        body: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 70),
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
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
                                  'Getting Started',
                                  style: TextStyle(
                                      color: AppColors.colorYellow,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900),
                                )),
                          ],
                        ),
                        const SizedBox(
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
                    const SizedBox(
                      height: 20,
                    ),
                    if (viewIndex == 0) NameWidget(setValue: setValue),
                    if (viewIndex == 1) EmailWidget(setValue: setValue),
                    if (viewIndex == 2)
                      CountryWidget(setValue: setValue, size: size),
                    if (viewIndex == 3) PasswordWidget(setValue: setValue),
                    if (viewIndex == 4)
                      Container(
                          child: const Loading(),
                          padding: const EdgeInsets.fromLTRB(20, 100, 20, 100)),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/union_logo.png'),
                            const SizedBox(
                              width: 5,
                            ),
                            const SizedBox(
                                width: 100,
                                child: Text(
                                  'Co Founded by the European Union',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                  ],
                ),
              ));
            })));
  }
}

class NameWidget extends StatefulWidget {
  final Function setValue;

  NameWidget({
    Key? key,
    required this.setValue,
  }) : super(key: key);

  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Row(
              children: const [
                SizedBox(
                    width: 200,
                    child: Text(
                      'What is your Name?',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )),
              ],
            ),
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
                        //Name
                        controller: nameController,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Name",
                          prefixIcon: Icon(
                            Icons.person_outline,
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
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 200.0,
          height: 50,
          child: ElevatedButton(
            child: const Text(AppTexts.next),
            onPressed: () {
              if (nameController.text == null || nameController.text == '') {
                yahSnackBar(context, 'Please enter your name');
              } else {
                setState(() {
                  widget.setValue(0, nameController.text);
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

class EmailWidget extends StatefulWidget {
  final Function setValue;

  EmailWidget({
    Key? key,
    required this.setValue,
  }) : super(key: key);

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Row(
              children: const [
                SizedBox(
                    width: 200,
                    child: Text(
                      'What is your Email?',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )),
              ],
            ),
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
                        //EMAIL
                        controller: emailController,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(
                            Icons.mail_outline,
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
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 200.0,
          height: 50,
          child: ElevatedButton(
            child: Text(AppTexts.next),
            onPressed: () {
              if (emailController.text.isValidEmail()) {
                setState(() {
                  widget.setValue(1, emailController.text);
                });
              } else {
                yahSnackBar(context, 'Please enter a valid email address');
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
  const CountryWidget({
    Key? key,
    required this.size,
    required this.setValue,
  }) : super(key: key);

  final MediaQueryData size;

  @override
  State<CountryWidget> createState() => _CountryWidgetState();
}

class _CountryWidgetState extends State<CountryWidget> {
  String country = '';

  void _setInitialCountry() async {
    if (country == '') {
      try {
        country = await getCountry();
      } catch (e) {
        country = 'UG';
      }
    }
    setState(() {
      country = country;
    });
  }

  void _onCountryChange(CountryCode countryCode) {
    country = countryCode.code.toString();
  }

  @override
  Widget build(BuildContext context) {
    _setInitialCountry();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Row(
              children: const [
                SizedBox(
                    width: 200,
                    child: Text(
                      'Where are you from?',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )),
              ],
            ),
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
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 200.0,
          height: 50,
          child: ElevatedButton(
            child: Text(AppTexts.next),
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

class PasswordWidget extends StatefulWidget {
  final Function setValue;

  PasswordWidget({
    Key? key,
    required this.setValue,
  }) : super(key: key);

  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Row(
              children: const [
                SizedBox(
                    width: 200,
                    child: Text(
                      'Choose a password',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )),
              ],
            ),
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
                        controller: passwordController,
                        obscureText: true,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: AppColors.colorGreenPrimary,
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: const TextStyle(
                              color: Colors.white, fontSize: 15),
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
            child: Text(AppTexts.next),
            onPressed: () {
              if (passwordController.text == '' ||
                  passwordController.text.length < 6) {
                yahSnackBar(
                    context, 'please pick a password longer than 6 characters');
              } else {
                setState(() {
                  widget.setValue(3, passwordController.text);
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

// Get Initial Country
Future<String> getCountry() async {
  Network n = Network("http://ip-api.com/json");
  var locationSTR = (await n.getData());
  var locationx = jsonDecode(locationSTR);
  return locationx["countryCode"];
}

//Class to use to get initial country without triggering location request
class Network {
  final String url;

  Network(this.url);

  Future<String> apiRequest(Map jsonMap) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/x-www-form-urlencoded');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  Future<String> sendData(Map data) async {
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      return 'No Data';
    }
  }

  Future<String> getData() async {
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      return 'No Data';
    }
  }
}
