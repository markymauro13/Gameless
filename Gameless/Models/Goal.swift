import Foundation

struct Goal: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var isRecurring: Bool = true
} 