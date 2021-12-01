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
    private var headerView = HeaderView()
    private var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didConvertedTableView.dataSource = self
        didConvertedTableView.delegate = self
        didConvertedTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        
        setHeaderView()
        setTableViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.didConvertMedia.removeAll()
        if let files = getFiles(.didConverted) {
            didConvertMedia = files
        }
        self.didConvertedTableView.reloadData()
    }
    
    private func setHeaderView() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.configure(title: "Audio List")
        
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
    
    private func editFileNameAlert(oldName: String, completion: @escaping (_ newName: String) -> Void) {
        alert = UIAlertController(title: "파일명 수정", message: "파일명을 입력하세요.", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default) { [self] (ok) in
            let text = alert!.textFields?.first?.text
            if let text = text {
             
                completion(text)
            }
        }

        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in

        }

        alert!.addAction(cancel)
        alert!.addAction(ok)
        alert!.addTextField { [self] textField in
            textField.text = oldName
            textField.addTarget(self, action: #selector(alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        self.present(alert!, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        self.alert?.actions[1].isEnabled = isValidFileName(sender.text!)
    }
    
   private func isValidFileName(_ name: String) -> Bool {
       //영어 소문자,대문자,한글,숫자 1~20자리
       let pattern = "^[A-Za-z0-9가-힣_]{1,20}$"
       let regex = try? NSRegularExpression(pattern: pattern)
       if let _ = regex?.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.count)) {
           return true
       }
       
       return false
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
        cell.setPlayButtonDelegate(self)
        cell.setMediaViewIndex(indexPath.row)
        return cell
    }
}

extension DidConvertedTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat {
        return tableView.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            do {
                //삭제하기
                let asset = self.didConvertMedia[indexPath.row] as! AVURLAsset
                try FileManager.default.removeItem(at: asset.url)
                self.didConvertMedia.remove(at: indexPath.row)
                
            } catch let e {
                //에러처리
                print(e.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        let fileNameEditAction = UIContextualAction(style: .normal, title: nil) { [self] (action, view, completion) in
            
            //수정하기
            let asset = self.didConvertMedia[indexPath.row] as! AVURLAsset
            editFileNameAlert(oldName: asset.url.deletingPathExtension().lastPathComponent, completion: { newName in
                
                let newFileName = newName + "." + asset.url.pathExtension
                let newPath = asset.url.deletingLastPathComponent().appendingPathComponent(newFileName)
                didConvertMedia[indexPath.row] = AVAsset(url: newPath)
                
                do {
                    try FileManager.default.moveItem(at: asset.url, to: newPath)
                } catch let e {
                    //에러처리
                    print(e.localizedDescription)
                }
            })
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash")
        fileNameEditAction.image = UIImage(systemName: "square.and.pencil")
        
        let configuration = UISwipeActionsConfiguration(actions: [action, fileNameEditAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension DidConvertedTableViewController: MediaViewDelegate {

    func didTappedPlayButton(index: Int) {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        let asset = didConvertMedia[index] as! AVURLAsset
        svc.setPlayer(url: asset.url)
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true)
    }
    
    func didTappedMediaShareButton() {
        self.view.makeToastActivity(.center)
        let asset = didConvertMedia[0] as! AVURLAsset
        
        var shareObject = [Any]()
        shareObject.append(asset.url)
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        self.view.hideToastActivity()
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?, completed: Bool,
             arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.view.makeToast("공유 성공")
            } else {
                if error != nil {
                    self.view.makeToast("공유 실패")
                }
            }
            if let shareError = error { print(shareError)} }
    }
}

