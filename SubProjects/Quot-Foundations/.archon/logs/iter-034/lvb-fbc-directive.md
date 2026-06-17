# lean-vs-blueprint-checker — fbc (iter-034)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

Report:
(a) Lean → blueprint: any fake/placeholder/over-strong statements, signature mismatches with the
    chapter's \lean{} pins, decls that claim more than the blueprint states.
(b) blueprint → Lean: chapter blocks whose \lean{} pin names a non-existent or renamed decl;
    blocks too thin to have guided the formalization the Lean clearly needed.
(c) coverage gaps: new non-private Lean decls in this file with NO blueprint block (lean_aux).

This iter's new decls in this file are the focus. Flag must-fix items explicitly.
