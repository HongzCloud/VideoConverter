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
    var videoSaveToast: UIView!
    private var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.willConvertTableView.delegate = self
        self.willConvertTableView.dataSource = self
        self.willConvertTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        self.headerView.delegate = self
        self.convertView.delegate = self

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
    
    private func editFileNameAlert(oldName: String, completion: @escaping (_ newName: String) -> Void) {
        let alert = UIAlertController(title: "파일명 수정", message: "파일명을 입력하세요.(확장자 제외)", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            let text = alert.textFields?.first?.text
            if let text = text {
                completion(text)
            }
        }

        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in
        }

        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField { [self] textField in
            textField.text = oldName
            textField.addTarget(self, action: #selector(alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        self.present(alert, animated: true, completion: nil)
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
        convertView.configure(currentFormat: file.url.pathExtension, index: indexPath.row)
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
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController else {
            return
        }
        
        svc.delegate = self
      
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
        self.view.makeToastActivity(.center)
        let asset = willConvertMedia[0] as! AVURLAsset
        
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

extension WillConvertViewController: ConvertViewDelegate {
    func didTappedConvertButton(_ convertView: ConvertView) {
        let asset = willConvertMedia[convertView.index] as! AVURLAsset
        let pathExtensionIndex = self.convertView.didConvertedExtensionNamePickerView.selectedRow(inComponent: 0)
        let pathExtension = pickerViewData[pathExtensionIndex]
        let inputName = asset.url.deletingPathExtension().lastPathComponent
        let outputStr = inputName + "." + pathExtension
        let output = FileHelper().createFileURL(outputStr, in: .didConverted)
        let fileFormats = FileFormat.allCases
        convertView.startConvertAnimation()
        
        convert(asset: asset, output: output, fileFormat: fileFormats[pathExtensionIndex], completion: {
            DispatchQueue.main.async {
                self.willConvertTableView.reloadData()
                convertView.endConvertAnimation()
                
                var style = ToastStyle()
                style.messageColor = .mint!
                self.view.makeToast("변환 완료",
                                    duration: 2,
                                    point: CGPoint(x: self.view.center.x, y: self.view.center.y * 3/2),
                                    title: nil,
                                    image: nil,
                                    style: style,
                                    completion: nil)
            }
        })
    }
    
    func convert(asset: AVAsset, output: URL, fileFormat: FileFormat, completion: @escaping () -> Void) {

        switch fileFormat {
        case .wav:
            asset.writeAudio(output: output,
                             format: fileFormat,
                             sampleRate: .m44k,
                             bitRate: nil,
                             bitDepth: .m32,
                             completion: completion)
        case .mp3:
            asset.writeAudio(output: output,
                             format: fileFormat,
                             sampleRate: .m44k,
                             bitRate: .m192k,
                             bitDepth: nil,
                             completion: completion)
        case .m4a:
            asset.writeAudio(output: output,
                             format: fileFormat,
                             sampleRate: .m44k,
                             bitRate: .m192k,
                             bitDepth: nil,
                             completion: completion)
        case .caf:
            asset.writeAudio(output: output,
                             format: fileFormat,
                             sampleRate: .m44k,
                             bitRate: .m192k,
                             bitDepth: nil,
                             completion: completion)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            do {
                //삭제하기
                let asset = self.willConvertMedia[indexPath.row] as! AVURLAsset
                try FileManager.default.removeItem(at: asset.url)
                self.willConvertMedia.remove(at: indexPath.row)
                
            } catch let e {
                //에러처리
                print(e.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        let fileNameEditAction = UIContextualAction(style: .normal, title: nil) { [self] (action, view, completion) in
            
            //수정하기
            let asset = self.willConvertMedia[indexPath.row] as! AVURLAsset
            editFileNameAlert(oldName: asset.url.deletingPathExtension().lastPathComponent, completion: { newName in
                
                let newFileName = newName + "." + asset.url.pathExtension
                let newPath = asset.url.deletingLastPathComponent().appendingPathComponent(newFileName)
                willConvertMedia[indexPath.row] = AVAsset(url: newPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                do {
                    try FileManager.default.moveItem(at: asset.url, to: newPath)
                } catch let e {
                    //에러처리
                    print(e.localizedDescription)
                }
            })

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

extension WillConvertViewController: VideoSaveCompletionDelegate {
    func startSave() {
        var style = ToastStyle()
        style.messageColor = .mint!
       
        self.videoSaveToast = try? self.view.toastViewForMessage("비디오 가져오는 중", title: nil, image: nil, style: style)
        
        if let toast = self.videoSaveToast {
            self.view.showToast(toast, point: CGPoint(x: self.view.center.x, y: self.view.center.y/3))
        }
    }
    
    func endSave() {
        self.view.hideToast(self.videoSaveToast)
        if let files = getFiles(.willConvert) {
            willConvertMedia = files
            self.willConvertTableView.reloadData()
        }
    }
}
