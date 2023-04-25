import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    myBanner.load();
    loadAd();
    loadRewardedAd();
  }

  //* BannerAd ---------------------------------------------- *//

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  //* InterstitialAd ---------------------------------------------- *//

  InterstitialAd? _interstitialAd;

  void loadAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  //* RewardedAd ---------------------------------------------- *//

  RewardedAd? _rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME PAGE'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           const Spacer(flex: 2,),

          ElevatedButton(
            child: const Text('interstitial'),
            onPressed: () {
              if (_interstitialAd == null) {
                return;
              }
              _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  debugPrint('$ad onAdDismissedFullScreenContent.');
                  ad.dispose();
                },
              );
              _interstitialAd!.show();
              _interstitialAd = null;
            },
          ),

          const Spacer(),
          ElevatedButton(
            style:  ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
            ),
            onPressed: () {
              if (_rewardedAd == null) {
                return;
              }
              _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  loadRewardedAd();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  loadRewardedAd();
                },
                onAdImpression: (ad) => debugPrint('\n\n\n\nO usuário clicou no anúncio.\n\n\n\n'),
              );
              _rewardedAd!.show(
                onUserEarnedReward: (ad, reward) {
                  debugPrint('\n\n\n\nRecompensa recebida: ${reward.amount}\n\n\n\n');
                },
              );
              _rewardedAd = null;
            },
            child: const Text('Rewarded'),
          ),
          const Spacer(flex: 2,),
          Center(
            child: SizedBox(
              width: myBanner.size.width.toDouble(),
              height: myBanner.size.height.toDouble(),
              child: AdWidget(
                ad: myBanner,
                key: UniqueKey(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
