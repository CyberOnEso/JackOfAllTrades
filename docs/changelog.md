### Version 0.1-alpha
  * If you run the addon on the live server it will not cause any errors. It simply will not register any events or try to call anything from the CP 2.0 System.
### Version 0.2-alpha
  * Fixed the undefined variable in the AddonLoaded function, thank you Votan!
### Version 0.3-alpha
  * Rewrote CP assigning functions to use an object-oriented paradigm. Should help in the future
  * Separated Events and Skill functions into separate files to keep things clean.
### Version 0.4-alpha
  * Added settings menu allowing you to customize when and how warnings will be shown if you do not have enough CP points allocated into the skill to slot it.
  * Added support for localization.
### Version 0.5-alpha
  * When we are unable to slot CP points into a node, due to being in combat etc. We will attempt to slot the node again once combat ends.
  * Will remember which skill should be set back afer a reload UI!
  * If you reload UI whilst in combat with it will slot your original CP back after combat ends after the reload UI ends, this took more effort than it is probably worth.
  * Added method of finding names, discipline data automatically.
  * Improved localization support
