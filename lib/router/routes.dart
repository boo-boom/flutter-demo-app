import 'package:flutter/cupertino.dart';
import 'package:flutter_demo_app/page/drop_down_menu_page.dart';
import 'package:flutter_demo_app/page/home_page.dart';
import 'package:flutter_demo_app/page/multiple_webview_page.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const CupertinoPage(
          child: HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/dropDownMenu',
      name: 'dropDownMenu',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const CupertinoPage(
          child: DropDownMenuPage(),
        );
      },
    ),
    GoRoute(
      path: '/multipleWebview',
      name: 'multipleWebview',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const CupertinoPage(
          child: MultipleWebviewPage(),
        );
      },
    ),
  ],
);
