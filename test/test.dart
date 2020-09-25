import 'package:alm/alm.dart';

void main() async{

  print('Alm.isWeb:${Alm.isWeb}');
  await Alm.delaySecond(3,(){
    print('Alm.delaySecond:${Alm.isWeb}');
  });


  print(Alm.timedate(1600927797153-10143415));

//  group('A group of tests', () async {
//    test('First Test', () {
//      expect(1, 1);
//    });
//  });
}
