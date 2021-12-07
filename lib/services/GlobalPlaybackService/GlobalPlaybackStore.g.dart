// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GlobalPlaybackStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GlobalPlaybackStoreA on GlobalPlaybackStoreBase, Store {
  final _$isPlayingAtom = Atom(name: 'GlobalPlaybackStoreBase.isPlaying');

  @override
  bool get isPlaying {
    _$isPlayingAtom.context.enforceReadPolicy(_$isPlayingAtom);
    _$isPlayingAtom.reportObserved();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.context.conditionallyRunInAction(() {
      super.isPlaying = value;
      _$isPlayingAtom.reportChanged();
    }, _$isPlayingAtom, name: '${_$isPlayingAtom.name}_set');
  }

  final _$currentPlaylistIdAtom =
      Atom(name: 'GlobalPlaybackStoreBase.currentPlaylistId');

  @override
  String get currentPlaylistId {
    _$currentPlaylistIdAtom.context.enforceReadPolicy(_$currentPlaylistIdAtom);
    _$currentPlaylistIdAtom.reportObserved();
    return super.currentPlaylistId;
  }

  @override
  set currentPlaylistId(String value) {
    _$currentPlaylistIdAtom.context.conditionallyRunInAction(() {
      super.currentPlaylistId = value;
      _$currentPlaylistIdAtom.reportChanged();
    }, _$currentPlaylistIdAtom, name: '${_$currentPlaylistIdAtom.name}_set');
  }

  final _$GlobalPlaybackStoreBaseActionController =
      ActionController(name: 'GlobalPlaybackStoreBase');

  @override
  void setPlayingStatus(bool value) {
    final _$actionInfo =
        _$GlobalPlaybackStoreBaseActionController.startAction();
    try {
      return super.setPlayingStatus(value);
    } finally {
      _$GlobalPlaybackStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentPlaylistId(String value) {
    final _$actionInfo =
        _$GlobalPlaybackStoreBaseActionController.startAction();
    try {
      return super.setCurrentPlaylistId(value);
    } finally {
      _$GlobalPlaybackStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
