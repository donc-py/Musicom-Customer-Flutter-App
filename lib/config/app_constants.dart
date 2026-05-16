class AppConstants {
  // API Constants
  // static const String baseUrl = 'https://www.sen.point-cash.org';
  static const String baseUrl = 'https://www.mucicom.it';
  static const String loginUrl = '$baseUrl/api/login';
  static const String registerUrl = '$baseUrl/api/registration';
  static const String profileUpdate = '$baseUrl/api/profile/update';
  static const String passwordChange = '$baseUrl/api/change/password';
  static const String dashboard = '$baseUrl/api/dashboard';
  static const String posProducts = '$baseUrl/api/products';
  static const String customers = '$baseUrl/api/customer/search';
  static const String cupon = '$baseUrl/api/apply/promo/code';
  static const String customersGroup = '$baseUrl/api/customer/groups';
  static const String addCustomer = '$baseUrl/api/customer/store';
  static const String posStore = '$baseUrl/api/pos/store';
  static const String report = '$baseUrl/api/reports';
  // category
  static const String categories = '$baseUrl/api/categories';
  static const String parentCategory =
      '$baseUrl/api/categories/parent-category';
  static const String addCategory = '$baseUrl/api/categories/store';
  static const String updateCategory = '$baseUrl/api/categories/update';
  static const String deleteCategory = '$baseUrl/api/categories/delete';
  // product
  static const String products = '$baseUrl/api/products';
  static const String productDetails = '$baseUrl/api/product-details';
  static const String deleteProduct = '$baseUrl/api/product/delete';
  static const String productInfo = '$baseUrl/api/add/product/info';
  static const String addProduct = '$baseUrl/api/product/store';
  // brand
  static const String brands = '$baseUrl/api/brands';
  static const String addBrand = '$baseUrl/api/brands/store';
  static const String updateBrand = '$baseUrl/api/brands/update';
  static const String deleteBrand = '$baseUrl/api/brands/delete';

  // collection
  static const String collections = '$baseUrl/api/collections';
  static const String addCollection = '$baseUrl/api/collections/store';
  static const String updateCollection = '$baseUrl/api/collections/update';
  static const String deleteCollection = '$baseUrl/api/collections/delete';

  // Masterpiece
  static const String masterpieces = '$baseUrl/api/masterpieces';
  //Events
  static const String events = '$baseUrl/api/events';
  //News
  static const String news = '$baseUrl/api/news';

  // deposit
  static const String bankAccount = '$baseUrl/api/accounts';
  static const String balance = '$baseUrl/api/balance';
  static const String balanceTransfer = '$baseUrl/api/balance/transfer';

  // purchase
  static const String purchasePDF = '$baseUrl/api/purchase/pdf';
  static const String salesPDF = '$baseUrl/api/sale/pdf';

  // warehouse
  static const String warehouses = '$baseUrl/api/warehouses';
  static const String updateWarehouse = '$baseUrl/api/warehouses/update';
  static const String addWarehouse = '$baseUrl/api/warehouses/store';
  static const String deleteWarehouse = '$baseUrl/api/warehouses/delete';

  static const String democurrency = '\$';
  static const String appcurrency = '$baseUrl/api/general-settings';

  static const String purchase = "$baseUrl/api/purchase";
  static const String wareHouse = "$baseUrl/api/warehouses";
  static const String sales = "$baseUrl/api/sales";
  static const String expenses = "$baseUrl/api/expense";
  static const String accounts = "$baseUrl/api/admin/accounts";
  static const String drafts = "$baseUrl/api/drafts";
  static const String paymentSuccess = "$baseUrl/api/sale/payment/success";
  static const String deleteDraft = "$baseUrl/api/draft/delete";

  // Hive Box
  static const String appSettingsBox = 'appSettings';
  static const String authBox = 'authBox';
  static const String cartBox = 'cartBox';

  // Settings veriable Names
  static const String appLocal = 'appLocal';
  static const String isDarkTheme = 'isDarkTheme';

  // Auth Variable Names
  static const String authToken = 'token';
  static const String userData = 'userData';
}
