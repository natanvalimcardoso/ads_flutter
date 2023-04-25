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
    nativedAd();
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

  //* NativeAd ---------------------------------------------- *//

  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  void nativedAd() {
    nativeAd = NativeAd(
        adUnitId: 'ca-app-pub-3940256099942544/2247696110',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: Colors.red, // Background color
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
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
          const Spacer(
            flex: 2,
          ),
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
            style: ElevatedButton.styleFrom(
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
          const Spacer(),
          ElevatedButton(
            style:  ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Native Ad'),
            onPressed: () {
              if (_nativeAdIsLoaded) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: AdWidget(
                          ad: nativeAd!,
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
