namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  AppendArrayTests = public class(Test)
  public
    method AppendArrayTest;
    begin
      Assert.IsTrue(TestApplication2.DoAppendArrayTest());
    end;
  end;



end.