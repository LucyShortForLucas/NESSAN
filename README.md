# Conventions

## Naming conventions

- use snake_case for labels

- use PascalCase for macros

- use camelCase for file names

- use ALL_CAPS for constant names

- asm instructions should be lowercase


## Structural conventions

- Always specify a .segment, do not assume default "CODE"
    - EXCEPTION: macro files do not need a .segment (as they do not generate machine code)

- imports and exports go at the top of a file, before any instructions

- Put ALL 'variables' in either zeropage.s (for zero-page variables) or bss.s (for regular ram variables)
    - This makes sure we can keep easy track of what's in ram/zero-page, and prevents accidental name-conflicts

- Labels that denote a 'code section' go on their own line, with the instructions starting on the following line. labels that denote a 'pointer' to a variable go on the same line as the data they define.

- Use little-endian for multi-byte variables

- If a subroutine is small or used only once, consider making it a macro instead

- Macros must go in their own, seperate files
    - These files MAY NOT contain any non-macro code, as they will be directly included in other files

- Use .include ONLY for macro-only files

- Constants go into consts.s


## Restrictions

- Do not touch header.s

- Do not use .autoimport
    - only import/export what needs to be

- Do not use unnamed labels. For temporary labels, use a 'cheap temporary' label instead (denoted with an @)


## Git

- When working on a different feature, create a new branch for it.

- When finished with a branch, prefer Merge over Rebase
