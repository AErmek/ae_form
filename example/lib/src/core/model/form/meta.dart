import 'package:ae_form/ae_form.dart';

typedef FormInputError = FormModelError;
typedef FormInput<T extends Object> = FormModel<T, FormInputError>;
typedef NullableFormInput<T extends Object> = NullableFormModel<T, FormInputError>;

extension FormInputX on FormInput {
  String? get errorMessage => switch (status) {
    FailureFormModelStatus(errors: final errors) => errors.message,
    _ => null,
  };
}

extension FormModelErrorListX on Iterable<FormModelError> {
  String? get message => map(
    (e) => switch (e) {
      LocalizedFormModelError(key: final key, arguments: final arguments) => localizedMessage(key, arguments),
      StringFormModelError(message: final message) => message,
      AnyFormModelError(data: final data) => data.toString(),
    },
  ).join(';');

  //TODO logic of localization
  String localizedMessage(String key, Map<String, dynamic> arguments) => key;
}
