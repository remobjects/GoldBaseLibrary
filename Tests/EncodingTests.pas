namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

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
      var lString := TestApplication2.DoEncodingJsonMarshal();
      Assert.AreEqual(lString, '{"ID":1,"Name":"Reds","Colors":["Crimson","Red","Ruby","Maroon"]}'); // T81705 issue, T81774
    end;

    method PemTest;
    begin
      var lString: RemObjects.Elements.RTL.String := TestApplication2.DoEncodingPEMEncode();
      var lLines := lString.Split(#10, true);
      Assert.AreEqual(lLines.Count, 4);
      Assert.AreEqual(lLines[0], '-----BEGIN MESSAGE-----');
      Assert.AreEqual(lLines[3], '-----END MESSAGE-----');
      Assert.IsTrue(TestApplication2.DoDecodingPEMDecode());
    end;

  end;

end.