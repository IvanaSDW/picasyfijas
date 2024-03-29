class PlayerStats {
  int soloGamesCount = 0;
  double timeAverage = 0.0;
  double guessesAverage = 0.0;
  int timeRank = 0;
  int guessesRank = 0;
  int soloWorldRank = 0;
  int vsGamesCount = 0;
  int vsGamesWon = 0;
  int vsGamesDraw = 0;
  int vsGamesLost = 0;
  double vsWinRate = 0;
  int vsWorldRank = 0;
  double vsPercentile = 0;
  int rating = 0;
  bool isRated = false;

  PlayerStats(this.soloGamesCount, this.timeAverage, this.guessesAverage,
      this.timeRank, this.guessesRank, this.soloWorldRank, this.vsGamesCount,
      this.vsWinRate, this.vsWorldRank, this.vsGamesWon, this.vsGamesDraw,
      this.vsGamesLost, this.vsPercentile, this.rating, this.isRated,
      );

  PlayerStats.blank();

}