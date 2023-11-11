
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:note_app_withphpapi/app/components/crud.dart';
import 'package:note_app_withphpapi/app/components/valid.dart';
import 'package:note_app_withphpapi/app/constants/linkapi.dart';
import 'package:note_app_withphpapi/main.dart';

import '../components/customtextform.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ///TODO Loading while login in progress but in stateManagement better than setState
  final Crud _crud = Crud();
  GlobalKey<FormState> formstate1 = GlobalKey();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();
  login()async{

    if(formstate1.currentState!.validate()){
      var response =  await _crud.postRequest(linkLogin, {
        "email": email.text,
        "password" : password.text
      }); ///نوع بوست لانو الصفحة البي اتش بي تبعت الساين اب بتستقبل ريكويست من نوع بوست انا هيك عملتها
      ///والبوست بنستخدمها مع الانسيرت والابديت والديليت
      if(response['status'] == "success"){
        ///استقبلت بالريسبونس داتا لحال انا لاني السيليكت بال ابي اي انا عامل يرجع الايدي ف بس رح يرجع الايدي
        ///لو برجع اكثر من شغله بالداتا بعمل كمان قوسين وبحط الاشي اللي بدي اخذو بين سنجل كوت
        sharedPreferences.setString("id", response['data']['id'].toString() ); ///بحفظ بالشيرد برف شغله عند تسجيل الدخول وبفحصها طول ما هي موجوده بوديه عالهوم اذا انحذفت وقت عمل تسجيل خروج
        //هون كان في مشكلة لاني بحط بالشيرد ماب اللي جوا الداتا لانو الداتا بترجع ماب
        //ف انا بفوت عالي جوا الداتا باخذ قيمة الايدي وبحطها بالشيرد وتو ستريج
        //عشان بالهوم بيج لما اودي للريكويست الايدي اللي بالشيرد بريف بدو يوخذو سترينج وهيك بتنحل
        ///وقتها بوديه عال لوج ان
        //انا عامل برضو بالنجاح يرجع ستاتس سكسس ف بفحصها
        //print(sharedPreferences.getString("id"));
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false); ///فولس عشان يلغي كل الصفحات من الستاك عشان ما نقدر نرجع
      }else {
        showDialog(
          context: context,
          builder: (_)=>AlertDialog(
            title: const Text("تنبيه"),
            content: const Text("كلمة السر او الايميل غلط"),
            actions: [
              FloatingActionButton(onPressed: ()=>Navigator.of(context).popAndPushNamed("login")),
            ],
          ),
          barrierDismissible: false
        );
        // AwesomeDialog( ///بطلعلو بوكس بنص الشاشه
        //   context: context ,
        //   // btnCancel:  Text("Cancel") , ///TODO future make it pop
        //   title: "تنبيه",
        //   body: const Text(
        //     "كلمة السر او البريد غير صحيحين!!"
        //   ),
        //
        // ).show();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Form(
              key: formstate1,
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 200,
                    height: 200,
                  ),
                  CustomTextFormSign(
                    valid: (val) {
                      return validInput(val!, 5, 40);
                    },
                    mycontroller: email,
                    hint: "Email",
                  ),
                  CustomTextFormSign(
                    valid: (val) {
                      return validInput(val!, 3, 10);
                    },
                    hint: "Password",
                    mycontroller: password,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                        vertical:
                            10), //بادنج يعني بحججمو قديش يكون حجمو افقي وعامودي لاني مستخدم سمتريك
                    onPressed: ()async {
                      await login();
                    },
                    child: const Text(
                      "Login",
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed("signup");
                    },
                      child: const Text("Sign Up")),
                ],
              ))
        ],
      ),
    ));
  }
}
