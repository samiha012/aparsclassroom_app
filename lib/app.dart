import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/theme_config.dart';
import 'core/routes/app_router.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'injection_container.dart' as di;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
      child: MaterialApp(
        title: 'Apars Classroom',
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.splash,
      ),
    );
  }
}