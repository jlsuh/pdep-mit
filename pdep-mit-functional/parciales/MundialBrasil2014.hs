module MundialBrasil2014 where

import Text.Show.Functions

data Jugador = UnJugador {
  nombre :: String,
  edad :: Int,
  promedioGol :: Float,
  habilidad :: Int,
  valorCansancio :: Float
} deriving (Show, Eq)

type Equipo = (String, Grupo, [Jugador])
type Grupo = Char

martin = UnJugador "Martin" 26 0.0 50 35.0
juan = UnJugador "Juancho" 30 0.2 50 40.0
maxi = UnJugador "Maxi Lopez" 27 0.4 68 30.0

jonathan = UnJugador "Chueco" 20 1.5 80 99.0
lean = UnJugador "Hacha" 23 0.01 50 35.0
brian = UnJugador "Panadero" 21 5 80 15.0

garcia = UnJugador "Sargento" 30 1 80 13.0
messi = UnJugador "Pulga" 26 10 99 43.0
aguero = UnJugador "Aguero" 24 5 90 5.0

equipo1 = ("Lo Que Vale Es El Intento", 'F', [martin, juan, maxi])
losDeSiempre = ( "Los De Siempre", 'F', [jonathan, lean, brian])
restoDelMundo = ("Resto del Mundo", 'A', [garcia, messi, aguero])

quickSort _ [] = [] 
quickSort criterio (x:xs) =
  (quickSort criterio . filter (not . criterio x)) xs ++ [x] ++ (quickSort criterio . filter (criterio x)) xs

----------------
-- Ejercicio 1 |
----------------
nombreEquipo :: Equipo -> String
nombreEquipo (nombreEquipo, _, _) = nombreEquipo

grupoEquipo :: Equipo -> Grupo
grupoEquipo (_, grupo, _) = grupo

jugadoresEquipo :: Equipo -> [Jugador]
jugadoresEquipo (_, _, jugadores) = jugadores

filtrarFiguras :: Equipo -> [Jugador]
filtrarFiguras =
  filter (esFigura) . jugadoresEquipo

esFigura :: Jugador -> Bool
esFigura jugador =
  criterioSegunConCota 75 (>) habilidad jugador && criterioSegunConCota 0 (>) promedioGol jugador

criterioSegunConCota :: Num a => a -> (a -> a -> Bool) -> (Jugador -> a) -> Jugador -> Bool
criterioSegunConCota cota funcion criterio jugador =
  criterio jugador `funcion` cota

----------------
-- Ejercicio 2 |
----------------
jugadoresFaranduleros = ["Maxi Lopez", "Icardi", "Aguero", "Caniggia", "Demichelis"]

tieneFarandulero :: Equipo -> Bool
tieneFarandulero =
  foldl1 (&&) . map esFarandulero . jugadoresEquipo

esFarandulero :: Jugador -> Bool
esFarandulero =
  flip elem jugadoresFaranduleros . nombre

----------------
-- Ejercicio 3 |
----------------
-- type Equipo = (String, Grupo, [Jugador])
figuritasDificiles :: [Equipo] -> Grupo -> [Jugador]
figuritasDificiles equipos grupo =
  filter esFigurita . concatMap jugadoresEquipo . filter ((== grupo).grupoEquipo) $ equipos

esFigurita :: Jugador -> Bool
esFigurita jugador =
  foldl1 (&&) . map ($ jugador) $ [esFigura, esJoven, (not.esFarandulero)]

esJoven :: Jugador -> Bool
esJoven =
  criterioSegunConCota 27 (<) edad

{-
map nombre . figuritasDificiles [equipo1, losDeSiempre, restoDelMundo] $ 'F'
["Chueco","Panadero"]
*MundialBrasil2014> map nombre . figuritasDificiles [equipo1, losDeSiempre, restoDelMundo] $ 'A'
["Pulga"]
-}

----------------
-- Ejercicio 4 |
----------------
jugarPartido :: Equipo -> Equipo
jugarPartido (nombre, grupo, jugadores) =
  (nombre, grupo, map modificarJugadores jugadores)

modificarJugadores :: Jugador -> Jugador
modificarJugadores jugadorOriginal
  | esFigurita jugadorOriginal = modificarCansancio 50 jugadorOriginal
  | esJoven jugadorOriginal = modificarCansancio (cansancioOriginal + cansancioOriginal * 0.10) jugadorOriginal
  | (not.esJoven $ jugadorOriginal) && esFigura jugadorOriginal = modificarCansancio (cansancioOriginal + 20) jugadorOriginal
  | otherwise = modificarCansancio (cansancioOriginal * 2) jugadorOriginal
  where
    cansancioOriginal = valorCansancio jugadorOriginal

modificarCansancio :: Float -> Jugador -> Jugador
modificarCansancio nuevoCansancio jugadorOriginal = jugadorOriginal {
  valorCansancio = nuevoCansancio
}

{-
*MundialBrasil2014> jugarPartido equipo1
("Lo Que Vale Es El Intento",'F',
[UnJugador {nombre = "Martin", edad = 26, promedioGol = 0.0, habilidad = 50, valorCansancio = 38.5},
UnJugador {nombre = "Juancho", edad = 30, promedioGol = 0.2, habilidad = 50, valorCansancio = 80.0},
UnJugador {nombre = "Maxi Lopez", edad = 27, promedioGol = 0.4, habilidad = 68, valorCansancio = 60.0}])
-}

----------------
-- Ejercicio 5 |
----------------
type Partido = Equipo -> Equipo -> Equipo

partidoMundial :: Partido
partidoMundial unEquipo otroEquipo
  | sumarPromediosOncePrimeros unEquipo > sumarPromediosOncePrimeros otroEquipo = jugarPartido unEquipo
  | otherwise = jugarPartido otroEquipo
  
sumarPromediosOncePrimeros :: Equipo -> Float
sumarPromediosOncePrimeros =
  foldl1 (+) . map promedioGol . losOncePrimerosMenosCansados . quickSort (funcionSegunCriterio (<) valorCansancio) . jugadoresEquipo
--   sum

funcionSegunCriterio :: (Num a, Ord a) => (a -> a -> Bool) -> (Jugador -> a) -> Jugador -> Jugador -> Bool
funcionSegunCriterio funcion criterio unJugador otroJugador =
  criterio unJugador `funcion` criterio otroJugador

losOncePrimerosMenosCansados :: [Jugador] -> [Jugador]
losOncePrimerosMenosCansados =
  take 11

----------------
-- Ejercicio 6 |
----------------
consagrarCampeonUno :: [Equipo] -> Equipo
consagrarCampeonUno equipos =
  foldl1 partidoMundial equipos

consagrarCampeonDos :: [Equipo] -> Equipo
consagrarCampeonDos [ultimo] = ultimo
consagrarCampeonDos (e:es)
  | (partidoMundial e (head es)) == jugarPartido e = consagrarCampeonDos (e : tail es)
  | otherwise = consagrarCampeonDos ((jugarPartido . head $ es) : tail es)

{-
*MundialBrasil2014> consagrarCampeonDos [equipo1, losDeSiempre, restoDelMundo]
("Resto del Mundo",'A',
[UnJugador {nombre = "Sargento", edad = 30, promedioGol = 1.0, habilidad = 80, valorCansancio = 33.0},
UnJugador {nombre = "Pulga", edad = 26, promedioGol = 10.0, habilidad = 99, valorCansancio = 50.0},
UnJugador {nombre = "Aguero", edad = 24, promedioGol = 5.0, habilidad = 90, valorCansancio = 5.5}])

*MundialBrasil2014> consagrarCampeonDos [equipo1, losDeSiempre]
("Los De Siempre",'F',
[UnJugador {nombre = "Chueco", edad = 20, promedioGol = 1.5, habilidad = 80, valorCansancio = 50.0},
UnJugador {nombre = "Hacha", edad = 23, promedioGol = 1.0e-2, habilidad = 50, valorCansancio = 38.5},
UnJugador {nombre = "Panadero", edad = 21, promedioGol = 5.0, habilidad = 80, valorCansancio = 50.0}])

*MundialBrasil2014> consagrarCampeonDos [losDeSiempre, restoDelMundo]
("Resto del Mundo",'A',
[UnJugador {nombre = "Sargento", edad = 30, promedioGol = 1.0, habilidad = 80, valorCansancio = 33.0},
UnJugador {nombre = "Pulga", edad = 26, promedioGol = 10.0, habilidad = 99, valorCansancio = 50.0},
UnJugador {nombre = "Aguero", edad = 24, promedioGol = 5.0, habilidad = 90, valorCansancio = 5.5}])
-}

----------------
-- Ejercicio 7 |
----------------
mvp :: [Equipo] -> Jugador
mvp equipos =
  (!!) (jugadoresEquipo $ consagrarCampeonUno equipos) (buscarPrimerMejor equipos)

buscarPrimerMejor :: [Equipo] -> Int
buscarPrimerMejor =
  (+1) . length . takeWhile (not . esFigura) . jugadoresEquipo . consagrarCampeonUno

{-
*MundialBrasil2014> mvp [equipo1, losDeSiempre, restoDelMundo]
UnJugador {nombre = "Pulga", edad = 26, promedioGol = 10.0, habilidad = 99, valorCansancio = 50.0}
-}

------------
-- Teórico |
------------
{-
1) ¿Dónde usaron funciones de orden superior? ¿Por qué? ¿Crearon alguna función de orden superior?
Se utilizó funciones de orden superior en las funciones:
-> Ejercicio 1:
  filtrarFiguritas -> uso del filter
-> Ejercicio 2:
  tieneFarandulero -> uso del foldl1
-> Ejercicio 3:
  figuritasDificiles -> uso del filter
  tieneFiguritas -> uso del foldl1
-> Ejercicio 5:
  sumarPromedioOncePrimeros -> uso del foldl1
-> Ejercicio 6:
  consagrarCampeonUno -> uso del foldl1
-> Ejercicio 7:
  buscarPrimerMejor -> uso del takeWhile

Se aplicó el concepto de orden superior, pues es una función que recibe como parámetro a otras funciones, como es el caso de
filter, foldl1, takeWhile.

Se han creado funciones de orden superior:
-> Ejercicio 1:
  criteriosSegunConCota
-> Ejercicio 5:
  funcionSegunCriterio

Se aplicó el concepto de orden superior, debido a la misma razón aclarado anteriormente.

2) ¿Qué pasaría si un equipo tuviera una lista infinita de jugadores?
En caso de que haya una lista infinita de jugadores, no se podría terminar de evaluarse la función, entrando así la misma en un loop
infinito. No obstante, hay excepciones en que sí se podrán, como por ejemplo en el ejercicio 5, en la función sumarPromediosOncePrimeros,
en donde se emplea la función take, debido a la definición de la función losOncePrimerosMenosCansados, en donde dicho take acota el
conjunto infinito de jugadores (la lista infinita de jugadores), y los reduce a un subconjunto acotado de 11 jugadores.
-}