import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tunda/presentation/bloc/fruit_tester_bloc.dart';
import 'package:image/image.dart' as img;

class TundaWidget extends StatefulWidget {
  const TundaWidget({super.key});

  @override
  State<TundaWidget> createState() => _TundaWidgetState();
}

class _TundaWidgetState extends State<TundaWidget> {
  XFile? pickedImage;
  File? selectedImg;

  Future<void> _takePicture() async {
    pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      Uint8List bytes = await pickedImage!.readAsBytes();
      //final imageBytes = await pickedImage!.readAsBytes();
      // if (context.mounted) {
      selectedImg = File(pickedImage!.path);
      //Uint8List bytes = await selectedImg!.readAsBytes();
      img.Image image = img.Image.fromBytes(224, 224, bytes);
      print(image.height);
      if (context.mounted) {
        context.read<FruitTesterBloc>().add(LoadData(convertedImage: image));
      }
      // context
      //     .read<TundaBloc>()
      //     .add(GetResultFromModel(imageFile: selectedImg!));
      // }

      setState(() {
        selectedImg = File(pickedImage!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: mediaQuery.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: pickedImage == null
                ? const Center(
                    child: Text('Take a picture'),
                  )
                : Image.file(
                    selectedImg!,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _takePicture,
              child: const Text('Take an Image of your plant'),
            ),
          ),
          BlocBuilder<FruitTesterBloc, FruitTesterState>(
              builder: (context, state) {
            if (state is FruitTesterLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FruitTesterLoaded) {
              return Text(state.greeting);
            }
            return const SizedBox.shrink();
          })
        ],
      ),
    );
  }
}
