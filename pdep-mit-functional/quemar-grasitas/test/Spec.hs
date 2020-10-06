import Library
import Test.Hspec

main :: IO ()
main = hspec $ do
   describe "Precalentamiento" $ do
    it "El ejercicio relax no impacta al gimnasta" $ do
        relax 60 gimnastaDePrueba `shouldBe` gimnastaDePrueba

    describe "Punto 1: Gimnastas saludables" $ do
        it "Un gimnasta que pesa más de 100 kilos es obeso" $ do
            -- Cambiar esto por la consulta y el valor esperado real
            esObeso (Gimnasta {peso = 110, tonificacion = 4, edad = 20}) `shouldBe` True
        it "Un gimnasta que pesa menos de 100 kilos no es obeso" $ do
            -- Cambiar esto por la consulta y el valor esperado real
            esObeso (Gimnasta {peso = 75, tonificacion = 4, edad = 20}) `shouldBe` False
        it "Un gimnasta con tonificación menor a 5 que no es obeso no está saludable" $ do
            -- Cambiar esto por la consulta y el valor esperado real
            esSaludable (Gimnasta {peso = 75, tonificacion = 4, edad = 20}) `shouldBe` False
        it "Un gimnasta con tonificación mayor a 5 que no es obeso está saludable" $ do
            -- Cambiar esto por la consulta y el valor esperado real
            esSaludable (Gimnasta {peso = 70, tonificacion = 6, edad = 20}) `shouldBe` True
        it "Un gimnasta con tonificación menor a 5 que es obeso no está saludable" $ do
            -- Cambiar esto por la consulta y el valor esperado real
            esSaludable (Gimnasta {peso = 110, tonificacion = 4, edad = 20}) `shouldBe` False
        it "Un gimnasta con tonificación mayor a 5 que es obeso no está saludable" $ do
            -- Cambiar esto por la consulta y el valor esperado real
            esSaludable (Gimnasta {peso = 110, tonificacion = 6, edad = 20}) `shouldBe` False

--    describe "Punto 2: Quemar calorías" $ do
--        it "Un gimnasta que es obeso quema 150 calorías por cada kilo" $ do
--            quemarCalorias (Gimnasta {peso = 110, tonificacion = 6, edad = 20}) 300 `shouldBe` 108