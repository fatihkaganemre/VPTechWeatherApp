# VPTechWeatherApp Overview


# Special instructions if any


# Architectural choices
- How RxSwift was utilised 
- RxSwift is used for async code
    - Driver trait used for driving UI (reference: https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md)
- MVVM architecture
- Coordinator pattern for navigation


# What is next
- better image fetching with caching the URL !!! or consider using some framework
- clean up the code a bit and more reactive
    - use Rx for data binding and ui events
- iPad support
- Unit tests
- Better error handing: 
    - The app shows the localised error description as a basic alert.
    - Error message could be more user friendly with defining specific error types such as:  no data, no internet ... etc 

