import 'dart:core';

double valueFromPercentageInRange(
    {required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

extension msToTime on int {
  String msTomt() {
    var milliseconds = ((this % 1000) / 100),
        seconds = ((this / 1000) % 60).floor(),
        minutes = ((this / (1000 * 60)) % 60).floor(),
        hours = ((this / (1000 * 60 * 60)) % 24).floor();

    // hours = (hours < 10) ? "0" + hours.toString() : hours.toString();
    // minutes = (minutes < 10) ? "0" + minutes : minutes;
    // seconds = (seconds < 10) ? "0" + seconds : seconds;

    return '2'; //hours + ":" + minutes + ":" + seconds + "." + milliseconds;
  }
}
