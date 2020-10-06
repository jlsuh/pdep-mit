module Video where

-- Definir acá el data Video usando la notación que vimos en clase
data Video = Video {
  titulo :: String,
  duracion :: (Int, Int, Int),
  hashtags :: String
} deriving (Show, Eq)

-- Crear los siguientes videos de prueba con las duraciones
-- que se indicaban en la consigna:

videoMuyLargo = Video {
  titulo = "unoMuyLargo",
  duracion = (1,15,45),
  hashtags = "muyLargo"
}

videoNormal = Video {
  titulo = "unoNormal",
  duracion = (0,32,12),
  hashtags = "normal"
}

videoCorto = Video {
    titulo = "unoCorto",
  duracion = (0,10,59),
  hashtags = "corto"
}

otroVideoCorto = Video {
  titulo = "otroUnoCorto",
  duracion = (0,10,20),
  hashtags = "otroCorto"
}