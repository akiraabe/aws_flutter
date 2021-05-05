import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';
import 'gallery_page.dart';

class CameraFlow extends StatefulWidget {
  // 1 CameraFlow は、ユーザーがログアウトし、
  // main.dart で状態を元どおりに更新したときにトリガーされる必要があります。
  // この機能は、GalleryPage を作成した後すぐに実装します。
  final VoidCallback shouldLogOut;

  CameraFlow({Key key, this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  CameraDescription _camera;

  // 2 このフラグは、カメラをいつ表示するかまたはしないかを決定する状態として機能します。
  bool _shouldShowCamera = false;

  // 3 _shouldShowCamera が更新されたときに Navigator が更新されるようにするために、
  // computed プロパティを使って、現在の状態に基づく適切なナビゲーションスタックを返します。
  // ここでは、Placeholder ページを使用します。
  List<MaterialPage> get _pages {
    return [
      // Show Gallery Page
      MaterialPage(
          child: GalleryPage(
              shouldLogOut: widget.shouldLogOut,
              shouldShowCamera: () => _toggleCameraOpen(true))),
      // Show Camera Page
      if (_shouldShowCamera)
        MaterialPage(
            child: CameraPage(
                camera: _camera,
                didProvideImagePath: (imagePath) {
                  this._toggleCameraOpen(false);
                }))
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 4 _MyAppState と同様、セッションの所定の時点でどのページを表示するかを決定するときは、
    // Navigator ウィジェットを使用します。
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // 5 このメソッドにより、呼び出しサイトに setState() を実装せずに、
  // カメラを表示するか否かを切り替えることができます。
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      this._camera = firstCamera;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
  }
}
