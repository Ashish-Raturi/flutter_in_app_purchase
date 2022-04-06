import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase/color.dart';
import 'package:flutter_in_app_purchase/service/user_db_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int totalGameCoins = 0;
  bool isUserPremium = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: UserDbService().featchUserDataFromDb,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          UserData? userData = snapshot.data;
          totalGameCoins = userData!.totalCoins;
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
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Get Premium',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 15,
                            ),
                            _buildPremiumProductTile(),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Get Game Coin',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildGameCoinTile(),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  _buildPremiumProductTile() {
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
                      Text('Product title',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                          text: TextSpan(
                              children: [
                            TextSpan(
                                text: 'Price',
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white)),
                          ],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white))),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Description',
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
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isUserPremium ? c4 : c2,
                ),
                width: 200,
                alignment: Alignment.center,
                child: Text(
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

  _buildGameCoinTile() {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Image.asset('assets/gold_coin_icon.png', width: 30),
                ),
            ]),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: c4,
                ),
                width: 200,
                alignment: Alignment.center,
                child: const Text(
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
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: c2,
                ),
                width: 200,
                alignment: Alignment.center,
                child: const Text(
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
