import Foundation

protocol TodoCellViewPresentable {
    var title: String { get }
    var detail: String { get }
}

struct TodoCellViewModel: TodoCellViewPresentable {
    var title: String
    var detail: String
    
    init(usingModel model: TodoModel) {
        self.title = model.title
        self.detail = model.detail
    }
}
