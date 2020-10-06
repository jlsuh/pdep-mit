import Test.Hspec
import Lib

main :: IO ()
main = hspec $ do
  describe "El código base anda" $ do
    it "Las funciones se pueden mostrar como <function>" $ do
      show id `shouldBe` "<function>"
    it "Máximo según anda" $ do
      maximoSegun id [4,3,6,1] `shouldBe` 6