namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  EncodingTests = public class(Test)
  public
    method Base64Test;
    begin
      Assert.AreEqual(TestApplication2.DoEncodeBase64(), 'YWJjMTIzIT8kKiYoKSctPUB+');
      Assert.AreEqual(TestApplication2.DoDecodeBase64(), "abc123!?$*&()'-=@~");
    end;

    method BinaryReadTest;
    begin
      Assert.AreEqual(TestApplication2.DoBinaryRead(), 3.141592653589793);
    end;

    method BinaryPutVaruintTest;
    begin
      var lBuf := TestApplication2.DoBinaryPutUvarint(1);
      Assert.AreEqual(lBuf.Length, 1);
      Assert.AreEqual(lBuf[0], 1);

      lBuf := TestApplication2.DoBinaryPutUvarint(127);
      Assert.AreEqual(lBuf.Length, 1);
      Assert.AreEqual(lBuf[0], $7f);

      lBuf := TestApplication2.DoBinaryPutUvarint(256);
      Assert.AreEqual(lBuf.Length, 2);
      Assert.AreEqual(lBuf[0], $80);
      Assert.AreEqual(lBuf[1], $02);
    end;

    method HexTest;
    begin
      Assert.AreEqual(TestApplication2.DoEncodingHexDecode(), 'Hello Gopher!');

      var lBuf := TestApplication2.DoEncodingHexEncode();
      Assert.AreEqual(lBuf.Length, 26);
      Assert.AreEqual(lBuf[0], 52);
      Assert.AreEqual(lBuf[1], 56);
    end;

    method JsonTest;
    begin

    end;

  end;

end.