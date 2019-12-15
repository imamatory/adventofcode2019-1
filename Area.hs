{-# LANGUAGE TupleSections #-}

module Area
  ( AreaMap
  , Pos
  , Dir(..)
  , dirs
  , visualize
  , move
  , neibs
  ) where

import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Data.Maybe (catMaybes)

type Pos = (Int, Int)
type AreaMap v = Map Pos v

data Dir = U | D | L | R deriving (Show, Eq, Enum)

dirs :: [Dir]
dirs = [U, D, L, R]

visualize :: (Maybe v -> Char) -> AreaMap v -> IO ()
visualize toChar m = mapM_ putStrLn rows
  where
    (xs, ys) = unzip . map fst $ Map.toList m
    rows =
      [ [ toChar $ Map.lookup (x, y) m
        | x <- [minimum xs .. maximum xs]
        ]
      | y <- [minimum ys .. maximum ys]
      ]

move :: Dir -> Pos -> Pos
move d (x, y) = case d of
  U -> (x    , y - 1)
  D -> (x    , y + 1)
  L -> (x - 1, y    )
  R -> (x + 1, y    )

neibs :: Pos -> AreaMap v -> [(Dir, Pos, v)]
neibs pos m = catMaybes $ map f dirs
  where
    f d = (d, p,) <$> Map.lookup p m
      where
        p = move d pos