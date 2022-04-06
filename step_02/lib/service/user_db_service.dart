import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class UserDbService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> convertUserToPremium(PurchaseDetails purchaseDetails) async {
    _firestore.collection('User Data').doc('J2Bu7KDlku5sFbc6S9HR').set({
      'Purchase Details': {
        'error': purchaseDetails.error,
        'pendingCompletePurchase': purchaseDetails.pendingCompletePurchase,
        'productID': purchaseDetails.productID,
        'purchaseID': purchaseDetails.purchaseID,
        'status': purchaseDetails.status.index,
        'transactionDate': purchaseDetails.transactionDate,
        'localVerificationData':
            purchaseDetails.verificationData.localVerificationData,
        'serverVerificationData':
            purchaseDetails.verificationData.serverVerificationData,
        'source': purchaseDetails.verificationData.source,
        'datetime': Timestamp.now()
      },
      'isPremiumUser': true
    }, SetOptions(merge: true));
  }

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

  //increase total no of coins
  Future<void> getCoins(int totalCoins) async {
    await _firestore
        .collection('User Data')
        .doc('J2Bu7KDlku5sFbc6S9HR')
        .set({'totalCoins': totalCoins + 5}, SetOptions(merge: true));
  }

  //decrease total no of coins
  Future<void> spendCoins(int totalCoins) async {
    await _firestore
        .collection('User Data')
        .doc('J2Bu7KDlku5sFbc6S9HR')
        .set({'totalCoins': totalCoins - 2}, SetOptions(merge: true));
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
