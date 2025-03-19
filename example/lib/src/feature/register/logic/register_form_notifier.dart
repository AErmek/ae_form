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
    username = username.set(value).validateSet(_usernameValidator, trigger: ValidateTrigger.reactive);

    notifyListeners();

    print(username.status);

    if (username.status.isFailure) {
      return;
    }

    username = username.reset(status: const FormModelStatus.dirtyEditing());

    notifyListeners();

    await Future.delayed(Duration(milliseconds: 300));

    username = username.setResult(
      username.value == 'user' ? FormModelError.string('$value already exists') : null,
      elseStatus: FormModelStatus.dirty(),
    );

    notifyListeners();
  }

  Future<void> setPassword(String value) async {
    password = password.set(value).validateSet(_passwordValidator, trigger: ValidateTrigger.reactive);
    confirmPassword = confirmPassword.reset(status: const FormModelStatus.dirty());

    notifyListeners();
  }

  Future<void> setConfirmPassword(String value) async {
    confirmPassword = confirmPassword
        .set(value)
        .validateSet(_confirmPasswordValidator, trigger: ValidateTrigger.reactive);
    notifyListeners();
  }

  Future<void> confirm() async {
    username = username.validateSet(_usernameValidator, trigger: ValidateTrigger.submit);
    password = password.validateSet(_passwordValidator, trigger: ValidateTrigger.submit);
    confirmPassword = confirmPassword.validateSet(_confirmPasswordValidator, trigger: ValidateTrigger.submit);
    notifyListeners();
  }
}
