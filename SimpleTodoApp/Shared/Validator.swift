import Foundation

class Validator {
    
    static func removeSpaceAndNewLine(text: String) -> String {
        var removeText = text.trimmingCharacters(in: .init(charactersIn: " "))
        removeText = removeText.trimmingCharacters(in: .init(charactersIn: "　"))
        removeText = removeText.trimmingCharacters(in: .init(charactersIn: "\n"))
        return removeText
    }
    
}
