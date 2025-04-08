
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // For handling image files
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:io';  // For File
import 'package:image_picker/image_picker.dart';  // For ImagePicker and XFile
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
//define image picker
final ImagePicker _picker = ImagePicker(); // Image picker instance
// its safe now

class BackendManager
{

//food part of backend


//connect to edamam api to get food nutrients when capturing a photo

//used variables



Future<void> pickAndUploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Or use .camera for camera

  
  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes();
    print("picked the image and its good");
    // Send image to FastAPI
    final response = await sendImageToAPI(bytes);

    //after getting the name of the food send it to US DATA to get its nutrients
    print(response.toString());
    getNutrients(response.toString());

    if (response != null) {
      print("the response is good,***");
      print('Predicted Label: ${response['predicted_label']}');
    }
  }
  else{
    print("failed");
  }
}






//using custome image model to identify food
Future<Map<String, dynamic>?> sendImageToAPI(Uint8List imageBytes) async {
  final uri = Uri.parse('http://10.0.2.2:8000/predict/');
  final request = http.MultipartRequest('POST', uri);

  // Add the image as a file
  request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      print("response is good");
      final responseData = await response.stream.bytesToString();
      print("the data is : "+responseData);
      return jsonDecode(responseData);
    } else {
      print('Failed to get prediction');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}


 Future<Map<String, dynamic>> getNutrients(String foodItem) async {

     final String apiKey = ""; // Replace with your API key
     final String apiUrl = "https://api.openai.com/v1/chat/completions";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // Use GPT-3.5 or GPT-4 model as per your requirement
          "messages": [
            {
              "role": "user",
              "content":
                  "give me carbs, protein, calories, fats, and sugars of $foodItem in json format with no explanation"
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData['choices'][0]['message']['content'];
        print("code is good now the response is: ");
        print(jsonDecode(message));
        return jsonDecode(message); // Assuming the response is valid JSON
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred: $error');
    }
  }







}//end of backend manager class



///============================================================================================================
///============================================================================================================///============================================================================================================

///============================================================================================================
///============================================================================================================

///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================

//                                        THE GPS PART



















