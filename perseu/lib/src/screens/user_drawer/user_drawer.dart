import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/screens/user_drawer/user_drawer_viewmodel.dart';
import 'package:perseu/src/states/session.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<UserDrawerViewModel>(),
      child: Consumer<UserDrawerViewModel>(
        builder: (context, model, _) {
          return Drawer(
            backgroundColor: Palette.background,
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(color: Palette.primary),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.account_circle,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer<Session>(builder: (_, session, __) {
                                return Text(
                                  model.userName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                );
                              }),
                              Text(
                                model.userEmail,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                ListTile(
                  leading: const Icon(Icons.person, color: Palette.primary),
                  title: const Text('Perfil'),
                  onTap: () => Navigator.of(context).pushNamed(Routes.profile),
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_back, color: Palette.primary),
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

  void _handleLogout(BuildContext context) async {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.login, (route) => false);
    await Future.delayed(const Duration(milliseconds: 800));
    locator<Session>().reset();
  }
}
