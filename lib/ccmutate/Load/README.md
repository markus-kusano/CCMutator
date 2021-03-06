## Mutate Load Instructions

### Description
Mutation operator to change concurrency aspects of load instructions. The
operator allows for:

1. Make atomic load instruction non-atomic
1. Change atomic ordering for atomic load instruction
1. Change synchronization scope for atomic load instruction

### Usage
See `test/run_test.sh` for more example usage.

With no arguments, the operator outputs the number of atomic load instructions
found.  Note the use of `-analyze`.

Example:

`````
opt -analyze -load $CCMUTATE_LIB/$testLibName -Load <test.bc >/dev/null
`````

#### Verbose
Verbose mode displays the source filename, linenumber and instruction for each
occurrence.

`````
opt -analyze -load $CCMUTATE_LIB/$testLibName -load -verbose <test.bc >/dev/null
`````

The output is of the form (with escaped characters):
`````
<index number>\t<source filename>:<source linenumer>
\t<fence instruction>\n
`````
For each atomic load instruction found

#### -toggle: Replace atomic load with non-atomic
Each load instruction can be reference by an index with `-pos`. Use the output
of `-verbose` or no argument to determine which index you'd like to mutate.

`-toggle` will switch an atomic load specified with -pos to non-atomic. The
converse operation is not yet supported.

`````
opt -load $CCMUTATE_LIB/$testLibName -Load -toggle -pos=0 <test.bc >out_001.bc
`````
This will change position 0 to a non-atomic load.

#### -mod: Modify Atomic Ordering
The flag `-mod` will change the atomic ordering to a value specified with
`-order`. `-order` must be specified. `-order` takes a list of unsigned
integers that correspond to the desired atomic ordering value for each
position specified with `-pos`. i.e. `-pos=0,1,3 -order=2,3,1` will set
position 0 to ordering 2, position 1 to ordering 3 and position 3 to ordering
1.

The values of `-order` correspond as follows:

0. unordered
1. monotonic
2. acquire
3. sequentially consistent

See http://llvm.org/docs/LangRef.html#ordering for information on what
guarantees the orderings provide.

If `-order` is shorter than `-pos` then the last value specified in `-order`
will be used for the remaining indecies. This will let you easily change a
group of fence instructions to the same atomic ordering. e.g. `-pos=0,1,3
-order=1` will change all three positions to monotonic semantics.

Example:
`````
opt -load $CCMUTATE_LIB/$testLibName -Load -mod -pos=0,1,2 -order=0,3 <test.bc >out_006.bc
`````
This will change position 0 to unordered, position 1 to sequentially consistent
and position 2 to sequentially consistent.

#### -scope: Change Synchronization Scope
`-scope` will toggle the syncrhonization scope for the positions specified with
`-pos`. This change a single-threaded load to multi-threaded and vice-versa.

Example:
`````
opt -load $CCMUTATE_LIB/$testLibName -Load -scope -pos=0 <test.bc >out_007.bc
`````

This will toggle position 0's synchronization scope.

#### Relevance
Examined C++11 code using `std::atomic` compiles down to use atomic load
instructions.
