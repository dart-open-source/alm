import 'package:alm/alm.dart';

void main() async{

  print('Alm.isWeb:${Alm.isWeb}');
  await Alm.delaySecond(3,(){
    print('Alm.delaySecond:${Alm.isWeb}');
  });


//  group('A group of tests', () async {
//    test('First Test', () {
//      expect(1, 1);
//    });
//  });
}
