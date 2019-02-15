namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  CrytoTests = public class(Test)
  public
    method BCDDecrypter;
    begin
      Assert.AreEqual(TestApplication2.DoBCDDecrypterTest(), 'exampleplaintext');
      Assert.AreEqual(TestApplication2.DoBCDEncrypterTest(), 'exampleplaintext');
    end;

    method NewCFB;
    begin
      Assert.AreEqual(TestApplication2.NewCFBDecrypter(), 'some plaintext');
      Assert.AreEqual(TestApplication2.NewCFBencrypter(), 'some plaintext');
    end;

    method NewCTR;
    begin
      Assert.AreEqual(TestApplication2.NewCTR(), 'some plaintext');
    end;

    method NewOFB;
    begin
      Assert.AreEqual(TestApplication2.DoNewOFB(), 'some plaintext');
    end;

    method NewTripleDESCipher;
    begin
      //Assert.AreEqual(TestApplication2.DoNewTripleDESCipher(), true); // T81984
    end;

    method ECDSAVerify;
    begin
      //Assert.AreEqual(TestApplication2.DoECDSAVerify(), true); // T81984 seems, array inside struct
    end;
  end;

end.