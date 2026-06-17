# Refactor directive — de-privatize the `CombinatorialCech.Dependent` engine

## Goal
Make the dependent-coefficient combinatorial Čech engine in
`AlgebraicJacobian/Cohomology/CechAcyclic.lean` IMPORTABLE from sibling files, by removing the `private`
modifier from its declarations. This is a pure visibility change — NO logic, NO signature, NO proof
changes. It unblocks the shared `CechSectionIdentification.lean` (and the dead `CechAcyclic.affine`) which
need to consume the contracting-homotopy machinery (Sub-brick B) without re-porting it.

## Exact change
In `CechAcyclic.lean`, namespace `CombinatorialCech`, `section Dependent` (currently ~lines 290–459),
remove the leading `private` keyword from each of these declarations so they become public:
- `depTransport` (lemma, ~line 302)
- `cons_comp_zero_succAbove` (lemma, ~line 308)
- `depDiff` (def, ~line 314)
- `depHomotopy` (def, ~line 320)
- `depHomotopy_spec` (lemma, ~line 329)
- `depDiff_eq_of_cocycle` (lemma, ~line 361)
- `comp_succAbove_swap` (lemma, ~line 383)
- `depDiff_comp` (lemma, ~line 397)
- `depDiff_exact` (lemma, ~line 432)

Also check `section Dependent`'s sibling `cons_comp_succAbove_succ` (referenced by `depHomotopy_spec`/
`depDiff_eq_of_cocycle` via `cons_comp_succAbove_succ r σ k`): if IT is `private` (likely defined just
above the section, search for it), de-privatize it too — `depHomotopy_spec` cannot be public while
depending on a private helper in its statement-level transport term.

Leave the bodies, the `variable` block, the `omit` lines, the docstrings, and EVERYTHING ELSE in the file
byte-for-byte unchanged. Do not reorder, do not rename, do not touch any other declaration in the file.

## Verify
After the edit, run `lake env lean` on `CechAcyclic.lean` and confirm it exits 0 with no new errors (the
file currently has 2 sorries — the dead `affine` at line ~110 and one other; both pre-existing, leave
them). Confirm `#print axioms` is unchanged for `CombinatorialCech.depDiff_exact` (kernel-only). If
de-privatizing surfaces ANY new error (e.g. a name clash, or a now-required `protected`), report it and
STOP — do not paper it; do not insert sorry.

## Out of scope
- Do NOT delete the dead `affine` sorry (planner handles that separately).
- Do NOT touch any file other than `CechAcyclic.lean`.
- Do NOT modify proofs or signatures of any declaration.
