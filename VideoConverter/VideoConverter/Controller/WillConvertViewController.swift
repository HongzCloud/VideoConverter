//
//  ViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/20.
//

import UIKit
import AVFoundation
import Photos
import Toast_Swift

class WillConvertViewController: UIViewController {

    var willConvertMedia = [AVAsset]()
    @IBOutlet weak var willConvertTableView: UITableView!
    let convertView = ConvertView()
    let headerView = HeaderView()
    let pickerViewData = FileFormat.allCases.map{ $0.text }
    var tableViewConstraints: [NSLayoutConstraint]? = nil
    private var selectedCellIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.willConvertTableView.delegate = self
        self.willConvertTableView.dataSource = self
        self.willConvertTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        self.headerView.delegate = self

        setHeaderViewConstraints()
        setConvertViewConstraints()
        setTableViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        willConvertMedia.removeAll()
        if let files = getFiles(.willConvert) {
            willConvertMedia = files
            self.willConvertTableView.reloadData()
        }
    }

    private func newTableViewConstraints() -> [NSLayoutConstraint] {
        let safeArea = self.view.safeAreaLayoutGuide
        self.willConvertTableView.translatesAutoresizingMaskIntoConstraints = false
        let constrains = [
            self.willConvertTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.willConvertTableView.bottomAnchor.constraint(equalTo: self.convertView.topAnchor),
            self.willConvertTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.willConvertTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        return constrains
    }
    
    private func setHeaderViewConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.backgroundColor = .lightGray
        self.headerView.configure(title: "Viedo List", photoLibraryButtonIsHidden: false)
        
        self.view.addSubview(headerView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/14)
        ])
    }
    
    private func setConvertViewConstraints() {
        self.convertView.translatesAutoresizingMaskIntoConstraints = false
        self.convertView.backgroundColor = .lightGray
        self.convertView.didConvertedExtensionNamePickerView.delegate = self
        self.convertView.didConvertedExtensionNamePickerView.dataSource = self
        self.convertView.isHidden = true
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(convertView)
        NSLayoutConstraint.activate([
            self.convertView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.convertView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.convertView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.convertView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/10)
        ])
    }
    
    private func setTableViewConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.willConvertTableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.willConvertTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.willConvertTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.willConvertTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.willConvertTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.tableViewConstraints = constraints
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

extension WillConvertViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return willConvertMedia.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WillConvertTableViewCell") as? WillConvertTableViewCell else { return UITableViewCell() }
        let file = willConvertMedia[indexPath.row] as! AVURLAsset
        cell.configure(image: nil, name: file.url.lastPathComponent, duration: file.duration.durationText)
        cell.setPlayButtonDelegate(self)
        cell.setMediaViewIndex(indexPath.row)
        return cell
    }
}

extension WillConvertViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat {
        return tableView.frame.height / 10
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = willConvertMedia[indexPath.row] as! AVURLAsset
        self.selectedCellIndex = indexPath
        convertView.isHidden = false
        convertView.configure(currentFormat: file.url.pathExtension)
        if (self.tableViewConstraints != nil) && self.headerView.isHidden == false {
            NSLayoutConstraint.deactivate(self.tableViewConstraints!)
            NSLayoutConstraint.activate(newTableViewConstraints())
        }
    }
}

extension WillConvertViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select=\(row)")
    }
}

extension WillConvertViewController: CustomHeaderViewDelegate {

    func didTappedPhotoLibraryButton() {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListViewController") else {
            return
        }
      
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true)
    }
}

extension WillConvertViewController: MediaViewDelegate {

    func didTappedPlayButton(index: Int) {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        let asset = willConvertMedia[index] as! AVURLAsset
        svc.setPlayer(url: asset.url)
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true)
    }
    
    func didTappedMediaShareButton() {
        let asset = willConvertMedia[0] as! AVURLAsset
        
        var shareObject = [Any]()
        shareObject.append(asset.url)
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
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
