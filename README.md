# iOS Guidelines
Guidelines, best practices and code style conventions.
Includes a project for bootstrapping a standardized new iOS project.


## Best practices

1. Try to keep the warning count to 0. This includes also SwiftLint rules violations.
2. Keep all hard coded strings in `CoreCostants.swift` (API paths, notification names, base prefixes, URLs, etc.)
3. No storyboards.
4. Keep libraries count low.


## Code style

1. Prefer using the `var aString = String.empty` than `var aString = ""`; in case, it's easier to find and replace them later.


# Bootstrap project documentation

## Setup and maintenance


### Bundler

Use  `bundle install` to get required dependencies.

From now on you should use 
`bundle exec pod install` or `bundle exec pod update` for managing CocoaPods.


### CocoaPods

Use only strictly necessary pods. Try to limit the scope of the imported pods, preferring single use ones to kitchen sink mega libraries. Keep an annotation on pods used in specific frameworks, to track the usage.



## Architecture

The project is divided in a main app and 4 embedded Cocoa Touch frameworks, to help mantain a separation of concerns and to speed up the compilation.

**Main app - Bootstrap**:
contains all controllers and the business logic. Place all resources (image, audio, video, etc.) here. 

**Frameworks**:

1. *BootstrapCore*: data read/write services and providers. Usually depend from Shared and Domain. Examples: data storage, networking, notifications, etc.)
2. *BootstrapDomain*: entities, relations, extensions and model related files. This framework stores the domain model of the project. Usually does not depend from other frameworks. Examples: domain classes, payloads, protocols, responses, themes, domain validators, etc.
3. *BootstrapShared*: generic extensions, functions and utilities. Ideally this represent a generic framework, not specific to the domain, that can be moved to another project and used as is. Usually does not depend from other frameworks. Examples: operation management, delegation, logging, observation, validation, localization, errors management, etc. 
4. *BootstrapUIKit*: all UI related stuff. Contains the navigation & presentation, views, cells, layout/sizing logic, collections and tables, HUD & alerts, base controller classes, etc. Usually depend from Shared and Domain. 


### Environment
Stores settings for the different network environments (prod, stage, etc.): base API URL, URLs not related to API, headers, etc.


### Container
Manages dependency injection and helps maintain a clean and single access point to the environment and the services.
All services must be registered using the container functions.


### Core
The main functional component of the project. This is the single access point for the services - storing all the different ones - and keeps a reference container and environment.

*Common services* should be accessed from other services are usually registered via type or key method.

Example:
KeychainService and UserDefaultsService are both a RegistryService, one registered via the base type and one via a key.

*Generic services* should be accessed via a public property on the core itself.

Example:
// TODO: add example when ready 
