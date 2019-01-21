namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  HashTests = public class(Test)
  public
    method HashTest;
    begin
      Assert.IsTrue(TestApplication2.DoHashTest());
      TestApplication2.DoCrash();
    end;
  end;

end.