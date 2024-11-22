import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupFormfields extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  SignupFormfields({
    Key? key,
    required this.controller,
    this.validator,
    required this.hintText,
    this.prefixIcon,
    this.inputFormatters,
    this.suffixIcon,
    this.keyBoardType,
    this.readOnly = false,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _SignupFormfieldsState createState() => _SignupFormfieldsState();
}

class _SignupFormfieldsState extends State<SignupFormfields> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyBoardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      obscureText: widget.obscureText ? _isObscured : false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
        ),
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : widget.suffixIcon,
      ),
      readOnly: widget.readOnly,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      onTap: widget.readOnly
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          : null,
    );
  }
}
