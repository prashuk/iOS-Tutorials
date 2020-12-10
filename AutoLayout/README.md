# Auto Layout 

Auto Layout allows us to set rules as to how we want our views to be displayed. Because mobile screens have different resolutions and sizes, we need these rules to tell the iPhone/iPad how it should layout all the elements in the storyboard onto the display. These rules allow our UI elements to be resized and positioned so that no matter which screen they are displayed on, they always look as the designer intended.

* Add constraints and understanding how Auto Layout works.
* Pin and Align elements.
* Create containers to configure advanced layouts.
* Debug auto layout errors.
* Understanding what Xcode needs in order to correctly layout a design.
* Stack Views to create complex interfaces.
* The **priority** really come in to play only if two different constraints conflict. The system will give importance to the one with higher priority. So, Priority is the tie-breaker in the autolayout world.
* Set the buttons horizontal **Compression** Resistance Priority to 1000. And now, change the priority of the width constraint to any value between 0 to 999. ie; less than the horizontal Compression Resistance Priority of the button.
* **Hugging**: Sets the priority with which a view resists being made larger than its intrinsic size. Setting a larger value to this priority indicates that we don’t want the view to grow larger than its content.
* https://medium.com/@abhimuralidharan/ios-content-hugging-and-content-compression-resistance-priorities-476fb5828ef

