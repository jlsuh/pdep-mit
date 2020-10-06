Consigna: https://docs.google.com/document/d/1BepktcQsT2GVsduUq8ldi6JXZ4u3A9cjyc-cxZcdQBE/edit#heading=h.1gbtavw6o1gk

module CrystalGems where

import Text.Show.Functions

data Aspecto = UnAspecto {
 tipoDeAspecto :: String,
 grado :: Float
} deriving (Show, Eq)

aspectoUno :: Aspecto
aspectoUno = UnAspecto {
  tipoDeAspecto = "Uno",
  grado = 10
}

otroAspectoUno :: Aspecto
otroAspectoUno = UnAspecto {
  tipoDeAspecto = "Uno",
  grado = 12
}

aspectoDos :: Aspecto
aspectoDos = UnAspecto {
  tipoDeAspecto = "Dos",
  grado = 20
}

otroAspectoDos :: Aspecto
otroAspectoDos = UnAspecto {
  tipoDeAspecto = "Dos",
  grado = 22
}

aspectoTres :: Aspecto
aspectoTres = UnAspecto {
  tipoDeAspecto = "Tres",
  grado = 30
}

otroAspectoTres :: Aspecto
otroAspectoTres = UnAspecto {
  tipoDeAspecto = "Tres",
  grado = 32
}

aspectoCuatro :: Aspecto
aspectoCuatro = UnAspecto {
  tipoDeAspecto = "Cuatro",
  grado = 40
}

otroAspectoCuatro :: Aspecto
otroAspectoCuatro = UnAspecto {
  tipoDeAspecto = "Cuatro",
  grado = 42
}

-- type Situacion = [Aspecto]

data Situacion = UnaSituacion {
  aspectos :: [Aspecto],
  tension :: Float,
  incertidumbre :: Float,
  peligro :: Float
} deriving (Show, Eq)

situacionUno :: Situacion
situacionUno = UnaSituacion {
  aspectos = [aspectoUno, aspectoDos, aspectoCuatro, aspectoTres],
  tension = 10,
  incertidumbre = 20,
  peligro = 8
}

situacionDos :: Situacion
situacionDos = UnaSituacion {
  aspectos = [otroAspectoTres, otroAspectoDos, otroAspectoCuatro, otroAspectoUno],
  tension = 8,
  incertidumbre = 12,
  peligro = 19
}

mejorAspecto mejor peor =
  grado mejor < grado peor

buscarAspecto aspectoBuscado =
  head.filter (mismoAspecto aspectoBuscado)
buscarAspectoDeTipo tipo =
  buscarAspecto (UnAspecto tipo 0)

mismoAspecto aspecto1 aspecto2 =
  tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2
reemplazarAspecto aspectoBuscado situacion =
 aspectoBuscado : (filter (not.mismoAspecto aspectoBuscado) situacion)

----------------
-- Ejercicio 1 |
----------------

-- a)
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto funcion aspectoOriginal = aspectoOriginal {
  grado = funcion . grado $ aspectoOriginal
}
  
-- b)
esMejorQueOtra :: Situacion -> Situacion -> Bool
esMejorQueOtra unaSituacion otraSituacion =
  all (== True) . zipWith mejorAspecto (aspectos unaSituacion) $ (emparejarSegundaRespectoDePrimera (aspectos unaSituacion) (aspectos otraSituacion))
  
emparejarSegundaRespectoDePrimera :: [Aspecto] -> [Aspecto] -> [Aspecto]
emparejarSegundaRespectoDePrimera [] listaDos = reverse listaDos
emparejarSegundaRespectoDePrimera (x:xs) listaDos =
  emparejarSegundaRespectoDePrimera xs . reemplazarAspecto (buscarAspectoDeTipo (tipoDeAspecto x) listaDos) $ listaDos
--  emparejarSegundaRespectoDePrimera xs (reemplazarAspecto (buscarAspectoDeTipo (tipoDeAspecto x) listaDos) listaDos)

-- c)
modificarSituacion :: Float -> String -> [Aspecto] -> [Aspecto]
modificarSituacion nuevoGrado tipoBuscado situacionOriginal =
  reemplazarAspecto (modificarGradoDeAspecto nuevoGrado . buscarAspectoDeTipo tipoBuscado $ situacionOriginal) situacionOriginal

modificarGradoDeAspecto :: Float -> Aspecto -> Aspecto
modificarGradoDeAspecto nuevoGrado aspectoOriginal = aspectoOriginal {
  grado = nuevoGrado
}

----------------
-- Ejercicio 2 |
----------------

-- a)
data Gema = UnaGema {
  nombre :: String,
  fuerza :: Float,
  personalidad :: Personalidad
} deriving (Show)

type Personalidad = Situacion -> Situacion

-- b)
vidente :: Personalidad
vidente situacionOriginal = situacionOriginal {
  tension = tension situacionOriginal - 10,
  incertidumbre = (/ 2) . incertidumbre $ situacionOriginal
}

relajada :: Float -> Personalidad
relajada nivelRelajamiento situacionOriginal = situacionOriginal {
  tension = tension situacionOriginal - 30,
  peligro = peligro situacionOriginal + nivelRelajamiento
}

-- c)

{-
*CrystalGems> (UnaGema "Vidente" 20 vidente)
UnaGema {nombre = "Vidente", fuerza = 20, personalidad = <function>}
-}

{-
*CrystalGems> (UnaGema "Descuidada" 30 (relajada 20))
UnaGema {nombre = "Descuidada", fuerza = 30, personalidad = <function>}
-}

gemaVidente = UnaGema {
  nombre = "Vidente",
  fuerza = 20,
  personalidad = vidente
}

gemaDescuidada = UnaGema {
  nombre = "Descuidada",
  fuerza = 30,
  personalidad = relajada 30
}

----------------
-- Ejercicio 3 |
----------------

gemaLeGanaAOtra :: Gema -> Gema -> Situacion -> Bool
gemaLeGanaAOtra unaGema otraGema situacion =
  tieneMasFuerza unaGema otraGema && esMejorQueOtra situacionResultanteUnaGema situacionResultanteOtraGema
  where
    situacionResultanteUnaGema = personalidad unaGema $ situacion
    situacionResultanteOtraGema = personalidad otraGema $ situacion
    
tieneMasFuerza :: Gema -> Gema -> Bool
tieneMasFuerza unaGema otraGema =
  fuerza unaGema > fuerza otraGema

----------------
-- Ejercicio 4 |
----------------
fusion :: Situacion -> Gema -> Gema -> Gema
fusion situacionOriginal unaGema otraGema =
  unificarGemas unaGema otraGema (reducirGradosDeAspectosDeUnaSituacion 10 situacionOriginal)

reducirGradosDeAspectosDeUnaSituacion :: Float -> Situacion -> Situacion
reducirGradosDeAspectosDeUnaSituacion gradosAReducir situacionOriginal = situacionOriginal {
  aspectos = map (reducirGradosEn gradosAReducir) (aspectos situacionOriginal)
}
reducirGradosEn :: Float -> Aspecto -> Aspecto
reducirGradosEn gradosAReducir aspectoOriginal = aspectoOriginal {
  grado = grado aspectoOriginal - gradosAReducir
}

unificarGemas :: Gema -> Gema -> Situacion -> Gema
unificarGemas unaGema otraGema situacion = UnaGema {
  nombre = fusionarNombre (nombre unaGema) (nombre otraGema),
  fuerza = fusionarFuerza unaGema otraGema situacion,
  personalidad = fusionarPersonalidad unaGema otraGema situacion
}

fusionarNombre :: String -> String -> String
fusionarNombre unNombre otroNombre
  | unNombre /= otroNombre = unNombre ++ " " ++ otroNombre
  | otherwise = unNombre

fusionarPersonalidad :: Gema -> Gema -> Situacion -> Personalidad
fusionarPersonalidad unaGema otraGema situacion =
  personalidad unaGema . personalidad otraGema

fusionarFuerza :: Gema -> Gema -> Situacion -> Float
fusionarFuerza unaGema otraGema situacion
  | sonCompatibles unaGema otraGema situacion = (* 10) . sum . map fuerza $ [unaGema, otraGema]
  | otherwise = (* 7) . fuerza $ gemaDominante unaGema otraGema

gemaDominante :: Gema -> Gema -> Gema
gemaDominante unaGema otraGema
  | fuerza unaGema > fuerza otraGema = unaGema
  | otherwise = otraGema

sonCompatibles :: Gema -> Gema -> Situacion -> Bool
sonCompatibles unaGema otraGema situacion =
  esMejorQueOtra situacionPersonalidadFusionada situacion &&
  esMejorQueOtra situacionPrimerGema situacion &&
  esMejorQueOtra situacionSegundaGema situacion
  where
    situacionPersonalidadFusionada = fusionarPersonalidad unaGema otraGema situacion $ situacion
    situacionPrimerGema = personalidad unaGema $ situacion
    situacionSegundaGema = personalidad otraGema $ situacion

----------------
-- Ejercicio 5 |
----------------

fusionGrupal :: Situacion -> [Gema] -> Gema
fusionGrupal situacion =
  foldl1 (fusion situacion)

{-
*CrystalGems> fusionGrupal situacionUno [gemaVidente, gemaDescuidada, (UnaGema "RrecontraDescuidada" 50 (relajada 100))]
UnaGema {nombre = "Vidente Descuidada RrecontraDescuidada", fuerza = 1470.0, personalidad = <function>}
-}

----------------
-- Ejercicio 6 |
----------------
   --  x ->      y      ->       z       -> algo -> Bool
foo :: a -> (a -> Bool) -> (a -> [Bool]) -> a -> Bool
foo x y z =
  any (== y x) . z

-- como ya "y" es un booleano que está del otro lado de la equivalencia (==), "z" debe devolver una lista de booleanos

-- a)
y :: a -> a -> Bool 
y = undefined
x :: a
x = undefined
z :: a -> [a]
z = undefined

-- b)
{-
Invocaciones de la función:
foo 5 (+7) [1..]
foo 3 even (map (< 7))
foo 3 even [1, 2, 3]
foo [1..] head (take 5) [1.. ]

foo :: a -> (a -> Bool) -> (a -> [Bool]) -> a -> Bool
foo x y z =
  any (== y x) . z

foo 5 (+7) [1..]
foo 3 even (map (< 7))
foo 3 even [1, 2, 3]
En estos tres casos no tiparán, pues se ausenta el 4to parámetro de la función, denotada con point-free.

foo [1..] head (take 5) [1.. ]
En este caso no tipará, pues el primer y cuarto parámetro son listas, cuando deberían ser elementos atómicos.
Además, las funciones head y take, nunca retornarán booleanos, o en su defecto, lista de booleanos.
-}