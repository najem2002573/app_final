
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // For handling image files
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';



class BackendManager
{

//food part of backend


//connect to edamam api to get food nutrients when capturing a photo

//used variables
final ImagePicker _picker = ImagePicker(); // Image picker instance



Future<void> pickAndUploadImage() async {
  try {
    print("starting the camera");
    // Step 1: Pick an image from the camera
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);


    if (image == null) {
      // No image selected, return early
      print("image is null ");
      return ;
    }

    print("got the image");
    String food=getDetection(image).toString();

    if(food.isEmpty){
      return;
    }
    else{
      //print("Got food name now the nutrients");
     // getNutrients("apple");
    }
    // Step 2: Upload the image to Firebase Storage
 
    // Step 3: Process the image to get nutritional data (e.g., carbs, proteins, etc.)
   // Map<String, dynamic> nutritionalData = await extractNutritionalData(image);

    // Step 4: Save the image URL and nutritional data to Firestore
 
    // Optionally, show a success message to the user
   
  }
  catch(e){print("error capturing the image");}

  

}




// getting the label of food to get its
Future<String> getDetection(XFile? image) async {
  final String apiKey = '944cd78d-2bdf-4873-bbe3-a76d63070520'; // Your DeepAI API key
  
  final url = Uri.parse('https://api.deepai.org/api/food-recognition');
  
  // Ensure that image is not null before proceeding
  if (image == null) {
    return 'No image selected';
  }

  try {
    final request = http.MultipartRequest('POST', url)
      ..headers['api-key'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('image', image.path));
    
    final response = await request.send();
    
    // Check if the response is successful (status code 200)
    if (response.statusCode == 200) {
      print("Got the good response");
      // Convert the response to a string
      final responseData = await response.stream.bytesToString();
      
      // Decode the JSON response
      final decodedData = json.decode(responseData);
      
      // Get the predicted food name
      final foodName = decodedData['output']['food_name'] ?? 'No food detected';
      return foodName;
    } else {
      // Log the raw response for debugging
      final responseData = await response.stream.bytesToString();
      print("Error response: $responseData");
      return 'Failed to detect food, status code: ${response.statusCode}';
    }
  } catch (e) {
    return 'Error occurred: $e';
  }
}


// getting the nutrients of the photo via edamam api


//analyze and get nutrients data
Future<Map<String, dynamic>> getNutrients(String foodName) async {
  print("starting collecting the nutrients");

  //Via the api, search fot the nutrients of this food name we got from roboflow model

  final url = Uri.parse('https://world.openfoodfacts.org/cgi/search.pl?search_terms=$foodName&search_simple=1&action=process&json=1');
  
  try {
    final response = await http.get(url);
print("HTTP status code: ${response.statusCode}");
print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final products = data['products'];
      if (products != null && products.isNotEmpty) {
        print("get the nutrients and the name of the food");
        final product = products[0];
        final nutrients = product['nutriments'] ?? {};
        print("${product['product_name']} — this is product name from the result");

        return {
          'name': product['product_name'] ?? 'Unknown',
          'calories': nutrients['energy-kcal_100g'] ?? 0,
          'protein': nutrients['proteins_100g'] ?? 0,
          'fat': nutrients['fat_100g'] ?? 0,
          'carbs': nutrients['carbohydrates_100g'] ?? 0,
          'fiber': nutrients['fiber_100g'] ?? 0,
          'sugar': nutrients['sugars_100g'] ?? 0,
        };
      } else {
        return {'error': 'No matching product found'};
      }
    } else {
      return {'error': 'HTTP Error: ${response.statusCode}'};
    }
  } catch (e) {
    return {'error': 'Exception: $e'};
  }
}


}












