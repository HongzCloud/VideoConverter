//
//  DidConvertedTableViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/15.
//
import AVFoundation
import UIKit

class DidConvertedTableViewController: UIViewController {

    private var assetManager: AssetManager!
    @IBOutlet weak var didConvertedTableView: UITableView!
    private var headerView: HeaderView!
    private var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assetManager = AssetManager(directoryPath: .didConverted)
        setHeaderView()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.assetManager.reloadAssets()
    }
    
    private func setHeaderView() {
        self.headerView = HeaderView()
        self.headerView.configure(title: "Audio List")
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(headerView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/14)
        ])
    }
    
    private func setTableView() {
        self.didConvertedTableView.dataSource = self
        self.didConvertedTableView.delegate = self
        self.didConvertedTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        self.didConvertedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.didConvertedTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.didConvertedTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.didConvertedTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.didConvertedTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func editFileNameAlert(oldName: String, completion: @escaping (_ newName: String) -> Void) {
        alert = UIAlertController(title: "파일명 수정",
                                  message: "파일명을 입력하세요.",
                                  preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default) { [self] (ok) in
            let text = alert!.textFields?.first?.text
            if let text = text {
                completion(text)
            }
        }

        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
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
        return self.assetManager.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WillConvertTableViewCell") as? WillConvertTableViewCell else { return UITableViewCell() }
        let file = self.assetManager.assets[indexPath.row] as! AVURLAsset
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

        let action = UIContextualAction(style: .normal, title: nil) {
            (action, view, completion) in
            //삭제하기
            self.assetManager.removeAsset(at: indexPath.row, completion: {
                result in
                if result {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    completion(true)
                } else {
                    let alert = UIAlertController(title: "파일 삭제",
                                                  message: "파일을 삭제할 수 없습니다.",
                                                  preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
        let fileNameEditAction = UIContextualAction(style: .normal, title: nil) { [self] (action, view, completion) in
            
            //수정하기
            let asset = self.assetManager.assets[indexPath.row] as! AVURLAsset
            let oldName = asset.url.deletingPathExtension().lastPathComponent
            editFileNameAlert(oldName: oldName, completion: { newName in
                self.assetManager.editAsset(at: indexPath.row, name: newName, completion: {
                    result in
                    
                    if result {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                        completion(true)
                    } else {
                        let alert = UIAlertController(title: "파일명 수정",
                                                      message: "파일명 변경 실패",
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            })
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

    func didTappedPlayButton(selectedIndex: Int) {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        let asset = self.assetManager.assets[selectedIndex] as! AVURLAsset
        svc.setPlayer(url: asset.url)
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true)
    }
    
    func didTappedMediaShareButton(selectedIndex: Int) {
        self.view.makeToastActivity(.center)
        let asset = self.assetManager.assets[selectedIndex] as! AVURLAsset
        
        var shareObject = [Any]()
        shareObject.append(asset.url)
        
        let actVC = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        actVC.popoverPresentationController?.sourceView = self.view
        
        self.view.hideToastActivity()
        self.present(actVC, animated: true, completion: nil)
        
        actVC.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?,
             completed: Bool,
             arrayReturnedItems: [Any]?,
             error: Error?) in
            
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

