# Limited Offer System

## Overview

The Limited Offer System presents premium subscription options through an engaging bottom sheet modal interface. The system features multiple pricing tiers with bonus benefits, secure payment processing integration, and dynamic promotional content to enhance user engagement and conversion rates.

## Core Features

### 1. Limited Offer Bottom Sheet

#### User Interface Elements
- **Header Section**:
  - Title: "Sınırlı Teklif" (Limited Offer)
  - Subtitle: "Jeton paketini seçerek bonus kazanın ve yeni bölümlerin kilidini açın!"
  - Promotional messaging with urgency indicators

- **Benefits Section**:
  - "Alacağınız Bonuslar" (Bonuses You'll Receive)
  - Four bonus categories with icons:
    - Premium Hesap (Diamond icon)
    - Daha Fazla Eşleşme (Hearts icon) 
    - Öne Çıkarma (Arrow up icon)
    - Daha Fazla Beğeni (Heart icon)

- **Pricing Tiers**:
  - Three subscription packages with promotional discounts
  - Percentage savings indicators (+10%, +70%, +35%)
  - Token amounts and pricing in Turkish Lira
  - "Başına haftalık" (Per week) pricing structure

- **Call-to-Action**:
  - "Tüm Jetonları Gör" (View All Tokens) primary button
  - Social login integration buttons

#### Technical Implementation
```dart
// Limited Offer Bottom Sheet Widget
class LimitedOfferBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          LimitedOfferHeader(),
          BonusBenefitsSection(),
          PricingTiersSection(),
          CallToActionButton(),
          SocialLoginOptions(),
        ],
      ),
    );
  }
}

// Header Component
class LimitedOfferHeader extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Sınırlı Teklif',
            style: AppTextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Jeton paketini seçerek bonus kazanın ve yeni bölümlerin kilidini açın!',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```

### 2. Bonus Benefits Display

#### Benefits Configuration
```dart
// Bonus Benefits Data Model
class BonusBenefit {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  BonusBenefit({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}

// Benefits Configuration
class BonusBenefitsConfig {
  static List<BonusBenefit> getBenefits() {
    return [
      BonusBenefit(
        title: 'Premium Hesap',
        description: 'Özel içeriklere erişim',
        icon: Icons.diamond,
        iconColor: Colors.cyan,
        backgroundColor: Colors.cyan.withOpacity(0.2),
      ),
      BonusBenefit(
        title: 'Daha Fazla Eşleşme',
        description: 'Günlük eşleşme sayısı artışı',
        icon: Icons.favorite,
        iconColor: Colors.pink,
        backgroundColor: Colors.pink.withOpacity(0.2),
      ),
      BonusBenefit(
        title: 'Öne Çıkarma',
        description: 'Profilinizi öne çıkarın',
        icon: Icons.trending_up,
        iconColor: Colors.orange,
        backgroundColor: Colors.orange.withOpacity(0.2),
      ),
      BonusBenefit(
        title: 'Daha Fazla Beğeni',
        description: 'Günlük beğeni limiti artışı',
        icon: Icons.favorite_border,
        iconColor: Colors.red,
        backgroundColor: Colors.red.withOpacity(0.2),
      ),
    ];
  }
}
```

#### Benefits Display Component
```dart
class BonusBenefitsSection extends StatelessWidget {
  Widget build(BuildContext context) {
    final benefits = BonusBenefitsConfig.getBenefits();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alacağınız Bonuslar',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: benefits.length,
            itemBuilder: (context, index) {
              return BonusBenefitCard(benefit: benefits[index]);
            },
          ),
        ],
      ),
    );
  }
}

class BonusBenefitCard extends StatelessWidget {
  final BonusBenefit benefit;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: benefit.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              benefit.icon,
              color: benefit.iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  benefit.title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  benefit.description,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3. Pricing Tiers Implementation

#### Pricing Data Model
```dart
class PricingTier {
  final String id;
  final String name;
  final int originalTokens;
  final int bonusTokens;
  final int totalTokens;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;
  final String period;
  final bool isPopular;
  final Color gradientStart;
  final Color gradientEnd;

  PricingTier({
    required this.id,
    required this.name,
    required this.originalTokens,
    required this.bonusTokens,
    required this.totalTokens,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.period,
    this.isPopular = false,
    required this.gradientStart,
    required this.gradientEnd,
  });

  double get weeklyPrice => discountedPrice / 4; // Assuming monthly pricing
  String get formattedPrice => '₺${discountedPrice.toStringAsFixed(2)}';
  String get formattedOriginalPrice => '₺${originalPrice.toStringAsFixed(2)}';
  String get formattedWeeklyPrice => '₺${weeklyPrice.toStringAsFixed(2)}';
}
```

#### Pricing Configuration
```dart
class PricingConfig {
  static List<PricingTier> getPricingTiers() {
    return [
      PricingTier(
        id: 'basic',
        name: 'Başlangıç Paketi',
        originalTokens: 200,
        bonusTokens: 130,
        totalTokens: 330,
        originalPrice: 99.99,
        discountedPrice: 99.99,
        discountPercentage: 10,
        period: 'monthly',
        gradientStart: AppColors.redGradientStart,
        gradientEnd: AppColors.redGradientEnd,
      ),
      PricingTier(
        id: 'premium',
        name: 'Premium Paketi',
        originalTokens: 2000,
        bonusTokens: 1375,
        totalTokens: 3375,
        originalPrice: 799.99,
        discountedPrice: 799.99,
        discountPercentage: 70,
        period: 'monthly',
        isPopular: true,
        gradientStart: AppColors.purpleGradientStart,
        gradientEnd: AppColors.purpleGradientEnd,
      ),
      PricingTier(
        id: 'pro',
        name: 'Pro Paketi',
        originalTokens: 1000,
        bonusTokens: 350,
        totalTokens: 1350,
        originalPrice: 399.99,
        discountedPrice: 399.99,
        discountPercentage: 35,
        period: 'monthly',
        gradientStart: AppColors.redGradientStart,
        gradientEnd: AppColors.redGradientEnd,
      ),
    ];
  }
}
```

#### Pricing Card Implementation
```dart
class PricingTierCard extends StatelessWidget {
  final PricingTier tier;
  final VoidCallback onTap;
  final bool isSelected;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [tier.gradientStart, tier.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
              ? Border.all(color: Colors.white, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Discount Badge
            if (tier.discountPercentage > 0)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${tier.discountPercentage}%',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: tier.gradientStart,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Main Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Token Display
                  Column(
                    children: [
                      Text(
                        tier.originalTokens.toString(),
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white.withOpacity(0.7),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        tier.totalTokens.toString(),
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Jeton',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Pricing Display
                  Column(
                    children: [
                      Text(
                        tier.formattedPrice,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Başına haftalık',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4. Payment Integration

#### Payment Service with Dio
```dart
class PaymentService {
  static final dio = Dio();

  static Future<PaymentResult> processPurchase({
    required String tierID,
    required String paymentMethod,
    required Map<String, dynamic> paymentDetails,
  }) async {
    try {
      final response = await dio.post(
        '/payments/purchase',
        data: {
          'tier_id': tierID,
          'payment_method': paymentMethod,
          'payment_details': paymentDetails,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${TokenStorage.getToken()}',
            'Content-Type': 'application/json',
          },
        ),
      );

      return PaymentResult.fromJson(response.data);
    } catch (e) {
      throw PaymentException('Payment processing failed: $e');
    }
  }

  static Future<List<PaymentMethod>> getAvailablePaymentMethods() async {
    try {
      final response = await dio.get(
        '/payments/methods',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${TokenStorage.getToken()}',
          },
        ),
      );

      return (response.data['data']['methods'] as List)
          .map((json) => PaymentMethod.fromJson(json))
          .toList();
    } catch (e) {
      throw PaymentException('Failed to fetch payment methods: $e');
    }
  }
}

// Payment API Endpoints
/*
POST /payments/purchase
Authorization: Bearer {token}
Content-Type: application/json

Request Body:
{
  "tier_id": "premium",
  "payment_method": "credit_card",
  "payment_details": {
    "card_token": "card_token_here",
    "billing_address": {
      "country": "TR",
      "city": "Istanbul"
    }
  }
}

Response:
{
  "success": true,
  "data": {
    "transaction_id": "txn_123456",
    "status": "completed",
    "tokens_awarded": 3375,
    "subscription": {
      "id": "sub_123",
      "tier": "premium",
      "starts_at": "2024-01-20T15:30:00Z",
      "expires_at": "2024-02-20T15:30:00Z"
    }
  }
}
*/
```

#### Payment State Management
```dart
// Payment BLoC
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService paymentService;

  PaymentBloc({required this.paymentService}) : super(PaymentInitial());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is PaymentProcessRequested) {
      yield PaymentProcessing();
      
      try {
        final result = await paymentService.processPurchase(
          tierID: event.tierID,
          paymentMethod: event.paymentMethod,
          paymentDetails: event.paymentDetails,
        );
        
        yield PaymentSuccess(result: result);
      } catch (e) {
        yield PaymentFailure(error: e.toString());
      }
    }
  }
}

// Payment States
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentResult result;
  PaymentSuccess({required this.result});
}

class PaymentFailure extends PaymentState {
  final String error;
  PaymentFailure({required this.error});
}

// Payment Events
abstract class PaymentEvent {}

class PaymentProcessRequested extends PaymentEvent {
  final String tierID;
  final String paymentMethod;
  final Map<String, dynamic> paymentDetails;

  PaymentProcessRequested({
    required this.tierID,
    required this.paymentMethod,
    required this.paymentDetails,
  });
}
```

### 5. User Experience Features

#### Loading and Success States
```dart
class PurchaseFlowManager extends StatefulWidget {
  final PricingTier selectedTier;

  @override
  State<PurchaseFlowManager> createState() => _PurchaseFlowManagerState();
}

class _PurchaseFlowManagerState extends State<PurchaseFlowManager> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          _showSuccessDialog(state.result);
        } else if (state is PaymentFailure) {
          _showErrorDialog(state.error);
        }
      },
      builder: (context, state) {
        if (state is PaymentProcessing) {
          return PaymentLoadingIndicator();
        }
        
        return PaymentMethodSelection(
          tier: widget.selectedTier,
          onPaymentMethodSelected: _processPurchase,
        );
      },
    );
  }

  void _processPurchase(String paymentMethod, Map<String, dynamic> details) {
    context.read<PaymentBloc>().add(
      PaymentProcessRequested(
        tierID: widget.selectedTier.id,
        paymentMethod: paymentMethod,
        paymentDetails: details,
      ),
    );
  }

  void _showSuccessDialog(PaymentResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PurchaseSuccessDialog(result: result),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => PurchaseErrorDialog(error: error),
    );
  }
}
```

## Analytics and Conversion Tracking

### Purchase Analytics
```dart
class PurchaseAnalytics {
  static void trackOfferViewed({
    required String source,
    Map<String, dynamic>? metadata,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'limited_offer_viewed',
      parameters: {
        'source': source,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...?metadata,
      },
    );
  }

  static void trackTierSelected({
    required String tierID,
    required double price,
    required int tokens,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'pricing_tier_selected',
      parameters: {
        'tier_id': tierID,
        'price': price,
        'tokens': tokens,
      },
    );
  }

  static void trackPurchaseStarted({
    required String tierID,
    required String paymentMethod,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'purchase_started',
      parameters: {
        'tier_id': tierID,
        'payment_method': paymentMethod,
      },
    );
  }

  static void trackPurchaseCompleted({
    required String tierID,
    required double revenue,
    required String currency,
  }) {
    FirebaseAnalytics.instance.logPurchase(
      value: revenue,
      currency: currency,
      parameters: {
        'tier_id': tierID,
        'item_category': 'subscription',
      },
    );
  }
}
```

## Security Features

### Payment Security
- **PCI Compliance**: Secure payment processing
- **Token Validation**: Server-side token verification
- **Fraud Detection**: Transaction monitoring
- **Data Encryption**: Sensitive data protection

### Purchase Validation
```dart
class PurchaseValidator {
  static Future<bool> validatePurchase({
    required String transactionID,
    required String tierID,
  }) async {
    try {
      final response = await Dio().post(
        '/payments/validate',
        data: {
          'transaction_id': transactionID,
          'tier_id': tierID,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${TokenStorage.getToken()}',
          },
        ),
      );

      return response.data['data']['is_valid'] == true;
    } catch (e) {
      LoggerService.error('Purchase validation failed: $e');
      return false;
    }
  }
}
```

## Testing Strategy

### Purchase Flow Testing
```dart
group('Limited Offer Tests', () {
  testWidgets('should display pricing tiers correctly', (tester) async {
    await tester.pumpWidget(
      TestWrapper(child: LimitedOfferBottomSheet()),
    );

    // Verify all pricing tiers are displayed
    expect(find.text('330'), findsOneWidget);
    expect(find.text('3.375'), findsOneWidget);
    expect(find.text('1.350'), findsOneWidget);
  });

  testWidgets('should handle tier selection', (tester) async {
    await tester.pumpWidget(
      TestWrapper(child: LimitedOfferBottomSheet()),
    );

    // Tap on premium tier
    await tester.tap(find.text('3.375'));
    await tester.pumpAndSettle();

    // Verify tier is selected
    expect(find.byType(PaymentMethodSelection), findsOneWidget);
  });
});
```

## Performance Optimizations

### UI Performance
- Efficient gradient rendering
- Optimized animations
- Memory-conscious image loading
- Lazy loading for payment methods

### Network Optimization
- Cached pricing data
- Optimistic UI updates
- Retry mechanisms for payment failures
- Connection timeout handling 