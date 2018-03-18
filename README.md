# LiteFMWK

`LiteFMWK` is a software development base that allows you to:
* Generate a software _package_ where you can generate arbitrary number of C++ class/function and compile into 1 library
* Automatically generate ROOT cling dictionary to access compiled class/function from cling/python interpreters (latter via PyROOT)
* Support a structure for introducing inter-package dependencies

## How to use it?
Just try:
```
source setup.sh
```
This sets up necessary shell env. variables. 
You need to have `ROOT6` (if not, you get an error message from `setup.sh`).
There's a support to detect `numpy` and provide a few handy compiler directives as well.

## How to make a new _package_?
Just try:
```
gen_my_package Aho
```
... which will generate a directory named `Aho` under the repository top directory.
A new package comes with `GNUmakefile` which allows you to compile a package by simply typing `make` in the package directory.
You also find `sample.h` and `sample.cxx`. 
These are very much empty C++ classes just to demonstrate that you can `make` and access them from an interpreter.
```
python -c "import ROOT;print ROOT.Aho.sample()"
```

## Generating a new class
In a package directory you can generate a new class. You can of course just type-it-up from scratch.
You can also try:
```
gen_my_class Tako
```
... which generates `Tako.h` and `Tako.cxx` much like `sample` class.  Again, to compile, you can just type  `make`.

If you have written your class from scratch, make sure you add your class to `LinkDef.h` if you want a dictionary generation (e.g. if you want an access from an interpreter).

## Example?
You can find an example in this branch:
```
git checkout example
```

## Compiling multiple packages
No one wants to `cd` package directory and `make` for every package. You can utilize the top level `GNUmakefile` which is extremely simple and hopefully self-descriptive. All you need to do is to list (space-separated) packages in `SUBDIRS` variable.

## Excluding a class from dictionary generation
Sometimes you don't want to expose your C++ class to an interpreter.
Assuming your C++ class is already registered in the dictionary (a mechanism to make your class available in an interpreter), simply exclude it from `LinkDef.h`.

If you wonder when you want to do it, here's some example reasons:
* Compilation is so slow (auto-generated dictionary source code is usually _really_ long, like easily 10,000 lines, taking long time to compile)
* Ugh I keep getting dictionary compilation error (auto-generation of dictionary source code is far from being perfect, especially for the latest C++ standards... if troublesome, exclude)

## Making inter-package dependencies
To make one package depend on another, you typically want to know 2 information: headers to be included and libraries to be linked against.
Here are two pieces of information you may find it useful/handy:
*  Package libraries are compiled and available under `$MYSW_LIBDIR/libLiteFMWK_$(PACKAGE_NAME).so`
*  Package header files are copied and available under `$MYSW_INCDIR/litefmwk/$(PACKAGE_NAME)`
... where you substitute `$(PACKAGE_NAME)` with the actual name string.

With these info, you know what you need to do for your new package compilation that depends on those.

1. Add compiler flags
  * `-I$(MYSW_INCDIR)`
  * `-L$(MYSW_LIBDIR) -lLiteFMWK_$(PACKAGE_NAME).so`
  
2. Include statements in the source codes
  * `#include "litefmwk/$(PACKAGE_NAME)/$(WANTED_HEADER)"`
  * ... where `$(WANTED_HEADER)` is the header file you want (like `sample.h`).
 
