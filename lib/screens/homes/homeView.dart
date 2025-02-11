import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Model Viewer'),
      ),
      body: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontal,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (lastTappedPosition != null) {
                addARObject(lastTappedPosition!);
              }
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: rotateLastAddedNode,
            child: const Icon(Icons.rotate_right),
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
      }
    };
  }

  Future<void> addARObject(Vector3 position) async {
    var newNode = ARNode(
      type: NodeType.webGLB,
      uri:
          "https://raw.githubusercontent.com/Typofree/depot_model/main/models/caracters/warrior.glb",
      scale: Vector3(1, 1, 1),
      position: position,
    );

    bool? didAdd = await arObjectManager?.addNode(newNode);
    if (didAdd == true) {
      lastAddedNode = newNode;
      debugPrint("Model added successfully at position: $position");
    } else {
      debugPrint("Failed to add model");
    }
  }

  void rotateLastAddedNode() {
    if (lastAddedNode != null) {
      Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (lastAddedNode == null) {
          timer.cancel();
          return;
        }
        Matrix4 currentTransform = lastAddedNode!.transform;
        currentTransform.rotateY(radians(10));
        lastAddedNode!.transform = currentTransform;
        arObjectManager?.removeNode(lastAddedNode!);
        arObjectManager?.addNode(lastAddedNode!);
        if (currentTransform.getRotation().getColumn(1).y >= radians(360)) {
          timer.cancel();
        }
      });
      debugPrint("Rotating last added model");
    } else {
      debugPrint("No model to rotate");
    }
  }
}
