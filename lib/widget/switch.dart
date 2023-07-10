import 'package:flutter/material.dart';
import 'package:music_player_1/screen/favlist.dart';
// import '../models/dbfunctions.dart';

class FavoriteButton extends StatelessWidget {
  final int  id;
  const  FavoriteButton({super.key,required this.id});

  // bool favorite= false;
  @override
  Widget build(BuildContext context) {
    return  IconButton(
              icon: (favController.checkFavourite(id))
                  ? Icon(
                      Icons.favorite,
                      color: Colors.white.withOpacity(0.8),
                      size: 25,
                    )
                  : Icon(
                      Icons.favorite,
                      color: Colors.red.withOpacity(0.8),
                      size: 25,
                    ),
              onPressed: () {
               favController.addFavourites(id);
              },
              iconSize: 25,
            );
      // return  GestureDetector(
      //   onTap: () {
      //     print('hjhh');
      //   },
      //   child: Icon(Icons.favorite,size: 30,color: Colors.white,));    
  }
}