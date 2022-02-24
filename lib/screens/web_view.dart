import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/widgets/common.dart';
import 'package:webview_flutter/webview_flutter.dart';


// ignore: must_be_immutable
class WebViewScreen extends StatefulWidget {
  String link = "https://studio.rtl.ug/yah-privacy-policy"; //start here


  WebViewScreen({this.link= "https://studio.rtl.ug/yah-privacy-policy"});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final _controller = Completer<WebViewController>();
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
              text: 'Youth Action Handbook',
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

      body: WebView(initialUrl: widget.link, onWebViewCreated: (controller) => _controller.complete(controller)),
            bottomNavigationBar: Container(
              // color: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.only(right:20),
                child: ButtonBar(children: [
                  navigationButton(Icons.chevron_left, (controller) => _goback(controller!)),
                  navigationButton(Icons.chevron_right, (controller) => _goForward(controller!)),
                  ]
                ),
              ),
            ),
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

