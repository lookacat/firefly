// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'YoutubePlaybackServiceStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$YoutubePlaybackServiceStoreA on YoutubePlaybackServiceStoreBase, Store {
  final _$isPlayingAtom =
      Atom(name: 'YoutubePlaybackServiceStoreBase.isPlaying');

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

  final _$YoutubePlaybackServiceStoreBaseActionController =
      ActionController(name: 'YoutubePlaybackServiceStoreBase');

  @override
  void setPlayingStatus(bool value) {
    final _$actionInfo =
        _$YoutubePlaybackServiceStoreBaseActionController.startAction();
    try {
      return super.setPlayingStatus(value);
    } finally {
      _$YoutubePlaybackServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
