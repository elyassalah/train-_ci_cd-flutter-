import 'package:flutter/material.dart';

class CustomTextFormSign extends StatelessWidget {
  final String hint;
  final String? Function(String?)? valid;
  final TextEditingController mycontroller;
  final FocusNode? focus;
  const CustomTextFormSign({super.key, required this.hint, required this.mycontroller, this.valid, this.focus});


  ///لازم اعمل فاليدايتور عشان ما يدخل قيم فارغه وتروع عالداتا بيز فاضيه وهاض كارثة
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10), //عشان ما يكونو ملزقين ببعض يعني خلي مسافة من تحتو عشرة فارغه
      child: TextFormField(
        focusNode: focus,
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 8 , horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black, width: 1)
          ),
        ),
      ),
    );
  }
}
