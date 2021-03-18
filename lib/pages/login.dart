import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/models/user.dart';
import 'package:flutter_application/services/auth.dart';
import 'package:flutter_application/providers/user.provider.dart';
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
      validator: (value) => value.isEmpty ? "Please enter ID" : null,
      onSaved: (value) => _username = value,
      decoration: const InputDecoration(
        icon: Icon(Icons.account_circle),
        hintText: 'Enter ID',
        labelText: 'ID *',
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock),
        hintText: 'Enter password',
        labelText: 'Password *',
      ),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
          style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
           Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        // ignore: deprecated_member_use
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
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
                  SizedBox(height: 200.0),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 20.0),
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
                          onPressed: () => doLogin(), 
                          splashColor: Colors.redAccent,
                          elevation: 5.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.center
                            ),
                          )
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