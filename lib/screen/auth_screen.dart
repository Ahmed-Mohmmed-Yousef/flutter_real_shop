import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/http_exceptions.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/AuthScreen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      Color.fromRGBO(255, 188, 177, 1).withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: Text(
                        'My Shop',
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: GoogleFonts.anton().fontFamily,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};

  bool isLoadin = false;
  bool get isLogin {
    return _authMode == AuthMode.Login;
  }

  final TextEditingController _passwordController = TextEditingController();

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  Future<void> submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoadin = true;
    });
    try {
      if (isLogin) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (err) {
      var errorMsg = err.toString();
      if (err.toString() == 'weak-password') {
        errorMsg = 'The password provided is too weak.';
      } else if (err.toString() == 'email-already-in-use') {
        errorMsg = 'The account already exists for that email.';
      } else if (err.toString()== 'user-not-found') {
        errorMsg = 'No user found for that email.';
      } else if (err.toString()== 'wrong-password') {
        errorMsg = 'Wrong password provided for that user.';
      }
      _showErrorDialog(errorMsg);
    } catch (error) {
      const errorMsg = 'Error Occured';
      _showErrorDialog(errorMsg);
    }
    setState(() {
      isLoadin = false;
    });
  }

  void switchAuthMode() {
    setState(() {
      _authMode = isLogin ? AuthMode.SignUp : AuthMode.Login;
      switch (_authMode) {
        case AuthMode.Login:
          _animationController.forward();
          break;
        case AuthMode.SignUp:
          _animationController.reverse();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: !isLogin ? 320 : 260,
        constraints: BoxConstraints(minHeight: !isLogin ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey('email'),
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val.isEmpty || !val.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val;
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val.isEmpty || val.length < 5) {
                      return 'Password is too short';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: isLogin ? 0 : 60,
                    maxHeight: isLogin ? 0 : 120,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        key: ValueKey('cpassword'),
                        enabled: !isLogin,
                        decoration:
                            InputDecoration(labelText: 'Confirm password'),
                        obscureText: true,
                        validator: isLogin
                            ? null
                            : (val) {
                                if (val != _passwordController.text) {
                                  return 'Password is not match';
                                }
                                return null;
                              },
                        onSaved: isLogin
                            ? null
                            : (val) {
                          _authData['password'] = val;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (isLoadin)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(isLogin ? 'Login' : 'Signup'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    color: Theme.of(context).primaryColor,
                    textColor:
                        Theme.of(context).primaryTextTheme.headline6.color,
                    onPressed: submit,
                  ),
                FlatButton(
                  child: Text("${!isLogin ? 'Login' : 'Signup'} INSTTEAD"),
                  onPressed: switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String msg) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text('An error aoccuerd'),
      content: Text(msg),
      actions: [
        FlatButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Oky'))
      ],
    ));
  }
}
