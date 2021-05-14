namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  MimeTests = public class(Test)
  public
    method WordDecoderTest;
    begin
      Assert.IsTrue(TestApplication2.DoMimeWordDecodeTest());
    end;

    method NewReaderTest;
    begin
      Assert.IsTrue(TestApplication2.DoNewReaderTest());
    end;

  end;

end.