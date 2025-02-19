#!/usr/bin/env wolframscript

$sourceDirectory = "c"
$buildDirectory = "LibraryResources"

Quiet@CreateDirectory[$buildDirectory]

Get["CCompilerDriver`"]; 
Get["LibraryLink`"];

getLibraryLinkVersion[] := 
Which[
    $VersionNumber >= 14.1, 
        With[{n = LibraryVersionInformation[FindLibrary["demo"] ]["WolframLibraryVersion"]},
            If[!NumberQ[n], 7, n]
        ], 
    $VersionNumber >= 13.1, 
        7, 
    $VersionNumber >= 12.1, 
        6, 
    $VersionNumber >= 12.0, 
        5, 
    $VersionNumber >= 11.2, 
        4, 
    $VersionNumber >= 10.0, 
        3, 
    $VersionNumber >= 9.0, 
        2, 
    True, 
        1
]; 

build[lib_String, opts: OptionsPattern[CreateLibrary]] := 
Block[{$directory, $libSrc, $libDir, $linkerOptions}, 
    Echo["Building "<>lib]; 
    
    $libSrc = File[lib]; 

    $libDir = FileNameJoin[{
        $buildDirectory, 
        $SystemID <> "-v" <> ToString[getLibraryLinkVersion[] ]
    }]; 


    If[!FileExistsQ[$libDir], CreateDirectory[]];

    CreateLibrary[$libSrc, FileBaseName[lib], 
        "TargetDirectory" -> $libDir, 
        "Debug" -> True, 
        opts
    ]
]; 

build /@ FileNames["*.c", $sourceDirectory];
Exit[0]
