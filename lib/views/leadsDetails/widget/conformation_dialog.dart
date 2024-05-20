import 'package:flutter/material.dart';

AlertDialog conformationDialog(BuildContext context){
  return AlertDialog(
    backgroundColor: Colors.grey,
    contentPadding: const EdgeInsets.only(
      left: 15,
      right: 15,
      top: 15,
    ),
    content: SizedBox(
      height: 57,
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Record Submitted Successfully",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "OK",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red),
        ),
      ),
    ],
  );
}