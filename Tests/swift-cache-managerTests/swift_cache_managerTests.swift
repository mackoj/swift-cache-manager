import XCTest
@testable import swift_cache_manager

struct User : Codable, Equatable {
  let id : Int
  let name : String
}

final class swift_cache_managerTests: XCTestCase {
  
  func test_1_save_then_load() {
    let cacheManager = CacheManager<User>()
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    let otherUser = cacheManager?.load(userID)
    
    assert(user == otherUser, "\(user) should equal to \(otherUser!)")
    cacheManager?.removeAllFileFromCache()
  }
  
  func test_2_save_then_loadAll() {
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
    cacheManager?.removeAllFileFromCache()
  }
  
  func test_3_purge_secondsAfterCreationDate() {
    let cacheManager = CacheManager<User>(cacheLimit: [.secondsAfterCreationDate(2)])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    let otherUser = cacheManager?.load(userID)
    assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
    cacheManager?.removeAllFileFromCache()
  }
  
  func test_4_purge_secondsAfterCreationDate_with_expiration() {
    let cacheManager = CacheManager<User>(cacheLimit: [.secondsAfterCreationDate(3600)])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    let otherUser = cacheManager?.load(userID)
    assert(otherUser != nil, "otherUser should not be nil")
    cacheManager?.removeAllFileFromCache()
  }
  
  func test_5_purge_size() {
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
    cacheManager?.removeAllFileFromCache()
  }
  
  func test_6_purge_should_not_purge_data() {
    let cacheManager = CacheManager<User>(cacheLimit: [])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    let otherUser = cacheManager?.load(userID)
    assert(otherUser == user)
    cacheManager?.removeAllFileFromCache()
  }
  
  func test_7_removeAllFileFromCache() {
    let cacheManager = CacheManager<User>(cacheLimit: [])
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    cacheManager?.removeAllFileFromCache()
    let otherUser = cacheManager?.load(userID)
    assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
  }
  
  
  static var allTests = [
    ("test_1_save_then_load", test_1_save_then_load),
    ("test_2_save_then_loadAll", test_2_save_then_loadAll),
    ("test_3_purge_secondsAfterCreationDate", test_3_purge_secondsAfterCreationDate),
    ("test_4_purge_secondsAfterCreationDate_with_expiration", test_4_purge_secondsAfterCreationDate_with_expiration),
    ("test_5_purge_size", test_5_purge_size),
    ("test_6_purge_should_not_purge_data", test_6_purge_should_not_purge_data),
    ("test_7_removeAllFileFromCache", test_7_removeAllFileFromCache),
  ]
}
