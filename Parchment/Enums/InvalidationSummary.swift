import UIKit

/// Used to represent what to invalidate in a collection view
/// layout. We need to be able to invalidate the layout multiple times
/// with different invalidation contexts before `invalidateLayout` is
/// called and we can use we can use this to determine exactly how
/// much we need to invalidate by adding together the states each
/// time a new context is invalidated.
public enum InvalidationState {
  case nothing
  case everything
  case contentOffset
  case transition
  case sizes
  
  init(_ invalidationContext: UICollectionViewLayoutInvalidationContext) {
    if invalidationContext.invalidateEverything {
      self = .everything
    } else if invalidationContext.invalidateDataSourceCounts {
      self = .everything
    } else if let context = invalidationContext as? PagingInvalidationContext {
      if context.invalidateTransition {
        self = .transition
      } else if context.invalidateSizes {
        self = .sizes
      } else if context.invalidateContentOffset {
        self = .contentOffset
      } else {
        self = .nothing
      }
    } else {
      self = .nothing
    }
  }
  
  static func +(lhs: InvalidationState, rhs: InvalidationState) -> InvalidationState {
    switch (lhs, rhs) {
    case (.everything, _), (_, .everything):
      return .everything
    case (.sizes, _), (_, .sizes):
      return .sizes
    case (.transition, _), (_, .transition):
      return .transition
    case (.contentOffset, _), (_, .contentOffset):
      return .contentOffset
    case (.nothing, _), (_, .nothing):
      return .nothing
    default:
      return .everything
    }
  }
}

