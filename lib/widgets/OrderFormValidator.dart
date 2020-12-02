//form validation
String nameValidator(String value) {
  if (value.trim().isEmpty) {
    return 'This field is required';
  } else {
    return null;
  }
}

String weightValidator(String value) {
  if (value.trim().isEmpty) {
    return 'This field is required';
  }
  if (int.tryParse(value) == null) {
    return 'Invalid value';
  } else {
    return null;
  }
}

String addressValidator(String value) {
  if (value.trim().isEmpty) {
    return 'This field is required';
  } else {
    return null;
  }
}

String contactValidator(String value) {
  if (value == '+60 ') {
    return 'This field is required';
  } else {
    return null;
  }
}

String datetimeValidator(String value) {
  if (value.trim().isEmpty) {
    return 'This field is required';
  } else {
    return null;
  }
}
