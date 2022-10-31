# Reqs
Recommendation app to search for, organize, and save the places you love.

![RocketSim_Recording_iPhone_13_Pro_2022-08-14_08 53 53](https://user-images.githubusercontent.com/98359662/184544983-fcdbba2e-2739-47bc-986c-ad8401b5dd95.gif)

* UIKit
* Programmatic UI
* MapKit
* API calls and JSON parsing (using generic networking)
* Data persistance using UserDefaults and Realm
* Fully dark mode compatible
* Onboarding flow


### Building the app

To run the app, you must do two things:
- Obtain an API key from Yelp. This can be done here: https://www.yelp.com/developers/
- Create a new file with the following code:

```swift
struct Constant {
    let apiKey = "<your key here>"
}
```

### TODOs:
* [ ] Implement UserDefaults for settings
* [ ] Refactor to MVVM architecture

#### Future concepts:
* Use FireBase to create user accounts
* Create 'share' function to share personalized lists with friends
