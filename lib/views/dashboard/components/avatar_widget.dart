import 'package:flutter/material.dart';

class AvatarWithName extends StatelessWidget {
  final String name;

  const AvatarWithName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    // Get the first and last characters of the name
    String firstLetter = name.substring(0, 1).toUpperCase();
    String lastLetter = name.substring(name.length - 1).toUpperCase();

    return CircleAvatar(
      backgroundColor: Colors.blue, // Set your desired background color
      radius: 25, // Set your desired radius
      child: Row(
        // alignment: Alignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            firstLetter,
            style: const TextStyle(
              color: Colors.white, // Set your desired text color
              fontSize: 20, // Set your desired font size
              fontWeight: FontWeight.bold, // Set your desired font weight
            ),
          ),
          Text(
            lastLetter,
            style: const TextStyle(
              color: Colors.white, // Set your desired text color
              fontSize: 20, // Set your desired font size
              fontWeight: FontWeight.bold, // Set your desired font weight
            ),
          ),
        ],
      ),
    );
  }
}
