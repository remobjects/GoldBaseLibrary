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
  end;

end.