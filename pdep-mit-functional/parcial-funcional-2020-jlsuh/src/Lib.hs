{-
Nombre: Suh, Joel
Legajo: 167231-9
-}

module Lib where
import Text.Show.Functions

----------------------
-- Código inicial
----------------------

maximoSegun :: Ord a => (b -> a) -> [b] -> b
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (p -> a) -> p -> p -> p
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- Esto inicialmente es esperable que no compile
-- porque no existen los tipos Rol y Participante.
-- Definilos en el punto 1a
data Desafio = Desafio {
    rolesDisponibles :: [Rol],
    pruebaASuperar :: Participante -> Bool
  }

----------------------------------------------
-- Definí tus tipos de datos y funciones aquí
-- indicando a qué punto pertenecen
----------------------------------------------

-- Punto 1a
data Participante = UnParticipante {
  nombre :: String,
  experiencia :: Int,
  inteligencia :: Int,
  destrezaFisica :: Int,
  aptitud :: Aptitud
} deriving (Show)

-- data Rol = UnRol {
--   aptitud :: Participante -> Int
-- } deriving (Show)

type Rol = Participante -> Int
type Aptitud = Rol

indeterminado :: Rol
indeterminado participante =
  inteligencia participante + destrezaFisica participante
-- indeterminado participante = UnRol {
--   aptitud = inteligencia participante + destrezaFisica participante
-- }

soporte :: Rol
soporte participante =
  experiencia participante + (7 * (inteligencia $ participante))

-- soporte participante = UnRol {
--   aptitud = (+ experiencia participante) . (* 7) . inteligencia $ participante
-- }

primeraLinea :: Int -> Rol
primeraLinea potenciaArma participante =
  (`div` 100) . (potenciaArma +) . destrezaFisica $ participante

-- Punto 1b
participante :: Participante
participante = UnParticipante {
  nombre = "Participante",
  experiencia = 10,
  inteligencia = 20,
  destrezaFisica = 12,
  aptitud = indeterminado
}

-- Etc...

-- Punto 1c
poderParticipante :: Participante -> Int
poderParticipante unParticipante =
  (experiencia unParticipante *) . (aptitud unParticipante) $ participante

-- Punto 1d
payaso :: Rol
payaso unParticipante =
  experiencia unParticipante + inteligencia unParticipante

{-
No fue necesario, puesto que payaso es un Rol, el cual el mismo recibe un participante y devuelve un entero como resultado, siendo
la aptitud del participante para dicho rol.
-}

-- Punto 2
nuevoRol :: Participante -> [Rol] -> Participante
nuevoRol participanteOriginal roles = participanteOriginal {
  aptitud = elRolMasApto participanteOriginal roles
}

elRolMasApto :: Participante -> [Rol] -> Rol
elRolMasApto participante roles =
  maximoSegun (flip laAptitud participante) roles
                      -- Rol -> Int

laAptitud :: Rol -> Participante -> Int
laAptitud unRol =
  unRol

{-
Consulta:
*Lib> poderParticipante . nuevoRol participante $ [indeterminado, primeraLinea 500, soporte, payaso]
1500
-}

-- maximoSegun :: Ord a => (b -> a) -> [b] -> b
-- type Rol = Participante -> Int

-- Punto 3a
seEncuentraEnUnGrupo :: Participante -> [Participante] -> Bool
seEncuentraEnUnGrupo participante = 
  elem (nombre participante) . map nombre

-- Punto 3b
experienciaAGanar :: [Participante] -> [Participante] -> Int
experienciaAGanar participantes ganadores =
  (+ 100) . (`div` (length $ ganadores)) . sumarExperiencia . filter (flip esPerdedor ganadores) $ participantes

sumarExperiencia :: [Participante] -> Int
sumarExperiencia =
  sum . map experiencia

esPerdedor :: Participante -> [Participante] -> Bool
esPerdedor participante ganadores =
  not . seEncuentraEnUnGrupo participante $ ganadores

-- Punto 3c
repartirExperiencia :: [Participante] -> [Participante] -> [Participante]
repartirExperiencia participantes ganadores =
  map (ganarExperiencia experienciaRepartida) ganadores
  where
    experienciaRepartida = experienciaAGanar participantes ganadores

ganarExperiencia :: Int -> Participante -> Participante
ganarExperiencia experienciaGanada participanteOriginal = participanteOriginal {
  experiencia = experiencia participanteOriginal + experienciaGanada
}

-- Punto 4a
encararDesafio :: Desafio -> [Participante] -> [Participante]
encararDesafio desafio participantes =      -- Participante -> Bool                                 -- [Rol]
  repartirExperiencia participantes . filtrarLosQueAprueban desafio . map (flip nuevoRol participantesConRolesMasAptos) $ participantes
  where
    participantesConRolesMasAptos = (map (elegirRolMasApto desafio) participantes) -- [Rol]

filtrarLosQueAprueban :: Desafio -> [Participante] -> [Participante]
filtrarLosQueAprueban desafio =
  filter (pruebaASuperar desafio)

elegirRolMasApto :: Desafio -> Participante -> Rol
elegirRolMasApto desafio participantes =
  elRolMasApto participante (rolesDisponibles desafio)

-- elRolMasApto :: Participante -> [Rol] -> Rol
-- nuevoRol :: Participante -> [Rol] -> Participante

-- Punto 4b
{-
-- i: any ((> 1000) . experiencia) (encararDesafio unDesafioCualquiera listaDeParticipantes)

-- ii: maximoSegun poderParticipante (encararDesafio unDesafioCualquiera listaDeParticipantes)
-}

-- Punto 4c
{-
Aplicando lazy evaluation para ambos casos:
Para la consulta i):
any ((> 1000) . experiencia) (encararDesafio unDesafioCualquiera listaDeParticipantes)
suponiendo que ya se obtuvo la lista de ganadores del desafío:
any ((> 1000) . experiencia) [ganador1, ganador2, ganador3, ..., ganadorEnésimo]
-> La consulta podrá finalizarse <=> se encuentre algún ganador en donde la experiencia sea mayor que 1000; en otras palabras,
gracias a la evaluación perezosa de haskell, al encontrar el primero que cumpla la condición, dejará de evaluar y retornará verdadero
Falso en caso contrario.
-> En caso de no encontrar ninguno que cumpla la condición de verdad, se seguirá evaluando de la misma manera, entrando en un loop infinito.

Para la consulta ii):
maximoSegun poderParticipante (encararDesafio unDesafioCualquiera listaDeParticipantes)
suponiendo que ya se obtuvo la lista de ganadores del desafío:
maximoSegun poderParticipante [ganador1, ganador2, ganador3, ..., ganadorEnésimo]
En este caso no se podrá finalizar la evaluación del foldl1, definida en la función maximoSegun, para la lista infinita,
pues nunca se determinará el ganador que posea el mayor poderParticipante de la lista de ganadores:
maximoSegun poderParticipante [ganador1, ganador2, ganador3, ..., ganadorEnésimo]
foldl1 (mayorSegun poderParticipante) [ganador1, ganador2, ganador3, ..., ganadorEnésimo]
foldl1 (mayorSegun poderParticipante) [ganadorEntre1Y2, ganador3, ..., ganadorEnésimo]
foldl1 (mayorSegun poderParticipante) [ganadorEntre1Y2Y3, ..., ganadorEnésimo]
foldl1 (mayorSegun poderParticipante) [ganadorEntre1Y2Y3YEnésimo, ...]
Por lo que la función nunca terminará de evaluar la lista infinita de Participantes.
-}

-- Punto 5
type Torneo = [Desafio]

competirEnTorneo :: Torneo -> [Participante] -> [Participante]
competirEnTorneo [ultimoTorneo] participantes = encararDesafio ultimoTorneo participantes
competirEnTorneo (d:ds) participantes =
  competirEnTorneo ds (encararDesafio d participantes)
