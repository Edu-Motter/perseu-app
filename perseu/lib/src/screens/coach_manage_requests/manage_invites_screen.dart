import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/models/requests/invite_request.dart';
import 'package:perseu/src/models/requests/team_request.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_viewmodel.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class CoachManageRequestsScreen extends StatefulWidget {
  const CoachManageRequestsScreen({Key? key}) : super(key: key);

  @override
  State<CoachManageRequestsScreen> createState() =>
      _CoachManageRequestsScreenState();
}

class _CoachManageRequestsScreenState extends State<CoachManageRequestsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CoachManageRequestsViewModel>(
      create: (_) => locator<CoachManageRequestsViewModel>(),
      child: Consumer<CoachManageRequestsViewModel>(
        builder: (__, model, _) {
          TeamRequest team = model.session.user!.coach!.team!;
          return ModalProgressHUD(
            inAsyncCall: model.isBusy,
            child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: const Text('Solicitações'),
                ),
                body: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.teal,
                      elevation: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Equipe ${team.name}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 16),
                            Text('Código de acesso: ${team.code}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, right: 16, left: 16),
                      child: FutureBuilder(
                        future: model.getRequests(model.session.user!.coach!.team!.id),
                        builder: (context, snapshot) {
                          if (model.isBusy) {
                            return const Center(child: SizedBox.shrink());
                          }

                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            case ConnectionState.active:
                              return const Center(
                                  child: CircularProgressIndicator());

                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                Result result = snapshot.data as Result;
                                List<InviteRequest> inviteRequests =
                                    result.data;
                                if (inviteRequests.isNotEmpty) {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: inviteRequests.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                              inviteRequests[index].athlete.name),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    _handleRefuseRequest(
                                                        inviteRequests[index]
                                                            .id,
                                                        model,
                                                        context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.clear)),
                                              IconButton(
                                                  onPressed: () {
                                                    _handleAcceptRequest(
                                                        inviteRequests[index]
                                                            .id,
                                                        model,
                                                        context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.check)),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                      child: Text(
                                          'Não existem solicitações pendentes'));
                                }
                              } else {
                                return const DefaultError();
                              }
                            default:
                              return const DefaultError();
                          }
                        },
                      ),
                    ),
                  ),
                ])),
          );
        },
      ),
    );
  }

  void _handleAcceptRequest(int requestId, CoachManageRequestsViewModel model,
      BuildContext context) async {
    Result result = await model.acceptRequest(requestId);
    if (result.success) {
      UIHelper.showSuccess(_scaffoldKey.currentContext!, result);
    } else {
      UIHelper.showError(_scaffoldKey.currentContext!, result);
    }
  }

  void _handleRefuseRequest(int requestId, CoachManageRequestsViewModel model,
      BuildContext context) async {
    Result result = await model.refuseRequest(requestId);
    if (result.success) {
      UIHelper.showFlashNotification(
          _scaffoldKey.currentContext!, result.message!);
    } else {
      UIHelper.showError(_scaffoldKey.currentContext!, result);
    }
  }
}

class DefaultError extends StatelessWidget {
  const DefaultError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.cancel, size: 36),
        SizedBox(height: 16),
        Text('Erro desconhecido')
      ],
    );
  }
}
