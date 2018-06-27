package;
import haxe.macro.Context;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Expr;

/**
 * ...
 * @author
 */
class AS3 {

    public static function str(e:Dynamic):String {
        var t:Class<Dynamic> = Type.getClass(e);
        return t == null ? Std.string(e) : "[object " + Type.getClassName(t) + "]";
    }

    public static inline function asDynamic(e:Dynamic):Dynamic {
        return Std.is(e, haxe.Constraints.IMap) ? e : null;
    }

    public static inline function asDictionary(e:Dynamic):Dynamic {
        return Std.is(e, haxe.Constraints.IMap) ? untyped e : null;
    }

    public static inline function asObject(e:Dynamic):openfl.utils.Object {
        return untyped e;
    }

    public static inline function asClass<T>(e:Dynamic, t:Class<T>):T {
        return Std.is(e, t) ? untyped e : null;
    }

    public static inline function asFloat(e:Dynamic):Float {
        //return cast(e, Float);
        return as3hx.Compat.parseFloat(e);
    }

    public static inline function asBool(e:Dynamic):Bool {
        return e != false && e != null && e != 0 && !(Std.is(e, String) && e.length == 0);
    }

    public static function AS(e:Dynamic, type:Dynamic):Dynamic {
        return Std.is(e, type) ? e : null;
    }

    public static macro function as(e:Expr, type:Expr):Expr {
        //switch(Context.typeof(e)) {
        switch(type.expr) {
            //case EConst(CIdent("Dictionary")): return macro Std.is($e, haxe.Constraints.IMap) ? $e : null;
            case EConst(CIdent("Dictionary")): return macro AS3.asDictionary($e);
            case EConst(CIdent("Object")): return macro AS3.asObject($e);
            case EConst(CIdent("Float")): return macro AS3.asFloat($e);
            case EConst(CIdent("Bool")): return macro AS3.asBool($e);

                                //write("(try cast(");
                                //writeExpr(e1);
                                //write(", ");
                                //switch(e2) {
                                    //case EIdent(s): writeModifiedIdent(s);
                                    //default: writeExpr(e2);
                                //}
            //case TAbstract(t, _) if(t.get().name == "Dictionary"): return macro Std.is($e, haxe.Constraints.IMap) ? $e : null;
            //case TInst(t, _) if(t.get().pack.length == 0): t.get().name;
            case _:
        }
        //throw Context.typeExpr(type);
        //throw Context.typeof(type);
        return macro AS3.asClass($e, $type);
        //return macro {
            //cast AS3.AS(${e}, ${type});
            //cast(AS3.AS(${e}, ${type}), );
        //}
        //return switch(type) {
            //case "Int": macro ${e};
            //case "Float": macro Std.int(${e});
            //case "String": macro @:privateAccess as3hx.Compat._parseInt(${e}, ${base});
            //case "Bool": macro ${e} ? 1 : 0;
            //case _: macro Std.parseInt(Std.string(${e}));
        //}
    }

    public static inline function hasOwnProperty(o:Dynamic, field:String):Bool {
        #if js
        var tmp;
        if(o == null) {
            return false;
        } else {
            var tmp1;
            if(untyped o.__properties__ && o.__properties__["get_" + field]) {
                return true;
            } else if (untyped o.prototype) {
                return untyped o.prototype.hasOwnProperty(field);
            } else {
                return Reflect.hasField(o, field);
            }
        }
        #else
        return false;
        #end
    }

}