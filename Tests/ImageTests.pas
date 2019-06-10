namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  ImageTests = public class(Test)
  public
    method ImageDecoderTest;
    begin
      Assert.IsTrue(TestApplication2.DoImageDecodeTest());
    end;
  end;

end.