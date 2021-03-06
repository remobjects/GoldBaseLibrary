﻿namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  BasicTests = public class(Test)
  public
    method BigInt64Test;
    begin
      Assert.AreEqual(TestApplication2.CheckAbsoluteToInternal, -9223371966579724800);
      Assert.AreEqual(TestApplication2.DoSliceTest, true);
      Assert.AreEqual(TestApplication2.DoCrash(), true);
    end;
  end;

end.