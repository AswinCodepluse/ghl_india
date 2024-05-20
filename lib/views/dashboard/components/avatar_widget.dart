import 'package:flutter/material.dart';

class AvatarWithName extends StatelessWidget {
  final String name;

  const AvatarWithName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    String firstLetter = name.substring(0, 1).toUpperCase();
    String lastLetter = name.substring(name.length - 1).toUpperCase();

    return CircleAvatar(
      backgroundColor: Colors.blue,
      radius: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            firstLetter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            lastLetter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
