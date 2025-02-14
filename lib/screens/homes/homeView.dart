import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'dart:async';

import 'package:ethernia_ar/screens/models/ARObjectsScreen.dart';
import 'package:ethernia_ar/constants/ArModels.dart';
import 'package:ethernia_ar/constants/appColors.dart';

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({Key? key}) : super(key: key);

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  Vector3? lastTappedPosition;
  ARNode? lastAddedNode;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Model Viewer'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          if (isLoading)
            Center(
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Loading Model...",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (lastTappedPosition != null) {
                addOrMoveARObject(lastTappedPosition!);
              }
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: moveModel,
            child: const Icon(Icons.open_with),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager?.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      showWorldOrigin: true,
      handleTaps: true,
    );

    arObjectManager?.onNodeTap = (nodes) {
      debugPrint("Tapped on node: ${nodes.first}");
    };

    arSessionManager?.onPlaneOrPointTap = (hits) {
      if (hits.isNotEmpty) {
        final hitResult = hits.first;
        lastTappedPosition = Vector3(
          hitResult.worldTransform[12], // X coordinate
          hitResult.worldTransform[13], // Y coordinate
          hitResult.worldTransform[14], // Z coordinate
        );
        debugPrint(
            "Tapped position: X=${lastTappedPosition!.x}, Y=${lastTappedPosition!.y}, Z=${lastTappedPosition!.z}");
      }
    };
  }

  Future<void> addOrMoveARObject(Vector3 position) async {
    if (lastAddedNode != null) {
      lastAddedNode!.position = position;
      arObjectManager?.removeNode(lastAddedNode!);
      arObjectManager?.addNode(lastAddedNode!);
      debugPrint("Moved existing model to new position: $position");
    } else {
      setState(() => isLoading = true);
      var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://raw.githubusercontent.com/Typofree/depot_model/main/models/caracters/archer.glb",
        scale: Vector3(0.1, 0.1, 0.1),
        position: position,
      );

      bool? didAdd = await arObjectManager?.addNode(newNode);
      setState(() => isLoading = false);
      if (didAdd == true) {
        lastAddedNode = newNode;
        debugPrint("Model added successfully at position: $position");
      } else {
        debugPrint("Failed to add model");
      }
    }
  }

  void moveModel() {
    if (lastAddedNode != null) {
      lastAddedNode!.position += Vector3(0.1, 0, 0);
      arObjectManager?.removeNode(lastAddedNode!);
      arObjectManager?.addNode(lastAddedNode!);
      debugPrint(
          "Moved model to: X=${lastAddedNode!.position.x}, Y=${lastAddedNode!.position.y}, Z=${lastAddedNode!.position.z}");
    } else {
      debugPrint("No model to move");
    }
  }
}
