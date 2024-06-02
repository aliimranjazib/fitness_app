import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:fit_fyp/constants.dart';
import 'package:fit_fyp/login.dart';
import 'package:fit_fyp/resources/app_colors.dart';
import 'package:fit_fyp/resources/share_pref.dart';
import 'package:fit_fyp/screens/first_page.dart';
import 'package:fit_fyp/screens/intro_page.dart';
import 'package:fit_fyp/signup.dart';
import 'package:fit_fyp/widgets/constantwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: Size(392.72727272727275, 807.2727272727273),
      builder: (context, child) => MaterialApp(
        theme: ThemeData(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Fitness',
        home: SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  bool _isSignIn = false;
  bool _isIntro = false;
  bool _isFirstTime = false;

  @override
  void initState() {
    super.initState();
    signInValue();

    Timer(Duration(seconds: 3), () {
      print("isIntro=----$_isIntro---$_isSignIn");
      if (_isIntro) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => IntroPage()));
      } else if (!_isSignIn) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(),
            ));
      } else {
        if (_isFirstTime) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(0),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FirstPage(),
              ));
        }
      }
    });
  }

  void signInValue() async {
    _isSignIn = await PrefData.getIsSignIn();
    _isIntro = await PrefData.getIsIntro();
    _isFirstTime = await PrefData.getIsFirstTime();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: new ExactAssetImage(
            ConstantData.assetImagesPath + "splash_bg.png",
          ),
          fit: BoxFit.fill,
        ),
      ),

      child: Stack(
        children: [
          Center(
            child: ConstantWidget.getCustomTextFont(
                "Fitness Workout",
                Colors.white,
                1,
                TextAlign.start,
                FontWeight.bold,
                ConstantWidget.getScreenPercentSize(context, 5),
                meriendaOneFont),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(ConstantData.assetImagesPath + "splash_icon.png",
                height: ConstantWidget.getScreenPercentSize(context, 25)),
          )
        ],
      ),
      // child: Image.asset(ConstantData.assetHomeImagesPath+"logo.png",
      //     height: MediaQuery.of(context).size.height,
      //     width: MediaQuery.of(context).size.width)
    );
  }
}
