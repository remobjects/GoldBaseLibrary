namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  CompressTests = public class(Test)
  public
    method ZLibTest;
    begin
      TestApplication2.DoZlibTest();
    end;

    method FlateTest;
    begin
      TestApplication2.DoFlateTest(); // T82177
    end;

    method GZipTest;
    begin
      TestApplication2.DoGZIPTest(); // T82177
    end;
  end;

end.