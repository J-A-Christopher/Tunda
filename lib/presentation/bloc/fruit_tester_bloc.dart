import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart' as img;

import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';
import 'package:tunda/data/datasources/label_datasource.dart';
import 'package:tunda/data/repository/fruit_repo.dart';

part 'fruit_tester_event.dart';
part 'fruit_tester_state.dart';

class FruitTesterBloc extends Bloc<FruitTesterEvent, FruitTesterState> {
  FruitTesterBloc() : super(FruitTesterInitial()) {
    on<LoadData>((event, emit) async {
      try {
        emit(FruitTesterInitial());
        emit(FruitTesterLoading());
        final labelDs = LabelDataSource().loadLabels();
        final fRipo = await FruitRepo().loadModel();
        final interpreter = await Interpreter.fromAsset('jaguh.tflite',
            options: InterpreterOptions());

        TensorImage preProcessInput(picture) {
          final inputTensor = TensorImage(fRipo.inputType);

          inputTensor.loadImage(picture);
          final minLength = min(inputTensor.height, inputTensor.width);
          final cropOp = ResizeWithCropOrPadOp(minLength, minLength);
          print(
              'CROPOP ${cropOp.getOutputImageHeight(inputTensor.height, inputTensor.width)}');
          final shapeLength = fRipo.inputShape;
          print('shapeLength $shapeLength');
          final resizeOp =
              ResizeOp(shapeLength[1], shapeLength[2], ResizeMethod.bilinear);
          final normalizeOp = NormalizeOp(127.5, 127.5);
          print('Nomralize Op ${normalizeOp.stddev}');

          int cropSize = min(inputTensor.height, inputTensor.width);
          print('crop size $cropSize');

          return ImageProcessorBuilder()
              .add(cropOp)
              .add(resizeOp)
              .add(normalizeOp)
              .build()
              .process(inputTensor);
        }

        var convertedImage = event.convertedImage;

        final inputImage = preProcessInput(convertedImage);
        print(inputImage);
        print(
            'Pre-processed image: ${inputImage.width}x ${inputImage.height} size: ${inputImage.buffer.lengthInBytes}bytes');
        print(fRipo.outputShape);
        print(fRipo.outputType);

        final outputBuffer =
            TensorBuffer.createFixedSize(fRipo.outputShape, fRipo.outputType);
        interpreter.run(inputImage.buffer, outputBuffer.getBuffer());
        print('OutputBuffer: ${outputBuffer.getDoubleList()}]');

        await Future.delayed(
          const Duration(seconds: 3),
        );
        emit(const FruitTesterLoaded(greeting: 'Hey pal'));
      } catch (e, stackTrace) {
        print('${e.toString()} stacktrace: $stackTrace');
      }
    });
  }
}
