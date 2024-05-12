# VPTechWeatherApp Overview


# Special instructions if any


# Architectural choices
- RxSwift is used for async code (How RxSwift was utilised)
    - Driver trait used for driving UI (reference: https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md)
- MVVM architecture
- Coordinator pattern for navigation

# What is next

- Update HomeViewModel in a better way
- better image fetching with caching the URL !!! or consider using some framework
- Unit tests
- Better error handing: 
    - The app shows the localised error description as a basic alert.
    - Error message could be more user friendly with defining specific error types such as:  no data, no internet ... etc 

