# VPTechWeatherApp Overview


# Special instructions if any


# Architectural choices
- How RxSwift was utilised 
- RxSwift is used for async code
    - Driver trait used for driving UI (reference: https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md)
- MVVM architecture
- Coordinator pattern for navigation


# What is next
- check if should i call onCompleted after onError in Networking
- better image fetching
- clean up the code a bit and more reactive
    - use Rx for data binding and ui events
- iPad support
- Unit tests
- Better error handling
