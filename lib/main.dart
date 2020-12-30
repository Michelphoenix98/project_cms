import 'package:campus_tool/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campus_tool/bloc/authentication_bloc/bloc.dart';
import 'bloc/simple_block_delegate.dart';
import 'ui/login_screen.dart';
import 'package:bloc/bloc.dart';
import 'resources/user_repository.dart';
import 'ui/splash_screen.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new App());
  });
}

class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRep: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authenticationBloc,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
          backgroundColor: Colors.grey[200],
          scaffoldBackgroundColor: Colors.grey[200],
          dialogBackgroundColor: Colors.grey[200],
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        title: "Campus Attendance",
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            print("In here!");
            if (state is Uninitialized) {
              print("In here!");
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is Authenticated) {
              print("In here!");
              return HomeScreen(name: state.displayName);
            }
            return Text("Hello");
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}
