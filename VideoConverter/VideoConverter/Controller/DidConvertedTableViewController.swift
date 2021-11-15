//
//  DidConvertedTableViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/15.
//
import AVFoundation
import UIKit

class DidConvertedTableViewController: UIViewController {

    var didConvertMedia = [AVAsset]()
    @IBOutlet weak var didConvertedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didConvertedTableView.dataSource = self
        didConvertedTableView.delegate = self
        didConvertedTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        
        if let files = getFiles(.didConverted) {
            didConvertMedia = files
        }
    }
    
    func getFiles(_ directory: Directory) -> [AVAsset]? {
        guard let urls = FileHelper().urls(for: directory) else { return nil }
        var avAssests = [AVAsset]()
        
        for url in urls {
            avAssests.append(AVAsset(url: url))
        }
        
        return avAssests
    }
}

extension DidConvertedTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return didConvertMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WillConvertTableViewCell") as? WillConvertTableViewCell else { return UITableViewCell() }
        let file = didConvertMedia[indexPath.row] as! AVURLAsset
        cell.configure(image: nil, name: file.url.lastPathComponent, duration: file.duration.durationText)
        return cell
    }
}


extension DidConvertedTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat {
        return tableView.frame.height / 10
    }

}
