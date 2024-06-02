import 'dart:convert';

// import 'package:bookbuddies/providers/location_provider.dart';
// import 'package:bookbuddies/routes/routes.dart';
// import 'package:fit_fyp/components/button.dart';
import 'package:fit_fyp/resources/share_pref.dart';
import 'package:fit_fyp/screens/first_page.dart';
import 'package:fit_fyp/screens/home_screen.dart';
import 'package:fit_fyp/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/primary-button.dart';
import 'components/secondary-button.dart';

goto(BuildContext context, Widget w) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => w));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordShown = false;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  // void _loadUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('@bb_user') ?? '';
  //   if (userId.length > 2) {
  //     goto(context, HomeScreen(0));
  //     // Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
  //   }
  // }

  void _onSubmit() async {
    _formKey.currentState?.save();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_formData['email'] == '' || _formData['password'] == '') {
      await showDialog(
          context: context,
          builder: (ctx) {
            return Dialog(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    Text('Incorrect email or password, try again!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
            );
          });
    } else {
      setState(() {
        loading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _formData['email'] as String,
                password: _formData['password'] as String);
        // await prefs.setString('@bb_user', userCredential.user?.uid ?? '');
        setState(() {
          loading = false;
        });
        PrefData.setIsSignIn(true);
        PrefData.setIsIntro(false);
        bool _isFirstTime = await PrefData.getIsFirstTime();

        // if (_isFirstTime) {
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => FirstPage(),
        //       ));
        // } else {
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => HomeScreen(0),
        //       ));
        // }
        goto(context, FirstPage());
        // Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          await showDialog(
              context: context,
              builder: (ctx) {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        Text('Incorrect email or password, please try again',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  ),
                );
              });

          setState(() {
            loading = false;
          });
        } else if (e.code == 'wrong-password') {
          await showDialog(
              context: context,
              builder: (ctx) {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        Text('Incorrect email or password, please try again',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  ),
                );
              });
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // _loadUser();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage("asset/images/rest.jpg"),
        //   fit: BoxFit.cover,
        // )),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset('asset/images/rest.jpg'),
                SizedBox(height: 40),
                Text(
                  "Glad to meet\nyou again!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.length < 3 ||
                                !value.contains('@')) {
                              return 'Entre seu email corretamente';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (email) {
                            _formData['email'] = email ?? '';
                            // locationProvider.getLocation();
                          },
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Your Email",
                              // suffixIcon: Icon(icon,color: Colors.grey,),
                              suffixIcon: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.vpn_key_rounded),
                            suffixIcon: IconButton(
                              icon: isPasswordShown
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = !isPasswordShown;
                                });
                              },
                            ),
                            labelText: 'Password',
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Color(0xFFC41212),
                              ),
                            ),
                            focusColor: Color(0xff909A9E),
                            errorStyle: TextStyle(color: Color(0xFFC41212)),
                            fillColor: Color(0xFF909A9E),
                            alignLabelWithHint: false,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          autocorrect: false,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 3) {
                              return 'invalid password';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (password) =>
                              _formData['password'] = password ?? '',
                          obscureText: !isPasswordShown,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      // ConstantWidget.getButtonWidget(
                      //     context, "SIGN IN NOW", Color(0x084043),
                      //     () {
                      //   // PrefData.setIsSignIn(true);
                      //   // PrefData.setIsIntro(false);

                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => FirstPage(),
                      //       ));
                      // }),
                      PrimaryButton(
                        title: 'ENTER',
                        loading: loading,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            _onSubmit();
                          }
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SecondaryButton(
                          title: 'REGISTER',
                          onPress: () {
                            goto(context, SignUpPage());
                            // Navigator.of(context).pushNamed(AppRoutes.SIGNUP);
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
