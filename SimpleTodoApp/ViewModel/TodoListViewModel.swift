import RxCocoa
import RxSwift
import RxDataSources

typealias TodoItemsSection = SectionModel<Int, TodoCellViewPresentable>

protocol TodoListPresentable {
    typealias Input = ()
    typealias Output = (
        todos: Driver<[TodoItemsSection]>, ()
    )
    
    var input: TodoListPresentable.Input { get }
    var output: TodoListPresentable.Output { get }
}

class TodoListViewModel: TodoListPresentable {
    var input: TodoListPresentable.Input
    var output: TodoListPresentable.Output
    
    private let storeManager: StoreManager
    
    init(input: TodoListPresentable.Input, storeManager: StoreManager) {
        self.input = input
        self.storeManager = storeManager
        self.output = TodoListViewModel.output(storeManager: self.storeManager)
    }
}

private extension TodoListViewModel {
    static func output(storeManager: StoreManager) -> TodoListPresentable.Output {
        let todos = storeManager.fetchTodosFromFirestore()
            .map { $0.compactMap { TodoCellViewModel(usingModel: $0) } }
            .map { [TodoItemsSection(model: 0, items: $0)] }
            .asDriver(onErrorJustReturn: [])
        
        return (
            todos: todos, ()
        )
    }
}
