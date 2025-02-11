import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';

class ModelsController {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? webObjectNode;
  String? modelUri; // Stores the model URL to be loaded later

  void initializeAR(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
    );

    arObjectManager.onInitialize();

    // ✅ Wait for a tap on a detected surface before loading a model
    arSessionManager.onPlaneOrPointTap = (hits) {
      if (hits.isNotEmpty) {
        var firstHit = hits.first;
        Vector3 position = firstHit.worldTransform.getTranslation();
        Vector4 rotation = Vector4(0, 0, 0, 1); // Default rotation

        if (modelUri != null) {
          print("✅ Detected a plane! Loading model at: $position");
          loadModel(modelUri!, position, rotation);
        } else {
          print("⚠️ Model URI is null. Set a model before tapping.");
        }
      } else {
        print("⚠️ No valid surface detected. Move your phone around.");
      }
    };

    print("✅ AR Session Initialized!");
  }

  void loadWebModel(String uri) {
    modelUri = uri;
    print("📡 Model URL set: $modelUri. Tap a surface to place the model.");
  }

  /// **Loads a model at a given position**
  Future<void> loadModel(String uri, Vector3 position, Vector4 rotation) async {
    if (webObjectNode != null) {
      await arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
      print("🗑️ Removed existing model.");
    }

    var newNode = ARNode(
      type: NodeType.webGLB,
      uri: uri,
      scale: Vector3(5.0, 5.0, 5.0), // Ensure it's visible
      position:
          Vector3(position.x, position.y + 0.3, position.z), // Lift slightly
      rotation: rotation,
    );

    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    if (didAddWebNode == true) {
      webObjectNode = newNode;
      print("✅ Model loaded successfully at: $position");
    } else {
      print("❌ Failed to load model.");
    }
  }

  /// **Cleans up AR objects when the session ends**
  void dispose() {
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }

    if (arSessionManager != null) {
      arSessionManager.dispose();
    }
  }
}
