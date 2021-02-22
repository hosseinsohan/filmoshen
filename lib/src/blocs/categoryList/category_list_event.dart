import 'package:meta/meta.dart';

@immutable
abstract class CategoryListEvent {}

class GetCategoryListEvent extends CategoryListEvent {}
