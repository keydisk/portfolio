//
//  NFCViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import Foundation
import CoreNFC
import Combine

/// nfc 읽기 테스트
class NFCViewModel: NSObject, ObservableObject {
    
    let readedNfcInfo = PassthroughSubject<Data, Never>()
    let readedNfcInfoError = PassthroughSubject<NSError, Never>()
    
    var nfcSession: NFCNDEFReaderSession!
    
    @Published var readNfcInfo: Data?
    @Published var readNfcInfoText  = ""
    @Published var writeNfcInfoText = ""
    
    override init() {
        
        super.init()
        
        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    }
    
    func beginSession() {
        
        guard NFCNDEFReaderSession.readingAvailable else {
            ToastMessage.shared.setMessage("이 장치는 nfc 스캔을 지원하지 않습니다.")
            return
        }
        
        self.nfcSession.begin()
    }
    
    func stopSession() {
        
        self.nfcSession.invalidate()
    }
    
    func writeNfcData() {
        
    }
}


extension NFCViewModel: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        
        self.readedNfcInfoError.send(error as NSError)
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        // 감지된 NFC 태그 정보 처리
        for message in messages {
            // 태그의 메시지 내용 출력
            guard let tag = message.records.first?.payload else {
                return
            }
            
            self.readedNfcInfo.send(tag)
            self.readNfcInfoText = tag.base64EncodedString()
            break
        }
    }
    
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [any NFCNDEFTag]) {
        
        guard let tag = tags.first else {
            
            session.restartPolling()
            return
        }
        
        session.connect(to: tag, completionHandler: {error in
            guard error == nil else {
                return
            }
            
            tag.queryNDEFStatus(completionHandler: {[weak self] status, capacity, error in
                
                switch status {
                case .notSupported:
                    
                    ToastMessage.shared.setMessage("태그를 쓸 수 없습니다.")
                    break
                case .readOnly:
                    ToastMessage.shared.setMessage("태그를 쓸 수 없습니다.")
                    break
                case .readWrite:
                    
                    guard let msg = self?.writeNfcInfoText.data(using: .utf8), 
                          let len = self?.writeNfcInfoText.count, len > capacity,
                          let nfcMsg = NFCNDEFMessage(data: msg) else {
                        
                        ToastMessage.shared.setMessage("테그 쓰기 실패")
                        return
                    }
                    
                    Task {
                        do {
                            try await tag.writeNDEF(nfcMsg)
                            ToastMessage.shared.setMessage("테그 쓰기 성공")
                        } catch let error {
                            ToastMessage.shared.setMessage("테그 쓰기 실패")
                        }
                    }
                    
                    break
                default:
                    break
                }
            })
        })
        
    }
}
