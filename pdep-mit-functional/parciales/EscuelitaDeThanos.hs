-- Consignas: https://docs.google.com/document/d/1IKrJkdbPyoxfHqREIfqzxpsBdANcL2g9gvs9t-IR30E/edit#

module EscuelitaDeThanos where

import Text.Show.Functions

------------
-- Parte 1 |
------------
----------------
-- Ejercicio 1 |
----------------
data Personaje = UnPersonaje {
  edad :: Int,
  energia :: Int,
  habilidades :: [String],
  nombre :: String,
  planetaResidencia :: String
} deriving (Show, Eq)

data Guantelete = UnGuantelete {
  material :: String,
  gemas :: [Gema]
} deriving (Show)

data Universo = UnUniverso {
  habitantes :: [Personaje]
} deriving (Show, Eq)

chasquidoDeUnUniverso :: Universo -> Universo
chasquidoDeUnUniverso universoOriginal = universoOriginal {
  habitantes = take ((`div` 2) . length . habitantes $ universoOriginal) (habitantes universoOriginal)
}

type Gema = Personaje -> Personaje

----------------
-- Ejercicio 2 |
----------------
esAptoParaPendex :: Universo -> Bool
esAptoParaPendex unUniverso =
  any ((< 45) . edad) (habitantes unUniverso)

energiaTotal :: Universo -> Int
energiaTotal unUniverso =
  sumatoriaEnergia $ filtrarPersonajesSegunCantidadHabilidad (>) 1 (habitantes unUniverso)

filtrarPersonajesSegunCantidadHabilidad :: (Int -> Int -> Bool) -> Int -> [Personaje] -> [Personaje]
filtrarPersonajesSegunCantidadHabilidad criterio minimo =
  filter ((criterio minimo) . length . habilidades)

sumatoriaEnergia :: [Personaje] -> Int
sumatoriaEnergia =
  sum . map energia

------------
-- Parte 2 |
------------
----------------
-- Ejercicio 3 |
----------------
mente :: Int -> Gema
mente energiaDebilitada personajeOriginal = personajeOriginal {
  energia = energia personajeOriginal - energiaDebilitada
}

alma :: String -> Gema -- Personaje -> Personaje
alma habilidadAEliminar unPersonaje
  | personajePoseeHabilidad habilidadAEliminar unPersonaje = eliminarHabilidad habilidadAEliminar unPersonaje
  | otherwise = unPersonaje

eliminarHabilidad :: String -> Gema -- Personaje -> Personaje
eliminarHabilidad habilidadAEliminar personajeOriginal = personajeOriginal {
  habilidades = filter (/= habilidadAEliminar) (habilidades personajeOriginal)
}

personajePoseeHabilidad :: String -> Personaje -> Bool
personajePoseeHabilidad habilidadAEliminar =
  elem habilidadAEliminar . habilidades

espacio :: String -> Gema -- Personaje -> Personaje
espacio planetaDestino rivalOriginal = rivalOriginal {
  planetaResidencia = planetaDestino,
  energia = ((-) 20) . energia $ rivalOriginal
}

poder :: Gema
poder =
  quitarSegunCantidad . dejarSinEnergia

quitarSegunCantidad :: Personaje -> Personaje
quitarSegunCantidad personaje
  | tieneComoMuchoHabilidades 2 personaje = quitarHabilidades personaje
  | otherwise = personaje

quitarHabilidades :: Personaje -> Personaje
quitarHabilidades personajeOriginal = personajeOriginal {
  habilidades = []
}

tieneComoMuchoHabilidades :: Int -> Personaje -> Bool
tieneComoMuchoHabilidades cota =
  (< cota) . length . habilidades

dejarSinEnergia :: Personaje -> Personaje
dejarSinEnergia personajeOriginal = personajeOriginal {
  energia = 0
}

tiempo :: Gema
tiempo personajeOriginal = personajeOriginal {
  edad = max 18 ((`div` 2) . edad $ personajeOriginal)
}

gemaLoca :: Gema -> Personaje -> Personaje
gemaLoca gema =
  gema . gema

----------------
-- Ejercicio 4 |
----------------
guanteleteDeGoma :: Guantelete
guanteleteDeGoma = UnGuantelete {
  material = "Goma",
  gemas = [tiempo, alma "Usar Mjolnir", gemaLoca (alma "Programación en Haskell")]
}

{-
*EscuelitaDeThanos> guanteleteDeGoma
UnGuantelete {material = "Goma", gemas = [<function>,<function>,<function>]}
-}

----------------
-- Ejercicio 5 |
----------------
                    -- enemigo
utilizar :: [Gema] -> Personaje -> Personaje
utilizar listaGemas enemigo =
  foldl (flip aplicarGemaSobrePersonaje) enemigo listaGemas

aplicarGemaSobrePersonaje :: Gema -> Personaje  -> Personaje
aplicarGemaSobrePersonaje gema =
  gema

----------------
-- Ejercicio 6 |
----------------
gemaMasPoderosa :: Personaje -> Guantelete -> Gema
gemaMasPoderosa unPersonaje unGuantelete =
  ponderarMayorSegun energia (gemas unGuantelete) unPersonaje

ponderarMayorSegun :: Ord a => (Personaje -> a) -> [Gema] -> Personaje -> Gema
--ponderarMayorSegun criterio [] unPersonaje = ponderarMayorSegun criterio ((head listaGemas) : (tail $ listaGemas)) unPersonaje
ponderarMayorSegun criterio listaGemas unPersonaje
  | (criterio . (head listaGemas) $ unPersonaje) < (criterio . (head . tail $ listaGemas) $ unPersonaje) =
      ponderarMayorSegun energia ((head listaGemas) : (tail . tail $ listaGemas)) unPersonaje
  | otherwise = ponderarMayorSegun criterio (tail . tail $ listaGemas) unPersonaje

----------------
-- Ejercicio 7 |
----------------
infinitasGemas :: Gema -> [Gema]
infinitasGemas gema =
  gema : (infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos =
  UnGuantelete "vesconite" (infinitasGemas tiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete =
  (utilizar . take 3 . gemas) guantelete

{-
gemaMasPoderosa punisher guanteleteDeLocos
Aplicando lazy evaluation:
ponderarMayorSegun energia (gemas guanteleteDeLocos) punisher

ponderarMayorSegun energia ([tiempo, tiempo, tiempo, ...]) punisher

Al poseer una lista infinita de gemas y al ausentar alguna función que pueda tomar un conjunto acotado del mismo,
la recursividad no será capaz de finiquitarse, entrará en un loop infinito.
-------------------------------------------------------------------------------------------------------------------
usoLasTresPrimerasGemas guanteleteDeLocos punisher
Aplicando lazy evaluation:
(utilizar . take 3 . gemas) guanteleteDeLocos punisher

(utilizar . take 3 . [tiempo, tiempo, tiempo, ...]) punisher

utilizar [tiempo, tiempo, tiempo] punisher

foldl (flip aplicarGemaSobrePersonaje) punisher [tiempo, tiempo, tiempo]

tiempo . tiempo . tiempo $ punisher

Será posible no caer en una recursividad, debido a la función take/2 de parámetros 3 y una lista infinita de gemas de la gema tiempo,
en donde la función take se encarga de tomar 3 gemas del tiempo de la lista infinita de gemas.
Posterior a ello, será capaz de evaluar las gemas aplicadas sobre el personaje, retornando así al personaje con las 3 gemas aplicadas.
-}
