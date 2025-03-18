import 'package:ae_form/ae_form.dart';
import 'package:flutter/foundation.dart';

abstract interface class IFormModel<T extends Object?, E extends Object> {
  T get value;

  FormModelStatus<E> get status;

  IFormModel<T, E> set(T value, {FormModelStatus<E> status = const FormModelStatus.dirty()});

  IFormModel<T, E> setFailure(E error);

  IFormModel<T, E> reset({ValueGetter<T>? value, FormModelStatus<E> status = const FormModelStatus.pure()});
}

abstract base class BaseFormModel<T extends Object?, TChild extends BaseFormModel<T, TChild, E>, E extends Object>
    implements IFormModel<T, E> {
  @override
  final T value;

  @override
  final FormModelStatus<E> status;

  const BaseFormModel(T initialValue, {this.status = const FormModelStatus.pure()}) : value = initialValue;

  @override
  TChild reset({ValueGetter<T>? value, FormModelStatus<E> status = const FormModelStatus.pure()}) =>
      copyWith(status: status, value: value);

  @override
  TChild set(T value, {FormModelStatus<E> status = const FormModelStatus.dirty()}) =>
      copyWith(status: status, value: () => value);

  @override
  TChild setFailure(E error) => copyWith(status: FormModelStatus<E>.failure(error));

  @protected
  TChild copyWith({ValueGetter<T>? value, FormModelStatus<E>? status});

  @override
  int get hashCode => Object.hash(value, status);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TChild && other.value == value && other.status == status);
  }
}

final class FormModel<T extends Object, E extends Object> extends BaseFormModel<T, FormModel<T, E>, E> {
  const FormModel(super.initialValue, {super.status = const FormModelStatus.pure()});

  const FormModel._(super.initialValue, {required super.status});

  @override
  @protected
  FormModel<T, E> copyWith({ValueGetter<T>? value, FormModelStatus<E>? status}) {
    return FormModel._(value != null ? value() : this.value, status: status ?? this.status);
  }
}

final class NullableFormModel<T extends Object, E extends Object>
    extends BaseFormModel<T?, NullableFormModel<T, E>, E> {
  const NullableFormModel({T? initialValue, super.status = const FormModelStatus.pure()}) : super(initialValue);

  const NullableFormModel._(super.initialValue, {required super.status});

  @override
  @protected
  NullableFormModel<T, E> copyWith({ValueGetter<T?>? value, FormModelStatus<E>? status}) {
    return NullableFormModel._(value != null ? value() : this.value, status: status ?? this.status);
  }
}

extension BaseFormModelX<T extends Object?, TChild extends BaseFormModel<T, TChild, E>, E extends Object>
    on BaseFormModel<T, TChild, E> {
  TChild validateSet(IFormModelValidatorSet<T, E> validatorSet, {ValidateTrigger trigger = ValidateTrigger.submit}) {
    final errors = validatorSet.validate(value, trigger: trigger);

    return copyWith(status: errors.isEmpty ? FormModelStatus<E>.valid() : FormModelStatus<E>.failures(errors));
  }

  TChild validate(IFormModelValidator<T, E> validator, {ValidateTrigger trigger = ValidateTrigger.submit}) {
    final error = !validator.level.supportTrigger(trigger) ? null : validator.validate(value);

    return copyWith(status: error == null ? FormModelStatus<E>.valid() : FormModelStatus<E>.failure(error));
  }

  TChild validateFromResult(E? error) {
    return copyWith(status: error == null ? FormModelStatus<E>.valid() : FormModelStatus<E>.failure(error));
  }
}

enum ValidateTrigger {
  submit,
  reactive,
}

enum ValidateLevel {
  any({ValidateTrigger.reactive, ValidateTrigger.submit}),
  onSubmit({ValidateTrigger.submit});

  final Set<ValidateTrigger> triggers;

  const ValidateLevel(this.triggers);

  bool supportTrigger(ValidateTrigger trigger) => triggers.contains(trigger);
}
