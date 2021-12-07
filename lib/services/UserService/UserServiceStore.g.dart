// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserServiceStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserServiceStoreA on UserServiceStoreBase, Store {
  final _$userAtom = Atom(name: 'UserServiceStoreBase.user');

  @override
  User get user {
    _$userAtom.context.enforceReadPolicy(_$userAtom);
    _$userAtom.reportObserved();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.context.conditionallyRunInAction(() {
      super.user = value;
      _$userAtom.reportChanged();
    }, _$userAtom, name: '${_$userAtom.name}_set');
  }

  final _$UserServiceStoreBaseActionController =
      ActionController(name: 'UserServiceStoreBase');

  @override
  void setUser(User user) {
    final _$actionInfo = _$UserServiceStoreBaseActionController.startAction();
    try {
      return super.setUser(user);
    } finally {
      _$UserServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
