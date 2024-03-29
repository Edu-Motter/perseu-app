import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/components/dialogs/athlete_information_dialog.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/invite_dto.dart';
import 'package:perseu/src/screens/coach_home/coach_home_screen.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_viewmodel.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
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
              backgroundColor: Palette.background,
              key: _scaffoldKey,
              appBar: AppBar(
                title: const Text('Solicitações'),
              ),
              body: Column(
                children: [
                  PerseuCard(
                    contentPadding: const EdgeInsets.all(16),
                    child: TeamInfo(
                      futureTeamInfo: model.getTeamInfo(),
                      style: const TextStyle(color: Palette.primary),
                      showCode: true,
                    ),
                  ),
                  const AccentDivider(accentColor: Palette.primary),
                  Flexible(
                    child: RequestList(model: model),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RequestList extends StatefulWidget {
  const RequestList({Key? key, required this.model}) : super(key: key);

  final CoachManageRequestsViewModel model;

  static const buttonColor = Palette.secondary;
  static const primaryButtonColor = Palette.accent;
  static const iconSize = 28.0;

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    return FutureBuilder(
      future: model.getRequests(model.team.id),
      builder: (context, AsyncSnapshot<Result<List<InviteDTO>>> snapshot) {
        if (model.isBusy) {
          return const Center(child: SizedBox.shrink());
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
          case ConnectionState.active:
            return const CircularLoading();

          case ConnectionState.done:
            if (snapshot.hasData) {
              final result = snapshot.data!;
              if (result.success) {
                List<InviteDTO> inviteRequests = result.data!;
                if (inviteRequests.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: inviteRequests.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(top: 8),
                          color: Colors.white,
                          child: ListTile(
                            onTap: () => _handleInformationDialog(
                              context,
                              inviteRequests[index].athlete.id,
                            ),
                            title: Text(
                              inviteRequests[index].athlete.name,
                              style: const TextStyle(
                                  color: Palette.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _handleRefuseRequest(
                                        inviteRequests[index], model, context);
                                  },
                                  icon: const Icon(Icons.clear),
                                  color: RequestList.buttonColor,
                                  iconSize: RequestList.iconSize,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _handleAcceptRequest(
                                        inviteRequests[index].athlete.id,
                                        model,
                                        context);
                                  },
                                  icon: const Icon(Icons.check),
                                  color: RequestList.primaryButtonColor,
                                  iconSize: RequestList.iconSize,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const PerseuMessage(
                    message: 'Nenhuma solicitação pendente',
                    icon: Icons.check_circle,
                  );
                }
              } else {
                return PerseuMessage.result(result);
              }
            }
            return PerseuMessage.defaultError();
        }
      },
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
      UIHelper.showSuccess(context, result);
    } else {
      UIHelper.showError(context, result);
    }

    setState(() {});
  }

  void _handleRefuseRequest(
    InviteDTO request,
    CoachManageRequestsViewModel model,
    BuildContext context,
  ) async {
    UIHelper.showBoolDialog(
      context: context,
      title: 'Removendo solicitação',
      message:
          'Deseja realmente remover a solicitação do(a) ${request.athlete.name}',
      onNoPressed: () => Navigator.pop(context),
      onYesPressed: () async {
        Result result = await model.declineRequest(request.athlete.id);
        if (result.success) {
          Navigator.pop(context);
          UIHelper.showSuccess(context, result);
        } else {
          UIHelper.showError(context, result);
        }
        model.notifyListeners();
      },
    );
  }
}

class PerseuMessage extends StatelessWidget {
  const PerseuMessage({
    Key? key,
    required this.message,
    this.icon = Icons.mood_bad,
    this.primaryColor = Palette.primary,
    this.withoutIcon = false,
  }) : super(key: key);

  final Color primaryColor;
  final String message;
  final IconData icon;
  final bool withoutIcon;

  factory PerseuMessage.defaultError() {
    return const PerseuMessage(
      message: 'Erro, tente novamente',
      icon: Icons.cancel,
    );
  }

  factory PerseuMessage.result(Result result, {IconData? icon}) {
    return PerseuMessage(
      message: result.message ?? 'Erro, tente novamente',
      icon: icon ?? Icons.cancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            border: Border.all(color: Colors.transparent, width: 3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!withoutIcon)
              Column(
                children: [
                  Icon(icon, size: 32, color: primaryColor),
                  const SizedBox(height: 16),
                ],
              ),
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PerseuCard extends StatelessWidget {
  const PerseuCard({
    Key? key,
    required this.child,
    this.insetPadding = const EdgeInsets.all(16),
    this.contentPadding = const EdgeInsets.all(8),
  }) : super(key: key);

  final Widget child;
  final EdgeInsets insetPadding;
  final EdgeInsets contentPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: insetPadding,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Palette.accent,
                width: 5,
              ),
            ),
          ),
          child: Padding(
            padding: contentPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
