// パーセントの算出
double setPercent(int smallPrice, int largePrice) {
  double calcResult = 0;
  double percent = 0;
  if (smallPrice != 0) {
    percent = smallPrice / largePrice * 100;
  } else {
    percent = 0;
  }
  calcResult = percent;
  return calcResult;
}
