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

    @IBOutlet weak var willConvertTableView: UITableView!
    private var convertView: ConvertView!
    private var headerView: HeaderView!
    private var pickerViewData: [FileFormat]!
    private var selectedCellIndex: IndexPath?
    private var videoSaveToast: UIView!
    private var alert: UIAlertController?
    private var dataSource: WillConvertDiffableDataSource!
    private var isConverting: Bool = false

    private var coordinator: WillConvertCoordinator?
    private var viewModel: WillConvertViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerViewData = FileFormat.allCases.map{ $0 }
        setHeaderView()
        setConvertView()
        setTableView()
        configureDataSource()
        addObserverForForground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.changeStateOfConvertButton()
    }

    static func create(with viewModel: WillConvertViewModel) -> WillConvertViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WillConvertViewController") as? WillConvertViewController else {
            return WillConvertViewController()
        }
        vc.viewModel = viewModel
        return vc
    }

    func coordinate(to coordinator: WillConvertCoordinator) {
        self.coordinator = coordinator
    }

    private func setHeaderView() {
        self.headerView = HeaderView()
        self.headerView.delegate = self
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.configure(title: "비디오 목록".localized(), photoLibraryButtonIsHidden: false)
        
        self.view.addSubview(headerView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/13)
        ])
    }
    
    private func setConvertView() {
        self.convertView = ConvertView()
        self.convertView.delegate = self
        self.convertView.isHidden = true
        self.convertView.translatesAutoresizingMaskIntoConstraints = false
        self.convertView.didConvertedExtensionNamePickerView.delegate = self
        self.convertView.didConvertedExtensionNamePickerView.dataSource = self
        
        self.view.addSubview(convertView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.convertView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.convertView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.convertView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.convertView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/10)
        ])
    }
    
    private func setTableView() {
        self.willConvertTableView.delegate = self
        self.willConvertTableView.register(WillConvertTableViewCell.self, forCellReuseIdentifier: "WillConvertTableViewCell")
        
        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh(_:)), for: .valueChanged)
        self.willConvertTableView.refreshControl = refreshControl
        
        let safeArea = self.view.safeAreaLayoutGuide
        self.willConvertTableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.willConvertTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.willConvertTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.willConvertTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.willConvertTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func refresh(_ control: UIRefreshControl) {
        self.willConvertTableView.alpha = 0.5
        self.viewModel.loadWillConvertMediaList()
        self.makeAndApplySnapShot(isAnimatable: false)
        control.endRefreshing()
        UIView.animate(withDuration: 1, animations: {
            self.willConvertTableView.alpha = 1
        }, completion: nil)
    }
    
    private func addObserverForForground() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(changeStateOfConvertButton), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(changeStateOfConvertButton), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }

    @objc func changeStateOfConvertButton() {
        if isConverting {
            self.convertView.deactivateConvertButton()
            self.convertView.startConvertAnimation()
        } else {
            self.convertView.activateConvertButton()
            self.convertView.endConvertAnimation()
        }
    }
    
    private func editFileNameAlert(oldName: String, completion: @escaping (_ newName: String) -> Void) {
        alert = UIAlertController(title: "파일명 수정".localized(),
                                  message: "파일명을 입력하세요.\n(영어, 한글, 숫자, -, _) 1~20글자".localized(),
                                  preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] (ok) in
            let text = self?.alert!.textFields?.first?.text
            if let text = text {
                completion(text)
            }
        }

        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        self.alert!.addAction(cancel)
        self.alert!.addAction(ok)
        self.alert!.addTextField { [weak self] textField in
            textField.text = oldName
            textField.addTarget(self, action: #selector(self?.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        self.present(self.alert!, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        self.alert?.actions[1].isEnabled = isValidFileName(sender.text!)
    }
    
    private func isValidFileName(_ name: String) -> Bool {
        
        // 영어 소문자,대문자,한글,숫자 1~20자리
        let pattern = "^[A-Za-z0-9가-힣_-]{1,20}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.count)) {
            return true
        }
        
        return false
    }
    
    private func makeAndApplySnapShot(isAnimatable: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WillConvertListItemViewModel>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items)

        self.dataSource.apply(snapshot, animatingDifferences: isAnimatable, completion: nil)
    }
    
    private func configureDataSource() {
        dataSource = WillConvertDiffableDataSource(tableView: willConvertTableView, cellProvider: { tableView, indexPath, media in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WillConvertTableViewCell") as? WillConvertTableViewCell else { return UITableViewCell() }
            
            let asset = AVAsset(url: media.url)
            
            asset.generateThumbnail(completion: { thumnailImage in
                DispatchQueue.main.async {
                    cell.configure(image: thumnailImage, name: media.url.lastPathComponent, duration: asset.duration.durationText)
                }
            })
            cell.setPlayButtonDelegate(self)
            cell.setMediaViewIndex(indexPath.row)
            
            return cell
        })
        
        self.willConvertTableView.dataSource = dataSource
        self.makeAndApplySnapShot(isAnimatable: false)
    }
    
    func addVideo(_ asset: AVAsset) {
        let asset = asset as! AVURLAsset
        self.viewModel.appendMedia(url: asset.url)
        self.makeAndApplySnapShot(isAnimatable: true)
    }
}

extension WillConvertViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat {
        return tableView.frame.height / 10
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.viewModel.items[indexPath.row]
        self.selectedCellIndex = indexPath
        
        DispatchQueue.main.async {
            self.convertView.isHidden = false
            self.convertView.configure(currentFormat: item.url.pathExtension, index: indexPath.row)
        }
        
        if !self.headerView.isHidden {
            willConvertTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.convertView.frame.height, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self]
            (action, view, completion) in
            
            // 삭제하기
            
            self?.viewModel.removeMedia(at: indexPath.row, completion: {
                result in
                if result {
                    self?.makeAndApplySnapShot(isAnimatable: true)
                    completion(true)
                } else {
                    let alert = UIAlertController(title: "파일 삭제".localized(),
                                                  message: "파일을 삭제할 수 없습니다.".localized(),
                                                  preferredStyle: .alert)

                    let ok = UIAlertAction(title: "OK", style: .default)
                    
                    alert.addAction(ok)
                    self?.present(alert, animated: true, completion: nil)
                }
            })
        }
        
        let fileNameEditAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completion) in

            // 수정하기
            
            guard let oldName = self?.viewModel.items[indexPath.row].title else { return }

            self?.editFileNameAlert(oldName: oldName.precomposedStringWithCanonicalMapping, completion: { newName in
                self?.viewModel.editMedia(at: indexPath.row, name: newName, completion: {
                    result in
                    
                    if result {
                        self?.makeAndApplySnapShot(isAnimatable: true)
                        completion(true)
                    } else {
                        let alert = UIAlertController(title: "파일명 수정".localized(),
                                                      message: "파일명 변경 실패".localized(),
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        
                        alert.addAction(ok)
                        self?.present(alert, animated: true, completion: nil)
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

extension WillConvertViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row].text
    }
}

extension WillConvertViewController: CustomHeaderViewDelegate {

    func didTappedPhotoLibraryButton() {
        coordinator?.presentVideoListViewController()
    }
}

extension WillConvertViewController: MediaViewDelegate {
    
    func didTappedPlayButton(selectedIndex: Int) {

        let asset = AVURLAsset(url: self.viewModel.items[selectedIndex].url)

        if asset.isPlayable {
            //coordinator?.presentPlayerViewController(assetManager: assetManager, tappedIndex: selectedIndex)
        } else {
            var style = ToastStyle()
            style.messageColor = .greenAndMint!
            
            self.view.makeToast("재생할 수 없는 파일입니다".localized(),
                                duration: 2,
                                point: CGPoint(x: self.view.center.x, y: self.view.center.y * 3/2),
                                title: nil,
                                image: nil,
                                style: style,
                                completion: nil)
        }
    }
    
    func didTappedMediaShareButton(selectedIndex: Int) {
        let url = self.viewModel.items[selectedIndex].url
        
        DispatchQueue.main.async { [weak self] in
            self?.coordinator?.presentShareViewController(url: url)
        }
    }
}

extension WillConvertViewController: ConvertViewDelegate {
    func didTappedConvertButton(_ convertView: ConvertView) {
        self.isConverting = true
        
        let asset = AVURLAsset(url: self.viewModel.items[convertView.index].url)
        
        let pathExtensionIndex = self.convertView.didConvertedExtensionNamePickerView.selectedRow(inComponent: 0)
        let newFormat = pickerViewData[pathExtensionIndex]
        let inputName = asset.url.deletingPathExtension().lastPathComponent
        let outputStr = inputName + "." + newFormat.text
        let output = FileHelper.shared.createFileURL(outputStr, in: .didConverted)
        
        convertView.startConvertAnimation()
        
        asset.writeAudio(output: output, format: newFormat, sampleRate: .m44k, bitRate: .m320k, bitDepth: .m16, completion: { result in
            DispatchQueue.main.async {
                var style = ToastStyle()
                style.messageColor = .greenAndMint!
                let point = CGPoint(x: self.view.center.x, y: self.view.center.y * 3/2)
                
                if result {
                    let  topVC = UIApplication.getTopMostViewController()
                    
                    topVC?.view.makeToast("변환 완료".localized(),
                                        duration: 2,
                                        point: point,
                                        title: nil,
                                        image: nil,
                                        style: style,
                                        completion: nil)
                } else {
                    self.view.makeToast("변환이 불가능한 파일입니다.".localized(),
                                        duration: 2,
                                        point: point,
                                        title: nil,
                                        image: nil,
                                        style: style,
                                        completion: nil)
                }
                
                self.isConverting = false
                convertView.endConvertAnimation()
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "aVideoConverted"), object: self))
            }
        })
    }
}

enum Section {
    case main
}
