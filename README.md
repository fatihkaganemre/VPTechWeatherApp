# VPTechWeatherApp Overview

- The application has two main views. The entry view (AKA home view) displays a daily forecast of Paris.
When user taps any of daily forecasts, a detail view is shown. Detail view includes
more detailed forecast information such as hourly forecast, wind speed, pressure, humidity et cetera.

# Architectural choices

- RxSwift is used (As required) for async code (How RxSwift was utilised). 
Driver trait used for driving UI (reference: https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md)
    
- UIKit, Storyboards: I had a few options here. I could go with RxSwift + SwiftUI,
However i believe better to use Combine or/and async/await with SwiftUI. The other option was UIKit.
I could write the UI programatically. There are only 2 views, so i did not want to spend much time on that.
(Because I have got limited time)

- MVVM architecture
- Coordinator pattern for navigation
- Dependency container for dependency injection

# What is next

- Tests:
    - I have implemented unit tests for viewModels. I could write tests for services.
    I could implement UI or/and Snapshot tests and so on.
- Image Loading: 
    - I have implemented a very basic image caching and loading mechanism.
    It could be handled with an advanced caching which resolves race conditions and so on. 
    Or simply an existing framework could be used.
- Error handing: 
    - The app shows the localised error description in a basic alert view.
    Error message could be more user friendly by defining specific error types and handling
    more specific scenarios such as: no data, no internet ... etc 
- Dependency Injection
    - I have used dependency container for showing some kind of dependency injection. More advance dependency 
    injection methods could be used. In current implementation dependencies are initialised when app loaded and they are
    alive until the app killed. A better approach might be using dependencies when needed.

