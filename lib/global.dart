import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'data/random.data.dart';

const bool isWeb = identical(0, 0.0);

int any2int(dynamic o) {
  try {
    return int.parse(o.toString().split('.').first);
  } catch (e) {
    return 0;
  }
}

double any2double(dynamic o) {
  try {
    return double.parse(o.toString());
  } catch (e) {
    return 0.00;
  }
}

String priceStr(dynamic o) {
  var od = any2double(o);
  return '\$' + od.toStringAsFixed(2);
}

String int2hex(int n, {int padLeft = 8}) {
  return n.toRadixString(16).padLeft(padLeft, '0');
}

DateTime timedate([Duration duration]) {
  if (duration != null) {
    var isAdd = duration > Duration.zero;
    if (isAdd) {
      return DateTime.now().add(duration);
    } else {
      return DateTime.now().subtract(duration);
    }
  }
  return DateTime.now();
}

String timestampStr([dynamic duration]) {
  return timestamp(duration).split('.').first;
}

String timestamp([dynamic duration]) {
  if (duration is Duration) {
    return timedate(duration).toString();
  }
  if (duration is int) {
    return DateTime.fromMicrosecondsSinceEpoch(duration).toString();
  }
  return timedate().toString();
}

String timeymd([Duration duration]) {
  return timedate(duration).toIso8601String().split('T').first;
}

int timeint([Duration duration]) {
  return timedate(duration).millisecondsSinceEpoch;
}

Duration timediff([int start, int end]) {
  var origin = end ?? timeint();
  var res = Duration(milliseconds: (origin - start));
  if (res == Duration.zero) return Duration(milliseconds: 1);
  return res;
}

class Timero {
  int start;

  Timero() {
    start = timeint();
  }

  bool isTimeOut(int second) => timediff(start) > Duration(seconds: second);
}

int duration2time(String input) {
  return DateTime.parse('${timeymd()} $input').millisecondsSinceEpoch;
}

String str2md5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

String strcut(String input, {int len}) {
  if (len != null) return input.substring(0, min(len, input.length));
  return input;
}

Future<void> delayed(Duration duration) async {
  await Future.delayed(duration);
}

String fileNameStarReset(String string) {
  for (var i = 0; i < 20; i++) {
    string = string.replaceAll('****', '***');
  }
  return string;
}

String convertBytes(int size) {
  var Kb = 1024;
  var Mb = Kb * 1024;
  var Gb = Mb * 1024;
  var Tb = Gb * 1024;
  var Pb = Tb * 1024;
  if (size < Kb) return size.toString() + 'B';
  if (size < Mb) return (size / Kb).toStringAsFixed(2) + 'KB';
  if (size < Gb) return (size / Mb).toStringAsFixed(2) + 'MB';
  if (size < Tb) return (size / Gb).toStringAsFixed(2) + 'GB';
  if (size < Pb) return (size / Tb).toStringAsFixed(2) + 'TB';
  return (size / Pb).toStringAsFixed(2) + 'PB';
}

String cutStr(String input, int len) {
  return input.substring(0, min(input.length, len));
}

T mapCast<T>(dynamic value) {
  T res = jsonDecode(jsonEncode(value));
  return res;
}

randomKey(Map map) => map.keys.elementAt(kRandom.nextInt(map.length));

randomMapElement(Map map) => map[randomKey(map)];

randomListElement(List list) => list.elementAt(kRandom.nextInt(list.length));

Iterable _randomList(List list) sync* {
  var keys = list;
  var rnd = new Random();
  while (keys.length > 0) {
    var index = rnd.nextInt(keys.length);
    var key = keys[index];
    keys[index] = keys.last;
    keys.length--;
    yield key;
  }
}

List randomList(List list) {
  return _randomList(list).toList();
}

String str2base64(String input) {
  return base64Encode(utf8.encode(input));
}

String base642str(String input) {
  return utf8.decode(base64Decode(input));
}

String prettyJson(Map<String, dynamic> json, {int indent = 2}) {
  var spaces = ' ' * indent;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

num degToRad(num deg) => deg * (pi / 180.0);

String sixDigits(int n) {
  if (n >= 100000) return "$n";
  if (n >= 10000) return "0$n";
  if (n >= 1000) return "00$n";
  if (n >= 100) return "000$n";
  if (n >= 10) return "0000$n";
  return "00000$n";
}

String durationFormat(Duration duration) {
  var str = duration.toString();
  str = str.substring(0, str.length - 4);
  final list = str.split(":");
  list.removeAt(0);
  return list.join(":");
}

kNum(int ip) {
  double size = ip / 1.0;

  double m = size / 1000000;
  double w = size / 10000;
  double k = size / 1000;

  if (m >= 1) return m.toStringAsFixed(2) + "m";
  if (w >= 1) return w.toStringAsFixed(2) + "w";
  if (k >= 1) return k.toStringAsFixed(2) + "k";
  return ip.toString();
}

String getFormattedTime(int totalSeconds) {
  if (totalSeconds < 0) {
    return "00:00:00";
  }
  int remainingHours = (totalSeconds / 3600).floor();
  int remainingMinutes = (totalSeconds / 60).floor() - remainingHours * 60;
  int remainingSeconds = totalSeconds - remainingMinutes * 60 - remainingHours * 3600;
  return remainingHours.toString().padLeft(2, '0') + ":" + remainingMinutes.toString().padLeft(2, '0') + ":" + remainingSeconds.toString().padLeft(2, '0');
}

String dateDiff(DateTime tm) {
  DateTime today = DateTime.now();
  Duration oneDay = Duration(days: 1);
  Duration twoDay = Duration(days: 2);
  Duration oneWeek = Duration(days: 7);
  String month;
  switch (tm.month) {
    case 1:
      month = "january";
      break;
    case 2:
      month = "february";
      break;
    case 3:
      month = "march";
      break;
    case 4:
      month = "april";
      break;
    case 5:
      month = "may";
      break;
    case 6:
      month = "june";
      break;
    case 7:
      month = "july";
      break;
    case 8:
      month = "august";
      break;
    case 9:
      month = "september";
      break;
    case 10:
      month = "october";
      break;
    case 11:
      month = "november";
      break;
    case 12:
      month = "december";
      break;
  }

  Duration difference = today.difference(tm);

  if (difference.compareTo(oneDay) < 1) {
    return "today";
  } else if (difference.compareTo(twoDay) < 1) {
    return "yesterday";
  } else if (difference.compareTo(oneWeek) < 1) {
    switch (tm.weekday) {
      case 1:
        return "monday";
      case 2:
        return "tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "thurdsday";
      case 5:
        return "friday";
      case 6:
        return "saturday";
      case 7:
        return "sunday";
    }
  } else if (tm.year == today.year) {
    return '${tm.day} $month';
  } else {
    return '${tm.day} $month ${tm.year}';
  }
  return "";
}

String timestampRan({Duration after = Duration.zero}) {
  int i = DateTime.now().millisecondsSinceEpoch - after.inMilliseconds;
  int dif = i - Duration(days: kRandom.nextInt(360)).inMilliseconds + kRandom.nextInt(1000);
  return DateTime.fromMillisecondsSinceEpoch(dif).toString();
}

final kRandom = Random(DateTime.now().millisecondsSinceEpoch);

String randomString(int length) {
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  final buf = StringBuffer();
  for (var x = 0; x < length; x++) {
    buf.write(chars[kRandom.nextInt(chars.length)]);
  }
  return buf.toString();
}

String randomName() => randomListElement(randomDataFirstNames) + ' ' + randomListElement(randomDataLastNames);

String randomCountry() => randomListElement(randomDataCountries);

String randomBahamaArea() => randomListElement(randomDataBahamaAreas);

String randomAddress() => '#${kRandom.nextInt(9999)} ${randomBahamaArea()}';

String tokenGen(String pass, {Duration duration}) {
  var time = duration ?? Duration(days: 7);
  return str2base64([pass, time.inMilliseconds, timeint()].join(':'));
}

bool tokenExpired(String token) {
  try {
    var tokens = base642str(token).split(':');
    var now = timeint();
    var expire = int.parse(tokens[1]);
    var time = int.parse(tokens[2]);
    return (now - time) < expire;
  } catch (e) {
    return false;
  }
}
Map tokenDecode(String token) {
  try {
    var res={};
    var tokens = base642str(token).split(':');
    res['pass'] = tokens[0];
    res['now'] = timeint();
    res['expire'] = int.parse(tokens[1]);
    res['time'] = int.parse(tokens[2]);
    return res;
  } catch (e) {
    return null;
  }
}

int lerpInt(int minV, int maxV, int value) {
  return max(minV, min(value, maxV));
}

String firstUpperCase(String str) {
  if (str.length > 1) return (str.substring(0, 1).toUpperCase()) + str.substring(1);
  return str;
}

Map fromDataDecode(String elem) {
  var map = {};
  elem = elem.replaceAll('form-data; ', '');
  var list = elem.split(';');
  list.forEach((element) {
    var ls = element.split('=');
    map[ls.first.trim()] = ls.last.replaceAll('"', '').trim();
  });
  return map;
}

void gitIgnoreUpdate(String path) {
  if (File('.gitignore').existsSync()) {
    var liens = File('.gitignore').readAsLinesSync();
    if (!liens.contains(path)) {
      File('.gitignore').writeAsStringSync(
          [
            '',
            '#$path at ${timestampStr()}',
            path,
            '',
          ].join('\n'),
          mode: FileMode.append);
    }
  }
}
