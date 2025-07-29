
import UIKit

class ReaderViewController: UIViewController, NewsDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var readerTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var showHideBookmarkBtn: UIButton!
    
    // MARK: - Properties
    var viewModel = ViewModel()
    var model: NewsResponse?
    var filteredArticles: [Article] = []
    var coredataModel: [Article] = []
    var bookmarkedArticles: [Article] = []
    var isSearching = false
    var isShowingBookmarks = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readerTableView.register(UINib(nibName: Identifier.newsCell, bundle: nil), forCellReuseIdentifier: Identifier.newsCell)
        readerTableView.delegate = self
        readerTableView.dataSource = self
        viewModel.delegate = self
        setupSearchField()
        pullToRefrace()
        viewModel.ApiCall()
        callApi()
    }
    
    
    func setupSearchField() {
        searchTextField.setupLeftImage(imageName: "searchIcon")
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func callApi() {
        if NetworkMonitor.shared.isConnected {
            viewModel.ApiCall()
        }else{
            filteredArticles = CoreDataManager.shared.fetchArticles()
            coredataModel = filteredArticles
        }
        
    }
    
    func getApiData(data:NewsResponse?) {
         model = data
        filteredArticles = data?.articles ?? []
        
        if let articles = data?.articles {
            CoreDataManager.shared.saveArticles(articles)
            coredataModel = filteredArticles
        }
       
        DispatchQueue.main.async {
            self.readerTableView.reloadData()
        }
  
    }
    
    func pullToRefrace(){
        let pullControl = UIRefreshControl()
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(pulledRefreshControl(_:)), for: .valueChanged)
        readerTableView.refreshControl = pullControl
    }
  
    
    @objc func pulledRefreshControl(_ sender: UIRefreshControl) {
        showHideBookmarkBtn.setImage(UIImage(named: "unBookmark"), for: .normal)
         searchTextField.text = ""
        if NetworkMonitor.shared.isConnected {
            viewModel.ApiCall()
        } else {
            filteredArticles = CoreDataManager.shared.fetchArticles()
            coredataModel = filteredArticles
        }
        self.readerTableView.reloadData()
       
        sender.endRefreshing()
        
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased() else { return }
        
        isSearching = !searchText.isEmpty
        
        if isShowingBookmarks {
            filteredArticles = isSearching
            ? bookmarkedArticles.filter {
                ($0.title?.lowercased().contains(searchText) ?? false) ||
                ($0.description?.lowercased().contains(searchText) ?? false) ||
                ($0.author?.lowercased().contains(searchText) ?? false)
            }
            : bookmarkedArticles
            
        } else if NetworkMonitor.shared.isConnected {
            guard let articles = model?.articles else { return }
            filteredArticles = isSearching
            ? articles.filter {
                ($0.title?.lowercased().contains(searchText) ?? false) ||
                ($0.description?.lowercased().contains(searchText) ?? false) ||
                ($0.author?.lowercased().contains(searchText) ?? false)
            }
            : articles
            
        } else {
            filteredArticles = isSearching
            ? coredataModel.filter {
                ($0.title?.lowercased().contains(searchText) ?? false) ||
                ($0.description?.lowercased().contains(searchText) ?? false) ||
                ($0.author?.lowercased().contains(searchText) ?? false)
            }
            : coredataModel
        }
        
        readerTableView.reloadData()
        
    }

    
    @objc func bookmarkAction(sender: UIButton) {
        let index = sender.tag
        let article: Article
        
       if isShowingBookmarks {
            article = bookmarkedArticles[index]
        } else if NetworkMonitor.shared.isConnected {
            article = isSearching ? filteredArticles[index] : model?.articles[index] ?? Article(source: Source(id: nil, name: ""), author: nil, title: nil, description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: "")
        } else {
            article = isSearching ? filteredArticles[index] : coredataModel[index]
        }
        
        if let existingIndex = bookmarkedArticles.firstIndex(where: { $0.title == article.title }) {
            bookmarkedArticles.remove(at: existingIndex)
        } else {
            bookmarkedArticles.append(article)
        }
        
        readerTableView.reloadData()
     }
    
    @IBAction func showBookMarkedAction(_ sender: Any) {
        isShowingBookmarks.toggle()
        
       if isShowingBookmarks {
            showHideBookmarkBtn.setImage(UIImage(named: "bookmark"), for: .normal)
            filteredArticles = bookmarkedArticles
        } else {
            showHideBookmarkBtn.setImage(UIImage(named: "unBookmark"), for: .normal)
            if NetworkMonitor.shared.isConnected {
                filteredArticles = model?.articles ?? []
            } else {
                filteredArticles = coredataModel
            }
            
        }
        isSearching = false
        searchTextField.text = ""
        readerTableView.reloadData()
        
        
     }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
     }
    
    
    
    
}
