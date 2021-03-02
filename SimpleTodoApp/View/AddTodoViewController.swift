import UIKit
import RxSwift
import RxCocoa

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var detailView: UITextView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var showTodoListButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    private var viewModel: AddTodoViewPresentable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddTodoViewModel(input: (
            titleText: titleField.rx.text.orEmpty.asDriver(),
            detailText: detailView.rx.text.orEmpty.asDriver()
        ), storeManager: StoreManager.shared)
        
        setupViews()
        setupBinding()
    }

}

private extension AddTodoViewController {

    private func setupViews() {
        titleField.borderStyle = .none
    }
    
    private func setupBinding() {
        
        viewModel.output.isValid
            .drive(joinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.isValid.drive(onNext: { [weak self] isValid in
            self?.joinButton.backgroundColor = isValid ? .init(red: 200/255, green: 200/255, blue: 255/255, alpha: 1) : .lightGray
        }).disposed(by: disposeBag)
        
        titleField.rx.controlEvent(.editingDidBegin).asDriver().drive(onNext: { [weak self] in
            self?.firstResponderAnimate()
        }).disposed(by: disposeBag)
        
        titleField.rx.controlEvent(.editingDidEnd).asDriver().drive(onNext: { [weak self] in
            self?.resignFirstResponderAnimate()
        }).disposed(by: disposeBag)
        
        detailView.rx.didBeginEditing.asDriver().drive(onNext: { [weak self] in
            self?.firstResponderAnimate()
        }).disposed(by: disposeBag)
        
        detailView.rx.didEndEditing.asDriver().drive(onNext: { [weak self] in
            self?.resignFirstResponderAnimate()
        }).disposed(by: disposeBag)
        
        joinButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let title = self?.titleField.text, let detail = self?.detailView.text else { return }
            self?.viewModel.insertTodoToFireStore(title: title, detail: detail)
            self?.titleField.text = ""
            self?.detailView.text = ""
        }).disposed(by: disposeBag)
        
        showTodoListButton.rx.tap.subscribe(onNext: { [weak self] in
            let viewController = TodoListViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func firstResponderAnimate() {
        let width = view.frame.size.width
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.transform = CGAffineTransform(translationX: 0, y: -width / 4)
        }
    }
    
    private func resignFirstResponderAnimate() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.transform = .identity
        }
    }
}
