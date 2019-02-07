namespace GoldAspect;

uses
  System.Linq,
  RemObjects.Elements.Cirrus.*;

type
  // we use this class to work around compiler issues in Gold.
  [AttributeUsage(AttributeTargets.Assembly)]
  GoldFixer = public partial class(Attribute, IAssemblyInterfaceDecorator)
  public
    method HandleInterface(Services: IServices);
    begin
      var lType := Services.GetType('net.http.atomicBool');
      ITypeDefinition(lType).RemoveMethod(lType.GetStaticMethods('isSet')[0] as IMethodDefinition);
      ITypeDefinition(lType).RemoveMethod(lType.GetStaticMethods('setTrue')[0] as IMethodDefinition);
      var lPar := new SelfValue;
      var lIsSet := ITypeDefinition(lType).AddMethod('isSet', Services.GetBaseType(1), false);
      lIsSet.ReplaceMethodBody(
        new ExitStatement(
        new BinaryValue(new ProcValue(new TypeValue(Services.GetType('sync.atomic.__Global')), 'LoadInteger', [new FieldValue(lPar, lType, 'Value')]), new DataValue(0), BinaryOperator.NotEqual)
        ));
      var lsetTrue := ITypeDefinition(lType).AddMethod('setTrue', nil, false);
      lsetTrue.ReplaceMethodBody(
      new StandaloneStatement(
      new ProcValue(new TypeValue(Services.GetType('sync.atomic.__Global')), 'StoreInteger', [new FieldValue(lPar, lType, 'Value'), new DataValue(1)])
      ));
    end;
  end;

  [MethodAspect('reflect.__Global', true, 'TypeOf', 0,  array of String(nil))]
  TypeOfFixer = public partial class(Attribute, IMethodCallDecorator)
  public
    method ProcessMethodCall(aContext: IContext; aMethod: IMethod; aValue: ParameterizedValue): Value;
    begin
      if (aValue.Parameters[0].Kind = ValueKind.Nil) and (NilValue(aValue.Parameters[0]).Type <> nil) then begin
        exit new NewValue(aContext.Services.GetType('reflect.TypeImpl'), new TypeOfValue(NilValue(aValue.Parameters[0]).Type));
      end;
      exit nil;
    end;
  end;

end.