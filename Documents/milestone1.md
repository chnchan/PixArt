# PixArt - Milestone 1

**Link to our Trello board:** https://trello.com/b/Nrt4UUJa

**Link to Github Classroom Project:** https://github.com/ECS189E/project-f19-pixelart
---

## UI Design
Log In

![Mockup1](https://user-images.githubusercontent.com/8505929/68826086-4819f600-0651-11ea-98e0-067e6d2b75c1.png)

Side Menu and Canvas

![Picture1](https://user-images.githubusercontent.com/8505929/68825533-47806000-064f-11ea-9d03-0c19680f2b10.png)

Profile and Works (Has been separated into two views), Feed

![Picture2](https://user-images.githubusercontent.com/8505929/68825618-9a5a1780-064f-11ea-9265-d1b306bd10b8.png)

## Libraries Used
- Firebase
    - Used to store relevant user data (drawings, settings, etc)
    - Also utilize the provided authentication functions to facilitate user log in
-  Color Slider
    - Used to provide the user with a color selector to use while drawing

## Server Support
- Will use Firebase as mentioned above

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

## Timeline
- User Login, storing and fetching data to/from server for appropriate user - Done by Nov 17
- Improve, unify UI across views to get our desired aesthetic - Done by Nov 20
- Support sharing images to one global feed where users can like and dislike images - Done by Nov 23
- Improve drawing canvas by having different size options and the ability for the user to zoom in on the grid for more fine control - Done by Nov 25
- Test app features/usability - Done by Nov 30
- Make sure app conforms to Apple guideline for submission to App store - done by Dec 1
- Submit app to be published in the App store - Done by Dec 2
- Push for 250 active users - Done by Dec 7

## Testing Plan
- What to Test
    - Login flow (How long does it take to sign up/login)
    - Usability of drawing canvas (How well does the canvas work for drawing? 1-10)
    - Functionality of sharing drawings to global feed (How good is the feed for viewing others drawings? 1-5)
    - General app responsiveness (How fast/responsive is the app? 1-10)
    - General app bugginess (How buggy is the app? 1-10)
- Testing group
    - Tech oriented: other cs students, heavy phone users
    - More casual user: older family members
