//
//  EML.swift
//  EML-Integration
//
//  Created by Irfan Elahi on 22/03/2024.
//

import Foundation
import CryptoSwift
import EMLiOSSDK

class EML {
    
    init() {
        let key = Constants.emlKey.rawValue
        guard let emlEnv = Environment(rawValue: Constants.emlEnv.rawValue) else {
            fatalError("Invalid EML environment")
        }
        let emlAppKey = Constants.emlAppKeyID.rawValue
        let emlAppSecret = Constants.emlAppSecret.rawValue
        
        EMLSDK.shared.configure(
            subscriptionKey: key,
            environment: emlEnv.emlEnv,
            debug: true,
            applicationKeyId: emlAppKey,
            applicationKeySecret: emlAppSecret
        )
    }
    
    static func setAuthToken(_ token: String?) {
        guard let token = token else {
            return
        }
        
        EMLSDK.shared.setAuthenticationToken(token: token, username: "user_name") {
            print("Auth token set")
        }
    }
    
    static func isCardAdded(_ cardEAID: String, _ status: ((CardStatus) -> Void)?) {
        let companyID = Constants.emlCompanyID.rawValue
        let request = EMLGetWalletStatusRequest(
            card: EMLCardModel(
                externalAccountId: cardEAID,
                companyId: companyID,
                mdesConfigId: nil
            )
        )
        
        EMLSDK.shared.getWalletStatus(request: request) { response in
            status?(CardStatus(response: response))
        } onError: { error in
            print(error.localizedDescription)
        }
    }
    
    func showCardDetails() {
        let companyID = Constants.emlCompanyID.rawValue
        let cardmodel = EMLCardModel(
            externalAccountId: "card_external_account_id",
            companyId: companyID,
            mdesConfigId: nil
        )
        let options = EMLCardDisplayEntity(
            cardImage: nil,
            cardImageURL: nil,
            accentColor: .black,
            cardForegroundTextColor: .white
        )
        let request = EMLShowCardNotPresentDetailsRequest(
            card: cardmodel,
            displayOptions: options
        )
        EMLSDK.shared.showCardNotPresentDetails(request: request)
    }
    
    func addCard(status: ((CardStatus) -> Void)?, failure: ((Error) -> Void)?) {
        let companyID = Constants.emlCompanyID.rawValue
        let cardmodel = EMLCardModel(
            externalAccountId: "card_external_account_id",
            companyId: companyID,
            mdesConfigId: nil
        )
        let addCardRequest = EMLAddToWalletRequest(
            card: cardmodel,
            cardName: "Card"
        )
        EMLSDK.shared.addCardToWallet(request: addCardRequest) { response in
            status?(CardStatus(response: response))
        } onError: { error in
            failure?(error)
        }
    }
}

extension EML {
    
    enum Environment: String {
        case beta
        case preProd = "preProduction"
        case prod = "production"
        
        var emlEnv: EMLSDKEnvironment {
            switch self {
            case .beta:
                return .beta
            case .preProd:
                return .preProd
            case .prod:
                return .prod
            }
        }
    }
    
    enum CardStatus {
        case unavailable
        case available
        case cancelled
        case cardInWallet
        
        init(response: EMLWalletStatus) {
            switch response {
            case .unavailable:
                self = .unavailable
            case .available:
                self = .available
            case .cancelled:
                self = .cancelled
            case .added:
                self = .cardInWallet
            @unknown default:
                self = .unavailable
            }
        }
    }
}

