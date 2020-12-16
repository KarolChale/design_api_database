import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'package:design_api_database/src/widgets/transitions/page_route.dart';
import 'package:design_api_database/src/pages/home_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xffF16E45),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 90.0),
            height: 735.0,
            width: 412.0,
            decoration: new BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/bgLogin2.png"), fit: BoxFit.cover),
              color: Color(0xff2D2529),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(40.0),
                topRight: const Radius.circular(40.0),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(bottom: 100.0),
              color: Colors.transparent,
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 45),
                    //_loading ? w_CargaCircular(true) : Text("Loading is " + _loading.toString()),
                    _loading ? w_CargaCircular(true) : w_CargaCircularDisable(),
                    //w_CargaCircular(true),
                    SizedBox(height: 50),
                    w_TextForm("Username", false),
                    SizedBox(height: 32),
                    w_TextForm("Password", true),
                    SizedBox(height: 32),
                    //w_BotonCarga(),
                    w_ButtonCargaCircular(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Widget w_CargaCircular(bool activateC) {
    return Container(
      child: CircularPercentIndicator(
        radius: 250.0,
        lineWidth: 3.0,
        startAngle: 20.0,
        circularStrokeCap: CircularStrokeCap.round,
        animateFromLastPercent: true,
        percent: 1.0,
        animation: activateC,
        animationDuration: 1200,
        restartAnimation: true,
        center: new CircleAvatar(
          backgroundColor: Color(0xffF4E7E3),
          backgroundImage: AssetImage("assets/avatarLogin3.png"),
          radius: 110.0,
        ),
        backgroundColor: Color(0xffC7D5DA),
        progressColor: Color(0xffFF7477),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_CargaCircularDisable() {
    return Container(
      child: CircularPercentIndicator(
        radius: 250.0,
        lineWidth: 3.0,
        startAngle: 20.0,
        circularStrokeCap: CircularStrokeCap.round,
        animateFromLastPercent: true,
        percent: 0.0,
        animation: true,
        animationDuration: 1300,
        center: new CircleAvatar(
          backgroundColor: Color(0xffF4E7E3),
          backgroundImage: AssetImage("assets/avatarLogin3.png"),
          radius: 110.0,
        ),
        backgroundColor: Color(0xffC7D5DA),
        progressColor: Color(0xffFF7477),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_TextForm(String hiddentexto, bool hiddentext) {
    return Container(
      height: 60.0,
      width: 300.0,
      decoration: BoxDecoration(color: Color(0xffEAEAEA), borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 2.0),
        child: TextFormField(
          style: TextStyle(fontSize: 18, fontFamily: "Calibri"),
          obscureText: hiddentext,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hiddentexto,
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_BotonCarga() {
    return Container(
      width: 200,
      decoration: BoxDecoration(color: Color(0xffFFCCB5), borderRadius: BorderRadius.circular(8.0)),
      child: FlatButton(
        onPressed: () {
          setState(() {
            _loading = true;
          });
          Timer(Duration(seconds: 3), () {
            Navigator.push(
                context,
                ConcentricPageRoute(
                    builder: (ctx) {
                      return Home();
                    },
                    maintainState: false));
          });
        },
        height: 60.0,
        color: Colors.transparent,
        child: const Text('Login',
            style: TextStyle(
              fontSize: 20,
            )),
      ),
    );
  }

  Widget w_ButtonCargaCircular() {
    return FloatingActionButton(
      elevation: 0.0,
      child: Icon(
        Icons.play_arrow_rounded,
        size: 40.0,
      ),
      foregroundColor: Colors.white,
      backgroundColor: Color(0xffF16E45),
      onPressed: () {
        setState(() {
          _loading = true;
        });
        Timer(Duration(seconds: 3), () {
          Navigator.push(
              context,
              ConcentricPageRoute(
                  builder: (ctx) {
                    return Home();
                  },
                  maintainState: false));
        });
      },
    );
  }
}
