# Conventions

- Do not touch header.s
- Always specify a .segment, do not assume default "CODE"
- imports and exports go at the top of a file, before any instructions
- Do not use .autoimport
    - only import/export what needs to be
- Do not use unnamed labels. For temporary labels, use a 'cheap temporary' label instead (denoted with an @)