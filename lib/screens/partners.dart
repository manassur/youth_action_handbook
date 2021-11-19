
import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/widgets/common.dart';


class PartnersScreen extends StatefulWidget {
  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorBluePrimary,
        elevation: 0,
        title:  RichText(
          text: TextSpan(
              text: 'Partners',
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

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            //first section
            Container(
                color: AppColors.colorBlueSecondary,
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: const Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("KONRAD ADENAUR STIFTUNG",
                      style: TextStyle(color: Colors.white),),
                  ),
                )),

              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Image.asset('assets/partners.png', width: 150, height: 150,
                 ),

                    Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy ',
                      style: TextStyle(color: Color(0XFFA7A7A7)),
                      textAlign: TextAlign.justify,

                    ),
                   ],
                ),
              ),



            //Second section
            Container(
                color: AppColors.colorBlueSecondary,
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: const Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("POLE INSTITUTE",
                      style: TextStyle(color: Colors.white),),
                  ),
                )),

            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/partners1.png', width: 150, height: 150,
                  ),

                  Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy ',
                    style: TextStyle(color: Color(0XFFA7A7A7),),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),


            //Third Section
            Container(
                color: AppColors.colorBlueSecondary,
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: const Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("VISION JEUNESSE NOUVELLE",
                      style: TextStyle(color: Colors.white),),
                  ),
                )),

            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/partners2.png', width: 150, height: 150,
                  ),
                  Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy ',
                    style: TextStyle(color: Color(0XFFA7A7A7)),
                    textAlign: TextAlign.justify,

                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
