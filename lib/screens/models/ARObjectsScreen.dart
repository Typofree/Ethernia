import 'package:flutter/material.dart';

import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ethernia_ar/screens/models/modelsController.dart';

class ARObjectsScreen extends StatefulWidget {
  const ARObjectsScreen({Key? key, required this.object, required this.isLocal})
      : super(key: key);

  final String object;

  final bool isLocal;

  @override
  State<ARObjectsScreen> createState() => _ARObjectsScreenState();
}

class _ARObjectsScreenState extends State<ARObjectsScreen> {
  final ModelsController modelsController = ModelsController();
  bool isAdd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: ARView(onARViewCreated: onARViewCreated),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modelsController.loadWebModel(widget.object),
        child: Icon(isAdd ? Icons.remove : Icons.add),
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    modelsController.initializeAR(arSessionManager, arObjectManager);
  }

  @override
  void dispose() {
    modelsController.dispose();
    super.dispose();
  }
}
