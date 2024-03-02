import 'dart:io';

import 'package:flutter/material.dart';

import '../entities/cell_entity.dart';
import '../entities/destination_entity.dart';
import '../socket/dto/socket_dto.dart';

const deltaDestination = [-22, 22, -2, 2];
const deltaEnemy = [-11, 11, -1, 1];

List<DestinationEntity> getAvailableDestinations(
  int index,
  List<CellEntity> board,
) {
  if (!CellEntity.isValid(index) || board[index].empty) return [];
  final answer = <DestinationEntity>[];
  for (int i = 0; i < 4; ++i) {
    final destinationIndex = index + deltaDestination[i];
    final enemyIndex = index + deltaEnemy[i];

    if (CellEntity.isValid(destinationIndex) &&
        board[destinationIndex].empty &&
        !board[enemyIndex].empty) {
      answer.add(
        DestinationEntity(
          destination: destinationIndex,
          capture: enemyIndex,
        ),
      );
    }
  }

  return answer;
}

bool isDestination(List<DestinationEntity> destinations, CellEntity cell) {
  for (final destination in destinations) {
    if (destination.destination == cell.index) {
      return true;
    }
  }
  return false;
}

(String, String) getMatchDisplayOrder(SocketDto data, String userName) {
  var firstPlayer = data.enemy;
  var secondPlayer = userName;

  if (data.start) {
    firstPlayer = userName;
    secondPlayer = data.enemy;
  }

  return (firstPlayer, secondPlayer);
}

bool isGameOver(List<CellEntity> board) {
  final destinations = [
    for (final cell in board) ...getAvailableDestinations(cell.index, board),
  ];
  return destinations.isEmpty;
}

bool get isPlatformDesktop =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
