// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SongCachingStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SongCachingStoreA on SongCachingStoreBase, Store {
  final _$cachedTracksAtom = Atom(name: 'SongCachingStoreBase.cachedTracks');

  @override
  Map<String, Song> get cachedTracks {
    _$cachedTracksAtom.context.enforceReadPolicy(_$cachedTracksAtom);
    _$cachedTracksAtom.reportObserved();
    return super.cachedTracks;
  }

  @override
  set cachedTracks(Map<String, Song> value) {
    _$cachedTracksAtom.context.conditionallyRunInAction(() {
      super.cachedTracks = value;
      _$cachedTracksAtom.reportChanged();
    }, _$cachedTracksAtom, name: '${_$cachedTracksAtom.name}_set');
  }

  final _$addOrUpdateSongAsyncAction = AsyncAction('addOrUpdateSong');

  @override
  Future<void> addOrUpdateSong(Song song) {
    return _$addOrUpdateSongAsyncAction.run(() => super.addOrUpdateSong(song));
  }

  final _$downloadAndCacheSongAsyncAction = AsyncAction('downloadAndCacheSong');

  @override
  Future<String> downloadAndCacheSong(Song song) {
    return _$downloadAndCacheSongAsyncAction
        .run(() => super.downloadAndCacheSong(song));
  }
}
