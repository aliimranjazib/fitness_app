import '/animations/transitions.dart';
import '/resources/app_colors.dart';
import '/screens/advanced/adv_day_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvDayListtile extends StatelessWidget {
  // const DayListtile({ Key? key }) : super(key: key);
  final String? day;
  final String? excercises;
  final String? time;
  final String? restTime;
  final String? id;

  AdvDayListtile({
    @required this.day,
    @required this.excercises,
    @required this.time,
    @required this.restTime,
    @required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.LIGHT_BLACK,
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              SlideLeftTransition(
                AdvDayWorkoutScreen(
                  selectedDay: day!,
                  excercises: excercises!,
                  time: time!,
                  resttime: restTime!,
                  id: id!,
                ),
              ),
            );
          },
          title: Text(
            day!,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "$excercises exercises",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          // tileColor: AppColors.BLACK,
        ),
      ),
    );
  }
}
