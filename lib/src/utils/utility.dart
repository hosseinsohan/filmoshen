import 'dart:io';
import 'dart:typed_data';

import 'package:filimo/src/resources/database/flute_music_player.dart';
import 'package:flutter/material.dart';

Song getImage(Song song) {
  return song.albumArt == null ? null : song;
}

Widget avatar(context, Song song, String title) {
  return new Material(
    borderRadius: new BorderRadius.circular(30.0),
    elevation: 2.0,
    child: song != null
        ? new CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            backgroundImage: new FileImage(File(song.albumArt)))
        : new CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: new Text(title[0].toUpperCase()),
          ),
  );
}
