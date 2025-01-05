
import Foundation

struct Exercise: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let muscle: String
    let equipment: String
    let difficulty: String
    let instructions: String
    
    enum CodingKeys: String, CodingKey {
        case name, type, muscle, equipment, difficulty, instructions
    }
} 
       
