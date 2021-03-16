import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/models/user.dart';
import 'package:flutter_application/services/auth.dart';
import 'package:flutter_application/providers/user.provider.dart';
// import 'package:flutter_application/utils/validators.dart';
// import 'package:flutter_application/utils/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      // validator: validateEmail,
      onSaved: (value) => _username = value,
      // decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      // decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
//         FlatButton(
//           padding: EdgeInsets.all(0.0),
//           child: Text("Forgot password?",
//               style: TextStyle(fontWeight: FontWeight.w300)),
//           onPressed: () {
// //            Navigator.pushReplacementNamed(context, '/reset-password');
//           },
//         ),
//         FlatButton(
//           padding: EdgeInsets.only(left: 0.0),
//           child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/register');
//           },
//         ),
      ],
    );

    var doLogin = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_username, _password);

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.of(context).pushNamed('home');
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message']['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 250.0),
                  Text("ID"),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 20.0),
                  Text("Password"),
                  SizedBox(height: 5.0),
                  passwordField,
                  SizedBox(height: 20.0),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : new MaterialButton( 
                          height: 40.0, 
                          minWidth: 70.0, 
                          color: Theme.of(context).primaryColor, 
                          textColor: Colors.white, 
                          child: new Text("Login"), 
                          onPressed: () => doLogin(), 
                          splashColor: Colors.redAccent,
                        ),
                  SizedBox(height: 5.0),
                  forgotLabel
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}