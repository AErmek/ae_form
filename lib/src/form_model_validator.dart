abstract interface class IFormModelValidator<T extends Object?, E extends Object> {
  E? validate(T value);
  bool get isCritical;
}

abstract interface class IFormModelValidatorSet<T extends Object?, E extends Object> {
  Iterable<E> validate(T value);
}

abstract base class FormModelValidatorSet<T extends Object?, E extends Object> implements IFormModelValidatorSet<T, E> {
  List<IFormModelValidator<T, E>> get validators;

  @override
  Iterable<E> validate(T value) sync* {
    for (var validator in validators) {
      var error = validator.validate(value);
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

//TODO Examples
// final class NameValidatorSet extends FormModelValidatorSet<String, String> {
//   @override
//   List<IFormModelValidator<String, String>> validators = [RequiredValidator()];
// }

// final class ConfirmPasswordValidatorSet extends FormModelValidatorSet<String, String> {
//   ConfirmPasswordValidatorSet({required this.originValueGetter});

//   final String Function() originValueGetter;

//   @override
//   late List<IFormModelValidator<String, String>> validators = [
//     RequiredValidator(),
//     SameValueValidator(originValueGetter: originValueGetter),
//   ];
// }

// final class RequiredValidator implements IFormModelValidator<String, String> {
//   RequiredValidator({this.isCritical = true});

//   @override
//   final bool isCritical;

//   @override
//   String? validate(String value) {
//     return value.isEmpty ? 'Required' : null;
//   }
// }

// final class SameValueValidator implements IFormModelValidator<String, String> {
//   SameValueValidator({this.isCritical = true, required this.originValueGetter});

//   final String Function() originValueGetter;

//   @override
//   final bool isCritical;

//   @override
//   String? validate(String value) {
//     return value == originValueGetter.call() ? null : 'Not same value';
//   }
// }
