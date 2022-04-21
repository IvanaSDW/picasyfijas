import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../data/ad_helper.dart';

class PlayerProfileController extends GetxController {

  CountryDetails? country = CountryCodes.detailsForLocale();

  late BannerAd bottomBannerAd;
  final RxBool _isBottomBannerAdLoaded = false.obs;
  bool get isBottomBannerAdLoaded => _isBottomBannerAdLoaded.value;

  final RxBool _showEdits = false.obs;
  bool get showEdits => _showEdits.value;
  set showEdits(bool value) => _showEdits.value = value;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  String? imagePath;
  final _picker = ImagePicker();

  String? nickNameErrorText;


  @override
  Future<void> onInit() async {
    _createBottomBannerAd();
    super.onInit();
  }

  Future<void> onEditProfile() async {
    if (showEdits) {
      if (formKey.currentState!.validate()) {
        logger.i('New Nickname is: ${nameController.value.text}');
        if (await firestoreService.nickNameDoesNotExist(nameController.value.text)) {
          firestoreService.updatePlayerNickName(auth.currentUser!.uid, nameController.value.text);
          _showEdits.toggle();
        } else {
          nickNameErrorText = 'Nickname already exists';
          logger.i('Nickname already exists');
        }

      } else {
        if (nameController.value.text.isEmpty) {
          _showEdits.toggle();
        } else {
          nameController.printError(info: 'At least 3 characters required');
        }
      }
    } else {
      _showEdits.toggle();
    }
  }

  Future<void> _imgFromCamera() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      final urlToImage = await storageService.uploadFile(imageTemp);
      firestoreService.addPlayerAvatarUrl(auth.currentUser!.uid, urlToImage);
    } on PlatformException catch (e) {
      logger.i('Failed to pick image: $e');
    }
  }

  Future<void> _imgFromGallery() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      final urlToImage = await storageService.uploadFile(imageTemp);
      firestoreService.addPlayerAvatarUrl(auth.currentUser!.uid, urlToImage);
    } on PlatformException catch (e) {
      logger.i('Failed to pick image: $e');
    }
  }

  void showPicker(context) {
    showModalBottomSheet(
        backgroundColor: originalColors.playerOneBackground,
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: 60,
            child: Row(
              children: <Widget>[
                Expanded(flex: 8,
                  child: Center(
                    child: ListTile(
                        leading: Icon(Icons.photo_library, color: originalColors.accentColor2,),
                        horizontalTitleGap: 4,
                        title: Text('gallery'.tr),
                        onTap: () {
                          Navigator.of(context).pop();
                          _imgFromGallery();
                        }),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(flex: 8,
                  child: Center(
                    child: ListTile(
                      horizontalTitleGap: 4,
                      leading: Icon(Icons.photo_camera, color: originalColors.accentColor2,),
                      title:  Text('camera'.tr),
                      onTap: () {
                        Navigator.of(context).pop();
                        _imgFromCamera();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  String? validateNickName(String? value) {
    if (value == null) return null;
    return value.length < 3
        ? 'at_least_3_chars'.tr
        : nickNameErrorText;
  }

  void _createBottomBannerAd() {
    bottomBannerAd = BannerAd(
      // adUnitId: AdHelper.testProfileBannerAdUnitId,
      adUnitId: AdHelper.profileBannerAdUnitId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBottomBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          logger.i('ad: ${ad.adUnitId}, error: $error');
          ad.dispose();
        },
      ),
    );
    bottomBannerAd.load();
  }

  Future<bool> onBackPressed() async {
    if(showEdits) {
      _showEdits.toggle();
      return false;
    } else {
      return true;
    }
  }
}