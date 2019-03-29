namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  BufioTest = public class(Test)
  public
    method ScannerTest;
    begin
      Assert.IsTrue(TestApplication2.DoScannerTest());
      Assert.AreEqual(TestApplication2.DoScannerCommaSeparatedTest(), 5);
      Assert.AreEqual(TestApplication2.DoScannerCountWords(), 15);
    end;
  end;

end.