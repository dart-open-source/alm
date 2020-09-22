
class Alm{
  static bool isWeb = identical(0, 0.0);

  static String type([dynamic o]){
    if(o==null) return 'null';
    return '${o.runtimeType}';
  }
  static bool notNull(dynamic o) =>o!=null;
  static bool notNullMap(dynamic o,[dynamic key]){
    if(key!=null) return o!=null&&isMap(o)&&o.containsKey(o);
    return o!=null&&isMap(o);
  }
  static bool notNullList(dynamic o) =>o!=null&&isList(o);
  static bool notNullString(dynamic o) =>o!=null&&isString(o);

  static bool isMap(dynamic o) =>o is Map;
  static bool isList(dynamic o) =>o is List;
  static bool isString(dynamic o) =>o is String;
}
