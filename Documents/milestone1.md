# PixArt - Milestone 1

**Link to our Trello board:** https://trello.com/b/Nrt4UUJa

---

## UI Design



## Libraries Used
- Firebase
    - Used to store relevant user data (drawings, settings, etc)
    - Also utilize the provided authentication functions to facilitate user log in
-  Color Slider
    - Used to provide the user with a color selector to use while drawing



## Models
- Firebase Cloud Firestore
    - As mentioned in the libraries function, we will be utilizing Firebase's Cloud Firestore to store the relevant user data
- Core Data
    - This is used for local storage (refilling last entered username, storing drawings on device once anonymous users are supported)


## View Controllers
- Login View Controller
    - This view is where the user log in is handled, calls Firebase Auth functions, handles any error in text field entry
    - If log in is successful, we will fetch all the information relevant to the user on the server and store it into variables whose values will be passed on to the Profile View Controller and subsequent Works View Controller
    - Successful login navigates us to the Profile View
- Side Menu View Controller
    - The Side Menu View is visible on every page of the app except the Login View
    - This view allows the user to quickly switch between pages of the app
    - The app navigates to whichever view corresponds the user selects on the side menu
- Profile View Controller
    - Display the username and profile picture
- Canvas View Controller
    - This is where the main function of the app is, the drawing
    - User can select a color via the color slider and then draw onto the grid through tapping on an individual square or by dragging their finger.
    - The user can also save the image they have created
    - Eventually, this image will be stored on to the server and passed to the Works View for dispaly there
-  Works View Controller
    - This is where all of the user's stored images will be displayed
    - Will involve fetching drawings from Cloud Firestore
    - Will contain works table view cells (detailed below)
- Works Table View Cell
    - Displays the drawing
    - Number of likes/dislikes
    - Give the user the option to share their drawing so that it will appear in the public feed
- Feed View Controller
    - Drawings that users have shared will appear here
    - Users will be able to slide to like, dislike, dismiss drawings by swiping in the appropriate direction
    
