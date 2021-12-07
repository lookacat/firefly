// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LibraryStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LibraryStoreA on LibraryStoreBase, Store {
  final _$playlistsAtom = Atom(name: 'LibraryStoreBase.playlists');

  @override
  List<Playlist> get playlists {
    _$playlistsAtom.context.enforceReadPolicy(_$playlistsAtom);
    _$playlistsAtom.reportObserved();
    return super.playlists;
  }

  @override
  set playlists(List<Playlist> value) {
    _$playlistsAtom.context.conditionallyRunInAction(() {
      super.playlists = value;
      _$playlistsAtom.reportChanged();
    }, _$playlistsAtom, name: '${_$playlistsAtom.name}_set');
  }

  final _$LibraryStoreBaseActionController =
      ActionController(name: 'LibraryStoreBase');

  @override
  void addPlaylist(Playlist playlist) {
    final _$actionInfo = _$LibraryStoreBaseActionController.startAction();
    try {
      return super.addPlaylist(playlist);
    } finally {
      _$LibraryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePlaylist(Playlist playlist) {
    final _$actionInfo = _$LibraryStoreBaseActionController.startAction();
    try {
      return super.updatePlaylist(playlist);
    } finally {
      _$LibraryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTrackToPlaylist(Song track, String id) {
    final _$actionInfo = _$LibraryStoreBaseActionController.startAction();
    try {
      return super.addTrackToPlaylist(track, id);
    } finally {
      _$LibraryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTrackFromPlaylist(int trackIndex, String id) {
    final _$actionInfo = _$LibraryStoreBaseActionController.startAction();
    try {
      return super.removeTrackFromPlaylist(trackIndex, id);
    } finally {
      _$LibraryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePlaylist(String id) {
    final _$actionInfo = _$LibraryStoreBaseActionController.startAction();
    try {
      return super.removePlaylist(id);
    } finally {
      _$LibraryStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
