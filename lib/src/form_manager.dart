import 'package:ae_form/ae_form.dart';
import 'package:flutter/widgets.dart';

abstract base class FormManager<TCaller extends Object, E extends Object> {
  final Map<String, FormModelValidator<Object?, E>> validators = {};

  void add(InputKey key, FormModelValidator<Object?, E> validators) => this.validators[key.validatorKey] = validators;

  @protected
  TCaller Function()? getCaller;

  @protected
  void updateInputs(TCaller caller, List<FormModel<Object?, E>> inputs);

  // ignore: use_setters_to_change_properties
  void setCaller(TCaller Function() delegate) => getCaller = delegate;

  bool validateInputs(List<FormModel<Object?, E>> inputs, {ValidateTrigger trigger = ValidateTrigger.onSubmit}) {
    var isValid = true;
    final newInputs = <FormModel<Object?, E>>[];
    for (final e in inputs) {
      final validator = validators[e.key.validatorKey];

      if (validator == null) {
        continue;
      }

      final newInput = e.reset(status: FormModelStatus.dirty()).validate(validator, trigger: trigger);

      newInputs.add(newInput);

      if (isValid && newInput.status.isFailure) {
        isValid = false;
      }
    }

    final caller = getCaller?.call();
    if (caller != null) {
      updateInputs(caller, newInputs);
    }

    return isValid;
  }

  FormModel<T, E>? toInput<T extends Object?>(FormModel<Object?, E> input) => input is FormModel<T, E> ? input : null;

  Future<void> validateAsync(
    FormModel<Object?, E> input, {
    required Future<List<E>> Function() asyncValidator,
  }) async {
    final caller = getCaller?.call();

    if (caller == null) return;

    updateInputs(caller, [input.reset(status: const FormModelStatus.dirtyEditing())]);

    final errors = await asyncValidator();

    updateInputs(caller, [input.validateResult(errors, okStatus: const FormModelStatus.dirty())]);
  }

  void validate(
    FormModel<Object?, E> input, {
    ValidateTrigger trigger = ValidateTrigger.onSubmit,
    FormModelStatus<E>? okStatus,
  }) {
    final caller = getCaller?.call();

    if (caller == null) return;

    final validator = validators[input.key.validatorKey];

    if (validator == null) return;

    final newInput = input.validate(validator, trigger: trigger);

    updateInputs(caller, [newInput]);
  }
}
