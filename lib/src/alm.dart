import 'dart:convert';
import 'dart:io';

import 'dart:math';

import 'package:alm/data/data.dart';
import 'package:crypto/crypto.dart';

///
///
///
/// [Alm] dart lib for developers tool
///
///
class Alm {
  static String version = '1.0.0';

  static bool isWeb = identical(0, 0.0);

  static Future<dynamic> delaySecond([int second = 1, dynamic computation]) async => await Future.delayed(Duration(seconds: second), computation);


  @deprecated
  static var onTimeoutReturnNull = () => null;

  static var onTimeoutNull = () => null;

  ///
  ///=========================== Type ===========================
  ///

  static String type([dynamic o]) {
    if (o == null) return 'null';
    return '${o.runtimeType}';
  }

  static bool notNull(dynamic o) => o != null;

  static bool notNullMap(dynamic o, [dynamic key, dynamic val]) {
    var res = o != null && isMap(o);
    if (res && key != null) {
      if (isList(key)) {
        for (var k in key) {
          if (!o.containsKey(k)) return false;
        }
      } else {
        if (val != null) return o.containsKey(key) && o[key] == val;
        return o.containsKey(key);
      }
    }
    ;
    return res;
  }

  static bool notNullList(dynamic o) => o != null && isList(o);

  static bool notNullString(dynamic o) => o != null && isString(o);

  static bool isMap(dynamic o) => o is Map;

  static bool isList(dynamic o) => o is List;

  static bool isString(dynamic o) => o is String;

  static Map map(dynamic input){
    dynamic res;
    if(input is Map){
      res=input;
    }else if(input is String) {
      res=jsonDecode(input);
    }
    return res?Map.from(res):null;
  }

  ///
  ///=========================== File ===========================
  ///

  static int fileSize(File target, {int defaultSize = -1}) => target.existsSync() ? target.lengthSync() : defaultSize;

  File file(String path, {bool autoDir = false}) {
    var r = File(path);
    if (autoDir && !r.parent.existsSync()) r.parent.createSync(recursive: true);
    return r;
  }

  ///
  ///=========================== Random ===========================
  ///

  static Random kRandom = Random(DateTime.now().millisecondsSinceEpoch);

  static String randomString(int length) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final buf = StringBuffer();
    for (var x = 0; x < length; x++) {
      buf.write(chars[kRandom.nextInt(chars.length)]);
    }
    return buf.toString();
  }

  static String randomName() => randomListElement(Alm_DataNames) + ' ' + randomListElement(Alm_DataNames);

  static String randomCountry() => randomListElement(Alm_DataCountries);

  static dynamic randomKey(Map map) => map.keys.elementAt(kRandom.nextInt(map.length));

  static dynamic randomMapElement(Map map) => map[randomKey(map)];

  static dynamic randomListElement(List list) => list.elementAt(kRandom.nextInt(list.length));

  static Iterable _randomList(List list) sync* {
    var keys = list;
    var rnd = Random();
    while (keys.isNotEmpty) {
      var index = rnd.nextInt(keys.length);
      var key = keys[index];
      keys[index] = keys.last;
      keys.length--;
      yield key;
    }
  }

  static List randomList(List list) => _randomList(list).toList();

  ///
  ///=========================== Time ===========================
  ///

  static DateTime timedate([dynamic input]) {
    if (input != null) {
      if (input is Duration) {
        var isAdd = input > Duration.zero;
        if (isAdd) {
          return DateTime.now().add(input);
        } else {
          return DateTime.now().subtract(input);
        }
      }
      if (input is int) return DateTime.fromMillisecondsSinceEpoch(input);
      if (!(input is String)) throw Exception('Wops!? input only [int,duration,string]!!?@#@');
      return DateTime.parse(input);
    }
    return DateTime.now();
  }

  static String timestampStr([dynamic input]) => timestamp(input).split('.').first;

  static String timestamp([dynamic input]) => timedate(input).toString();

  static String timeymd([dynamic input]) => timedate(input).toIso8601String().split('T').first;

  static int timeint([dynamic input]) => timedate(input).millisecondsSinceEpoch;

  /// start only duration and millisecond
  static Duration timediff([dynamic start, int end]) {
    if (start is String) start = duration2time(start);
    var origin = end ?? timeint();
    var res = Duration(milliseconds: (origin - start));
    if (res == Duration.zero) return Duration(milliseconds: 1);
    return res;
  }

  static int duration2time(String input) => DateTime.parse('${timeymd()} $input').millisecondsSinceEpoch;

  static String convertTime(int ms, {int fixed = 2}) => (ms / 1000).toStringAsFixed(fixed) + 's';

  static String durationFormat(Duration duration) {
    var str = duration.toString();
    str = str.substring(0, str.length - 4);
    final list = str.split(':');
    list.removeAt(0);
    return list.join(':');
  }

  static String getFormattedTime(int totalSeconds) {
    if (totalSeconds < 0) return '00:00:00';
    var remainingHours = (totalSeconds / 3600).floor();
    var remainingMinutes = (totalSeconds / 60).floor() - remainingHours * 60;
    var remainingSeconds = totalSeconds - remainingMinutes * 60 - remainingHours * 3600;
    return remainingHours.toString().padLeft(2, '0') + ':' + remainingMinutes.toString().padLeft(2, '0') + ':' + remainingSeconds.toString().padLeft(2, '0');
  }

  static String timestampRan({Duration after = Duration.zero}) {
    var i = DateTime.now().millisecondsSinceEpoch - after.inMilliseconds;
    var dif = i - Duration(days: kRandom.nextInt(360)).inMilliseconds + kRandom.nextInt(1000);
    return DateTime.fromMillisecondsSinceEpoch(dif).toString();
  }

  ///
  ///=========================== Token ===========================
  ///

  static String tokenGen(String pass, {Duration duration}) {
    var time = duration ?? Duration(days: 7);
    return str2base64([pass, time.inMilliseconds, timeint()].join(':'));
  }

  static bool tokenExpired(String token) {
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

  static Map tokenDecode(String token) {
    try {
      var res = <String, dynamic>{};
      var tokens = base642str(token).split(':');
      if (tokens.length != 3) throw Exception();
      var now = timeint();
      var expire = int.parse(tokens[1]);
      var time = int.parse(tokens.last);

      res['time'] = time;
      res['pass'] = tokens.first;
      res['now'] = now;
      res['expire'] = expire;
      res['expired'] = (now - time) < expire;

      return res;
    } catch (e) {
      return null;
    }
  }

  ///
  ///=========================== Utilities|Convert|Math ===========================
  ///
  static int lerpInt(int minV, int maxV, int value) => max(minV, min(value, maxV));

  static num degToRad(num deg) => deg * (pi / 180.0);

  static String str2base64(String input) => base64Encode(utf8.encode(input));

  static String base642str(String input) => utf8.decode(base64Decode(input));

  static int any2int(dynamic o, {int defaultVal = -1}) => int.tryParse(o.toString().split('.').first) ?? defaultVal;

  static double any2double(dynamic o, {double defaultVal = -1.0}) => double.tryParse(o.toString()) ?? defaultVal;

  static String priceStr(dynamic o, {String defaultPre = '\$'}) => defaultPre + any2double(o).toStringAsFixed(2);

  static String int2hex(int n, {int padLeft = 8}) => n.toRadixString(16).padLeft(padLeft, '0');

  static String str2md5(String input) => md5.convert(utf8.encode(input)).toString();

  static String prettyJson(Map<String, dynamic> json, {int indent = 2}) {
    var spaces = ' ' * indent;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }

  static Map fromDataDecode(String elem) {
    var map = {};
    elem = elem.replaceAll('form-data; ', '');
    var list = elem.split(';');
    list.forEach((element) {
      var ls = element.split('=');
      map[ls.first.trim()] = ls.last.replaceAll('"', '').trim();
    });
    return map;
  }

  static void gitIgnoreUpdate(File gitignore, String path) {
    if (gitignore.existsSync()) {
      var liens = gitignore.readAsLinesSync();
      if (!liens.contains(path)) {
        gitignore.writeAsStringSync(['', '#$path at ${timestampStr()}', path, ''].join('\n'), mode: FileMode.append);
      }
    }
  }

  static bool needUpgrade(String old, String ver) {
    var upgrade = false;
    if (old != ver) {
      var nvl = ver.split('.');
      var ovl = old.split('.');
      if (nvl.length != ovl.length) {
        upgrade = true;
      } else {
        for (var i = 0; i < nvl.length; i++) {
          var nvln = any2int(nvl[i]);
          var ovln = any2int(ovl[i]);
          if (nvln > ovln) {
            upgrade = true;
            break;
          }
          if (nvln < ovln) break;
        }
      }
    }
    return upgrade;
  }

  static String kNum(int ip) {
    var size = ip / 1.0;

    var m = size / 1000000;
    var w = size / 10000;
    var k = size / 1000;

    if (m >= 1) return m.toStringAsFixed(2) + 'm';
    if (w >= 1) return w.toStringAsFixed(2) + 'w';
    if (k >= 1) return k.toStringAsFixed(2) + 'k';

    return ip.toString();
  }

  static String convertBytes(int size, {String format = 'PB', int fixed = 2}) {
    var Kb = 1024;
    var Mb = Kb * 1024;
    var Gb = Mb * 1024;
    var Tb = Gb * 1024;
    var Pb = Tb * 1024;
    if (size < Kb || format == 'B') return size.toString() + 'b';
    if (size < Mb || format == 'KB') return (size / Kb).toStringAsFixed(fixed) + 'kb';
    if (size < Gb || format == 'MB') return (size / Mb).toStringAsFixed(fixed) + 'mb';
    if (size < Tb || format == 'GB') return (size / Gb).toStringAsFixed(fixed) + 'gb';
    if (size < Pb || format == 'TB') return (size / Tb).toStringAsFixed(fixed) + 'tb';
    return (size / Pb).toStringAsFixed(fixed) + 'pb';
  }

  static String sixDigits(int n) {
    if (n >= 100000) return '$n';
    if (n >= 10000) return '0$n';
    if (n >= 1000) return '00$n';
    if (n >= 100) return '000$n';
    if (n >= 10) return '0000$n';
    return '00000$n';
  }

  static String strcut(String input, {int len}) {
    if (len != null) return input.substring(0, min(len, input.length));
    return input;
  }

  static String fileNameStarReset(String string) {
    for (var i = 0; i < 20; i++) {
      string = string.replaceAll('****', '***');
    }
    return string;
  }

  static String firstUpperCase(String str) {
    if (str.length > 1) return (str.substring(0, 1).toUpperCase()) + str.substring(1);
    return str;
  }
}
