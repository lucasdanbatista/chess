enum Direction {
  up(1, 0),
  upRight(1, 1),
  right(0, 1),
  downRight(-1, 1),
  down(-1, 0),
  downLeft(-1, -1),
  left(0, -1),
  upLeft(1, -1),
  upTwoRight(2, 1),
  upTwoLeft(2, -1),
  downTwoRight(-2, 1),
  downTwoLeft(-2, -1),
  rightTwoUp(1, 2),
  rightTwoDown(-1, 2),
  leftTwoUp(1, -2),
  leftTwoDown(-1, -2);

  final int row;
  final int column;

  const Direction(this.row, this.column);
}
