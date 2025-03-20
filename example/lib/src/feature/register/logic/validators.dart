import 'package:ae_form/ae_form.dart';
import 'package:example/src/core/model/form/meta.dart';

final class RegisterUsernameValidator extends FormModelValidator<String, FormInputError> {
  @override
  List<IFormModelValidatorUnit<String, FormInputError>> get units => [RequiredValidatorUnit()];
}

final class RegisterPasswordValidator extends FormModelValidator<String, FormInputError> {
  @override
  List<IFormModelValidatorUnit<String, FormInputError>> get units => [RequiredValidatorUnit()];
}

final class RegisterConfirmPasswordValidator extends FormModelValidator<String, FormInputError> {
  RegisterConfirmPasswordValidator({required this.originValueGetter});
  final String Function() originValueGetter;

  @override
  List<IFormModelValidatorUnit<String, FormInputError>> get units => [
    RequiredValidatorUnit(),
    SameValueValidatorUnit(originValueGetter: originValueGetter),
  ];
}

final class RequiredValidatorUnit implements IFormModelValidatorUnit<String, FormInputError> {
  RequiredValidatorUnit({this.isCritical = true, this.level = ValidationLevel.onAny});

  @override
  final bool isCritical;

  @override
  final ValidationLevel level;

  @override
  FormInputError? validate(String value) => value.isEmpty ? const FormInputError.localized(key: 'required') : null;
}

final class SameValueValidatorUnit implements IFormModelValidatorUnit<String, FormInputError> {
  SameValueValidatorUnit({
    required this.originValueGetter,
    this.isCritical = true,
    this.level = ValidationLevel.onSubmit,
  });

  final String Function() originValueGetter;

  @override
  final bool isCritical;

  @override
  final ValidationLevel level;

  @override
  FormInputError? validate(String value) =>
      value == originValueGetter.call() ? null : const FormInputError.localized(key: 'not_same_value');
}
