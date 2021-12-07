// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlayerComponentStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PlayerComponentStoreA on PlayerComponentStoreBase, Store {
  final _$songAtom = Atom(name: 'PlayerComponentStoreBase.song');

  @override
  Song get song {
    _$songAtom.context.enforceReadPolicy(_$songAtom);
    _$songAtom.reportObserved();
    return super.song;
  }

  @override
  set song(Song value) {
    _$songAtom.context.conditionallyRunInAction(() {
      super.song = value;
      _$songAtom.reportChanged();
    }, _$songAtom, name: '${_$songAtom.name}_set');
  }

  final _$positionAtom = Atom(name: 'PlayerComponentStoreBase.position');

  @override
  int get position {
    _$positionAtom.context.enforceReadPolicy(_$positionAtom);
    _$positionAtom.reportObserved();
    return super.position;
  }

  @override
  set position(int value) {
    _$positionAtom.context.conditionallyRunInAction(() {
      super.position = value;
      _$positionAtom.reportChanged();
    }, _$positionAtom, name: '${_$positionAtom.name}_set');
  }

  final _$durationAtom = Atom(name: 'PlayerComponentStoreBase.duration');

  @override
  int get duration {
    _$durationAtom.context.enforceReadPolicy(_$durationAtom);
    _$durationAtom.reportObserved();
    return super.duration;
  }

  @override
  set duration(int value) {
    _$durationAtom.context.conditionallyRunInAction(() {
      super.duration = value;
      _$durationAtom.reportChanged();
    }, _$durationAtom, name: '${_$durationAtom.name}_set');
  }

  final _$PlayerComponentStoreBaseActionController =
      ActionController(name: 'PlayerComponentStoreBase');

  @override
  void setSong(Song value) {
    final _$actionInfo =
        _$PlayerComponentStoreBaseActionController.startAction();
    try {
      return super.setSong(value);
    } finally {
      _$PlayerComponentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPosition(int pos) {
    final _$actionInfo =
        _$PlayerComponentStoreBaseActionController.startAction();
    try {
      return super.setPosition(pos);
    } finally {
      _$PlayerComponentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDuration(int pos) {
    final _$actionInfo =
        _$PlayerComponentStoreBaseActionController.startAction();
    try {
      return super.setDuration(pos);
    } finally {
      _$PlayerComponentStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
