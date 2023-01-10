import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/profile_screen/profile_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/style.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:perseu/src/utils/validators.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const Key nameInputKey = Key('nameInput');
  static const Key birthdateInputKey = Key('birthdateInput');
  static const Key documentInputKey = Key('documentInput');
  static const Key emailInputKey = Key('emailInput');
  static const Key passwordInputKey = Key('passwordInput');
  static const Key confirmPasswordInputKey = Key('confirmPasswordInput');
  static const Key profileInputKey = Key('profileInput');
  static const Key crefInputKey = Key('crefInput');
  static const Key heightInputKey = Key('heightInput');
  static const Key weightInputKey = Key('weightInput');

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<ProfileViewModel>(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil'),
            ),
            body: FutureBuilder(
                future: model.getUserData(),
                builder: (context, AsyncSnapshot<Result> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const CircularLoading();

                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return FormProfile(model: model);
                      } else {
                        return PerseuMessage.defaultError();
                      }
                  }
                }),
          );
        },
      ),
    );
  }
}

class FormProfile extends StatefulWidget {
  const FormProfile({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ProfileViewModel model;

  @override
  State<FormProfile> createState() => _FormProfileState();
}

class _FormProfileState extends State<FormProfile> {
  final _nameController = TextEditingController();
  final _documentController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _emailController = TextEditingController();
  final _crefController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const defaultPadding = 12.0;

  @override
  void initState() {
    loadInitialValuesFromModel(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: defaultPadding, horizontal: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: ProfileScreen.nameInputKey,
                  controller: _nameController,
                  onChanged: (value) => widget.model.name = value.trim(),
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Nome',
                      labelText: 'Nome'),
                  validator: RequiredValidator(
                      errorText: 'O nome de usuário precisa ser informado'),
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                    key: ProfileScreen.emailInputKey,
                    controller: _emailController,
                    enabled: false,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'E-mail',
                        labelText: 'E-mail'),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'O E-mail precisa ser informado'),
                      EmailValidator(errorText: 'O E-mail precisa ser válido')
                    ])),
                const SizedBox(height: defaultPadding),
                TextFormField(
                    key: ProfileScreen.documentInputKey,
                    controller: _documentController,
                    onChanged: (value) => widget.model.document = value,
                    inputFormatters: [Formatters.cpf()],
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'CPF',
                        labelText: 'CPF'),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'O CPF precisa ser informado'),
                      CpfValidator(errorText: 'O CPF precisa ser válido')
                    ])),
                const SizedBox(height: defaultPadding),
                TextFormField(
                    key: ProfileScreen.birthdateInputKey,
                    controller: _birthdateController,
                    onChanged: (value) => widget.model.birthdate = value,
                    inputFormatters: [Formatters.date()],
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'Data de nascimento',
                        labelText: 'Data de nascimento'),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText:
                              'A data de nascimento precisa ser informada'),
                      DateValidator('dd/MM/yyyy',
                          errorText: 'A data precisa ser válida')
                    ])),
                const SizedBox(height: defaultPadding),
                Visibility(
                  visible: widget.model.isCoach,
                  child: TextFormField(
                    key: ProfileScreen.crefInputKey,
                    controller: _crefController,
                    onChanged: (value) => widget.model.cref = value.trim(),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'CREF',
                      hintText: 'CREF',
                    ),
                    validator: RequiredValidator(
                        errorText: 'O CREF precisa ser informado'),
                  ),
                ),
                Visibility(
                  visible: widget.model.isAthlete,
                  child: TextFormField(
                    key: ProfileScreen.heightInputKey,
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => widget.model.height = value,
                    inputFormatters: [Formatters.height()],
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Altura',
                      hintText: 'Altura 0.00 m',
                    ),
                    validator: RequiredValidator(
                        errorText: 'A Altura precisa ser informada'),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Visibility(
                  visible: widget.model.isAthlete,
                  child: TextFormField(
                    key: ProfileScreen.weightInputKey,
                    controller: _weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => _formatWeight(value, widget.model),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Peso',
                      hintText: 'Peso 00 Kg',
                    ),
                    validator: RequiredValidator(
                        errorText: 'O Peso precisa ser informado'),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                ElevatedButton(
                    onPressed: widget.model.isBusy
                        ? null
                        : () => _handleSave(context, widget.model),
                    child: const Text('Salvar')),
                const SizedBox(height: 8),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          side: BorderSide(color: Palette.accent, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    onPressed: widget.model.isBusy
                        ? null
                        : () => Navigator.of(context)
                            .pushNamed(Routes.changePassword),
                    child: const Text(
                      'Alterar senha',
                      style: TextStyle(color: Palette.accent),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  _formatWeight(String value, ProfileViewModel model) {
    if (value.length > 6) {
      _weightController.text = value.substring(0, 6);
      return;
    }

    String numberValue = '';
    if (value.length > 5) {
      numberValue = value.replaceAll(' Kg', '');
    }

    if (value.length < model.weight.length && value.length > 2) {
      setState(() {
        _weightController.text = '';
      });
    }

    if (value.length == 2) {
      setState(() {
        _weightController.text = '$value Kg';
      });
    }

    if (numberValue.length == 3) {
      setState(() {
        _weightController.text = '$numberValue Kg';
      });
    }

    model.weight = value;
    _weightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _weightController.text.length));
  }

  void _handleSave(BuildContext context, ProfileViewModel model) async {
    if (_formKey.currentState == null) return;
    if (_formKey.currentState!.validate()) {
      if (_hasBlancFields(model)) {
        UIHelper.showError(
            context, const Result.error(message: 'Preencha todos os campos'));
        return;
      }

      if (_profileHasModification(model)) {
        final result = await model.updateUser();
        if (result.success) {
          UIHelper.showSuccess(context, result);
          model.notifyListeners();
        } else {
          UIHelper.showError(context, result);
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => const NoModificationsDialog(),
        );
      }
    }
  }

  bool _profileHasModification(ProfileViewModel model) {
    if (_nameController.text != model.oldName) return true;

    if (_documentController.text != model.oldDocument) return true;

    if (_birthdateController.text != model.oldBirthdate) return true;

    if (model.isCoach && _crefController.text != model.oldCref) return true;

    if (model.isAthlete &&
        _heightController.text != model.oldHeight.toString()) {
      return true;
    }
    if (model.isAthlete &&
        _weightController.text != model.oldWeight.toString()) {
      return true;
    }

    return false;
  }

  bool _hasBlancFields(ProfileViewModel model) {
    if (_nameController.text.trim().isEmpty) return true;

    if (_documentController.text.trim().isEmpty) return true;

    if (_birthdateController.text.trim().isEmpty) return true;

    if (model.isCoach && _crefController.text.trim().isEmpty) return true;

    if (model.isAthlete && _heightController.text.trim().isEmpty) return true;

    if (model.isAthlete && _weightController.text.trim().isEmpty) return true;

    return false;
  }

  void loadInitialValuesFromModel(ProfileViewModel model) {
    _emailController.text = model.email ?? '';
    _nameController.text = model.name ?? '';
    _emailController.text = model.email ?? '';
    _documentController.text = model.document ?? '';
    _birthdateController.text = model.birthdate ?? '';
    _crefController.text = model.cref ?? '';
    _heightController.text = model.height;
    _weightController.text = model.weight;
  }
}

class NoModificationsDialog extends StatelessWidget {
  const NoModificationsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = locator<Style>();

    return AlertDialog(
      title: const Text('Sem modificações'),
      content: const Text(
          'Realize alguma alteração nos seus dados para então salvar'),
      actions: [
        ElevatedButton(
            style: style.buttonAlertPrimary,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'))
      ],
    );
  }
}
