import 'package:flutter/material.dart';

import 'validation.dart';

class PositiveNumberValidation extends Validation<num> {
  const PositiveNumberValidation();

  @override
  String? validate(BuildContext context, num? value) {
    if (value == null) return 'This field is required';
    if (value <= 0) return 'Value must be positive';
    return null;
  }
}



