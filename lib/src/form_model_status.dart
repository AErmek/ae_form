import 'package:flutter/material.dart';

@immutable
sealed class FormModelStatus<E extends Object> {
  const FormModelStatus();

  const factory FormModelStatus.pureLoading() = _Pure._inProcess;
  const factory FormModelStatus.pure() = _Pure._;

  const factory FormModelStatus.dirtyEditing() = _Dirty._inProcess;
  const factory FormModelStatus.dirty() = _Dirty._;

  const factory FormModelStatus.valid() = _Valid._;

  factory FormModelStatus.failure(E error) => FailureFormModelStatus._([error]);
  factory FormModelStatus.failures(Iterable<E> errors) => FailureFormModelStatus._(errors);

  bool get isEnabled;

  bool get isPure => switch (this) {
    _Pure._ => true,
    _Pure._inProcess => true,
    _ => false,
  };

  bool get isDirty => switch (this) {
    _Dirty._ => true,
    _Dirty._inProcess => true,
    _ => false,
  };

  bool get isProcessing;

  @override
  int get hashCode => Object.hash(runtimeType, isPure, isProcessing, isDirty);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is FormModelStatus &&
          other.isPure == isPure &&
          other.isDirty == isDirty &&
          other.isProcessing == isProcessing);
}

class _Pure<E extends Object> extends FormModelStatus<E> {
  const _Pure._({this.processing = false});
  const _Pure._inProcess({this.processing = true});

  final bool processing;

  @override
  bool get isProcessing => processing;

  @override
  bool get isEnabled => !processing;
}

class _Dirty<E extends Object> extends FormModelStatus<E> {
  const _Dirty._({this.processing = false});
  const _Dirty._inProcess({this.processing = true});

  final bool processing;

  @override
  bool get isProcessing => processing;

  @override
  bool get isEnabled => true;
}

class _Valid<E extends Object> extends FormModelStatus<E> {
  const _Valid._();

  @override
  bool get isProcessing => false;

  @override
  bool get isEnabled => true;
}

class FailureFormModelStatus<E extends Object> extends FormModelStatus<E> {
  const FailureFormModelStatus._(this.errors);

  final Iterable<E> errors;
  @override
  bool get isProcessing => false;

  @override
  bool get isEnabled => true;
}
