
//  ReaderExt.swift
//  ReaderApp
//  Created by swaim yadav on 26/07/25.

import UIKit

extension ReaderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingBookmarks {
            return filteredArticles.count
        }
        
        if NetworkMonitor.shared.isConnected {
            return isSearching ? filteredArticles.count : (model?.articles.count ?? 0)
        } else {
            return isSearching ? filteredArticles.count : (coredataModel.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.newsCell, for: indexPath) as? NewCellTableViewCell else {
            return UITableViewCell()
        }
        
        cell.bookmarkBtn.addTarget(self, action: #selector(bookmarkAction), for: .touchUpInside)
        cell.bookmarkBtn.tag = indexPath.row
        
        let article: Article
        if isShowingBookmarks {
            article = filteredArticles[indexPath.row]
        } else if NetworkMonitor.shared.isConnected {
            article = isSearching ? filteredArticles[indexPath.row] : model?.articles[indexPath.row] ?? Article(source: Source(id: nil, name: ""), author: nil, title: nil, description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: "")
        } else {
            article = isSearching ? filteredArticles[indexPath.row] : coredataModel[indexPath.row] ?? Article(source: Source(id: nil, name: ""), author: nil, title: nil, description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: "")
        }
        
        cell.setData(keys: article)
        let isBookmarked = bookmarkedArticles.contains(where: { $0.title == article.title })
        let imageName = isBookmarked ? "bookmark" : "unBookmark"
        cell.bookmarkBtn.setImage(UIImage(named: imageName), for: .normal)        
        return cell
        
        
    }
    
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urll = filteredArticles[indexPath.row].url,let url = URL(string: urll) {
            UIApplication.shared.open(url)
        }
        
        
        
    }
    
    
    
}
