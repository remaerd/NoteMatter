//
//  Security.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 17/11/2017.
//

import Keys
import CommonCrypto
import KeychainAccess
import Foundation

public class SecurityManager
{
	enum Exception: Error
	{
		case missingData
		case invalidPassword
		case invalidMasterKey
		case passwordRequired
		case cannotResetPassword
		case masterKeyNotFound
		case ivNotFound
		case cannotSaveMasterKeyWithAppleAuth
	}
	
	static let shared = SecurityManager()
	static let serviceIdentifier = "com.zhengxingzhi.gigi"
	
	var masterKey: SymmetricKey?
	
	func unlock(password: String) throws
	{
		let keychain = Keychain(service: SecurityManager.serviceIdentifier)
		guard let salt = try keychain.getData("salt") else { throw Exception.missingData }
		guard let round = try keychain.get("round") else { throw Exception.missingData }
		guard let iv = try keychain.getData("iv") else { throw Exception.missingData }
		guard let key = try keychain.getData("key") else { throw Exception.missingData }
		var password = try Password(password: password, salt: salt, roundCount: Int(round))
		masterKey = try password.decrypt(key, IV: iv)
	}
	
	func lock()
	{
		masterKey = nil
	}
	
	func reset(newPassword: String, oldPassword: String?) throws
	{
		let keychain = Keychain(service: SecurityManager.serviceIdentifier)
		
		func reset() throws
		{
			let key = SymmetricKey()
			var password = try Password(password: newPassword)
			let encryptedKey = try password.encrypt(key)
			try keychain.set(encryptedKey.key, key: "key")
			try keychain.set(encryptedKey.IV, key: "iv")
			try keychain.set(String(password.rounds), key: "round")
			try keychain.set(password.salt, key: "salt")
		}
		
		let salt = try keychain.getData("salt")
		let round = try keychain.get("round")
		let iv = try keychain.getData("iv")
		let key = try keychain.getData("key")
		
		if let password = oldPassword, let salt = salt, let round = round, let key = key, let iv = iv
		{
			var password = try Password(password: password, salt: salt, roundCount: Int(round))
			_ = try password.decrypt(key, IV: iv)
			try reset()
		}
		else if oldPassword == nil && salt == nil && round == nil && iv == nil && key == nil { try reset() }
		throw Exception.passwordRequired
	}
}

extension SecurityManager
{
	func enableBiometricAuthentication(completion: @escaping (Bool, Error?) -> Void)
	{
		guard let masterKey = masterKey else { completion(false, Exception.masterKeyNotFound); return  }
		guard let hmacKey = masterKey.hmacKey else { completion(false, Exception.invalidMasterKey); return }
		var data = masterKey.cryptoKey
		data.append(hmacKey)
		do
		{
			let keychain = Keychain(service: SecurityManager.serviceIdentifier)
			try keychain.accessibility(.whenUnlockedThisDeviceOnly, authenticationPolicy: .userPresence).set(data, key: "masterKey")
			completion(true, nil)
		}
		catch { completion(false, Exception.masterKeyNotFound) }
	}
	
	func unlockWithBiometricAuthentication(completion: @escaping (Bool, Error?) -> Void)
	{
		let keychain = Keychain(service: SecurityManager.serviceIdentifier)
		DispatchQueue.global().async
		{
			do
			{
				guard let masterKey = try keychain.accessibility(.whenUnlockedThisDeviceOnly, authenticationPolicy: .userPresence).getData("masterKey")
				else { completion(false, Exception.masterKeyNotFound); return }
				guard let iv = try keychain.getData("iv")
				else { completion(false, Exception.ivNotFound); return }
				self.masterKey = try SymmetricKey(key: masterKey, IV: iv)
			}
			catch { completion(false, Exception.missingData) }
		}
	}
}
