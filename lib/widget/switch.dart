import 'package:flutter/material.dart';
import '../models/dbfunctions.dart';

class SwitchCase extends StatefulWidget {
   SwitchCase({super.key,required this.id});
int id;
  @override
  State<SwitchCase> createState() => _SwitchCaseState();
}

class _SwitchCaseState extends State<SwitchCase> {
  // bool favorite= false;
  @override
  Widget build(BuildContext context) {
    return  IconButton(
              icon: (checkFavourite(widget.id, BuildContext))
                  ? Icon(
                      Icons.favorite,
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Icon(
                      Icons.favorite,
                      color: Colors.red.withOpacity(0.8),
                    ),
              onPressed: () {
                addFavourites(widget.id,context);
                setState(() {
                  
                });
              },
              
            );
            
  }
}