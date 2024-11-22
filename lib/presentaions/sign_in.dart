import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/buttons.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/signup_formfields.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/signin_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: screenWidth * 0.04,
                ),
                SignupFormfields(
                  controller: nameController,
                  hintText: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenWidth * 0.04,
                ),
                SignupFormfields(
                  controller: passWordController,
                  hintText: "Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenWidth * 0.04,
                ),
                CustomButtons(
                  text: loginProvider.isLoading ? "Loading..." : "Sign In",
                  onPressed: loginProvider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await loginProvider.handleLogin(nameController.text,
                                passWordController.text, context);
                          }
                        },
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                if (loginProvider.loginMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      loginProvider.loginMessage!,
                      style: TextStyle(
                          color:
                              loginProvider.loginMessage == "Login successful"
                                  ? ThemeColors.successColor
                                  : Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
