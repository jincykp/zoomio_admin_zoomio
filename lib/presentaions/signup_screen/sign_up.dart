import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/buttons.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/signup_formfields.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/signup_provider.dart'; // New provider for sign-up
import 'package:zoomio_adminzoomio/presentaions/signup_screen/sign.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController =
      TextEditingController(); // Email controller
  final TextEditingController passwordController =
      TextEditingController(); // Password controller

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final signUpProvider = Provider.of<SignUpProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    height: screenWidth * 0.04,
                  ),
                  SignupFormfields(
                    controller: emailController, // Email input
                    hintText: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: screenWidth * 0.04,
                  ),
                  SignupFormfields(
                    controller: passwordController, // Password input
                    hintText: "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      LengthLimitingTextInputFormatter(6)
                    ],
                  ),
                  SizedBox(
                    height: screenWidth * 0.04,
                  ),
                  CustomButtons(
                    text: signUpProvider.isLoading ? "Loading..." : "Sign Up",
                    onPressed: signUpProvider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await signUpProvider.handleSignUp(
                                emailController.text,
                                passwordController.text,
                                context,
                              );
                            }
                          },
                    backgroundColor: ThemeColors.primaryColor,
                    textColor: ThemeColors.textColor,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  if (signUpProvider.signUpMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        signUpProvider.signUpMessage!,
                        style: TextStyle(
                          color: signUpProvider.signUpMessage ==
                                  "Sign-up successful"
                              ? ThemeColors.successColor
                              : Colors.red,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontStyle:
                              FontStyle.italic, // Apply italic style here
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                            );
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                color: ThemeColors.baseColor,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
