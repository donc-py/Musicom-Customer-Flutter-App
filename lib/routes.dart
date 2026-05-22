import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readypos_flutter/models/brand/brand_update.dart';
import 'package:readypos_flutter/models/warehouse/warehouse.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/models/event/event.dart';
import 'package:readypos_flutter/models/news/news.dart';
import 'package:readypos_flutter/models/collection/collection.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/views/auth/login_view.dart';
import 'package:readypos_flutter/views/auth/register_view.dart';
import 'package:readypos_flutter/views/cart/cart_view.dart';
import 'package:readypos_flutter/views/core/core_view.dart';
import 'package:readypos_flutter/views/draft/draft_screen.dart';
import 'package:readypos_flutter/views/more/layouts/accounting.dart';
import 'package:readypos_flutter/views/more/layouts/admin_profile.dart';
import 'package:readypos_flutter/views/more/layouts/expenses.dart';
import 'package:readypos_flutter/views/more/layouts/purchase.dart';
import 'package:readypos_flutter/views/more/layouts/sales.dart';
import 'package:readypos_flutter/views/pos/components/pdf_view.dart';
import 'package:readypos_flutter/views/pos/layouts/add_new_customer.dart';
import 'package:readypos_flutter/views/pos/layouts/deposit_pos_cash.dart';
import 'package:readypos_flutter/views/pos/pos_view.dart';
import 'package:readypos_flutter/views/products/brand_add_update_view.dart';
import 'package:readypos_flutter/views/products/brands_view.dart';
import 'package:readypos_flutter/views/products/categories_view.dart';
import 'package:readypos_flutter/views/products/category_add_update_view.dart';
import 'package:readypos_flutter/views/products/layouts/add_products_layout.dart';
import 'package:readypos_flutter/views/products/layouts/category_add_update_layout.dart';
import 'package:readypos_flutter/views/products/product_view.dart';
import 'package:readypos_flutter/views/products/warehouse_add_update_view.dart';
import 'package:readypos_flutter/views/products/warehouses_view.dart';
import 'package:readypos_flutter/views/splash/splash_view.dart';
import 'package:readypos_flutter/views/welcome/welcome_view.dart';

// museum views
import 'package:readypos_flutter/views/museum/collections_list_view.dart';
import 'package:readypos_flutter/views/museum/artists_list_view.dart';
import 'package:readypos_flutter/views/museum/masterpieces_list_view.dart';
import 'package:readypos_flutter/views/museum/masterpiece_detail_view.dart';
import 'package:readypos_flutter/views/museum/events_list_view.dart';
import 'package:readypos_flutter/views/museum/event_detail_view.dart';
import 'package:readypos_flutter/views/museum/news_list_view.dart';
import 'package:readypos_flutter/views/museum/news_detail_view.dart';

import 'package:readypos_flutter/views/museum/collection_detail_view.dart'; // ← nuevo
import 'package:readypos_flutter/views/museum/artist_detail_view.dart'; // ← nuevo

class Routes {
  Routes._();
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String core = '/core';
  static const String pos = '/pos';
  static const String addNewCustomer = '/addNewCustomer';
  static const String cart = '/cart';
  static const String adminProfile = '/adminProfile';
  static const String purchase = '/purchase';
  static const String sales = '/sales';
  static const String expenses = '/expenses';
  static const String accounting = '/accounting';
  static const String categories = '/categories';
  static const String categoryAddUpdateView = '/categoryAddUpdateView';
  static const String productView = '/productView';
  static const String brandsView = '/brandsView';
  static const String brandAddUpdateView = '/brandAddUpdateView';
  static const String warehousesView = '/warehousesView';
  static const String warehousesAddUpdateView = '/warehousesAddUpdateView';
  static const String depositPOSScreen = '/depositPOSScreen';
  static const String addProductsView = '/addProductsView';
  static const String pdfView = '/pdfView';
  static const String draft = '/draft';
  // museum
  static const String collectionsListView = '/collectionsListView';
  static const String artistsListView = '/artistsListView';
  static const String masterpiecesListView = '/masterpiecesListView';
  static const String masterpieceDetail = '/masterpieceDetail';
  static const String eventsListView = '/eventsListView';
  static const String eventDetail = '/eventDetail';
  static const String newsListView = '/newsListView';
  static const String newsDetail = '/newsDetail';

  static const String collectionDetail = '/collectionDetail'; // ← nuevo
  static const String artistDetail = '/artistDetail'; // ← nuevo
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    case Routes.splash:
      child = const SplashView();
      break;
    case Routes.welcome:
      child = const WelcomeView();
      break;
    case Routes.login:
      child = const LoginView();
      break;
    case Routes.register: // ← nuevo
      child = const RegisterView();
      break;
    case Routes.core:
      child = const CoreView();
      break;
    case Routes.pos:
      child = const POSView();
      break;
    case Routes.addNewCustomer:
      child = const AddNewCustomer();
      break;
    case Routes.cart:
      child = const CartView();
      break;
    case Routes.adminProfile:
      child = const AdminProfileScreen();
      break;
    case Routes.purchase:
      child = const PurchasesScreen();
      break;
    case Routes.sales:
      child = const SalesScreen();
      break;
    case Routes.expenses:
      child = const ExpensesScreen();
      break;
    case Routes.accounting:
      child = const AccountingScreen();
      break;
    case Routes.categories:
      child = const CategoriesView();
      break;
    case Routes.categoryAddUpdateView:
      CategoryAddUpdateArguament? categoryAddUpdateArguament =
          settings.arguments as CategoryAddUpdateArguament?;
      child = CategoryAddUpdateView(
        categoryAddUpdateArguament: categoryAddUpdateArguament,
      );
      break;
    case Routes.productView:
      child = const ProductView();
      break;
    case Routes.brandsView:
      child = const BrandsView();
      break;
    case Routes.brandAddUpdateView:
      final UpdateBrandModel? updateBrandModel =
          settings.arguments as UpdateBrandModel?;
      child = BrandAddUpdateView(
        updateBrandModel: updateBrandModel,
      );
      break;
    case Routes.warehousesView:
      child = const WarehousesView();
      break;
    case Routes.warehousesAddUpdateView:
      final Warehouse? warehouse = settings.arguments as Warehouse?;
      child = WarehouseAddUpdateView(
        warehouse: warehouse,
      );
      break;
    case Routes.depositPOSScreen:
      child = const DepositPOSScreen();
      break;
    case Routes.addProductsView:
      child = const AddProductsView();
      break;
    case Routes.pdfView:
      child = PDFViewScreen(
        url: settings.arguments as String,
      );
      break;
    case Routes.draft:
      child = const DraftScreen();
      break;
    // ── museum ──────────────────────────────────────────────────────────────
    case Routes.collectionsListView:
      child = const CollectionsListView();
      break;

    case Routes.collectionDetail: // ← nuevo
      child = CollectionDetailView(
        collection: settings.arguments as Collection,
      );
      break;
    case Routes.artistsListView:
      child = const ArtistsListView();
      break;
    case Routes.artistDetail: // ← nuevo
      child = ArtistDetailView(
        artist: settings.arguments as Brand,
      );
      break;
    case Routes.masterpiecesListView:
      child = const MasterpiecesListView();
      break;
    case Routes.masterpieceDetail:
      child = MasterpieceDetailView(
        masterpiece: settings.arguments as Masterpiece,
      );
      break;
    case Routes.eventsListView:
      child = const EventsListView();
      break;
    case Routes.eventDetail:
      child = EventDetailView(event: settings.arguments as Event);
      break;
    case Routes.newsListView:
      child = const NewsListView();
      break;
    case Routes.newsDetail:
      child = NewsDetailView(news: settings.arguments as News);
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
  );
}
