Project AlcoFlag final report:
Official repository (Git): https://afaci@bitbucket.org/afaci/alcoflag.git

Information for App-Store submission:

Meta-Tags: alcohol, calculator, flag-indicator, animated
Description: With this simple App you'll see your current drunkness level.
             It is very easy to use and contains lots of pre-defined drinks.

Used APIs:
    * Covered in the lecture
        - CollectionView
            Showing user- and predefined drinks for the add-view.
        - TableView
            Showing all added drinks in a list.
        - Animations
            Appearance of PickerView and scrolling of ScrollView.
        - NSUserDefaults
            Saving user-data (weight and gender)
        - NSJsonSerialization
            Saving drink-data as json file in the storage.
    * Not covered in the lecture
        - Sharing (Social-Kit)
            Sharing current drunk-level to Twitter.
        - ImagePicker (Camera, Photo-Library)
            Add a new drink by providing a picture.
        - AnimatedGIF (extenal API)
            Show the flag animation

ViewControllers:
    * (Main)ViewController
        Shows current drinking level and the sober-at time.
    * AddDrinkController
        Adds a new drink to current session. Drinks are shown in a CollectionView.
    * EditController
        Editing and Deleting drinks.
    * SettingsController
        Adjust user-data (weight and gender) as well as use Notifications.
    * InstructionView
        Show a short instruction with texts and images on first start.

Tested devices:
    iPhone 5s (iOS 8.1)

Limitations:
    User has to be logged-in in a Twitter-Account (just for Sharing)

Known issures:
    LaunchScreen.xib is localized but always shown in English.
    2015-06-21 23:11:49.782 AlcoFlag[2200:25184] Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
    