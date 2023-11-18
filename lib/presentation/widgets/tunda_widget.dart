import 'package:flutter/material.dart';

class TundaWidget extends StatefulWidget {
  const TundaWidget({super.key});

  @override
  State<TundaWidget> createState() => _TundaWidgetState();
}

class _TundaWidgetState extends State<TundaWidget> {
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Take an Image of your plant'),
            ),
          )
        ],
      ),
    );
  }
}
