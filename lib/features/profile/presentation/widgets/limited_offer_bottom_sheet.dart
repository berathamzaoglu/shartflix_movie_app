import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shartflix_movie_app/l10n/app_localizations.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF090909),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Stack(children: [

         Positioned(
              top: -100,
              left: 0,
              right: 0,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 216.25, sigmaY: 216.25),
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFB00020), // Kırmızı
                        Colors.transparent,
                      ],
                      radius: 0.8,
                    ),
                  ),
                ),
              ),
            ),

            // Alt kırmızı glow + blur
            Positioned(
              bottom: -100,
              left: 0,
              right: 0,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 216.25, sigmaY: 216.25),
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFB00020),
                        Colors.transparent,
                      ],
                      radius: 0.8,
                    ),
                  ),
                ),
              ),
            ),


      
      Column(
       
        children: [

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Limited Offer Section
                  _buildLimitedOfferSection(context, l10n),
                  
                  const SizedBox(height: 20),
                  
                  // Bonuses Section
                  _buildBonusesSection(context, l10n),
                  
                  const SizedBox(height: 20),
                  
                  // Token Packages Section
                  _buildTokenPackagesSection(context, l10n),
                  
                  const SizedBox(height: 30),
                  
                  
                  // Call to Action Button
                  
                  FilledButton(onPressed: () {}, child: Text(l10n.limited_offer_view_all_tokens, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),)),
                  // _buildCallToActionButton(context, l10n),
                  
                  // Extra padding at bottom for safe area
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
          ],
        )
    );
  }

  Widget _buildLimitedOfferSection(BuildContext context, AppLocalizations l10n) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.limited_offer_title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.limited_offer_description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      
    );
  }

  Widget _buildBonusesSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
       gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            Colors.white.withAlpha(25),   // %10 opacity
            Colors.white.withAlpha(8), // %3 opacity
          ],
          stops:const  [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(25), width: 1),
      ),
      child: Column(
        children: [
          Text(
            l10n.limited_offer_bonuses_title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBonusItem(context, 'assets/images/offer_1.png', l10n.limited_offer_premium_account),
              _buildBonusItem(context, 'assets/images/offer_2.png', l10n.limited_offer_more_matches),
              _buildBonusItem(context, 'assets/images/offer_3.png', l10n.limited_offer_featured),
              _buildBonusItem(context, 'assets/images/offer_4.png', l10n.limited_offer_more_likes),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBonusItem(BuildContext context, String image, String label) {
    return Column(
      children: [

        
    Container(
          width: 55,
          height: 55,
          padding: const EdgeInsets.all(10),
          decoration:const BoxDecoration(
               boxShadow: [
              // Beyaz iç ışık efekti (simülasyon)
              BoxShadow(
                color: Colors.white, // %100 opaklık
                spreadRadius:-1,
                
                blurRadius: 0,
                offset: Offset(0, 0),
              ),

              // Koyu kırmızı iç glow gölge
              BoxShadow(
                color: Color(0xFF6F060B),
                blurRadius: 8.5,
                offset: Offset(0, 0),
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: Image.asset(image, ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTokenPackagesSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.limited_offer_select_package,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Row(
                      children: [
              Expanded(child: _buildTokenPackage(context, '200', '330', '₺99,99', '+10%', true, l10n)),
              const SizedBox(width: 12),
              Expanded(child: _buildTokenPackage(context, '2.000', '3.375', '₺799,99', '+70%', false, l10n, isRecommended: true)),
              const SizedBox(width: 12),
              Expanded(child: _buildTokenPackage(context, '1.000', '1.350', '₺399,99', '+35%', true, l10n)),
            ],
        ),
      ],
    );
  }

  Widget _buildTokenPackage(BuildContext context, String original, String newAmount, String price, String bonus, bool isRed, AppLocalizations l10n, {bool isRecommended = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        
        // Main card container
        Container(
          height: 217,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors:isRed  ? [const Color(0xFF6F060B), const Color(0xFFE50914)] : [const Color(0xFF5949E6), const Color(0xFFE50914)],
              stops: const [0.2, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(102), width: 1),
            boxShadow: [
              BoxShadow(
                blurStyle: BlurStyle.inner,
                color: Colors.white.withAlpha(76),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              )
            
            ],
          ),
          child: Column(
            children: [
           
              const SizedBox(height: 12),
              
              // Token Amounts Section - Centered
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Original amount (strikethrough)
                    Text(
                      original,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // New amount (prominent)
                    Text(
                      newAmount,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // "Jeton" text
                    Text(
                      'Jeton',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Separator line
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.3),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              
              // Price Section - Centered
              Column(
                children: [
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.limited_offer_weekly,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
           // Top glow effect - extending upward
        Positioned(
  top: -12,
  left: 24,


          
          child: Container(
            height: 25,
            width: 61,
         
            decoration: BoxDecoration(


                boxShadow: [
                // Beyaz iç ışık efekti (simülasyon)
               const  BoxShadow(
                  color: Colors.white, // %100 opaklık
                  spreadRadius: -1,
                  
                  blurRadius: 0,
                  offset: Offset(0, 0),
                ),

                // Koyu kırmızı iç glow gölge
                BoxShadow(
                  color:  isRed ? const Color(0xFF6F060B) : const Color(0xFF5949E6),
                  blurRadius: 8.5,
                  offset: const Offset(0, 0),
                ),
              ],
            //  color: isRed ? const Color(0xFFDC2626) : const Color(0xFF7C3AED),
              borderRadius:  BorderRadius.circular(24),
            ),

            child:Center(child: Text(bonus, style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
           
            ),)),
          ),
        ),
     
      ],
    );
  }

}

// Helper function to show the bottom sheet
void showLimitedOfferBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    
    isScrollControlled: true,
    showDragHandle: false,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.75,
    ),
    builder: (context) => const LimitedOfferBottomSheet(),
  );
} 
