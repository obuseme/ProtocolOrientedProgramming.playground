// Playground for work from:
// http://www.raywenderlich.com/109156/introducing-protocol-oriented-programming-in-swift-2

protocol Bird: BooleanType {
    var name: String { get }
    var canFly: Bool { get }
}

extension Bird where Self: Flyable {
    // Flyable birds can fly!
    var canFly: Bool { return true }
}

protocol Flyable {
    var airspeedVelocity: Double { get }
}

extension BooleanType where Self: Bird {
    var boolValue: Bool {
        return self.canFly
    }
}

struct FlappyBird: Bird, Flyable {
    let name: String
    let flappyAmplitude: Double
    let flappyFrequency: Double
    // intentionally leave out definition of canFly - it comes from protocol extension Bird where Flyable

    var airspeedVelocity: Double {
        return 3 * flappyFrequency * flappyAmplitude
    }
}

struct Penguin: Bird {
    let name: String
    let canFly = false
}

struct SwiftBird: Bird, Flyable {
    var name: String { return "Swift \(version)" }
    let version: Double
    // intentionally leave out definition of canFly - it comes from protocol extension Bird where Flyable

    // Swift is FAST!
    var airspeedVelocity: Double { return 2000.0 }
}

var swifty = SwiftBird(version: 1)
swifty.canFly

enum UnladenSwallow: Bird, Flyable {
    case African
    case European
    case Unknown

    var name: String {
        switch self {
        case .African:
            return "African"
        case .European:
            return "European"
        case .Unknown:
            return "What do you mean? African or European?"
        }
    }

    var airspeedVelocity: Double {
        switch self {
        case .African:
            return 10.0
        case .European:
            return 9.9
        case .Unknown:
            fatalError("You are thrown from the bridge of death!")
        }
    }
}

if UnladenSwallow.African {
    print("I can fly!")
} else {
    print("Guess I’ll just sit here :[")
}

// Let's create an extension on something from the Swift Standard Library
extension CollectionType {
    func skip(skip: Int) -> [Generator.Element] {
        guard skip != 0 else { return [] }

        var index = self.startIndex
        var result: [Generator.Element] = []
        var i = 0
        repeat {
            if i % skip == 0 {
                result.append(self[index])
            }
            index = index.successor()
            i++
        } while (index != self.endIndex)
        
        return result
    }
}

// Demo of CollectionType in action
let bunchaBirds: [Bird] =
[UnladenSwallow.African,
    UnladenSwallow.European,
    UnladenSwallow.Unknown,
    Penguin(name: "King Penguin"),
    SwiftBird(version: 2.0),
    FlappyBird(name: "Felipe", flappyAmplitude: 3.0, flappyFrequency: 20.0)]

bunchaBirds.skip(3)

// Define a single method take take an Array of Flyables and figure out the fastest
func topSpeed<T: CollectionType where T.Generator.Element == Flyable>(c: T) -> Double {
    return c.map { $0.airspeedVelocity }.reduce(0) { max($0, $1) }
}

let flyingBirds: [Flyable] =
[UnladenSwallow.African,
    UnladenSwallow.European,
    SwiftBird(version: 2.0)]

topSpeed(flyingBirds)