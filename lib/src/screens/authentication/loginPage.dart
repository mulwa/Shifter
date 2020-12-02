import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shifter_app/src/screens/authentication/signupPage.dart';
import 'package:shifter_app/src/utils/constants.dart';
import 'package:shifter_app/src/utils/strings.dart';
import 'package:shifter_app/src/widgets/app_card.dart';
import 'package:shifter_app/src/widgets/custom_input_decoration.dart';
import 'package:shifter_app/src/widgets/progress_dialog.dart';
import 'package:shifter_app/src/widgets/roundedApealBtn.dart';
import 'package:shifter_app/src/widgets/vertical_spacing.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _passwordVisible = true;

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Email Address',
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      validator: (String value) {
        if (value.isEmpty) {
          return "Email address is required";
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
      onChanged: (value) {
        _email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: inputBackground,
          filled: true,
          hintText: "Password",
          suffix: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                  print(_passwordVisible);
                });
              })),
      obscureText: _passwordVisible ? true : false,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {},
      validator: (String value) {
        if (value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
      onChanged: (value) {
        _password = value;
      },
    );
  }

  void _showError(String error) {
    final snackBar = SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ListView(
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: 150,
              ),
              Container(
                height: 250,
                color: colorPrimary,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 26.0),
                        )
                      ],
                    ),
                  )),
              Positioned(
                  top: 100.0,
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width - 32.0,
                    child: AppCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            VerticalSpacing(),
                            Text("Sign In", style: TextStyle(fontSize: 18)),
                            VerticalSpacing(
                              height: 20,
                            ),
                            _buildEmailField(),
                            VerticalSpacing(),
                            _buildPasswordField(),
                            VerticalSpacing(),
                            RoundedApealBtn(
                                text: "Login",
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    showDialog(
                                      context: context,
                                      builder: (context) => ProgressDialog(
                                        status: "Authenticating user Wait ....",
                                      ),
                                    );
                                    // try {
                                    //   final User user =
                                    //       await AuthService.signInWithEmail(
                                    //           email: _email,
                                    //           password: _password);
                                    //   Navigator.pop(context);
                                    //   if (user != null) {
                                    //     print("loged in");
                                    //   }
                                    // } catch (e) {
                                    //   FirebaseAuthException pe = e;
                                    //   _showError(pe.message);
                                    //   Navigator.pop(context);
                                    //   print(pe.code);
                                    // }
                                  }
                                  return;
                                }),
                            VerticalSpacing(),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                    text: "New User ? ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: " Create an account",
                                          style: TextStyle(
                                              color: colorPrimaryDark,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignUpPage()));
                                            })
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
