namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  BufferTest = public class(Test)
  public
    method BufferInit;
    begin
      Assert.AreEqual(TestApplication2.DoBufferInitTest(), 5);
    end;

    method ReaderTest;
    begin
      Assert.AreEqual(TestApplication2.DoReader64Test(), 'Gophers rule!');
    end;

    method BytesContainsTest;
    begin
      Assert.IsTrue(TestApplication2.DoContainsTest());
    end;

    method BytesContainsAnyTest;
    begin
      Assert.IsTrue(TestApplication2.DoContainsAnyTest());
    end;

    method BytesContainsRuneTest;
    begin
      Assert.IsTrue(TestApplication2.DoContainsRuneTest());
    end;

    method BytesCountTest;
    begin
      Assert.IsTrue(TestApplication2.DoCountTest());
    end;

  end;

end.