# Blueprint Writer Report

## Slug
gf-helpers

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made

### Task 1 — expanded the proof of `lem:gf_torsion_reindex`
- **Revised** proof of `lem:gf_torsion_reindex`: replaced the 4-line "Transitivity"
  paragraph with four new sub-steps that record the genuine localisation-transport content
  the formalization required, all in mathematical prose (no Lean tactic strings):
  - *Localisation transport* — introduces the two distinct localisations of `T`:
    `T'_g := T[C^{-1}]` (localisation at the constant-polynomial monoid `MC`, the natural
    home of the elimination step, carrying the full `A_g[X_0,…,X_{d-1}]`-module API and
    quotient structure for free) versus the goal's `T_g := T[g^{-1}]` (localisation at the
    powers of `g ∈ A`), and states that they must be identified.
  - *Change of variables as a ring iso* — `ē : P_d[g^{-1}] ≃ P_d[g^{-1}]` obtained by
    localising `e` at `MC` (which it preserves, fixing constants), carrying `F_g ↦ G` and
    descending to a quotient ring iso `ψ : P_d[g^{-1}]/(F_g) ≃ P_d[g^{-1}]/(G)`; finiteness
    over `R = A_g[X_1,…,X_{m'}]` transported across `ψ` via
    `lem:gf_finite_of_quotient_ringequiv`.
  - *Identification of the two localisations* — via the restrict-scalars descent
    `lem:gf_islocalizedmodule_restrictscalars`, giving the linear iso `T_g ≅ T'_g`.
  - *Action-diamond subtlety* — records the wall: `T_g` carries its canonical `A_g`
    localisation action, which beats any anonymous witness, so the identification must be
    promoted to an `A_g`-linear iso (compatibility on `A_g`-constants), after which the
    `R`-structure + finiteness pull back via `lem:gf_pullback_module_transport`.
  - The original *Transitivity* closing sentence is retained.
- The existing `% SOURCE QUOTE PROOF` (Nitsure L1766–L1768) was left intact.

### Task 2 — added blueprint blocks for the 5 helpers
New `\subsubsection{Module-structure transport helpers (reindex)}`
(`\label{sec:gf_reindex_transport_helpers}`) placed after the reindex proof, before
`lem:gf_polynomial_core`. These are Archon-original project helpers — no `% SOURCE`
citation (correct per directive).
- **Added lemma** `\label{lem:gf_pullback_module_transport}` with **three** `\lean{}` pins
  (folded per directive's option): `pullbackModuleAddEquiv` (def, the pulled-back action
  `r·y := e(r·e⁻¹ y)`), `finite_of_pullbackModuleAddEquiv` (finiteness transports, via
  `Module.Finite.equiv`), `pullback_isScalarTower` (scalar tower transports, via
  `smul_assoc`). One-line statement + proof naming the Mathlib facts in prose.
- **Added lemma** `\label{lem:gf_finite_of_quotient_ringequiv}` —
  `\lean{…finite_of_quotientRingEquiv}`; `Module.Finite` across a structure-compatible ring
  iso of the acting ring. Proof names `AlgEquiv.ofRingEquiv`, `Module.Finite.equiv`,
  `Module.Finite.trans`.
- **Added lemma** `\label{lem:gf_islocalizedmodule_restrictscalars}` —
  `\lean{…isLocalizedModule_restrictScalars}`; descent of `IsLocalizedModule` along a scalar
  tower (image submonoid → base submonoid). Proof names `IsLocalizedModule.mk`,
  `Module.End.isUnit_iff`, `IsScalarTower.algebraMap_smul`.
- **Fixed dependencies** `lem:gf_torsion_reindex` — added the three new helper labels to
  BOTH the statement `\uses{}` and the proof `\uses{}` (the chapter's convention duplicates
  uses across both; adding only to the proof block left the helpers isolated in `leandag`).

### Task 3 — stale prose
- No blueprint prose described `gf_torsion_reindex` as "blocked / still sorry". The only
  history-flavored phrase ("the real cause of the prior stall") is inside a `% LEAN PROOF
  STRUCTURE` comment in `lem:gf_polynomial_core`'s proof and explains the
  base-generalizing induction (not a status claim), so it was left untouched. Nothing to
  change.

## Cross-references introduced
- `\uses{lem:gf_pullback_module_transport}`, `\uses{lem:gf_finite_of_quotient_ringequiv}`,
  `\uses{lem:gf_islocalizedmodule_restrictscalars}` added to `lem:gf_torsion_reindex`
  (statement + proof). All three targets are new blocks in this same chapter.
- The three new helper blocks `\cref` nothing project-side (their dependencies are Mathlib,
  named in prose); they are tied into the DAG by the incoming edges from
  `lem:gf_torsion_reindex`.

## leandag verification
- `leandag build --json`: `lean_aux_nodes: 0` (was non-zero — the 5 helpers were unmatched;
  now all matched), `isolated: 0`, `unknown_uses: []`. Edges 297 → 300 (the three new
  dependency edges). 5 Lean helper names matched across 3 blueprint blocks (one block, three
  `\lean{}` pins; two single-pin blocks).

## References consulted
None — all five helpers are Archon-original module-theory transport lemmas (no external
source). Grounding for the proof prose came from reading the Lean proof of
`gf_torsion_reindex` (`AlgebraicJacobian/Picard/FlatteningStratification.lean`, lines
~907–1252) to keep the localisation-transport description faithful to the formalization.

## Macros needed (if any)
None — only standard commands (`\texttt`, `\cref`, `\xrightarrow`, `\mathcal`) and existing
chapter macros used.

## Notes for Plan Agent
- `pullback_isScalarTower` (helper 3) is currently defined in Lean but **not consumed** by
  `gf_torsion_reindex` (the final scalar tower in the reindex proof is built inline via
  `IsScalarTower.of_algebraMap_smul`, not via this helper). It is documented (1-to-1
  coverage restored) and tied into the DAG by folding it into the
  `lem:gf_pullback_module_transport` block alongside the two helpers that ARE used. If a
  future cleanup removes the unused `pullback_isScalarTower` from the Lean file, drop its
  `\lean{}` pin from that block.

## Strategy-modifying findings
None.
