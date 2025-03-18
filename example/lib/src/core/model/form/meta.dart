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
      //TODO logic of localization
      LocalizedFormModelError(key: final key, arguments: final _) => key,
      StringFormModelError(message: final message) => message,
      AnyFormModelError(data: final data) => data.toString(),
    },
  ).join(';');
}
