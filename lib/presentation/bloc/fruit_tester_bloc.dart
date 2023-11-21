import 'dart:math';
// import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart' as img;
// import 'package:flutter/material.dart';
// import 'package:image/src/image.dart';
// import 'package:image/src/image.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_plus/src/bindings/types.dart';
import 'package:tunda/data/datasources/label_datasource.dart';
import 'package:tunda/data/repository/fruit_repo.dart';

part 'fruit_tester_event.dart';
part 'fruit_tester_state.dart';

class FruitTesterBloc extends Bloc<FruitTesterEvent, FruitTesterState> {
  FruitTesterBloc() : super(FruitTesterInitial()) {
    on<LoadData>((event, emit) async {
      emit(FruitTesterInitial());
      emit(FruitTesterLoading());
      final labelDs = LabelDataSource().loadLabels();
      final fRipo = await FruitRepo().loadModel();
      TensorImage preProcessInput(img.Image picture) {
        final inputTensor = TensorImage(fRipo.inputType);

        inputTensor.loadImage(picture);
        final minLength = min(inputTensor.height, inputTensor.width);
        final cropOp = ResizeWithCropOrPadOp(minLength, minLength);
        final shapeLength = fRipo.inputShape[1];
        final resizeOp =
            ResizeOp(shapeLength, shapeLength, ResizeMethod.bilinear);
        final normalizeOp = NormalizeOp(127.5, 127.5);
        final imageProcessor = ImageProcessorBuilder()
            .add(cropOp)
            .add(resizeOp)
            .add(normalizeOp)
            .build();
        imageProcessor.process(inputTensor);
        return inputTensor;
      }

      img.Image convertedImage = event.convertedImage;

      final inputImage = preProcessInput(convertedImage);
      print(inputImage);
      print(
          'Pre-processed image: ${inputImage.width}x ${inputImage.height} size: ${inputImage.buffer.lengthInBytes}bytes');

      final outputBuffer =
          TensorBuffer.createFixedSize(fRipo.outputShape, fRipo.outputType);
      fRipo.interpreter.run(inputImage.buffer, outputBuffer.buffer);
      print('Out[putBuffer: ${outputBuffer.getDoubleList()}]');

      await Future.delayed(
        const Duration(seconds: 3),
      );
      emit(const FruitTesterLoaded(greeting: 'Hey pal'));
    });
  }
}
