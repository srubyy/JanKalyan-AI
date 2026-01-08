
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider with ChangeNotifier {
  List<String> _wishlistedSchemeIds = [];

  List<String> get wishlistedSchemeIds => _wishlistedSchemeIds;

  bool isWishlisted(String schemeId) {
    return _wishlistedSchemeIds.contains(schemeId);
  }

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    _wishlistedSchemeIds = prefs.getStringList('wishlist') ?? [];
    notifyListeners();
  }

  Future<void> addToWishlist(String schemeId) async {
    if (!_wishlistedSchemeIds.contains(schemeId)) {
      _wishlistedSchemeIds.add(schemeId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('wishlist', _wishlistedSchemeIds);
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String schemeId) async {
    if (_wishlistedSchemeIds.contains(schemeId)) {
      _wishlistedSchemeIds.remove(schemeId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('wishlist', _wishlistedSchemeIds);
      notifyListeners();
    }
  }
}
