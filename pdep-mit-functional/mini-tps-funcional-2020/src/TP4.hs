module TP4 where
import Video
import EdicionVideos
import Data.Char

-- Definir las funciones de acuerdo a lo indicado en las consignas del TP4

-------------------------
-- Hashtags
-------------------------

-- 1)
tieneHashtag :: String -> Video -> Bool
tieneHashtag hashtag =
  elem (hashtagEnMinuscula hashtag) . hashtagsDeUnVideoEnMinuscula
--  where
--    hashtagsSegmentadosEnMinuscula = words . hashtagEnMinuscula . hashtags

hashtagEnMinuscula :: String -> String
hashtagEnMinuscula = map toLower

hashtagsDeUnVideoEnMinuscula :: Video -> [String]
hashtagsDeUnVideoEnMinuscula =
  map hashtagEnMinuscula . words . hashtags

-- 2)
estanRelacionados :: Video -> Video -> Bool
estanRelacionados unVideo otroVideo =
  listaEsMayorQue 3 listaDeHashtagsCoincidentes
  where
    listaDeHashtagsCoincidentes = coincidencias (hashtagsDeUnVideoEnMinuscula unVideo) otroVideo

listaEsMayorQue :: Int -> [String] -> Bool
listaEsMayorQue numero lista =
  length lista >= numero
  
coincidencias :: [String] -> Video -> [String]
coincidencias unaListaDeHashtag otroVideo =
  filter (flip tieneHashtag otroVideo) unaListaDeHashtag

-- coincidencias :: [String] -> Video -> [String]
-- coincidencias unaListaDeHashtag otroVideo =
--   filter (`tieneHashtag` otroVideo) unaListaDeHashtag

-- 3)
agregarHashtag :: String -> Video -> Video
agregarHashtag hashtagNuevo unVideo
  | (not . tieneHashtag hashtagNuevo) unVideo = videoConNuevoHashtag hashtagNuevo unVideo
  | otherwise = unVideo

agregarHashtags :: [String] -> Video -> Video
agregarHashtags nuevosHashtags unVideo =
  foldr agregarHashtag unVideo nuevosHashtags
-- (String -> Video -> Video) -> Video -> [String] -> Video

-- plain old
videoConNuevoHashtag :: String -> Video -> Video
videoConNuevoHashtag hashtagNuevo unVideo = Video {
  titulo = titulo unVideo,
  duracion = duracion unVideo,
  hashtags = hashtags unVideo ++ " " ++ hashtagNuevo
}

-- with sugar
-- videoConNuevoHashtag :: String -> Video -> Video
-- videoConNuevoHashtag hashtagNuevo videoOriginal = videoOriginal {
--   hashtags = hashtags videoOriginal ++ " " ++ hashtagNuevo
-- }

-------------------------
-- Edicion de videos
-------------------------
-- 1)
subir :: Video -> VideoVersionado
subir video = Version {
  versionActual = video,
  versionesAnteriores = []
}

-- 2)
editar :: (Video -> Video) -> VideoVersionado -> VideoVersionado
editar funcionalidad unVideoVersionado
  | aplicarFuncionalidad funcionalidad unVideoVersionado /= versionActual unVideoVersionado =
      nuevaVersionDeVideo funcionalidad unVideoVersionado
  | otherwise = unVideoVersionado

nuevaVersionDeVideo :: (Video -> Video) -> VideoVersionado -> VideoVersionado
nuevaVersionDeVideo funcionalidad videoVersionadoOriginal = Version {
  versionActual = aplicarFuncionalidad funcionalidad videoVersionadoOriginal,
  versionesAnteriores = versionActual videoVersionadoOriginal : versionesAnteriores videoVersionadoOriginal
}

aplicarFuncionalidad :: (Video -> Video) -> VideoVersionado -> Video
aplicarFuncionalidad funcionalidad unVideoVersionado =
  funcionalidad (versionActual unVideoVersionado)

-- 3)
postProcesamiento :: String -> (Int, Int, Int) -> Video -> VideoVersionado
postProcesamiento nuevoNombre duracionAReducir =
  editarConRecorte . editarConRenombre . subir
  where
    editarConRecorte = editar (recortar duracionAReducir)
    editarConRenombre = editar (renombrar nuevoNombre)