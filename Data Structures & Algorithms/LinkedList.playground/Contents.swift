//: Playground - noun: a place where people can play

import UIKit
import Foundation

public class Node<Value> {
    public var value: Value
    public var next: Node?
    
    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next) + " "
    }
}

let node1 = Node(value: 1)
let node2 = Node(value: 2)
let node3 = Node(value: 3)

node1.next = node2
node2.next = node3

//print(node1)

public class LinkedList<Value> {
    public var head: Node<Value>?
    public var tail: Node<Value>?
    
    public init() {}
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    public func append(_ value: Value) {
        guard !isEmpty else {
            push(value)
            return
        }
        
        tail!.next = Node(value: value)
        tail = tail!.next
    }
    
    public func node(at index: Int) -> Node<Value>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        
        return currentNode
    }
    
    @discardableResult
    public func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        guard tail !== node else {
            append(value)
            return tail!
        }
        
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    @discardableResult
    public func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    @discardableResult
    public func removeLast() -> Value? {
        guard let head = head else {
            return nil
        }
        
        guard head.next != nil else {
            return pop()
        }
        
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        
        prev.next = nil
        tail = prev
        return current.value
    }
    
    @discardableResult
    public func remove(after node: Node<Value>) -> Value? {
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else {
            return "Empty List"
        }
        return String(describing: head)
    }
}

//var list = LinkedList<Int>()
//list.push(3)
//list.append(1)
//list.push(2)
//list.append(2)
//list.push(1)
//list.append(3)

//print("Before inserting: \(list)")

//var middleNode = list.node(at: 1)!
//
//for _ in 1...4 {
//    middleNode = list.insert(-1, after: middleNode)
//}

//print("After inserting: \(list)")

//print("Before popping list: \(list)")
//
//let poppedValue = list.pop()
//
//print("After popping list: \(list)")
//print("Popped value: " + String(describing: poppedValue))

//print("Before removing last node: \(list)")

//let removedValue = list.removeLast()

//print("After removing last node: \(list)")
//print("Removed value: " + String(describing: removedValue))

//print("Before removing at particular index: \(list)")

//let index = 1
//let node = list.node(at: index - 1)!
//let removedValue = list.remove(after: node)

//print("After removing at index \(index): \(list)")
//print("Removed value: " + String(describing: removedValue))

extension LinkedList: Collection {
    public struct Index: Comparable {
        public var node: Node<Value>?
        
        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains{ $0 === rhs.node }
            }
        }
    
    public var startIndex: Index {
        return Index(node: head)
    }
    
    public var endIndex: Index {
        return Index(node: tail?.next)
    }
    
    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    
    public subscript(position: Index) -> Value {
        return position.node!.value
    }
}

// Verifying Collection Adherence

//var list = LinkedList<Int>()

//for i in 0...9 {
//    list.append(i)
//}

//print("List: \(list)")
//print("First element: \(list[list.startIndex])")
//print("Array containing first 3 elements: \(Array(list.prefix(3)))")
//print("Array continaing last 3 elements: \(Array(list.suffix(3)))")

//let sum = list.reduce(0, +)
//print("Sum of all values: \(sum)")
