import 'package:ae_form/ae_form.dart';
import 'package:flutter/foundation.dart';

abstract interface class IFormModel<T extends Object?, E extends Object> {
  T get value;

  FormModelStatus<E> get status;

  IFormModel<T, E> set(T value, {FormModelStatus<E> status = const FormModelStatus.dirty()});

  IFormModel<T, E> setFailure(E error);

  IFormModel<T, E> reset({ValueGetter<T>? value, FormModelStatus<E> status = const FormModelStatus.pure()});
}

class FormModel<T extends Object?, E extends Object> implements IFormModel<T, E> {
  @override
  final T value;

  @override
  final FormModelStatus<E> status;

  const FormModel(T initialValue, {this.status = const FormModelStatus.pure()}) : value = initialValue;

  @override
  FormModel<T, E> reset({ValueGetter<T>? value, FormModelStatus<E> status = const FormModelStatus.pure()}) =>
      copyWith(status: status, value: value);

  @override
  FormModel<T, E> set(T value, {FormModelStatus<E> status = const FormModelStatus.dirty()}) =>
      copyWith(status: status, value: () => value);

  @override
  FormModel<T, E> setFailure(E error) => copyWith(status: FormModelStatus<E>.failure(error));

  @protected
  FormModel<T, E> copyWith({ValueGetter<T>? value, FormModelStatus<E>? status}) =>
      FormModel(value != null ? value() : this.value, status: status ?? this.status);

  @override
  int get hashCode => Object.hash(value, status);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FormModel<T, E> &&
            other.value == value &&
            other.status == status);
  }
}

extension FormModelX<T extends Object?, E extends Object> on FormModel<T, E> {
  FormModel<T, E> validate(
    IFormModelValidatorSet<T, E> validatorSet, {
    ValidateTrigger trigger = ValidateTrigger.onSubmit,
    FormModelStatus<E>? okStatus,
  }) {
    final errors = validatorSet.validate(value, trigger: trigger);

    return validateResult(errors, okStatus: okStatus);
  }

  FormModel<T, E> validateResult(Iterable<E> errors, {FormModelStatus<E>? okStatus}) {
    return copyWith(status: errors.isEmpty ? okStatus : FormModelStatus<E>.failures(errors));
  }
}

enum ValidateTrigger {
  onSubmit,
  onChange,
}

enum ValidationLevel {
  onAny({
    ValidateTrigger.onChange,
    ValidateTrigger.onSubmit,
  }),
  onSubmit({
    ValidateTrigger.onSubmit,
  });

  final Set<ValidateTrigger> triggers;

  const ValidationLevel(this.triggers);

  bool supportTrigger(ValidateTrigger trigger) => triggers.contains(trigger);
}
