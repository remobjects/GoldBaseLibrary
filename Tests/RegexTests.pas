namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  RegeexTests = public class(Test)

  public
    method SimpleMatchTest;
    begin
      Assert.IsTrue(TestApplication2.DoSimpleMatchTest());
    end;


    method MustCompileTest;
    begin
      Assert.IsTrue(TestApplication2.DoMustCompileTest());
    end;

  end;

end.