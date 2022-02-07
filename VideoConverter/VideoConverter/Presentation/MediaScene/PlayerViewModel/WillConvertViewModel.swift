//
//  WillConvertViewModel.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/02/06.
//

import Foundation
import AVFoundation

protocol WillConvertViewModelInput {
    func loadWillConvertMediaList()
    func removeMedia(at index: Int, completion: (Bool) -> Void)
    func editMedia(at index: Int, name: String, completion: (Bool) -> Void)
    func appendMedia(url: URL)
}

protocol WillConvertViewModelOutput {
    var items: [WillConvertListItemViewModel] { get }
}

protocol WillConvertViewModel: WillConvertViewModelInput, WillConvertViewModelOutput { }

final class DefaultWillConvertViewModel: WillConvertViewModel {
    
    private let fetchMediaUseCase: FetchMediaUseCase
    
    // MARK: - OUTPUT
    
    var items: [WillConvertListItemViewModel] = []
    
    // MARK: - Init
    
    init(fetchMediaUseCase: FetchMediaUseCase) {
        self.fetchMediaUseCase = fetchMediaUseCase
        loadWillConvertMediaList()
    }
}

// MARK: - INPUT. View event methods

extension DefaultWillConvertViewModel {

    func loadWillConvertMediaList() {
        
        if !items.isEmpty { items.removeAll() }
        
        self.fetchMediaUseCase.execute(requestValue: .init(directory: .willConvert)) { [self] (result: Result<[Media], Error>) in
            switch result {
            case .success(let mediaList):
                var tempItems = [WillConvertListItemViewModel]()
                
                mediaList.forEach { media in
                    tempItems.append(WillConvertListItemViewModel(title: media.metadata.title, url: media.metadata.assetURL))
                }
                items = tempItems
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func removeMedia(at index: Int, completion: (Bool) -> Void) {
        do {
            try FileManager.default.removeItem(at: items[index].url)
            self.items.remove(at: index)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func editMedia(at index: Int, name: String, completion: (Bool) -> Void) {
        let asset = AVURLAsset(url: items[index].url)
        let dicURL = Directory.willConvert.rawValue
        let pathExtension = asset.url.pathExtension
        let newURL = dicURL.appendingPathComponent(name).appendingPathExtension(pathExtension)
 
        do {
            try FileManager.default.moveItem(at: asset.url, to: newURL)
            items[index].url = newURL
            items[index].title = newURL.lastPathComponent
            
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func appendMedia(url: URL) {
        items.append(.init(title: url.lastPathComponent, url: url))
    }
}

struct WillConvertListItemViewModel: Hashable {
    var title: String
    var url: URL
}
