import XCTest
@testable import swift_cache_manager

struct User : Codable, Equatable {
  let id : Int
  let name : String
}

struct PropertyTester {
  @Cache var user : User
}

final class swift_cache_managerTests: XCTestCase {
  override class func tearDown() {
    let cacheManager = CacheManager<User>()
    if let cacheDirectoryURL = cacheManager?.cacheDirectoryURL {
      do {
        try cacheManager?.fileManager.removeItem(at: cacheDirectoryURL)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func testSimpleTest_SaveAndLoad() {
    let cacheManager = CacheManager<User>()
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    let otherUser = cacheManager?.load(userID)
    
    assert(user == otherUser, "\(user) should equal to \(otherUser!)")
  }
  
  func testSimpleTest_SaveAndLoadAll() {
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
  
  func testPurge_date() {
    let cacheManager = CacheManager<User>(cacheLimit: .date(2))
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    do {
      try cacheManager?.purgeCache()
    } catch {
      print(error)
    }
    let otherUser = cacheManager?.load(userID)
    assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
  }
  
  func testPurge_date_noDelete() {
    let cacheManager = CacheManager<User>(cacheLimit: .date(3600))
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    sleep(3)
    do {
      try cacheManager?.purgeCache()
    } catch {
      print(error)
    }
    let otherUser = cacheManager?.load(userID)
    assert(otherUser != nil, "otherUser should not be nil")
  }
  
  func testPurge_size() {
    let cacheManager = CacheManager<User>(cacheLimit: .size(30))
    
    let firstUser = User(id: #line, name: "Malotru")
    let firstUserID = "\(firstUser.id)"
    cacheManager?.save(firstUser, firstUserID)
    
    let secondUser = User(id: #line, name: "Malotru")
    let secondUserID = "\(secondUser.id)"
    cacheManager?.save(secondUser, secondUserID)
    
    do {
      try cacheManager?.purgeCache()
    } catch {
      print(error)
    }
    
    let otherUser = cacheManager?.load(firstUserID)
    let otherUser2 = cacheManager?.load(secondUserID)
    assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
    assert(secondUser == otherUser2, "\(secondUser) should equal to \(otherUser2!)")
  }
    
  func testPurge_none() {
    let cacheManager = CacheManager<User>(cacheLimit: .none)
    let user = User(id: #line, name: "Malotru")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    let otherUser = cacheManager?.load(userID)
    sleep(3)
    do {
      try cacheManager?.purgeCache()
    } catch {
      print(error)
    }
    assert(otherUser == user)
  }
    
  static var allTests = [
    ("testSimpleTest_SaveAndLoad", testSimpleTest_SaveAndLoad),
    ("testSimpleTest_SaveAndLoadAll", testSimpleTest_SaveAndLoadAll),
    ("testPurge_date", testPurge_date),
    ("testPurge_date_noDelete", testPurge_date_noDelete),
    ("testPurge_size", testPurge_size),
    ("testPurge_none", testPurge_none),
  ]
}
