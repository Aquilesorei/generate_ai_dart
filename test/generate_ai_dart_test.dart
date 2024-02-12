import 'package:flutter_test/flutter_test.dart';


import 'package:generate_ai_dart/generate_ai_dart.dart';
import 'package:generate_ai_dart/internal/api/APIController.dart';
void main() {


  const key = "AIzaSyA8rLjw-PmkAFgSd3z3j0AfuHPHqdREISg";
  final config = generationConfig((builder){
    builder.temperature =0.7;
  });
  final model = GenerativeModel(Model.geminiPro,key,generationConfig: config);
  model.generateContent([content(role : 'user' ,init: (builder){
    builder.text("hello");
  })]).then((value) => print(value.text));
 /* test('adds one to input values', () {

    //expect(des, category);
  });*/


}
