import 'package:equatable/equatable.dart';

abstract class Equality extends Equatable {
  const Equality();

  @override
  bool? get stringify => true;
}
