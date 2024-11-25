# Hax
Hax is a **Hacker News client for iPhone, iPad and Apple Watch**, that aims to provide a native browsing experience that improves upon the website while keeping a similar minimalistic appearance. The app is built from the ground up using SwiftUI and adopts many iOS features including widgets, controls, Safari extensions, and more.

[View on the App Store](https://apps.apple.com/us/app/hax-for-hacker-news/id1635164814)

## Motivation
I've been reading Hacker News for a few years now. It's a great way to keep up with the latest news from the tech world and I always learn something new every time I go on there.

Back in 2018 I created what could be considered the predecessor to Hax, with the purpose of learning iOS development, though I never got around to publishing it on the App Store. Four years later it still works, barring a few bugs, though its codebase has become quite stale...

I've wanted to publish an app on the App Store for a long time, but not just any app. I wanted the scope of the app to be large enough so that:
- it can eventually become a **full-fledged app**, and
- it allows me to try out many of the **latest technologies from Apple** that launch every year.

Therefore, after not much consideration, I decided to remake my old Hacker News app on SwiftUI!

## Technologies

- AppIntents
- Swift Concurrency
- Swift Testing
- SwiftData
- SwiftUI
- UIKit
- WatchConnectivity
- WidgetKit

## Architecture
The app follows the MVVM pattern, ensuring a clear separation of model and view code, which simplifies writing unit tests for the model code. All REST API requests are handled by the `HackerNewsService` class, which uses a local Swift package, `Networking`, that encapsulates the networking logic. Both fully take advantage of the Swift Concurrency APIs.

## Roadmap
Instead of outlining any upcoming features here, I'll create issues for any feature or fix that I plan on implementing. You can check out the latest issues [here](https://github.com/lui5fl/hax/issues). You're more than welcome to create an issue to propose a feature or report a bug.

I also invite you to take a look at the [Projects](https://github.com/lui5fl/hax/projects) tab, since I'll definitely use this feature for prioritizing issues.

## License
Released under GPL-3.0 license. See [LICENSE](/LICENSE) for details.
