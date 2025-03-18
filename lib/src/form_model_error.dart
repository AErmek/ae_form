import 'package:collection/collection.dart';

sealed class FormModelError {
  const factory FormModelError.localized({required String key, Map<String, dynamic> arguments}) =
      LocalizedFormModelError;
  const factory FormModelError.string(String message) = StringFormModelError;
  const factory FormModelError.any(Object data) = AnyFormModelError;

  bool equals(FormModelError other);
}

class LocalizedFormModelError implements FormModelError {
  final String key;
  final Map<String, dynamic> arguments;

  const LocalizedFormModelError({required this.key, this.arguments = const {}});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalizedFormModelError && key == other.key && const MapEquality().equals(arguments, other.arguments));

  @override
  int get hashCode => Object.hash(key, const MapEquality().hash(arguments));

  @override
  bool equals(FormModelError other) => this == other;
}

class StringFormModelError implements FormModelError {
  final String message;

  const StringFormModelError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StringFormModelError && message == other.message);

  @override
  int get hashCode => message.hashCode;

  @override
  bool equals(FormModelError other) => this == other;
}

class AnyFormModelError implements FormModelError {
  final Object data;

  const AnyFormModelError(this.data);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is AnyFormModelError && data == other.data);

  //TODO may be fix then
  @override
  int get hashCode => data.hashCode;

  @override
  bool equals(FormModelError other) => this == other;
}
