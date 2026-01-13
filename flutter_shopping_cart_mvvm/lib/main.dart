import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/routing/app_router.dart';
import 'package:flutter_shopping_cart_mvvm/routing/routes.dart';
import 'package:provider/provider.dart';

import 'config/app_module.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: AppModule.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.catalog,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}