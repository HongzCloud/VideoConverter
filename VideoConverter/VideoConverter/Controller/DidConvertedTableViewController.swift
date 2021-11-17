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
    private var headerView = WillConvertTableHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didConvertedTableView.dataSource = self
        didConvertedTableView.delegate = self
        didConvertedTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        
        if let files = getFiles(.didConverted) {
            didConvertMedia = files
            setHeaderView()
            setTableViewConstraints()
        }
    }
    
    private func setHeaderView() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.backgroundColor = .lightGray
        self.headerView.configure(title: "Audio List", photoLibraryIsHidden: false)
        
        self.view.addSubview(headerView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/14)
        ])
    }
    
    private func setTableViewConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.didConvertedTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.didConvertedTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.didConvertedTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.didConvertedTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.didConvertedTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func getFiles(_ directory: Directory) -> [AVAsset]? {
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
