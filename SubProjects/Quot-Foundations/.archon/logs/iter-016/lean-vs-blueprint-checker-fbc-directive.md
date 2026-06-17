# lean-vs-blueprint-checker — FBC (iter-016)

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Check (a) Lean → blueprint: are all Lean decls represented; any fake/placeholder statements;
signature mismatches with `\lean{}` pins. In particular the NEW decl
`AlgebraicGeometry.pullbackPushforward_unit_comp` (~line 1140) has NO blueprint block yet — confirm
that gap and say where it should be pinned (it is the Seam-2 leg-reindex engine feeding
`lem:base_change_mate_fstar_reindex`).
And (b) blueprint → Lean: does the chapter give enough detail to formalize Seam 2/3? The prover
reported the Seam-2 conjugate-calculus / dependent-leg-transport mechanism is the gap and the chapter
may omit it. Report whether the chapter is adequate or too thin, with a must-fix flag if so.
