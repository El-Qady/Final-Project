class DoctorsModel {
  String? name;
  String? address;
  String? phone;
  DoctorsModel({this.name, this.address, this.phone});
  static  List doctors = [
    DoctorsModel(
      name: "د. أحمد محمد",
      address: "القاهرة - مدينة نصر",
      phone: '01012345678',
    ),
    DoctorsModel(
      name: "د. سارة علي",
      address: "الجيزة - الدقي",
      phone: '01198765432',
    ),
    DoctorsModel(
      name: "د. محمد عبد الحميد",
      address: "القاهرة - مدينة نصر",
      phone: '01012345678',
    ),
    DoctorsModel(
      name: "د. ليلى حسن",
      address: "الجيزة - الدقي",
      phone: '01198765432',
    ),
    DoctorsModel(
      name: "د. سارة علي",
      address: "الجيزة - الدقي",
      phone: '01198765432',
    ),
    DoctorsModel(
      name: "د. سارة علي",
      address: "الجيزة - الدقي",
      phone: '01198765432',
    ),
  ];
}
