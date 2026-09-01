# Roan Justine B. Baluyut
## INF231
## CTADMOBL Advance Mobile Programming
 
A Flutter project that focuses on advance topics. Covering the Mobile to web transactions.

 ## Lab Activity 1: Discussion

State management in Flutter is the process of managing and updating the data in an application. It helps Flutter know when to refresh the user interface after data changes. There are two types of state used in this activity: ephemeral state and app state. Ephemeral state is temporary and only affects one widget or a small part of the app. It is usually managed using setState(), such as a counter that changes when a button is pressed and resets when the widget is rebuilt. On the other hand, app state is shared across the entire application and is used by multiple screens or widgets. It is commonly managed using Provider. An example of app state is the Light Mode and Dark Mode setting, which remains the same across different screens in the application.
 
## Lab Activity 2: Discussion

The product.dart(models)  is responsible for defining what the product should have its fields etc. Meanwhile product_service.dart(services) is the only one who touches the json directly and transmute it into a dart object by calling product.dart(models). Lastly, product_screen.dart(screens) is just a container for the screen of search bar and list of products(dart object), and then product_detail_screen.dart(screens) displays the products.  In summary, product.dart(models) defines the data, product_service.dart(services) is how to get the data, and screens(product_screen.dart, product_detail_screen.dart) displays the processed data.

The current design pattern is different from the old one. The theme toggle feature is now handled by a separate theme_provider.dart(providers) class instead of living directly inside a screen. The new design is the model/service pattern that was discuss earlier.

## Lab Activity 3: discussion

The Cart Model is responsible for converting the JSON data from the API into Cart and CartProduct objects. The Cart Service handles the cart endpoints and gets the needed cart information from the API, then returns the parsed data. The Cart Screen uses the service to get the cart information and displays the items that are currently added to the cart.

To reach the same detail_screen.dart, the Cart Screen gets the ID from the cart item that was selected and uses getById from the ProductService to get the complete information of the product. After getting the Product object, it passes it to the same ProductDetailsScreen that is also used by the product listing. This allows the user to select an item from the cart and still access its product details.

The updated design still follows the Model-Service-Screen pattern, but the Cart Screen now uses two different services, which are CartService and ProductService. This shows how one screen can use multiple services to complete a feature and handle different types of data.
