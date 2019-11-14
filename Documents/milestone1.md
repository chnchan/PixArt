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
    - This is used for local storage (refilling last entered username, storing drawings on device for unregistered users)


## View Controllers
- Login View Controller
    - This view is where the user log in is handled
    - If log in is successful, we will fetch all the information relevant to the user on the server and store it into variables whose values will be passed on to the Profile View Controller and subsequent Works View Controller
- 
