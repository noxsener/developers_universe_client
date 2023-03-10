import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {

  static AdWithView? bannerAd;
  static InterstitialAd? interstitialAd;
  static RewardedAd? rewardedAd;
  static RewardedInterstitialAd? rewardedInterstitialAd;

  static int maxFailedLoadAttempts = 3;

  static int _numBannerLoadAttempts = 0;
  static int _numInterstitialLoadAttempts = 0;
  static int _numRewardedLoadAttempts = 0;
  static int _numRewardedInterstitialLoadAttempts = 0;
  
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // test
      // return 'ca-app-pub-2921747646300533/4571274595';
    } else if (Platform.isIOS) {
      
    }
    return null;
  }

  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );


  void createBanerAd(Size? size) {
    if (_numBannerLoadAttempts >= maxFailedLoadAttempts) {
      return;
    }
    AdSize adSize = getBannerAdSize(size);
    BannerAdListener bannerAdListener = BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded');
          _numBannerLoadAttempts = 0;
          bannerAd = ad as AdWithView?;
          bannerAd!.load();
        },
        onAdFailedToLoad: (ad, error) {
          print('$ad had error ${error.message}');
          if(bannerAd != null) {
            bannerAd!.dispose();
            bannerAd = null;
          }
          ad.dispose();
          _numBannerLoadAttempts += 1;
          if (_numBannerLoadAttempts < maxFailedLoadAttempts) {
            createBanerAd(size);
          }
        },
    );
    if(bannerAdUnitId == null) {
      return;
    }
    bannerAd = BannerAd(size: adSize,
        adUnitId: bannerAdUnitId!,
        listener: bannerAdListener,
        request: request)..load();
  }

  AdSize getBannerAdSize(Size? size) {
    if(size == null) {
      return AdSize.fullBanner;
    }
    AdSize adSize;
    if(size.width >= 728) {
      adSize = AdSize.leaderboard;
    } else if(size.width >= 468) {
      adSize = AdSize.fullBanner;
    } else if(size.width >= 320) {
      adSize = AdSize.banner;
    } else {
      adSize = AdSize.mediumRectangle;
    }
    return adSize;
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            ad.setImmersiveMode(true);
            print('$ad loaded');
            _numInterstitialLoadAttempts = 0;
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    rewardedAd = null;
  }

  void createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5354046379'
            : 'ca-app-pub-3940256099942544/6978759866',
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    if (rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
              print('$ad onAdShowedFullScreenContent.'),
          onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            createRewardedInterstitialAd();
          },
          onAdFailedToShowFullScreenContent:
              (RewardedInterstitialAd ad, AdError error) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            createRewardedInterstitialAd();
          },
        );

    rewardedInterstitialAd!.setImmersiveMode(true);
    rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    rewardedInterstitialAd = null;
  }
}