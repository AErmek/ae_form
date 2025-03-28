import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
sealed class FormModelStatus<E extends Object> {
  const FormModelStatus();

  const factory FormModelStatus.pureLoading() = _PureLoading<E>;
  const factory FormModelStatus.pure() = _Pure<E>;

  const factory FormModelStatus.dirtyEditing() = _DirtyEditing<E>;
  const factory FormModelStatus.dirty() = _Dirty<E>;

  const factory FormModelStatus.failures(Iterable<E> errors) = FailureFormModelStatus<E>;

  bool get isEnabled => switch (this) {
        _PureLoading<E>() => false,
        _ => true,
      };

  bool get isPure => switch (this) {
        _Pure<E>() => true,
        _PureLoading<E>() => true,
        _ => false,
      };

  bool get isDirty => switch (this) {
        _Dirty<E>() => true,
        _DirtyEditing<E>() => true,
        _ => false,
      };

  bool get isFailure => switch (this) {
        FailureFormModelStatus<E>() => true,
        _ => false,
      };

  bool get isProcessing => switch (this) {
        _PureLoading<E>() => true,
        _DirtyEditing<E>() => true,
        _ => false,
      };

  @override
  int get hashCode => Object.hash(runtimeType, isPure, isProcessing, isDirty, isEnabled);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is FormModelStatus<E> &&
          other.isPure == isPure &&
          other.isDirty == isDirty &&
          other.isProcessing == isProcessing &&
          other.isEnabled == isEnabled);
}

class _PureLoading<E extends Object> extends FormModelStatus<E> {
  const _PureLoading();
}

class _Pure<E extends Object> extends FormModelStatus<E> {
  const _Pure();
}

class _DirtyEditing<E extends Object> extends FormModelStatus<E> {
  const _DirtyEditing();
}

class _Dirty<E extends Object> extends FormModelStatus<E> {
  const _Dirty();
}

class FailureFormModelStatus<E extends Object> extends FormModelStatus<E> {
  const FailureFormModelStatus(this.errors);

  final Iterable<E> errors;

  @override
  int get hashCode =>
      Object.hash(runtimeType, isPure, isProcessing, isDirty, isEnabled, IterableEquality<E>().hash(errors));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is FailureFormModelStatus<E> &&
          other.isPure == isPure &&
          other.isDirty == isDirty &&
          other.isProcessing == isProcessing &&
          other.isEnabled == isEnabled &&
          IterableEquality<E>().equals(errors, other.errors));
}
