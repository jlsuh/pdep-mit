module TP1 where

-- 1)
esMes :: Int -> Bool
esMes unNumero =
  unNumero >= 1 && unNumero <= 12

-- 2)
-- Verifica si el primero es el múltiplo del segundo
esMultiploDe :: Int -> Int -> Bool
esMultiploDe primero segundo =
  primero `mod` segundo == 0

hayCambioDeEstacion :: Int -> Bool
hayCambioDeEstacion unNumero =
  esMultiploDe unNumero 3 && esMes unNumero

-- 3)
esVerano :: Int -> Bool
esVerano unNumero =
  unNumero > 0 && unNumero < 3

esOtonio :: Int -> Bool
esOtonio unNumero =
  unNumero > 3 && unNumero < 6

esInvierno :: Int -> Bool
esInvierno unNumero =
  unNumero > 6 && unNumero < 9

esPrimavera :: Int -> Bool
esPrimavera unNumero =
  unNumero > 9 && unNumero < 12

estacion :: Int -> String
estacion 12 = "primavera/verano"  -- redefinición del dominio debido a: estacion (unNumero+1)
estacion unNumero
  | esVerano unNumero = "verano"
  | esOtonio unNumero = "otoño"
  | esInvierno unNumero = "invierno"
  | esPrimavera unNumero = "primavera"
  | hayCambioDeEstacion unNumero = estacion (unNumero-1) ++ "/" ++ estacion (unNumero+1)