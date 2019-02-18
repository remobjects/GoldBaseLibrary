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

    method DoMD5;
    begin
      Assert.AreEqual(TestApplication2.DoMD5Sum, "b0804ec967f48520697662a204f5fe72");
    end;

    method DoMD5New;
    begin
      Assert.AreEqual(TestApplication2.DoMD5New, "d41d8cd98f00b204e9800998ecf8427e");
    end;

  end;

end.