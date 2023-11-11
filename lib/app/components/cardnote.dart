import 'package:flutter/material.dart';
import 'package:note_app_withphpapi/app/constants/linkapi.dart';
import 'package:note_app_withphpapi/model/notemodel.dart';

class CardNote extends StatelessWidget {
  final note;
  final void Function()? ontap;
  // final String title; ///بعد ما عملنا المودل بطل الهم داعي هذول
  // final String content;
  final NoteModel noteModel;
  final void Function(DismissDirection)? swipDelete;
  const CardNote({super.key, required this.ontap, required this.note, required this.swipDelete, required this.noteModel});

  @override
  Widget build(BuildContext context) {
    return InkWell( //عشان لما اكبس عالملاحظة يوديني على مكان تعديل وقراية وهيك
      onTap: ontap,
      overlayColor: MaterialStateColor.resolveWith((states) => Colors.blue),

      child: Material(
        elevation: 4, // قيمة الظل
        borderRadius: BorderRadius.circular(8), // تقوم بتدوير الحواف لتعطي شكل منحني
        child: Dismissible( ///هاي بتسمحلي اللي برابو فيها يكون بقدر احركو يمين وشمال
          key: Key("${noteModel.noteTitle}"), ///هاي الكي تبعت اللي بدي احركو عشان اميزو اخذت التايتل هيو استقبلو فوق فاينل
          onDismissed: swipDelete , ///عشان شو يعمل فنكشن بس تحركو بعطيه اياه من الهوم
          direction: DismissDirection.startToEnd,///كيف تكون اتجاه الحركة
          background: Container( //ديزاين الباك تبع لما يزيح الكارد شو يبين وهكذا

            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.0), ///عشان يكون بعيد  و عقد الكارد مش ل اخر الشاشة لما ازيح يبين الاحمر
            decoration: BoxDecoration(
              color:Colors.red,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(
              Icons.delete,
              color: Colors.white,

            ),
          ),
          child: Card(
            elevation: 0, // قيمة الظل للكارد تكون صفر لكي لا يكون هناك فاصل
            // margin: EdgeInsets.all(20), // لجعل الحواف بدون فاصل حاليا بتأثرش لو لغيتها
            ///لاني بعدتهم عن بعض بالهوم عملت راب بادنج لليست بيلدر
            ///هيه هاي عشان تعمل قديش حجم الكارد من جميه الجهات قديش تبعد اذا اوول او سيمترك وهكذا بتحدد
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // تدوير الحواف لتطابق الـ Material
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Image.network(
                    ///وهون بنلغي الاسيت لانها الاسيت اذا الصورة جوا الابلكيشن بس اذا عالسيرفر فهي نيتورك
                    "$linkImageRoot/${noteModel.noteImage}",
                    /*"assets/logo.png",*/ ///بجي اخلي الصورة اللي رفعها تبين لذلك بدنا نروح على اللينكات ونضيف اللينك تبع الصورة والاسم بوخذو من النوت موديل لانو
                    ///لما رفعنا الصورة مسكنا اسمها بالداتا بيز ف بضيفو مع اللينك عشان يجيبها
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text("${noteModel.noteTitle}"),
                      subtitle: Text("${noteModel.noteContent}"),
                      // trailing: ,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
