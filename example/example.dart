import 'package:alm/alm.dart';

void main() {
  print(Alm.version);
  //...
  ///
  print('#first check map not null');
  print(Alm.isMap({})); //true
  print(Alm.isMap([])); //false
  print(Alm.isMap(null)); //false

  print('#check keys');
  print(Alm.isMap({'alm': 1}, 'alm')); //true
  print(Alm.isMap({'alm': 1, 'foo': 3}, ['alm', 'foo'])); //true
  print(Alm.isMap({'alm': 1}, 'slm')); //false

  print('#check one key and value');
  print(Alm.isMap({'alm': 2}, 'alm', 2)); //true
  print(Alm.isMap({'alm': 3}, 'alm', 3.1)); //false

  //...
  print(Alm.timestamp());
}
