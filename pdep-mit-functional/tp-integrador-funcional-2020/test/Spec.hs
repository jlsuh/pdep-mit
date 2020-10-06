import Test.Hspec
import TP

main :: IO ()
main = hspec $ do
  describe "El código base anda y el TP compila" $ do
    it "Las funciones se pueden mostrar como <function>" $ do
      show id `shouldBe` "<function>"
    it "Ordenar por ... ordena" $ do
      ordenarPor id [4,3,6,1] `shouldBe` [1,3,4,6]