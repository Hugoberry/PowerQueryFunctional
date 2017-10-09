# PowerQueryFunctional
Power Query utility library with a functional twist

![PowerBI](media/heading.PNG)

## Quickstart
This module uses the extensibility provided by [Data Connectors](https://github.com/Microsoft/DataConnectors), so in order to use it you have to:
1. Create a `[My Documents]\Microsoft Power BI Desktop\Custom Connectors` directory
2. Enable the **Custom data connectors** preview feature in Power BI Desktop (under *File | Options and settings | Custom data connectors*)
3. Copy the the contents of `/build` folder with all the *.mez files into the above folder
4. Restart Power BI Desktop


## For developers 
In order to extend the modules 
1. Install the [Power Query SDK](https://aka.ms/powerquerysdk) from the Visual Studio Marketplace
2. Edit the existing `Data Connector Projects` or *.pq files 
3. Build the solution
The deployable *.mez files will be located in the Debug folder of each module under `/src`. The Relese configuration of the build will copy these files into the `/build` folder.

# Functions
For additional examples and explanations, please refer to the embeded documentation of each of the functions.
## _.Identity
A function that does nothing but return the parameter supplied to it. Good as a default or placeholder function.

`:: a -> a`

## _.Const
Return a function which always returns a given value.

`a -> b -> a`

## _.Flip
Reverse the order of arguments to a function of arity 2.

`:: ((a, b) -> c) -> ((b, a) -> c)`

## _.Compose 
Perform a right-to-left composition across a list of functions.

`:: ((y -> z), (x -> y), ..., (a -> b)) -> a -> z`

## _.Pipe
Perform a left-to-right composition across a list of functions.

`:: ((a -> b), (b -> c), ..., (y -> z)) -> a -> z`

# _.Of
Return a single item array containing the passed value.

`:: a -> [a]`

## _.Partial
Takes a function f and a list of arguments, and returns a function g. When applied, g returns the result of applying f to the arguments provided initially followed by the argument list provided to g.

`:: ((a, b, c, ..., n) -> x) -> [a, b, c, ...] -> ([d, e, f, ..., n] -> x)`

## _.Partial1 = 
Similar to _.Partial but instead of returning a function expecting a list of remaining arguments, provides a function expecting a final single argument in order to fully apply the initial function.

`:: ((a, b, c, ..., n) -> x) -> [a, b, c, ...] -> (n -> x)`

## _.PartialRight
Takes a function f and a list of arguments, and returns a function g. When applied, g returns the result of applying f to the arguments provided to g followed by the argument list provided initially.

`:: ((a, b, c, ..., n) -> x) -> [d, e, f, ..., n] -> ([a, b, c, ...] -> x)`

## _.PartialRight1
Similar to PartialRight however accepts a single, final argument in order to fully apply the intial function.

`:: ((a, b, c, ..., n) -> x) -> d, e, f, ..., n] -> (a -> x)`

## _.Curry = 
Curry a function so that arguments are supplied one at a time up until the specified arity is met at which point the original function will be invoked. 
<br>eg.Curry((a, b, c) => x) = (a) => (b) => (c) => x

`:: number (* -> a) -> (* -> a)`

## _.Foldl 
Perform a left-associative reduction over a list.

`:: (a b -> a) a -> [b] -> a`

## _.Foldr
Perform a right-associative reduction over a list.

`:: (a b -> b) -> b -> [a] -> b`

## _.Map 
Apply a transform to all elements of a list.

`(a -> b) -> [a] -> [b]`

## _.Filter 
Evaluate elements of a list against a predicate, returning a new list of the items which evaluated to true.

`:: (a -> Boolean) -> [a] -> [a]`

## _.Combine 
Given two lists, create a new list containing the result of appending b to a.

`:: [a] [a] -> [a]`

## _.Prepend 
Add a single element to the head of a list and return a new list containing the merged result.

`:: a -> [a] -> [a]`

## _.ChainOperations
Provide the ability to chain sequences of internal table, record and list operations.
The internal transform functions all take the object being transformed as parameter 0. To remove the need to assign intermediate variables this lifts that argument to be within a higher-order function allowing a sequence of operations to be performed. This sequence is defined as a list of lists, with element 0 containing the transform function and elements 1..n containing the arguments 1..n for that transform.
 
 `[(a -> b, x, y, ..n), (b -> c, x, y, ..n),...] -> a -> z`
 ```javascript
 TransformDummyTable = _.ChainOperations({
    {Table.SelectColumns, {"Col1", "Col2"}},
    {Table.RenameColumns, {"Col1", "Id"}},
    {Table.RenameColumns, {"Col2", "Alfa"}}
    })( 
        #table({"Col1","Col2","Col3"},
                {{1,"A","B"},
                 {2,"C","D"}})
        )
```

## References

The M functions used in this library have been inspired from the following repository
* [m-tools](https://github.com/acaprojects/m-tools)