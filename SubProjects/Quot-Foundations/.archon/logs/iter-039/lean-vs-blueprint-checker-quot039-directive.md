# Lean ↔ Blueprint checker — QuotScheme (iter-039)

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

## Blueprint chapter
`/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

## What changed this iter
Three new axiom-clean algebra/category "feeder" decls toward gap1's `Hfr`:
- `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` (~1665) — instantiable basic-open-
  hypothesis form of the cover-descent (the general-U `_of_cover` form is reported as an
  unprovable trap; this is the usable variant).
- `isLocalizedModule_powers_transport` (~1905) — combined bridge (I)+(II) algebra transport.
- `isIso_fromTildeΓ_of_iso` (~1936) — iso-invariance of `IsIso M.fromTildeΓ`.

The named keystone `isLocalizedModule_basicOpen_descent` (quasi-coherent M) and gap1
`isIso_fromTildeΓ_of_isQuasicoherent` were NOT closed — only the geometric Hfr producer
(slice → Spec R_r section transport) remains. The protected iter-176 scaffold stubs at
126/165/201/228 still carry `sorry` (frozen skeletons, not new dead code).

## Check
- These three new public decls are NOT yet in any blueprint chapter (dag `unmatched` lists all
  three). Confirm and report them as coverage debt — name the labels the planner should author
  and what each Lean proof depends on.
- Is the chapter's account of the `Hfr` assembly / `lem:section_localization_descent` still
  accurate given the prover chose the **basic-open** descent form (not the general-U form)?
  Flag any blueprint prose that still references the abandoned general-U `_of_cover` path.
- Any `\lean{...}` hint pointing at a renamed/abandoned decl?
