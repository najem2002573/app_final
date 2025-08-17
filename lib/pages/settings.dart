import 'dart:io';

import 'package:app/pages/EditAccount.dart';

import 'package:app/pages/calender.dart';
import 'package:app/pages/food.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/updateData.dart';
import 'package:app/services/appUser.dart';
import 'package:app/services/nutrients.dart';
import 'package:app/services/userDATA.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Box user=Hive.box<AppUser>('userBox');
  AppUser xuser=AppUser(uid: "", username: "", email: "");
 // String userName = manager.getUname();
  Box box=Hive.box('profileimageBox');
  String userImagePath="";
  String uname="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(box.get('profileimage')!=null) {
      setState(() {
        this.userImagePath =box.get('profileimage');
        build(context);
      });
      
    }
    else
      {this.userImagePath="";}

    this.xuser=user.get('currentUser');
    this.uname=xuser.username;


    
  }
     

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:   userImagePath.isNotEmpty
  ? FileImage(File(userImagePath))   // ✅ Load image from file
  : AssetImage("lib/images/user.png") ,
                  ),
                  GestureDetector(
                    onTap: () async {
                          final updatedImagePath = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAccountPage(),
                            ),
                          );

                          if (updatedImagePath != null) {
                            setState(() {
                              userImagePath = updatedImagePath; // or however you're storing it
                            });
                          }
                        },



                    
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      radius: 18,
                      child: Icon(Icons.edit, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                uname,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),

              // Settings List
              _buildSettingsTile("Calendar", Icons.calendar_today_outlined),
              //cancelled the remider page cause its full of errors
              //_buildSettingsTile("Reminder", Icons.notifications_outlined),
              _buildSettingsTile("Update Data", Icons.update,
                  showTrailing: false),
              /*remove the terms and conditions cause its useless for now
              _buildSettingsTile(
                  "Terms & Conditions", Icons.description_outlined,
                  showTrailing: false),*/

              SizedBox(height: 180,),
              _buildlogOut("Sign out", Icons.logout,
                  isDestructive: true, showTrailing: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon,
      {bool isDestructive = false, bool showTrailing = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: Icon(icon,
            size: 26, color: isDestructive ? Colors.red : Colors.deepPurple),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: isDestructive ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: showTrailing
            ? Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey.shade400)
            : null,
        onTap: () {
          
          if (title == "Calendar") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          }
          if(title=="Update Data"){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Updatedata()));
            }
        },
      ),
    );
  }

Widget _buildlogOut(String title, IconData icon,
      {bool isDestructive = false, bool showTrailing = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: Icon(icon,
            size: 26, color: isDestructive ? Colors.red : Colors.deepPurple),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: isDestructive ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: showTrailing
            ? Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey.shade400)
            : null,
        onTap: () async{
          _logoutConfirmation(context);
        },
      ),
    );
  }
  

  void _logoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Are you sure tou want to log out ${manager.getUname() } ? "),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
            onPressed: () async{
               await FirebaseAuth.instance.signOut();
          print("user has signed out from the firebase");
          // Optional: Clear local user data
          final box = Hive.box<AppUser>('userBox');
          box.delete('currentUser');
          Box userBox = Hive.box<AppUser>('userBox');
          await userBox.clear();  // ✅ Clears all stored user data!
          Box box1=Hive.box<Nutrients>('nutrientsBox');
          box1.clear();

          Box box2=Hive.box<Userdata>('userData');
          box2.clear();

Box box3=Hive.box('profileimageBox');
          box3.clear();
Box box4=Hive.box<AppUser>('userBox');
          box4.clear();
          
          
          print("deleting the local user data from hive local");
          // Navigate to sign-in screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInScreen()),
            (route) => false,);
            },
             child: Text("confirm log out"))
          ],
        ),
      );
    });
  }




  Widget _buildSocialButton(IconData icon) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.deepPurple.shade50,
      child: Icon(icon, size: 18, color: Colors.deepPurple),
    );
  }
}