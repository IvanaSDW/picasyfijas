class PlayerSoloStats {
  int qtyMatches = 0;
  double timeAverage = 0.0;
  double guessesAverage = 0.0;
  int timeRank = 0;
  int guessesRank = 0;

  PlayerSoloStats(this.qtyMatches, this.timeAverage, this.guessesAverage,
      this.timeRank, this.guessesRank);

  PlayerSoloStats.blank();

}