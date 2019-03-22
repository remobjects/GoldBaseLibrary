namespace GoldLibrary.Tests.Shared;

uses
  RemObjects.Elements.EUnit,
  RemObjects.Elements.RTL;

type
  StringTests = public class(Test)
  public
    method StringsCompare;
    begin
      Assert.IsTrue(TestApplication2.DoStringsCompareTest());
    end;

    method StringsContains;
    begin
      Assert.IsTrue(TestApplication2.DoStringsContainsTest());
    end;

    method StringsContainsAny;
    begin
      Assert.IsTrue(TestApplication2.DoStringsContainsAnyTest());
    end;

    method StringsContainsRune;
    begin
      Assert.IsTrue(TestApplication2.DoStringsContainsRuneTest());
    end;

    method StringsCount;
    begin
      Assert.IsTrue(TestApplication2.DoStringsCountTest());
    end;

    method StringsEqualFold;
    begin
      Assert.IsTrue(TestApplication2.DoStringsEqualFoldTest());
    end;

    method StringsFields;
    begin
      Assert.IsTrue(TestApplication2.DoStringsFieldsTest());
    end;

    method StringsHasPrefix;
    begin
      Assert.IsTrue(TestApplication2.DoStringsHasPrefixTest());
    end;

    method StringsHasSuffix;
    begin
      Assert.IsTrue(TestApplication2.DoStringsHasSuffixTest());
    end;

    method StringsIndex;
    begin
      Assert.IsTrue(TestApplication2.DoStringsIndexTest());
    end;

    method StringsIndexAny;
    begin
      Assert.IsTrue(TestApplication2.DoStringsIndexAnyTest());
    end;

    method StringsIndexRune;
    begin
      Assert.IsTrue(TestApplication2.DoStringsIndexRuneTest());
    end;

    method StringsJoin;
    begin
      Assert.IsTrue(TestApplication2.DoStringsJoinTest());
    end;

    method StringsLastIndex;
    begin
      Assert.IsTrue(TestApplication2.DoStringsLastIndexTest());
    end;

    method StringsMap;
    begin
      Assert.IsTrue(TestApplication2.DoStringsMapTest());
    end;

    method StringsReplace;
    begin
      Assert.IsTrue(TestApplication2.DoStringsReplaceTest());
    end;

    method StringsReplaceAll;
    begin
      Assert.IsTrue(TestApplication2.DoStringsReplaceAllTest());
    end;

    method StringsSplit;
    begin
      Assert.IsTrue(TestApplication2.DoStringsSplitTest());
    end;

    method StringsToLower;
    begin
      Assert.IsTrue(TestApplication2.DoStringsToLowerTest());
    end;

    method StringsToLowerSpecial;
    begin
      Assert.IsTrue(TestApplication2.DoStringsToLowerSpecialTest());
    end;

    method StringsToTitle;
    begin
      Assert.IsTrue(TestApplication2.DoStringsToTitleTest());
    end;

    method StringsToTitleSpecial;
    begin
      Assert.IsTrue(TestApplication2.DoStringsToTitleSpecialTest());
    end;

    method StringsToUpper;
    begin
      Assert.IsTrue(TestApplication2.DoStringsToUpperTest());
    end;

    method StringsTrim;
    begin
      Assert.IsTrue(TestApplication2.DoStringsTrimTest());
    end;

    method StringsBuilder;
    begin
      Assert.IsTrue(TestApplication2.DoStringsBuilderTest());
    end;
  end;

end.