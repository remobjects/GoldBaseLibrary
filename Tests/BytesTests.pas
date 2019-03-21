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

    method BytesEqualTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesEqualTest());
    end;

    method BytesEqualFoldTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesEqualFoldTest());
    end;

    method BytesFieldsTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesFieldsTest());
    end;

    method BytesFieldsFuncTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesFieldsFuncTest());
    end;

    method BytesHasPrefixTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesHasPrefix());
    end;

    method BytesHasSuffixTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesHasSuffixTest());
    end;

    method BytesIndexTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesIndexTest());
    end;

    method BytesIndexAnyTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesIndexAnyTest());
    end;

    method IndexByteTest;
    begin
      Assert.IsTrue(TestApplication2.DoIndexByteTest());
    end;

    method IndexRuneTest;
    begin
      Assert.IsTrue(TestApplication2.DoIndexRuneTest());
    end;

    method BytesJoinTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesJoinTest());
    end;

    method BytesLasIndexTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesLasIndexTest());
    end;

    method BytesLastIndexAnyTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesLastIndexAnyTest());
    end;

    method BytesMapTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesMapTest());
    end;

    method BytesRepeatTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesRepeatTest());
    end;

    method BytesReplaceTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesReplaceTest());
    end;

    method BytesReplaceAllTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesReplaceAllTest());
    end;

    method BytesRuneTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesRuneTest());
    end;

    method BytesSplitTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesSplitTest());
    end;

    method BytesSplitAfterTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesSplitAfterTest());
    end;

    method BytesToLowerTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesToLowerTest());
    end;

    method BytesToTitleTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesToTitleTest());
    end;

    method BytesToUpperTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesToUpperTest());
    end;

    method BytesTrimTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesTrimTest());
    end;

    method BytesTrimSpaceTest;
    begin
      Assert.IsTrue(TestApplication2.DoBytesTrimSpaceTest());
    end;

    method BytesTrimSuffix;
    begin
      Assert.IsTrue(TestApplication2.DoBytesTrimSuffix());
    end;
  end;

end.