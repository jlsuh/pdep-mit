module FMI where

import Text.Show.Functions

----------------
-- Ejercicio 1 |
----------------
-- a)
data Pais = UnPais {
  ingresoPerCapita :: Double,
  sectorPublico :: Double,
  sectorPrivado :: Double,
  recursosNaturales :: [Recurso],
  deudaConFMI :: Double
} deriving (Show, Eq, Ord)

type Recurso = String

-- b)
namibia :: Pais
namibia = UnPais {
  ingresoPerCapita = 4140,
  sectorPublico = 400000,
  sectorPrivado = 650000,
  recursosNaturales = ["Mineria", "Ecoturismo"],
  deudaConFMI = millones 50
}

millones :: Double -> Double
millones =
  (* 1000000)

----------------
-- Ejercicio 2 |
----------------
type Receta = Pais -> Pais

prestarleNMillones :: Double -> Receta
prestarleNMillones cifra paisOriginal = paisOriginal {
  deudaConFMI = (deudaConFMI paisOriginal +) . endeudarPais cifra $ 1.5
}

endeudarPais :: Double -> Double -> Double
endeudarPais cifra porcentaje =
  (* porcentaje) . millones $ cifra

reducirPuestosTrabajo :: Double -> Receta
reducirPuestosTrabajo cantidadPuestos paisOriginal = paisOriginal {
  sectorPublico = sectorPublico paisOriginal - cantidadPuestos,
  ingresoPerCapita = ingresoPerCapita paisOriginal - disminuirIngresoPerCapita paisOriginal
}

disminuirIngresoPerCapita :: Pais -> Double
disminuirIngresoPerCapita pais
  | sectorPublico pais > 100 = ingresoPerCapita pais * 0.20
  | otherwise = ingresoPerCapita pais * 0.15

empresaAFin :: String -> Receta
empresaAFin recursoNatural paisOriginal = paisOriginal {
  deudaConFMI = deudaConFMI paisOriginal - millones 2,
  recursosNaturales = filter (/= recursoNatural) $ recursosNaturales paisOriginal
}

establecerBlindaje :: Receta
establecerBlindaje paisOriginal = paisOriginal {
  deudaConFMI = deudaConFMI paisOriginal + obtenerPBI paisOriginal,
  sectorPublico = sectorPublico paisOriginal - 500
}

obtenerPBI :: Pais -> Double
obtenerPBI pais =
  deudaConFMI (prestarleNMillones (ingresoPerCapita pais * (sectorPublico pais + sectorPrivado pais)) pais)

-- aplicarCriterioSegun :: (Ord a) => (a -> a -> Bool) -> (a -> Bool) -> Double -> Double -> a -> Double
-- aplicarCriterioSegun funcion criterio cota elemento
--   | criterio elemento `funcion` cota = 
--   | otherwise = 

----------------
-- Ejercicio 3 |
----------------
-- a)
armarReceta :: [Receta] -> Receta
armarReceta =
  foldl1 (flip (.))

recetaUno :: Receta
recetaUno =
  armarReceta [prestarleNMillones 200, empresaAFin "Mineria"]

recetaDos :: Receta
recetaDos =
  armarReceta [prestarleNMillones 200, empresaAFin "Petroleo", reducirPuestosTrabajo 1000]
  

-- b)
{-
*FMI> receta namibia
UnPais {ingresoPerCapita = 4140.0, sectorPublico = 400000.0, sectorPrivado = 650000.0, recursosNaturales = ["Ecoturismo"], deudaConFMI = 3.48e8}

Partiendo de la base que en Haskell no hay efecto lateral (léase: mantener el cambio producido sobre un valor), dicho efecto colateral se
emularía mediante el retorno de una nueva estructura con los "cambios" que se desee realizar.
En este caso mediante la función foldl1, se componen las dos funciones: prestarleNMillones 200 y empresaAFin "Mineria", en donde las mismas
endeudan al pais namibia en un 150% del total del préstamo, y dejan sin recurso "Mineria" momentaneamente.
-}

----------------
-- Ejercicio 4 |
----------------
-- a)
puedeZafar :: Pais -> Bool
puedeZafar =
  (> 0) . length . filter (/= "Petroleo") . recursosNaturales

-- b)
totalDeuda :: [Pais] -> Double
totalDeuda =
  sum . map deudaConFMI

-- c)
{-
Hay orden superior en puedeZafar, al momento de utilizar el filter (/= "Petroleo"), siendo la función recibida por parámetro "/="
Hay composición y aplicación parcial en puedeZafar entre (> 0) y length
-}

----------------
-- Ejercicio 5 |
----------------
recetasEstanOrdenadas :: [Receta] -> Pais -> Bool
recetasEstanOrdenadas recetas pais =
  foldl1 (&&) . menorQueSiguiente $ (obtenerPBIReceta recetas pais)

menorQueSiguiente :: [Double] -> [Bool]
menorQueSiguiente (l:ls)
  | l < head ls = True : menorQueSiguiente ls
  | otherwise = False : menorQueSiguiente ls

obtenerPBIReceta :: [Receta] -> Pais -> [Double]
obtenerPBIReceta [ultimaReceta] pais = obtenerPBI (ultimaReceta pais):[]
obtenerPBIReceta recetas pais =
  obtenerPBI ((head recetas) pais) : obtenerPBIReceta (tail recetas) pais

-- obtenerPBI :: Pais -> Double
----------------
-- Ejercicio 6 |
----------------
{-
Si un país tiene infinitos recursos naturales, modelado con esta función
-}
recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos
{-
¿qué sucede evaluamos la función 4a con ese país? ¿y con la 4b? Justifique ambos puntos relacionándolos con algún concepto.

Si se aplica lazy evaluation sobre la función del 4a):

puedeZafar unPais
(> 0) . length . filter (/= "Petroleo") . recursosNaturalesInfinitos
(> 0) . length . filter (/= "Petroleo") . (["Energia"] : recursosNaturalesInfinitos)
(> 0) . length . filter (/= "Petroleo") . ("Energia" : ["Energia"] : recursosNaturalesInfinitos)
(> 0) . length . filter (/= "Petroleo") . (["Energia", "Energia"] : recursosNaturalesInfinitos) ...

Y así seguiría hasta el infinito.
Rta/. No es posible determinar si un pais puede zafar, en caso de que se tengan recursos ilimitados.

Por otro lado, en la función del 4b) es posible determinar la deuda total que posee el fmi a su favor respecto de la lista de paises,
pues para el cálculo de la deuda total, pues para la deuda total no influya la lista de recursos infinitos, sino que para la deuda
total influyen solamente el ingresoPerCapita, el sectorPublico y el sectorPrivado, desligándolo así de la evaluación sobre la lista
de recursos infinitos.
-}