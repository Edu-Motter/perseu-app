import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/group_dto.dart';
import 'package:perseu/src/models/dtos/group_name_dto.dart';
import 'package:perseu/src/screens/group_details/group_details_screen.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/screens/manage_groups/manage_groups_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/style.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

class ManageGroupsScreen extends StatelessWidget {
  const ManageGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManageGroupsViewModel>(
      create: (_) => locator<ManageGroupsViewModel>(),
      child: Consumer<ManageGroupsViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: const Text('Lista de grupos'),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Palette.accent,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => GroupNameDialog(model: model),
              ),
              child: const Icon(Icons.add),
            ),
            body: FutureBuilder(
              future: model.getGroups(),
              builder: (
                context,
                AsyncSnapshot<Result<List<GroupNameDTO>>> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularLoading();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final result = snapshot.data!;
                      if (result.success && result.data!.isNotEmpty) {
                        return GroupsList(groups: result.data!);
                      }
                      if (result.success && result.data!.isEmpty) {
                        return const CenterError(
                            message: 'Não possui grupos ainda');
                      }
                    }
                    return const CenterError(message: 'Erro desconhecido');
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class GroupsList extends StatelessWidget {
  const GroupsList({
    Key? key,
    required this.groups,
  }) : super(key: key);

  final List<GroupNameDTO> groups;

  static const Color buttonColor = Palette.secondary;
  static const Color textColor = Palette.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTitle(text: 'Quantidade de grupos: ${groups.length}'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final GroupNameDTO group = groups[index];
                return Card(
                  margin: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    title: Text(
                      group.name,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: buttonColor,
                      size: 28,
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return GroupDetailsScreen(
                          groupId: group.id,
                          groupName: group.name,
                        );
                      },
                    )),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class GroupNameDialog extends StatefulWidget {
  const GroupNameDialog({Key? key, required this.model}) : super(key: key);

  final ManageGroupsViewModel model;

  @override
  State<GroupNameDialog> createState() => _GroupNameDialogState();
}

class _GroupNameDialogState extends State<GroupNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool get valid => _nameController.text.trim().length > 2;
  bool confirmed = false;

  @override
  Widget build(BuildContext context) {
    final style = locator<Style>();

    return AlertDialog(
      title: Text(
        confirmed ? 'Grupo ${_nameController.text}' : 'Nome do grupo',
        style: const TextStyle(
            color: Palette.primary, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      content: confirmed
          ? FutureBuilder(
              future: widget.model.getAthletes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularLoading();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      Result result = snapshot.data as Result;
                      if (result.success) {
                        final List<AthleteToGroup> athletes =
                            widget.model.athletes;
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Divider(),
                              const ListTitle(
                                text: 'Atletas disponíveis',
                                dividerPadding: 0,
                                topPadding: 4,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: athletes.length,
                                  itemBuilder: (_, int index) {
                                    return AthleteCheckboxTile(
                                      athlete: athletes[index],
                                    );
                                  },
                                ),
                              ),
                            ]);
                      }
                      return CenterError(
                          message:
                              result.message ?? 'Erro ao carregar atletas');
                    }
                    return const Center(
                      child: Text('Consulta aos atletas não obteve retorno'),
                    );
                }
              },
            )
          : TextField(
              style: const TextStyle(color: Palette.primary),
              controller: _nameController,
              onChanged: (_) => setState(() {}),
            ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          style: style.buttonAlertSecondary,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: style.buttonAlertPrimary,
          onPressed: confirmed
              ? _handleGroupCreation(widget.model, context)
              : _handleGroupName(valid: valid),
          child: Text(confirmed ? 'Criar' : 'Continuar'),
        ),
      ],
    );
  }

  VoidCallback? _handleGroupCreation(
      ManageGroupsViewModel model, BuildContext context) {
    return () async {
      if (model.athletes.where((a) => a.checked == true).length < 2) {
        UIHelper.showError(
            context, const Result.error(message: 'Selecione 2 atletas'));
        return;
      }

      Result result = await model.createGroup(_nameController.text);
      if (result.error) return UIHelper.showError(context, result);

      final group = GroupDTO.fromJson(result.data);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GroupDetailsScreen(
            groupId: group.id,
            groupName: group.name,
          ),
        ),
      );
      return UIHelper.showSuccess(context, result);
    };
  }

  VoidCallback? _handleGroupName({required bool valid}) {
    if (!valid) return null;

    return () {
      setState(() {
        confirmed = true;
      });
    };
  }
}

class AthleteCheckboxTile extends StatefulWidget {
  const AthleteCheckboxTile({Key? key, required this.athlete})
      : super(key: key);

  final AthleteToGroup athlete;

  @override
  State<AthleteCheckboxTile> createState() => _AthleteCheckboxTileState();
}

class _AthleteCheckboxTileState extends State<AthleteCheckboxTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: Palette.background,
      activeColor: Palette.primary,
      selectedTileColor: Palette.accent,
      title: Text(
        widget.athlete.name,
        style: const TextStyle(color: Palette.primary),
      ),
      value: widget.athlete.checked,
      onChanged: (bool? checkboxState) {
        setState(() {
          widget.athlete.checked = checkboxState ?? true;
        });
      },
    );
  }
}
