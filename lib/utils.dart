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
    var milliseconds = ((this % 1000) / 100).toString(),
        seconds = ((this / 1000) % 60).floor().toString(),
        minutes = ((this / (1000 * 60)) % 60).floor().toString(),
        hours = ((this / (1000 * 60 * 60)) % 24).floor().toString();

    hours = (int.parse(hours) < 10) ? "0" + hours : hours;
    minutes = (int.parse(minutes) < 10) ? "0" + minutes : minutes;
    seconds = (int.parse(seconds) < 10) ? "0" + seconds : seconds;

    var result = hours == '00'
        ? minutes + ":" + seconds
        : hours + ":" + minutes + ":" + seconds;

    return result;
  }
}
