import 'package:flutter/material.dart';

import '../entities/cell_entity.dart';
import '../entities/destination_entity.dart';
import 'circle_widget.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    Key? key,
    required this.selectedIndex,
    required this.cell,
    required this.onTap,
    required this.destinations,
    required this.onCellDropped,
    required this.myTurn,
    required this.gameOver,
  }) : super(key: key);

  final int selectedIndex;
  final CellEntity cell;
  final List<DestinationEntity> destinations;
  final void Function(CellEntity) onTap;
  final void Function(CellEntity, CellEntity) onCellDropped;
  final bool myTurn;
  final bool gameOver;

  @override
  Widget build(BuildContext context) {
    if (!cell.valid) return const SizedBox.shrink();

    final child = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: _getElevation(),
        shadowColor: _getBackgroundColor(),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => onTap(cell),
          customBorder: const CircleBorder(),
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: [
              CircleWidget(color: _getBackgroundColor()),
              CircleWidget(color: _getOverlayColor()),
            ],
          ),
        ),
      ),
    );

    if (_isDestination) {
      return DragTarget<CellEntity>(
        onAccept: (droppedCell) => onCellDropped(droppedCell, cell),
        builder: (context, candidateData, rejectedData) => child,
      );
    }

    if (_empty || !myTurn || gameOver) return child;

    return Draggable<CellEntity>(
      data: cell,
      feedback: SizedBox.square(
        dimension: 54.545454545,
        child: child,
      ),
      childWhenDragging: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleWidget(
          color: Colors.black,
        ),
      ),
      onDragStarted: () {
        if (!_selected) {
          onTap(cell);
        }
      },
      child: child,
    );
  }

  double _getElevation() {
    if (_empty) return 0.0;
    return 12.0;
  }

  Color _getBackgroundColor() {
    if (_empty) return Colors.black;
    return Colors.red;
  }

  Color _getOverlayColor() {
    if (_isDestination || _selected) return Colors.white.withOpacity(.5);
    return Colors.transparent;
  }

  bool get _isDestination =>
      destinations.map((e) => e.destination).contains(cell.index);

  bool get _selected => cell.index == selectedIndex;

  bool get _empty => cell.empty;
}
