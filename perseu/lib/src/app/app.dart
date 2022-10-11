import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/states/session.dart';
import 'package:perseu/src/viewModels/login_view_model.dart';
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
          create: (_) => locator<Session>(),
        ),
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
        initialRoute: Routes.bootstrap,
        routes: Routes.map,
      ),
    );
  }
}
