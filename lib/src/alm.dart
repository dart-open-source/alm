
class Alm{
  static String version = '1.0.0';
  static bool isWeb = identical(0, 0.0);

  static String type([dynamic o]){
    if(o==null) return 'null';
    return '${o.runtimeType}';
  }
  static bool notNull(dynamic o) =>o!=null;
  static bool notNullMap(dynamic o,[dynamic key,dynamic val]){
    var res=o!=null&&isMap(o);
    if(res&&key!=null){
      if(isList(key)){
        for(var k in key) {
          if(!o.containsKey(k)) return false;
        }
      }else{
        if(val!=null) return o.containsKey(key)&&o[key]==val;
        return o.containsKey(key);
      }
    };
    return res;
  }
  static bool notNullList(dynamic o) =>o!=null&&isList(o);
  static bool notNullString(dynamic o) =>o!=null&&isString(o);

  static bool isMap(dynamic o) =>o is Map;
  static bool isList(dynamic o) =>o is List;
  static bool isString(dynamic o) =>o is String;
}
