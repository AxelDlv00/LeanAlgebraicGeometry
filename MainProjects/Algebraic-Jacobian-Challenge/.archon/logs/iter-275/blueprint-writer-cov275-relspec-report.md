# Blueprint Writer Report

## Slug
cov275-relspec

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_RelativeSpec.tex

## Changes Made
- **Added definition** `\definition` / `\label{def:relspec_qcoh_pullback}` /
  `\lean{AlgebraicGeometry.Scheme.QcohAlgebra.pullback}` — the base-change
  (pullback) `g^* 𝒜` of a quasi-coherent `O_X`-algebra `𝒜` along `g : T → X`,
  packaged as a `QcohAlgebra T`. States the construction faithfully to the Lean
  `def` (RelativeSpec.lean:390): underlying module = topological pushforward
  `q_* O` along the first projection `q`, unit = comorphism `q^♯`,
  coequifibered overlay from the named helper. Placed in the
  "Pullback compatibility helpers" section, right after
  `lem:relspec_pullback_coequifibered` (its coequifibered-feeding helper) and
  before the base-change-iso affine-piece machinery.
  - Proof block added: Y — one-line `Proved directly in Lean.` (sorry-free in
    Lean; project-bespoke base-change constructor, no external citation per
    directive).

## Cross-references introduced
- Statement-level `\uses{def:qc_sheaf_of_algebras}` — the `QcohAlgebra`
  structure block (exists in this chapter, §`sec:qc_sheaf_of_algebras`).
- Statement-level `\uses{lem:relspec_pullback_fst_isaffinehom}` — affineness
  helper (`...QcohAlgebra.pullback_fst_isAffineHom`, exists in this chapter).
- Statement-level `\uses{lem:relspec_pullback_coequifibered}` — coequifibered
  overlay helper (`...QcohAlgebra.pullback_coequifibered`, exists in this
  chapter).
- Prose `\cref{thm:relative_spec_base_change}` (existing block, not modified)
  identifying this constructor as the object underlying the base-change iso.

leandag verification (`leandag build --json` + `leandag query --isolated
--chapter Picard_RelativeSpec`):
- `conflicts: []`, `unknown_uses: []`.
- New node `def:relspec_qcoh_pullback` matched to its Lean declaration (NOT in
  `unmatched_lean`), with exactly 3 incoming edges from
  `def:qc_sheaf_of_algebras`, `lem:relspec_pullback_fst_isaffinehom`,
  `lem:relspec_pullback_coequifibered`.
- Isolated nodes in `Picard_RelativeSpec`: 0 results (new block is not
  isolated).

## References consulted
None opened this session. The block is the project's own base-change
constructor (Archon-original); per directive no external citation is fabricated.
The chapter's existing Stacks-01LL/01LS context already covers the surrounding
prose.

## Macros needed (if any)
None. Used only existing macros (`\Spec`, `\cref`, standard `\mathcal`/`\to`).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The existing base-change theorem block `thm:relative_spec_base_change` (frozen
  per "Do NOT touch existing blocks") states that `g^* 𝒜` is a quasi-coherent
  `O_T`-algebra but `\uses{}` the iso helpers, not the constructor `def`. The
  new `def:relspec_qcoh_pullback` now gives that constructor a first-class node;
  a future (out-of-scope this round) edit could add `\uses{def:relspec_qcoh_pullback}`
  to `thm:relative_spec_base_change` to make the dependency on the named
  pullback explicit, but the directive scoped this round to additive coverage
  only.

## Strategy-modifying findings
None.
