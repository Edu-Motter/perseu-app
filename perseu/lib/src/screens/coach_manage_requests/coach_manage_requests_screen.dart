import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/components/dialogs/athlete_information_dialog.dart';
import 'package:perseu/src/models/dtos/invite_dto.dart';
import 'package:perseu/src/screens/coach_home/coach_home_screen.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_viewmodel.dart';
import 'package:perseu/src/utils/palette.dart';
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
                      color: Palette.primary,
                      elevation: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TeamInfo(
                              futureTeamInfo: model.getTeamInfo(),
                              style: const TextStyle(color: Palette.background),
                              showCode: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Palette.primary,
                  ),
                  const Flexible(
                    child: RequestList(),
                  ),
                ])),
          );
        },
      ),
    );
  }
}

class RequestList extends StatefulWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    final model =
        Provider.of<CoachManageRequestsViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
      child: FutureBuilder(
        future: model.getRequests(model.team.id),
        builder: (context, snapshot) {
          if (model.isBusy) {
            return const Center(child: SizedBox.shrink());
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              if (snapshot.hasData) {
                Result result = snapshot.data as Result;
                List<InviteDTO> inviteRequests = result.data;
                if (inviteRequests.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: inviteRequests.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Palette.background,
                        child: ListTile(
                          onLongPress: () => _handleInformationDialog(
                            context,
                            inviteRequests[index].athlete.id,
                          ),
                          title: Text(
                            inviteRequests[index].athlete.name,
                            style: const TextStyle(color: Palette.primary),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _handleInformationDialog(
                                  context,
                                  inviteRequests[index].athlete.id,
                                ),
                                icon: const Icon(Icons.info_outlined),
                                color: Palette.primary,
                              ),
                              IconButton(
                                  onPressed: () {
                                    _handleRefuseRequest(
                                        inviteRequests[index].athlete.id,
                                        model,
                                        context);
                                  },
                                  icon: const Icon(Icons.clear),
                                  color: Palette.primary),
                              IconButton(
                                  onPressed: () {
                                    _handleAcceptRequest(
                                        inviteRequests[index].athlete.id,
                                        model,
                                        context);
                                  },
                                  icon: const Icon(Icons.check),
                                  color: Palette.primary),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text('Não existem solicitações pendentes'));
                }
              } else {
                return const DefaultError();
              }
            default:
              return const DefaultError();
          }
        },
      ),
    );
  }

  void _handleInformationDialog(BuildContext context, int athleteId) {
    showDialog(
      context: context,
      builder: (context) => AthleteInformationDialog(
        athleteId: athleteId,
      ),
    );
  }

  void _handleAcceptRequest(int athleteId, CoachManageRequestsViewModel model,
      BuildContext context) async {
    Result result = await model.acceptRequest(athleteId);
    if (result.success) {
      UIHelper.showFlashNotification(context, result.message!);
    } else {
      UIHelper.showError(context, result);
    }

    setState(() {});
  }

  void _handleRefuseRequest(int athleteId, CoachManageRequestsViewModel model,
      BuildContext context) async {
    Result result = await model.declineRequest(athleteId);
    if (result.success) {
      UIHelper.showFlashNotification(context, result.message!);
    } else {
      UIHelper.showError(context, result);
    }

    setState(() {});
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
