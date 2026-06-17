# Blueprint Writer Report

## Slug
quot-gap1

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Summary
Reworked the G1-core / gap1 region of the Quot-foundations layer to match the iter-028 Lean
architecture, which REDUCES G1-core to a single irreducible lemma (gap1). G1-core is now a downstream
corollary of gap1; gap1 is elevated as the primary stated gap and split into its Step-1 sub-build
(the prover's this-iter target) plus a module Mayer–Vietoris gluing assembly. Added the two
coverage-debt helper blocks and the Mathlib End-unit anchor.

## Changes Made

- **Revised** `lem:qcoh_affine_section_localization` (G1-core) — statement unchanged; **rewrote the
  proof sketch** from the 3-field Route-F compact-open induction to the Lean-derived reduction:
  gap1 gives `IsIso M.fromTildeΓ`, then `isLocalizedModule_restrict_of_isIso_fromTildeΓ` delivers all
  three `IsLocalizedModule` fields at once; equivalence recorded via
  `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`. New `\uses{}` (statement + proof):
  `lem:qcoh_affine_isIso_fromTildeΓ`, `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`,
  `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`. Updated the NOTE to say G1-core is a
  downstream corollary; removed the SOURCE-QUOTE-PROOF-absent qcqs-template NOTE.

- **Revised** `lem:qcoh_affine_isIso_fromTildeΓ` (gap1) — statement unchanged; elevated to the
  PRIMARY gap. Rewrote `\uses{}` to depend on the new sub-build + gluing anchors
  (`lem:exists_isIso_fromTildeΓ_basicOpen_cover`, `lem:existsUnique_gluing_mathlib`,
  `lem:isLimitPullbackCone_mathlib`, `lem:isLocalizedModule_tilde_restrict`). Replaced the old
  "G1-assemble from G1-core" proof with the Stacks `lemma-quasi-coherent-affine` route: finite
  basic-open cover (sub-build) + cocycle/descent module gluing. Added `% SOURCE QUOTE PROOF`
  (gluing step, stacks-schemes.tex L1354–L1360). Updated NOTE (port of
  `exists_eq_pow_mul_of_isCompact_of_isQuasiSeparated`, sidestepping `objSupIsoProdEqLocus`).

- **Added lemma** `lem:exists_isIso_fromTildeΓ_basicOpen_cover` —
  `\lean{AlgebraicGeometry.Scheme.Modules.exists_isIso_fromTildeΓ_basicOpen_cover}` (Lean decl not
  yet present; the prover's this-iter target). Statement: finite basic-open family `{D(gⱼ)}`,
  `⨆ D(gⱼ)=⊤`, each `IsIso((M|_{D(gⱼ)}).fromTildeΓ)` (equiv. `M|_{D(gⱼ)}≅Ñⱼ` over `R_{gⱼ}`).
  Proof sketch added (Y): QuasicoherentData cover → refine to basic opens (`isBasis_basic_opens`) →
  finite subcover (`CompactSpace (PrimeSpectrum R)`) → transport presentation across `D(g)≅Spec R_g`
  → `IsIso` per `D(g)`. `% SOURCE QUOTE PROOF` from stacks-schemes.tex L1289–L1303 (covering step).
  `\uses{}`: `lem:isQuasicoherent_quasicoherentData_mathlib`, `lem:isBasis_basic_opens_mathlib`,
  `lem:isIso_fromTildeΓ_of_presentation_mathlib`, `lem:isLocalizedModule_basicOpen_of_presentation`,
  `lem:isLocalizedModule_tilde_restrict`.

- **Added lemma** `lem:isLocalizedModule_basicOpen_of_presentation` (coverage debt) —
  `\lean{AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation}` (axiom-clean in-file).
  One-line proof: `isIso_fromTildeΓ_of_presentation` then
  `isLocalizedModule_restrict_of_isIso_fromTildeΓ`.
  `\uses{lem:isIso_fromTildeΓ_of_presentation_mathlib, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ}`.

- **Added lemma** `lem:map_units_restrict_basicOpen` (coverage debt) —
  `\lean{AlgebraicGeometry.map_units_restrict_basicOpen}` (axiom-clean in-file). Statement: for ANY
  `M` (no quasi-coherence) every element of `powers f` acts invertibly on `Γ(M,D(f))`; note that
  `map_units` therefore contributes nothing to the gap. `\uses{lem:isUnit_algebraMap_end_basicOpen_mathlib}`.

- **Added Mathlib anchor** `lem:isUnit_algebraMap_end_basicOpen_mathlib` (`\mathlibok`) —
  `\lean{AlgebraicGeometry.tilde.isUnit_algebraMap_end_basicOpen}` (verified Mathlib, Tilde.lean:182).
  Statement: `IsUnit (algebraMap R (Module.End R Γ(M,D f)) f)` for any `M : (Spec R).Modules`. The
  G1-core `map_units` note now cites THIS anchor instead of `RingedSpace.isUnit_res_basicOpen`.

- **Added Mathlib anchor** `lem:isQuasicoherent_quasicoherentData_mathlib` (`\mathlibok`) —
  `\lean{SheafOfModules.QuasicoherentData}` (verified Mathlib, Quasicoherent.lean:201). States
  `IsQuasicoherent M = Nonempty (QuasicoherentData M)` and that a datum carries a cover `{Xᵢ}` with
  local presentations `(M.over Xᵢ).Presentation`. Provides the resolvable `\uses{}` target for the
  sub-build's "QuasicoherentData" dependency.

- **Revised prose** — G1-assemble subsection intro: now describes the bridge as
  `section-localization ⇒ IsIso fromTildeΓ` assembling the equivalence that makes G1-core a corollary
  of gap1 (was: "what gap1 invokes once G1-core is available"). Also corrected the dependency-order
  NOTE in `lem:qcoh_section_localization_basicOpen` (gap1 → G1-core → general keystone).

## Cross-references introduced
- `lem:exists_isIso_fromTildeΓ_basicOpen_cover` (new, in this chapter) — used by `lem:qcoh_affine_isIso_fromTildeΓ`.
- `lem:isQuasicoherent_quasicoherentData_mathlib` (new, in this chapter) — used by the sub-build.
- `lem:isUnit_algebraMap_end_basicOpen_mathlib` (new, in this chapter) — used by `lem:map_units_restrict_basicOpen`.
- `lem:isLocalizedModule_basicOpen_of_presentation` (new) — used by the sub-build.
- gap1 now `\uses` `lem:existsUnique_gluing_mathlib`, `lem:isLimitPullbackCone_mathlib`,
  `lem:isLocalizedModule_tilde_restrict` (all pre-existing in this chapter).
- G1-core now `\uses` `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (pre-existing).

leandag verification: `unknown_uses: 0`, `conflicts: 0`. No NEW isolated nodes introduced by my
blocks (all five new blocks are wired in).

## References consulted
- `references/stacks-schemes.tex` — verbatim `% SOURCE QUOTE` (gap1 statement, L1279–1284), and two
  `% SOURCE QUOTE PROOF` blocks: the covering step (L1289–L1303) for the sub-build and the
  gluing step (L1354–L1360) for gap1, all from Lemma `lemma-quasi-coherent-affine`.
- `references/stacks-properties.tex` — scanned for the standard-open / finite-cover statements used
  in the route prose (no new verbatim quote taken from it).
- `references/summary.md` — confirmed which Stacks sources are local (schemes/properties).
- Lean cross-check (read-only): `AlgebraicJacobian/Picard/QuotScheme.lean` (the iter-028 helpers
  `isLocalizedModule_basicOpen_of_presentation`, `map_units_restrict_basicOpen`,
  `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`),
  and Mathlib sources `Mathlib/AlgebraicGeometry/Modules/Tilde.lean` (anchor
  `tilde.isUnit_algebraMap_end_basicOpen`, `isIso_fromTildeΓ_of_presentation`) and
  `Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean` (`QuasicoherentData`,
  `IsQuasicoherent`, `Presentation.ofIsIso`, `Presentation.map`) to confirm the `\lean{}` targets and
  proof shapes.

## Macros needed (if any)
- None. All commands used (`\Spec`, `\cref`, `\bigsqcup`, `\widetilde`, etc.) are already in use in
  the chapter.

## Reference-retriever dispatches (if any)
- None. The Stacks `lemma-quasi-coherent-affine` statement and proof were already present in
  `references/stacks-schemes.tex`; no new source needed. (The directive's "Stacks 01HA proper" was
  not required — the affine QCoh≃Mod content is fully covered by the local `lemma-quasi-coherent-affine`,
  cited by lemma name + line numbers rather than a fabricated 01HA verbatim.)

## Notes for Plan Agent
- **Four Route-F Mathlib anchors are now ISOLATED** (`leandag show isolated`): they were the
  ingredients of the abandoned direct 3-field G1-core descent and have lost their consumer now that
  G1-core is a corollary of gap1:
  - `lem:isLocalization_basicOpen_of_qcqs_mathlib` (`isLocalization_basicOpen_of_qcqs`)
  - `lem:isLocalizedModule_constructor_mathlib` (`IsLocalizedModule`)
  - `lem:compact_open_induction_mathlib` (`compact_open_induction_on`)
  - `lem:isUnit_res_basicOpen_mathlib` (`RingedSpace.isUnit_res_basicOpen`) — superseded by the new
    `lem:isUnit_algebraMap_end_basicOpen_mathlib`.
  I did NOT remove them (removal not authorized by the directive, and they are valid `\mathlibok`
  leaves with effort 0). Recommend the plan agent decide whether to delete them or keep them as
  documentation of the abandoned route. They create no ∞ holes — only graph noise.
- The new `\lean{}` targets `...exists_isIso_fromTildeΓ_basicOpen_cover`,
  `...isIso_fromTildeΓ_of_isQuasicoherent` (gap1), and
  `...isLocalizedModule_basicOpen_of_isQuasicoherent` (G1-core) do not yet exist in Lean — expected
  (`sync_leanok` will leave them unmarked; the prover targets the sub-build first).
- Physical block order is unchanged: G1-core appears before gap1/the sub-build in the file even
  though it is logically downstream. The `\cref` forward references render fine; if the plan agent
  prefers reading order to match the dependency order, the G1-core block could be moved after gap1 in
  a future cleanup (not done here to minimize churn).

## Strategy-modifying findings
- None. The chapter now faithfully reflects the iter-028 Lean architecture (gap1 as the single
  irreducible gap, G1-core as its corollary); no strategy-level inconsistency surfaced.
