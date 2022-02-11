import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/viewModels/login_view_model.dart';
import 'package:perseu/src/viewModels/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class PerseuApp extends StatelessWidget {
  const PerseuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SignUpViewModel(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(Size.infinite.width, 48))),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Perseu',
        initialRoute: Routes.login,
        routes: Routes.map,
      ),
    );
  }
}
