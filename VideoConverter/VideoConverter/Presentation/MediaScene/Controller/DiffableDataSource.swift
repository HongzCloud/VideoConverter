//
//  DiffableDataSource.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/13.
//

import UIKit
import AVFoundation

final class DiffableDataSource: UITableViewDiffableDataSource<Section, WillConvertListItemViewModel> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
