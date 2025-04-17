import 'package:hive/hive.dart';
part 'nutrients.g.dart';



@HiveType(typeId: 0)
class Nutrients{

  
  @HiveField(4)
  double protein = 0.0;

  @HiveField(0)
  double carbs = 0.0;

  @HiveField(2)
  double fats = 0.0;

  @HiveField(1)
  double sugars = 0.0;

  @HiveField(3)
  double calories = 0.0;

  //optional
  String data="";

 @HiveField(5) // make sure the number is unique and in order
  int waterGlasses=0;


// set the values, thake photo-> get nutrients of that food-> add that nutrients values to this variable->
//then link this object to food class to update 
void addProtein(double grams) {
    protein += grams;
    calories += grams * 4; // 4 cal per gram
  }

  void addCarbs(double grams) {
    carbs += grams;
    calories += grams * 4;
  }

  void addFats(double grams) {
    fats += grams;
    calories += grams * 9;
  }

  void addSugars(double grams) {
    sugars += grams;
    // Sugars are part of carbs, so you might not need to add extra calories
  }

  void reset() {
    protein = carbs = fats = sugars = calories = 0.0;
  }

  Map<String, dynamic> toJson() => {
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
    'sugars': sugars,
    'calories': calories,
  };


double getFats(){return this.fats;}

double getproteins(){return this.protein;}

double getCarbs(){return this.carbs;}

double getSugars(){return this.sugars;}

double getCals() {return this.calories;}



  //the set functions

  void setProtein(double protein){this .protein=protein;}
  void setcarb(double carbs){this.carbs=carbs;}
  void setfats(double fats){this.fats=fats;}
  void setcalories(double calories){this.calories=calories;}
  void setsugars(double sugars){this.sugars=sugars;}

}