import 'package:app/pages/register.dart';
import 'package:app/pages/reset_pass.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),

                // App Logo
                Center(
                  child: Image.asset(
                    'lib/images/wellness.jpg', // Replace with your logo
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),

                // Welcome Text
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Login to continue your wellness journey.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 30),

                // Email Input
                _buildTextField("Phone / Email", emailController, false, Icons.email),
                SizedBox(height: 20),

                // Password Input
                _buildTextField("Password", passwordController, true, Icons.lock),
                SizedBox(height: 10),

                // Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to Forgot Password Page
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ResetPassword()));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.teal, fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Login Button
                _buildLoginButton(),
                SizedBox(height: 20),

                // "Sign in with" Text
                Text(
                  "Sign in with",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),

                // Social Login Buttons
                _buildSocialIcons(),
                SizedBox(height: 20),

                // Sign Up Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Sign Up Page
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for text input fields
  Widget _buildTextField(String hint, TextEditingController controller, bool isPassword, IconData icon) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hint';
        } else if (!isPassword && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email';
        } else if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  // Widget for Login Button
  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // Perform login action
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          "Sign In",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Widget for Social Login Icons
  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(FontAwesomeIcons.apple,Colors.black),
        SizedBox(width: 15),
        _buildSocialButton(FontAwesomeIcons.facebook,Colors.blue),
        SizedBox(width: 15),
        _buildGoogleButton(),
        SizedBox(width: 15),
        _buildSocialButton(FontAwesomeIcons.instagram,Colors.red),
      ],
    );
  }

  // Widget for Social Media Buttons
  Widget _buildSocialButton(IconData icon,Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      
      child: Icon(icon, size: 24,color: color,),
      
    );
  }
}


Widget _buildGoogleButton() {
  return GestureDetector(
    onTap: () {
      print("Google Sign-In Clicked");
    },
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            FontAwesomeIcons.google,
            size: 24,
            color: Colors.white, // This will be overridden by ShaderMask
          ),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 94, 246), // Blue
                  Color.fromRGBO(216, 85, 73, 1), // Red
                  Color(0xFFF4B400), // Yellow
                  Color(0xFF0F9D58), // Green
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: Icon(
              FontAwesomeIcons.google,
              size: 24,
              color: Colors.white, // This will be replaced by gradient
            ),
          ),
        ],
      ),
    ),
  );
}