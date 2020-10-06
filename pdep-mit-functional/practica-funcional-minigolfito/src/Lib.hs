-- Consignas: https://www.youtube.com/redirect?q=https%3A%2F%2Fdocs.google.com%2Fdocument%2Fd%2Fe%2F2PACX-1vRkOd4mTaiEPPuDtYK0ln8x3Sswjim0Mioxvbs5zlShAZ2nqDSxpIv9WTsQCgaDq-K7fVako9QHPLD3%2Fpub&event=video_description&v=NEhCiL7JTo8&redir_token=_Dkx8VzHjNoJy4h2UBkKS2L5N8p8MTU5MTMxOTY1MEAxNTkxMjMzMjUw

module Lib where

import Text.Show.Functions

-- Modelo inicial

data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo

bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)

mayorSegun f a b
  | f a > f b = a
  | otherwise = b

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------

----------------
-- Ejercicio 1 |
----------------

-- a)
type Palo = (Habilidad -> Tiro)

putter :: Palo
putter habilidadJugador = UnTiro {
  velocidad = 10,
  precision = (* 2) . precisionJugador $ habilidadJugador,
  altura = 0
}

madera :: Palo
madera habilidadJugador = UnTiro {
  velocidad = 100,
  precision = (`div` 2) . precisionJugador $ habilidadJugador,
  altura = 5
}

hierro :: Int -> Palo
hierro n habilidadJugador = UnTiro {
  velocidad = (* n) . fuerzaJugador $ habilidadJugador,
  precision = (`div` n) . precisionJugador $ habilidadJugador,
  altura = (n - 3) `max` 0
  -- altura = restaAlMenos 0 3
}
-- un tanto innecesaria esta función:
-- restaAlMenos :: Int -> Int -> Int
-- restaAlMenos n numeroRestado
--   | n - numeroRestado > 0 = n - numeroRestado
--   | otherwise = 0

-- b)
palos :: [Palo]
-- palos = [putter, madera, hierro 1, hierro 2,
--         hierro 3, hierro 4, hierro 5, hierro 6,
--         hierro 7, hierro 8, hierro 9, hierro 10]
-- Se puede declararse de mejor forma la constante palos:
palos = [putter, madera] ++ map hierro [1..10]

----------------
-- Ejercicio 2 |
----------------

golpe ::  Palo -> Jugador -> Tiro
golpe palo =
  palo . habilidad

{-
*Lib> golpe ((!!) palos 0) bart
UnTiro {velocidad = 10, precision = 120, altura = 0}
-}

----------------
-- Ejercicio 3 |
----------------

data Obstaculo = UnObstaculo {
  puedeSuperarlo :: Tiro -> Bool,
  tiroSuperado :: Tiro -> Tiro
} deriving (Show)

tiroPuedeSuperarObstaculo :: [(Tiro -> Bool)] -> Tiro -> Bool
tiroPuedeSuperarObstaculo condiciones unTiro =
  all (== True) . map ($ unTiro) $ condiciones

intentarSuperarObstaculo :: Obstaculo -> Tiro -> Tiro
intentarSuperarObstaculo obstaculo tiro
  | (puedeSuperarlo obstaculo) tiro = (tiroSuperado obstaculo) tiro
  | otherwise = detenerTiro

detenerTiro :: Tiro
detenerTiro = UnTiro {
  velocidad = 0,
  precision = 0,
  altura = 0
}

tunelConRampita :: Obstaculo
tunelConRampita = UnObstaculo {
  puedeSuperarlo = tiroPuedeSuperarObstaculo [((> 90) . precision), ((== 0) . altura)],
  tiroSuperado = tiroSuperadoTunelRampita
}

tiroSuperadoTunelRampita :: Tiro -> Tiro
tiroSuperadoTunelRampita tiro = UnTiro {
  precision = 100,
  velocidad = ((* 2) . velocidad $ tiro),
  altura = 0
}

laguna :: Int -> Obstaculo
laguna largoDeLaguna = UnObstaculo {
  puedeSuperarlo = tiroPuedeSuperarObstaculo [((> 80) . velocidad), (between 1 5 . altura)],
  tiroSuperado = tiroSuperadoLaguna largoDeLaguna
}

tiroSuperadoLaguna :: Int -> Tiro -> Tiro
tiroSuperadoLaguna largoDeLaguna tiroOriginal = tiroOriginal {
  altura = (`div` largoDeLaguna) . altura $ tiroOriginal
}

hoyo :: Obstaculo
hoyo = UnObstaculo {
  puedeSuperarlo = tiroPuedeSuperarObstaculo [(between 5 20 . velocidad), ((== 0) . altura), ((> 95) . precision)],
  tiroSuperado = tiroSuperadoHoyo
}

tiroSuperadoHoyo :: Tiro -> Tiro
tiroSuperadoHoyo _ = detenerTiro

{-
Un jugador le pega con todos los palos posibles en el obstáculo
*Lib> map (intentarSuperarObstaculo tunelConRampita) (map (flip golpe bart) palos)
[UnTiro {velocidad = 20, precision = 100, altura = 0},UnTiro {velocidad = 0, precision = 0, altura = 0},
UnTiro {velocidad = 0, precision = 0, altura = 0},UnTiro {velocidad = 0, precision = 0, altura = 0},
UnTiro {velocidad = 0, precision = 0, altura = 0},UnTiro {velocidad = 0, precision = 0, altura = 0},
UnTiro {velocidad = 0, precision = 0, altura = 0},UnTiro {velocidad = 0, precision = 0, altura = 0},
UnTiro {velocidad = 0, precision = 0, altura = 0},UnTiro {velocidad = 0, precision = 0, altura = 0},
UnTiro {velocidad = 0, precision = 0, altura = 0},UnTiro {velocidad = 0, precision = 0, altura = 0}]
-}

----------------
-- Ejercicio 4 |
----------------

-- a)
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles unJugador obstaculo =
  filter (puedeSuperarlo obstaculo . flip golpe unJugador) palos
-- golpe ::  Palo -> Jugador -> Tiro
-- flip golpe :: Jugador -> Palo -> Tiro

-- b)
cuantosConsecutivos ::  Tiro -> [Obstaculo] -> Int
cuantosConsecutivos unTiro =
  length . takeWhile (flip puedeSuperarlo unTiro)

-- c)
paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil unJugador listaObstaculos =
  maximoSegun (flip cuantosConsecutivos listaObstaculos . flip golpe unJugador) palos
        -- -> (Tiro -> Int)        ->           [Palo]
        --[ palo1, palo2, palo3, palo4, palo5]

-- golpe ::  Palo -> Jugador -> Tiro
-- maximoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> [a2] -> a2
-- maximoSegun f = foldl1 (mayorSegun f)
-- foldl1 :: Foldable t => (a -> a -> a) -> t a -> a

{-
mayorSegun :: Ord a => (p -> a) -> p -> p -> p
mayorSegun f a b
  | f a > f b = a
  | otherwise = b
-}

{-
*Lib> flip golpe bart (paloMasUtil bart [tunelConRampita, tunelConRampita, hoyo])
UnTiro {velocidad = 10, precision = 120, altura = 0}
-}

----------------
-- Ejercicio 5 |
----------------
padresQuePierdenLaApuesta :: [(Jugador, Puntos)] -> [String]
padresQuePierdenLaApuesta listaJugadores =
  map padre $ filter ((/=) . mayorSegunPuntos $ listaJugadores) (map jugador listaJugadores)

mayorSegunPuntos :: [(Jugador, Puntos)] -> Jugador
mayorSegunPuntos =
  jugador . maximoSegun puntos

jugador :: (Jugador, Puntos) -> Jugador
jugador =
  fst

puntos :: (Jugador, Puntos) -> Puntos
puntos =
  snd