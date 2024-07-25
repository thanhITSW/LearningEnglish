import 'dart:convert';

import 'package:application_learning_english/loginPage.dart';
import 'package:application_learning_english/toastify/account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'loading_overlay.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final urlRoot = kIsWeb ? WEB_URL : ANDROID_URL;

  TextEditingController emailController = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    if (emailController.text.isNotEmpty) {
      var reqBody = {
        'email': emailController.text,
      };

      var res = await http.post(Uri.parse(urlRoot + '/accounts/reset'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(res.body);
      setState(() {
        _isLoading = false;
      });

      if (jsonResponse['code'] == 0) {
        showSuccessToast(
            context: context,
            title: 'Success',
            description: 'Please check email to take new password');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyLogin()));
      } else {
        print(jsonResponse['message']);
      }
    } else {
      setState(() {
        _isNotValidate = true;
        _isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LoadingOverlay(
          isLoading: _isLoading,
          child: Stack(
            children: [
              Container(),
              Container(
                padding: EdgeInsets.only(left: 35, top: 130),
                child: Text(
                  'Reset\nPassword',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextField(
                              controller: emailController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.black),
                                  errorText: _isNotValidate
                                      ? "Enter your email"
                                      : null,
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(height: 30),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  resetPassword();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.blue, // Màu nền của nút
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 20), // Kích thước nút
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20), // Bo góc
                                  ),
                                ),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyLogin()));
                                    },
                                    icon: Icon(Icons.arrow_back),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
