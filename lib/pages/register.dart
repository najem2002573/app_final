
import 'package:app/pages/login.dart';
import 'package:app/services/appUser.dart';
import 'package:app/services/authUser.dart';
import 'package:app/services/manager.dart';
import 'package:app/services/nutrients.dart';
import 'package:app/services/userDATA.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  
  Register register=Register();
  @override
  Widget build(BuildContext context) {
    final manager=BackendManager();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo or Illustration
                  Center(
                    child: Image.asset(
                      'lib/images/logo.jpeg', // Add your logo in the assets folder
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  // App Title
                  const Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Join Wellness Tracker today!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
        
                  // Name Input
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "User name",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
        
                  // Email Input
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
        
                  // Password Input
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
        
                  // Confirm Password Input
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
        
                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        
                        
                        if (_formKey.currentState!.validate()) {
                          // Perform registration action
                          //first save this data to the firebase authentication then move to the sign in
                          //screen to let the user sign in as an already registered user
        
                          final user = await AuthService().registerUser(
                                    nameController.text.trim(),
                                    emailController.text.trim(),
                                    passwordController.text,
                                  );
                                  
                                      if (user != null) {
                                        
                                        // Navigate to homepage or show success
                                        print("register the user for the first time is success!!!");
                                        print("now the manager will store the user locally: caching");
                                        final box=Hive.box<Nutrients>("nutrientsBox");
                                        box.clear();
                                        await manager.cacheUser(user);
                                        
                                        final box4 = Hive.box<AppUser>('userBox');
          box4.delete('currentUser');
          Box userBox = Hive.box<AppUser>('userBox');
          await userBox.clear();  // ✅ Clears all stored user data!
          Box box1=Hive.box<Nutrients>('nutrientsBox');
          box1.clear();
          manager.deleteNutrients();

          Box box2=Hive.box<Userdata>('userData');
          box2.clear();

Box box3=Hive.box('profileimageBox');
          box3.clear();
Box box5=Hive.box<AppUser>('userBox');
          box5.clear();
          
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
                                      } else {
                                        // Show error
        
                                        print("user aint registered error");
                                      }
        
                          
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  // Login Prompt
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            // Navigate to Login Page
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
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
