# Conventions

## Naming conventions

- use snake_case for labels


## Structural conventions

- Always specify a .segment, do not assume default "CODE"

- imports and exports go at the top of a file, before any instructions

- Put ALL 'variables' in either zeropage.s (for zero-page variables) or bss.s (for regular ram variables)
    - This makes sure we can keep easy track of what's in ram/zero-page, and prevents accidental name-conflicts

- labels that denote a 'code section' go on their own line, with the instructions starting on the following line. labels that denote a 'pointer' to a variable go on the same line as the data they define.


## Restrictions

- Do not touch header.s

- Do not use .autoimport
    - only import/export what needs to be

- Do not use unnamed labels. For temporary labels, use a 'cheap temporary' label instead (denoted with an @)


