

import 'package:generate_ai_dart/generate_ai_dart.dart';
void main() {


  const key = "your key here";
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
