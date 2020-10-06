module ExpertosEnMaquinitas where

import Text.Show.Functions

data Persona = UnaPersona {
  nombrePersona :: String,
  dinero :: Float,
  suerte :: Int,
  factores :: [(String,Int)]
} deriving(Show)

nico = (UnaPersona "Nico" 100.0 30 [("amuleto", 3), ("manos magicas",100)])
maiu = (UnaPersona "Maiu" 100.0 42 [("inteligencia",55), ("paciencia",50)])

----------------
-- Ejercicio 1 |
----------------
suerteTotal :: Persona -> Int
suerteTotal persona
  | tieneSegun "amuleto" persona =
      suerte $ personaConAmuletoYFactor amuletosConFactoresConsiderables persona
  | otherwise = suerte persona
  where
    amuletosConFactoresConsiderables = filtrarFactor "amuleto" persona

{-
*ExpertosEnMaquinitas> suerteTotal (UnaPersona "Nico" 100.0 30 [("amuleto", 3), ("manos magicas",100), ("amuleto", 2)])
150
*ExpertosEnMaquinitas> suerteTotal (UnaPersona "Nico" 100.0 30 [("amuleto", 3), ("manos magicas",100), ("amuleto", 0)])
90
-}

personaConAmuletoYFactor :: [(String,Int)] -> Persona -> Persona
personaConAmuletoYFactor amuletosConFactoresConsiderables personaOriginal = personaOriginal {
  suerte = (* sumatoriaDeFactores amuletosConFactoresConsiderables) . suerte $ personaOriginal
}

sumatoriaDeFactores :: [(String,Int)] -> Int
sumatoriaDeFactores =
  sum . map valorFactor

filtrarFactor :: String -> Persona -> [(String,Int)]
filtrarFactor factor persona =
  filter (tieneFactorConsiderable factor) (factores persona)

tieneFactorConsiderable :: String -> (String,Int) -> Bool
tieneFactorConsiderable nombreDelFactor factor =
  ((== nombreDelFactor) . nombreFactor $ factor) && tieneFactor factor

tieneSegun :: String -> Persona -> Bool
tieneSegun nombreDelFactor =
  (> 0) . length . filtrarFactor nombreDelFactor

tieneFactor :: (String,Int) -> Bool
tieneFactor =
  (> 0) . valorFactor

nombreFactor :: (String,Int) -> String
nombreFactor =
  fst

valorFactor :: (String,Int) -> Int
valorFactor =
  snd

----------------
-- Ejercicio 2 |
----------------
data Juego = UnJuego {
  nombreJuego :: String,
  cuantoGanaria :: Dinero -> Dinero,
  condiciones :: [Condicion]
}

type Dinero = Float
type Condicion = (Persona -> Bool)

ruleta :: Juego
ruleta = UnJuego {
  nombreJuego = "La ruleta",
  cuantoGanaria = (* 37),
  condiciones = [((> 80) . suerteTotal)]
}

maquinita :: Dinero -> Juego
maquinita jackpot = UnJuego {
  nombreJuego = "La maquinita",
  cuantoGanaria = (+ jackpot), -- delimitar billetera
  condiciones = [((> 95) . suerteTotal), tieneSegun "paciencia"]
}

----------------
-- Ejercicio 3 |
----------------
puedeGanarJuego :: Persona -> Juego -> Bool
puedeGanarJuego persona juego =
  foldl1 (&&) . map ($ persona) $ (condiciones juego)
-- all (== True) $ map ($ persona) (condiciones juego)
-- no utilizar: all (== True)

----------------
-- Ejercicio 4 |
----------------
-- a)
totalDineroEnJuegosConsecutivos :: Float -> Persona -> [Juego] -> Float
totalDineroEnJuegosConsecutivos apuestaInicial jugador listaJuegos =
  foldl jugarJuego apuestaInicial (juegosGanables jugador listaJuegos)

juegosGanables :: Persona -> [Juego] -> [Juego]
juegosGanables jugador listaJuegos =
  (filter (puedeGanarJuego jugador) listaJuegos)

jugarJuego :: Dinero -> Juego -> Float
jugarJuego apuesta juego =
  (cuantoGanaria juego) apuesta

joel = (UnaPersona "Joel" 100.0 35 [("amuleto", 3), ("paciencia",100)])

{-
*ExpertosEnMaquinitas> totalDineroEnJuegosConsecutivos 200 joel [ruleta, maquinita 1000]
8400.0
-}

-- b)
totalDineroEnJuegosConsecutivosRecursivo :: Float -> Persona -> [Juego] -> Float
totalDineroEnJuegosConsecutivosRecursivo apuestaInicial _ [] = apuestaInicial
totalDineroEnJuegosConsecutivosRecursivo apuestaInicial jugador (x:xs)
  | puedeGanarJuego jugador x = totalDineroEnJuegosConsecutivosRecursivo apuestaActual jugador xs
  | otherwise = totalDineroEnJuegosConsecutivosRecursivo apuestaInicial jugador xs
    where
      apuestaActual = jugarJuego apuestaInicial x

{-
*ExpertosEnMaquinitas> totalDineroEnJuegosConsecutivosRecursivo 200 joel [ruleta, maquinita 1000]
8400.0
-}

----------------
-- Ejercicio 5 |
----------------
jugadoresQueNoGananNingunJuego :: [Persona] -> [Juego] -> [String]
jugadoresQueNoGananNingunJuego personas juegos =
  map nombrePersona . filter (flip noPuedeGanarNingunJuego juegos) $ personas
--  map nombrePersona . filter ((== True) . flip noPuedeGanarNingunJuego juegos) $ personas
-- no utilizar: filter ((== True) ...)

noPuedeGanarNingunJuego :: Persona -> [Juego] -> Bool
noPuedeGanarNingunJuego persona =
  all (not.puedeGanarJuego persona)
-- all (== False) . map (puedeGanarJuego persona)
-- no utilizar: all (== False)

--  foldl1 (&&) . map (puedeGanarJuego persona)
----------------
-- Ejercicio 6 |
----------------
apostar :: Dinero -> Juego -> Persona -> Persona
apostar apuestaOriginal juego persona
  | puedeGanarJuego persona juego = personaQueApuesta apuestaOriginal juego (persona {dinero = dinero persona - apuestaOriginal})
  | otherwise = persona

personaQueApuesta :: Dinero -> Juego -> Persona -> Persona
personaQueApuesta apuestaOriginal juego personaOriginal = personaOriginal {
  dinero = jugarJuego apuestaOriginal juego
}

----------------
-- Ejercicio 7 |
----------------
elCocoEstaEnLaCasa x y z = all ( (>z) . (+42) ) . foldl (\a (b,c) -> y c ++ b a) (snd x)