# lean-vs-blueprint-checker directive (iter-240) — FlatBaseChange

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Context
This iter the proof of `pushforward_spec_tilde_iso` (around L535–L660) was extended:
the old `hloc` obligation is now discharged by a ~70-line scaffold (`algebraize [φ.hom]`
+ `IsLocalizedModule.powers_restrictScalars` with explicit instances + `of_linearEquiv`
transport), leaving ONE residual `sorry` — `hsq`, the "naturality in the open" square of
`gammaPushforwardIsoAt`. Net file sorry count unchanged at 3 (`pushforward_spec_tilde_iso`,
`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`). Two new `\lean{}`
blocks + "natural-in-open" notes were added to the chapter this iter (sync added 2 `\leanok`).

## What to report
- Lean → blueprint: do the chapter's claims about `pushforward_spec_tilde_iso` and its
  helper lemmas match the current Lean (signatures, the route described)? Does any
  `\leanok` / `\lean{}` pin point at a decl that is actually still `sorry`-bearing
  (`pushforward_spec_tilde_iso` still has a residual `hsq` sorry — verify the chapter
  does not claim it complete)?
- Blueprint → Lean: is the chapter detailed enough on the "natural-in-open" square that
  the residual `hsq` needs? The prover proposes repackaging `gammaPushforwardIsoAt` as a
  genuine `NatIso` to make naturality definitional — does the blueprint reflect that, or
  still describe an element-level route?
- Flag any must-fix-this-iter discrepancy (over-claimed completion, signature mismatch,
  stale route).
