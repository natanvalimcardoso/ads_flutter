
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmoboController {
  
  //* BannerAd ---------------------------------------------- *//

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  //* InterstitialAd ---------------------------------------------- *//

  InterstitialAd? interstitialAd;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  //* RewardedAd ---------------------------------------------- *//

  RewardedAd? rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  //* NativeAd ---------------------------------------------- *//

  NativeAd? nativeAd;
  bool nativeAdIsLoaded = false;

  void nativedAd(Function setState) {
    nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
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
            size: 16.0),
      ),
    )..load();
  }
}