import Foundation
import RxCocoa
import RxSwift

protocol AddTodoViewPresentable {
    typealias Input = (
        titleText: Driver<String>,
        detailText: Driver<String>
    )
    typealias Output = (
        isValid: Driver<Bool>, ()
    )
    
    var input: AddTodoViewPresentable.Input { get }
    var output: AddTodoViewPresentable.Output { get }
    
    func insertTodoToFireStore(title: String, detail: String)
}


class AddTodoViewModel: AddTodoViewPresentable {
    var input: AddTodoViewPresentable.Input
    var output: AddTodoViewPresentable.Output
    
    var storeManager: StoreManager
    
    init(input: AddTodoViewPresentable.Input, storeManager: StoreManager) {
        self.input = input
        self.output = AddTodoViewModel.output(input: self.input)
        self.storeManager = storeManager
    }
}

private extension AddTodoViewModel {
    static func output(input: AddTodoViewPresentable.Input) -> AddTodoViewPresentable.Output {
        let titleObservable = input.titleText.asObservable()
        let detailObservable = input.detailText.asObservable()
        
        let isValid = Observable.combineLatest(titleObservable, detailObservable) { (title, detail) -> Bool in
            return !title.isEmpty && !Validator.removeSpaceAndNewLine(text: detail).isEmpty
        }.asDriver(onErrorJustReturn: false)
        
        return (
            isValid: isValid, ()
        )
    }
}

extension AddTodoViewModel {
    func insertTodoToFireStore(title: String, detail: String) {
        storeManager.insertTodoToFireStore(title: title, detail: detail)
    }
}

