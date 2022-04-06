import 'package:cloud_firestore/cloud_firestore.dart';

class UserDbService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<UserData> get featchUserDataFromDb {
    return _firestore
        .collection('User Data')
        .doc('J2Bu7KDlku5sFbc6S9HR')
        .snapshots()
        .map((event) => userDataFromSnapshot(event));
  }

  UserData userDataFromSnapshot(DocumentSnapshot ds) {
    return UserData(
        isUserPremium: ds.get('isPremiumUser'),
        totalCoins: ds.get('totalCoins'),
        username: ds.get('username'));
  }
}

class UserData {
  String username;
  int totalCoins;
  bool isUserPremium;

  UserData(
      {required this.username,
      required this.isUserPremium,
      required this.totalCoins});
}
