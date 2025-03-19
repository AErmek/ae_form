import 'package:ae_form/ae_form.dart';
import 'package:example/src/core/model/form/meta.dart';

final class RegisterUsernameValidatorSet extends FormModelValidatorSet<String, FormInputError> {
  @override
  List<IFormModelValidator<String, FormInputError>> get validators => [RequiredValidator()];
}

final class RegisterPasswordValidatorSet extends FormModelValidatorSet<String, FormInputError> {
  @override
  List<IFormModelValidator<String, FormInputError>> get validators => [RequiredValidator()];
}

final class RegisterConfirmPasswordValidatorSet extends FormModelValidatorSet<String, FormInputError> {
  RegisterConfirmPasswordValidatorSet({required this.originValueGetter});
  final String Function() originValueGetter;

  @override
  List<IFormModelValidator<String, FormInputError>> get validators => [
    RequiredValidator(),
    SameValueValidator(originValueGetter: originValueGetter),
  ];
}

final class RequiredValidator implements IFormModelValidator<String, FormInputError> {
  RequiredValidator({this.isCritical = true, this.level = ValidationLevel.onAny});

  @override
  final bool isCritical;

  @override
  final ValidationLevel level;

  @override
  FormInputError? validate(String value) => value.isEmpty ? const FormInputError.localized(key: 'required') : null;
}

final class SameValueValidator implements IFormModelValidator<String, FormInputError> {
  SameValueValidator({required this.originValueGetter, this.isCritical = true, this.level = ValidationLevel.onSubmit});

  final String Function() originValueGetter;

  @override
  final bool isCritical;

  @override
  final ValidationLevel level;

  @override
  FormInputError? validate(String value) =>
      value == originValueGetter.call() ? null : const FormInputError.localized(key: 'not_same_value');
}
