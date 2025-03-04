### Summary
> Include screen shots or a video of your app highlighting its features

The low quality video is in the root of this repository: FetchRecipes.mp4

### Focus Areas
> What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

1. **Modularization and abstraction** in order to make things more testable and independently edited.
2. **Test-Driven Development** as I find it a powerful way to ensure that product requirements are satisfied by production code and to allow said code to be "refactored without mercy".
3. **Unfamiliar technology** such as `SwiftData` so that I could learn something new and experience the challenges faced by using it.

### Time Spent
> Approximately how long did you spend working on this project? How did you allocate your time?

I'd guess that everything including documentation and video editing took close to 20 hours. After an illness delayed my ability to focus on the project, I decided to both spend more time than I normally would and went further into areas that are important to me. 

### Trade-offs and Decisions
> Did you make any significant trade-offs in your approach?

Perhaps the only significant trade-offs were when sticking with some implementation choices:
* `URLCache` presents issues with failing to clear the cache, but it provides on-disk storage which kept me from having to write my own underlying cache. These issues cropped up during both testing and runtime usage. 
* `SwiftData` forced some interesting design choices since it is built to be better used directly from `SwiftUI` which added to the concurrency challenges one encounters when using that UI framework. Testing also suffered some flakiness likely due to either the immaturity of the framework or the contortions I put myself through to fully test the recipe provider.

### Weakest Part of the Project
> What do you think is the weakest part of your project?

Unfortunately, I don't feel like I nailed all of the concurrency challenges even though I turned on and satisfied the strict concurrency checking option. I intend to exercise that muscle more in personal testing and real-world development.

### Additional Information
> Is there anything else we should know? Feel free to share any insights or constraints you encountered.

* I used a "main" object at the top level of the app to bundle all dependencies into a single location that is easily used to inject them into the view hierarchy.
* I intentionally differentiated between remote models and domain models in order to pin wire formats to the server API and allow for richer, more appropriate models to be used in the app. This helps push validation of data to the appropriate places which properly separates concerns of data handling.
* The way that I like to do TDD is by stating assertions about the system and then using those assertions in the tests. This ensures that test failures carry more context and map more appropriately to system requirements.
* I included a couple of examples (networking and caching) of wrapping even Apple's frameworks so that custom interfaces can be built to wrap those frameworks. This approach is frequently recommended only for third party APIs, but I find that it allows for preferable APIs and helps testing by the ability to create test doubles without torturous subclassing or other unsavory tactics.
* Sleeping threads in asynchronous tests is not something I would want to normally do. In a few instances, however, I felt that it proved an adequate tool in a pinch.
* In order to use the latest versions of the various frameworks, I limited support for the app to the most recent version of iOS (18.2). This was probably unnecessary for the most part, but I wanted to focus on using the frameworks instead of trying to account for differences in versions of them across operating system versions.
* I made little use of SwiftUI previews as the app UI is so small in implementation size. Normally I would make heavier use of them as they are one of the most valuable features of the framework.
