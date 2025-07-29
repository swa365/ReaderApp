//
//  NewCellTableViewCell.swift
//  ReaderApp
//  Created by swaim yadav on 26/07/25.


import UIKit
import SDWebImage

class NewCellTableViewCell: UITableViewCell{
        
    // MARK: - outlets
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImage.layer.cornerRadius = 7
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - setData
    func setData(keys : Article){
        
        if let imageUrl = keys.urlToImage {
            newsImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "ic_loading"))
        }
        
        if let title = keys.description{
            newsTitle.text = title
        }
        if let name = keys.author{
            authorName.text = name
        }
        if keys.publishedAt != nil{
            timeLbl.text = formatArticleDate(keys.publishedAt!)
        }
        
    }
    
    func formatArticleDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Today, \(formatter.string(from: date))"
        }
        else if calendar.isDateInYesterday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Yesterday, \(formatter.string(from: date))"
        }
        else if let daysAgo = calendar.dateComponents([.day], from: date, to: now).day, daysAgo < 7 {
            return "\(daysAgo) days ago"
        }
        else{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    
     }
    
    
    
}
