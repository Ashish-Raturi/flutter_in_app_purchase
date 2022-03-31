import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stripe_subscription_app/shared/color.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int totalGameCoins = 09;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Hi, Ashish',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Flutter In app purchase (consumable)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Get Premium',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    getPremium(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Get Game Coin',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('\$2 Per Coin',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    getGameCoin()
                  ],
                ),
              ),
            ),
          )),
    );
  }

  getPremium() {
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
                  color: c4,
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
                      const Text('Product Name',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                          text: const TextSpan(
                              text: '\$  ',
                              children: [
                                TextSpan(
                                    text: 'Price',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white)),
                              ],
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white))),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Product Discrption',
                          style: TextStyle(color: c4, fontSize: 16)),
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
                  color: c3,
                ),
                width: 200,
                alignment: Alignment.center,
                child: const Text(
                  'Get Premium',
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

  getGameCoin() {
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
                  color: c4,
                ),
                width: double.maxFinite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                alignment: Alignment.center,
                child: Text(
                    '◯  Total Coins : ${totalGameCoins.toString().padLeft(2, "0")}',
                    style: TextStyle(color: Colors.white))),
            Wrap(children: [
              for (int i = 0; i < totalGameCoins; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/gold_coin_icon.png', width: 40),
                ),
            ]),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: c3,
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
