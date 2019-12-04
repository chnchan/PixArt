# PixArt - Sprint Planning

**Dev Team:** Hin Chan, Ronald Guerra, Jiahao Chen, Pavit Bath

**Short Summary:** Pixart is a pixel art creation tool with the ability to share and browse through other people's work.

**Link to our Trello board:** https://trello.com/b/Nrt4UUJa

**General meeting schedule:**
In-person meeting: Monday 5pm - 6pm
Discord meeting: Wednesday and Saturday after 7 pm. May change depending on everyone’s schedule.


---


### Discord meeting on Tues (11/5) Recap
- UI Views (code and storyboard) for Pixel Art Maker (use a “view” for placeholder, will discuss how to implement the implementation starting week 2), UI Views (code and storyboard) for the social media portion by end of this week.
- Fluid animation / transition. 
- Note: Try to make every view controller into its own storyboard so we don’t run into conflicting git pushes.
---


### In person meeting on Thurs (11/7) Recap
- One person will do the UIs design. Otherwise, the style will be all over the place.
- Updated communication method:If you know something doesn’t work or needs to be completed, add it to TODOS in discord. (add it when you stop working)Write down files you will be working on on discord to prevent git conflicts.
---


### Discord meeting on Sat (11/9) Recap
Completed:
- Hin finished the UI portion, note: UI design is not finalized. Link to commit: https://github.com/ECS189E/project-f19-pixelart/commit/6ab2253996a4ab9fdc55c0a5b7dd72ced5cff85a

Target:
- Google firebase
  - Have users, be able to login
- UI improvement
- See process to push app to AppStore
---


### In person meeting on Tues (11/12)
Completed:
- Ronald finished the Canvas logic (can draw and display result in image viewer). Link to commit: https://github.com/ECS189E/project-f19-pixelart/commit/acc4e396b3ab851809a9351c158cf9e286edc3e3
- Minor bug fixes.

Target for this week:
- Pavit will look into firebase, and hopefully get login by milestone 1.
- Bug fixes (color picker doesn’t show initial color, tap doesn’t draw, etc.)
- UI improvement
- create API handler, data structure for each “post”.
---


### Discord meeting on Sat (11/16)
Implemented:
- Sign up page implemented, users now able to create accounts and login, drawings associated with user accounts, stored on server. 
- Created CoreData Adapter since function calls to CoreData tend to be chunky. Will improve readability of code
- Redesigned Works UI

Goal for next meeting:
- Store drawing as GridView object to support editing the drawing
---


### In person meeting on Tues (11/19)
Implemented:
- Redesigned Canvas UI.
- Canvas can change grid size on Profile and Settings popup in Canvas.
- Added Works detail page.

Goal for next meeting:
- Have Feeds complete by next week (meaning pulling random published art (backend)).
---


### Discord meeting on Tues (11/19) at night
Completed Written Plan
---


### In person meeting on Thurs (11/21) after milestones 2

Goals:
- Clean up code
- Ronald: fix Zoom, able to slide after zoomed in
- Pavit: backend support for social media
- Hin: UI, Transition logics
- Jiahao: debug, and help out
---


### Discord meeting on Sat (11/23)

Completed: 
- Login redesigned. Card-looking style. 
- Zoom restrained
- Backend random fetching support

Goals:
- Zoom restrain should be different for different canvas size
- Apply card-looking style to the rest of the views
- Connect random fetching to feeds
---


### In person meeting on Tues (11/26)

Completed:
- Redesigned profile view, Canvas view

Goals:
- (see previous, everyone was studying for quiz for the weekend)
---


### Discord meeting on Wed (11/27)

Completed: 
- UI design done

For Thanksgiving:
- Test app and find bugs
---


### In-person meeting on Tues (12/3)

Bugs found:
- Works view showing in side menu. **FIXED**
- Feeds view crashes on fetch. **IN PROGRESS** (b/c art was not inserted in the database with UUID. Should be fixed after wiping database)
- Collection view (Works view) lag as user scroll. **IN PROGRESS**

Goals:
- Fix bug and optimize.

---
