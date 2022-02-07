//
//  DiffableDataSource.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/13.
//

import UIKit
import AVFoundation

final class WillConvertDiffableDataSource: UITableViewDiffableDataSource<Section, WillConvertListItemViewModel> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

final class DidConvertedDiffableDataSource: UITableViewDiffableDataSource<Section, DidConvertedListItemViewModel> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
