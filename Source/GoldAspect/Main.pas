namespace GoldAspect;

uses
  System.Linq,
  RemObjects.Elements.Cirrus.*;

type
  // we use this class to work around compiler issues in Gold.
  [AttributeUsage(AttributeTargets.Assembly)]
  GoldFixer = public partial class(Attribute, IAssemblyInterfaceDecorator)
  public
    method GetCallToClassConstructor(aServices: IServices; aNamespace: String): Statement;
    begin
      var lType := aServices.GetType('go.'+aNamespace+'.__Global');
      if (lType = nil) or (lType.GetClassConstructor = nil) then exit new BeginStatement();
      var lMeth: IMethod := lType.GetStaticMethod('__Initialize', new IType[0], []);
      if lMeth = nil then begin
        lMeth := (lType as ITypeDefinition).AddMethod('__Initialize', nil, true);
      end;
      exit new StandaloneStatement(new ProcValue(new TypeValue(lMeth.Owner), lMeth));
    end;

    method ForceInitializationOfNamespaces(aServices: IServices; aNamespace: String; aArgs: array of String);
    begin
      var lType := aServices.GetType('go.'+aNamespace+'.__Global');
      var lCCtor := IMethodDefinition(lType.GetClassConstructor);
      if lCCtor = nil then
        lCCtor := ITypeDefinition(lType).AddConstructor(true);
      var lBeg := new BeginStatement();
      for each x in aArgs do
        lBeg.Add(GetCallToClassConstructor(aServices, x));
      lCCtor.SurroundMethodBody(lBeg, new BeginStatement, SurroundMethod.Never);
    end;

    method HandleInterface(Services: IServices);
    begin
      ForceInitializationOfNamespaces(Services, 'crypto.tls', ["crypto",
      "crypto.hmac",
      "crypto.md5",
      "crypto.sha1",
      "crypto.sha256",
      "crypto.sha512",
      "errors",
      "fmt"]);
      var lType := Services.GetType('go.net.http.atomicBool');
      ITypeDefinition(lType).RemoveMethod(lType.GetStaticMethods('isSet')[0] as IMethodDefinition);
      ITypeDefinition(lType).RemoveMethod(lType.GetStaticMethods('setTrue')[0] as IMethodDefinition);
      var lPar := new SelfValue;
      var lIsSet := ITypeDefinition(lType).AddMethod('isSet', Services.GetBaseType(1), false);
      lIsSet.ReplaceMethodBody(
        new ExitStatement(
        new BinaryValue(new ProcValue(new TypeValue(Services.GetType('go.sync.atomic.__Global')), 'LoadInt32', [new FieldValue(lPar, lType, 'Value')]), new DataValue(0), BinaryOperator.NotEqual)
        ));
      var lsetTrue := ITypeDefinition(lType).AddMethod('setTrue', nil, false);
      lsetTrue.ReplaceMethodBody(
      new StandaloneStatement(
      new ProcValue(new TypeValue(Services.GetType('go.sync.atomic.__Global')), 'StoreInt32', [new FieldValue(lPar, lType, 'Value'), new DataValue(1)])
      ));
    end;
  end;

  [MethodAspect('go.reflect.__Global', true, 'TypeOf', 0,  array of String(nil))]
  TypeOfFixer = public partial class(Attribute, IMethodCallDecorator)
  public
    method ProcessMethodCall(aContext: IContext; aMethod: IMethod; aValue: ParameterizedValue): Value;
    begin
      if (aValue.Parameters[0].Kind = ValueKind.Nil) and (NilValue(aValue.Parameters[0]).Type <> nil) then begin
        exit new NewValue(aContext.Services.GetType('go.reflect.TypeImpl'), new TypeOfValue(NilValue(aValue.Parameters[0]).Type));
      end;
      exit nil;
    end;
  end;

end.