// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NavigatorStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NavigatorStoreA on NavigatorStoreBase, Store {
  final _$routeAtom = Atom(name: 'NavigatorStoreBase.route');

  @override
  String get route {
    _$routeAtom.context.enforceReadPolicy(_$routeAtom);
    _$routeAtom.reportObserved();
    return super.route;
  }

  @override
  set route(String value) {
    _$routeAtom.context.conditionallyRunInAction(() {
      super.route = value;
      _$routeAtom.reportChanged();
    }, _$routeAtom, name: '${_$routeAtom.name}_set');
  }

  final _$routeParametersAtom =
      Atom(name: 'NavigatorStoreBase.routeParameters');

  @override
  Map<String, dynamic> get routeParameters {
    _$routeParametersAtom.context.enforceReadPolicy(_$routeParametersAtom);
    _$routeParametersAtom.reportObserved();
    return super.routeParameters;
  }

  @override
  set routeParameters(Map<String, dynamic> value) {
    _$routeParametersAtom.context.conditionallyRunInAction(() {
      super.routeParameters = value;
      _$routeParametersAtom.reportChanged();
    }, _$routeParametersAtom, name: '${_$routeParametersAtom.name}_set');
  }

  final _$NavigatorStoreBaseActionController =
      ActionController(name: 'NavigatorStoreBase');

  @override
  void changeRoute(String value, {Map<String, dynamic> parameters}) {
    final _$actionInfo = _$NavigatorStoreBaseActionController.startAction();
    try {
      return super.changeRoute(value, parameters: parameters);
    } finally {
      _$NavigatorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic goBack() {
    final _$actionInfo = _$NavigatorStoreBaseActionController.startAction();
    try {
      return super.goBack();
    } finally {
      _$NavigatorStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
