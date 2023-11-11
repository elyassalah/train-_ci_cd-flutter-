
import 'package:flutter/material.dart';
import 'package:note_app_withphpapi/app/components/crud.dart';
import 'package:note_app_withphpapi/app/components/valid.dart';
import 'package:note_app_withphpapi/app/constants/linkapi.dart';

import '../components/customtextform.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Crud  _crud = Crud();
 // بعمل منو انستنس عشان استخدم اللي فيه
  GlobalKey<FormState> formstate = GlobalKey();

  final TextEditingController username = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();


  signUp()async{
    if(formstate.currentState!.validate()){ ///عشان ينفذ فقط لما تكون الامور فاليد وتمام
      var response =  await _crud.postRequest(linkSignUp, {
        "username" : username.text,
        "email": email.text,
        "password" : password.text
      }); ///نوع بوست لانو الصفحة البي اتش بي تبعت الساين اب بتستقبل ريكويست من نوع بوست انا هيك عملتها
      ///والبوست بنستخدمها مع الانسيرت والابديت والديليت
      if(response['status'] == "success"){
        //انا عامل برضو بالنجاح يرجع ستاتس سكسس ف بحفصها
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false); ///فولس عشان يلغي كل الصفحات من الستاك عشان ما نقدر نرجع
        ///TODO::Look down
        ///الافضل بعد ما يتم انشاء الحساب وديه على صفحة التسجيل عشان يسجل ونتأكد انو مش ناسي اللي دخلهن
        ///او بنوديه على صفحة انو تم انشاء الحساب الان يمكنك تسجيل دخول وبكبس بروح على صفحة تسجيل الدخول
      }else{
        print("SignUp fail"); ///TODO show it in the app
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Form(
                  key: formstate,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 200,
                        height: 200,
                      ),
                      CustomTextFormSign(
                        ///بعمل فنكشن عشان اتحقق من الفاليد ب فايل بالكومبوننتس
                        valid: (val) {
                          return validInput(val!, 3, 20);

                        },
                        mycontroller: username,
                        hint: "Uaername",
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 70,
                            vertical:
                            10), //بادنج يعني بحججمو قديش يكون حجمو افقي وعامودي لاني مستخدم سمتريك
                        onPressed: () async {
                           await signUp();
                        },
                        child: Text(
                          "Sign Up",
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacementNamed("login");
                          },
                          child: Text("Login")),

                    ],
                  ))
            ],
          ),
        ));
  }
}
