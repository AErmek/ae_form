import 'package:ae_form/ae_form.dart';
import 'package:flutter/foundation.dart';

@immutable
class FormModelKey {
  factory FormModelKey(String key, [Object? uniqueKey]) => FormModelKey._(key, uniqueKey);

  const FormModelKey._(this.validatorKey, this.uniqueKey);
  final String validatorKey;
  final Object? uniqueKey;

  @override
  int get hashCode => Object.hash(validatorKey, uniqueKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormModelKey &&
          runtimeType == other.runtimeType &&
          validatorKey == other.validatorKey &&
          uniqueKey == other.uniqueKey;

  String get id => [validatorKey, uniqueKey].nonNulls.join('_');
}

abstract interface class IFormModel<T extends Object?, E extends Object> {
  FormModelKey get key;

  T get value;

  FormModelStatus<E> get status;

  IFormModel<T, E> set(T value, {FormModelStatus<E> status = const FormModelStatus.dirty()});

  IFormModel<T, E> reset({ValueGetter<T>? value, FormModelStatus<E> status = const FormModelStatus.pure()});
}

@immutable
class FormModel<T extends Object?, E extends Object> implements IFormModel<T, E> {
  const FormModel(this.key, {required this.value, this.status = const FormModelStatus.pure()});

  @override
  final FormModelKey key;

  @override
  final T value;

  @override
  final FormModelStatus<E> status;

  @override
  FormModel<T, E> reset({ValueGetter<T>? value, FormModelStatus<E> status = const FormModelStatus.pure()}) =>
      copyWith(status: status, value: value);

  @override
  FormModel<T, E> set(T value, {FormModelStatus<E> status = const FormModelStatus.dirty()}) =>
      copyWith(status: status, value: () => value);

  @protected
  FormModel<T, E> copyWith({ValueGetter<T>? value, FormModelStatus<E>? status}) => FormModel(
        this.key,
        value: value != null ? value() : this.value,
        status: status ?? this.status,
      );

  @override
  int get hashCode => Object.hash(value, status);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is FormModel<T, E> &&
          other.key == key &&
          other.value == value &&
          other.status == status);
}

extension FormModelX<T extends Object?, E extends Object> on FormModel<T, E> {
  FormModel<T, E> validate(
    IFormModelValidator<T, E> validator, {
    ValidateTrigger trigger = ValidateTrigger.onSubmit,
    FormModelStatus<E>? okStatus,
  }) {
    final errors = validator.validate(value, trigger: trigger);

    return validateResult(errors, okStatus: okStatus);
  }

  FormModel<T, E> validateResult(Iterable<E> errors, {FormModelStatus<E>? okStatus}) =>
      copyWith(status: errors.isEmpty ? okStatus : FormModelStatus<E>.failures(errors));
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

  const ValidationLevel(this.triggers);

  final Set<ValidateTrigger> triggers;

  bool supportTrigger(ValidateTrigger trigger) => triggers.contains(trigger);
}
