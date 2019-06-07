namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  MimeTests = public class(Test)
  public
    method WordDecoderTest;
    begin
      TestApplication2.DoMimeWordDecodeTest();
    end;

    method NewReaderTest;
    begin
      TestApplication2.DoNewReaderTest();
    end;

  end;

end.