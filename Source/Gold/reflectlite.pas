namespace go.internal.reflectlite;

method TypeOf(v: Object): go.reflect.Type; public;
begin
    result := new go.reflect.TypeImpl(v.GetType());
end;


end.