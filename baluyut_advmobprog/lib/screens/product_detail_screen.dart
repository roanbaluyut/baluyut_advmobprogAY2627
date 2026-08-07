import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// models
import '../models/product.dart';

// widgets
import '../widgets/custom_text.dart';

// Enhancement 2: Opened from ProductScreen when a card is tapped it shows the full product information for that item.
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: product.title,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.thumbnail,
                width: double.infinity,
                height: 260.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 260.h,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 48),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: product.title,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: product.brand,
                      fontSize: 13.sp,
                      fontStyle: FontStyle.italic,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        CustomText(
                          text: '\$${product.price.toStringAsFixed(2)}',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(width: 8.w),
                        if (product.discountPercentage > 0)
                          CustomText(
                            text:
                                '-${product.discountPercentage.toStringAsFixed(0)}%',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: product.rating.toStringAsFixed(1),
                          fontSize: 13.sp,
                        ),
                        SizedBox(width: 12.w),
                        CustomText(
                          text: 'Stock: ${product.stock}',
                          fontSize: 13.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'Description',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(text: product.description, fontSize: 14.sp),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'Warranty: ${product.warrantyInformation}',
                      fontSize: 13.sp,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: 'Shipping: ${product.shippingInformation}',
                      fontSize: 13.sp,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: 'Availability: ${product.availabilityStatus}',
                      fontSize: 13.sp,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: 'Return Policy: ${product.returnPolicy}',
                      fontSize: 13.sp,
                    ),
                    SizedBox(height: 20.h),

                    // A plain divider + extra top spacing is enough to read
                    // as "a new section", without turning it into its own card.
                    Divider(height: 1, color: Colors.grey.shade300),
                    SizedBox(height: 16.h),

                    // Reviews section
                    CustomText(
                      text: 'Reviews (${product.reviews.length})',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10.h),
                    if (product.reviews.isEmpty)
                      CustomText(text: 'No reviews yet.', fontSize: 13.sp)
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: product.reviews.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final review = product.reviews[index];
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                      text: review.reviewerName,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const Spacer(),
                                    // Star rating out of 5 for this review
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          i < review.rating
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 14.sp,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                CustomText(
                                  text: review.date.isNotEmpty
                                      ? review.date.substring(
                                          0,
                                          review.date.length >= 10
                                              ? 10
                                              : review.date.length,
                                        )
                                      : '',
                                  fontSize: 11.sp,
                                ),
                                SizedBox(height: 6.h),
                                CustomText(
                                  text: review.comment,
                                  fontSize: 13.sp,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
