import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewModel {
  int? index;
  String title;
  double width;
  double height;
  HeadlessInAppWebView? headlessWebView;
  InAppWebViewController? webViewController;
  int progress;
  WebUri? url;
  bool convertFlag;
  bool isWebview;

  WebViewModel({
    this.index,
    required this.title,
    this.width = 0,
    this.height = 0,
    this.headlessWebView,
    this.webViewController,
    this.progress = 0,
    this.url,
    this.convertFlag = false,
    this.isWebview = true,
  });
}

class MultipleWebviewPage extends StatefulWidget {
  const MultipleWebviewPage({super.key});

  @override
  State<MultipleWebviewPage> createState() => _MultipleWebviewPageState();
}

class _MultipleWebviewPageState extends State<MultipleWebviewPage> {
  final List<WebViewModel> _tabsList = [
    WebViewModel(
      title: '套餐内容',
      url: WebUri("https://cdn.xxxxxxx.com/html/20230801/4b6e0db8-0c4f-4a85-a664-997a4e3ed288.html"),
      height: 0,
      progress: 0,
      isWebview: true,
      headlessWebView: null,
      webViewController: null,
    ),
    WebViewModel(
      title: '商品须知',
      url: WebUri("https://cdn.xxxxxxx.com/html/20230802/ddbc1705-ca01-454c-97b6-b20a9c16e30d.html"),
      height: 0,
      progress: 0,
      isWebview: true,
      headlessWebView: null,
      webViewController: null,
    ),
    WebViewModel(
      title: '商品详情',
      url: WebUri("https://cdn.xxxxxxx.com/html/20230802/c60c5bf5-2e14-4a16-b572-d2bb2e7efaaf.html"),
      height: 0,
      progress: 0,
      isWebview: true,
      headlessWebView: null,
      webViewController: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    disposeWebview();
    super.dispose();
  }

  init() async {
    initWebview(_tabsList[0]);
    initWebview(_tabsList[1]);
    initWebview(_tabsList[2]);
  }

  initWebview(WebViewModel webview) {
    webview.headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: webview.url),
      onWebViewCreated: (controller) {
        webview.webViewController = controller;
      },
      onProgressChanged: (controller, progress) {},
      onLoadStop: (controller, url) async {
        await controller.injectJavascriptFileFromAsset(assetFilePath: "assets/js/detail_html.js");

        var bodyWidth = await controller.evaluateJavascript(source: "document.body.offsetHeight");
        var bodyHeight = await controller.evaluateJavascript(source: "document.body.offsetHeight");

        double domWidth = bodyWidth.runtimeType == double ? bodyWidth : (bodyWidth as int).toDouble();
        double domHeight = bodyHeight.runtimeType == double ? bodyHeight : (bodyHeight as int).toDouble();

        webview.width = domWidth;
        webview.height = domHeight;
        webview.convertFlag = true;

        print('============${webview.height}============');

        setState(() {});
      },
    );
    // 开始加载webview
    if (webview.headlessWebView != null && !webview.headlessWebView!.isRunning()) {
      webview.headlessWebView!.run();
    }
  }

  disposeWebview() async {
    for (var i = 0; i < _tabsList.length; i++) {
      if (_tabsList[i].isWebview) {
        await _tabsList[i].headlessWebView?.dispose();
        _tabsList[i].webViewController?.dispose();
        _tabsList[i].headlessWebView = null;
        _tabsList[i].url = null;
        _tabsList[i].convertFlag = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HeadlessInAppWebView to InAppWebView",
          textScaleFactor: .8,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _tabsList.map((item) {
            return item.convertFlag
                ? SizedBox(
                    height: item.height,
                    child: InAppWebView(
                      headlessWebView: item.headlessWebView,
                      onWebViewCreated: (controller) async {
                        item.headlessWebView = null;
                      },
                    ),
                  )
                : SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: (item.progress / 100).toDouble(),
                      ),
                    ),
                  );
          }).toList(),
        ),
      ),
    );
  }
}
