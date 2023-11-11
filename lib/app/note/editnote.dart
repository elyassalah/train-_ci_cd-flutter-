import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app_withphpapi/app/components/crud.dart';
import 'package:note_app_withphpapi/app/components/customtextform.dart';
import 'package:note_app_withphpapi/app/components/valid.dart';
import 'package:note_app_withphpapi/app/constants/linkapi.dart';

///TODO advanced and more good request verification that content and title and photo still the same or be change
///this cause if still same that is not required to make request to the server!!!
class EditNote extends StatefulWidget {
  final note;
  EditNote({
    super.key, this.note,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}
class _EditNoteState extends State<EditNote> with Crud {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();

  final TextEditingController content = TextEditingController();
  final FocusNode focusNode = FocusNode();
  File? myfile;

  bool isLoading = false;
  editNote() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {
        //عشان تتحدث الايز لودنج
      });
      var response;
      if(myfile == null){///هاض الحكي عشان اشوف اذا رفع صورة او لا وبقلو في حال ما رفع صورة اعمل ريكويست بدون صورة وإلا
        ///وبنروح عالباك ايند وبنعمل نفس الشي بالايدت بنعدل
        response = await postRequest(linkEditNote, {
          "title": title.text,
          "content": content.text,
          "id": widget.note['note_id'].toString(), ///لانو رقم وانا بدي اياه سترينج
          "imagename": widget.note['note_image'].toString(),
        });

      }else{// و إلا في حال رفع صورة اعمل الريكويست مع فايل وببين رفع الصورة من الماي فايل اذا نل او لا
        response = await postRequestWithFile(linkEditNote, {
          "title": title.text,
          "content": content.text,
          "id": widget.note['note_id'].toString(), ///لانو رقم وانا بدي اياه سترينج
          "imagename": widget.note['note_image'].toString(),
        }, myfile!);

      }
      isLoading = false;
      setState(() {
        //عشان تتحدث الايز لودنج
        //بعد ما ينتهي الاوييت
      });
      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        ///TODO handle it
      }
    }
  }
  @override
  void initState() {
    title.text = widget.note['note_title'];
    content.text = widget.note['note_content'];
    ///TODO اذا بدي ابينلو الصورة هون بالايدن بديزينها بس باخذ قيمتها مع النوت اللي جبتها لما كبس على النوت واخذ التايتل والكونتن هون بالاينيت ستيت زي اللي فوقي
    ///ف باخذ اسم الصورة وبعمل ايمج نيتورك وبحطها وهيك بتبينلو الصورة عند التعديل عشان يشوفها اذا بدو وخلص بس هيك


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        backgroundColor: Colors.blue,
      ),

      ///يعني لو الايز لودنج بترو اعمل سيركل لو فولس اظهر الكونتينر
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    CustomTextFormSign(
                      hint: "title",
                      mycontroller: title,
                      valid: (val) {
                        return validInput(val!, 1, 40);
                      },
                    ),
                    CustomTextFormSign(
                      hint: "content",
                      mycontroller: content,
                      valid: (val) {
                        return validInput(val!, 10, 500);
                      },
                    ),
                    Container(height: 20),
                    MaterialButton(
                      onPressed: () {
                        focusNode.unfocus(); ///حطينا الان فوكس هون عند الضغظ على اختيار صورة ولو بدنا عند اي مكان بقدر احط
                        ///وربطنا الفوكس بالكست فورم وعملنا متغير الفوكس هون و و ديناه للكستم فورم تيع الكونتنت لانو اخر اشي بعبيه
                        ///وهيك بسكرو الكيبورد لما يبكس اخيتار صورة
                        ///ممكن تكون الصورة من الاستديو او الكاميرا ف شوف شو بدنا نعمللو
                        showModalBottomSheet(
                          ///هاي لائحة بتطلعلو بالاسفل تحت وبختار منها اذا كاميرا او استديو
                          context: context,
                          //backgroundColor: Colors.white,

                          builder: (context) => Container(
                            //color: Colors.white,
                            height: 100,
                            //width: double.infinity, //بطل في داعي للويدث للكونتينر لانو العناصر اللي بالرو اكسبانديد
                            //لانها اكسبانديد بتوخذ كل مساحه الكونيتنر المسموحه وبتقسهمها على عناصر الرو بنائا على الفلكس
                            child: Row(
                              //mainAxisSize: MainAxisSize.max, // To make the column take the minimum height necessary

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Text('This is a sample text inside the bottom sheet.'),
                                Expanded(
                                  ///عشان يوخذو العناصر كلها بالرو نفس المساحه بالاعتماد الفلكس اللي بحددو لكل وحده انا مخليه متساوي
                                  flex: 1,
                                  child: SizedBox(
                                    ///عشان اخلي الارتفاع تبع الكبسة والظل ارتفاعو على قد ارتفاع الكونتينر عشان لما اكبس ما يصير فراغ بالظل
                                    height: 100,
                                    child: InkWell(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(26)),

                                      ///عشان الظل تبع الكبسة لما تكبس يكون الكريف تبعو نفس المودل بوتم شيت
                                      onTap: () async {
                                        //متغير نوعو فايل عشان احط فيه الصورة واوديه للسيرفر
                                        //وممكن يكون نل ولو كان نل بحط صورة افتراضيه من عندي
                                        XFile? xFile = await ImagePicker()
                                            .pickImage(
                                            source: ImageSource.gallery);
                                        Navigator.of(context).pop(); //عشان يلتغي البوتم شيت مباشرة بعد ما يفتح الاستديو ما يضل موجود

                                        ///هيك عشان يمسك الصورة من الاستوديو اللي بختارها

                                        ///هسا بدنا متغير من نوع فايل بس الفايل اللي من دارت اي او مش دارت اتش تي ام ال لانو هاض الاتش تي ام ال
                                        ///بستخدمو لما بدي ارفع صورة على فلاتر ويب مش موبايل
                                        ///وخلي جلوبل عشان بدي استخدمو ب اكثر من مكان
                                        myfile = File(xFile!.path);
                                        // focusNode.focusInDirection(TraversalDirection.down);

                                        setState(() {});///هون بنعمل السيت ستيت عشان يرفرش الصفحة بعد ما يختار صورة ونخزنها بالماي فايل عشان يتغير لون الكبسة
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        child: const Icon(
                                          Icons.image,
                                          size: 40,
                                          color: Colors.blue,
                                        ), //عشان ما يكونو ملزقين ببعض
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  //width: 50,
                                  //بطل الو داعي لاني خليهم الايقونتين ايكسبانديد
                                  ///واعطيت كل وحده فلكس ع قد الثانيه ف الرو بتقسم على قدهم بالزبط كل وحده بتوخ مساحه نفس الثانيه
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 100,
                                    child: InkWell(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(26)),

                                      ///عشان الظل تبع الكبسة يكوون الكريف تبعو نفس المودل بوتم شيت
                                      onTap: () async {
                                        XFile? xFile = await ImagePicker()
                                            .pickImage(
                                            source: ImageSource
                                                .camera); //بمسك فيه الصورة اللي بصورها بالكاميرا
                                        Navigator.of(context).pop();//برضو عشان يلتغي البوتم شيت بعد ما يختار صورة ما يضل مبين
                                        myfile = File(xFile!.path);
                                        // focusNode.focusInDirection(TraversalDirection.down);
                                        /// هون قبل السيت ستيت بسكرو الكيبورد بعد ما اختار صورة ورجع للصفحة الاد,, هيك زبط استخدمت الفوكس دايركشن وعملتو داون
                                        /// هيك بنزل الكيبورد بعد ما يختار صورة
                                        /// بس هو فعليا هيك خلا الكبيورد اسفل يعني خلى التركيز على الواجهة اللي كانت تحتو وهو صار تحت هاي الواجهة فهمت كيف صارت العمليه
                                        /// ومش هاض اللي بدنا ااياه هسا بنشوف حل افضل
                                        /// الحل المثالي اللي بسكر الكيبورد مش بخليه وبعمل فوكس عالويدجت اللي تحتو انو اعمل ان فوكس
                                        /// ف عملنا الان فوكس عند الضغط على اختيار صورة وهيك بسكرو تمام بدون مشاكل

                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                          color: Colors.blue,
                                        ), //عشان ما يكونو ملزقين ببعض
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text("Chose Image"),
                      textColor: Colors.white,
                      color: myfile == null ? Colors.blue : Colors.green, ///عشان اذا اختار صورة نحول لون الكبسة ل اخضر
                      ///بس هيك بدو يصير ريفرش عشان يتغير اللون ف بنعمل سيت ستيت وهي بتعمل رفرش كامل للصفحة
                      ///بنحط السيت ستيت بعد ما اختار صورة وحطيناها بالماي فايل ف بنعمل ثنتين وحده بعد الاختيار من الكمرا و وحده بعد الاختيار من الاستديو
                    ),
                    Container(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await editNote();
                      },
                      child: Text("Save"),
                      textColor: Colors.white,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
