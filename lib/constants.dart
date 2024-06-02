import 'package:fit_fyp/models/internseModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:healtho_app/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

// Color defPrimaryColor = "#0053A6".toColor();
Color defPrimaryColor = Colors.orange;
Color mainBgColor = Colors.grey.shade100;
Color primaryColor = "#142B44".toColor();
// Color primaryColor = "#102C45".toColor();
String arialFont = "Arial";
String bebasneueFont = "Bebasneue";
String meriendaOneFont = "MeriendaOne";

class ConstantData {
  static const double avatarRadius = 40;
  static const double padding = 20;
  static String fontsFamily = 'SFProText';
  static String assetImagesPath = 'asset/imgs/';
  static String assetHomeImagesPath = 'asset/homeImages/';
  static int defaultRepsCount = 12;
  static Color subPrimaryColor = "#084043".toColor();
  // static Color primaryColor = "#FCC414".toColor();
  static Color bgColor = "#EBEBEB".toColor();

  static final String defTimeZoneName = "America/Detroit";

  static Color cellColor = "#e1e2e2".toColor();
  static Color defCellColor = "#ffffff".toColor();
  static Color color1 = "#FFE5E5".toColor();
  static Color color2 = "#E5FFF3".toColor();
  static Color color3 = "#FFE5F6".toColor();
  static Color color4 = "#ECE5FF".toColor();
  // static Color cellColor = "#E4E4E4".toColor();
  static Color defColor = "#12153D".toColor();

  static double font15Px = SizeConfig.safeBlockVertical! / 0.6;

  static double font12Px = SizeConfig.safeBlockVertical! / 0.75;

  static double font18Px = SizeConfig.safeBlockVertical! / 0.5;
  static double font20Px = SizeConfig.safeBlockVertical! / 0.58;
  static double font22Px = SizeConfig.safeBlockVertical! / 0.4;
  static double font25Px = SizeConfig.safeBlockVertical! / 0.3;

  static ThemeData themeData = new ThemeData(
    primaryColor: new Color(0xFF102B46),
    primaryColorDark: new Color(0xFF102B46),
    // accentColor: new Color(0xFFF1C40E),
    backgroundColor: Colors.white,

    // textTheme: TextTheme().apply(bodyColor: Colors.black),

    // primaryColorDark: new Color(0xFFF1C40E),
  );

  static String getExerciseTypeStr(int i, BuildContext context) {
    switch (i) {
      case 1:
        return "beginner";
      case 2:
        return "intemediate";
      case 3:
        return "advanced";
    }
    return "";
  }

  static List<IntensivelyModel> getIntensivelyModel() {
    List<IntensivelyModel> list = [];

    IntensivelyModel model = new IntensivelyModel();
    model.title = "NORMAL USER";
    // model.title = "Low";
    model.desc = "Select if you are looking for training";
    list.add(model);

    model = new IntensivelyModel();
    model.title = "TRAINER";
    // model.title = "Moderate";
    model.desc = "Select if you want to give training";
    list.add(model);

    // model = new IntensivelyModel();
    // // model.title = "High";
    // model.title = "Intermediate ";
    // model.desc =
    //     "While it's often referred to as \"runner's high,\"these feelings can also occur with other forms of aerobic.";
    // list.add(model);

    return list;
  }

// static String getLocalNameFromModel(
  //     BuildContext context, ModelExerciseCategory category) {
  //   print("objecy=${category.toString()}");
  //   // Map<String, dynamic> parsedMap = jsonEDecode(category);
  //   String resp = jsonEncode(category);
  //
  //   //   print("modelset===${jsonEncode(category)}");
  //   // var map=Map<String, dynamic>.from(category.toMap());
  //   // var map=category.toMap();
  //   return 'id';
  // }

}

launchURL() async {
  await launch("https://google.com");
}

void exitApp() {
  if (Platform.isIOS) {
    exit(0);
  } else {
    SystemNavigator.pop();
    // Future.delayed(const Duration(milliseconds: 200), () {
    //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // });
  }
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = (screenWidth! / 100);
    blockSizeVertical = (screenHeight! / 100);
    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight! - _safeAreaVertical!) / 100;
  }
}

var kBottomContainerHeight = 80.0.h;
// const kActiveCardColour = Color(0xFF1D1E33);
const kActiveCardColour = LinearGradient(colors: [
  Color(0xffaa076b),
  Color(0xff61045f),
]);

// const kInactiveCardColour = Color(0xFF111328);
const kInactiveCardColour = LinearGradient(colors: [
  Color(0xFF111328),
  Color(0xFF111328),
]);

const kBottomContainerColour = Color(0xFFEB1555);

var kLabelTextStyle = GoogleFonts.lato(
    textStyle: TextStyle(
  fontSize: 18.0.sp,
  color: Colors.white,
  fontWeight: FontWeight.w900,
));

var kNumberTextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
        fontSize: 40.0.sp, fontWeight: FontWeight.w700, color: Colors.white));

var kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0.sp,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

var kTitleTextStyle = TextStyle(
    fontSize: 50.0.sp, fontWeight: FontWeight.bold, color: Colors.white);

var kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0.sp,
  fontWeight: FontWeight.bold,
);

var kBMITextStyle = TextStyle(
    fontSize: 100.0.sp, fontWeight: FontWeight.bold, color: Colors.white);

var kBodyTextStyle = TextStyle(fontSize: 22.0.sp, color: Colors.white);
