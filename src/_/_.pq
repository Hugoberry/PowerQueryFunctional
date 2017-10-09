section _;
    
    // Right-to-left composition of a pair of unary functions.
    // :: (b -> c) (a -> b) -> a -> c
    _Compose = (f, g) => (x) => f(g(x));

shared _.Identity = 
    Document(
        "_.Identity",
        "A function that does nothing but return the parameter supplied to it. Good as a default or placeholder function.
        <br>:: a -> a",
        {[ Description = "Identity of the sine function", Code="_.Identity(Number.Sin)(0)", Result="0"]},
        (a) => a
    );

shared _.Const =
    Document(
        "_.Const",
        "Return a function which always returns a given value.
        <br>a -> b -> a",
        {[ Description = "Always return digits", Code="_.Const({0..9})", Result="{0..9}"]},        
        (a) => (b) => a
    );

shared _.Flip = 
    Document(
        "_.Flip",
        "Reverse the order of arguments to a function of arity 2.
        <br>:: ((a, b) -> c) -> ((b, a) -> c)",
        {[ Description = "Flip the divident with divisor", Code="_.Flip(Number.IntegerDivide)(1,2)", Result="2"]},    
        (f) => (a, b) => f(b, a)
    );

shared _.Compose =
    Document(
        "_.Compose",
        "Perform a right-to-left composition across a list of functions.
        <br>:: ((y -> z), (x -> y), ..., (a -> b)) -> a -> z",
        {[ Description = "Compose sin(cos(1))", Code="_.Compose({Number.Sin,Number.Cos})(1)", Result="0.51439525852354917"]},    
         _.Foldr(_Compose, _.Identity)
    );

shared _.Pipe = 
    Document(
        "_.Pipe",
        "Perform a left-to-right composition across a list of functions.
        <br>:: ((a -> b), (b -> c), ..., (y -> z)) -> a -> z",
        {[ Description = "Compose cos(sin(1))", Code="_.Pipe({Number.Sin,Number.Cos})(1)", Result="0.66636674539288054"]},    
        _.Foldl(_.Flip(_Compose), _.Identity)
     );

shared _.Of = 
    Document(
        "_.Of",
        "Return a single item array containing the passed value.
        <br>:: a -> [a]",
        {[ Description = "Return 1 as a list {1}", Code="_.Of(1)", Result="{1}"]},    
        (a) => {a}
    );

shared _.Partial = 
     Document(
        "_.Partial",
        "Takes a function f and a list of arguments, and returns a function g. When applied, g returns the result of applying f to the arguments provided initially followed by the argument list provided to g.
        <br>:: ((a, b, c, ..., n) -> x) -> [a, b, c, ...] -> ([d, e, f, ..., n] -> x)",
        {[ Description = "Double a number through partial application", 
                   Code="double = _.Partial(Value.Multily,{2}),
                        <br>six = mdouble({3})", Result="6"]},  
        (f, a) => (b) => Function.Invoke(f, a & b)
    );

shared _.Partial1 = 
     Document(
        "_.Partial1",
        "Similar to _.Partial but instead of returning a function expecting a list of remaining arguments, provides a function expecting a final single argument in order to fully apply the initial function.
        <br>:: ((a, b, c, ..., n) -> x) -> [a, b, c, ...] -> (n -> x)",
        {[ Description = "", Code="double = _.Partial1(Value.Multily,{2}),
                        <br>six = mdouble(3)", Result="6"]},  
        (f, a) => _Compose(_.Partial(f, a), _.Of)
      );

shared _.PartialRight =
     Document(
        "_.PartialRight",
        "Takes a function f and a list of arguments, and returns a function g. When applied, g returns the result of applying f to the arguments provided to g followed by the argument list provided initially.
        <br>:: ((a, b, c, ..., n) -> x) -> [d, e, f, ..., n] -> ([a, b, c, ...] -> x)",
        {[ Description = "Double the numbers of a list", Code="double = _.PartialRight(List.Transform,{each _*2})
                               <br>digits = double({{0..9}})", Result="List=0,2,4,..18"]},  
        (f, a) => (b) => Function.Invoke(f, b & a)
     );

shared _.PartialRight1 = 
     Document(
        "_.PartialRight1",
        "Similar to PartialRight however accepts a single, final argument in order to fully apply the intial function.
        <br>:: ((a, b, c, ..., n) -> x) -> d, e, f, ..., n] -> (a -> x)",
        {[ Description = "", Code="_.PartialRight1(Numbers.Sin)", Result="function"]},  
        (f, a) => _Compose(_.PartialRight(f, a), _.Of)
     );

shared _.Curry = 
     Document(
        "_.Curry",
        "Curry a function so that arguments are supplied one at a time up until the specified arity is met at which point the original function will be invoked. 
        <br>eg.Curry(3, (a, b, c) => x) = (a) => (b) => (c) => x
        <br>:: number (* -> a) -> (* -> a)",
        {[ Description = "", Code="_.Curry(Numbers.Sin)", Result="function"]},  
        (arity, f) =>
        let
            Apply = (args) =>
                if List.Count(args) >= arity then Function.Invoke(f, args)
                else (x) => @Apply(args & _.Of(x))
        in
            Apply({})
     );

shared _.Foldl = 
     Document(
        "_.Foldl",
        "Perform a left-associative reduction over a list.
        <br>:: (a b -> a) a -> [b] -> a",
        {[ Description = "", Code="_.Foldl(Numbers.Sin)", Result="function"]},  
        (fn, seed) => (list) => List.Accumulate(list, seed, fn)
     );

shared _.Foldr = 
     Document(
        "_.Foldr",
        "Perform a right-associative reduction over a list.
        <br>:: (a b -> b) -> b -> [a] -> b",
        {[ Description = "", Code="_.Foldr(Numbers.Sin)", Result="function"]},  
        (fn, seed) => (list) =>
        if List.IsEmpty(list) then seed
        else
            let
                x = List.Last(list),
                xs = List.RemoveLastN(list, 1)
            in
                fn(@_.Foldr(fn, x)(xs), seed)
     );

shared _.Map = 
     Document(
        "_.Map",
        "Apply a transform to all elements of a list.
        <br>(a -> b) -> [a] -> [b]",
        {[ Description = "", Code="_.Map(Numbers.Sin)", Result="function"]},  
        (fn) => (list) => List.Transform(list, fn)
     );

shared _.Filter = 
     Document(
        "_.Filter",
        "Evaluate elements of a list against a predicate, returning a new list of the items which evaluated to true.
        <br>:: (a -> Boolean) -> [a] -> [a]",
        {[ Description = "", Code="_.Filter(Numbers.Sin)", Result="function"]},  
        (fn) => (list) => List.Select(list, fn)
     );

shared _.Combine = 
     Document(
        "_.Combine",
        "Given two lists, create a new list containing the result of appending b to a.
        <br>:: [a] [a] -> [a]",
        {[ Description = "", Code="_.Combine(Numbers.Sin)", Result="function"]},  
        (a, b) => a & b
     );
shared _.Append = 
     Document(
        "_.Append",
        "Add a single element to the tail of a list and return a new list containing the merged result.
        <br>:: a -> [a] -> [a]",
        {[ Description = "", Code="_.Append(Numbers.Sin)", Result="function"]},  
        (a) => (list) => list & _.Of(a)
     );

shared _.Prepend = 
     Document(
        "_.Prepend",
        "Add a single element to the head of a list and return a new list containing the merged result.
        <br>:: a -> [a] -> [a]",
        {[ Description = "", Code="_.Prepend(Numbers.Sin)", Result="function"]},  
        (a) => (list) => _.Of(a) & list
    );

shared _.ChainOperations =
    Document(
        "_.Prepend",
        "Provide the ability to chain sequences of internal table, record and list operations.
      <br>The internal transform functions all take the object being transformed as parameter 0. To remove the need to assign intermediate variables this lifts that argument to be within a higher-order function allowing a sequence of operations to be performed. This sequence is defined as a list of lists, with element 0 containing the transform function and elements 1..n containing the arguments 1..n for that transform.
      <br>:: [(a -> b, x, y, ..n), (b -> c, x, y, ..n),...] -> a -> z",
        {[ Description = "Apply multiple table transformations", Code="ExtractRoomInfo = _.ChainOperations({
              {Table.SelectColumns, {""RoomID"", ""RoomName""}},
              {Table.RenameColumns, {""RoomID"", ""ID""}},
              {Table.RenameColumns, {""RoomName"", ""Name""}}
          })", Result="function"]},  
        
        let
            Transform = (t) =>
                let
                    f = List.First(t),
                    args = List.Skip(t)
                in
                    _.PartialRight1(f, args)
        in
            _Compose(_.Pipe, _.Map(Transform))
     );

///////////////////////// 
// Dependencies        //
/////////////////////////

Document = (name as text, description as text, valueOrExample as any, optional valueIfExample as any) =>
    let
        value = if valueIfExample is null then valueOrExample else valueIfExample,
        examples = if valueIfExample is null then {} else valueOrExample
    in
        Value.ReplaceType(value, Value.Type(value) meta [
            Documentation.Name = name, 
            Documentation.Description = description,  
            Documentation.Examples = examples
        ]);