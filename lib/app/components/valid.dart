import 'package:note_app_withphpapi/app/constants/message.dart';

validInput (String val , int min , int max){
  ///بوديلو القيمة االي بدو يفحصها بالفال والمين هيه اقل قيمه يقبلها والماكس اكبر قيمه يقبلها
  ///طبعا بتقدر تعمل غيرها لل ايميل او الباس او الخ الخ
  ///يتحقق الصيغة صح الكلمة ضعيفه او قوية الخ الخ

  if(val.isEmpty){
    return "$messageInputEmpty";
  }
  else if(val.length < min){
    return "$messageInputMin $min";
  }
  else if(val.length > max){
    return "$messageInputMax $max";
  }





}