enum DataType {
  chat,
  movement,
  start,
  whiteFlag,
  disconnectedPair;

  int toMap() => DataType.values.indexOf(this);

  static DataType fromMap(int index) => DataType.values[index];

  bool equals(DataType other) => this == other;
}
