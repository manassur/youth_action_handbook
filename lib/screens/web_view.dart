import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:webview_flutter/webview_flutter.dart';


// ignore: must_be_immutable
class WebViewScreen extends StatefulWidget {
  String link = "https://studio.rtl.ug/yah-privacy-policy"; //start here
  String title = "Youth Action Handbook";


  WebViewScreen({this.link= "https://studio.rtl.ug/yah-privacy-policy", this.title="Youth Action Handbook"});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final _controller = Completer<WebViewController>();
  bool isLoading=true;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorBluePrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: AppColors.colorBluePrimary,
        ), 
        elevation: 0,
        title:  RichText(
          text: TextSpan(
              text: widget.title,
              style: TextStyle(
                  color: AppColors.colorYellow, fontSize: 20,fontWeight: FontWeight.w900),
              children: const <TextSpan>[

              ]
          ),
        ),
        actions:  [
          MenuForAppBar(),
        ],
      ),

      body: 
            Stack(
              children: [
                WebView(
                  initialUrl: widget.link,
                  // onWebViewCreated: (controller) => _controller.complete(controller),
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {setState(() => isLoading = false);},),
                if(isLoading) Center( child: CircularProgressIndicator(),),
              ],
            ),

  // bottomNavigationBar: Container(
  //   // color: Theme.of(context).accentColor,
  //   child: Padding(
  //     padding: const EdgeInsets.only(right:20),
  //     child: ButtonBar(children: [
  //       navigationButton(Icons.chevron_left, (controller) => _goback(controller!)),
  //       navigationButton(Icons.chevron_right, (controller) => _goForward(controller!)),
  //       ]
  //     ),
  //   ),
  // ),
    );
  }

  Widget navigationButton(IconData icon, Function(WebViewController?) onPressed){
    return FutureBuilder(
      future: _controller.future,
      // initialData: AsyncSnapshot,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        if (snapshot.hasData) {
          return IconButton(icon: Icon(icon),color: Colors.white, onPressed: () => onPressed(snapshot.data));
        }else{
          return Container(height: 50,);
        }
      },
    );
  }

  void _goback (WebViewController controller) async{
    final _cangoback = await controller.canGoBack();
    if(_cangoback){
      controller.goBack();
    }
  }
 
  void _goForward(WebViewController controller) async{
    final _cangoforward = await controller.canGoForward();
    if(_cangoforward){
      controller.goForward();
    }

  }
}

