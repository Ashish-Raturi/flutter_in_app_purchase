import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class UserDataDbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //saving purchase details and converting to premium user
  Future<void> convertUserToPremium(PurchaseDetails purchaseDetails) async {
    await _firestore.collection('User Data').doc('a0STYJfcX2wLFMRpvipp').set({
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
      'isUserPremium': true
    }, SetOptions(merge: true));
  }

  Stream<UserData> get featchUserDataFromDb {
    return _firestore
        .collection('User Data')
        .doc('a0STYJfcX2wLFMRpvipp')
        .snapshots()
        .map((event) => userDataFromSnapshot(event));
  }

  UserData userDataFromSnapshot(DocumentSnapshot ds) {
    return UserData(
        isUserPremium: ds.get('isUserPremium'),
        totalCoins: ds.get('totalCoins'),
        username: ds.get('username'));
  }

  Future<void> increaseNoOfCoin(int totalCoins) async {
    await _firestore
        .collection('User Data')
        .doc('a0STYJfcX2wLFMRpvipp')
        .set({'totalCoins': totalCoins + 5}, SetOptions(merge: true));
  }

  Future<void> spendCoin(int totalCoins) async {
    await _firestore
        .collection('User Data')
        .doc('a0STYJfcX2wLFMRpvipp')
        .set({'totalCoins': totalCoins - 2}, SetOptions(merge: true));
  }
}

class UserData {
  String username;
  int totalCoins;
  bool isUserPremium;

  UserData(
      {required this.isUserPremium,
      required this.totalCoins,
      required this.username});
}
