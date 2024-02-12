import 'dart:convert';

import 'data_type.dart';

class SocketDto {
  final DataType type;

  // start game command
  final bool start;
  final bool ack;

  // identification
  final String enemy;

  // movement
  final int sourceIndex;
  final int captureIndex;
  final int destinationIndex;

  // chat
  final String message;

  SocketDto({
    required this.type,
    required this.start,
    required this.ack,
    required this.enemy,
    required this.sourceIndex,
    required this.captureIndex,
    required this.destinationIndex,
    required this.message,
  });

  factory SocketDto.start({
    required bool start,
    required bool ack,
    required String enemy,
  }) {
    return SocketDto(
      type: DataType.start,
      start: start,
      ack: ack,
      enemy: enemy,
      sourceIndex: -1,
      captureIndex: -1,
      destinationIndex: -1,
      message: '',
    );
  }

  factory SocketDto.chat({required String message}) {
    return SocketDto(
      type: DataType.chat,
      start: false,
      ack: false,
      enemy: '',
      sourceIndex: -1,
      captureIndex: -1,
      destinationIndex: -1,
      message: message,
    );
  }

  factory SocketDto.movement({
    required int sourceIndex,
    required int captureIndex,
    required int destinationIndex,
  }) {
    return SocketDto(
      type: DataType.movement,
      start: false,
      ack: false,
      enemy: '',
      sourceIndex: sourceIndex,
      captureIndex: captureIndex,
      destinationIndex: destinationIndex,
      message: '',
    );
  }

  factory SocketDto.whiteFlag() {
    return SocketDto(
      type: DataType.whiteFlag,
      start: false,
      ack: false,
      enemy: '',
      sourceIndex: -1,
      captureIndex: -1,
      destinationIndex: -1,
      message: '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toMap(),
      'start': start,
      'ack': ack,
      'enemy': enemy,
      'sourceIndex': sourceIndex,
      'captureIndex': captureIndex,
      'destinationIndex': destinationIndex,
      'message': message,
    };
  }

  factory SocketDto.fromMap(Map<String, dynamic> map) {
    return SocketDto(
      type: DataType.fromMap(map['type']),
      start: map['start'] as bool,
      ack: map['ack'] as bool,
      enemy: map['enemy'] as String,
      sourceIndex: map['sourceIndex'] as int,
      captureIndex: map['captureIndex'] as int,
      destinationIndex: map['destinationIndex'] as int,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SocketDto.fromJson(String source) =>
      SocketDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
