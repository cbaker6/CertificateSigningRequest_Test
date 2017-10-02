//
//  CertificateSigningRequestSwift_Test.swift
//  CertificateSigningRequestSwift_Test
//
//  Created by Corey Baker on 9/27/17.
//  Copyright © 2017 Corey Baker. All rights reserved.
//

import Foundation
import CertificateSigningRequestSwift


class TestCSR {
    
    private var publicKey: SecKey?
    private var privateKey: SecKey?
    private var keyBlockSize: Int?
    private var publicKeyBits: Data?
    
    let tagPublic = "com.csr.public"
    let tagPrivate = "com.csr.private"
    let keyAlgorithm = KeyAlgorithm.ec(signatureType: .sha256)
    
    func start(){
        
        if (self.publicKey == nil) && (self.privateKey == nil) && self.keyBlockSize == nil {
            
            let publicKeyParameters: [String: AnyObject] = [
                String(kSecAttrIsPermanent): kCFBooleanTrue,
                String(kSecAttrApplicationTag): tagPublic as AnyObject,
                String(kSecAttrAccessible): kSecAttrAccessibleAlways
            ]
            
            let privateKeyParameters: [String: AnyObject] = [
                String(kSecAttrIsPermanent): kCFBooleanTrue,
                String(kSecAttrApplicationTag): tagPrivate as AnyObject,
                String(kSecAttrAccessible): kSecAttrAccessibleAlways
            ]
            
            //Define what type of keys to be generated here
            let parameters: [String: AnyObject] = [
                String(kSecAttrKeyType): keyAlgorithm.secKeyAttrType,
                String(kSecAttrKeySizeInBits): keyAlgorithm.availableKeySizes.last! as AnyObject,
                String(kSecReturnRef): kCFBooleanTrue,
                kSecPublicKeyAttrs as String: publicKeyParameters as AnyObject,
                kSecPrivateKeyAttrs as String: privateKeyParameters as AnyObject,
            ]
            
            //Use Apple Security Framework to generate keys, save them to application keychain
            var error: Unmanaged<CFError>?
            self.privateKey = SecKeyCreateRandomKey(parameters as CFDictionary, &error)
            
            if self.privateKey == nil{
                print("Error creating keys occured: \(error!.takeRetainedValue() as Error), keys weren't created")
                return
            }
            
            //Get generated public key
            let query: [String: AnyObject] = [
                String(kSecClass): kSecClassKey,
                String(kSecAttrKeyType): keyAlgorithm.secKeyAttrType,
                String(kSecAttrApplicationTag): tagPublic as AnyObject,
                String(kSecReturnRef): kCFBooleanTrue
            ]
            
            var publicKeyReturn:AnyObject?
            
            let result = SecItemCopyMatching(query as CFDictionary, &publicKeyReturn)
            
            if result != errSecSuccess{
                print("Error getting publicKey fron keychain occured: \(result)")
                return
            }
            
            self.publicKey = publicKeyReturn as! SecKey?
        }
        
        //Set block size
        self.keyBlockSize = SecKeyGetBlockSize(self.publicKey!)
        
        //Ask keychain to provide the publicKey in bits
        let query: [String: AnyObject] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrKeyType): keyAlgorithm.secKeyAttrType,
            String(kSecAttrApplicationTag): tagPublic as AnyObject,
            String(kSecReturnData): kCFBooleanTrue
        ]
        
        var tempPublicKeyBits:AnyObject?
        
        _ = SecItemCopyMatching(query as CFDictionary, &tempPublicKeyBits)
        
        guard let keyBits = tempPublicKeyBits as? Data else {
            return
        }
        
        publicKeyBits = keyBits
        
        //Initiale CSR
        let csr = CertificateSigningRequest(commonName: "CertificateSigningRequestSwift Test", organizationName:"Test", organizationUnitName:"Test", countryName:"US", keyAlgorithm: keyAlgorithm)
        
        //Build the CSR
        guard let csrBuild = csr.buildAndEncodeDataAsString(publicKeyBits!, privateKey: privateKey!) else {
            return
        }
        
        print("CSR string no header and footer")
        print(csrBuild)
        
        guard let csrBuild2 = csr.buildCSRAndReturnString(publicKeyBits!, privateKey: privateKey!) else {
            return
        }
        
        print("CSR string with header and footer")
        print(csrBuild2)
    }
    
}

