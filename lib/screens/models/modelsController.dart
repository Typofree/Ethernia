import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';

class ModelsController {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? localObjectNode;
  ARNode? webObjectNode;

  void initializeAR(
      ARSessionManager sessionManager,
      ARObjectManager objectManager,
      ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arObjectManager.onInitialize();
  }

  Future<void> loadLocalModel(String modelUri) async {
    if (localObjectNode != null) {
      arObjectManager.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: modelUri,
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(0.0, 0.0, 0.0, 1.0),
      );

      bool? didAddLocalNode = await arObjectManager.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }

  Future<void> loadWebModel(String modelUri) async {
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
        type: NodeType.webGLB,
        uri: modelUri,
        scale: Vector3(0.2, 0.2, 0.2),
      );

      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }

  void dispose() {
    arSessionManager.dispose();
  }
}
