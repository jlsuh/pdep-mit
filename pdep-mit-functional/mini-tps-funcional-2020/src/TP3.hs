module TP3 where
import Cafe

-- (.) :: (b -> c) -> (a -> b) -> a -> c

-- 1)
armarCafe :: Vaso -> Gramos -> Cafe
armarCafe unVaso =
  servirEnVaso unVaso . prepararCafe 1000 . molerGranos
  -- (Cafe -> Cafe) -> ((Gramos -> Cafe) -> (Gramos -> Gramos)) -> Gramos -> Cafe

-- 2)
armarFrapu :: Gramos -> Cafe
armarFrapu =
  servirEnVaso 400 . licuar 60 120 . agregarHielo 6 . prepararCafe 80 . molerGranos
-- (Cafe -> Cafe) -> ((Cafe -> Cafe) -> ((Cafe -> Cafe) -> ((Gramos -> Cafe) -> (Gramos -> Gramos)))) -> Gramos -> Cafe