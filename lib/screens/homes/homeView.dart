import 'package:flutter/material.dart';

import 'package:ethernia_ar/screens/models/ARObjectsScreen.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ShopCardModel> mycard = [
    ShopCardModel(Icons.shopping_bag, 'Warrior', true, ARObjects.shoe, false),
    ShopCardModel(Icons.apartment, 'Magician', true, ARObjects.chair, false),
    ShopCardModel(Icons.home, 'Ranger', true, ARObjects.chicken, false),
    ShopCardModel(Icons.grade, 'Rogue', true, ARObjects.figure, false),
    ShopCardModel(Icons.animation, 'Barbarian', true, ARObjects.fox, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Let's shopping!",
              style: TextStyle(fontSize: 24, color: AppColors.black54),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: mycard
                    .map(
                      (e) => InkWell(
                    onTap: () => onTap(e),
                    child: Card(
                      color: e.isActive ? AppColors.mainColor : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            e.icon,
                            size: 50,
                            color: e.isActive
                                ? AppColors.white
                                : AppColors.mainColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            e.title,
                            style: TextStyle(
                                color: e.isActive
                                    ? AppColors.white
                                    : AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );

  }

  void onTap(ShopCardModel e) {
    setState(() {
      e.isActive = !e.isActive;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ARObjectsScreen(
              object: e.object,
              isLocal: e.isLocal,
            ))).then((value) {
      setState(() {
        e.isActive = !e.isActive;
      });
    });
  }
}

class AppColors {
  static Color mainColor = Colors.deepPurple;

  static Color background = const Color(0xfff6f7f9);

  static Color black54 = Colors.black54;

  static Color white = Colors.white;

  static Color grey = Colors.grey;
}

class ARObjects {

  static const String fox = "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/Duck/glTF-Binary/Duck.glb";

  static const String figure = "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/Duck/glTF-Binary/Duck.glb";

  static const String shoe = "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/Duck/glTF-Binary/Duck.glb";

  static const String chair =
      "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/Duck/glTF-Binary/Duck.glb";

  static const String chicken = "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/Duck/glTF-Binary/Duck.glb";
}

class ShopCardModel {
  final IconData icon;

  final String title;

  bool isActive = false;

  final String object;

  final bool isLocal;

  ShopCardModel(
      this.icon, this.title, this.isActive, this.object, this.isLocal);
}

