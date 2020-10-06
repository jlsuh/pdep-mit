module Interestelar where

import Text.Show.Functions

{-
En un futuro en el cual la tierra ya no es un buen lugar para habitar, las expediciones desesperadas por
el universo en busca de nuevos planetas habitables llevó a la NASA a pedirnos que hagamos un
programa para modelar cómo se ven afectados los astronautas por sus misiones. Tenemos los
siguientes datos para trabajar:
-}

                      -- nombre, posición en espacio, relación: cuánto tiempo terrestre equivale pasar un año allí
data Planeta = UnPlaneta String Posicion (Int -> Int) deriving (Show)
posicion (UnPlaneta _ p _) = p
tiempo (UnPlaneta _ _ t) = t

tierra = UnPlaneta "Tierra" (10000,23425,310495) cumplirAnios
-- distancia de la luna a la tierra: 384400km

-- aniosTierra :: Int -> Int
-- aniosTierra aniosTierraEnEsePlaneta = aniosTierraEnEsePlaneta

type Posicion = (Float, Float, Float)
coordX (x,_,_) = x
coordY (_,y,_) = y
coordZ (_,_,z) = z

                            -- nombre, edad, planeta actual en el que están
data Astronauta = UnAstronauta String Int Planeta deriving (Show)
nombre (UnAstronauta n _ _) = n
edad (UnAstronauta _ e _) = e
planeta (UnAstronauta _ _ p) = p

----------------
-- Ejercicio 1 |
----------------

-- a)
distancia :: Posicion -> Posicion -> Float
distancia posicionInicial posicionFinal =
  sqrt . sum $ [diferenciaCoordenadasAlCuadrado (coordX posicionInicial) (coordX posicionFinal),
                diferenciaCoordenadasAlCuadrado (coordY posicionInicial) (coordY posicionFinal),
                diferenciaCoordenadasAlCuadrado (coordZ posicionInicial) (coordZ posicionFinal)]

diferenciaCoordenadasAlCuadrado :: Float -> Float -> Float
diferenciaCoordenadasAlCuadrado final =
  (** 2) . (final -)

-- b)
cuantoTiempoTardaEntrePlaneta :: Planeta -> Planeta -> Float -> Float
cuantoTiempoTardaEntrePlaneta planetaInicial planetaFinal velocidad =
  (/ velocidad) . distancia (posicion planetaInicial) $ (posicion planetaFinal)

----------------
-- Ejercicio 2 |
----------------

pasarTiempo :: Int -> Astronauta -> Astronauta
pasarTiempo anios astronauta = UnAstronauta (nombre astronauta) (edad astronauta + cumplirAnios anios) (planeta astronauta)

-- suponiendo relación de 1 año en dicho planeta son tantos años en la Tierra. 1 -> x
cumplirAnios :: Int -> Int
cumplirAnios equivalenciaEnAniosTierra = equivalenciaEnAniosTierra

----------------
-- Ejercicio 3 |
----------------
type Nave = Planeta -> Planeta -> Int -> Float

-- a)
naveVieja :: Nave
naveVieja planetaOrigen planetaDestino tanquesDeOxigeno
  | tanquesDeOxigeno >= 0 && tanquesDeOxigeno < 6 = cuantoTiempoTardaEntrePlaneta planetaOrigen planetaDestino 10
  | otherwise = cuantoTiempoTardaEntrePlaneta planetaOrigen planetaDestino 7

-- b)
naveNueva :: Nave
naveNueva planetaOrigen planetaDestino tanquesDeOxigeno = 0

viajarAOtroPlaneta :: Planeta -> Nave -> Int -> Astronauta -> Astronauta
viajarAOtroPlaneta planetaDestino unaNave tanquesDeOxigeno astronauta =
  UnAstronauta (nombre astronauta) (edad astronauta + ceiling aniosACumplir) planetaDestino
  where
    aniosACumplir = (unaNave (planeta astronauta) planetaDestino tanquesDeOxigeno)
    -- cumplirAnios . ceiling $ (unaNave (planeta astronauta) planetaDestino tanquesDeOxigeno)

astroDoug = UnAstronauta "Doug" 35 tierra
astroBob = UnAstronauta "Bob" 40 tierra
astroSergei = UnAstronauta "Sergei" 33 tierra
astroNeil = UnAstronauta "Neil" 33 zapewlkr
astroMegan = UnAstronauta "Megan" 54 zapewlkr

zapewlkr = UnPlaneta "zapewlkr" (2324,234,23279) cumplirAnios

{-
*Interestelar> viajarAOtroPlaneta astroDoug tierra naveVieja 19
UnAstronauta "Doug" 35 (UnPlaneta "Tierra" (10000.0,23425.0,310495.0) <function>)
*Interestelar> viajarAOtroPlaneta astroDoug zapewlkr naveVieja 19
UnAstronauta "Doug" 41214 (UnPlaneta "zapewlkr" (2324.0,234.0,23279.0) <function>)

*Interestelar> viajarAOtroPlaneta astroDoug zapewlkr naveNueva 19
UnAstronauta "Doug" 35 (UnPlaneta "zapewlkr" (2324.0,234.0,23279.0) <function>)
*Interestelar> viajarAOtroPlaneta astroDoug tierra naveNueva 19
UnAstronauta "Doug" 35 (UnPlaneta "Tierra" (10000.0,23425.0,310495.0) <function>)
-}

----------------
-- Ejercicio 4 |
----------------

-- a)
type Tripulacion = [Astronauta]

apollo :: Tripulacion
apollo = [astroDoug, astroBob, astroSergei]

varados = [astroNeil, astroMegan]

realizarRescate :: Int -> Int -> Nave -> Tripulacion -> Astronauta -> Tripulacion
realizarRescate tanquesDeOxigeno aniosAPasar nave tripulacion astronautaVarado =
  viajarAlPlanetaConTripulacion tanquesDeOxigeno (planeta . head $ tripulacion) nave .
    map (pasarTiempo aniosAPasar) .
      ((viajarAOtroPlaneta planetaDestino nave tanquesDeOxigeno astronautaVarado) :) $
        viajarAlPlanetaConTripulacion tanquesDeOxigeno planetaDestino nave tripulacion
      where
        planetaDestino = planeta astronautaVarado

viajarAlPlanetaConTripulacion :: Int -> Planeta -> Nave -> Tripulacion -> Tripulacion
viajarAlPlanetaConTripulacion tanquesDeOxigeno planetaDestino nave tripulacion =
  map (viajarAOtroPlaneta planetaDestino nave tanquesDeOxigeno) $ tripulacion

-- b)
listarRescatables :: Int -> Int -> Nave -> Tripulacion -> Tripulacion -> [String]
listarRescatables _ _ _ _ [] = []
listarRescatables tanquesDeOxigeno aniosAPasar naveUsada rescatistas (a:as)
  | esRescatable tanquesDeOxigeno aniosAPasar naveUsada rescatistas a = nombre a : elRestoVarados
  | otherwise = elRestoVarados
  where
    elRestoVarados = listarRescatables tanquesDeOxigeno aniosAPasar naveUsada rescatistas as

esRescatable :: Int -> Int -> Nave -> Tripulacion -> Astronauta -> Bool
esRescatable tanquesDeOxigeno aniosAPasar nave tripulacion astronautaVarado =
  all ((< 90) . edad) $ realizarRescate tanquesDeOxigeno aniosAPasar nave tripulacion astronautaVarado

----------------
-- Ejercicio 5 |
----------------

{-
Inferir el tipo de la siguiente función:
-}
f :: Ord a => (a -> a -> a) -> a -> (Int -> a -> Bool) -> [a] -> Bool
f a b c = any ((> b).a b).filter (c 10)

-- Notar que f posee point free para el 4° parámetro, que debe ser una lista, pues será el segundo argumento del filter

                      -- notar que acá no puede ser
                      -- bool, pues la función "a"
                      -- debe retornar el mismo tipo
                      -- de dato que b, pues se necesita
                      -- que sean iguales para la
                      -- comparación por (>)
-- f :: Ord a => (a -> a -> Bool) -> a -> (Int -> a -> Bool) -> [a] -> Bool

-- any :: (a -> Bool) -> [a] -> Bool
-- filter :: (a -> Bool) -> [a] -> [a]
-- a :: a -> a -> Bool <- MAL
-- c :: Int -> a -> Bool
-- b :: Ord a