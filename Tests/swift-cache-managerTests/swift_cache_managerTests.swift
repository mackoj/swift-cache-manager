import XCTest
@testable import swift_cache_manager

struct User : Codable, Equatable {
  let id : Int
  let name : String
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
    let user = User(id: 42, name: "Jeffrey")
    let userID = "\(user.id)"
    
    cacheManager?.save(user, userID)
    let otherUser = cacheManager?.load(userID)
    
    assert(user == otherUser, "\(user) should equal to \(otherUser!)")
  }
  
  func testSimpleTest_SaveAndLoadAll() {
    let cacheManager = CacheManager<User>()
    
    let user1 = User(id: 42, name: "Jeffrey")
    let user2 = User(id: 44, name: "Ayoub")
    let user3 = User(id: 45, name: "Radwan")
    
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
  
  static var allTests = [
    ("testSimpleTest_SaveAndLoad", testSimpleTest_SaveAndLoad),
  ]
}
