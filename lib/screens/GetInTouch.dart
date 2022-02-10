import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/widgets/common.dart';

class GetInTouch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorBluePrimary,
        elevation: 0,
        title:  RichText(
          text: TextSpan(
              text: 'Impressum',
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Column(
            children: [
            Image.asset(
                'assets/certify.png',
                // height: 32,
                // width: MediaQuery.of(context).size.width/4,
              ),
           Container(
                padding: const EdgeInsets.all(16.0),
                // width: MediaQuery.of(context).size.width/1.5,
                child: Flexible(
                  
                  child: Text(
                    'This App\'s contents are the sole responsibility of the Project Great Lakes Youth Network for Dialogue and Peace and do not necessarily reflect the views of the Partners.',
                  ),
                ),
              ),
          ],),
          StepWidget2(
            indicator: Icons.location_city_rounded,
            title: 'Address',
            nobullets: true,
            nolines: true,
            text: '289,Alindi av./Himbi; Goma\nRépublique Démocratique du Congo',
          ),
          StepWidget2(
            indicator: Icons.phone_android_rounded,
            title: 'Tel',
            nobullets: true,
            nolines: true,
            text: '+243 813 304394',
          ),
          StepWidget2(
            indicator: Icons.email_rounded,
            title: 'Email',
            nobullets: true,
            nolines: true,
            text: 'info@greatlakesyouth.africa',
          ),
          // Padding(
          //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          //       child: Text('App Developed by:'),
          //     ),
          // Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: Divider(
          //       height: 2,
          //     )),
          // Column(mainAxisSize: MainAxisSize.min,
          //         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           TextButton(onPressed:  () {
          //                       launchURL(context, 'https://rtl.ug/');
          //                     }, child: Row(
          //                       mainAxisSize: MainAxisSize.min,
          //                       children: [
          //                         Image.asset(
          //                           'assets/union_logo.png',
          //                           height: 32,
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.only(left: 8.0),
          //                           child: Text('Rootless Technologies Limited'),
          //                         ),
          //                       ],
          //                     )),
          //           TextButton(onPressed:  () {
          //                       launchURL(context, 'https://loftuganda.tech/');
          //                     }, child: Row(
          //                       mainAxisSize: MainAxisSize.min,
          //                       children: [
          //                         Image.asset(
          //                           'assets/union_logo.png',
          //                           height: 32,
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.only(left: 8.0),
          //                           child: Text('Loft Uganda'),
          //                         ),
          //                       ],
          //                     )),
          //         ]),
        
        ],
      ),
    );
  }
}

class StepWidget2 extends StatefulWidget {
  final String? title;
  final DateTime? date;
  final DateTime? enddate;
  final String? image;
  final bool? nolines;
  final bool? nobullets;
  final String? text;
  final IconData? indicator;
  final String? indicator2;
  const StepWidget2({
    this.text,
    this.date,
    this.enddate,
    this.image,
    this.nobullets,
    this.nolines,
    this.indicator,
    this.indicator2,
    this.title,
    Key? key,
  }) : super(key: key);
  @override
  _StepWidget2State createState() => _StepWidget2State();
}

class _StepWidget2State extends State<StepWidget2> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(left: 72.0, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Head(
                      text: widget.title?? "",
                    ),
                    if (widget.image != null) Image.asset(widget.image!),
                    // if (widget.image != null) Icon(Icons.link, color: AppColors.colorPurple),
                    Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.text!,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          )
                  ],
                  
                  
            )),
        if (!(widget.nolines ?? false))
          new Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 32.0,
            child: new Container(
              height: double.infinity,
              width: 1.0,
              color: Theme.of(context).accentColor,
            ),
          ),
        new Positioned(
          top: 5.0,
          left: 0.0,
          child: new Container(
            height: 64.0,
            width: 64.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff1a3333).withAlpha(128),
                      offset: Offset(3, 3),
                      blurRadius: 4,
                      spreadRadius: -2)
                ]),
            child: new Container(
              margin: new EdgeInsets.all(5.0),
              height: 2.0,
              width: 2.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                // color: Theme.of(context).accentColor
              ),
              child: Center(
                  child: (widget.indicator2 != null)
                      ? Image.asset(widget.indicator2!): Icon(
                          widget.indicator ?? Icons.event,
                          color: AppColors.colorPurple,
                          size: 36,
                        )),
            ),
          ),
        )
      ],
    );
  }
}

class BulletText {
}


class Head extends StatelessWidget {
  final String text;
  const Head({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline6
          ),
          Divider(
            height: 1,
            color: Theme.of(context).accentColor.withAlpha(128),
            endIndent: MediaQuery.of(context).size.width / 2,
          ),
        ],
      ),
    );
  }
}
