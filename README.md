# Cache Manager

```swift
struct User : Codable, Equatable {
  let id : Int
  let name : String
}

func saveAndLoad() {
  let cacheManager = CacheManager<User>()
  let user = User(id: #line, name: "Malotru")
  let userID = "\(user.id)"
  
  cacheManager?.save(user, userID)
  let otherUser = cacheManager?.load(userID)
  
  assert(user == otherUser, "\(user) should equal to \(otherUser!)")
}
  
func saveAndLoadAll() {
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

func clearTheCache() {
  let cacheManager = CacheManager<User>(cacheLimit: [])
  let user = User(id: #line, name: "Malotru")
  let userID = "\(user.id)"
  
  cacheManager?.save(user, userID)
  cacheManager?.removeAllFileFromCache()
  let otherUser = cacheManager?.load(userID)
  assert(otherUser == nil, "otherUser(\(otherUser!)) should be nil")
}

```

## Done

- [x] Add test
- [x] Open Source
- [x] Add a loadAll

## ToDo

- [ ] Better documentation
- [ ] Better errors
- [ ] Add CI
- [ ] Add support for Property Wrappers - https://github.com/mackoj/Burritos
- [ ] Improve Package.swift
- [ ] Support various storage type (today only JSON)
