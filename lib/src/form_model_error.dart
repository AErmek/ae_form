import 'package:collection/collection.dart';

sealed class FormModelError {
  const FormModelError();

  const factory FormModelError.localized({required String key, Map<String, dynamic> arguments}) =
      LocalizedFormModelError;
  const factory FormModelError.string(String message) = StringFormModelError;
  const factory FormModelError.object(Object data) = ObjectFormModelError;
}

class LocalizedFormModelError extends FormModelError {
  final String key;
  final Map<String, dynamic> arguments;

  const LocalizedFormModelError({required this.key, this.arguments = const {}});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalizedFormModelError && key == other.key && const MapEquality().equals(arguments, other.arguments));

  @override
  int get hashCode => Object.hash(key, const MapEquality().hash(arguments));
}

class StringFormModelError extends FormModelError {
  final String message;

  const StringFormModelError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StringFormModelError && message == other.message);

  @override
  int get hashCode => message.hashCode;
}

class ObjectFormModelError extends FormModelError {
  final Object data;

  const ObjectFormModelError(this.data);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is ObjectFormModelError && data == other.data);

  //TODO may be fix then
  @override
  int get hashCode => data.hashCode;
}
