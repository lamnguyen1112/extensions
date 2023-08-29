import Foundation

struct Atomic<Value> {
  private let queue = DispatchQueue(label: "atomic")

  private var value: Value
  init(wrappedValue: Value) {
    self.value = wrappedValue
  }

  var wrappedValue: Value {
    get {
      return queue.sync { value }
    }
    set {
      queue.sync { value = newValue }
    }
  }
}

// References
// https://fxstudio.dev/thread-safety-data-race-swift/
// https://www.vadimbulavin.com/swift-atomic-properties-with-property-wrappers/
