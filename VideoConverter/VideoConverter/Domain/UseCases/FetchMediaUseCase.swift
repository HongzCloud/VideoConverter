//
//  FetchMediaUseCase.swift
//  VideoConverter
//
//  Created by 오킹 on 2022/01/10.
//

import Foundation

protocol FetchMediaUseCase {
    func execute(requestValue: FetchMediaUseCaseRequestValue,
                 completion: @escaping (Result<[Media], Error>) -> Void)
}

final class DefaultFetchMediaUseCase: FetchMediaUseCase {

    private let mediaRepository: MediaRepository

    init(mediaRepository: MediaRepository) {
        self.mediaRepository = mediaRepository
    }

    func execute(requestValue: FetchMediaUseCaseRequestValue, completion: @escaping (Result<[Media], Error>) -> Void) {
        mediaRepository.fetchMediaList(directory: requestValue.directory, completion: completion)
    }
}

struct FetchMediaUseCaseRequestValue {
    private(set) var directory: Directory
}
