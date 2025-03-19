import 'package:ae_form/ae_form.dart';

abstract interface class IFormModelValidator<T extends Object?, E extends Object> {
  E? validate(T value);
  bool get isCritical;
  ValidateLevel get level;
}

extension IFormModelValidatorX<T extends Object?, E extends Object> on IFormModelValidator<T, E> {
  E? validateWithTrigger(T value, ValidateTrigger trigger) => !level.supportTrigger(trigger) ? null : validate(value);
}

abstract interface class IFormModelValidatorSet<T extends Object?, E extends Object> {
  Iterable<E> validate(T value, {required ValidateTrigger trigger});
}

abstract base class FormModelValidatorSet<T extends Object?, E extends Object> implements IFormModelValidatorSet<T, E> {
  List<IFormModelValidator<T, E>> get validators;

  @override
  Iterable<E> validate(T value, {required ValidateTrigger trigger}) sync* {
    for (var validator in validators) {
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
