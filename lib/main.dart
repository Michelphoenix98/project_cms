import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_cms/staff_page.dart';
import './home_page.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new Main());
  });
}

class Main extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Attendance Companion", home: SafeArea(child: LoginPage()));
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _success;
  String _userEmail;
  String _userID;
  String phone;
  String _message = '';
  String _verificationId;
  final TextEditingController _phoneTextController =
  new TextEditingController();
  final TextEditingController _emailIDTextController =
      new TextEditingController();
  final TextEditingController _passwordTextController =
      new TextEditingController();
  final TextEditingController _verificationCodeTextController =
  new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _phoneAuthFormKey=GlobalKey<FormState>();
  final _verificationCodeKey=GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    final emailTextBox = Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(0),
                  topRight: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 20, top: 5, bottom: 5),
            child: TextFormField(
              controller: _emailIDTextController,
              validator: (String value) {
                if (value.isEmpty) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return 'Please enter a valid Email ID.';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mike@example.com",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
            ),
          ),
        ),
      ),
    );
    ;
    final passWordTextBox = Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(0))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 20, top: 5, bottom: 5),
            child: TextFormField(
              obscureText: true,
              controller: _passwordTextController,
              //onSubmitted: _handleSubmitted,
              validator: (String value) {
                if (value.isEmpty) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return 'Please enter a valid password.';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "loki@45",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
            ),
          ),
        ),
      ),
    );
    return Container(
      decoration: new BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xFF00CCFF),
              const Color(0xFF3366FF),
              const Color(0xFF00CCFF),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 0.5, 0.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(icon: Icon(Icons.list)),
            ],
            title: Center(child: Text('Attendance Companion')),
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      const Color(0xFFFF6919),
                      const Color(0xFFFF9700),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          body: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewPortConstraints) {
            return SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewPortConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "College of Engineering",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JH'),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Pathanapuram",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JH'),
                          ),
                        ),
                        Center(
                          child: Image(
                              image: AssetImage("assets/logo.png"),
                              height: 100.0),
                        ),
                        Spacer(flex: 1),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                emailTextBox,
                                SizedBox(height: 5),
                                passWordTextBox,
                              ],
                            )),
                        Spacer(flex: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.orange,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.only(
                                  left: 40.0, right: 40, top: 10, bottom: 15),
                              splashColor: Colors.orangeAccent,
                              onPressed: () async{
                                if (_formKey.currentState.validate()) {
                                  // If the form is valid, display a Snackbar.
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                          //duration:Duration(seconds:5),
                                          content: Text('Processing Data')));
                                  _signInWithEmailAndPassword();
                                }
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Spacer(flex: 2),
                        Center(
                            child: FlatButton(
                          splashColor: Colors.grey,
                          color: Colors.white,
                          onPressed: ()async {
                            /*final studentsList=await Firestore.instance.collection('Students');
                             studentsList.where('email',isEqualTo: _emailIDTextController.text).snapshots().listen(
                                 (data){
                                   if (data.documents.isNotEmpty){
                                     _signInWithGoogle();
                                   }
                                 }
                             );*/
                            final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
                            final GoogleSignInAuthentication googleAuth =
                            await googleUser.authentication;
                            final AuthCredential credential = GoogleAuthProvider.getCredential(
                              accessToken: googleAuth.accessToken,
                              idToken: googleAuth.idToken,
                            );
                            final studentsList=Firestore.instance.collection('Users');
                           final result=studentsList.where('email',isEqualTo:googleUser.email ).where('registered',isEqualTo: true).getDocuments();
                           result.then((QuerySnapshot docs){
                             if(docs.documents.isNotEmpty){

                               _signInWithGoogle(credential,docs);
                             }
                             else{
                               _scaffoldKey.currentState
                                   .showSnackBar(SnackBar(
                                 //duration:Duration(seconds:5),
                                   content: Text('Sign in failed')));
                               _googleSignIn.signOut();
                               _auth.signOut();

                             }

                           });



                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                    image: AssetImage("assets/google_logo.png"),
                                    height: 15.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                        Spacer(flex: 2),
                        Center(
                            child: FlatButton(
                          splashColor: Colors.grey,
                          color: Colors.white,
                          onPressed: ()async {
showDialog(
  context:context,
  builder: (BuildContext context){
    return AlertDialog(
      content:Form(
        key:_phoneAuthFormKey,

            child:Column(
              mainAxisSize:MainAxisSize.min,
              children:<Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                children:<Widget>[Icon(Icons.phone ,color:Colors.lightGreen,),Text("Phone Authentication")],),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneTextController,
                    //onSubmitted: _handleSubmitted,
                    validator: (String value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        return 'Please enter a valid phone number.';
                        phone=_phoneTextController.text;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "+91-XXXX-XXX-XXX",
                        hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),

                  ),
                ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text("Send Verification Code"),
          onPressed: () {
            if (_phoneAuthFormKey.currentState.validate()) {
             // _formKey.currentState.save();
_verifyPhoneNumber();
              phone=_phoneTextController.text;
            //  _phoneTextController.clear();
              Navigator.of(context).pop();
              showDialog(
                  context:context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      content:Form(
                        key:_verificationCodeKey,

                        child:Column(
                          mainAxisSize:MainAxisSize.min,
                          children:<Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children:<Widget>[Icon(Icons.phone ,color:Colors.lightGreen,),Text("Phone Authentication")],),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _verificationCodeTextController,
                                //onSubmitted: _handleSubmitted,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    return 'Please enter the verification Code.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter the 6 digit verification code",
                                    hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),

                              ),
                            ),
Row(
  //mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children:<Widget>[
         Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: RaisedButton(
                                child: Text("Verify Code"),
                                onPressed: ()async {
                                  if (_verificationCodeKey.currentState.validate()) {
                                    // _formKey.currentState.save();

_signInWithPhoneNumber();
Navigator.of(context).pop();

                                  }
                                },
                              ),
                            ),

      Padding(
        padding: const EdgeInsets.all(0.0),
        child: RaisedButton(
          child: Text("Resend Code"),
          onPressed: () {

              // _formKey.currentState.save();




          },
        ),
      )
    ])     ],
                        ),
                      ),
                    );
                  }
              );
            }
          },
        ),
      )     ],
            ),
      ),
    );
  }
);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.phone, color: Color(0xFF76FF03)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Sign in with phone number',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                        Spacer(),
                        Center(
                          child: Text(
                            "© 2019 Michel Thomas",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                  ),
                ));
          })),
    );
  }

  void _pushPage(BuildContext context, Widget page) async {
    _scaffoldKey.currentState.removeCurrentSnackBar();
     _emailIDTextController.clear();
     _passwordTextController.clear();
    final task= await (Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    ));
    await _googleSignIn.signOut();
    await _auth.signOut();
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(
      //duration:Duration(seconds:5),
        content: Text("$_userEmail signed out successfully")));
  }
  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);

        _message = 'Received phone auth credential: $phoneAuthCredential';
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(
          //duration:Duration(seconds:5),
            content: Text(_message)));

    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {

        _message =
        'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(
          //duration:Duration(seconds:5),
            content: Text(_message)));

    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(
            //duration:Duration(seconds:5),
              content: Text('Verification code received')));
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId
      ;
      setState((){
      _phoneTextController.text=_verificationId;
    });};

    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneTextController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
       // codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
  }
  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _verificationCodeTextController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(
          //duration:Duration(seconds:5),
            content: Text('$phone successfully signed in')));
        _verificationCodeTextController.clear();
        Navigator.of(context).pop();
      } else {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(
          //duration:Duration(seconds:5),
            content: Text('Sign in failed')));
        _message = 'Sign in failed';
      }
    });
  }
  void _signInWithEmailAndPassword() async {
    try{
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailIDTextController.text,
      password: _passwordTextController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        Timer(Duration(seconds: 3), () {
          _scaffoldKey.currentState

              .showSnackBar(SnackBar(
            //duration:Duration(seconds:5),
              content: Text('$_userEmail successfully signed in')));
        });

        final studentsList=Firestore.instance.collection('Users');
        final result=studentsList.where('email',isEqualTo:_emailIDTextController.text ).where('registered',isEqualTo: true).getDocuments();
        result.then(
            (QuerySnapshot docs){
              if(docs.documents.isNotEmpty){
                Timer(Duration(seconds: 3), () {
                  //  print("print after every 3 seconds");
                  _pushPage(context,docs.documents[0].data["role"]=="Student"?HomePage(docs):StaffLogin(docs));
                });
               // _signInWithGoogle(credential,docs);


              }
              else{
                _scaffoldKey.currentState
                    .showSnackBar(SnackBar(
                  //duration:Duration(seconds:5),
                    content: Text('Sign in failed')));
               // _googleSignIn.signOut();
                _auth.signOut();

              }

            }
        );

      });
    }}
        catch(e){
          _success = false;
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(
            //duration:Duration(seconds:5),
              content: Text('Sign in failed')));
        }


  }

  void _signInWithGoogle(AuthCredential credential,QuerySnapshot docs) async {




    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        _userEmail=user.email;
        _scaffoldKey.currentState

            .showSnackBar(SnackBar(
          //duration:Duration(seconds:5),
            content: Text('${user.email} successfully signed in')));

        Timer(Duration(seconds: 3), () {
        //  print("print after every 3 seconds");

          _pushPage(context,(docs.documents[0].data["role"]=="Student")?HomePage(docs):StaffLogin(docs));
        });
      //  _auth.signOut();

      } else {
        _success = false;
      }
    });
  }

}


const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
