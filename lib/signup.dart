import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart' as cp;
import 'package:fit_fyp/components/primary-button.dart';
import 'package:fit_fyp/components/secondary-button.dart';
import 'package:fit_fyp/constants.dart';
import 'package:fit_fyp/login.dart';
import 'package:fit_fyp/widgets/constantwidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordShown = false;
  bool isConfirmPasswordShown = false;
  bool showForm = true;
  bool loading = false;

  final _formData = Map<String, Object>();
  final _formKey = GlobalKey<FormState>();
  final _codeKey = GlobalKey<FormState>();

  String verificationCode = '';
  String loadedVerificationId = '';

  Future<bool> _requestPop() {
    exitApp();

    return new Future.value(false);
  }

  @override
  void initState() {
    super.initState();

    // setTheme();
  }

  // void _verifyCode(phone) async {
  //   _formKey.currentState?.save();

  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '+92$phone',
  //       timeout: const Duration(seconds: 60),
  //       verificationCompleted: (PhoneAuthCredential authCredential) async {
  //         User? current = FirebaseAuth.instance.currentUser;
  //         current?.updatePhoneNumber(authCredential);
  //         goto(context, LoginPage());

  //         // Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
  //       },
  //       verificationFailed: (FirebaseAuthException e) async {
  //         if (e.code == 'invalid-phone-number') {
  //           print('The provided phone number is not valid.');
  //         }
  //       },
  //       codeSent: (String verificationId, int? resendToken) async {
  //         setState(() {
  //           loadedVerificationId = verificationId;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (_) async {
  //         print('Auto Retrieval Timeout');
  //       });
  // }

  void _onSubmit() async {
    _codeKey.currentState?.save();

    if (verificationCode != '') {
      try {
        final credential = PhoneAuthProvider.credential(
            verificationId: loadedVerificationId, smsCode: verificationCode);
        User? current = FirebaseAuth.instance.currentUser;
        await current?.updatePhoneNumber(credential);
        goto(context, LoginPage());
        // Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
      } on FirebaseAuthException {
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
                      Text('Incorrect code, try again',
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
      }
    } else {
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
                    Text('Incorrect code, try again',
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
    }
  }

  void _signUp() async {
    _formKey.currentState?.save();
    if (_formData['confirmPassword'] == '') {
      setState(() {
        loading = false;
      });
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
                    Text('Fill the data correctly',
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
    }

    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _formData['email'] as String,
        password: _formData['confirmPassword'] as String,
      );
      User? current = FirebaseAuth.instance.currentUser;

      if (userCredential.credential != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(current!.uid)
            .set({
          "name": _formData['name'] as String,
          "email": _formData['email'] as String,
          'userphone': _formData['phone'] as String,
          "uid": current.uid,
        });
      }
      current?.updateDisplayName(_formData['name'] as String);

      goto(context, LoginPage());

      setState(() {
        showForm = false;
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          loading = false;
        });
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
                      Text('password is too weak',
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
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          loading = false;
        });
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
                      Text('An account with this email already exists',
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
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Unidentified Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return showForm
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mainBgColor,
              elevation: 0,
              title: Text(""),
              leading: GestureDetector(
                onTap: () {
                  _requestPop();
                },
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.black,
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(24),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Container(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Sign up and\nstart workout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
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
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 3) {
                              return 'Enter your full name';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) =>
                              _formData['name'] = newValue ?? '',
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Name and surname",
                              // suffixIcon: Icon(icon,color: Colors.grey,),
                              suffixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 20,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                          autocorrect: false,
                          keyboardType: TextInputType.name,
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
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.length < 3 ||
                                !value.contains('@')) {
                              return 'Entre your e-mail';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) =>
                              _formData['email'] = newValue ?? '',
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "e - mail",
                              // suffixIcon: Icon(icon,color: Colors.grey,),
                              suffixIcon: Icon(
                                Icons.mail,
                                color: Colors.grey,
                                size: 20,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 7),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: ConstantData.defCellColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: cp.CountryCodePicker(
                              boxDecoration: BoxDecoration(
                                color: ConstantData.defCellColor,
                              ),
                              closeIcon: Icon(Icons.close,
                                  size: ConstantWidget.getScreenPercentSize(
                                      context, 3),
                                  color: Colors.black),

                              onChanged: (value) {
                                // countryCode = value.dialCode;
                                // print("changeval===$countryCode");
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'PK',
                              searchStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: ConstantData.fontsFamily),
                              searchDecoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: ConstantData.fontsFamily)),
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: ConstantData.fontsFamily),
                              dialogTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: ConstantData.fontsFamily),

                              showFlagDialog: true,
                              hideSearch: true,
                              comparator: (a, b) => b.name!.compareTo(a.name!),

                              onInit: (code) {
                                // countryCode = code.dialCode;
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 3) {
                                    return 'Enter your phone in the format (DDD) XXXXXXXXXX';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (newValue) =>
                                    _formData['phone'] = newValue ?? '',
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "enter phone number",
                                    // suffixIcon: Icon(icon,color: Colors.grey,),
                                    suffixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    )),
                                autocorrect: false,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      /////////////////////
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
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 3) {
                              return 'password invalid';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) =>
                              _formData['password'] = newValue ?? '',
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "enter password",
                              // suffixIcon: Icon(icon,color: Colors.grey,),
                              suffixIcon: Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                size: 20,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(10),
                      //     ),
                      //   ),
                      //   child: TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     validator: (value) {
                      //       if (value!.isEmpty || value.length < 7) {
                      //         return 'password invalid';
                      //       } else {
                      //         return null;
                      //       }
                      //     },
                      //     onSaved: (newValue) =>
                      //         _formData['password'] = newValue ?? '',
                      //     decoration: InputDecoration(
                      //       prefixIcon: Icon(Icons.vpn_key_rounded),
                      //       labelText: 'password',
                      //       suffixIcon: IconButton(
                      //         icon: isPasswordShown
                      //             ? Icon(Icons.visibility_off)
                      //             : Icon(Icons.visibility),
                      //         onPressed: () {
                      //           setState(() {
                      //             isPasswordShown = !isPasswordShown;
                      //           });
                      //         },
                      //       ),
                      //       errorBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide: BorderSide(
                      //           style: BorderStyle.solid,
                      //           color: Color(0xFFC41212),
                      //         ),
                      //       ),
                      //       focusedErrorBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide: BorderSide(
                      //           style: BorderStyle.solid,
                      //           color: Color(0xFFC41212),
                      //         ),
                      //       ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide: BorderSide(
                      //           color: Color(0xFF909A9E),
                      //         ),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide: BorderSide(
                      //           style: BorderStyle.solid,
                      //           color: Color(0xff909A9E),
                      //         ),
                      //       ),
                      //       focusColor: Color(0xff909A9E),
                      //       floatingLabelBehavior: FloatingLabelBehavior.never,
                      //     ),
                      //     autocorrect: false,
                      //     obscureText: !isPasswordShown,
                      //     keyboardType: TextInputType.visiblePassword,
                      //   ),
                      // ),

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
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'password invalid';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key_rounded),
                            labelText: 'Confirm your password',
                            suffixIcon: IconButton(
                              icon: isConfirmPasswordShown
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordShown =
                                      !isConfirmPasswordShown;
                                });
                              },
                            ),
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusColor: Color(0xff909A9E),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          autocorrect: false,
                          onSaved: (newValue) =>
                              _formData['confirmPassword'] = newValue ?? '',
                          obscureText: !isConfirmPasswordShown,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      SizedBox(height: 24),
                      PrimaryButton(
                          title: 'REGISTER',
                          loading: loading,
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              _signUp();
                            }
                          }),
                      SizedBox(
                        height:
                            ConstantWidget.getScreenPercentSize(context, 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidget.getTextWidget(
                              "Already have an account ?",
                              Colors.black,
                              TextAlign.left,
                              FontWeight.w500,
                              ConstantWidget.getScreenPercentSize(
                                  context, 1.8)),
                          SizedBox(
                            width: ConstantWidget.getScreenPercentSize(
                                context, 0.5),
                          ),
                          InkWell(
                            child: ConstantWidget.getTextWidget(
                                "SIGN IN",
                                primaryColor,
                                TextAlign.start,
                                FontWeight.bold,
                                ConstantWidget.getScreenPercentSize(
                                    context, 2)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
            ),
          )
        : Scaffold(
            body: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //   image: AssetImage("asset/images/rest.jpg"),
                  //   fit: BoxFit.cover,
                  // )
                  ),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('asset/images/rest.jpg'),
                      SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _codeKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 12,
                              ),
                              child: Text(
                                'Enter the code we sent to your mobile',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 24,
                              ),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 6,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(8),
                                  fieldHeight: 60,
                                  fieldWidth: 40,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    verificationCode = value;
                                  });
                                },
                              ),
                            ),
                            PrimaryButton(
                              title: 'CONFIRM',
                              onPress: () => _onSubmit(),
                            ),
                            // SecondaryButton(
                            //     title: 'RESEND',
                            //     onPress: () {
                            //       _verifyCode(_formData['phone']);
                            //     })
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
