# Roan Justine B. Baluyut
## INF231
## CTADMOBL Advance Mobile Programming
 
A Flutter project that focuses on advance topics. Covering the Mobile to web transactions.
 
## Lab Activity 2: discussion

The product.dart(models)  is responsible for defining what the product should have its fields etc. Meanwhile product_service.dart(services) is the only one who touches the json directly and transmute it into a dart object by calling product.dart(models). Lastly, product_screen.dart(screens) is just a container for the screen of search bar and list of products(dart object), and then product_detail_screen.dart(screens) displays the products.  In summary, product.dart(models) defines the data, product_service.dart(services) is how to get the data, and screens(product_screen.dart, product_detail_screen.dart) displays the processed data.

The current design pattern is different from the old one. The theme toggle feature is now handled by a separate theme_provider.dart(providers) class instead of living directly inside a screen. The new design is the model/service pattern that was discuss earlier.