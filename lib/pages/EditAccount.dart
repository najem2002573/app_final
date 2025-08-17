import 'dart:io';

import 'package:app/services/appUser.dart';
import 'package:app/services/manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';



class EditAccountPage extends StatefulWidget {
  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}


final picker = ImagePicker();//for changing the user image purpose


class _EditAccountPageState extends State<EditAccountPage> {
  final manager=BackendManager();
  String imagepath="";
  String uname="";
 
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  AppUser Xuser=AppUser(uid: "", username: "", email: '');
 
  Future<XFile?> pickImage() async{
    
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); // Or use .camera for camera
    print(pickedFile?.path);

    if(pickedFile!=null){
      setState(() {
            this.imagepath=pickedFile.path;
            build(context);
          });
      Box profileImage=Hive.box('profileimageBox');
      profileImage.put("profileimage", this.imagepath);
      print("the onclick path is $imagepath");
      manager.setProfiePath(imagepath);
    }
    return pickedFile;
  }

  Future<String> loadProfileImage() async{
  Box profileImage=Hive.box('profileimageBox');
  String? imagepath=profileImage.get('profileimage');
  if(imagepath==null)
    return "";
  setState(() {
    this.imagepath=imagepath;
  });
  return imagepath;
  
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    openBox(); // for loading image path
    loadProfileImage();
    Box userbox=Hive.box<AppUser>('userBox');
    AppUser user=userbox.get('currentUser');

    Xuser.uid=manager.getUid();
   
    

    this.Xuser=user;
    print("the xuser values are : mail is ${this.Xuser.email} and its uname is : ${this.Xuser.username}");
    
    nameController.text=uname;
    

    

  }



  Future<void> openBox() async{
    await Hive.openBox("profileimageBox");
  }
  


  @override
  Widget build(BuildContext context) {
    this.Xuser.uid=manager.uid;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: BackButton(color: Colors.black,onPressed: (){Navigator.pop(context, imagepath);},),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Edit account",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bigger profile image
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.deepPurple.shade100,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: imagepath!="" ? FileImage(File(imagepath)) : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: Text(
                      "Edit photo",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Full Name Field
                  _buildInputFieldname("Full name", uname),
                  const SizedBox(height: 30),

                  // Email Field
                  
                  const SizedBox(height: 30),

                  // Change password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Change password
                        _showChangePasswordDialog(context);
                      },
                      child: Text(
                        "Change password",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button pinned at the bottom
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save logic
                  this.uname=nameController.text;
                  this.Xuser.username=uname;

                  print("the xuser that will be cached and uploaded to DB is ${Xuser.username}");
                  print("the xuser id is : ${Xuser.uid}");
                  manager.cacheUser(Xuser);
                  manager.updateUserInDatabase(Xuser);
                  manager.getPrediction();
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Name changed successfully!"),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFieldname(String label, String initialValue) {
    nameController.text=this.Xuser.username;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: nameController,
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }


  final TextEditingController newPasswordController=TextEditingController();
  
  final TextEditingController oldPasswordController=TextEditingController();

  
  void _showChangePasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Old Password"),
              controller: oldPasswordController,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
              controller: newPasswordController,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Validate and update password logic here
              print("the user.mail is (before changing password) ${this.Xuser.email}");
              _changePassword(Xuser.email,oldPasswordController.text, newPasswordController.text);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without action
            },
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}




Future<void> _changePassword(String email, String oldPassword, String newPassword) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is signed in.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No authenticated user."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 1: Reauthenticate the user with the old password
   final user1 = FirebaseAuth.instance.currentUser;
if (user1 != null) {
  final credential = EmailAuthProvider.credential(
    email: user.email!,
    password: oldPassword,
  );
  await user.reauthenticateWithCredential(credential);
  print("Reauthentication successful!");
} else {
  print("No user is currently signed in.");
}

    // Step 2: Update the password
    await user.updatePassword(newPassword);
    print("Password successfully updated!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Password changed successfully!"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );

  } catch (error) {
    print("Error updating password: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to change password. Please try again."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}