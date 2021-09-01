import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 110.0,
            child: DrawerHeader(
              child: Text(
                'How to Use',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Column(
            children: [
              Container(
                child: Text(
                  'This App tells you the battery status of your device.It will tell you when your phone is plugged-in or not. The UI will change the color according to your battery percentage',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
