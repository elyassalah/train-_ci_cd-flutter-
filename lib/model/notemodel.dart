
///هاي المودل عشان انا اسهل على حالي
///ما اضل كل شوي ارجع لل ابي اي واشوف شو اسم الكولم ومش عارف شوي وكيف سميتو
///خلص بعمل هاي المودل مره وحده وهيه بتجنرت اللي جاي من الداتا بيز من جيسون وبتعطيني اياهن بمتغيرات دارت اسمهم هيك زي ما انا معرفهم
///وعشان يكون الشغل منظم وسهل التعديل واشي قوي ومحترم
///خلص بصير لما بدي استلم من الداتا بيز بستلم من هاض الكلاس بالكونستركتر اللي اسمو فروم جسون
///هوه بمسكهن وبحطهن بمتغيرات وبعطيني اياهن دارت وبصير استخدم اللي بدي اياه من اللي اجانا
///ونفس الاشي لما اودي خلص مش ضروري اروح اشوف كيف اسمو بال ابي اي بستخدم التو جسون وهي بتجنرتو وبتعطيني اياه
///ب داتا عبارة عن ماب سترينج وداينمك وبوديها للداتا بيز

class NoteModel {
   String? noteId;
   String? noteTitle;
   String? noteContent;
   String? noteImage;
   String? noteUser;
  NoteModel( {
     this.noteImage,
     this.noteId,
     this.noteTitle,
     this.noteContent,
     this.noteUser,
});
  ///هاي بمسك اللي جاي من الداتا بيز وبحولو ل جسون وبحط القيم بهذول المتغيرات
   ///يعني بحول الجسون ل اوبجكت دارت
  NoteModel.fromJson(Map<String,dynamic> json){
    noteId = json["note_id"];
    noteTitle = json["note_title"];
    noteContent = json["note_content"];
    noteUser = json["note_user"];
    noteImage = json["note_image"];
  }
  ///هاي بمسك المتغيرات اللي عندي والقيم اللي فيها بحولها ل جسون وبعطيني اياها ب اسم داتا وبتكون ماب وانا بوديها للداتا بيز
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['note_id'] = this.noteId;
    data['note_title'] = this.noteTitle;
    data['note_content'] = this.noteContent;
    data['note_image'] = this.noteImage;
    data['note_user'] = this.noteUser;
    return data;
  }






}