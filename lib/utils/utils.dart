import '../entities/cell_entity.dart';
import '../entities/destination_entity.dart';

const deltaDestination = [-22, 22, -2, 2];
const deltaEnemy = [-11, 11, -1, 1];

List<DestinationEntity> getAvailableDestinations(
  int index,
  List<CellEntity> board,
) {
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
          enemy: enemyIndex,
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
