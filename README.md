# VPTechWeatherApp Overview




# Architectural choices
- RxSwift is used for async code (How RxSwift was utilised)
    - Driver trait used for driving UI (reference: https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md)
- MVVM architecture
- Coordinator pattern for navigation

# What is next

- Update HomeViewModel in a better way
- Unit tests

- Image Loading: 
    - I have implemented a very basic image caching and loading mechanism.
    It could be handled with an advanced caching which resolve race conditions and so on. 
    Or simply an existing framework could be used.
- Error handing: 
    - The app shows the localised error description as a basic alert.
    - Error message could be more user friendly with defining specific error types such as:  no data, no internet ... etc 

