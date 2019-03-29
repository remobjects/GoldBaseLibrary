namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  ContainerTests = public class(Test)
  public
    method List;
    begin
      Assert.IsTrue(TestApplication2.DoListTest()); // list has 4 elements and first one is 1.
      Assert.IsTrue(TestApplication2.DoListRemoveTest());
    end;

    method Ring;
    begin
      Assert.AreEqual(TestApplication2.DoRingTest(), 5);
      Assert.IsTrue(TestApplication2.DoRingLinkTest());
    end;

  end;

end.