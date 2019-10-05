# Cache Manager

```swift
struct User : Codable, Equatable {
  let id : Int
  let name : String
}

class LocalAnimationCache: AnimationCacheProvider {

  let cache = CacheManager<Animation>()

  public init() { }

  public func animation(forKey: String) -> Animation? {
    return cache?.load(forKey.sha1!)
  }

  public func setAnimation(_ animation: Animation, forKey: String) {
    cache?.save(animation, forKey.sha1!)
  }

  public func clearCache() {
    cache?.removeAllFileFromCache()
  }
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
