import 'package:ae_form/ae_form.dart';
import 'package:example/src/core/model/form/meta.dart';
import 'package:example/src/feature/register/logic/validators.dart';
import 'package:flutter/material.dart';

final class RegisterFormManager extends FormManager<RegisterFormNotifier, FormInputError> {
  @override
  void updateInputs(RegisterFormNotifier caller, List<FormInput<Object?>> inputs) {
    for (final input in inputs) {
      switch (input.key.validatorKey) {
        case 'username':
          caller.username = toInput<String>(input) ?? caller.username;
        case 'password':
          caller.password = toInput<String>(input) ?? caller.password;
        case 'confirmPassword':
          caller.confirmPassword = toInput<String>(input) ?? caller.confirmPassword;
      }
    }

    caller.mutate();
  }
}

class RegisterFormNotifier extends SafeChangeNotifier {
  RegisterFormNotifier() {
    username = FormInput<String>(InputKey('username'), value: '');
    password = FormInput<String>(InputKey('password'), value: '');
    confirmPassword = FormInput<String>(InputKey('confirmPassword'), value: '');
    formManager =
        RegisterFormManager()
          ..add(username.key, RegisterUsernameValidator())
          ..add(password.key, RegisterPasswordValidator())
          ..add(confirmPassword.key, RegisterConfirmPasswordValidator(originValueGetter: () => password.value))
          ..setCaller(() => this);
  }

  late final RegisterFormManager formManager;
  late FormInput<String> username;
  late FormInput<String> password;
  late FormInput<String> confirmPassword;

  Future<void> setUsername(String value) async {
    formManager.validate(username.set(value), trigger: ValidateTrigger.onChange);

    if (username.status.isFailure) {
      return;
    }

    await formManager.validateAsync(username, asyncValidator: () => _validateUserNameInApi(value));
  }

  Future<List<FormInputError>> _validateUserNameInApi(String value) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return username.value == 'user' ? [FormInputError.string('$value already exists')] : [];
  }

  Future<void> setPassword(String value) async {
    confirmPassword = confirmPassword.reset(status: const FormModelStatus.dirty());
    formManager.validate(password.set(value), trigger: ValidateTrigger.onChange);
  }

  Future<void> setConfirmPassword(String value) async {
    formManager.validate(confirmPassword.set(value), trigger: ValidateTrigger.onChange);
  }

  Future<bool> confirm() async {
    final rv = formManager.validateInputs([username, password, confirmPassword]);
    return rv;
  }
}

extension SafeChangeNotifierX on SafeChangeNotifier {
  void mutate() {
    notifyListeners();
  }
}

class SafeChangeNotifier extends ChangeNotifier {
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_isDisposed) return;
    super.notifyListeners();
  }
}
