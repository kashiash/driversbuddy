# Concurrent Programming in SwiftData

from https://fatbobman.com/en/posts/concurret-programming-in-swiftdata/

Concurrent programming in Core Data may not be difficult, but it is full of traps. Even with ample experience in Core Data, a slight negligence can introduce vulnerabilities into the code, making the application unsafe. As the successor to Core Data, SwiftData provides a more elegant and secure mechanism for concurrent programming. This article will introduce how SwiftData addresses these issues and offers developers a better experience with concurrent programming.

> The content of this article will make use of concurrency features like async/await, Task, and Actor in Swift. Readers are expected to have some experience with Swift concurrency programming.

## Using Serial Queues to Avoid Data Race

We often say that managed object instances (NSManagedObject) and managed object contexts (NSManagedObjectContext) in Core Data are not thread-safe. So why do unsafe problems occur? How does Core Data solve this problem?

Actually, the main point of insecurity lies in data race (simultaneous modification of the same data in a multi-threaded environment). Core Data avoids data race issues by operating on managed object instances and managed object context instances in a serial queue. This is why we need to place the operation code within the closures of `perform` or `performAndWait`.

For the view context and the managed object instances registered within it, developers should perform operations on the main thread queue. Similarly, for private contexts and the managed objects registered within them, we should perform operations on the serial queue created by the private context. The `perform` method will ensure that all operations are performed on the correct queue.

> Read the article [Several Tips on Core Data Concurrency Programming](https://fatbobman.com/en/posts/concurrencyofcoredata/) to learn in detail about different types of managed object contexts, serial queues, the usage of `perform`, and other considerations for concurrency programming in Core Data.

In theory, as long as we strictly adhere to the aforementioned requirements, we can avoid most concurrency issues in Core Data. Therefore, developers often write code similar to the following:

```swift
func updateItem(_ item: Item, timestamp: Date?) async throws {
    guard let context = item.managedObjectContext else { throw MyError.noContext }
    try await context.perform {
        item.timestamp = timestamp
        try context.save()
    }
}
```

When there are a lot of `perform` methods in the code, it reduces the code’s readability. This is also a problem that many developers complain about.

## How to create a ModelContext using a private queue?

In Core Data, developers can use a very explicit way to create different types of managed object contexts:

```swift
// view context - main queue concurrency type
let viewContext = container.viewContext
let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

// private context - private queue concurrency type
let privateContext = container.newBackgroundContext()

let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
```

Even in a private context, operations can be performed directly without the need for explicit creation.

```swift
container.performBackgroundTask{ context in
    ...
}
```

However, SwiftData has made adjustments to the creation logic of ModelContext (a wrapped version of NSManagedObjectContext). The type of the newly created context depends on the queue it is in. In other words, a ModelContext created on the main thread will automatically use the main thread queue (com.apple.main-thread), while a ModelContext created on other threads (non-main threads) will use a private queue.

```swift
Task.detached {
    let privateContext = ModelContext(container)
}
```

Please note that when creating a new task through `Task.init`, it inherits the execution context of its parent task or actor. This means that the following code will not create a ModelContext that uses a private queue:

```swift
// In SwiftUI View
Button("Create New Context"){
    let container = modelContext.container
    Task{
        // Using main queue, not background context
        let privateContext = ModelContext(container)
    }
}

SomeView()
    .task {
        // Using main queue, not background context
        let privateContext = ModelContext(modelContext.container)
    }
```

This is because in SwiftUI, the body of a view is annotated with `@MainActor`, so it is recommended to use `Task.detached` to ensure that the ModelContext is created and used on a non-main thread with a private queue.

> In the main thread, the ModelContext created is an independent instance, different from the context instance provided by the mainContext property of the ModelContainer instance. Although they both operate on the main queue, they manage separate sets of registered objects.

## Actor: More elegant implementation of serial queue

From version 5.5 onwards, Swift introduced the concept of Actors. Similar to serial queues, they can be used to solve data race issues and ensure data consistency. Compared to running through the `perform` method on a specific serial queue, Actors provide a more advanced and elegant implementation approach.

> Each Actor has an associated serial queue for executing its methods and tasks. This queue is based on GCD, and GCD is responsible for underlying thread management and task scheduling. This ensures that the methods and tasks of the Actor are executed in a serial manner, meaning that only one task can be executed at a time. This guarantees that the internal state and data of the Actor are thread-safe at all times, avoiding issues with concurrent access.

Although in theory it is possible to use Actors to restrict code to the context and operations of managed objects, this approach was not adopted in previous versions of Swift due to the lack of custom Actor executors. Fortunately, Swift 5.9 addresses this shortcoming and allows SwiftData to provide a more elegant concurrent programming experience through Actors.

> [Custom Actor Executors](https://github.com/apple/swift-evolution/blob/main/proposals/0392-custom-actor-executors.md#custom-actor-executors): This proposal introduces a basic mechanism for customizing Swift Actor executors. By providing instances of executors, Actors can influence the execution location of their tasks while maintaining the mutual exclusivity and isolation guaranteed by the Actor model.

Thanks to the new feature “macros” in Swift, it is very easy to create an Actor in SwiftData that corresponds to a specific serial queue:

```swift
@ModelActor
actor DataHandler {}
```

By adding more data manipulation logic code to the Actor, developers can safely use the instance of the Actor to manipulate data.

```swift
extension DataHandler {
    func updateItem(_ item: Item, timestamp: Date) throws {
        item.timestamp = timestamp
        try modelContext.save()
    }

    func newItem(timestamp: Date) throws -> Item {
        let item = Item(timestamp: timestamp)
        modelContext.insert(item)
        try modelContext.save()
        return item
    }
}
```

You can use the following method to invoke the code mentioned above:

```swift
let handler = DataHandler(modelContainer: container)
let item = try await handler.newItem(timestamp: .now)
```

Afterwards, no matter which thread calls the methods of `DataHandler`, these operations will be performed in a specific serial queue. Developers no longer have to struggle with writing a lot of code containing `perform`.

Do you remember the considerations we discussed in the previous section about creating a ModelContext? The same rules apply when creating an instance using the ModelActor macro. The type of serial queue used by the newly created Actor instance depends on the thread that creates it.

```swift
Task.detached {
    // Using private queue
    let handler = DataHandler(modelContainer: container)
    let item = try await handler.newItem(timestamp: .now)
}
```

## The Secret of the ModelActor Macro

ModelActor, what magic does it possess? And how does SwiftData ensure that the execution sequence of the Actor remains consistent with the serial queue used by ModelContext?

By expanding the ModelActor macro in Xcode, we can see the generated complete code:

```swift
actor DataHandler {
    nonisolated let modelExecutor: any SwiftData.ModelExecutor
    nonisolated let modelContainer: SwiftData.ModelContainer
    init(modelContainer: SwiftData.ModelContainer) {
        let modelContext = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }
}

extension DataHandler: SwiftData.ModelActor {}
```

ModelActor Protocol Definition:

```swift
// The code below is not generated by ModelActor
public protocol ModelActor : Actor {

    /// The ModelContainer for the ModelActor
    /// The container that manages the app’s schema and model storage configuration
    nonisolated var modelContainer: ModelContainer { get }

    /// The executor that coordinates access to the model actor.
    ///
    /// - Important: Don't use the executor to access the model context. Instead, use the
    /// ``context`` property.
    nonisolated var modelExecutor: ModelExecutor { get }

    /// The optimized, unonwned reference to the model actor's executor.
    nonisolated public var unownedExecutor: UnownedSerialExecutor { get }

    /// The context that serializes any code running on the model actor.
    public var modelContext: ModelContext { get }

    /// Returns the model for the specified identifier, downcast to the appropriate class.
    public subscript<T>(id: PersistentIdentifier, as as: T.Type) -> T? where T : PersistentModel { get }
}
```

Through the code, it can be seen that there are mainly two operations performed during the construction process:

- Create a ModelContext instance using the provided ModelContainer.

The thread on which the constructor runs determines the serial queue used by the created ModelContext, which in turn affects the execution queue of the Actor.

- Based on the newly created ModelContext, create a DefaultSerialModelExecutor (custom Actor executor).

DefaultSerialModelExecutor is an Actor executor declared by SwiftData. Its main responsibility is to use the serial queue used by the incoming ModelContext instance as the execution queue for the current Actor instance.

In order to determine if the DefaultSerialModelExecutor functions as expected, we can verify it using the following code:

```swift
import SwiftDataKit

actor DataHandler {
    nonisolated let modelExecutor: any SwiftData.ModelExecutor
    nonisolated let modelContainer: SwiftData.ModelContainer
    init(modelContainer: SwiftData.ModelContainer) {
        let modelContext = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }

    func checkQueueInfo() {
        // Get Actor run queue label
        let actorQueueLabel = DispatchQueue.currentLabel
        print("Actor queue:",actorQueueLabel)
        modelContext.managedObjectContext?.perform {
            // Get context queue label
            let contextQueueLabel = DispatchQueue.currentLabel
            print("Context queue:",contextQueueLabel)
        }
    }
}

extension DataHandler: SwiftData.ModelActor {}

// get current dispatch queue label
extension DispatchQueue {
    static var currentLabel: String {
        return String(validatingUTF8: __dispatch_queue_get_label(nil)) ?? "unknown"
    }
}
```

In the `checkQueueInfo` method, we respectively retrieve and print the execution sequence of the current actor and the name of the queue corresponding to the managed object context.

```swift
Task.detached {
    // create handler in non-main thread
    let handler = DataHandler(modelContainer: container)
    await handler.checkQueueInfo()
}

// Output
Actor queue: NSManagedObjectContext 0x600003903b50
Context queue: NSManagedObjectContext 0x600003903b50
```

When creating a DataHandler instance on a non-main thread, the managed object context will create a private serial queue named `NSManagedObjectContext + address`, and the execution queue of the actor will be the same as it.

```swift
Task { @MainActor in
    // create handler in main thread
    let handler = DataHandler(modelContainer: container)
    await handler.checkQueueInfo()
}

// Output
Actor queue: com.apple.main-thread
Context queue: com.apple.main-thread
```

When creating a DataHandler instance on the main thread, both the managed object context and the actor are on the main thread queue.

Based on the output, it can be seen that the execution queue of the Actor is exactly the same as the queue used by the context, confirming our previous speculation.

SwiftData ensures that operations are executed on the correct queue by using Actors, which can also provide inspiration for Core Data developers. Consider implementing similar functionality in Core Data by using a custom Actor executor.

## Accessing Data through PersistentIdentifier

In Core Data’s concurrent programming, in addition to performing operations on the correct queue, another important principle is to avoid passing NSManagedObject instances between contexts. This rule also applies to SwiftData.

If you want to operate on the storage data corresponding to a PersistentModel in another ModelContext, you can solve it by passing the PersistentIdentifier of the object. PersistentIdentifier can be seen as the SwiftData implementation of NSManagedObjectId.

The following code will attempt to retrieve and modify the corresponding data by passing in a PersistentIdentifier:

```swift
extension DataHandler {
    func updateItem(identifier: PersistentIdentifier, timestamp: Date) throws {
        guard let item = self[identifier, as: Item.self] else {
            throw MyError.objectNotExist
        }
        item.timestamp = timestamp
        try modelContext.save()
    }
}

let handler = DataHandler(container:container)
try await handler.updateItem(identifier: item.id, timestamp: .now )
```

In the code, we use a subscript method provided by the ModelActor protocol. This method first tries to find the corresponding PersistentModel from the ModelContext held by the current actor. If it doesn’t exist, it will attempt to retrieve it from the row cache and persistent storage. You can think of it as the equivalent version of Core Data’s `existingObject(with:)` method. Interestingly, this method that directly accesses the persistent storage is only implemented in the ModelActor protocol. From this perspective, the development team of SwiftData is also consciously guiding developers to use this kind of data operation logic (ModelActor).

Additionally, ModelContext also provides two methods to retrieve PersistentModel through PersistentIdentifier. `registeredModel(for:)` corresponds to the `registeredObject(for:)` method in NSManagedObjectContext, while `model(for:)` corresponds to the `object(with:)` method in NSManagedObjectContext.

```swift
func updateItemInContext(identifier: PersistentIdentifier, timestamp: Date) throws {
    guard let item = modelContext.registeredModel(for: identifier) as Item? else {
        throw MyError.objectNotInContext
    }
    item.timestamp = timestamp
    try modelContext.save()
}

func updateItemInContextAndRowCache(identifier: PersistentIdentifier,timestamp: Date) throws {
    if let item = modelContext.model(for: identifier) as? Item {
        item.timestamp = timestamp
        try modelContext.save()
    }
}
```

The differences between these three methods are as follows:

- `existingObject(with:)`

If the specified object is detected in the context, this method will return that object. Otherwise, the context will retrieve and return a fully instantiated object from persistent storage. Unlike the `object(with:)` method, this method will never return an object in a fault state. If the object is neither in the context nor in persistent storage, this method will throw an error. In simple terms, unless the data does not exist on persistent storage, it will always return an object in a non-fault state.

- `registeredModel(for:)`

This method can only return objects that are already registered in the current context (with the same identifier). If the object is not found, it returns nil. When the return value is nil, it does not necessarily mean that the object does not exist in persistent storage, but rather that it is not registered in the current context.

- `model(for:)`

Even if the object is not registered in the current context, this method will still return an empty fault state object - a placeholder object. When the user actually accesses this placeholder object, the context will try to retrieve data from persistent storage. If the data does not exist, it may cause the application to crash.

## The Second Line of Defense

Not every developer will strictly follow the expected way of concurrent programming in SwiftData (ModelActor). As the code becomes more complex, there may be accidental access or modification of PersistentModel properties on other queues. Based on the experience with Core Data, such access will inevitably lead to application crashes when the debugging parameter `com.apple.CoreData.ConcurrencyDebug 1` is enabled.

But in SwiftData, despite receiving some warning messages (`Capture non-sendable`), the above operations do not cause any issues and allow normal data access and modification. Why is that?

The following code will modify the properties of an Item object on the main thread from a non-main thread. After clicking the button, the property modification will be successful.

```swift
Button("Modify in Wrong Thread") {
    let item = items.first!
    DispatchQueue.global().async {
        print(Thread.current)
        item.timestamp = .now
    }
}
```

If you have read the previous article [Unveiling the Data Modeling Principles of SwiftData](https://fatbobman.com/en/posts/unveiling-the-data-modeling-principles-of-swiftdata/), you may remember that it mentioned SwiftData provides Get and Set methods for PersistentModel and BackingData, which not only read and set properties but also have the ability to schedule tasks in a queue (ensuring thread safety). In other words, even if we modify properties on the wrong thread (queue), these methods will automatically switch the operation to the correct queue. Through further experimentation, we discovered that this scheduling ability exists at least at the implementation level of the BackingData protocol.

```swift
Button("Modify in Wrong Thread") {
    let item = items.first!
    DispatchQueue.global().async {
        item.persistentBackingData.setValue(forKey: \.timestamp, to: Date.now)
    }
}
```

This section does not encourage bypassing ModelActor for data operations, but through these details, we can see that the SwiftData team has made a lot of effort to avoid thread safety issues.

## Summary

Perhaps some people, like me, upon learning about the new concurrency programming approach in SwiftData, would first feel delighted, followed by an indescribable sensation. After some time of reflection, I seem to have found the reason for this peculiar feeling - code style. Obviously, the data processing logic commonly used in Core Data does not fully apply to SwiftData. So, how can we write code that has a more SwiftData flavor? How can we make the data processing code better align with SwiftUI? These are the topics we will study in the future.

# Practical SwiftData: Building SwiftUI Applications with Modern Approaches

https://fatbobman.com/en/posts/practical-swiftdata-building-swiftui-applications-with-modern-approaches/

In the previous article [Concurrent Programming in SwiftData](https://fatbobman.com/en/posts/concurret-programming-in-swiftdata/), we delved into the innovative concurrent programming model proposed by SwiftData, including its principles, core operations, and related considerations. This elegant programming solution has earned considerable praise. However, as more developers attempt to use SwiftData in actual SwiftUI applications, they have encountered some challenges, especially after enabling Swift’s strict concurrency checks. They found that SwiftData’s actor-based concurrency model is difficult to integrate with traditional application construction methods. This article will explain, in a tutorial-like manner, how to integrate SwiftData with modern programming concepts smoothly into SwiftUI applications and provide strategies to address the current challenges faced by developers.



## What Are Modern Approaches?

When discussing modern programming approaches, different developers might have various perspectives, but there are some core principles that are widely agreed upon. In the context of building SwiftUI applications with SwiftData, I believe modern programming approaches should at least meet the following key standards:

- **Modularity**: By encapsulating data definitions and operational logic within independent modules, we can not only enhance code readability and maintainability but also promote feature reusability. Modularity is the cornerstone of ensuring a project structure is clear and flexible enough to adapt to future changes.
- **Comprehensive Testability**: Ensuring every data operation is thoroughly unit tested is crucial. This practice guarantees the reliability and stability of the code, making the continuous integration and deployment process smoother.
- **Thread Safety**: Maintaining the integrity and consistency of data in concurrent programming is extremely important. Effective thread safety measures not only prevent data conflicts and race conditions but also comply with Swift’s strict concurrency standards, ensuring the application’s high performance and stable operation.
- **Architecture Agnostic**: A powerful data management module should flexibly adapt to various architectural designs, whether it’s SwiftUI’s own data injection mechanism or integration with other third-party frameworks, it should seamlessly connect, demonstrating a high degree of adaptability.
- **Preview Support**: The preview feature in SwiftUI is a significant highlight of its development experience, allowing developers to see interface changes instantly. Therefore, ensuring the data layer supports this functionality is vital for speeding up the development process and enhancing efficiency.
- **Separation of Data Display and Operations**: While adhering to SwiftUI’s reactive design principles, it’s effective to separate the data display and operational logic. Data is intuitively displayed and responds to changes through `@Query`, while creation, update, deletion, and other operations are handled by SwiftData’s new concurrency model, thus enhancing efficiency and fully leveraging the advantages of SwiftUI’s reactive framework.

To better understand the concepts discussed in this article and to see the application of these modern programming methods in practice, I have prepared a demo project. You can obtain the complete project code by visiting the following GitHub repository:

This project includes examples implemented using SwiftData in a SwiftUI application, demonstrating how to build applications according to the modern programming standards introduced in the article.

## Creating a Data Management Module

For a long time, the practice of extracting data management logic from the main project and encapsulating it into an independent module has been highly acclaimed. Many developers have adopted this approach in projects using Core Data. However, compared to SwiftData, Core Data presents additional challenges in terms of modularity. This is mainly because Core Data uses a graphical model editor to build data models, and the data models themselves are stored as separate files, loaded at different stages of the application’s lifecycle with various file extensions. This dependency on external model files has significantly diminished developers’ inclination to modularize their data management code.

SwiftData, with its pure code declaration approach, greatly simplifies this process, leaving virtually no excuse not to isolate the data management logic. This method not only simplifies code maintenance but also enhances the portability and reusability of the code.

Considering that the data management module is usually highly related to a specific project, I chose to create a new Swift Package in the current directory of the demo project, rather than setting up a separate repository for it.

I started by creating a package named `DataProvider`. In its `Package.swift` file, we enabled Swift’s strict concurrency checks to ensure the safety of concurrent code:

```swift
.target(
  name: "DataProvider",
  swiftSettings: [
    .enableExperimentalFeature("StrictConcurrency"),
  ]
),
```

In this independent module, we will complete the definition of the data model, the implementation of the data operation logic, and the related testing work. This structure not only clearly delineates the different concerns of the application but also makes maintenance and testing more efficient.

## Building the Data Model

In `SwiftData`, the method of building a data model is very similar to defining Swift’s basic types, requiring only pure code to complete. In our demo project, we have defined a succinct model `Item`:

```swift
@Model
public final class Item {
  public var timestamp: Date
  public var createTimestamp: Date

  public init(timestamp: Date) {
    self.timestamp = timestamp
    createTimestamp = .now
  }
}
```

It’s important to note that adopting SwiftData’s pure code modeling approach means that once the application is deployed, any modifications to the data model or data migrations require manual management of all versions of the data model. Therefore, even though our model currently has only one version, it’s best to plan a strategy for data migration right from the start.

To this end, we first define an enumeration to represent the version of the model, and use the `CurrentScheme` type alias to mark it as the version currently in use:

```swift
public typealias CurrentScheme = SchemaV1

public enum SchemaV1: VersionedSchema {
  public static var versionIdentifier: Schema.Version {
    .init(1, 0, 0)
  }

  public static var models: [any PersistentModel.Type] {
    [Item.self]
  }
}
```

Next, we embed the declaration of the `Item` class into `SchemaV1`, and maintain consistency in the naming through a type alias:

```swift
public typealias Item = SchemaV1.Item

extension SchemaV1 {
  @Model
  public final class Item {
    public var timestamp: Date
    public var createTimestamp: Date

    public init(timestamp: Date) {
      self.timestamp = timestamp
      createTimestamp = .now
    }
  }
}
```

In our demo project, to simplify the learning process, we haven’t further extended the data model. However, in real-world applications, developers can enhance the data model by adding predefined predicates, sorting rules, or FetchDescriptors through extensions, as detailed in [this example code](https://gist.github.com/fatbobman/6dc873ae18bb28cd1ccc521b3f56cefb).

Now, whether inside the module or externally, we can use `Item` to reference this version of the data model. If the model changes in the future, we can easily introduce a new Schema version, such as `SchemaV2`, and adjust the type aliases accordingly to accommodate the new model structure.

> To delve deeper into the principles of building SwiftData data models, refer to [Unveiling the Data Modeling Principles of SwiftData](https://fatbobman.com/en/posts/unveiling-the-data-modeling-principles-of-swiftdata/). Additionally, if you are interested in SwiftData’s data model migration methods, you can read [this article](https://fatbobman.com/en/posts/what-s-new-in-core-data-in-wwdc23/#staged-migration), which discusses migration strategies and implementation steps.

## SwiftData Also Requires a Stack

In Core Data projects, developers are accustomed to constructing a structure akin to a stack that centrally manages the declaration of the persistent container and data operation logic. SwiftData significantly simplifies this process, allowing developers to quickly build containers and perform data injections using straightforward calls like `.modelContainer(for: Item.self)`. So, in scenarios using SwiftData, is it still necessary to maintain a structure similar to a stack?

Even though we will be using the `@ModelActor` macro to encapsulate the data operation logic, building a structure similar to a stack remains crucial. Such a structure not only uniformly provides a container and `@ModelActor` implementation for different parts of the application but is also particularly key in projects attempting to combine SwiftData with Core Data in a dual-framework mode, as it can handle the container construction for both frameworks in one place.

In our demo project, we defined a `DataProvider` class. This class functions similarly to the `CoreDataStack` commonly used in Core Data projects:

```swift
public final class DataProvider: Sendable {
  public static let shared = DataProvider()

  public let sharedModelContainer: ModelContainer = {
    let schema = Schema(CurrentScheme.models)
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  public init() {}
}
```

Here, the construction of the schema directly utilizes the type information provided by `CurrentScheme.models`. Moreover, if the data model requires migration, the corresponding migration logic will also be implemented within the initialization closure of `sharedModelContainer`.

> Please read [Mastering the Core Data Stack](https://fatbobman.com/en/posts/masteringofcoredatastack/) to learn more about building techniques for the Core Data Stack.

## Encapsulating Data Operation Logic with @ModelActor

SwiftData offers the `@ModelActor` macro, encouraging developers to utilize this feature to create an actor type, thereby encapsulating the data operation logic within it. For our `Item` type, we have defined the logic for creating, updating, and deleting data items:

```swift
@ModelActor
public actor DataHandler {
  @discardableResult
  public func newItem(date: Date) throws -> PersistentIdentifier {
    let item = Item(timestamp: date)
    modelContext.insert(item)
    try modelContext.save()
    return item.persistentModelID
  }

  public func updateItem(id: PersistentIdentifier, timestamp: Date) throws {
    guard let item = self[id, as: Item.self] else { return }
    item.timestamp = timestamp
    try modelContext.save()
  }

  public func deleteItem(id: PersistentIdentifier) throws {
    guard let item = self[id, as: Item.self] else { return }
    modelContext.delete(item)
    try modelContext.save()
  }
}
```

In implementing these functionalities, several points need special attention:

- The update and delete operations only accept `PersistentIdentifier` as a parameter.
- After creating a new Item instance, the method returns the `PersistentIdentifier` of the newly created object. Although this return value might not be commonly used in many practical application scenarios, it is extremely useful during unit testing, providing an effective way to reference and test the newly created data entities.

> For a deeper understanding of the usage of `@ModelActor` and its role in SwiftData, please refer to the article [Concurrent Programming in SwiftData](https://fatbobman.com/en/posts/concurret-programming-in-swiftdata/).

## Writing Tests

Although the logic of Test-Driven Development (TDD) usually recommends writing tests before implementing functionalities, in our demo project, we will construct the test units after completing the data operation logic.

First, we set up a helper function dedicated to testing, ensuring that each test case can use a clean database environment:

```swift
enum ContainerForTest {
  static func temp(_ name: String, delete: Bool = true) throws -> ModelContainer {
    let url = URL.temporaryDirectory.appending(component: name)
    if delete, FileManager.default.fileExists(atPath: url.path) {
      try FileManager.default.removeItem(at: url)
    }
    let schema = Schema(CurrentScheme.models)
    let configuration = ModelConfiguration(url: url)
    let container = try! ModelContainer(for: schema, configurations: configuration)
    return container
  }
}
```

This helper function creates a separate database for each test case, with the database name based on the name of the test function. By default, it deletes the old data file before each test.

Here is a test case designed to verify the functionality of creating a new `Item` instance:

```swift
final class DataProviderTests: XCTestCase {
  @MainActor
  func testNewItem() async throws {
    // Arrange
    let container = try ContainerForTest.temp(#function)
    let hander = DataHandler(modelContainer: container)

    // ACT
    let date = Date(timeIntervalSince1970: 0)
    try await hander.newItem(date: date)

    // Assert
    let fetchDescriptor = FetchDescriptor<Item>()
    let items = try container.mainContext.fetch(fetchDescriptor)

    XCTAssertNotNil(items.first, "The item should be created and fetched successfully.")
    XCTAssertEqual(items.count, 1, "There should be exactly one item in the store.")

    if let firstItem = items.first {
      XCTAssertEqual(firstItem.timestamp, date, "The item's timestamp should match the initially provided date.")
    } else {
      XCTFail("Expected to find an item but none was found.")
    }
  }
}
```

Test Process Overview:

- Initialize a new, clean database instance.
- Use `DataHandler` to add a new data item.
- Retrieve `Item` data from the database through the container’s `mainContext`.
- Assert whether the retrieved data meets the expectations.

Special Considerations:

- The test case is marked with `@MainActor` to allow direct use of the container’s `mainContext`.
- Creation and retrieval of data are conducted in different contexts to ensure the accuracy of the logic and to simulate real application scenarios.
- When testing deletion functionality, the returned `PersistentIdentifier` of the newly created data item can be used to simplify the process and avoid repeated data retrieval from the database.
- The returned `PersistentIdentifier` should be used in the same context, especially when it is still in a temporary state. For operations across contexts, it may be necessary to retrieve the data again to obtain a persistent identifier.

Concerns About Testing Efficiency: Based on practical experience, even the method of testing with new database files can complete a large number of tests in a short time, so developers should not worry about its impact on testing performance.

<video src="https://cdn.fatbobman.com/unitTests-demo_2024-03-01.mp4" autoplay="" loop="" muted="true" style="box-sizing: border-box; border-width: 0px; border-style: solid; border-color: rgb(229, 231, 235); --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-pan-x: ; --tw-pan-y: ; --tw-pinch-zoom: ; --tw-scroll-snap-strictness: proximity; --tw-gradient-from-position: ; --tw-gradient-via-position: ; --tw-gradient-to-position: ; --tw-ordinal: ; --tw-slashed-zero: ; --tw-numeric-figure: ; --tw-numeric-spacing: ; --tw-numeric-fraction: ; --tw-ring-inset: ; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgb(63 131 248 / 0.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; --tw-blur: ; --tw-brightness: ; --tw-contrast: ; --tw-grayscale: ; --tw-hue-rotate: ; --tw-invert: ; --tw-saturate: ; --tw-sepia: ; --tw-drop-shadow: ; --tw-backdrop-blur: ; --tw-backdrop-brightness: ; --tw-backdrop-contrast: ; --tw-backdrop-grayscale: ; --tw-backdrop-hue-rotate: ; --tw-backdrop-invert: ; --tw-backdrop-opacity: ; --tw-backdrop-saturate: ; --tw-backdrop-sepia: ; display: block; vertical-align: middle; max-width: 100%; height: auto; margin-top: 2em; margin-bottom: 2em; caret-color: rgb(148, 163, 184); color: rgb(148, 163, 184); font-family: &quot;Inter Variable&quot;, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, &quot;Noto Sans&quot;, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;, &quot;Noto Color Emoji&quot;; font-size: 16px; font-style: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: -0.4px; orphans: auto; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: none;"></video>

## Preparing for Injection

After completing comprehensive testing of data operations in the demo project, the next step is to consider how to make `DataHandler` easily accessible or injectable into other parts of the project in a safe manner that aligns with modern programming paradigms.

To this end, we have defined the following method in the `DataProvider` class:

```swift
public func dataHandlerCreator() -> @Sendable () async -> DataHandler {
  let container = sharedModelContainer
  return { DataHandler(modelContainer: container) }
}
```

This helper function provides a safe method to create `DataHandler` instances, which is particularly crucial when Swift’s strict concurrency checks are enabled.

In the demo project, we demonstrated how to inject the `DataHandler` creation function into the view environment. This approach is not limited to injection through environment values but is also applicable to various architectural designs. For instance, when using The Composable Architecture (TCA), a similar strategy can be employed to define `DependencyKey` for the purpose of dependency injection. Moreover, given that `DataProvider` itself conforms to the `Sendable` protocol, it can also be used directly as a source for dependency injection in certain scenarios. This flexibility allows developers to choose the most appropriate injection and dependency management strategy based on the specific requirements of their application architecture.

By extending SwiftUI’s `EnvironmentValues`, we can seamlessly integrate the `DataHandler` creation logic into the SwiftUI environment, thereby providing a robust data operation capability to the view layer:

```swift
public struct DataHandlerKey: EnvironmentKey {
  public static let defaultValue: @Sendable () async -> DataHandler? = { nil }
}

extension EnvironmentValues {
  public var createDataHandler: @Sendable () async -> DataHandler? {
    get { self[DataHandlerKey.self] }
    set { self[DataHandlerKey.self] = newValue }
  }
}
```

With this, we have completed all the preparatory work for the data management module, and now it can be integrated into the project and put to use.

## Always Use One Instance or Create a New Instance Every Time

When developing with SwiftData, I recommend avoiding the retention of a long-term shared `DataHandler` instance within `DataProvider`. Instead, it might be a better choice to create a new instance independently in each business logic scenario. This approach has several advantages:

Firstly, considering the excellent performance of modern devices, the overhead of dynamically creating a new `DataHandler` instance is generally acceptable and does not negatively impact the application’s response speed or efficiency.

Secondly, due to the absence of configurations such as error handling and merge strategies in SwiftData, creating a new independent instance for each data operation can simplify the complexity of exception handling. In this way, each instance is self-contained, and operations do not interfere with each other, thereby reducing the risk of errors and making the code clearer and easier to maintain.

## Integrating the Data Module into the Project

After introducing the package into the project, we can start utilizing it within the application, providing the `container` and methods to generate `DataHandler`.

```swift
import DataProvider
import SwiftData
import SwiftUI

@main
struct SwiftDataConcurrencyDemoApp: App {
  let dataProvider = DataProvider.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.createDataHandler, dataProvider.dataHandlerCreator())
    }
    .modelContainer(dataProvider.sharedModelContainer)
  }
}
```

This code segment integrates the instance of `DataProvider` into the main entry of the SwiftUI application. We inject the `createDataHandler` method using the `.environment` modifier, making it available in `ContentView` and its subviews.

In `ContentView`, we have implemented the functionality to add new data items, as shown below:

```swift
struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.createDataHandler) private var createDataHandler
  @Query(sort: \Item.createTimestamp, animation: .smooth) private var items: [Item]

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(items) { item in
          ItemView(item: item)
        }
      }
      .toolbar {
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    } detail: {
      Text("Select an item")
    }
  }

  @MainActor
  private func addItem() {
    let createDataHandler = createDataHandler
    Task.detached {
      if let dataHandler = await createDataHandler() {
        try await dataHandler.newItem(date: .now)
      }
    }
  }
}
```

Key Points Summary:

- Use `@Environment(\.createDataHandler)` to introduce the method for creating `DataHandler` into the view.
- To comply with Swift’s strict concurrency checks, the `addItem` function is annotated with `@MainActor`.
- Utilize `Task.detached` to create a detached task, ensuring that the `DataHandler` instance is created on a non-main thread, and perform data operations, thereby avoiding blocking the UI.

In this way, the data management logic is separated from the view logic, maintaining the clarity and maintainability of the code while also facilitating asynchronous data processing and interface updates.

## Building Independent View to Display Data

Following the list view, we will next construct an independent view for displaying detailed `Item` data. In `ItemView`, we use the `createDataHandler` environment variable to create a `DataHandler` instance, handling the data’s deletion and update operations respectively. All operations of the `DataHandler`instances are carried out on non-main threads to ensure that the smoothness of the interface is not affected by the data processing.

```swift
struct ItemView: View {
  @Environment(\.createDataHandler) private var createDataHandler
  let item: Item
  var body: some View {
    VStack {
      Text("\(item.timestamp.timeIntervalSince1970)")
      HStack {
        Button("Update Timestamp") {
          let id = item.id
          let date = Date.now
          let createDataHandler = createDataHandler
          Task.detached {
            if let dataHandler = await createDataHandler() {
              try? await dataHandler.updateItem(id: id, timestamp: date)
            }
          }
        }
        Button("Delete") {
          let id = item.id
          let createDataHandler = createDataHandler
          Task.detached {
            if let dataHandler = await createDataHandler() {
              try? await dataHandler.deleteItem(id: id)
            }
          }
        }
      }
    }
    .buttonStyle(.bordered)
  }
}
```

Now, we can fully run the project in the simulator and implement the addition and deletion of data.

## Is a Data Transformation Layer Still Needed?

In traditional Core Data projects, it’s common to create a value-type data transformation layer, which mainly serves to convert managed objects (reference types) into value types that are more suitable for use in views. This helps enhance the safety of data handling and simplifies the data binding in views.

In SwiftData, the model is built using pure Swift types, and SwiftData’s `PersistentModel` leverages the observation mechanism provided by the `Observation` framework. This mechanism provides observability for each property, ensuring that views can accurately respond to data changes. Transforming these data in the views would disrupt this observation mechanism, leading to unnecessary view updates. Therefore, it is recommended to use the data models defined in SwiftData directly in the views.

However, this does not mean that a data transformation layer is unnecessary in all scenarios. In fact, using value-based data models for creating or updating data can be safer and more efficient, especially when it comes to data comparison and testing.

Although we did not provide a data transformation layer type in the demo project, developers should consider whether to introduce this layer based on specific needs during the actual application development process. This design decision should be based on the specific requirements of the project, taking into consideration data safety, development efficiency, and whether it can enhance the overall code quality and maintainability.

## Preparing for Preview

In SwiftUI development, previewing is an indispensable feature that can greatly improve development efficiency. Therefore, configuring an appropriate environment for previews is crucial. We typically recommend using an in-memory database for preview scenarios, which requires us to make appropriate adjustments to `DataProvider`.

Firstly, we add the following code in `DataProvider` to initialize a non-persistent `ModelContainer`specifically for preview environments:

```swift
public let previewContainer: ModelContainer = {
  let schema = Schema(CurrentScheme.models)
  let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
  do {
    return try ModelContainer(for: schema, configurations: [modelConfiguration])
  } catch {
    fatalError("Could not create ModelContainer: \(error)")
  }
}()
```

Next, we modify the `dataHandlerCreator` function so that it can choose between using a persistent or non-persistent container based on the requirements:

```swift
public func dataHandlerCreator(preview: Bool = false) -> @Sendable () async -> DataHandler {
  let container = preview ? previewContainer : sharedModelContainer
  return { DataHandler(modelContainer: container) }
}
```

To effectively utilize these configurations in previews, we typically create a dedicated preview wrapper view, which not only prepares the preview environment but also constructs demo data. Below is an example demonstrating how to build a preview container for `ItemView`:

```swift
#if DEBUG
  struct ItemViewPreviewContainer: View {
    @Environment(\.createDataHandler) var createDataHandler
    @Query var items: [Item]
    var body: some View {
      VStack {
        if let item = items.first {
          ItemView(item: item)
        }
      }
      .task {
        if let dataHander = await createDataHandler() {
          let _ = try? await dataHander.newItem(date: .now)
        }
      }
    }
  }
#endif

#Preview {
  let dataProvider = DataProvider()
  return ItemViewPreviewContainer()
    .environment(\.createDataHandler, dataProvider.dataHandlerCreator(preview: true))
    .modelContainer(dataProvider.previewContainer)
}
```

When configuring the preview environment for `ItemViewPreviewContainer`, ensure to use the `container` and `DataHandler` creation functions specifically prepared for previews. This guarantees that the preview environment is isolated, not affecting the actual application data, and provides a fast and efficient way to demonstrate and test views.

## A New Issue: The View Does Not Refresh After Data Update

If you follow this article to build your own code, you might encounter a problem: clicking the update data button in `ItemView` does not refresh the data on the interface as expected. Considering that our unit tests pass successfully and there is no issue with the data update logic itself, what could be causing this problem?

This is actually caused by a known bug in the current version of SwiftData, which leads to the view not refreshing after a data update under the following two conditions:

- The data update logic is encapsulated within a `ModelActor`.
- An independent view is used to display and respond to data changes (for example, when we adjust the display code as follows, using `Text` directly to show the data, the difference after the update becomes noticeable):

```swift
List {
  ForEach(items) { item in
    VStack {
      Text("\(item.timestamp.timeIntervalSince1970)")
      ItemView(item: item) // don't change after update
    }
  }
}
```

This issue has been raised by several developers using `ModelActor`, and the solution I provided at the time was not ideal. It mainly involved adding extra parameters to the data display view to achieve update awareness. This method has significant limitations and might result in the loss of changes during the initial update. This article will explore other possible solutions.

```swift
struct ItemView: View {
  @Environment(\.createDataHandler) private var createDataHandler
  let item: Item
  let date: Date
  var body: some View {
     ....
  }
}

ItemView(item: item, date: item.timestamp)
```

## Solution Approach

To address the issue of the view not refreshing after a data update, we initially consider the following two methods:

1. Avoid using independent views to display and respond to data.
2. Extract the data update logic from `DataHandler` and directly modify the data in the `mainContext`.

Obviously, considering the maintenance of the existing architectural pattern and testing workflow, neither of these methods is desirable. However, if performing the data update operation in the `mainContext` can avoid the issue of the view not refreshing, then could we consider creating a dedicated `DataHandler` instance for data update operations that directly uses the `mainContext`?

> The `mainContext` is provided by the `ModelContainer` instance and is annotated with `@MainActor`, meaning it can only be used on the main thread. We retrieve data in the view using this context with `@Query`.

Swift’s Macro functionality provides the potential for implementing this approach. By exploring the code generated by the `@ModelActor` macro, we can gain insight into its underlying implementation mechanism and make the necessary adjustments.

Let’s examine the initialization method of `DataHandler` generated by the `@ModelActor` macro:

```swift
public init(modelContainer: SwiftData.ModelContainer) {
    let modelContext = ModelContext(modelContainer)
    self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
    self.modelContainer = modelContainer
}
```

This initialization method creates a new `ModelContext` instance via `ModelContext(modelContainer)`and sets the actor’s execution environment to be associated with this context (using the same thread). Therefore, we can consider adding a new constructor to `DataHandler`, which allows us to provide a solution without significantly altering the current development mode.

## Temporary Solution

Our temporary solution involves extending the `DataHandler` class and adjusting `DataProvider` to ensure that data update operations are carried out in the `mainContext` on the main thread.

First, we add a new constructor to `DataHandler`:

```swift
@MainActor
public init(modelContainer: ModelContainer, mainActor _: Bool) {
  let modelContext = modelContainer.mainContext
  modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
  self.modelContainer = modelContainer
}
```

This constructor is annotated with `@MainActor` to ensure that the `modelContainer.mainContext` is directly bound to the actor’s executor. We introduced an unused parameter to avoid conflicts with the existing constructor signature.

Next, we add a new helper method in `DataProvider` to generate `DataHandler` instances that are bound to the `mainContext`:

```swift
public func dataHandlerWithMainContextCreator(preview: Bool = false) -> @Sendable @MainActor () async -> DataHandler {
  let container = preview ? previewContainer : sharedModelContainer
  return { DataHandler(modelContainer: container, mainActor: true) }
}
```

Next, we define a new environment key and extend `EnvironmentValues` to inject the new helper method:

```swift
public struct MainActorDataHandlerKey: EnvironmentKey {
  public static let defaultValue: @Sendable @MainActor () async -> DataHandler? = { nil }
}

extension EnvironmentValues {
  public var createDataHandlerWithMainContext: @Sendable @MainActor () async -> DataHandler? {
    get { self[MainActorDataHandlerKey.self] }
    set { self[MainActorDataHandlerKey.self] = newValue }
  }
}
```

In the root view of the application, we inject this new environment value:

```swift
WindowGroup {
  ContentView()
    .environment(\.createDataHandler, dataProvider.dataHandlerCreator())
    // new
    .environment(\.createDataHandlerWithMainContext, dataProvider.dataHandlerWithMainContextCreator())
}
```

In `ItemView`, we introduce and use this new environment value to perform data update operations:

```swift
struct ItemView: View {
  @Environment(\.createDataHandler) private var createDataHandler
  @Environment(\.createDataHandlerWithMainContext) private var createDataHandlerWithMainContext
  let item: Item
  var body: some View {
    VStack {
      Text("\(item.timestamp.timeIntervalSince1970)")
      HStack {
        Button("Update Timestamp") {
          updateItemTimestamp()
        }
				....
      }
    }
    .buttonStyle(.bordered)
  }

  @MainActor
  private func updateItemTimestamp() {
    let id = item.id
    let date = Date.now
    Task { @MainActor in
      if let dataHandler = await createDataHandlerWithMainContext() {
        try? await dataHandler.updateItem(id: id, timestamp: date)
      }
    }
  }
}
```

Ensure that the corresponding environment values are also injected into the preview environment:

```swift
#Preview {
  let dataProvider = DataProvider()
  return ItemViewPreviewContainer()
    .environment(\.createDataHandler, dataProvider.dataHandlerCreator(preview: true))
    .environment(\.createDataHandlerWithMainContext, dataProvider.dataHandlerWithMainContextCreator(preview: true))
    .modelContainer(dataProvider.previewContainer)
}
```

In this way, we can ensure that data update operations are conducted within a `DataHandler` instance that is bound to the `mainContext` on the main thread, while other operations continue to be executed on non-main threads. Although this requires special handling for update operations, it is a viable compromise solution without altering the existing architecture. I hope that this issue can be resolved by the official update soon.

**Special Reminder**: Since its first version (iOS 17.0), SwiftData has been fixing some known issues in almost every version, but new problems might also be introduced. Therefore, when you run the demo project provided in the article, and the project is running on different system versions or compiled with different versions of Xcode, you might encounter results that are inconsistent with expectations (for example, not being able to see new data after clicking the add button, or the app crashes when pushed to the background, etc.). We still need to wait for Apple to further address these issues. Nevertheless, I believe the data manipulation logic introduced in the article is correct. To ensure the method introduced in this article is used in a stable and reliable manner in the current project, please create all `DataHandler`s through `createDataHandlerWithMainContext` (i.e., building `DataHandler` with the main context).

## Conclusion

In this article, we explored how to adopt a new mindset to build SwiftUI applications using SwiftData. When we start using a new framework, especially those developed on the foundation of older frameworks, we cannot simply transplant old experiences and habits directly. We need to think deeply about how to leverage the advantages of the new framework while integrating the latest programming concepts to create more efficient, modern applications.

Each update to a framework is not only a challenge but also an opportunity. It requires developers to step out of their comfort zones, re-examine, and learn the potential and best practices of new tools. By doing so, we not only enhance our personal skills but also provide better products for our users. As a modern data management framework, SwiftData offers developers greater flexibility and powerful features, making data handling more intuitive and efficient.

With the continuous evolution of Swift and SwiftUI, combined with frameworks like SwiftData, developers are empowered to create safer, more responsive, richer, and more interactive applications. Therefore, keeping up with the latest development trends and learning to utilize the powerful features of these new tools is essential for every developer committed to improving their skills and product quality.