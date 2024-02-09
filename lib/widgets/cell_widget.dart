import 'package:flutter/material.dart';

import '../entities/cell_entity.dart';
import '../entities/destination_entity.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    Key? key,
    required this.selectedIndex,
    required this.cell,
    required this.onTap,
    required this.destinations,
    required this.onCellDropped,
  }) : super(key: key);

  final int selectedIndex;
  final CellEntity cell;
  final List<DestinationEntity> destinations;
  final void Function(CellEntity) onTap;
  final void Function(CellEntity, CellEntity) onCellDropped;

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
        builder: (context, candidateData, rejectedData) {
          // final hasData = candidateData.isNotEmpty;
          return child;
        },
      );
    }

    if (_empty) return child;

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

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    super.key,
    this.color,
    this.child,
  });

  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
