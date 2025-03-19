import 'package:ae_form/ae_form.dart';
import 'package:example/src/core/model/form/meta.dart';
import 'package:example/src/feature/register/logic/validators.dart';
import 'package:flutter/material.dart';

class RegisterFormNotifier extends ChangeNotifier {
  RegisterFormNotifier() {
    username = FormInput<String>('');
    password = FormInput<String>('');
    confirmPassword = FormInput<String>('');
    _confirmPasswordValidator = RegisterConfirmPasswordValidatorSet(originValueGetter: () => password.value);
  }

  final _usernameValidator = RegisterUsernameValidatorSet();
  final _passwordValidator = RegisterPasswordValidatorSet();
  late final RegisterConfirmPasswordValidatorSet _confirmPasswordValidator;

  late FormInput<String> username;
  late FormInput<String> password;
  late FormInput<String> confirmPassword;

  Future<void> setUsername(String value) async {
    username = username.set(value).validate(_usernameValidator, trigger: ValidateTrigger.onChange);

    notifyListeners();

    if (username.status.isFailure) {
      return;
    }

    username = username.reset(status: const FormModelStatus.dirtyEditing());

    notifyListeners();

    final rv = await _validateUserNameInApi(value);

    username = username.validateResult(rv, okStatus: FormModelStatus.dirty());

    notifyListeners();
  }

  Future<List<FormModelError>> _validateUserNameInApi(String value) async {
    await Future.delayed(Duration(milliseconds: 300));
    return username.value == 'user' ? [FormModelError.string('$value already exists')] : [];
  }

  Future<void> setPassword(String value) async {
    password = password.set(value).validate(_passwordValidator, trigger: ValidateTrigger.onChange);
    confirmPassword = confirmPassword.reset(status: const FormModelStatus.dirty());

    notifyListeners();
  }

  Future<void> setConfirmPassword(String value) async {
    confirmPassword = confirmPassword.set(value).validate(_confirmPasswordValidator, trigger: ValidateTrigger.onChange);
    notifyListeners();
  }

  Future<void> confirm() async {
    username = username.validate(_usernameValidator, trigger: ValidateTrigger.onSubmit);
    password = password.validate(_passwordValidator, trigger: ValidateTrigger.onSubmit);
    confirmPassword = confirmPassword.validate(_confirmPasswordValidator, trigger: ValidateTrigger.onSubmit);
    notifyListeners();
  }
}
