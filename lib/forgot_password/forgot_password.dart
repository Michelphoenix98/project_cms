import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../resources/user_repository.dart';
import 'package:campus_tool/util/common.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.black38
              : Colors.white,
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black38,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black38, //change your color here
        ),
        centerTitle: true,
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black38
                : Colors.white,
      ),
      body: FormBody(),
    );
  }
}

class FormBody extends StatefulWidget {
  @override
  _FormBodyState createState() => _FormBodyState();
}

class _FormBodyState extends State<FormBody> {
  TextEditingController _emailController = new TextEditingController();
  static final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Icon(
              Icons.vpn_key,
              size: 200,
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.white
                      : Colors.black38,
            ),
          ),
          Text(
            "A link will be sent to this email ID",
            style: TextStyle(
              fontFamily: "Roboto",
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.white
                      : Colors.black38,
            ),
          ),
          Form(
            key: _key,
            child: TextBox(
              textController: _emailController,
              validationFunction: (String string) {
                if (string.isEmpty)
                  return "Field empty";
                else
                  return EmailValidator(errorText: '').isValid(string) != true
                      ? 'Enter a valid email address'
                      : null;
              },
              isEnabled: true,
              hintText: "Email ID",
            ),
          ),
          Button(
            onPressed: () async {
              String text;
              if (_key.currentState.validate()) {
                UserRepository auth = new UserRepository();
                await auth.resetPassword(_emailController.text).then((message) {
                  text = message;
                }).whenComplete(() {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        auth.state == STATE.SUCCESS
                            ? "Password reset email sent"
                            : "$text",
                      ),
                    ),
                  );
                });
              }
            },
            text: "Send",
          )
        ],
      ),
    );
  }
}
