# Roan Justine B. Baluyut
## INF231
## CTADMOBL Advance Mobile Programming
 
A Flutter project that focuses on advance topics. Covering the Mobile to web transactions.
 
## Lab Activity 4: discussion

The User Model stores the information of the user that is received from the API, while the UserService is responsible for handling the authentication and saving the user's information using SharedPreferences. The Profile Screen then gets the saved user information through the UserService and uses the User Model to display the user's details.

The updated design still follows the Model-Service-Screen pattern, where the Model handles the data, the Service manages the API requests and saved information, and the Screen is responsible for displaying the data to the user.

The saved userId is also used to display the correct cart for the logged-in user. The Profile Screen gets the user's ID from the User Model and passes it to the CartService. The CartService then uses the ID to retrieve the cart information that belongs to that specific user and displays it on the Cart Screen.
