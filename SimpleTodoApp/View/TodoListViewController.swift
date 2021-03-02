import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TodoListViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    private static let cellId = "TodoCell"
    
    private let dataSources = RxTableViewSectionedReloadDataSource<TodoItemsSection> { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListViewController.cellId, for: indexPath) as! TodoCell
        cell.configure(usingViewModel: item)
        return cell
    }
    
    
    private let disposeBag = DisposeBag()
    private var viewModel: TodoListPresentable!
    private let storeManager = StoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = TodoListViewModel(input: (), storeManager: storeManager)
        
        setupViews()
        setupBinding()
    }
    
    private func setupViews() {
        tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: TodoListViewController.cellId)
        tableView.separatorStyle = .none
    }
    
    private func setupBinding() {
        self.viewModel.output.todos
            .drive(tableView.rx.items(dataSource: self.dataSources))
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
}
