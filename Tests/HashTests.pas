namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  HashTests = public class(Test)
  public
    method HashTest;
    begin
      TestApplication2.DoHashTest();

    end;
  end;

end.