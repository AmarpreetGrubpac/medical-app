import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/data/api/api_checker.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_repo.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_support_model.dart';
class HelpFaqListController extends GetxController {
  final HelpRepo helpRepo;

  HelpFaqListController({required this.helpRepo});

  List<FaqCategory>? _faqCategories;
  List<FaqCategory>? get faqCategories => _faqCategories;
  bool _isInitialLoading = true;
  List<Faq>? _faqList;
  List<Faq>? get faqList => _faqList;
  String title = AppString.troubleshooting;
  int _faqPage = 1;
  bool _faqHasMoreData = true;
  bool _faqIsLoading = false;
  bool _faqInitialLoading = true;
  String _faqSearch = '';
  String _currentCategoryId = '';

  bool get faqIsLoading => _faqIsLoading;
  bool get faqInitialLoading => _faqInitialLoading;

  bool get isInitialLoading => _isInitialLoading;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ScrollController faqScrollController = ScrollController();

  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;
  String _currentSearch = '';
  Timer? _faqDebounce;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    getCategoryList(isFirstLoad: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        getCategoryList();
      }
    });
    faqScrollController.addListener(() {
      if (faqScrollController.position.pixels ==
          faqScrollController.position.maxScrollExtent &&
          !_faqIsLoading &&
          _faqHasMoreData) {
        getCategoryById(_currentCategoryId);
      }
    });

  }


  void scrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        getCategoryList();
      }
    });
  }

  Future<void> getCategoryList({
    bool isFirstLoad = false,
    String? search,
  }) async {
    if (isFirstLoad) {
      _page = 1;
      _hasMoreData = true;
      _faqCategories = null;
      _currentSearch = search ?? '';
      _isInitialLoading = true;
      update();
    }

    if (!_hasMoreData || _isLoading) return;

    _isLoading = true;
    update();

    Response response = await helpRepo.getCategory(
      query: _currentSearch.isEmpty ? null : _currentSearch,
      limit: _limit,
      page: _page,
    );

    if (response.statusCode == 200) {
      List<FaqCategory> newData =
          HelpSupportResponse.fromJson(response.body)
              .data
              ?.faqCategories ??
              [];

      if (_page == 1) {
        // 🔥 First page
        _faqCategories = newData;
        _isInitialLoading = false;
      } else {
        // 🔥 Append next pages
        _faqCategories?.addAll(newData);
      }

      if (newData.length < _limit) {
        _hasMoreData = false;
      } else {
        _page++;
      }
    } else {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }
  Future<void> getCategoryById(
      String id, {
        bool isFirstLoad = false,
        String? search,
      }) async {
    if (isFirstLoad) {
      _currentCategoryId = id;
      _faqPage = 1;
      _faqHasMoreData = true;
      _faqList = null;
      _faqSearch = search ?? '';
      _faqInitialLoading = true;
      update();
    }

    if (!_faqHasMoreData || _faqIsLoading) return;

    _faqIsLoading = true;
    update();

    Response response = await helpRepo.getCategoryBYID(
      id: _currentCategoryId,
      query: _faqSearch.isEmpty ? null : _faqSearch,
      limit: _limit,
      page: _faqPage,
    );

    if (response.statusCode == 200) {
      List<Faq> newData =
          HelpSupportResponse.fromJson(response.body)
              .data
              ?.faqs ??
              [];

      if (_faqPage == 1) {
        _faqList = newData;
        _faqInitialLoading = false;
      } else {
        _faqList?.addAll(newData);
      }

      if (newData.length < _limit) {
        _faqHasMoreData = false;
      } else {
        _faqPage++;
      }
    } else {
      ApiChecker.checkApi(response);
    }

    _faqIsLoading = false;
    update();
  }

  void onFaqSearchChanged(String value) {
    if (_faqDebounce?.isActive ?? false) {
      _faqDebounce!.cancel();
    }

    _faqDebounce = Timer(const Duration(milliseconds: 500), () {
      getCategoryById(
        _currentCategoryId,
        isFirstLoad: true,
        search: value,
      );
    });
  }

}
