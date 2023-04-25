import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admobo_controller.dart';

class AdmoboPage extends StatefulWidget {
  const AdmoboPage({Key? key}) : super(key: key);

  @override
  State<AdmoboPage> createState() => _AdmoboPageState();
}

class _AdmoboPageState extends State<AdmoboPage> {
  final admoboController = AdmoboController();

  @override
  void initState() {
    super.initState();
    admoboController.myBanner.load();
    admoboController.loadInterstitialAd();
    admoboController.loadRewardedAd();
    admoboController.nativedAd(
      setState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME PAGE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(
              flex: 2,
            ),
            ElevatedButton(
              child: const Text('interstitial'),
              onPressed: () {
                if (admoboController.interstitialAd == null) {
                  return;
                }
                admoboController.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    debugPrint('$ad onAdDismissedFullScreenContent.');
                    ad.dispose();
                  },
                );
                admoboController.interstitialAd!.show();
                admoboController.interstitialAd = null;
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              onPressed: () {
                if (admoboController.rewardedAd == null) {
                  return;
                }
                admoboController.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    ad.dispose();
                    admoboController.loadRewardedAd();
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    ad.dispose();
                    admoboController.loadRewardedAd();
                  },
                  onAdImpression: (ad) => debugPrint('\n\n\n\nO usuário clicou no anúncio.\n\n\n\n'),
                );
                admoboController.rewardedAd!.show(
                  onUserEarnedReward: (ad, reward) {
                    debugPrint('\n\n\n\nRecompensa recebida: ${reward.amount}\n\n\n\n');
                  },
                );
                admoboController.rewardedAd = null;
              },
              child: const Text('Rewarded'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Native Ad'),
              onPressed: () {
                if (admoboController.nativeAdIsLoaded) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: AdWidget(
                            ad: admoboController.nativeAd!,
                            key: UniqueKey(),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            const Spacer(
              flex: 2,
            ),
            SizedBox(
              width: admoboController.myBanner.size.width.toDouble(),
              height: admoboController.myBanner.size.height.toDouble(),
              child: AdWidget(
                ad: admoboController.myBanner,
                key: UniqueKey(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
