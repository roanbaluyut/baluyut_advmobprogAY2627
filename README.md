# Roan Justine B. Baluyut
## INF231
## CTADMOBL Advance Mobile Programming
 
A Flutter project that focuses on advance topics. Covering the Mobile to web transactions.

## Lab Activity 1: Discussion

State management in Flutter is the process of managing and updating the data in an application. It helps Flutter know when to refresh the user interface after data changes. There are two types of state used in this activity: ephemeral state and app state. Ephemeral state is temporary and only affects one widget or a small part of the app. It is usually managed using setState(), such as a counter that changes when a button is pressed and resets when the widget is rebuilt. On the other hand, app state is shared across the entire application and is used by multiple screens or widgets. It is commonly managed using Provider. An example of app state is the Light Mode and Dark Mode setting, which remains the same across different screens in the application.
 
## Lab Activity 2: Discussion

The product.dart(models)  is responsible for defining what the product should have its fields etc. Meanwhile product_service.dart(services) is the only one who touches the json directly and transmute it into a dart object by calling product.dart(models). Lastly, product_screen.dart(screens) is just a container for the screen of search bar and list of products(dart object), and then product_detail_screen.dart(screens) displays the products.  In summary, product.dart(models) defines the data, product_service.dart(services) is how to get the data, and screens(product_screen.dart, product_detail_screen.dart) displays the processed data.

The current design pattern is different from the old one. The theme toggle feature is now handled by a separate theme_provider.dart(providers) class instead of living directly inside a screen. The new design is the model/service pattern that was discuss earlier.
