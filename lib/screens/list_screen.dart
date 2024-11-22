import 'package:flutter/material.dart';


class ListScreen extends StatelessWidget {
  final dynamic media;

    const ListScreen({Key? key, required this.media}) : super(key: key);
    
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: media['type'],
            leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        
        //Mostrar a lista de filmes com as imagens
      );
    }
}
