import XCTest
@testable import swift_cache_manager

struct User : Codable, Equatable {
  let id : Int
  let name : String
}

final class swift_cache_managerTests: XCTestCase {
  
  func test_1_SimpleTest_SaveAndLoad() {
    let cacheManager = CacheManager<User>()
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    let otherUser = cacheManager?.load(userID)
    
    assert(user == otherUser, "\(user) should equal to \(otherUser!)")
  }
  
  func test_2_SimpleTest_SaveAndLoadAll() {
    let cacheManager = CacheManager<User>()
    
    let user1 = User(id: #line, name: "Malotru")
    let user2 = User(id: #line, name: "Moule a gauffre")
    let user3 = User(id: #line, name: "Bachibouzouk")
    
    cacheManager?.save(user1, "\(user1.id)")
    cacheManager?.save(user2, "\(user2.id)")
    cacheManager?.save(user3, "\(user3.id)")
    
    let allUser = cacheManager?.loadAll()
    let otherUser1 = allUser?.first { $0.id == user1.id }
    let otherUser2 = allUser?.first { $0.id == user2.id }
    let otherUser3 = allUser?.first { $0.id == user3.id }
    assert(user1 == otherUser1, "\(user1) should equal to \(otherUser1!)")
    assert(user2 == otherUser2, "\(user2) should equal to \(otherUser2!)")
    assert(user3 == otherUser3, "\(user3) should equal to \(otherUser3!)")
  }
  
  func test_3_Purge_date() {
    let cacheManager = CacheManager<User>(cacheLimit: [.secondsAfterCreationDate(2)])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    let otherUser = cacheManager?.load(userID)
    assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
  }
  
  func test_4_Purge_date_noDelete() {
    let cacheManager = CacheManager<User>(cacheLimit: [.secondsAfterCreationDate(3600)])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    let otherUser = cacheManager?.load(userID)
    assert(otherUser != nil, "otherUser should not be nil")
  }
  
  func test_5_Purge_size() {
    let cacheManager = CacheManager<User>(cacheLimit: [.size(30)])
    
    let firstUser = User(id: #line, name: "Malotru")
    let firstUserID = "\(firstUser.id)"
    cacheManager?.save(firstUser, firstUserID)
    
    let secondUser = User(id: #line, name: "Malotru")
    let secondUserID = "\(secondUser.id)"
    cacheManager?.save(secondUser, secondUserID)
    
    let otherUser = cacheManager?.load(firstUserID)
    let otherUser2 = cacheManager?.load(secondUserID)
    assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
    assert(secondUser == otherUser2, "\(secondUser) should equal to \(otherUser2!)")
  }
  
  func test_6_Purge_none() {
    let cacheManager = CacheManager<User>(cacheLimit: [])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    let otherUser = cacheManager?.load(userID)
    assert(otherUser == user)
  }
  
  func test_7_Purge_all() {
    let cacheManager = CacheManager<User>(cacheLimit: [])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    cacheManager?.removeAllFileFromCache()
    let otherUser = cacheManager?.load(userID)
    assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
  }
  
  
  static var allTests = [
    ("test_1_SimpleTest_SaveAndLoad", test_1_SimpleTest_SaveAndLoad),
    ("test_2_SimpleTest_SaveAndLoadAll", test_2_SimpleTest_SaveAndLoadAll),
    ("test_3_Purge_date", test_3_Purge_date),
    ("test_4_Purge_date_noDelete", test_4_Purge_date_noDelete),
    ("test_5_Purge_size", test_5_Purge_size),
    ("test_6_Purge_none", test_6_Purge_none),
    ("test_7_Purge_all", test_7_Purge_all),
  ]
}
