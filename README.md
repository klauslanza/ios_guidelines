# iOS Guidelines
Guidelines, best practices and code style conventions.
Includes a project for bootstrapping a standardized new iOS project.

## Basics
### SOLID Principles
S — The Single Responsibility Principle (SRP): A class should have only one reason to change.  

O — The Open-Closed Principle (OCP): Software entities such as classes, functions, modules should be open for extension but not modification.  

L — The Liskov Substitution Principle (LSP): Child classes should never break the parent class’ type definitions.  

I — The Interface Segregation Principle (ISP): The interface-segregation principle (ISP) states that no client should be forced to depend on methods it does not use.  

D — The Dependency Inversion Principle (DIP): High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend upon details. Details should depend upon abstractions.  

## Structure
### Project structure
The folder `Application`  is for app delegate and all support files (.plist, bridging, etc).
Group related controllers in flows.
Keep a `Resource` folder: all media, font, image, storyboards, etc. Organize assets using folders inside asset catalogs.
When a group grows to contain more than five files consider adding sub-groups.

### File structure
1. Default header created by Xcode
2. Import statements (system frameworks, followed by third party, and then our own frameworks)
3. Delegate protocols that are associated only with the major type declaration of the file
4. The major type declaration of the file
5. Inner type declarations
6. Properties
	* Inherited
	* Protocol
	* IBOutlets
	* Open
	* Public
	* Internal
	* Private
7. Functions
	* Inherited
	* Protocol
	* Open
	* Public
	* Internal
	* Private
8. Extension Protocol Conformances

## Best practices
* Try to keep the warning count to 0. This includes also SwiftLint rules violations.
* Keep all hard coded strings in `CoreCostants.swift` (API paths, notification names, base prefixes, URLs, etc.)
* No storyboards.
* Focus on making your code as easy to understand as possible with clear variable names.
* Use comments when trying to explain edge cases where code may require complexity or unfamiliar patterns.
* Declare an extension that will only be used in a single file, in the same file that will use it, e.g. an Array extension constrained to a specific type of element used elsewhere in that file.
* Keep libraries count low.

## Code style
* Prefer using the `var aString = String.empty` than `var aString = ""`; in case, it's easier to find and replace them later.
* Prefer `typealias` for complex return types, closures, callbacks.
* A file should only contain one major type declaration. Other types are allowed in support of the main type that is represented by the file, which typically shares the name of the file.
* Enums should be encapsulated within their respective classes when it makes sense.
* Use default parameter values instead of creating convenience functions that pass common constant values to the original function.
* Do not make Bools optional. A tri-state Bool can be represented in a more structured way, such as an enum with three well-named cases.
* Avoid makingArrays optional. Only do this if it provides meaning beyond it just being empty.

- - - -

# Bootstrap project documentation

## Setup and maintenance
### Bundler
Install Bundler using `gem install bundler`

Use  `bundle install` to get required dependencies.

From now on you should use 
`bundle exec pod install` or `bundle exec pod update` for managing CocoaPods.


### CocoaPods
Use only strictly necessary pods. Try to limit the scope of the imported pods, preferring single use ones to kitchen sink mega libraries. Keep an annotation on pods used in specific frameworks, to track the usage.


### Localization
https://localise.biz/

#### Basic rules
specificAppKey_appSection_key (example: bootstrap_common_cancel)  
Always use camelCase  

#### Examples  
bootstrap_menu_findStore  
bootstrap_catalog_buttonSearch  
bootstrap_catalog_buttonCompare (use common word as prefix, to group them in generated list)  

#### Rules  
1) Always check in Loco before adding a new translation.  
2) Use placeholders (also Android postional ones). Always configure the correct platform for the formatting (check https://share.getcloudapp.com/lluzKy9J).  
3) Try not to use the same string in different parts of the app. Strings are not lego-like/interchangable (like when appending "the door" to "close"), but are strictly related to the corresponding section. This helps managing a different translation for a similar key in two part of the app.  

## Architecture
The project is divided in a main app and 4 embedded Cocoa Touch frameworks, to help mantain a separation of concerns and to speed up the compilation.

Main app - Bootstrap:
contains all controllers and the business logic. Place all resources (image, audio, video, etc.) here. 

Frameworks:

1. **BootstrapCore**: data read/write services and providers. Usually depend from Shared and Domain. Examples: data storage, networking, notifications, etc.
2. **BootstrapDomain**: entities, relations, extensions and model related files. This framework stores the domain model of the project. Usually does not depend from other frameworks. Examples: domain classes, payloads, protocols, responses, themes, domain validators, etc.
3. **BootstrapShared**: generic extensions, functions and utilities. Ideally this represent a generic framework, not specific to the domain, that can be moved to another project and used as is. Usually does not depend from other frameworks. Examples: operation management, delegation, logging, observation, validation, localization, errors management, etc. 
4. **BootstrapUIKit**: all UI related stuff. Contains the navigation & presentation, views, cells, layout/sizing logic, collections and tables, HUD & alerts, base controller classes, etc. Usually depend from Shared and Domain. 

### Environment
Stores settings for the different network environments (prod, stage, etc.): base API URL, URLs not related to API, headers, etc.

### Container
Manages dependency injection and helps maintain a clean and single access point to the environment and the services.
All services must be registered using the container functions.

### Core
The main functional component of the project. This is the single access point for the services - storing all the different ones - and keeps a reference to the container and the environment.

**Common services** should be accessed from other services are usually registered via type or key method.

Example:
KeychainService and UserDefaultsService are both a RegistryService, one registered via the base type and one via key.

**Generic services** should be accessed via a public property on the core itself.

Example:
TODO: add example.


# Bibliography
TODO
