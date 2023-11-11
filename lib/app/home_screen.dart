import 'package:flutter/material.dart';
import 'package:note_app_withphpapi/app/components/cardnote.dart';
import 'package:note_app_withphpapi/app/components/crud.dart';
import 'package:note_app_withphpapi/app/constants/linkapi.dart';
import 'package:note_app_withphpapi/app/note/editnote.dart';
import 'package:note_app_withphpapi/main.dart';
import 'package:note_app_withphpapi/model/notemodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Crud {
  ///هاي الويذ عشان بدل ما اعمل انستنس بس لازم اعملو ميكسين كلاس الكرود
  getNotes() async {
    var response = await postRequest(linkViewNote, {
      "id": "${sharedPreferences.getString("id")}",

      ///بودي الايدي للريكويست من خلال الشيرد بريف منا حفظت فيه الايدي طول ما هو مسجل دخول
    });
    // print(response);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Home weclome user test ci anth test"),
        actions: [
          IconButton(
              onPressed: () {
                sharedPreferences.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnote");
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
                future: getNotes(),

                ///هاي الفنكشن الفيوتشر اللي رح تجيب المعلومات من الداتا بيز
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    ///او بنعملها سويتش كيسيز بناءا حلى حالة الريكويست زي مشروع الافلام
                    if (snapshot.data['status'] == 'fail') {
                      return const Center(
                        child: Text(
                          "لا يوجد ملاحظات",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data['data'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: CardNote(
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditNote(
                                      note: snapshot.data['data'][index])));
                            },
                            // title: snapshot.data['data'][index]['note_title'], ///بعد ما ضفنا المودل بطل هيك اوديهم شوف تحتيهم كيف بستقبلهم من الداتا بيز بدون ما اعرف اسم الكولم بالزبط
                            // content: snapshot.data['data'][index]['note_content'],
                            noteModel: NoteModel.fromJson(

                                ///هسا بمررلو كود الجسون وهو بزبطه وبعملو اوبجكت دارت
                                snapshot.data['data'][index]),
                            note: snapshot.data['data'][index]['note_title'],
                            swipDelete: (direction) async {
                              ///عادي بقدر استخدم البوست دغري لاني عامل ميكسين مع كلاس الكرود
                              var response = await postRequest(linkDeleteNote, {
                                "id": snapshot.data['data'][index]['note_id']
                                    .toString(),
                                "imagename": snapshot.data['data'][index]
                                    ['note_image'],

                                ///عشان يحذف الصورة من السيرفر عملنا ريكويست بالديليت بالسيرفر بوخذ اسم الصور
                                ///ف بوديلو اسم الصورة وهو بفلترها وبمسحها

                                ///الايدي هون اللي ببعثو هوه انتجر والبوست ريكويست بدها سترينج بحولو
                              });
                              if (response['status'] == "success") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.blue,
                                    content: Text('تم حذف الملاحظة'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                setState(() {
                                  ///عشان لما يعمل سيت ستيت يعني يعيد الواجهة يحذف اللي اخترنا نحذفو ويعيد البناء
                                  ///عشان ما تظهر مشاكل لاني بالسيت ستيت ليش عاملها عشان احدث اللي صار واحذف اللي انحذف من الواجهة
                                  snapshot.data['data'].removeAt(
                                      index); // تحديث القائمة بإزالة العنصر بالمؤشر المحدد (index)
                                });
                              }
                            },
                          ),
                        ) /*Text("${snapshot.data['data'][index]['note_title']}")*/;

                        ///كان هون المشكلة انو الاندكس مرفوض لاني انا كنت بال ابي اي بعمل فيتش بس هيك بوخذ رو واحد
                        ///لما غيرتها ل فيتش اوولل صار بجيب كل الداتا وبتكون هيك اوبجكت الداتا جواتو ليست اوف ماب ف بقدر اعمل اندكس ل عناصر الداتا
                        ///اللي همه النوت لانو بكون للمستخدم اكثر من نوت وده هيك بجيبهم كلهم
                      },
                    );
                    //
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    ///هوه بحتاج وقت ل يجيب البيانات من الدااتا بيز ف هاي يعني اثناء هاض الوقت شو اعمل
                    return const Center(
                      child: Text("LOading ..."),
                    );
                  }
                  return const Center(
                    child: Text("LOading ..."),
                  );

                  ///ولو مش بيجيب بيانات ولا جاب ف اظهر هاي لانو بكون في مشكلة
                  ///هاي للاحتياط بس عشان ما يوقف يعمل ايرور وعالاغلب ما رح تتحقق هاي
                }),
          ],
        ),
      ),
    );
  }
}
