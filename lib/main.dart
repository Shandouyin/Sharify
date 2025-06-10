import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/services/audio_player_service.dart';

void main() {
  runApp(const MyApp());
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
  
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AudioPlayerService(),
      child: MaterialApp(
        title: 'Sharify',
        debugShowCheckedModeBanner: false,
        scrollBehavior: CustomScrollBehavior(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.main,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}