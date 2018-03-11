getLines :: Int -> IO [String]
getLines n
    | n <= 0 = return []
    | otherwise = do
        thisLn <- getLine
        others <- getLines (n - 1)
        return (thisLn : others)

main = do
  n <- readLn :: IO Int
  is  <- getLines n
  let tree = [1] ++ concat [ let ilr = words i in [read $ ilr !! 0 :: Int, read $ ilr !! 1 :: Int] | i <- is ]
  t <- readLn :: IO Int
  kstrs <- getLines t
  let ks = [ read k :: Int | k <- kstrs]
  let height = calH tree
  let ths = [filter (<= height) [(ks !! i) * j | j <- [1..height]] | i <- [0..t-1]]
  go tree ths

go :: [Int] -> [[Int]] -> IO ()
go _ [] = do
  return ()
go tree (t:ts) = do
  let tree' = swap tree t
  putStrLn $ id $ unwords $ map (\x -> show x) $ filter (/= (-1)) $ traverseInorder 1 (drop 1 tree')
  go tree' ts


traverseInorder :: Int -> [Int] -> [Int]
traverseInorder parent ts
  | left == -1 && right == -1 = [-1, parent, -1]
  | right == -1 = traverseInorder left ts ++ [parent, -1]
  | left == -1 = [-1, parent] ++ traverseInorder right ts
  | otherwise = traverseInorder left ts ++ [parent] ++ traverseInorder right ts
  where (left, right) = (ts !! ((parent - 1) * 2), ts !! ((parent - 1) * 2 + 1))

{-
calH :: [Int] -> Int
calH tree
-}

swap :: [Int] -> [Int] -> [Int]
swap tree [] = tree
swap (t:ts) (h:hs)
  | h == 1 = swapChild t (t:ts)
  | otherwise = swap (foldr swapChild (t:ts) (filter (/= (-1)) (getParents h (t:ts)))) hs

swapChild :: Int -> [Int] -> [Int]
swapChild parent (t:ts) = t:ts'
  where (front, back) = splitAt ((parent-1)*2) ts
        a = back !! 0
        b = back !! 1
        ts' = front ++ [b] ++ [a] ++ drop 2 back

{-
getParents :: Int -> [Int] -> [Int]
-}
