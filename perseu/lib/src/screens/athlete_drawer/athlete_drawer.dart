import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/screens/athlete_drawer/athlete_drawer_viewmodel.dart';
import 'package:perseu/src/states/session.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';

class AthleteDrawer extends StatelessWidget {
  const AthleteDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AthleteDrawerViewModel>(),
      child: Consumer<AthleteDrawerViewModel>(
        builder: (context, model, _) {
          UserRequest user = model.session.user!;
          return Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.teal
                  ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.account_circle, size: 48, color: Colors.white,),
                        ),
                        Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(user.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 24, color: Colors.white),),
                            Text(user.email,  overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, color: Colors.white),),
                          ],
                        ))
                      ],
                    )),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Perfil'),
                  onTap: () => Navigator.of(context).pushNamed(Routes.profile),
                ),
                ListTile(
                   leading: const Icon(Icons.arrow_back),
                  title: const Text('Sair'),
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleLogout(BuildContext context){
    locator<Session>().reset();
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }
}
