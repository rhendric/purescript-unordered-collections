module Data.CHAMP where

import Prelude

import Data.Foldable (class Foldable, foldr)
import Data.Hashable (class Hashable, hash)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))

foreign import data CHAMP :: Type -> Type -> Type

foreign import empty :: forall k v. CHAMP k v

foreign import lookupPurs :: forall k v. Maybe v -> (v -> Maybe v) -> (k -> k -> Boolean) -> k -> Int -> CHAMP k v -> Maybe v

lookup :: forall k v. Hashable k => k -> CHAMP k v -> Maybe v
lookup k = lookupPurs Nothing Just (==) k (hash k)

foreign import insertPurs :: forall k v. (k -> k -> Boolean) -> (k -> Int) -> k -> v -> CHAMP k v -> CHAMP k v

insert :: forall k v. Hashable k => k -> v -> CHAMP k v -> CHAMP k v
insert = insertPurs (==) hash

fromFoldable :: forall f k v. Foldable f => Hashable k => f (Tuple k v) -> CHAMP k v
fromFoldable = foldr (\(Tuple k v) -> insert k v) empty
