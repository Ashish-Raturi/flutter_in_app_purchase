import 'dart:async';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase/color.dart';
import 'package:flutter_in_app_purchase/service/user_db_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

String _premiumProductId =
    Platform.isAndroid ? 'premium_plan' : 'your_ios_sub1_id';

String _coinId = Platform.isAndroid ? 'game_coin' : 'your_ios_sub2_id';

List<String> _productIds = <String>[
  _premiumProductId,
  _coinId,
];

class _HomepageState extends State<Homepage> {
  int totalGameCoins = 0;
  bool isUserPremium = false;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    //step:1
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {});

    //step: 2
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];

        _notFoundIds = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_productIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;

        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;

        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: UserDataDbService().featchUserDataFromDb,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          UserData userData = snapshot.data!;
          totalGameCoins = userData.totalCoins;
          isUserPremium = userData.isUserPremium;
          return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Hi, ${userData.username}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                _buildRestoreButton()
                              ],
                            ),
                            _buildConnectionCheckTile(),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Get Premium',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 15,
                            ),
                            if (_isAvailable &&
                                !_notFoundIds.contains(_premiumProductId) &&
                                _queryProductError == null)
                              getPremium(),
                            if (_notFoundIds.contains(_premiumProductId))
                              Text('$_premiumProductId id not found'),
                            if (_queryProductError != null)
                              Text(_queryProductError!),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Get Game Coin',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            // const Text('\$2 Per Coin',
                            //     style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            if (_isAvailable &&
                                !_notFoundIds.contains(_coinId) &&
                                _queryProductError == null)
                              getGameCoin(),
                            if (_notFoundIds.contains(_coinId))
                              Text('$_coinId id not found'),
                            if (_queryProductError != null)
                              Text(_queryProductError!),
                          ],
                        ),
                      ),
                    ),
                    if (_purchasePending)
                      Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        color: Colors.black87,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Processing Purchase, Please wait...",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )
                  ],
                )),
          );
        });
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text(
          'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text('Unable to connect to the payments processor.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  ProductDetails? findProductDetail(String id) {
    for (ProductDetails pd in _products) {
      if (pd.id == id) return pd;
    }
    return null;
  }

  getPremium() {
    ProductDetails? pd = findProductDetail(_premiumProductId);

    if (pd == null) {
      return const Text('Product Details Not found');
    } else {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: c1,
          ),
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)),
                    color: c3,
                  ),
                  height: 35,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star_border, color: Colors.white, size: 18),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Recommanded', style: TextStyle(color: Colors.white))
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pd.title,
                            // 'Product title',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                            text: TextSpan(
                                children: [
                              TextSpan(
                                  text: pd.price,
                                  // 'Price',
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white)),
                            ],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white))),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(pd.description,
                            style: TextStyle(color: c3, fontSize: 16)),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(
                        width: 5,
                      ),
                    ),
                    Image.asset('assets/sub2.png', width: 100),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (!isUserPremium) _buyProduct(pd);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isUserPremium ? c4 : c2,
                  ),
                  width: 200,
                  alignment: Alignment.center,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : Text(
                          isUserPremium ? 'Active' : 'Get Premium',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ));
    }
  }

  getGameCoin() {
    ProductDetails? pd = findProductDetail(_coinId);

    if (pd == null) {
      return const Text('Product Details Not found');
    } else {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: c1,
          ),
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: [
              Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)),
                    color: c3,
                  ),
                  width: double.maxFinite,
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  alignment: Alignment.center,
                  child: Text(
                      '◯  Total Coins : ${totalGameCoins.toString().padLeft(2, "0")}',
                      style: const TextStyle(color: Colors.white))),
              const SizedBox(
                height: 10,
              ),
              Wrap(children: [
                for (int i = 0; i < totalGameCoins; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5),
                    child: Image.asset('assets/gold_coin_icon.png', width: 30),
                  ),
              ]),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  await UserDataDbService().spendCoin(totalGameCoins);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: c4,
                  ),
                  width: 200,
                  alignment: Alignment.center,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Spend Coin',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _buyProduct(pd);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: c2,
                  ),
                  width: 200,
                  alignment: Alignment.center,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Get Coin',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ));
    }
  }

  void _buyProduct(ProductDetails productDetails) async {
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }
    //buying consumable product
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: const Text('Restore purchases'),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              primary: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
          ),
        ],
      ),
    );
  }

  void showPendingUI() {
    //Step: 1, case:1
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    //Step: 1, case:2
    setState(() {
      _purchasePending = false;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.details),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('ok'))
                ],
              ));
    });
  }

  void verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    //Step: 1, case:3
    //Verify Purchase
    // bool purchaseVerified = false;
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('verifyPurchase');
    HttpsCallableResult res = await callable.call({
      'source': Platform.isAndroid ? 'google_play' : 'app_store',
      'productId': purchaseDetails.productID,
      'uid': 'a0STYJfcX2wLFMRpvipp',
      'verificationData':
          purchaseDetails.verificationData.serverVerificationData,
    });
    print('Purchase verified : ${res.data}');
    // Deliver Product
    if (res.data) {
      if (purchaseDetails.productID == _premiumProductId) {
        await UserDataDbService().convertUserToPremium(purchaseDetails);
      } else if (purchaseDetails.productID == _coinId) {
        await UserDataDbService().increaseNoOfCoin(totalGameCoins);
      }
    }
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //Step: 1, case:1
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //Step: 1, case:2
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          //Step: 1, case:3
          verifyAndDeliverProduct(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }
}
