class BookingModel {
  String userId;
  String selectedDay;
  String selectedTimeSlot;
  String hospitalName;
  String doctorName;
  String specialty;
  String username;
  String phoneNumber;
  String bookingId;
  String hospitalId;
  String status;
  String type;

  BookingModel({
    required this.userId,
    required this.selectedDay,
    required this.selectedTimeSlot,
    required this.hospitalName,
    required this.doctorName,
    required this.specialty,
    required this.username,
    required this.phoneNumber,
    required this.bookingId,
    required this.hospitalId,
    required this.status,
    required this.type
  });

  // from map
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      userId: map['userId'] ?? '',
      selectedDay: map['selectedDay'] ?? '',
      selectedTimeSlot: map['selectedTimeSlot'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      doctorName: map['doctorName'] ?? '',
      specialty: map['specialty'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      bookingId: map['bookingId'] ?? '',
      hospitalId: map['hospitalId'] ?? '',
      status: map['status'] ?? '',
      type: map['type'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "selectedDay": selectedDay,
      "selectedTimeSlot": selectedTimeSlot,
      "hospitalName": hospitalName,
      "doctorName": doctorName,
      "specialty": specialty,
      "username": username,
      "phoneNumber": phoneNumber,
      "bookingId": bookingId,
      "hospitalId": hospitalId,
      "status": status,
      "type": type
    };
  }
}
