import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class FormModelError {
  const FormModelError();

  const factory FormModelError.localized({required String key, Map<String, dynamic> arguments}) =
      LocalizedFormModelError;
  const factory FormModelError.string(String message) = StringFormModelError;
  const factory FormModelError.object(Object data) = ObjectFormModelError;
}

class LocalizedFormModelError extends FormModelError {
  const LocalizedFormModelError({required this.key, this.arguments = const {}});
  final Map<String, dynamic> arguments;
  final String key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalizedFormModelError &&
          key == other.key &&
          const MapEquality<String, dynamic>().equals(arguments, other.arguments));

  @override
  int get hashCode => Object.hash(key, const MapEquality<String, dynamic>().hash(arguments));
}

class StringFormModelError extends FormModelError {
  const StringFormModelError(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StringFormModelError && message == other.message);

  @override
  int get hashCode => message.hashCode;
}

class ObjectFormModelError extends FormModelError {
  const ObjectFormModelError(this.data);

  final Object data;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is ObjectFormModelError && data == other.data);

  //TODO may be fix then
  @override
  int get hashCode => data.hashCode;
}
