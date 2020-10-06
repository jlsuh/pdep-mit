module TP where
import Text.Show.Functions

----------------------
-- Código inicial
----------------------

ordenarPor :: Ord a => (b -> a) -> [b] -> [b]
ordenarPor ponderacion =
  foldl (\ordenada elemento -> filter ((< ponderacion elemento).ponderacion) ordenada
                                  ++ [elemento] ++ filter ((>= ponderacion elemento).ponderacion) ordenada) []

data Demonio = Demonio {
    deudores :: [String],
    subordinados :: [Demonio]
} deriving (Show, Eq)

----------------------------------------------
-- Definí tus tipos de datos y funciones aquí
----------------------------------------------

----------------------
-- Resolución 1
----------------------

data Humano = Humano {
  nombre :: String,
  reconocimiento :: Int,
  felicidad :: Int,
  deseos :: [Deseo]
} deriving (Show)

type Deseo = (Humano -> Humano)
type Carrera = String

pazMundial :: Deseo
pazMundial unHumano = unHumano {
  nombre = nombre unHumano,
  reconocimiento = reconocimiento unHumano,
  felicidad = felicidad unHumano * 20,
  deseos = deseos unHumano
}

recibirseDeUnaCarrera :: Carrera -> Deseo
recibirseDeUnaCarrera carrera unHumano = unHumano {
  nombre = nombre unHumano,
  reconocimiento = (reconocimiento unHumano +) . (* 3) . length $ carrera,
  felicidad = felicidad unHumano + 250,
  deseos = deseos unHumano
}

serFamoso :: Deseo
serFamoso unHumano = unHumano {
  nombre = nombre unHumano,
  reconocimiento = reconocimiento unHumano + 1000,
  felicidad = 50,
  deseos = deseos unHumano
}

humanoDePrueba :: Humano
humanoDePrueba = Humano {
  nombre = "Joel",
  reconocimiento = 50,
  felicidad = 100,
  deseos = [pazMundial,
            recibirseDeUnaCarrera "Ingeniería en Sistemas de Información",
            recibirseDeUnaCarrera "Medicina",
            serFamoso]
}

-- Pruebas extras ejercicio 1 --
trump :: Humano -- en realidad no lo es
trump = Humano "Donald" 10000 1 [serFamoso,
                                  recibirseDeUnaCarrera "Culpar a China, a Rusia, a Alemania y México",
                                  recibirseDeUnaCarrera "Construir un muro"]

humanoDePrueba1 :: Humano
humanoDePrueba1 = Humano "Humano 1" 29 342 [recibirseDeUnaCarrera "Ingeniería en lavar autos a una mano"]

donQuijoteDeLaMancha :: Humano
donQuijoteDeLaMancha = Humano "Don Quijote" 40 5000 [recibirseDeUnaCarrera "Ingeniería en ver molinos a lo lejos"]

-- Fin pruebas extras ejercicio 1 --

----------------------
-- Fin resolución 1
----------------------

----------------------
-- Resolución 2
-- Se ha aplicado la función cumplirDeseo, producto de resoluciones posteriores (ver ejercicio 3)
----------------------

espiritualidad :: Humano -> (Deseo) -> Int
espiritualidad humanoOriginal unDeseo =
 felicidadObtenida humanoRealizado humanoOriginal - reconocimientoObtenido humanoRealizado humanoOriginal
  where
    humanoRealizado = cumplirDeseo humanoOriginal unDeseo

felicidadObtenida :: Humano -> Humano -> Int
felicidadObtenida humanoRealizado humanoOriginal =
  diferenciaSegunCualidad felicidad humanoRealizado humanoOriginal

reconocimientoObtenido :: Humano -> Humano -> Int
reconocimientoObtenido humanoRealizado humanoOriginal =
  diferenciaSegunCualidad reconocimiento humanoRealizado humanoOriginal
  
diferenciaSegunCualidad :: (Humano -> Int) -> Humano -> Humano -> Int
diferenciaSegunCualidad criterio unHumano otroHumano =
  criterio unHumano - criterio otroHumano

{-
*TP TP> espiritualidad humanoDePrueba (recibirseDeUnaCarrera "Medicina")
226
-}

----------------------
-- Fin resolución 2
----------------------

----------------------
-- Resolución 3
----------------------

cumplirDeseo :: Humano -> Deseo -> Humano
cumplirDeseo unHumano unDeseo =
  unDeseo unHumano

cumplirTodosSusDeseos :: Humano -> Humano
cumplirTodosSusDeseos unHumano =
  foldl cumplirDeseo unHumano . deseos $ unHumano

seriaMasFeliz :: Humano -> Bool
seriaMasFeliz unHumano =
  (felicidad unHumano <) . felicidad . cumplirTodosSusDeseos $ unHumano

{-
*TP TP> seriaMasFeliz humanoDePrueba 
False
-}

----------------------
-- Fin resolución 3
----------------------

----------------------
-- Resolución 4
----------------------

esTerrenal :: Humano -> Deseo -> Bool
esTerrenal unHumano =
  (< 150) . espiritualidad unHumano

susDeseosTerrenales :: Humano -> [Deseo]
susDeseosTerrenales unHumano =
  filter (esTerrenal unHumano) (deseos unHumano)

deseosMasTerrenales :: Humano -> [Deseo]
deseosMasTerrenales unHombre =
  ordenarPor (espiritualidad unHombre) (susDeseosTerrenales unHombre)

{-
*TP TP> map (espiritualidad humanoDePrueba) (deseosMasTerrenales humanoDePrueba) 
[-1050,139]
-}

mejorVersion :: Humano -> Humano
mejorVersion unHumano =
  head . reverse . ordenarPor sumarFelicidadYReconocimiento . map (cumplirDeseo unHumano) . deseos $ unHumano

sumarFelicidadYReconocimiento :: Humano -> Int
sumarFelicidadYReconocimiento unHumano =
  felicidad unHumano + reconocimiento unHumano

{-
*TP TP> mejorVersion humanoDePrueba                                                                                           
Humano {nombre = "Joel", reconocimiento = 50, felicidad = 2000, deseos = [<function>,<function>,<function>,<function>]}
-}

----------------------
-- Fin resolución 4
----------------------

----------------------
-- Resolución 5
----------------------

-- Ejemplos resolución 5 --

satan :: Demonio
satan = Demonio {
  deudores = [],
  subordinados = [pena, panico]
}

pena :: Demonio
pena = Demonio {
  deudores = [nombre humanoDePrueba],
  subordinados = [muerte]
}

panico :: Demonio
panico = Demonio {
  deudores = [nombre trump],
  subordinados = [tristeza]
}

tristeza :: Demonio
tristeza = Demonio {
  deudores = [nombre humanoDePrueba1],
  subordinados = []
}

muerte :: Demonio
muerte = Demonio {
  deudores = [],
  subordinados = []
}

-- Fin ejemplos resolución 5 --

tienePoderSobre :: Demonio -> Humano -> Bool
tienePoderSobre unDemonio unHumano =
  esUnDeudorSuyo unDemonio unHumano || esUnDeudorDeLosSubordinados (subordinados unDemonio) unHumano

esUnDeudorSuyo :: Demonio -> Humano -> Bool
esUnDeudorSuyo unDemonio unHumano =
  any (nombre unHumano ==) (deudores unDemonio)

esUnDeudorDeLosSubordinados :: [Demonio] -> Humano -> Bool
esUnDeudorDeLosSubordinados demonios unHumano =
  any (flip esUnDeudorSuyo unHumano) demonios

{-
*TP TP> satan `tienePoderSobre` trump
True
-}

---------------------
-- Ejericicio bonus |
---------------------

arbolDeudores :: [Demonio] -> [Demonio]
arbolDeudores demonios
  | (sum . map (length . subordinados) $ demonios) > 0 = 
    demonios ++ arbolDeudores (concatMap subordinados demonios)
  | otherwise = demonios

tienePoderSobre' :: Demonio -> Humano -> Bool
tienePoderSobre' unDemonio unHumano =
  any (flip esUnDeudorSuyo unHumano) (arbolDeudores (unDemonio:[]))

----------------------
-- Fin ejercicio bonus
----------------------

{-
Suponiendo que un demonio tiene Infinitos subordinados y/o Infinitos deudores, si se hace la derivación de la función en cuestión
mediante la evaluación perezosa:

tienePoderSobre unDemonio unHumano
esUnDeudorSuyo unDemonio unHumano || esUnDeudorDeLosSubordinados (subordinados unDemonio) unHumano
any (nombre unHumano ==) (deudores unDemonio) || esUnDeudorDeLosSubordinados (subordinados unDemonio) unHumano

Lado izquierdo de la disyunción:
Caso a)
Al poseer una función any, aplicada a una lista infinita, en caso de que encuentre el primer valor que dé verdadero
en base al criterio utilizado como primer parámetro del any, devolverá como valor el valor booleano True.

Caso b)
En caso de no poseer ningún valor que cumpla con mi condición de verdad, se obtendrá una lista infinita de False,
produciendo así un loop infinito del any.

Suponiendo que el caso a) se ha satisfecho:
Entonces la expresión quedaría:
True || esUnDeudorDeLosSubordinados (subordinados unDemonio) unHumano
True || any (flip esUnDeudorSuyo unHumano) demonios

Caso c) 
Nuevamente, al poseer un any en el lado derecho de la disyunción, se hace la misma deducción que para el lado izquierdo
(suponiendo también lista infinita). En caso de que haya un valor que por lo menos que satisfaga la condición del any,
también devolvería el valor booleano True.

Caso d)
Suponiendo nuevamente una lista infinita, en caso de no tener ningún True que satisfaga la condición del any, dicha función
quedará evaluando, entrando así en un loop infinito nuevamente como en el caso b)

Conclusión:
Podría o no permitir terminar la evaluación de un valor de verdad para las condiciones de ambos any definidas en la función principal.
-}

----------------------
-- Fin resolución 5
----------------------

----------------------
-- Resolución 6
----------------------

ayudarSiLeConviene :: Humano -> Demonio -> (Humano, Demonio)
ayudarSiLeConviene unHumano unDemonio
  | not (unDemonio `tienePoderSobre` unHumano) && tieneDeseosTerrenales unHumano =
      (cumplirDeseo unHumano elDeseoMasTerrenal, incorporarNombre unHumano unDemonio)
  | otherwise = (unHumano, unDemonio)
  where
    elDeseoMasTerrenal = head (deseosMasTerrenales unHumano)

incorporarNombre :: Humano -> Demonio -> Demonio
incorporarNombre unHumano demonioOriginal = demonioOriginal {
  deudores = deudores demonioOriginal ++ (nombre unHumano) : []
}

tieneDeseosTerrenales :: Humano -> Bool
tieneDeseosTerrenales =
  (> 0) . length. susDeseosTerrenales

-- Casos de prueba ejercicio 6 --

traicion :: Demonio
traicion = Demonio {
  deudores = [],
  subordinados = []
}

{-
*TP TP> fst (ayudarSiLeConviene humanoDePrueba traicion)
Humano {nombre = "Joel", reconocimiento = 1050, felicidad = 50, deseos = [<function>,<function>,<function>,<function>]}

*TP TP> snd (ayudarSiLeConviene humanoDePrueba traicion)
Demonio {deudores = ["Joel"], subordinados = []}
-}

plaga :: Demonio
plaga = Demonio {
  deudores = [nombre humanoDePrueba],
  subordinados = []
}

{-
*TP TP> fst (ayudarSiLeConviene humanoDePrueba plaga)   
Humano {nombre = "Joel", reconocimiento = 50, felicidad = 100, deseos = [<function>,<function>,<function>,<function>]}

*TP TP> snd (ayudarSiLeConviene humanoDePrueba plaga)
Demonio {deudores = ["Joel"], subordinados = []}
-}

hambruna :: Demonio
hambruna = Demonio {
  deudores = [],
  subordinados = [plaga, traicion]
}

{-
*TP TP> fst (ayudarSiLeConviene humanoDePrueba hambruna)
Humano {nombre = "Joel", reconocimiento = 50, felicidad = 100, deseos = [<function>,<function>,<function>,<function>]}

*TP TP> snd (ayudarSiLeConviene humanoDePrueba hambruna)
Demonio {deudores = [], subordinados = [Demonio {deudores = ["Joel"], subordinados = []},Demonio {deudores = [], subordinados = []}]}
-}

blasfemia :: Demonio
blasfemia = Demonio {
  deudores = [nombre humanoDePrueba],
  subordinados = [hambruna]
}

{-
*TP TP> fst (ayudarSiLeConviene humanoDePrueba blasfemia)
Humano {nombre = "Joel", reconocimiento = 50, felicidad = 100, deseos = [<function>,<function>,<function>,<function>]}

*TP TP> snd (ayudarSiLeConviene humanoDePrueba blasfemia)
Demonio {deudores = ["Joel"], subordinados = [Demonio {deudores = [], subordinados = [Demonio {deudores = ["Joel"], subordinados = []},
Demonio {deudores = [], subordinados = []}]}]}
-}

-- Fin casos de prueba ejercicio 6 --

----------------------
-- Fin resolución 6
----------------------
