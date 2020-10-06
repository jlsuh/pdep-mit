module Library where

---------------------------
-- Precalentamiento
---------------------------

-- Declarar el tipo de dato Gimnasta
data Gimnasta = Gimnasta {
  peso :: Int,
  tonificacion :: Int,
  edad :: Int
} deriving (Show, Eq)

-- Explicitar el tipo de esta función en base al uso esperado:
type Ejercicio = Int -> Gimnasta -> Gimnasta

relax :: Ejercicio
relax minutos gimnasta = gimnasta

-- Declarar la constante gimnastaDePrueba de tipo Gimnasta
-- para usarlo desde las pruebas (Spec.hs) y/o desde la consola
gimnastaDePrueba :: Gimnasta
gimnastaDePrueba = Gimnasta{
  peso = 60,
  tonificacion = 5,
  edad = 40
}

-------------------------------------
-- Punto 1: Gimnastas saludables
-------------------------------------
esSaludable :: Gimnasta -> Bool
esSaludable gimnasta =
  (not . esObeso) gimnasta && esTonificado gimnasta

esObeso :: Gimnasta -> Bool
esObeso  =
  (>= 100) . peso

esTonificado :: Gimnasta -> Bool
esTonificado =
  (>= 5) . tonificacion

---------------------------
-- Punto 2: Quemar calorías
---------------------------
quemarCalorias :: Int -> Gimnasta -> Gimnasta
quemarCalorias calorias gimnasta
  | esObeso gimnasta = bajarKilos (calorias `div` 150) gimnasta
  | (not . esObeso) gimnasta && edad gimnasta > 30 && calorias > 200 = bajarKilos 1 gimnasta
  | otherwise = bajarKilos (calorias `div` (peso gimnasta * edad gimnasta)) gimnasta

-- bajarPeso' :: Int -> Gimnasta -> Gimnasta
-- bajarPeso' pesosBajados (Gimnasta peso tonificacion edad) =
--  Gimnasta (peso - pesosBajados) tonificacion edad

bajarKilos :: Int -> Gimnasta -> Gimnasta
bajarKilos kilosABajar gimnasta = Gimnasta {
  tonificacion = tonificacion gimnasta,
  edad = edad gimnasta,
  peso = peso gimnasta - kilosABajar
}
-- esta forma es del agrado de la profe <3

-- bajarPeso'' :: Int -> Gimnasta -> Gimnasta
-- bajarPeso'' kilosABajar gimnastaOriginal =
--  gimnastaOriginal {peso = peso gimnastaOriginal - kilosABajar}

---------------------------
-- Punto 3: Ejercicios
---------------------------
pesas :: Int -> Int -> Gimnasta -> Gimnasta
pesas kilosLevantados minutos gimnasta
  | minutos > 10 = tonificar (kilosLevantados `div` 10) gimnasta
  | otherwise = gimnasta

tonificar :: Int -> Gimnasta -> Gimnasta
tonificar tonificacionObtenida gimnastaOriginal =
  gimnastaOriginal {
    tonificacion = tonificacion gimnastaOriginal + tonificacionObtenida
  }

ejercitarEnCinta :: Int -> Int -> Gimnasta -> Gimnasta
ejercitarEnCinta velocidadPromedio minutos =
  quemarCalorias (velocidadPromedio * minutos)

caminata :: Int -> Gimnasta -> Gimnasta
caminata minutos gimnasta =
  ejercitarEnCinta 5 minutos gimnasta

entrenamientoEnCinta :: Int -> Gimnasta -> Gimnasta
entrenamientoEnCinta minutos gimnasta =
  ejercitarEnCinta velocidadPromedio minutos gimnasta
  where
    velocidadInicial = 6
    velocidadFinal = velocidadInicial + minutos `div` 5
    velocidadPromedio = (velocidadInicial  + velocidadFinal) `div` 2

colina :: Int -> Int -> Gimnasta -> Gimnasta
colina minutos inclinacion gimnasta =
  quemarCalorias (2 * minutos * inclinacion) gimnasta

montania :: Int -> Int -> Gimnasta -> Gimnasta
montania minutos inclinacion =
  tonificar 1 . (colina duracion (inclinacion + 3)) . (colina duracion inclinacion)
  where
    duracion = minutos `div` 2