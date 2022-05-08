[_Flutter Validation_](https://github.com/hsul4n/flutter_validation) is localized validation package wrapped around [_form_field_validator_](https://pub.dev/packages/form_field_validator) to deliver ready localized validation messages.

1. [Getting Started](#getting-started)
1. [Validators](#validators)
   1. [Common](#common)
   1. [Phone](#phone)
      1. [International](#international)
      1. [National](#national)
   1. [Match](#match)
   1. [List](#list)
   1. [Length](#length)
   1. [Number](#number)
   1. [Date](#date)
   1. [Custom](#custom)
1. [Multi Validator](#multi-validator)
1. [How does it work](#how-does-it-work)

# Getting Started

1. Add to your dependencies:

```yaml
dependencies:
  flutter_validation:
    git: git://github.com/hsul4n/flutter_validation.git
```

1. Add localizations delegates in your `MaterialApp` widget:

```dart
MaterialApp(
	// ...
	localizationsDelegates: [
		ValidationLocalizations.delegate,
		AttributeLocalizations.delegate,
	],
	supportedLocales: [
		const Locale('en'),
		const Locale('ar'),
		/// add other locales for now (en, ar)
	],
	// ...
)
```

2. Use it:

```dart
/// ...

TextFormField(
	decoration: InputDecoration(
		labelText: AttributeLocalizations.of(context).email,
	),
	// It's as easys as
	validator: Validator.of(context).email,
)

/// ...
```

# Validators

## Common

```dart
Validator.of(context).name // Validate name split legth >= 2
Validator.of(context).fullName // Validate name split legth >= 4
Validator.of(context).email // Validate email regex
Validator.of(context).required(
	AttributeLocalizations.of(context).name,
) // Validate name to be required
Validator.of(context).empty(
	AttributeLocalizations.of(context).name,
) // Validate name to be empty
```

## Phone

### International

```dart
Validator.of(context).phone
```

### National

```dart
Validator.of(context).phoneNational(
	IsoCode.US
);
```

## Match

```dart
Validator.of(context).match(
	AttributeLocalizations.of(context).password,
	AttributeLocalizations.of(context).passwordConfirmation,
	() => 'confirm_password',
);
```

## List

```dart
Validator.of(context).contains(
	AttributeLocalizations.of(context).gender,
	[
		'male',
		'femaile',
	],
);
```

## Length

```dart
Validator.of(context).length(
	AttributeLocalizations.of(context).password,
	3,
);

Validator.of(context).minLength(
	AttributeLocalizations.of(context).password,
	6,
);

Validator.of(context).minLength(
	AttributeLocalizations.of(context).password,
	12,
);
```

## Number

```dart
Validator.of(context).lessThan(
	AttributeLocalizations.of(context).age,
	18,
);

Validator.of(context).lessThanOrEqualTo(
	AttributeLocalizations.of(context).age,
	18,
);

Validator.of(context).greaterThan(
	AttributeLocalizations.of(context).age,
	18,
);

Validator.of(context).greaterThanOrEqualTo(
	AttributeLocalizations.of(context).age,
	18,
);

Validator.of(context).isNum(AttributeLocalizations.of(context).price);

Validator.of(context).isInt(AttributeLocalizations.of(context).price);
```

## Date

```dart
Validator.of(context).lessThan(
	AttributeLocalizations.of(context).age,
	18,
);
```

## Custom

```dart
// Example for starts with `https`
Validator.of(context).pattern(
	'Url',
	r'^(http|https)://',
);
```

# Multi Validator

As the package depend on [_form_field_validator_](https://pub.dev/packages/form_field_validator#multi-rules-validation) so you can use the same logic using `MultiValidator`:

```dart
MultiValidator([
	Validator.of(context).required(
		AttributeLocalizations.of(context).name
	),
	Validator.of(context).name,
	// ...
])
```

# How does it work

As the library delivers a localized validation so it depends on both of [validation_localizations](https://github.com/hsul4n/flutter-localizations/tree/master/packages/validation_localizations) and [attribute_localizations](https://github.com/hsul4n/flutter-localizations/tree/master/packages/attribute_localizations).
