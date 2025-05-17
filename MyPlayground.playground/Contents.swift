import Cocoa

func lastHero(n: Int, k: Int) -> Int {
    // Check for invalid arguments
    if n <= 0 || k <= 0 {
        return -1
    }
    
    var people = Array(1...n) // Create an array of people numbered 1 to n
    var index = 0 // Start from the first person
    
    // Continue removing every kth person until only one remains
    while people.count > 1 {
        // Find the index of the person to be removed (cyclically)
        index = (index + k - 1) % people.count
        people.remove(at: index) // Remove that person
    }
    
    // Return the last remaining person's number
    return people.first!
}

lastHero(n: 7, k: 2)
