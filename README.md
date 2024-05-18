# Hax
Hax is a **Hacker News client for iPhone**, planned for all Apple devices. It aims to provide a browsing experience that is both native and akin to the website's. The app is built from the ground up using SwiftUI, so it's got many features out of the box such as Dark Mode and Dynamic Type.

[Download on the App Store](https://apps.apple.com/us/app/hax-for-hacker-news/id1635164814)

## Screenshots
![Screenshots](/Assets/screenshots.png)

## Motivation
I've been reading Hacker News for a few years now. It's a great way to keep up with the latest news from the tech world and I always learn something new every time I go on there.

Back in 2018 I created what could be considered the predecessor to Hax, with the purpose of learning iOS development, though I never got around to publishing it on the App Store. Four years later it still works, barring a few bugs, though its codebase has become quite stale...

I've wanted to publish an app on the App Store for a long time, but not just any app. I wanted the scope of the app to be large enough so that:
- it can eventually become a **full-fledged app**, and
- it allows me to try out many of the **latest technologies from Apple** that launch every year.

Therefore, after not much consideration, I decided to remake my old Hacker News app on SwiftUI!

## Technologies

- SafariServices
- Swift Concurrency
- SwiftUI
- UIKit

## Architecture
I'll start off by saying the initial version of this app could be considered a MVP, since waiting until the app was perfect to release it didn't make sense. Instead, I wanted to launch a functional app and then build on it over the coming years. Consequently there are some things than can be improved upon but they'll be worked out eventually.

The app is written using the MVVM pattern with the main purpose of separating model code from view code. I don't feel content with the approach though, so once I get to writing tests for the entire app I'll see whether I need a whole new architecture or just refine the current one. Now's the best time to do it since there's not much code yet!

Currently the structure of the app is simple. There are three main views, `MenuView`, `FeedView` and `ItemView`, which form the main navigation stack. The data displayed on the last two is retrieved through the `HackerNewsService` class, which uses a local Swift package, `Networking`, that encapsulates the networking logic. Both fully take advantage of the Swift Concurrency APIs.

## Roadmap
Instead of outlining any upcoming features here, I'll create issues for any feature or fix that I plan on implementing. You can check out the latest issues [here](https://github.com/lui5fl/hax/issues). You're more than welcome to create an issue to propose a feature or report a bug.

I also invite you to take a look at the [Projects](https://github.com/lui5fl/hax/projects) tab, since I'll definitely use this feature for prioritizing issues.

## License
Released under GPL-3.0 license. See [LICENSE](/LICENSE) for details.
