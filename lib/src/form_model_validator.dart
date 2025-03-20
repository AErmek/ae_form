import 'package:ae_form/ae_form.dart';

abstract interface class IFormModelValidatorUnit<T extends Object?, E extends Object> {
  E? validate(T value);

  /// Indicates whether the validator is critical.
  ///
  /// A critical validator will stop further validation if it produces an error.
  bool get isCritical;

  /// The level of validation.
  ///
  /// It defines which triggers are applicable to the validator.
  /// The validator will only be executed if the trigger matches one of the triggers
  /// defined in the [ValidationLevel].
  ValidationLevel get level;
}

extension IFormModelValidatorUnitX<T extends Object?, E extends Object> on IFormModelValidatorUnit<T, E> {
  E? validateWithTrigger(T value, ValidateTrigger trigger) => !level.supportTrigger(trigger) ? null : validate(value);
}

abstract interface class IFormModelValidator<T extends Object?, E extends Object> {
  Iterable<E> validate(T value, {required ValidateTrigger trigger});
}

abstract base class FormModelValidator<T extends Object?, E extends Object> implements IFormModelValidator<T, E> {
  List<IFormModelValidatorUnit<T, E>> get units;

  @override
  Iterable<E> validate(T value, {required ValidateTrigger trigger}) sync* {
    for (final validator in units) {
      final error = validator.validateWithTrigger(value, trigger);
      if (error != null) {
        yield error;

        if (validator.isCritical) {
          break;
        }
      }
    }
  }
}

final class SingleValidator<T extends Object?, E extends Object> extends FormModelValidator<T, E> {
  SingleValidator(this.validator);

  final IFormModelValidatorUnit<T, E> validator;

  @override
  List<IFormModelValidatorUnit<T, E>> get units => [validator];
}

//TODO FEATURE
// final class AndValidator<T extends Object?, E extends Object> implements IFormModelValidator<T, E> {
//   AndValidator({required this.validators});

//   final List<IFormModelValidator<T, E>> validators;

//   @override
//   final bool isCritical = true;

//   @override
//   E? validate(T value) {
//     for (var validator in validators) {
//       var error = validator.validate(value);
//       if (error != null) {
//         return error;
//       }
//     }
//     return null;
//   }
// }

// final class OrValidator<T extends Object?, E extends Object> implements IFormModelValidator<T, E> {
//   OrValidator({required this.validators, required this.ifError});

//   final E ifError;
//   final List<IFormModelValidator<T, E>> validators;

//   @override
//   final bool isCritical = false;

//   @override
//   E? validate(T value) {
//     for (var validator in validators) {
//       var error = validator.validate(value);
//       if (error == null) {
//         return null;
//       }
//     }
//     return ifError;
//   }
// }
