//
//  SynchronizedArray.swift
//  MVVMBinding Example
//
//  Created by Ivan Foong on 1/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import Foundation

public class SynchronizedArray<T> {
    fileprivate let queue = DispatchQueue(label: "io.zamzam.ZamzamKit.SynchronizedArray", attributes: .concurrent)
    fileprivate var array: [T]
    
    init(array: [T] = [T]()) {
        self.array = array
    }
}

// MARK: - Properties
public extension SynchronizedArray {
    
    /// The first element of the collection.
    var first: T? {
        var result: T?
        queue.sync { result = self.array.first }
        return result
    }
    
    /// The last element of the collection.
    var last: T? {
        var result: T?
        queue.sync { result = self.array.last }
        return result
    }
    
    /// The number of elements in the array.
    var count: Int {
        var result = 0
        queue.sync { result = self.array.count }
        return result
    }
    
    /// A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool {
        var result = false
        queue.sync { result = self.array.isEmpty }
        return result
    }
    
    /// A textual representation of the array and its elements.
    var description: String {
        var result = ""
        queue.sync { result = self.array.description }
        return result
    }
}

// MARK: - Immutable
public extension SynchronizedArray {
    /// Returns the first element of the sequence that satisfies the given predicate or nil if no such element is found.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The first match or nil if there was no match.
    func first(where predicate: (T) -> Bool) -> T? {
        var result: T?
        queue.sync { result = self.array.first(where: predicate) }
        return result
    }
    
    /// Returns an array containing, in order, the elements of the sequence that satisfy the given predicate.
    ///
    /// - Parameter isIncluded: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element should be included in the returned array.
    /// - Returns: An array of the elements that includeElement allowed.
    func filter(_ isIncluded: (T) -> Bool) -> [T] {
        var result = [T]()
        queue.sync { result = self.array.filter(isIncluded) }
        return result
    }
    
    /// Returns the first index in which an element of the collection satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: The index of the first element for which predicate returns true. If no elements in the collection satisfy the given predicate, returns nil.
    func index(where predicate: (T) -> Bool) -> Int? {
        var result: Int?
        queue.sync { result = self.array.index(where: predicate) }
        return result
    }
    
    /// Returns the elements of the collection, sorted using the given predicate as the comparison between elements.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
    /// - Returns: A sorted array of the collection’s elements.
    func sorted(by areInIncreasingOrder: (T, T) -> Bool) -> [T] {
        var result = [T]()
        queue.sync { result = self.array.sorted(by: areInIncreasingOrder) }
        return result
    }
    
    /// Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-nil results of calling transform with each element of the sequence.
    func flatMap<E>(_ transform: (T) -> E?) -> [E] {
        var result = [E]()
        queue.sync { result = self.array.flatMap(transform) }
        return result
    }
    
    /// Calls the given closure on each element in the sequence in the same order as a for-in loop.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a parameter.
    func forEach(_ body: (T) -> Void) {
        queue.sync { self.array.forEach(body) }
    }
    
    /// Returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: true if the sequence contains an element that satisfies predicate; otherwise, false.
    func contains(where predicate: (T) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(where: predicate) }
        return result
    }
}

// MARK: - Mutable
public extension SynchronizedArray {
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameter element: The element to append to the array.
    func append( _ element: T) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameter element: The element to append to the array.
    func append( _ elements: [T]) {
        queue.async(flags: .barrier) {
            self.array += elements
        }
    }
    
    /// Inserts a new element at the specified position.
    ///
    /// - Parameters:
    ///   - element: The new element to insert into the array.
    ///   - index: The position at which to insert the new element.
    func insert( _ element: T, at index: Int) {
        queue.async(flags: .barrier) {
            self.array.insert(element, at: index)
        }
    }
    
    /// Removes and returns the element at the specified position.
    ///
    /// - Parameters:
    ///   - index: The position of the element to remove.
    ///   - completion: The handler with the removed element.
    func remove(at index: Int, completion: ((T) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let element = self.array.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }
    
    /// Removes and returns the element at the specified position.
    ///
    /// - Parameters:
    ///   - predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    ///   - completion: The handler with the removed element.
    func remove(where predicate: @escaping (T) -> Bool, completion: ((T) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            guard let index = self.array.index(where: predicate) else { return }
            let element = self.array.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }
    
    /// Removes all elements from the array.
    ///
    /// - Parameter completion: The handler with the removed elements.
    func removeAll(completion: (([T]) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()
            
            DispatchQueue.main.async {
                completion?(elements)
            }
        }
    }
}

public extension SynchronizedArray {
    
    /// Accesses the element at the specified position if it exists.
    ///
    /// - Parameter index: The position of the element to access.
    /// - Returns: optional element if it exists.
    subscript(index: Int) -> T? {
        get {
            var result: T?
            
            queue.sync {
                guard self.array.startIndex..<self.array.endIndex ~= index else { return }
                result = self.array[index]
            }
            
            return result
        }
        set {
            guard let newValue = newValue else { return }
            
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
    }
}


// MARK: - Equatable
public extension SynchronizedArray where T: Equatable {
    
    /// Returns a Boolean value indicating whether the sequence contains the given element.
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: true if the element was found in the sequence; otherwise, false.
    func contains(_ element: T) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(element) }
        return result
    }
    
    public static func ==(lhs: SynchronizedArray, rhs: SynchronizedArray) -> Bool {
        return lhs.array == rhs.array
    }
}

// MARK: - Infix operators
public extension SynchronizedArray {
    
    static func +=(left: inout SynchronizedArray, right: T) {
        left.append(right)
    }
    
    static func +=(left: inout SynchronizedArray, right: [T]) {
        left.append(right)
    }
}
