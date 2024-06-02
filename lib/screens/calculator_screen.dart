import 'package:fit_fyp/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MetricSystem extends StatefulWidget {
  // final ValueChanged<int> onChanged;

  // MetricSystem(this.onChanged);
  @override
  _MetricSystemState createState() => _MetricSystemState();
}

class _MetricSystemState extends State<MetricSystem> {
  List<DropdownMenuItem<String>> dropdownGenderList = [];
  List<DropdownMenuItem<String>> dropdownEquationList = [];
  List<DropdownMenuItem<String>> dropdownActivityList = [];
  List<String> dropdownGender = ["Female", "Male"];
  List<String> dropdownEquation = ["Mifflin-St Jeor", "Harris-Benedict"];
  List<String> dropdownActivity = [
    "I am sedentary",
    "I am lightly active",
    "I am moderately active",
    "I am very active",
    "I am super active"
  ];
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? selected,
      selected1,
      selected2,
      genderController,
      equationController,
      activityController;
  int age = 0, height = 0, weight = 0, bmrTotal = 0, calories = 0;
  double bmrDouble = 0.0;
  double? caloriesDouble;

  @override
  Widget build(BuildContext context) {
    loadGender();
    loadEquation();
    loadActivity();
    return new Scaffold(
        backgroundColor: Colors.white,
        // resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image.asset(
                //   'assets/images/bmr.png',
                //   scale: 1,
                // ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 25.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CALORIES',
                        style: GoogleFonts.bebasNeue(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 3),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'CALCULATOR',
                        style: GoogleFonts.bebasNeue(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff8E2DE2),
                            letterSpacing: 3),
                      ),
                    ],
                  ),
                ),

                // GestureDetector(
                //     onTap: _onClick,
                //     child: Text('Unfamiliar with the Metric system?',
                //         style: TextStyle(fontSize: 16))),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    // padding: EdgeInsets.all(8.0),
                    // decoration: BoxDecoration(
                    //   color: Colors.grey.withOpacity(0.2),
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    child: new DropdownButtonFormField(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      value: selected,
                      items: dropdownGenderList,
                      hint: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: new Text("Gender"),
                      ),
                      // icon: Icon(Icons.arrow_drop_down_circle),
                      // iconSize: 15,
                      iconEnabledColor: Colors.black,
                      // elevation: 100,
                      // style: TextStyle(color: Colors.orange),

                      onChanged: (String? genderValue) {
                        selected = genderValue;
                        setState(() {
                          genderController = genderValue;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: new DropdownButtonFormField(
                      value: selected1,
                      items: dropdownEquationList,
                      hint: new Text("Equation method"),
                      // icon: Icon(Icons.arrow_drop_down_circle),
                      // iconSize: 15,
                      iconEnabledColor: Colors.black,
                      elevation: 20,
                      style: TextStyle(color: Colors.orange),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String? equationChoice) {
                        selected1 = equationChoice;
                        setState(() {
                          equationController = equationChoice;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextField(
                    style: new TextStyle(
                        fontSize: 15.0, height: 1.5, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Age',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(),
                      // focusedBorder: InputBorder.none,
                      // enabledBorder: InputBorder.none,
                      // errorBorder: InputBorder.none,
                      // disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _ageController,
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _heightController,
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _weightController,
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: new DropdownButtonFormField(
                      value: selected2,
                      items: dropdownActivityList,
                      hint: new Text("Level of Activeness"),
                      // icon: Icon(Icons.),
                      // iconSize: 15,
                      iconEnabledColor: Colors.black,
                      // elevation: 20,
                      style: TextStyle(color: Colors.orange),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String? activityChoice) {
                        selected2 = activityChoice;
                        setState(() {
                          activityController = activityChoice;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onPress,
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff434343),
                          Color(0xff000000),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(minWidth: 508.w, minHeight: 36.0.h),
                      padding: EdgeInsets.all(12.h),
                      // alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'CALCULATE BMR',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                // letterSpacing: 1,
                                fontSize: 16.sp,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 15,
                    shadowColor: AppColors.LIGHT_BLACK,
                    padding: const EdgeInsets.all(0.0),
                    primary: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),

                // MaterialButton(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20)),
                //   minWidth: 300,
                //   height: 50,
                //   child: Text('Calculate BMR'),
                //   color: Colors.cyan,
                //   textColor: Colors.black,
                //   elevation: 5,
                //   onPressed: _onPress,
                // ),
                SizedBox(height: 8),

                Text("Your results are as follows:"),
                SizedBox(height: 8),
                Text(
                  "Your BMR is $bmrTotal",
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Recommended Calorie intake is $calories"),
                SizedBox(
                  height: 8,
                ),
              ],
            )));
  }

  void loadGender() {
    dropdownGenderList = [];
    dropdownGenderList = dropdownGender
        .map((values) => new DropdownMenuItem<String>(
              child: new Text(values),
              value: values,
            ))
        .toList();
  }

  void loadEquation() {
    dropdownEquationList = [];
    dropdownEquationList = dropdownEquation
        .map((values) => new DropdownMenuItem<String>(
              child: new Text(values),
              value: values,
            ))
        .toList();
  }

  void loadActivity() {
    dropdownActivityList = [];
    dropdownActivityList = dropdownActivity
        .map((values) => new DropdownMenuItem<String>(
              child: new Text(values),
              value: values,
            ))
        .toList();
  }

  void _onPress() {
    setState(() {
      age = int.parse(_ageController.text);
      height = int.parse(_heightController.text);
      weight = int.parse(_weightController.text);

      if (genderController == "Male") {
        if (equationController == "Mifflin-St Jeor") {
          bmrDouble = (10 * weight) + (6.25 * height) - (5 * age) + 5;
        } else if (equationController == "Harris-Benedict") {
          bmrDouble =
              66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
        }
      } else if (genderController == "Female") {
        if (equationController == "Mifflin-St Jeor") {
          bmrDouble = (10 * weight) + (6.25 * height) - (5 * age) - 161;
        } else if (equationController == "Harris-Benedict") {
          bmrDouble =
              655.1 + (9.563 * weight) + (1.85 * height) - (4.676 * age);
        }
      }
      bmrTotal = (bmrDouble.round());
      if (activityController == "I am sedentary") {
        caloriesDouble = (bmrTotal * 1.2);
      } else if (activityController == "I am lightly active") {
        caloriesDouble = (bmrTotal * 1.375);
      } else if (activityController == "I am moderately active") {
        caloriesDouble = (bmrTotal * 1.55);
      } else if (activityController == "I am very active") {
        caloriesDouble = (bmrTotal * 1.725);
      } else if (activityController == "I am super active") {
        caloriesDouble = (bmrTotal * 1.9);
      }
      calories = (caloriesDouble!.round());
    });
  }

  // void _onClick() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => ImperialSystem()),
  //   );
  // }
}
