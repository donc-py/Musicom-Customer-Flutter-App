// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  get collections => null;

  get artists => null;

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to ReadyPos`
  String get welcomeToReadyPos {
    return Intl.message(
      'Welcome to ReadyPos',
      name: 'welcomeToReadyPos',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get yearly {
    return Intl.message(
      'Yearly',
      name: 'yearly',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message(
      'Profit',
      name: 'profit',
      desc: '',
      args: [],
    );
  }

  /// `Sale`
  String get sale {
    return Intl.message(
      'Sale',
      name: 'sale',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get purchase {
    return Intl.message(
      'Purchase',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Due`
  String get purchaseDue {
    return Intl.message(
      'Purchase Due',
      name: 'purchaseDue',
      desc: '',
      args: [],
    );
  }

  /// `Purchase And Sale`
  String get purchaseAndSale {
    return Intl.message(
      'Purchase And Sale',
      name: 'purchaseAndSale',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message(
      'Brands',
      name: 'brands',
      desc: '',
      args: [],
    );
  }

  /// `Warehouses`
  String get warehouses {
    return Intl.message(
      'Warehouses',
      name: 'warehouses',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Category name`
  String get categoryName {
    return Intl.message(
      'Category name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Enter category name`
  String get enterCategoryName {
    return Intl.message(
      'Enter category name',
      name: 'enterCategoryName',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Parent Category`
  String get parentCategory {
    return Intl.message(
      'Parent Category',
      name: 'parentCategory',
      desc: '',
      args: [],
    );
  }

  /// `Category Image`
  String get categoryImage {
    return Intl.message(
      'Category Image',
      name: 'categoryImage',
      desc: '',
      args: [],
    );
  }

  /// `Tap To Upload Image`
  String get tapToUploadImage {
    return Intl.message(
      'Tap To Upload Image',
      name: 'tapToUploadImage',
      desc: '',
      args: [],
    );
  }

  /// `field is mandatory`
  String get fieldIsMandatory {
    return Intl.message(
      'field is mandatory',
      name: 'fieldIsMandatory',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Product Type`
  String get productType {
    return Intl.message(
      'Product Type',
      name: 'productType',
      desc: '',
      args: [],
    );
  }

  /// `Product Code`
  String get productCode {
    return Intl.message(
      'Product Code',
      name: 'productCode',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message(
      'Brand',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get unit {
    return Intl.message(
      'Unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Alert Quantity`
  String get alertQuantity {
    return Intl.message(
      'Alert Quantity',
      name: 'alertQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Cost`
  String get purchseCost {
    return Intl.message(
      'Purchase Cost',
      name: 'purchseCost',
      desc: '',
      args: [],
    );
  }

  /// `Selling Price`
  String get sellingPrice {
    return Intl.message(
      'Selling Price',
      name: 'sellingPrice',
      desc: '',
      args: [],
    );
  }

  /// `New Brand`
  String get newBrand {
    return Intl.message(
      'New Brand',
      name: 'newBrand',
      desc: '',
      args: [],
    );
  }

  /// `Brand Name`
  String get brandName {
    return Intl.message(
      'Brand Name',
      name: 'brandName',
      desc: '',
      args: [],
    );
  }

  /// `Enter brand name`
  String get enterBrandName {
    return Intl.message(
      'Enter brand name',
      name: 'enterBrandName',
      desc: '',
      args: [],
    );
  }

  /// `Brand Image`
  String get brandImage {
    return Intl.message(
      'Brand Image',
      name: 'brandImage',
      desc: '',
      args: [],
    );
  }

  /// `New Warehouse`
  String get newWarehouse {
    return Intl.message(
      'New Warehouse',
      name: 'newWarehouse',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Warehouse name`
  String get enterWarehouseName {
    return Intl.message(
      'Enter Warehouse name',
      name: 'enterWarehouseName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter email address`
  String get enterEmailAddress {
    return Intl.message(
      'Enter email address',
      name: 'enterEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Enter warehouse address`
  String get enterWarehouseAddress {
    return Intl.message(
      'Enter warehouse address',
      name: 'enterWarehouseAddress',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this item?`
  String get deleteDialogDes {
    return Intl.message(
      'Do you want to delete this item?',
      name: 'deleteDialogDes',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message(
      'Delete',
      name: 'Delete',
      desc: '',
      args: [],
    );
  }

  /// `Purchases`
  String get purchases {
    return Intl.message(
      'Purchases',
      name: 'purchases',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `TAX`
  String get tax {
    return Intl.message(
      'TAX',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Due`
  String get due {
    return Intl.message(
      'Due',
      name: 'due',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `Selling Products`
  String get sellingProducts {
    return Intl.message(
      'Selling Products',
      name: 'sellingProducts',
      desc: '',
      args: [],
    );
  }

  /// `Available Products`
  String get availableProducts {
    return Intl.message(
      'Available Products',
      name: 'availableProducts',
      desc: '',
      args: [],
    );
  }

  /// `Payment Recevied`
  String get paymentReceived {
    return Intl.message(
      'Payment Recevied',
      name: 'paymentReceived',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get bank {
    return Intl.message(
      'Bank',
      name: 'bank',
      desc: '',
      args: [],
    );
  }

  /// `Total Cash Received`
  String get totalCashReceived {
    return Intl.message(
      'Total Cash Received',
      name: 'totalCashReceived',
      desc: '',
      args: [],
    );
  }

  /// `Total Received in Bank`
  String get totalReceviedInBank {
    return Intl.message(
      'Total Received in Bank',
      name: 'totalReceviedInBank',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Admin Profile`
  String get adminProfile {
    return Intl.message(
      'Admin Profile',
      name: 'adminProfile',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expenses',
      desc: '',
      args: [],
    );
  }

  /// `Accounting`
  String get accounting {
    return Intl.message(
      'Accounting',
      name: 'accounting',
      desc: '',
      args: [],
    );
  }

  /// `Bill Summary`
  String get billSummary {
    return Intl.message(
      'Bill Summary',
      name: 'billSummary',
      desc: '',
      args: [],
    );
  }

  /// `Total Items`
  String get totalItems {
    return Intl.message(
      'Total Items',
      name: 'totalItems',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get coupon {
    return Intl.message(
      'Coupon',
      name: 'coupon',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total`
  String get grandTotal {
    return Intl.message(
      'Grand Total',
      name: 'grandTotal',
      desc: '',
      args: [],
    );
  }

  /// `Choose Customer`
  String get chooseCustomer {
    return Intl.message(
      'Choose Customer',
      name: 'chooseCustomer',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get neww {
    return Intl.message(
      'New',
      name: 'neww',
      desc: '',
      args: [],
    );
  }

  /// `Search by name/mobile`
  String get searchNameOrMobile {
    return Intl.message(
      'Search by name/mobile',
      name: 'searchNameOrMobile',
      desc: '',
      args: [],
    );
  }

  /// `POS`
  String get pos {
    return Intl.message(
      'POS',
      name: 'pos',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get card {
    return Intl.message(
      'Card',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `PayPal`
  String get paypal {
    return Intl.message(
      'PayPal',
      name: 'paypal',
      desc: '',
      args: [],
    );
  }

  /// `Gift Card`
  String get giftCard {
    return Intl.message(
      'Gift Card',
      name: 'giftCard',
      desc: '',
      args: [],
    );
  }

  /// `Cheque`
  String get cheque {
    return Intl.message(
      'Cheque',
      name: 'cheque',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Deposit POS Cash`
  String get depositPOSCash {
    return Intl.message(
      'Deposit POS Cash',
      name: 'depositPOSCash',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Today's Sale`
  String get todaysSale {
    return Intl.message(
      'Today\'s Sale',
      name: 'todaysSale',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Purpose`
  String get purpose {
    return Intl.message(
      'Purpose',
      name: 'purpose',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get personalInfo {
    return Intl.message(
      'Personal Info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Profile Image`
  String get profileImage {
    return Intl.message(
      'Profile Image',
      name: 'profileImage',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `SL`
  String get sl {
    return Intl.message(
      'SL',
      name: 'sl',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get reference {
    return Intl.message(
      'Reference',
      name: 'reference',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get supplier {
    return Intl.message(
      'Supplier',
      name: 'supplier',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get end {
    return Intl.message(
      'End',
      name: 'end',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse`
  String get warehouse {
    return Intl.message(
      'Warehouse',
      name: 'warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message(
      'Print',
      name: 'print',
      desc: '',
      args: [],
    );
  }

  /// `Biller`
  String get biller {
    return Intl.message(
      'Biller',
      name: 'biller',
      desc: '',
      args: [],
    );
  }

  /// `Qty`
  String get qty {
    return Intl.message(
      'Qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Total Expense`
  String get totalExpense {
    return Intl.message(
      'Total Expense',
      name: 'totalExpense',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `Money Transfer`
  String get moneyTransfer {
    return Intl.message(
      'Money Transfer',
      name: 'moneyTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Balance Sheet`
  String get balanceSheet {
    return Intl.message(
      'Balance Sheet',
      name: 'balanceSheet',
      desc: '',
      args: [],
    );
  }

  /// `Account No`
  String get accountNo {
    return Intl.message(
      'Account No',
      name: 'accountNo',
      desc: '',
      args: [],
    );
  }

  /// `Debit`
  String get debit {
    return Intl.message(
      'Debit',
      name: 'debit',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get credit {
    return Intl.message(
      'Credit',
      name: 'credit',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// ` Dashboard`
  String get dashboard {
    return Intl.message(
      ' Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get prodcts {
    return Intl.message(
      'Products',
      name: 'prodcts',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get Reports {
    return Intl.message(
      'Reports',
      name: 'Reports',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get More {
    return Intl.message(
      'More',
      name: 'More',
      desc: '',
      args: [],
    );
  }

  /// `Add Products`
  String get addProducts {
    return Intl.message(
      'Add Products',
      name: 'addProducts',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product name`
  String get entrName {
    return Intl.message(
      'Enter Product name',
      name: 'entrName',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Select Type`
  String get selectType {
    return Intl.message(
      'Select Type',
      name: 'selectType',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get code {
    return Intl.message(
      'Code',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Code`
  String get enterCode {
    return Intl.message(
      'Enter Product Code',
      name: 'enterCode',
      desc: '',
      args: [],
    );
  }

  /// `Bar Code Symbology`
  String get barCodeSymbology {
    return Intl.message(
      'Bar Code Symbology',
      name: 'barCodeSymbology',
      desc: '',
      args: [],
    );
  }

  /// `Select Symbology`
  String get selectSymbology {
    return Intl.message(
      'Select Symbology',
      name: 'selectSymbology',
      desc: '',
      args: [],
    );
  }

  /// `Product Unit`
  String get productUnit {
    return Intl.message(
      'Product Unit',
      name: 'productUnit',
      desc: '',
      args: [],
    );
  }

  /// `Sale Unit`
  String get saleUnit {
    return Intl.message(
      'Sale Unit',
      name: 'saleUnit',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Unit`
  String get purchaseUnit {
    return Intl.message(
      'Purchase Unit',
      name: 'purchaseUnit',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Cost`
  String get purchaseCost {
    return Intl.message(
      'Purchase Cost',
      name: 'purchaseCost',
      desc: '',
      args: [],
    );
  }

  /// `Alert Quantity`
  String get aletrtQuantity {
    return Intl.message(
      'Alert Quantity',
      name: 'aletrtQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price`
  String get salePrice {
    return Intl.message(
      'Sale Price',
      name: 'salePrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Quantity`
  String get entrQty {
    return Intl.message(
      'Enter Quantity',
      name: 'entrQty',
      desc: '',
      args: [],
    );
  }

  /// `Product Image`
  String get productImage {
    return Intl.message(
      'Product Image',
      name: 'productImage',
      desc: '',
      args: [],
    );
  }

  /// `Tax Method`
  String get taxMethod {
    return Intl.message(
      'Tax Method',
      name: 'taxMethod',
      desc: '',
      args: [],
    );
  }

  /// `Feature Product Will be displayed in POS`
  String get featureProductWillbe {
    return Intl.message(
      'Feature Product Will be displayed in POS',
      name: 'featureProductWillbe',
      desc: '',
      args: [],
    );
  }

  /// `This Product has Variants`
  String get thisProducthasVariants {
    return Intl.message(
      'This Product has Variants',
      name: 'thisProducthasVariants',
      desc: '',
      args: [],
    );
  }

  /// `This Product has batch and expired date`
  String get thisProducthasbatches {
    return Intl.message(
      'This Product has batch and expired date',
      name: 'thisProducthasbatches',
      desc: '',
      args: [],
    );
  }

  /// `Add Promotional Price`
  String get addPromotion {
    return Intl.message(
      'Add Promotional Price',
      name: 'addPromotion',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Orange Pay`
  String get orangePay {
    return Intl.message(
      'Orange Pay',
      name: 'orangePay',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
