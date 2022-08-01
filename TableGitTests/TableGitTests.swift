//
//  TableGitTests.swift
//  TableGitTests
//
//  Created by MINERVA on 01/08/2022.
//

import XCTest
@testable import TableGit

class TableGitTests: XCTestCase {
    //MARK: Properties
    var secureStoreWithGenericPwd: KeychainManager!
    
    //MARK: Override
    override func setUp() {
        super.setUp()
        
        let genericQuery = GenericPasswordQuery(service: "someService")
        
        secureStoreWithGenericPwd = KeychainManager(keychainQuery: genericQuery)
        
    }
    
    override func tearDown() {
        
        try? secureStoreWithGenericPwd.removeAllValues()
        
        super.tearDown()
    }
    
    func testSaveGenericPassword() {
        
        do {
            try secureStoreWithGenericPwd.addPasswordToKeychains(key: .JWT, password: "genericPassword")
            
        } catch (let e) {
            XCTFail("Saving generic password failed with \(e.localizedDescription).")
        }
        
    }
    
    func testReadGenericPassword() {
        
        do {
            try secureStoreWithGenericPwd.addPasswordToKeychains(key: .JWT, password: "genericPassword")
            let password = try secureStoreWithGenericPwd.findPasswordInKeychains(key: .JWT)
            XCTAssertEqual("genericPassword", password)
            
        } catch (let e) {
            XCTFail("Reading generic password failed with \(e.localizedDescription).")
        }
        
    }
    
    func testUpdateGenericPassword() {
        
        do {
            try secureStoreWithGenericPwd.addPasswordToKeychains(key: .JWT, password: "pwd_1234")
            try secureStoreWithGenericPwd.addPasswordToKeychains(key: .JWT, password: "pwd_1235")
            let password = try secureStoreWithGenericPwd.findPasswordInKeychains(key: .JWT)
            XCTAssertEqual("pwd_1235", password)
            
        } catch (let e) {
            XCTFail("Updating generic password failed with \(e.localizedDescription).")
        }
        
    }
    
    func testRemoveGenericPassword() {
        
        do {
            try secureStoreWithGenericPwd.addPasswordToKeychains(key: .JWT, password: "pwd_1234")
            try secureStoreWithGenericPwd.deleteKeychain(key: .JWT)
            XCTAssertNil(try secureStoreWithGenericPwd.findPasswordInKeychains(key: .JWT))
            
        } catch (let e) {
            XCTFail("Saving generic password failed with \(e.localizedDescription).")
        }
        
    }
    
    func testRemoveAllGenericPasswords() {
        
        do {
            try secureStoreWithGenericPwd.addPasswordToKeychains(key: .JWT, password: "pwd_1234")
            try secureStoreWithGenericPwd.addPasswordToKeychains(key: .TokenSeed, password: "pwd_1235")
            try secureStoreWithGenericPwd.removeAllValues()
            XCTAssertNil(try secureStoreWithGenericPwd.findPasswordInKeychains(key: .JWT))
            XCTAssertNil(try secureStoreWithGenericPwd.findPasswordInKeychains(key: .TokenSeed))

        } catch (let e) {
            XCTFail("Removing generic passwords failed with \(e.localizedDescription).")
        }
        
    }
    
    func testExample() throws {
    }
    
    func testPerformanceExample() throws {
        
        self.measure {}
        
    }
    
}
