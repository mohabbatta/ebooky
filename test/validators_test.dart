import 'package:ebooky2/repository/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
test('non empty string', (){
  final validator = NoEmptyStringValidator();
  expect(validator.isValid('test'),true);
});

test('empty string', (){
  final validator = NoEmptyStringValidator();
  expect(validator.isValid(''),false);
});

test('null string', () {
  final validator = NoEmptyStringValidator();
  expect(validator.isValid(null), false);
});

}