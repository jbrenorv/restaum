import 'dart:convert';

import 'data_type.dart';

class Dto {
  final DataType type;

  // start game command
  final bool start;
  final bool ack;
  final bool accept;
  final String ip;
  final int port;

  // identification
  final String enemy;

  // movement
  final int sourceIndex;
  final int captureIndex;
  final int destinationIndex;

  // chat
  final String message;

  Dto({
    required this.type,
    required this.start,
    required this.ack,
    required this.accept,
    required this.ip,
    required this.port,
    required this.enemy,
    required this.sourceIndex,
    required this.captureIndex,
    required this.destinationIndex,
    required this.message,
  });

  factory Dto.start({
    required bool start,
    required bool ack,
    required bool accept,
    required String enemy,
    required String ip,
    required int port,
  }) {
    return Dto(
      type: DataType.start,
      start: start,
      ack: ack,
      accept: accept,
      ip: ip,
      port: port,
      enemy: enemy,
      sourceIndex: -1,
      captureIndex: -1,
      destinationIndex: -1,
      message: '',
    );
  }

  factory Dto.chat({required String message}) {
    return Dto(
      type: DataType.chat,
      start: false,
      ack: false,
      accept: false,
      ip: '',
      port: -1,
      enemy: '',
      sourceIndex: -1,
      captureIndex: -1,
      destinationIndex: -1,
      message: message,
    );
  }

  factory Dto.movement({
    required int sourceIndex,
    required int captureIndex,
    required int destinationIndex,
  }) {
    return Dto(
      type: DataType.movement,
      start: false,
      ack: false,
      accept: false,
      ip: '',
      port: -1,
      enemy: '',
      sourceIndex: sourceIndex,
      captureIndex: captureIndex,
      destinationIndex: destinationIndex,
      message: '',
    );
  }

  factory Dto.whiteFlag() {
    return Dto(
      type: DataType.whiteFlag,
      start: false,
      ack: false,
      accept: false,
      ip: '',
      port: -1,
      enemy: '',
      sourceIndex: -1,
      captureIndex: -1,
      destinationIndex: -1,
      message: '',
    );
  }

  factory Dto.disconnectedPair() {
    return Dto(
      type: DataType.disconnectedPair,
      start: false,
      ack: false,
      accept: false,
      ip: '',
      port: -1,
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
      'accept': accept,
      'ip': ip,
      'port': port,
      'enemy': enemy,
      'sourceIndex': sourceIndex,
      'captureIndex': captureIndex,
      'destinationIndex': destinationIndex,
      'message': message,
    };
  }

  factory Dto.fromMap(Map<String, dynamic> map) {
    return Dto(
      type: DataType.fromMap(map['type']),
      start: map['start'] as bool,
      ack: map['ack'] as bool,
      accept: map['accept'] as bool,
      ip: map['ip'] as String,
      port: map['port'] as int,
      enemy: map['enemy'] as String,
      sourceIndex: map['sourceIndex'] as int,
      captureIndex: map['captureIndex'] as int,
      destinationIndex: map['destinationIndex'] as int,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dto.fromJson(String source) =>
      Dto.fromMap(json.decode(source) as Map<String, dynamic>);
}
