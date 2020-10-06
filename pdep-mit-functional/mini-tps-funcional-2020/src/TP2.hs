module TP2 where
import Video

-- Definir las funciones de acuerdo a lo indicado en las consignas del TP2
-- y explicitar su tipo
-- 1)
esMasLargo :: Video -> Video -> Bool
esMasLargo unVideo otroVideo =
  duracion unVideo > duracion otroVideo

-- 2)
horas_en_minutos :: Int -- no place for hardcoding
horas_en_minutos = 60

estampaHorariaEnMinutos :: (Int, Int, Int) -> Int
estampaHorariaEnMinutos (hora, minuto, _) = hora * horas_en_minutos + minuto

duracionEnMinutos :: Video -> Int
duracionEnMinutos unVideo =
  estampaHorariaEnMinutos (duracion unVideo)

-- 3)
porcentajeDeReproduccionPromedio :: Int -> (Int, Int, Int) -> Video -> Int
porcentajeDeReproduccionPromedio cantidadVisitas tiempoReproducido unVideo =
  ((estampaHorariaEnMinutos tiempoReproducido * 100) `div` cantidadVisitas) `div` duracionEnMinutos unVideo