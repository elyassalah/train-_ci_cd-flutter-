import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

///هاي السترينج عبارة عن متغير اسمو هيك بنحط فيه نوع الاوث االلي عملناه وكان بيسك وبعدين بنحط اليوزر والباس اللي عملناه بالابي اي
String _basicAuth = 'Basic' + 
    base64Encode(utf8.encode(
      'salah:hbebeyaba'
    ));
///وهاي الماب فيها الهيدر تبعي لشو هوه للاوث بحطو وشو قيمتو النوع واليوزر والباس بعطيه اياهن
Map<String , String> myheaders = {
  'authorization' : _basicAuth
};
//وهسا بنضيف المتغيرات بالبوست ريكويست بالهيدرز وهي بتقبل ماب

mixin class Crud {
  //للتعامل مع الريكويستات ب انواعها جيت وبوست ومشتقاتهن ابديت ديليت وهكذا
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response
            .body); //عشان يعمل ديكود للريسبونس اللي جاي يفكو ويحولو ل دارت وهو رح يجي ب جسون انا هيك رح اعملو
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }



  postRequest(String url , Map data) async {
    try {
      var response = await http.post(Uri.parse(url) , body: data, headers: myheaders  ); //عشان امرر الداتا اللي بدو يوديها الايميل الباس وهيك للبودي
      if (response.statusCode == 200) {
        var responsebody = jsonDecode( ///برضو عشان يعمل ديكود للجاي ب جسون واشوف شو النتيجة مهي رح تيجي جسون
            response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  ///بدنا فنكشن جديده لرفع الملفات لانو البوست والجيت ما برفعو ملفات

  postRequestWithFile(String url , Map data , File file)async{
    var request = await http.MultipartRequest("POST" , Uri.parse(url) ); ///استخدمنا هون الملتي بارت ريكويست لانو هاي لرفع الملفات
    ///اول اشي بتوخذ طريقة الارسال وبتكون بهاي الحاله بوست وثاني اشي بتوخذ اللينك
    ///واللينك بدو يكون من نوع يو ار اي ف بنعملو ودوت بارس لليو ار ال الخاص بالصفحة اللي بوديه للفنكشن
    var length =  await file.length(); //عملنا اوايت عليها لانو اللينث نوعها فيوتشر ف كان في ايرور
    var stream = http.ByteStream(file.openRead());//اوبن ريد عشان يبدأ بعمليه القراءه
    var multipartFile = http.MultipartFile("file" , stream , length ,
        filename: basename(file.path)
    );///بنعمل هاض المتغير من اجل التعامل مع الصورة وبكون ملتي بارت فايل
    ///وهاض الملتي بارت فايل بوخذ ثلث متغيرات
    ///الاول اسم الريكويست اللي بدو يتم ارسالو وبستقبلو من الابي اي زي ما انا مسميه
    ///ثانيا بدو البايت ستريم وهو احنا بحاجه ل اللينث الخاص بالملف والستريم الخاص بالملف بعملهم متغيرات
    ///الستريم وهي تدفق البيانات
    ///بعدين بدو اسم الملف وبنحصل عليه من خلال البيس نيم وهي بدها استدعي مكتبة الباث دوت دارت
    ///وهاي الباس نيم مهمتها تجيبلي الاسم من المسار الخاص بالملف  والاسم بكون هوه اخر جزء من المسار اسم ومعو دوت دارت
    ///ف بعطيها الباث تبع الفايل وهي بتعطيني اسمو
    request.headers.addAll(myheaders); //وهون برضو بحملو الهيدر للريكويست اللي عملتو لانو كان ملتي بارت ريكويست


    //هسا بدي احمل الملف على الريكويست اللي رايح عالسيرفر من ميثود اللي هيه مع الريكويست فايلز دوت ادد
    request.files.add(multipartFile);//وهي بتوخذ الملتي بارت فايل اللي عملناه
    ///يعني زي كأنو الريكويست اللي رايح للسيرفر ليست وانا بقلو حمل معك الملف ادد
    ///لكن اانا مش بس بدي ارفع ملف برضو بدي ارفع داتا مع الريكويست اللي هنه العنوان والمحتوى تبع الملاحظة ف بعمل هيك
    data.forEach((key, value) { ///هاض هيك عشان تكون داينمك مش انا ادخل العناصر ب ايدي
      ///عشان استخدمها ب اي تطبيق ف هون بتعمل لفة عكل عناصر الداتا وبترفع وحده وحده مع الكي والفاليو تبعونها اللي جايات من الداتا لانها ماب الداتا
      request.fields[key] = value;

    });
    //هسا اخر اشي ارسال الريكويست
    var myRequest = await request.send();

    var response = await http.Response.fromStream(myRequest) ; //بدي اجيب الريسوبنس
    ///فرووم ستريم لانو السيند هوه عمليه ستريم يعني عمليه ارسال للبيانات ف باخض الريكويست منو  اللي هوه الماي ريكويست

    if(myRequest.statusCode == 200){
      return jsonDecode(response.body);

    }else {
      print("Error ${myRequest.statusCode}");
    }
    ///TODO عشان استخدمها بروح عالاد نوت وببدل البوست ريكويست مع بوست ويذ فايل وبنكمل
  }

}
