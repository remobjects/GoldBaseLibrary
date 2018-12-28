namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  BasicTests = public class(Test)
  public
    method BigInt64Test;
    begin
      Assert.AreEqual(TestApplication2.CheckAbsoluteToInternal, -9223371966579724800);
    end;
  end;

end.