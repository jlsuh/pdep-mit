-- consigna: https://docs.google.com/document/d/1ivhqJIWGanstr324ElRY6lev0b0UN-QN3kcYFH9wqMs/edit#

module GravityFalls where

import Text.Show.Functions

-------------
-- Parte 1  |
-------------
----------------
-- Ejercicio 1 |
----------------
data Criatura = UnaCriatura {
  peligrosidad :: Float,
  condiciones :: [Condicion]
} deriving (Show)

type Condicion = Persona -> Bool
type Item = String

data Persona = UnaPersona {
  edad :: Int,
  items :: [Item],
  experiencia :: Float
} deriving (Show, Eq)

siempreDetras :: Criatura
siempreDetras = UnaCriatura {
  peligrosidad = 0,
  condiciones = []
}

gnomos :: Float -> Criatura
gnomos cantidad = UnaCriatura {
  peligrosidad = 2 ** cantidad,
  condiciones = [elem "Sopladora de hojas" . items]
}

fantasma :: Float -> [Condicion] -> Criatura
fantasma categoria condiciones = UnaCriatura {
  peligrosidad = (* 20) $ categoria,
  condiciones = condiciones
}

----------------
-- Ejercicio 2 |
----------------
enfrentarCriatura :: Persona -> Criatura -> Persona
enfrentarCriatura unaPersona unaCriatura
  | puedeDeshacerse unaPersona unaCriatura = ganarExperiencia unaPersona (peligrosidad unaCriatura)
  | otherwise = ganarExperiencia unaPersona 1

puedeDeshacerse :: Persona -> Criatura -> Bool
puedeDeshacerse persona (UnaCriatura _ []) = False
puedeDeshacerse persona criatura =
  foldl1 (&&) . (map ($ persona) . condiciones) $ criatura
-- all (== True) . (map ($ persona) . condiciones) $ criatura
-- no utilizar: all (== True)

{-
*GravityFalls> puedeDeshacerse dipper (fantasma 3 [elem "Disfraz de oveja" . items])
True
-}

----------------
-- Ejercicio 3 |
----------------
-- a)
ganarExperiencia :: Persona -> Float -> Persona
ganarExperiencia personaOriginal experienciaGanada = personaOriginal {
  experiencia = experiencia personaOriginal + experienciaGanada
}

cuantaExperienciaPuedeGanar :: Persona -> [Criatura] -> Float
cuantaExperienciaPuedeGanar persona grupoDeCriaturas
  | contieneAlMonstruo siempreDetras grupoDeCriaturas = calcularExperiencia + 1
  | otherwise = calcularExperiencia
  where
    calcularExperiencia =
      (experiencia . foldl enfrentarCriatura persona . takeWhile (puedeDeshacerse persona) $ grupoDeCriaturas) - experiencia persona
    -- calcularExperiencia = (sum . takeWhile (/= 1) . map (flip (-) (experiencia persona))
    --   . map experiencia . map (enfrentarCriatura persona) $ grupoDeCriaturas)

-- Corrección: se ha aplanado el uso con foldl

-- foldl1 (+) . map (enfrentarCriatura persona) $ grupoDeCriaturas

-- sum . takeWhile (/= experiencia persona + 1) . map experiencia . map (enfrentarCriatura persona) $ grupoDeCriaturas
-- se ha supuesto que la persona puede enfretar a la criatura <=> no se le ha sumado en 1 a la experiencia
-- cuantaExperienciaPuedeGanar dipper [siempreDetras, gnomos 10, fantasma 3 [(< 13) . edad, elem "Disfraz de oveja" . items]]
-- map experiencia (map (enfrentarCriatura dipper) [siempreDetras, gnomos 10, fantasma 3 [(< 13) . edad, elem "Disfraz de oveja" . items]])
-- sum (takeWhile (/= 1) (map (flip (-) (experiencia dipper)) (map experiencia (map (enfrentarCriatura dipper) [siempreDetras, gnomos 10, fantasma 3 [(< 13) . edad, elem "Disfraz de oveja" . items]])))) + 1

contieneAlMonstruo :: Criatura -> [Criatura] -> Bool
contieneAlMonstruo criatura =
  elem (show criatura) . (map show)

-- b)
dipper :: Persona
dipper = UnaPersona {
  edad = 13,
  items = ["Disfraz de oveja", "Sopladora de hojas"],
  experiencia = 12
}

{-
*GravityFalls> cuantaExperienciaPuedeGanar dipper [(fantasma 3 [elem "Disfraz de oveja" . items]), (fantasma 3 [elem "Disfraz de oveja" . items]), gnomos 5, siempreDetras]
153.0
-}

mabel :: Persona
mabel = UnaPersona {
  edad = 12,
  items = [],
  experiencia = 11
}

{-
*GravityFalls> cuantaExperienciaPuedeGanar mabel [fantasma 1 [(> 10) . experiencia]]
21.0
-}

------------
-- Parte 2 |
------------
----------------
-- Ejercicio 1 |
----------------
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf _ _ [] _ = []
zipWithIf _ _ _ [] = []
zipWithIf funcion condicion listaUno listaDos
  | condicion . head $ listaDos = ((head listaUno) `funcion` (head listaDos)):[] ++ zipWithIf funcion condicion (tail listaUno) (tail listaDos)
  | otherwise = (head listaDos):[] ++ zipWithIf funcion condicion listaUno (tail listaDos)

{-
*GravityFalls> zipWithIf (*) even [10..50] [1..7]  
[1,20,3,44,5,72,7]
-}

----------------
-- Ejercicio 2 |
----------------

-- a)
abecedarioDesde :: Char -> [Char]
abecedarioDesde letra =
  init . ([letra .. 'z'] ++) $ ['a' .. letra]

{-
*GravityFalls> abecedarioDesde 'y'
"yzabcdefghijklmnopqrstuvwx"
-}

-- b)
desencriptarLetra :: Char -> Char -> Char
desencriptarLetra letraClave letraADesencriptar =
  last . take (length (takeWhile (/= letraADesencriptar) (abecedarioDesde letraClave)) + 1) $ abecedarioDesde 'a'

{-
*GravityFalls> desencriptarLetra 'x' 'b'                                                                
'e'
-}

-- c)
cesar ::  Char -> String -> String
cesar letraClave textoEncriptado =
  zipWithIf (desencriptarLetra) (esLetra) (repeat letraClave) textoEncriptado
-- "jrzel zrfaxal!"
-- map (flp cesar "texto") ['a'..'z']

esLetra :: Char -> Bool
esLetra =
  flip elem ['a' .. 'z']

-- d)
{-
*GravityFalls> map (flip cesar "jrzel zrfaxal!") ['a'..'z']
["jrzel zrfaxal!","iqydk yqezwzk!","hpxcj xpdyvyj!","gowbi wocxuxi!","fnvah vnbwtwh!","emuzg umavsvg!","dltyf tlzuruf!",
"cksxe skytqte!","bjrwd rjxspsd!","aiqvc qiwrorc!","zhpub phvqnqb!","ygota ogupmpa!","xfnsz nftoloz!","wemry mesnkny!",
"vdlqx ldrmjmx!","uckpw kcqlilw!","tbjov jbpkhkv!","sainu iaojgju!","rzhmt hznifit!","qygls gymhehs!","pxfkr fxlgdgr!",
"owejq ewkfcfq!","nvdip dvjebep!","mucho cuidado!","ltbgn bthczcn!","ksafm asgbybm!"]
-}

-----------------------
-- Ejercicio 3) Bonus |
-----------------------
vignere :: String -> String -> String
vignere palabraClave textoEncriptado =
  zipWithIf (desencriptarLetra) (esLetra) (cycle palabraClave) textoEncriptado

-- "wrpp, irhd to qjcgs!"

-----------------------
-- Versión alto orden |
-----------------------
encriptarSegun :: String -> String -> String
encriptarSegun clave textoEncriptado =
  zipWithIf (desencriptarLetra) (esLetra) clave textoEncriptado
-- (Char -> Char -> Char) -> (Char -> Bool) -> [Char] -> [Char] -> [Char]

cesar' :: Char -> String -> String
cesar' letraClave textoEncriptado =
  encriptarSegun (repeat letraClave) textoEncriptado

vignere' :: String -> String -> String
vignere' palabraClave textoEncriptado =
  encriptarSegun (cycle palabraClave) textoEncriptado