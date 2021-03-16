import 'package:flutter/material.dart';

import 'package:flutter_application/pages/login.dart';
import 'package:flutter_application/pages/home.dart';
import 'package:flutter_application/services/auth.dart';
import 'package:flutter_application/providers/user.provider.dart';
import 'package:flutter_application/shares/shared_preference.dart';
import 'package:flutter_application/models/user.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (snapshot.data.token == null)
                    return Login();
                  else
                    return Home(user: snapshot.data);
              }
            }
          ),
          routes: {
            'login': (BuildContext context) => new Login(),
            'home': (BuildContext context) => new Home(),
          }),
    );
  }
}
