import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// --- MODELS ---

class Category {
  final String id;
  final String name;
  final String slug;
  final IconData icon;
  final String image;
  final List<String> subcategories;
  final int itemCount;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.image,
    required this.subcategories,
    required this.itemCount,
  });
}

class Product {
  final String id;
  final String qrCode;
  final String name;
  final String category;
  final String subcategory;
  final String brand;
  final double price;
  final double originalPrice;
  final int discount;
  final double rating;
  final int reviews;
  final String badge;
  final bool inStock;
  final String image;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;
  final String description;
  final List<String> features;
  final bool isBestSeller;
  final bool isTrending;
  final String gender;
  final String shelfLocation;

  const Product({
    required this.id,
    required this.qrCode,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.rating,
    required this.reviews,
    required this.badge,
    required this.inStock,
    required this.image,
    required this.images,
    required this.colors,
    required this.sizes,
    required this.description,
    required this.features,
    this.isBestSeller = false,
    this.isTrending = false,
    this.gender = 'Unisex',
    this.shelfLocation = 'Aisle 3, Shelf B-4 (Luggage Section)',
  });

  // Backward compatibility getters
  String get title => name;
  String get categoryId => category;
  String get segment => gender;
}

class HeroBannerItem {
  final String id;
  final String tag;
  final String title;
  final String buttonText;
  final String image;
  final String category;

  const HeroBannerItem({
    required this.id,
    required this.tag,
    required this.title,
    required this.buttonText,
    required this.image,
    required this.category,
  });
}

class CuratedOffer {
  final String id;
  final String title;
  final String offer;
  final String cta;
  final String image;
  final String category;

  const CuratedOffer({
    required this.id,
    required this.title,
    required this.offer,
    required this.cta,
    required this.image,
    required this.category,
  });
}

class StoreLocation {
  final String id;
  final String name;
  final String city;
  final String address;
  final String timing;
  final String phone;
  final String distance;
  final double rating;
  final int reviews;
  final String image;
  final String tag;
  final List<String> availableFeatures;

  const StoreLocation({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.timing,
    required this.phone,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.tag,
    required this.availableFeatures,
  });
}

class ValueProp {
  final IconData icon;
  final String title;
  final String desc;

  const ValueProp({
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class Testimonial {
  final String id;
  final String name;
  final String role;
  final int rating;
  final String comment;
  final String avatar;

  const Testimonial({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.comment,
    required this.avatar,
  });
}

class Coupon {
  final String code;
  final double discountPercent;
  final bool isFreeShipping;
  final String desc;

  const Coupon({
    required this.code,
    required this.discountPercent,
    required this.isFreeShipping,
    required this.desc,
  });
}

class CartItem {
  final Product product;
  int quantity;
  String selectedColor;
  String selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor = '',
    this.selectedSize = '',
  });

  double get totalPrice => product.price * quantity;
}

// --- CUSTOMER PROFILE & ORDER MODELS (Web App 1:1) ---

class CustomerProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String badge;

  const CustomerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    this.badge = 'Verified Shopper',
  });
}

class CustomerOrderItem {
  final String id;
  final String name;
  final String image;
  final double price;
  final int quantity;

  const CustomerOrderItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });
}

class CustomerOrder {
  final String orderId;
  final String date;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final String city;
  final List<CustomerOrderItem> items;

  const CustomerOrder({
    required this.orderId,
    required this.date,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.city,
    required this.items,
  });
}

// --- VENDOR / SELLER PERSONA MODEL ---

class VendorPersona {
  final String id;
  final String name;
  final String role;
  final String email;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeTextColor;
  final String avatar;
  final List<String> permissions;

  const VendorPersona({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeTextColor,
    required this.avatar,
    required this.permissions,
  });

  bool hasPermission(String perm) => permissions.contains(perm);
}

class VendorOrder {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String channel; // 'POS (Counter)' or 'ONLINE'
  final double totalAmount;
  final String status; // 'Delivered', 'Shipped', 'Ready for Pickup', 'Pending'
  final String time;
  final String date;
  final List<String> items;

  const VendorOrder({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.channel,
    required this.totalAmount,
    required this.status,
    required this.time,
    required this.date,
    required this.items,
  });
}

// --- STATE MANAGER ---

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal() {
    // Pre-populate with 2 default cart items for initial realistic experience
    _cart.add(CartItem(
      product: DummyData.products[0],
      quantity: 1,
      selectedColor: DummyData.products[0].colors.isNotEmpty ? DummyData.products[0].colors[0] : 'Olive',
      selectedSize: DummyData.products[0].sizes.isNotEmpty ? DummyData.products[0].sizes[0] : '28L',
    ));
    _cart.add(CartItem(
      product: DummyData.products[1],
      quantity: 1,
      selectedColor: DummyData.products[1].colors.isNotEmpty ? DummyData.products[1].colors[0] : 'Matte Black',
      selectedSize: DummyData.products[1].sizes.isNotEmpty ? DummyData.products[1].sizes[0] : 'Standard',
    ));

    // Pre-populate wishlist with 2 items
    _wishlist.add(DummyData.products[2]);
    _wishlist.add(DummyData.products[13]);
  }

  final List<CartItem> _cart = [];
  final List<Product> _wishlist = [];
  Coupon? _appliedCoupon;
  VendorPersona? _currentVendorPersona;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }

  CustomerProfile? _currentCustomer = const CustomerProfile(
    id: 'USR-1082',
    name: 'Vicky Sharma',
    email: 'vicky@example.com',
    phone: '+91 98765 43210',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=120&auto=format&fit=crop&q=80',
    badge: 'Verified Shopper',
  );

  final List<CustomerOrder> _customerOrders = [
    const CustomerOrder(
      orderId: 'ORD-92841',
      date: '18 Sep 2026, 04:30 PM',
      totalAmount: 3598.0,
      paymentMethod: 'UPI Instant',
      status: 'Delivered',
      city: 'New Delhi',
      items: [
        CustomerOrderItem(
          id: 'p1',
          name: 'Minimalist Everyday Backpack',
          image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&auto=format&fit=crop&q=80',
          price: 2499.0,
          quantity: 1,
        ),
        CustomerOrderItem(
          id: 'p2',
          name: 'Wireless Noise-Cancelling Headphones',
          image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80',
          price: 1099.0,
          quantity: 1,
        ),
      ],
    ),
    const CustomerOrder(
      orderId: 'ORD-78102',
      date: '14 Sep 2026, 11:15 AM',
      totalAmount: 1799.0,
      paymentMethod: 'Card Ending in •••• 8921',
      status: 'Delivered',
      city: 'Downtown Center',
      items: [
        CustomerOrderItem(
          id: 'p3',
          name: 'Classic Organic Cotton Hoodie',
          image: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500&auto=format&fit=crop&q=80',
          price: 1799.0,
          quantity: 1,
        ),
      ],
    ),
  ];

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<Product> get wishlist => List.unmodifiable(_wishlist);
  Coupon? get appliedCoupon => _appliedCoupon;
  VendorPersona? get currentVendorPersona => _currentVendorPersona;
  bool get isVendorLoggedIn => _currentVendorPersona != null;

  CustomerProfile? get currentCustomer => _currentCustomer;
  bool get isCustomerLoggedIn => _currentCustomer != null;
  List<CustomerOrder> get customerOrders => List.unmodifiable(_customerOrders);

  StoreLocation? _selectedStore;
  StoreLocation get selectedStore => _selectedStore ?? DummyData.stores[0];
  void setSelectedStore(StoreLocation store) {
    _selectedStore = store;
    notifyListeners();
  }

  void loginCustomer(CustomerProfile profile) {
    _currentCustomer = profile;
    notifyListeners();
  }

  void logoutCustomer() {
    _currentCustomer = null;
    notifyListeners();
  }

  void addCustomerOrder(CustomerOrder order) {
    _customerOrders.insert(0, order);
    notifyListeners();
  }

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  int get wishlistCount => _wishlist.length;

  double get subtotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get discountAmount {
    if (_appliedCoupon == null) return 0.0;
    return subtotal * _appliedCoupon!.discountPercent;
  }
  double get shippingFee {
    if (_appliedCoupon?.isFreeShipping == true || subtotal >= 999 || _cart.isEmpty) {
      return 0.0;
    }
    return 99.0;
  }
  double get taxAmount => (subtotal - discountAmount) * 0.12; // 12% GST
  double get grandTotal => _cart.isEmpty ? 0.0 : (subtotal - discountAmount + shippingFee + taxAmount);

  bool isInWishlist(String productId) => _wishlist.any((p) => p.id == productId);

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  void addToCart(Product product, {String? color, String? size, int quantity = 1}) {
    final effectiveColor = color ?? (product.colors.isNotEmpty ? product.colors.first : '');
    final effectiveSize = size ?? (product.sizes.isNotEmpty ? product.sizes.first : '');

    final index = _cart.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedColor == effectiveColor &&
        item.selectedSize == effectiveSize);

    if (index != -1) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        quantity: quantity,
        selectedColor: effectiveColor,
        selectedSize: effectiveSize,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int delta) {
    item.quantity += delta;
    if (item.quantity <= 0) {
      _cart.remove(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _appliedCoupon = null;
    notifyListeners();
  }

  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    final coupon = DummyData.coupons.firstWhere(
      (c) => c.code == cleanCode,
      orElse: () => const Coupon(code: '', discountPercent: 0, isFreeShipping: false, desc: ''),
    );
    if (coupon.code.isNotEmpty) {
      _appliedCoupon = coupon;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  // --- VENDOR PERSONA METHODS ---
  void loginAsVendorPersona(VendorPersona persona) {
    _currentVendorPersona = persona;
    notifyListeners();
  }

  void logoutVendor() {
    _currentVendorPersona = null;
    notifyListeners();
  }

  bool hasVendorPermission(String perm) {
    if (_currentVendorPersona == null) return false;
    return _currentVendorPersona!.hasPermission(perm);
  }
}

// --- DUMMY DATA FROM LIVE SHOPMATE ---

class DummyData {
  // 6 Primary Categories
  static final List<Category> categories = [
    const Category(
      id: 'cat-electronics',
      name: 'Electronics',
      slug: 'electronics',
      icon: LucideIcons.headphones,
      image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80',
      subcategories: ['Audio & Headphones', 'Smart Wearables', 'Gadgets & Accessories'],
      itemCount: 18,
    ),
    const Category(
      id: 'cat-fashion',
      name: 'Fashion',
      slug: 'fashion',
      icon: LucideIcons.shirt,
      image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop&q=80',
      subcategories: ["Men's Collection", "Women's Collection", 'Casual & Loungewear'],
      itemCount: 24,
    ),
    const Category(
      id: 'cat-home',
      name: 'Home & Kitchen',
      slug: 'home-kitchen',
      icon: LucideIcons.armchair,
      image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500&auto=format&fit=crop&q=80',
      subcategories: ['Modern Furniture', 'Kitchen & Coffee', 'Home Decor & Lamps'],
      itemCount: 16,
    ),
    const Category(
      id: 'cat-beauty',
      name: 'Beauty & Care',
      slug: 'beauty',
      icon: LucideIcons.sparkles,
      image: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500&auto=format&fit=crop&q=80',
      subcategories: ['Luxury Perfumes', 'Skincare Essentials', 'Organic Wellness'],
      itemCount: 12,
    ),
    const Category(
      id: 'cat-sports',
      name: 'Sports & Gear',
      slug: 'sports',
      icon: LucideIcons.activity,
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=80',
      subcategories: ['Athletic Footwear', 'Gym Gear & Travel Bags', 'Outdoor Equipment'],
      itemCount: 15,
    ),
    const Category(
      id: 'cat-accessories',
      name: 'Accessories',
      slug: 'accessories',
      icon: LucideIcons.watch,
      image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=80',
      subcategories: ['Smart Watches', 'Eyewear & Wallets', 'Everyday Carry'],
      itemCount: 14,
    ),
  ];

  // 20 Authentic ShopMate Catalog Products
  static final List<Product> products = [
    const Product(
      id: 'PROD-001',
      qrCode: 'QR-SM-001',
      name: 'Nordic Olive Travel Backpack 28L',
      category: 'Sports & Gear',
      subcategory: 'Gym Gear & Travel Bags',
      brand: 'NORDIC LAB',
      price: 1799,
      originalPrice: 2999,
      discount: 40,
      rating: 4.9,
      reviews: 158,
      badge: 'Best Seller',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Olive Green', 'Matte Black', 'Sand Dune'],
      sizes: ['24L', '28L', '32L'],
      description: 'Engineered for seamless urban exploration and weekend travel. Crafted from water-resistant recycled ripstop nylon with padded laptop sleeve and hidden anti-theft compartments.',
      features: [
        'Water-resistant recycled ripstop fabric',
        'Dedicated 16-inch padded laptop pocket',
        'Ergonomic breathable back panel',
        'Hidden passport & wallet compartment',
      ],
      isBestSeller: true,
      isTrending: true,
    ),
    const Product(
      id: 'PROD-002',
      qrCode: 'QR-SM-002',
      name: 'Acoustic Aura Wireless ANC Headphones',
      category: 'Electronics',
      subcategory: 'Audio & Headphones',
      brand: 'AURA AUDIO',
      price: 2999,
      originalPrice: 4999,
      discount: 40,
      rating: 4.8,
      reviews: 320,
      badge: 'Top Rated',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Matte Black', 'Silver Frost', 'Midnight Navy'],
      sizes: ['Over-Ear'],
      description: 'Experience pure acoustic immersion with active noise cancellation, custom 40mm titanium drivers, and 45-hour extended battery life.',
      features: [
        'Hybrid Active Noise Cancellation (-38dB)',
        '40mm custom titanium dynamic drivers',
        '45 hours playtime with quick charge',
        'Ultra-plush memory foam ear cushions',
      ],
      isBestSeller: true,
      isTrending: true,
    ),
    const Product(
      id: 'PROD-003',
      qrCode: 'QR-SM-003',
      name: 'Smart Watch Series 8 Elegance',
      category: 'Accessories',
      subcategory: 'Smart Watches',
      brand: 'KRONOS TECH',
      price: 2499,
      originalPrice: 4499,
      discount: 44,
      rating: 4.7,
      reviews: 210,
      badge: 'Popular',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Space Gray', 'Rose Gold', 'Silver Frost'],
      sizes: ['41mm', '45mm'],
      description: 'Sleek stainless steel casing with vibrant AMOLED always-on display, heart rate monitor, SpO2 sensor, and 7-day battery life.',
      features: [
        '1.78-inch HD AMOLED curved display',
        'Continuous 24/7 Heart & SpO2 tracking',
        'IP68 50m water resistance rating',
        'Magnetic rapid-charge dock included',
      ],
      isTrending: true,
    ),
    const Product(
      id: 'PROD-004',
      qrCode: 'QR-SM-004',
      name: 'CloudStrider Feather Running Shoes',
      category: 'Sports & Gear',
      subcategory: 'Athletic Footwear',
      brand: 'AEROSTEP',
      price: 3499,
      originalPrice: 5499,
      discount: 36,
      rating: 4.6,
      reviews: 88,
      badge: 'Hot Deal',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Crimson Red', 'Ghost White', 'Carbon Black'],
      sizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10', 'UK 11'],
      description: 'Engineered for lightweight road running. Breathable knitted upper with responsive dual-density nitrogen infused foam midsole.',
      features: [
        'Breathable seamless jacquard upper',
        'Nitrogen-infused high rebound midsole',
        'High-abrasion herringbone rubber outsole',
      ],
      isBestSeller: true,
    ),
    const Product(
      id: 'PROD-005',
      qrCode: 'QR-SM-005',
      name: "L'Aura Botanical Luxury Eau De Parfum",
      category: 'Beauty & Care',
      subcategory: 'Luxury Perfumes',
      brand: "L'AURA PARIS",
      price: 1999,
      originalPrice: 3499,
      discount: 43,
      rating: 4.9,
      reviews: 142,
      badge: 'Signature',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Glass Amber'],
      sizes: ['50ml', '100ml'],
      description: 'Sophisticated botanical fragrance crafted in Grasse. Top notes of Italian bergamot, heart of wild jasmine, and base of amber musk.',
      features: [
        'Cruelty-free & 100% vegan formula',
        'Long-lasting 12+ hour sillage',
        'Hand-polished heavyweight flacon',
      ],
      isTrending: true,
    ),
    const Product(
      id: 'PROD-006',
      qrCode: 'QR-SM-006',
      name: 'Minimalist Sage Ceramic Lounge Chair',
      category: 'Home & Kitchen',
      subcategory: 'Modern Furniture',
      brand: 'STUDIO NORDIC',
      price: 8999,
      originalPrice: 14999,
      discount: 40,
      rating: 4.9,
      reviews: 76,
      badge: '50% Off Special',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Sage Olive', 'Cream Linen', 'Charcoal Grey'],
      sizes: ['Single Seater'],
      description: 'Scandinavian minimalist aesthetic designed for elevated living spaces. High resilience foam with textured bouclé upholstery.',
      features: [
        'Kiln-dried solid beech wood internal frame',
        'Premium stain-resistant bouclé textile',
        'Ergonomic lumbar contoured silhouette',
      ],
    ),
    const Product(
      id: 'PROD-007',
      qrCode: 'QR-SM-007',
      name: 'Barista Touch Espresso Machine',
      category: 'Home & Kitchen',
      subcategory: 'Kitchen & Coffee',
      brand: 'BREW CRAFT',
      price: 6499,
      originalPrice: 9999,
      discount: 35,
      rating: 4.8,
      reviews: 115,
      badge: "Chef's Choice",
      inStock: true,
      image: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Brushed Steel', 'Matte Black'],
      sizes: ['Standard'],
      description: 'Cafe quality espresso at home. 15-bar Italian pressure pump with microfoam milk texturing steam wand.',
      features: [
        '15-bar high pressure Italian pump',
        'Instant thermo-block rapid heating system',
        'Commercial style 54mm portafilter',
      ],
    ),
    const Product(
      id: 'PROD-008',
      qrCode: 'QR-SM-008',
      name: 'Organic Olive Relaxed Cotton Tee',
      category: 'Fashion',
      subcategory: "Men's Collection",
      brand: 'SHOPMATE ORIGINALS',
      price: 799,
      originalPrice: 1299,
      discount: 38,
      rating: 4.7,
      reviews: 94,
      badge: 'Eco-Friendly',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Sage Olive', 'Onyx Black', 'Chalk White'],
      sizes: ['S', 'M', 'L', 'XL'],
      description: 'Crafted from 100% GOTS certified organic combed cotton. Pre-shrunk with ribbed crewneck collar.',
      features: [
        '240 GSM heavyweight combed cotton',
        'Eco-friendly non-toxic reactive dyes',
        'Drop-shoulder relaxed everyday cut',
      ],
      isBestSeller: true,
    ),
    const Product(
      id: 'PROD-009',
      qrCode: 'QR-SM-009',
      name: 'Lumbar Comfort Studio Desk Lamp',
      category: 'Home & Kitchen',
      subcategory: 'Home Decor & Lamps',
      brand: 'LUMEN STUDIO',
      price: 1499,
      originalPrice: 2499,
      discount: 40,
      rating: 4.8,
      reviews: 63,
      badge: 'Staff Pick',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Warm Brass', 'Matte Black'],
      sizes: ['Tabletop'],
      description: 'Minimalist architectural desk lamp with flicker-free warm LED lighting and stepless rotary dimmer.',
      features: [
        'CRI > 95 daylight color rendering',
        'Stepless touch dimmer with memory',
        'Heavyweight cast-iron weighted base',
      ],
    ),
    const Product(
      id: 'PROD-010',
      qrCode: 'QR-SM-010',
      name: 'Classic Amber Polarized Sunglasses',
      category: 'Accessories',
      subcategory: 'Eyewear & Wallets',
      brand: 'SOLARIS EYEWEAR',
      price: 1199,
      originalPrice: 1999,
      discount: 40,
      rating: 4.9,
      reviews: 110,
      badge: 'Summer Must-Have',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Tortoise Amber', 'Gloss Black'],
      sizes: ['Medium 52mm'],
      description: 'Handcrafted Italian acetate frames with TAC polarized UV400 lenses reducing glare across all outdoor environments.',
      features: [
        '100% UV400 category 3 sun protection',
        'Hand-finished Italian cellulose acetate',
        'Includes vegan leather hard case & cloth',
      ],
    ),
    const Product(
      id: 'PROD-011',
      qrCode: 'QR-SM-011',
      name: 'CULT Men Regular Fit Track Pants',
      category: 'Fashion',
      subcategory: "Men's Collection",
      brand: 'CULTSPORT',
      price: 1239,
      originalPrice: 2599,
      discount: 52,
      rating: 4.8,
      reviews: 703,
      badge: '52% OFF',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Dark Charcoal', 'Navy Blue', 'Olive Green'],
      sizes: ['M', 'L', 'XL', 'XXL'],
      description: 'Moisture-wicking 4-way stretch fabric engineered for athletic recovery, training sessions, and relaxed weekend travel.',
      features: [
        'Quick-dry sweat-wicking technology',
        'Concealed zippered secure side pockets',
        'Elasticated waistband with inner drawcord',
      ],
      isBestSeller: true,
    ),
    const Product(
      id: 'PROD-012',
      qrCode: 'QR-SM-012',
      name: 'Heavyweight Oversized Streetwear Hoodie',
      category: 'Fashion',
      subcategory: "Men's Collection",
      brand: 'SHOPMATE ORIGINALS',
      price: 1899,
      originalPrice: 3499,
      discount: 45,
      rating: 4.9,
      reviews: 412,
      badge: 'Trending',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Sage Olive', 'Onyx Black', 'Oatmeal Heather'],
      sizes: ['M', 'L', 'XL'],
      description: 'Crafted with 420 GSM French terry cotton. Preshrunk, dropped shoulders, and relaxed boxy streetwear fit.',
      features: [
        '420 GSM heavyweight French terry',
        'Double-layered structured hood without drawcords',
        'Seamless kangaroo pouch pocket',
      ],
      isTrending: true,
    ),
    const Product(
      id: 'PROD-013',
      qrCode: 'QR-SM-013',
      name: 'Royal Silk Blend Embroidered Kurta Set',
      category: 'Fashion',
      subcategory: "Men's Collection",
      brand: 'SHOPMATE HERITAGE',
      price: 2999,
      originalPrice: 5999,
      discount: 50,
      rating: 4.9,
      reviews: 189,
      badge: 'Festive Special',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Emerald Green', 'Royal Navy', 'Ivory Gold'],
      sizes: ['38', '40', '42', '44'],
      description: 'Handcrafted mulberry silk blend kurta set with delicate tonal threadwork embroidery along the collar and placket.',
      features: [
        'Lustrous lightweight silk-blend fabric',
        'Intricate hand-stitched mandarin collar',
        'Paired with matching tapered churidar pyjama',
      ],
    ),
    const Product(
      id: 'PROD-014',
      qrCode: 'QR-SM-014',
      name: 'Nike Air Jordan 1 Low Retro Mocha',
      category: 'Sports & Gear',
      subcategory: 'Athletic Footwear',
      brand: 'JORDAN',
      price: 8999,
      originalPrice: 12999,
      discount: 30,
      rating: 4.9,
      reviews: 512,
      badge: 'Iconic Drop',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Mocha Brown / Sail', 'Shadow Grey'],
      sizes: ['UK 7.5', 'UK 8.5', 'UK 9.5', 'UK 10.5'],
      description: 'Iconic basketball silhouette rendered in premium suede and full-grain leather overlays with encapsulated Air-Sole cushioning.',
      features: [
        'Full-grain leather and soft nubuck upper',
        'Encapsulated Air-Sole unit in heel',
        'Solid rubber cupsole with deep flex grooves',
      ],
      isBestSeller: true,
      isTrending: true,
    ),
    const Product(
      id: 'PROD-015',
      qrCode: 'QR-SM-015',
      name: 'Nike Dunk Low Retro Panda White/Black',
      category: 'Sports & Gear',
      subcategory: 'Athletic Footwear',
      brand: 'NIKE',
      price: 7499,
      originalPrice: 10999,
      discount: 31,
      rating: 4.9,
      reviews: 845,
      badge: 'Best Seller',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['White / Black'],
      sizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
      description: 'The definitive streetwear grail. Crisp leather overlays with contrasting black paneling and padded low-cut collar.',
      features: [
        'Crisp leather upper that softens over time',
        'Lightweight foam midsole for responsive cushioning',
        'Iconic pivot circle traction tread',
      ],
      isBestSeller: true,
    ),
    const Product(
      id: 'PROD-016',
      qrCode: 'QR-SM-016',
      name: 'New Balance 550 Vintage White & Forest Green',
      category: 'Sports & Gear',
      subcategory: 'Athletic Footwear',
      brand: 'NEW BALANCE',
      price: 6999,
      originalPrice: 9999,
      discount: 30,
      rating: 4.8,
      reviews: 320,
      badge: 'Retro Classic',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Sea Salt / Forest Green'],
      sizes: ['UK 8', 'UK 9', 'UK 10'],
      description: '1989 archival basketball classic revived for modern street style. Premium perforated leather with heritage rubber cupsole.',
      features: [
        'Heavyweight premium perforated leather',
        'Durable non-marking vintage rubber outsole',
        'Signature puffed N logo on side quarters',
      ],
    ),
    const Product(
      id: 'PROD-017',
      qrCode: 'QR-SM-017',
      name: 'Adidas Samba OG Classic Cloud White',
      category: 'Sports & Gear',
      subcategory: 'Athletic Footwear',
      brand: 'ADIDAS',
      price: 5499,
      originalPrice: 7999,
      discount: 31,
      rating: 4.9,
      reviews: 640,
      badge: 'Street Staple',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Cloud White / Core Black / Gum'],
      sizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
      description: 'Timeless indoor soccer icon reimagined for everyday lifestyle. Soft leather upper with suede T-toe and classic gum sole.',
      features: [
        'Full grain leather upper with grit suede T-toe',
        'Soft synthetic leather sockliner',
        'Authentic translucent low-profile gum rubber sole',
      ],
      isBestSeller: true,
      isTrending: true,
    ),
    const Product(
      id: 'PROD-018',
      qrCode: 'QR-SM-018',
      name: 'Chronograph Stainless Steel Luxury Watch',
      category: 'Accessories',
      subcategory: 'Smart Watches',
      brand: 'VALENTIN',
      price: 3999,
      originalPrice: 7999,
      discount: 50,
      rating: 4.9,
      reviews: 178,
      badge: '50% OFF',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Silver Sunray', 'All Black', 'Rose Gold'],
      sizes: ['42mm Case'],
      description: 'Japanese quartz chronograph movement encased in marine-grade 316L stainless steel with sapphire-coated crystal glass.',
      features: [
        'Marine-grade 316L solid stainless steel',
        'Japanese precision multi-dial chronograph',
        'Water-resistant to 10 ATM (100 meters)',
      ],
    ),
    const Product(
      id: 'PROD-019',
      qrCode: 'QR-SM-019',
      name: 'Women High-Rise Performance Gym Leggings',
      category: 'Sports & Gear',
      subcategory: 'Gym Gear & Travel Bags',
      brand: 'AURA ACTIVE',
      price: 1299,
      originalPrice: 2499,
      discount: 48,
      rating: 4.8,
      reviews: 380,
      badge: 'Top Rated',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Sage Green', 'Midnight Black', 'Berry Purple'],
      sizes: ['XS', 'S', 'M', 'L'],
      description: 'Buttery-soft compressive fabric designed for high-intensity training, yoga sessions, and active running.',
      features: [
        'Zero-chafing flatlock seam engineering',
        'Wide non-slip high waistband stays put',
        'Dual deep lateral phone storage pockets',
      ],
    ),
    const Product(
      id: 'PROD-020',
      qrCode: 'QR-SM-020',
      name: '100% French Linen Relaxed Resort Shirt',
      category: 'Fashion',
      subcategory: "Men's Collection",
      brand: 'SHOPMATE ORIGINALS',
      price: 1699,
      originalPrice: 2999,
      discount: 43,
      rating: 4.8,
      reviews: 140,
      badge: 'Pure Linen',
      inStock: true,
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop&q=80',
      ],
      colors: ['Natural Oatmeal', 'Sky Blue', 'Crisp White'],
      sizes: ['M', 'L', 'XL'],
      description: 'Woven from premium Normandy flax fibers. Ultra-breathable, moisture-wicking and softens with every wash.',
      features: [
        '100% genuine French flax linen',
        'Camp collar styling with curved hemline',
        'Natural mother-of-pearl button detailing',
      ],
    ),
  ];

  // Hero Carousel Banners
  static final List<HeroBannerItem> heroBanners = [
    const HeroBannerItem(
      id: 'banner-1',
      tag: 'PUMA / RETRO',
      title: 'Sneakers That Move With You, Comfortable, Durable, And Always In Style.',
      buttonText: 'Find Your Fit',
      image: 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800&auto=format&fit=crop&q=80',
      category: 'Sports & Gear',
    ),
    const HeroBannerItem(
      id: 'banner-2',
      tag: 'NIKE / ADIDAS',
      title: 'Fresh Drops. Iconic Silhouettes. Sneakers That Speak Before You Do.',
      buttonText: 'Get Your Pair',
      image: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&auto=format&fit=crop&q=80',
      category: 'Sports & Gear',
    ),
    const HeroBannerItem(
      id: 'banner-3',
      tag: 'ORIGINALS',
      title: 'STYLE-STACK: Curated Streetwear Essentials For Everyday Rotation',
      buttonText: 'Shop Sneakers',
      image: 'https://images.unsplash.com/photo-1512374382149-233c42b661ac?w=800&auto=format&fit=crop&q=80',
      category: 'Sports & Gear',
    ),
  ];

  // Curated Offer Cards
  static final List<CuratedOffer> curatedOffers = [
    const CuratedOffer(
      id: 'cat-ethnic',
      title: 'Ethnic Wear',
      offer: '50-80% OFF',
      cta: 'Shop Now',
      image: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=600&auto=format&fit=crop&q=80',
      category: 'Fashion',
    ),
    const CuratedOffer(
      id: 'cat-casual',
      title: 'Casual Wear',
      offer: '40-80% OFF',
      cta: 'Shop Now',
      image: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&auto=format&fit=crop&q=80',
      category: 'Fashion',
    ),
    const CuratedOffer(
      id: 'cat-men-active',
      title: 'Activewear',
      offer: '30-70% OFF',
      cta: 'Shop Now',
      image: 'https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=600&auto=format&fit=crop&q=80',
      category: 'Sports & Gear',
    ),
    const CuratedOffer(
      id: 'cat-western',
      title: 'Western Wear',
      offer: '40-70% OFF',
      cta: 'Shop Now',
      image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop&q=80',
      category: 'Fashion',
    ),
    const CuratedOffer(
      id: 'cat-sneakers',
      title: "Men's Sneakers",
      offer: '30-60% OFF',
      cta: 'Shop Now',
      image: 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=600&auto=format&fit=crop&q=80',
      category: 'Sports & Gear',
    ),
    const CuratedOffer(
      id: 'cat-loungewear',
      title: 'Loungewear',
      offer: '30-60% OFF',
      cta: 'Shop Now',
      image: 'https://images.unsplash.com/photo-1576995853123-5a10305d9370?w=600&auto=format&fit=crop&q=80',
      category: 'Fashion',
    ),
  ];

  // Physical Stores
  static final List<StoreLocation> stores = [
    const StoreLocation(
      id: 'store-downtown',
      name: 'ShopMate Flagship - Downtown Galleria',
      city: 'Downtown Center',
      address: '450 Grand Avenue, Level 2, Suite 210',
      timing: '10:00 AM - 10:00 PM (Open Today)',
      phone: '+1 (555) 234-8900',
      distance: '1.2 km away',
      rating: 4.9,
      reviews: 412,
      image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&auto=format&fit=crop&q=80',
      tag: 'Flagship Experience Center',
      availableFeatures: ['Express QR Self-Checkout', 'Curbside Pickup', 'Smart Fitting Rooms', 'Product Demos'],
    ),
    const StoreLocation(
      id: 'store-metro',
      name: 'ShopMate Express - Metro Promenade',
      city: 'Westside Hub',
      address: 'Shop 42, Central Concourse, Metro Rail Station',
      timing: '9:00 AM - 11:00 PM (Open Today)',
      phone: '+1 (555) 345-6712',
      distance: '3.8 km away',
      rating: 4.7,
      reviews: 290,
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500&auto=format&fit=crop&q=80',
      tag: 'Express Store',
      availableFeatures: ['Scan & Go Mobile Pay', 'Instant Locker Pickup', 'Top 100 Best Sellers'],
    ),
    const StoreLocation(
      id: 'store-cyber',
      name: 'ShopMate Tech Hub - Silicon Square',
      city: 'Tech Valley',
      address: 'Block B, Ground Floor, Cyber Park Avenue',
      timing: '10:00 AM - 9:30 PM (Open Today)',
      phone: '+1 (555) 789-1234',
      distance: '5.4 km away',
      rating: 4.8,
      reviews: 345,
      image: 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=500&auto=format&fit=crop&q=80',
      tag: 'Smart Tech Store',
      availableFeatures: ['Smart Audio Testing Booth', 'QR Scan & Reserve', 'Tech Support Bar'],
    ),
    const StoreLocation(
      id: 'store-greenpark',
      name: 'ShopMate Lifestyle - Green Valley Mall',
      city: 'Green Valley',
      address: 'Wing C, First Floor, Green Valley Mall',
      timing: '10:30 AM - 10:00 PM (Open Today)',
      phone: '+1 (555) 901-4321',
      distance: '7.1 km away',
      rating: 4.9,
      reviews: 518,
      image: 'https://images.unsplash.com/photo-1528698827591-e19ccd7bc23d?w=500&auto=format&fit=crop&q=80',
      tag: 'Lifestyle & Decor Outlet',
      availableFeatures: ['Furniture Lounge', 'Scan & Ship to Home', 'Fragrance Bar'],
    ),
  ];

  // Value Props Bar
  static final List<ValueProp> valueProps = [
    const ValueProp(
      icon: LucideIcons.truck,
      title: 'Free Shipping',
      desc: 'On orders over ₹999',
    ),
    const ValueProp(
      icon: LucideIcons.shieldCheck,
      title: 'Secure Payment',
      desc: '100% secure payment',
    ),
    const ValueProp(
      icon: LucideIcons.refreshCw,
      title: 'Easy Returns',
      desc: '30 days return policy',
    ),
    const ValueProp(
      icon: LucideIcons.headphones,
      title: '24/7 Support',
      desc: 'Dedicated support team',
    ),
  ];

  // Customer Reviews
  static final List<Testimonial> testimonials = [
    const Testimonial(
      id: 'test-1',
      name: 'John R.',
      role: 'Verified Buyer',
      rating: 5,
      comment: 'Amazing products and fast delivery! ShopMate is my go-to store for all my lifestyle and tech needs. The quality is exceptional.',
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=120&auto=format&fit=crop&q=80',
    ),
    const Testimonial(
      id: 'test-2',
      name: 'Sarah M.',
      role: 'Interior Designer',
      rating: 5,
      comment: 'Great quality at affordable prices. The Nordic backpack and studio desk lamp exceeded my expectations in person.',
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120&auto=format&fit=crop&q=80',
    ),
    const Testimonial(
      id: 'test-3',
      name: 'Aarav M.',
      role: 'Tech Enthusiast',
      rating: 5,
      comment: 'Very happy with my wireless headphones and sneaker purchase. Sleek aesthetics and seamless in-store QR checkout!',
      avatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=120&auto=format&fit=crop&q=80',
    ),
  ];

  // Promo Coupons
  static final List<Coupon> coupons = [
    const Coupon(
      code: 'SHOP50',
      discountPercent: 0.50,
      isFreeShipping: false,
      desc: '50% off for new shoppers',
    ),
    const Coupon(
      code: 'SAVE20',
      discountPercent: 0.20,
      isFreeShipping: false,
      desc: '20% off on all orders',
    ),
    const Coupon(
      code: 'FREESHIP',
      discountPercent: 0.0,
      isFreeShipping: true,
      desc: 'Free standard shipping',
    ),
  ];

  // Fast Demo Personas for Seller Portal
  static final List<VendorPersona> vendorPersonas = [
    const VendorPersona(
      id: 'persona-owner',
      name: 'Rajesh Sharma',
      role: 'Store Owner',
      email: 'rajesh.sharma@urbanthreads.in',
      subtitle: 'Rajesh • Full 100% Access',
      icon: LucideIcons.store,
      iconColor: Color(0xFFE11D48),
      badgeBg: Color(0xFFFCE7F3),
      badgeTextColor: Color(0xFFBE185D),
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=120&auto=format&fit=crop&q=80',
      permissions: [
        'dashboard',
        'orders',
        'pos',
        'attendance',
        'employees',
        'products',
        'add-product',
        'shop',
        'analytics',
      ],
    ),
    const VendorPersona(
      id: 'persona-cashier',
      name: 'Rahul Verma',
      role: 'Cashier Staff',
      email: 'rahul.cashier@urbanthreads.in',
      subtitle: 'Rahul • POS & Orders Only',
      icon: LucideIcons.creditCard,
      iconColor: Color(0xFF059669),
      badgeBg: Color(0xFFD1FAE5),
      badgeTextColor: Color(0xFF047857),
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=120&auto=format&fit=crop&q=80',
      permissions: [
        'dashboard',
        'orders',
        'pos',
        'attendance',
      ],
    ),
    const VendorPersona(
      id: 'persona-inventory',
      name: 'Sneha Kapoor',
      role: 'Inventory Staff',
      email: 'sneha.inventory@urbanthreads.in',
      subtitle: 'Sneha • Catalog & Stock',
      icon: LucideIcons.boxes,
      iconColor: Color(0xFF6366F1),
      badgeBg: Color(0xFFE0E7FF),
      badgeTextColor: Color(0xFF4338CA),
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120&auto=format&fit=crop&q=80',
      permissions: [
        'dashboard',
        'orders',
        'products',
        'add-product',
        'attendance',
      ],
    ),
  ];

  // Vendor Recent Orders
  static final List<VendorOrder> vendorOrders = [
    const VendorOrder(
      orderId: 'ORD-VN-9041',
      customerName: 'Priya Verma',
      customerPhone: '+91 99200 88771',
      channel: 'POS (Counter)',
      totalAmount: 4299,
      status: 'Delivered',
      time: '03:45 PM',
      date: '10 Mar 2026',
      items: ['AeroGlide Pro Court Low Sneakers'],
    ),
    const VendorOrder(
      orderId: 'ORD-VN-9042',
      customerName: 'Aarav Mehta',
      customerPhone: '+91 98112 33441',
      channel: 'ONLINE',
      totalAmount: 1999,
      status: 'Ready for Pickup',
      time: '01:15 PM',
      date: '10 Mar 2026',
      items: ['ShopMate Heritage Oversized Hoodie'],
    ),
    const VendorOrder(
      orderId: 'ORD-VN-9039',
      customerName: 'Kabir Singhania',
      customerPhone: '+91 97110 55223',
      channel: 'ONLINE',
      totalAmount: 5398,
      status: 'Shipped',
      time: '04:10 PM',
      date: '09 Mar 2026',
      items: ['Raw Selvedge Relaxed Cargo Denim'],
    ),
    const VendorOrder(
      orderId: 'ORD-VN-9035',
      customerName: 'Ananya Sharma',
      customerPhone: '+91 98111 22345',
      channel: 'POS (Counter)',
      totalAmount: 2999,
      status: 'Delivered',
      time: '11:20 AM',
      date: '09 Mar 2026',
      items: ['Acoustic Aura Wireless ANC Headphones'],
    ),
  ];
}
