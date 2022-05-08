library flutter_validation;

import 'package:attribute_localizations/attribute_localizations.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:validation_localizations/validation_localizations.dart';

export 'package:form_field_validator/form_field_validator.dart';

export 'package:attribute_localizations/attribute_localizations.dart'
    show AttributeLocalizations;
export 'package:validation_localizations/validation_localizations.dart'
    show ValidationLocalizations;
export 'package:dart_countries/src/generated/iso_codes.enum.dart';

class Validator {
  final BuildContext _context;

  Validator._(this._context);

  static Validator? of(BuildContext context) => Validator._(context);

  TextFieldValidator empty(String attribute) =>
      ExpressionValidator((value) => value!.isEmpty,
          errorText: ValidationLocalizations.of(_context)!.present(attribute));

  MultiValidator required(String attribute) => MultiValidator([
        NullableValidator(
            errorText:
                ValidationLocalizations.of(_context)!.required(attribute)),
        RequiredValidator(
            errorText:
                ValidationLocalizations.of(_context)!.required(attribute))
      ]);

  TextFieldValidator get name =>
      ExpressionValidator((value) => value!.trim().split(' ').length >= 2,
          errorText: ValidationLocalizations.of(_context)!
              .invalid(AttributeLocalizations.of(_context)!.name));

  TextFieldValidator get fullName =>
      ExpressionValidator((value) => value!.trim().split(' ').length >= 4,
          errorText: ValidationLocalizations.of(_context)!
              .invalid(AttributeLocalizations.of(_context)!.name));

  TextFieldValidator get email => EmailValidator(
      errorText: ValidationLocalizations.of(_context)!
          .invalid(AttributeLocalizations.of(_context)!.email));

  TextFieldValidator get phone => ExpressionValidator(
        (value) => value != null ? PhoneNumber.fromRaw(value).validate() : true,
        errorText: ValidationLocalizations.of(_context)!
            .invalid(AttributeLocalizations.of(_context)!.phone),
      );

  TextFieldValidator phoneNational(IsoCode isoCode) => ExpressionValidator(
        (value) => value != null
            ? PhoneNumber.fromNational(isoCode, value).validate()
            : true,
        errorText: ValidationLocalizations.of(_context)!
            .invalid(AttributeLocalizations.of(_context)!.phone),
      );

  TextFieldValidator match(String attribute, String otherAttribute,
          String Function() otherValue) =>
      ExpressionValidator(
        (_value) => _value == otherValue(),
        errorText: ValidationLocalizations.of(_context)!
            .confirmation(attribute, otherAttribute),
      );

  TextFieldValidator contains(String attribute, List<dynamic> items) =>
      ExpressionValidator((value) => items.contains(value),
          errorText:
              ValidationLocalizations.of(_context)!.inclusion(attribute));

  TextFieldValidator length(String attribute, int count) =>
      LengthRangeValidator(
          min: count,
          max: count,
          errorText: ValidationLocalizations.of(_context)!
              .wrongLength(attribute, count));

  TextFieldValidator minLength(String attribute, int count) =>
      MinLengthValidator(count,
          errorText:
              ValidationLocalizations.of(_context)!.tooShort(attribute, count));

  TextFieldValidator maxLength(String attribute, int count) =>
      MaxLengthValidator(count,
          errorText:
              ValidationLocalizations.of(_context)!.tooLong(attribute, count));

  MultiValidator lessThan(String attribute, num count) => MultiValidator([
        isNum(attribute),
        ExpressionValidator(
          (String? value) => num.parse(value!) < count,
          errorText:
              ValidationLocalizations.of(_context)!.lessThan(attribute, count),
        )
      ]);

  MultiValidator lessThanOrEqualTo(String attribute, num count) =>
      MultiValidator([
        isNum(attribute),
        ExpressionValidator(
          (String? value) => num.parse(value!) <= count,
          errorText: ValidationLocalizations.of(_context)!
              .lessThanOrEqualTo(attribute, count),
        )
      ]);

  MultiValidator greaterThan(String attribute, num count) => MultiValidator([
        isNum(attribute),
        ExpressionValidator(
          (String? value) => num.parse(value!) > count,
          errorText: ValidationLocalizations.of(_context)!
              .greaterThan(attribute, count),
        ),
      ]);

  MultiValidator greaterThanOrEqualTo(String attribute, num count) =>
      MultiValidator([
        isNum(attribute),
        ExpressionValidator((String? value) => num.parse(value!) >= count,
            errorText: ValidationLocalizations.of(_context)!
                .greaterThanOrEqualTo(attribute, count)),
      ]);

  TextFieldValidator dateFormat(String format) => DateValidator(format,
      errorText: ValidationLocalizations.of(_context)!
          .invalid(AttributeLocalizations.of(_context)!.date));

  TextFieldValidator pattern(String attribute, Pattern pattern,
          {bool caseSensitive = true}) =>
      PatternValidator(pattern,
          caseSensitive: caseSensitive,
          errorText: ValidationLocalizations.of(_context)!.invalid(attribute));

  TextFieldValidator isNum(String attribute) => ExpressionValidator(
      (value) => num.tryParse(value!) != null,
      errorText: ValidationLocalizations.of(_context)!.notANumber(attribute));

  TextFieldValidator isInt(String attribute) => ExpressionValidator(
      (value) => int.tryParse(value!) != null,
      errorText: ValidationLocalizations.of(_context)!.notAnInteger(attribute));
}

class ExpressionValidator extends TextFieldValidator {
  final bool Function(String? value) experssion;

  ExpressionValidator(this.experssion, {required String errorText})
      : super(errorText);

  @override
  bool isValid(String? value) => experssion(value);
}

class NullableValidator extends FieldValidator {
  NullableValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(value) {
    return value != null;
  }
}
