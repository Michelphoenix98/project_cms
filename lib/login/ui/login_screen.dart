import 'dart:ui';

import 'package:campus_tool/authentication/bloc/bloc.dart';
import 'package:campus_tool/forgot_password/forgot_password.dart';
import 'package:campus_tool/login/bloc/bloc.dart';
import 'package:campus_tool/register/ui/register_screen.dart';
import 'package:campus_tool/util/nm_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campus_tool/util/common.dart';

import 'package:flutter/material.dart';

import '../../resources/user_repository.dart';



class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;
  Color color;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.grey[200],
      /* appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Campus Tool",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black38,
          ),
        ),
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.white,
      ),*/
      body: BlocProvider<LoginBloc>(
        bloc: _loginBloc,
        child: Center(
          child: Container(
              height: 700,
              width: 325,
              child: NeumorphicContainer(
                isInteractive: false,
                bevel: 2,
                padding: 10,
                child: Container(
                  child: LayoutBuilder(builder: (BuildContext context,
                      BoxConstraints viewPortConstraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewPortConstraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: CustomForm(
                            userRepository: _userRepository,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )),
        ),
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  final UserRepository _userRepository;
  CustomForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  bool active = false;
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _onResendVerificationEmail(User user) {
    _loginBloc.dispatch(ResendVerificationEmail(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state.isFailure) {
          if (state.isEmailAuthenticated) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  action: SnackBarAction(
                      textColor: Colors.white,
                      label: "Resend",
                      onPressed: () {
                        _onResendVerificationEmail(state.user);
                      }),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Account not verified."),
                      Icon(Icons.email)
                    ],
                  ),
                  backgroundColor: Colors.blue,
                ),
              );
          } else {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Login Failure'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.verificationEmailJustSent) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Verification email sent.'),
                    Icon(Icons.check)
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 200,
                  width: 200,
                  decoration: createInvertBox(radius: 50, isCircular: true),
                  child: Center(
                    child: Image(
                        image: AssetImage("assets/logo.png"), height: 100.0),
                  ),
                ),
                Center(
                  child: Text(
                    "College of Engineering",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JH',
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                Center(
                  child: Text(
                    "Pathanapuram",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JH',
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                /*  GestureDetector(
            onTap: () {
              setState(() {
                (active) ? active = false : active = true;
              });
            },
            child: NMCard(
              active: active,
              icon: active ? Icons.lock : Icons.lock_open,
              label: 'Lock Account',
            ),
          ),*/
                TextBox(
                  textController: _emailController,
                  validationFunction: (_) {
                    return !state.isEmailValid ? 'Invalid Email' : null;
                  },
                  /* (String string) {
                    if (string.isEmpty)
                      return "Field empty";
                    else
                      return EmailValidator(errorText: '').isValid(string) !=
                              true
                          ? 'Enter a valid email address'
                          : null;
                  },*/
                  hintText: "Email ID: eg Mike@gmail.com",
                ),
                TextBox(
                  textController: _passwordController,
                  validationFunction: (_) {
                    return !state.isPasswordValid ? 'Invalid Password' : null;
                  },
                  /* MultiValidator([
                    RequiredValidator(errorText: 'password is required'),
                    MinLengthValidator(8,
                        errorText: 'password must be at least 8 digits long'),
                    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                        errorText:
                            'passwords must have at least one special character')
                  ]),*/
                  hintText: "Password",
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      final task = await (Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => ResetPasswordScreen()),
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 15),
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                NeumorphicContainer(
                  bevel: 5,
                  //  color: Colors.white,
                  child: GestureDetector(
                    /* onTap: () async {
                      User user;
                      if (_formKey.currentState.validate()) {
                        Auth auth = new Auth();
                        await auth
                            .signIn(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          user = value;
                          //  print("DATA ${user.emailID}");
                        }).whenComplete(() {
                          // print("DATA  ${user.userName} ${user.emailID}");
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              action: auth.state == STATE.SUCCESS &&
                                      user.message ==
                                          "Please check your mail for the verification link"
                                  ? SnackBarAction(
                                      label: "Resend",
                                      onPressed: () {
                                        auth.sendVerficationLink(user.user);
                                      },
                                    )
                                  : null,
                              content: Text(
                                "${user.message}",
                              ),
                            ),
                          );
                          if (auth.state == STATE.SUCCESS &&
                              user.message !=
                                  "Please check your mail for the verification link")
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (_) => Scaffold()),
                            );
                        });
                      } else
                        FocusScope.of(context).requestFocus(FocusNode());
                    },*/
                    onTap:
                        isLoginButtonEnabled(state) ? _onFormSubmitted : null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Login',
                        style: Typography.blackCupertino.display2,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final task = await (Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) =>
                              RegisterScreen(userRepository: _userRepository)),
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "Create new account",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final double bevel;
  final Offset blurOffset;
  final Color color;
  final double padding;
  final bool isInteractive;
  NeumorphicContainer({
    Key key,
    this.child,
    this.bevel = 10.0,
    this.color,
    this.padding = 24.0,
    this.isInteractive = true,
  })  : this.blurOffset = Offset(bevel / 2, bevel / 2),
        super(key: key);

  @override
  _NeumorphicContainerState createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = this.widget.color ?? Theme.of(context).backgroundColor;
    final nContainer = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.all((this.widget.padding)),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(widget.bevel * 10),
        /*   gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isPressed ? color : color.mix(Colors.grey.shade200, .1),
                _isPressed ? color.mix(Colors.black, .05) : color,
                _isPressed ? color.mix(Colors.black, .05) : color,
                color.mix(Colors.white, _isPressed ? .2 : .5),
              ],
              stops: [
                0.0,
                .3,
                .6,
                1.0,
              ]),*/
        boxShadow: _isPressed
            ? null
            : [
                BoxShadow(
                  blurRadius: widget.bevel,
                  offset: -widget.blurOffset,
                  color: color.mix(Colors.white, 1),
                ),
                BoxShadow(
                  blurRadius: widget.bevel,
                  offset: widget.blurOffset,
                  color: color.mix(Colors.black, .3),
                )
              ],
      ),
      child: widget.child,
    );
    return this.widget.isInteractive
        ? Listener(
            onPointerDown: _onPointerDown,
            onPointerUp: _onPointerUp,
            child: nContainer,
          )
        : nContainer;
  }
}

class NMButton extends StatelessWidget {
  final bool down;
  final IconData icon;
  const NMButton({this.down, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: down ? createInvertBox() : nMbox,
      child: Icon(
        icon,
        color: down ? fCD : fCL,
      ),
    );
  }
}

class NMCard extends StatelessWidget {
  final bool active;
  final IconData icon;
  final String label;
  const NMCard({this.active, this.icon, this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: nMbox,
      child: Row(
        children: <Widget>[
          Icon(icon, color: fCL),
          SizedBox(width: 15),
          Text(
            label,
            style: TextStyle(
                color: fCD, fontWeight: FontWeight.w700, fontSize: 16),
          ),
          Spacer(),
          Container(
            decoration: active ? nMboxInvertActive : createInvertBox(),
            width: 70,
            height: 40,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: active
                  ? EdgeInsets.fromLTRB(35, 5, 5, 5)
                  : EdgeInsets.fromLTRB(5, 5, 35, 5),
              decoration: createNeuroButton(active),
            ),
          ),
        ],
      ),
    );
  }
}
