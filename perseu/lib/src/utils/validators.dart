import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:form_field_validator/form_field_validator.dart';

export 'package:form_field_validator/form_field_validator.dart';

class CpfValidator extends TextFieldValidator {
  CpfValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    return CPFValidator.isValid(value);
  }
}

