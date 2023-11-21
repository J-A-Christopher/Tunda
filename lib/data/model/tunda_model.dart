import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierModel {
  Interpreter interpreter;
  List<int> inputShape;
  List<int> outputShape;
  final inputType;
  //TfLiteType outputType;
  //TensorType inputType;
  TensorType outputType;
  ClassifierModel(
      {required this.inputShape,
      required this.inputType,
      required this.interpreter,
      required this.outputShape,
      required this.outputType});
}
