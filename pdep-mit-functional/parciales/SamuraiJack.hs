module Samuraijack where

import Text.Show.Functions

data Elemento = UnElemento {
  tipo :: String,
  ataque :: (Personaje -> Personaje),
  defensa :: (Personaje -> Personaje)
} deriving (Show)

data Personaje = UnPersonaje {
  nombre :: String,
  salud :: Int,
  elementos :: [Elemento],
  anioPresente :: Int
} deriving (Show)

----------------
-- Ejercicio 1 |
----------------
-- a)
mandarAlAnio :: Int -> Personaje -> Personaje
mandarAlAnio anioIndicado personajeOriginal = personajeOriginal {
  anioPresente = anioIndicado
}

-- b)
meditar :: Personaje -> Personaje
meditar personajeOriginal = personajeOriginal {
  salud = saludOriginal + (saludOriginal `div` 2)
} where
  saludOriginal = salud personajeOriginal

-- c)
causarDanio :: Int -> Personaje -> Personaje
causarDanio danioProducido personajeOriginal = personajeOriginal {
  salud = max 0 (salud personajeOriginal - danioProducido)
}

personajeUno :: Personaje
personajeUno = UnPersonaje {
  nombre = "Personaje 1",
  salud = 300,
  elementos = [elementoUno],
  anioPresente = 2000
}

elementoUno :: Elemento
elementoUno = UnElemento {
  tipo = "Malvado",
  ataque = id,
  defensa = id
}

----------------
-- Ejercicio 2 |
----------------
-- a)
esMalvado :: Personaje -> Bool
esMalvado personaje =
  contieneElemento . buscarElementos "Malvado" $ elementos personaje

buscarElementos :: String -> [Elemento] -> [Elemento]
buscarElementos tipoDeElemento =
  filter ((== tipoDeElemento) . tipo)

contieneElemento :: [a] -> Bool
contieneElemento =
  (> 0) . length

-- b)
danioQueProduce :: Personaje -> Elemento -> Int
danioQueProduce personaje elemento =
  (salud personaje -) . salud . (ataque elemento) $ personaje

-- c)
enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje enemigos =
  filter (puedeMatarlo personaje) enemigos

puedeMatarlo :: Personaje -> Personaje -> Bool
puedeMatarlo personaje =
  any (== 0) . map salud . map ($ personaje) . map ataque . elementos

----------------
-- Ejercicio 3 |
----------------
-- a)
concentracion :: Int -> Elemento
concentracion nivelConcentracion = UnElemento {
  tipo = "Magia",
  ataque = id,
  defensa = foldl1 (.) . replicate nivelConcentracion $ meditar -- last . take (nivelConcentracion + 1) . (iterate meditar)
}

-- b)
esbirro :: Elemento
esbirro = UnElemento {
  tipo = "Malvado",
  ataque = causarDanio 1,
  defensa = id
}

esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados cantidad =
  replicate cantidad esbirro

-- c)
jack :: Personaje
jack = UnPersonaje {
  nombre = "Jack",
  salud = 300,
  elementos = [concentracion 3, katanaMagica],
  anioPresente = 200
}

katanaMagica :: Elemento
katanaMagica = UnElemento {
  tipo = "Magia",
  ataque = causarDanio 1000,
  defensa = id
}

-- d)
aku :: Int -> Int -> Personaje
aku anioActual saludIndicada = UnPersonaje {
  nombre = "Aku",
  salud = saludIndicada,
  elementos = [concentracion 4] ++ esbirrosMalvados (anioActual * 100) ++ [portalAlFuturo anioActual],
  anioPresente = anioActual
}

akuPrueba :: Int -> Int -> Personaje
akuPrueba anioActual saludIndicada = UnPersonaje {
  nombre = "Aku",
  salud = saludIndicada,
  elementos = [concentracion 4] ++ [portalAlFuturo anioActual],
  anioPresente = anioActual
}

portalAlFuturo :: Int -> Elemento
portalAlFuturo anioBase = UnElemento {
  tipo = "Magia",
  ataque = mandarAlAnio anioFuturo,
  defensa = nuevoAku anioFuturo
} where
  anioFuturo = anioBase + 2800

nuevoAku :: Int -> Personaje -> Personaje
nuevoAku anioFuturo akuOriginal = akuOriginal {
  anioPresente = anioFuturo
}

----------------
-- Ejercicio 4 |
----------------
luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor
  | (== 0) . salud $ atacante = (defensor, atacante)
  | otherwise =
    luchar defensor ((juntarAtaque defensor) ((juntarDefensa atacante) atacante))

juntarSegun :: (Elemento -> (Personaje -> Personaje)) -> [Elemento] -> (Personaje -> Personaje)
juntarSegun criterio =
  foldl1 (.) . map criterio

juntarDefensa :: Personaje -> (Personaje -> Personaje)
juntarDefensa =
  juntarSegun defensa . elementos

juntarAtaque :: Personaje -> (Personaje -> Personaje)
juntarAtaque =
  juntarSegun ataque . elementos

----------------
-- Ejercicio 5 |
----------------
f x y z
  | y 0 == z = map (fst . x z)
  | otherwise = map (snd . x (y 0))

f :: Eq a => (a -> b -> (c, c)) -> (Int -> a) -> a -> [b] -> [c]