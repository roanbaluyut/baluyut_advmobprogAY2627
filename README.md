# Roan Justine B. Baluyut
## INF231
## CTADMOBL Advance Mobile Programming
 
A Flutter project that focuses on advance topics. Covering the Mobile to web transactions.
 
## Lab Activity 3: discussion

The Cart Model is responsible for converting the JSON data from the API into Cart and CartProduct objects. The Cart Service handles the cart endpoints and gets the needed cart information from the API, then returns the parsed data. The Cart Screen uses the service to get the cart information and displays the items that are currently added to the cart.

To reach the same detail_screen.dart, the Cart Screen gets the ID from the cart item that was selected and uses getById from the ProductService to get the complete information of the product. After getting the Product object, it passes it to the same ProductDetailsScreen that is also used by the product listing. This allows the user to select an item from the cart and still access its product details.

The updated design still follows the Model-Service-Screen pattern, but the Cart Screen now uses two different services, which are CartService and ProductService. This shows how one screen can use multiple services to complete a feature and handle different types of data.
