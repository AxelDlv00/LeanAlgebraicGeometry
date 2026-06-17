# Blueprint Writer Report

## Slug
bw252

## Status
COMPLETE — all three math-content updates landed in `Picard_TensorObjSubstrate.tex`; no other chapter touched, no markers added.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### 1. New tracked block `lem:dual_unit_iso` (was named-but-untracked)
- **Added lemma** `\lemma[Dual of the structure sheaf]` / `\label{lem:dual_unit_iso}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` /
  `\uses{lem:internal_hom_eval, lem:internal_hom_isSheaf, lem:tensorobj_unit_iso}`.
  Statement: `dual 𝒪_Y ≅ 𝒪_Y`, obtained by sheafifying the presheaf-level
  "evaluation at 1" iso `ℋom(𝟙,𝟙) ≅ 𝟙` (every unit-endomorphism is multiplication by its
  value at the global section 1). Inserted directly before `lem:dual_isLocallyTrivial`.
- **Added a short proof block** for it (presheaf eval-at-1 ⇒ sheafify), citing the same three
  lemmas. (No `\leanok` added — sync_leanok owns that.)
- Verified the Lean decl exists: `DualInverse.lean:272` `def dual_unit_iso`, core
  `presheafDualUnitIso` at `DualInverse.lean:261`.
- **Updated Step-3 reference** in `lem:dual_isLocallyTrivial`'s proof: `(\(\mathtt{dual\_unit\_iso}\))`
  → `(\cref{lem:dual_unit_iso})`.
- **Removed** the stale `% NOTE: (review iter-251 …) dual_unit_iso is named here but …` comment.
- **Added `lem:dual_unit_iso` to the `\uses`** of `lem:dual_isLocallyTrivial` (both the lemma
  block and its proof) so the dependency graph carries the edge.

### 2. Rewrote Step 4 of `lem:dual_restrict_iso` into the (A)+(B) decomposition
- Replaced the old `(a)/(b)/(c)` ingredient sketch with the **two-leg** structure established by
  the `analogies/dual252.md` consult:
  - **Opening paragraph** now states the dual is *not sectionwise*: `(dual M)(V) = ℋom(M|_V, 𝒪|_V)|_{Over V}`
    over the whole down-set, not a single fibre `M(V) → 𝒪(V)`; hence the transport does NOT reduce
    to a single ground-ring reconciliation and factors into two legs.
  - **Leg (A) — slice-site Hom base-change (Beck–Chevalley):** transport of the domain presheaf
    `restr_V(f_*M)` over `Over V ⊆ Opens Y` to `restr_{fV} M` over `Over fV ⊆ Opens X` across the
    fully-faithful `f.opensFunctor` restricted to the down-set of `fV`; a genuine slice equivalence,
    not a fibrewise identity.
  - **Leg (B) — ground-ring reconciliation:** unit codomain reconciled along
    `β_V : 𝒪_X(fV) ≅ 𝒪_Y(V)`, the content of (closed) `\cref{lem:restrictscalars_ringiso_dualequiv}`;
    noted as the module-level dual analogue of the ring-iso tensor equivalence of the tensor lane's H2.
  - **Why H2's `restrictScalarsMonoidalOfBijective` has no direct dual analogue:** tensor is sectionwise
    so its transport collapsed to leg (B) alone; the dual's non-sectionwise nature forces the extra leg (A).
  - **Cautionary (visible) sentence:** the naive "fixed-value-category slice equivalence"
    (sheaf-level `overSliceSheafEquiv`) is NOT applicable to leg (A) — that residual lives at the
    presheaf level with a varying per-section ring `𝒪_Y(V)` and finer slicing.
  - **Alternative route recorded (not committed):** derive from `\cref{lem:tensorobj_restrict_iso}`
    by uniqueness of monoidal inverses via eval/coeval naturality.
- `\uses` of the lemma/proof left unchanged (the alternative route is a `\cref` mention only, not a
  real dependency edge).

### 3. One math sentence in `lem:pullback_tensor_map_natural` (D1′)
- Replaced the `% NOTE: (review iter-251 …)` Lean-idiom comment with ONE math sentence: the fourth
  square (naturality of `sheafifyTensorUnitIso`) reduces, after expanding the comparison into its
  whisker factors, to the naturality of the sheafification unit `η` in each tensor argument
  (`p` then `η` = `η` then `sheafification.map p`), the middle crossings handled by the monoidal
  interchange (whisker-exchange) law. No Lean instance-elaboration idiom mentioned.

## Cross-references introduced
- `\uses{lem:internal_hom_eval, lem:internal_hom_isSheaf, lem:tensorobj_unit_iso}` in
  `lem:dual_unit_iso` (block + proof) — all three exist (L5078, L5147, L1563).
- `lem:dual_unit_iso` added to `\uses` of `lem:dual_isLocallyTrivial` — exists (L5501).
- `\cref{lem:tensorobj_restrict_iso}` in `lem:dual_restrict_iso` proof (alternative-route mention) —
  exists (L560).
- All label existence re-verified by grep after editing.

## References consulted
- `analogies/dual252.md` — the (A)+(B) decomposition of the Step-4 residual, the
  `restrictScalarsRingIsoDualEquiv` = leg (B) identification, why H2 has no dual analogue, the
  `overSliceSheafEquiv` caution, and the inverse-uniqueness alternative route. (Project analogy
  artifact, not an external `references/` source — no `% SOURCE` citation added or changed.)
- `analogies/whisker252.md` — confirmed the D1′ residual is the sheafification-unit naturality `η`
  with whisker-exchange middle crossings (used only to phrase the one math sentence; the Lean idiom
  was deliberately NOT transcribed, per directive).
- No external `references/<file>.md` opened: no new `% SOURCE` / `% SOURCE QUOTE` blocks were
  written. The pre-existing Stacks citations on `lem:dual_restrict_iso` and `lem:dual_isLocallyTrivial`
  were left verbatim and untouched.

## Macros needed (if any)
- None. All new commands used (`\cref`, `\mathtt`, `\mathcal`, `\xrightarrow`, `\mathbf`, `\le`,
  `\subseteq`) are already in use throughout the chapter.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- `lem:dual_unit_iso` now has a `\lean{}` pin; once `sync_leanok` runs it should pick up `\leanok`
  (the Lean decl `dual_unit_iso` is reported closed/axiom-clean in the directive and exists in
  `DualInverse.lean:272`).
- The Step-4 prose now flags leg (A) (slice-site Beck–Chevalley base-change at the presheaf /
  varying-ring level) as the substantive open build for `dual_restrict_iso`, with
  `restrictScalarsRingIsoDualEquiv` supplying only leg (B). If the prover finds leg (A) expensive,
  the recorded alternative (derive from `tensorObj_restrict_iso` by monoidal-inverse uniqueness) is
  a documented fallback — but it is a `\cref` mention only and is NOT in any `\uses` edge.
- Off-path `% NOTE: ABANDONED` blocks (`lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`) were
  left untouched, per directive.

## Strategy-modifying findings
None. The (A)+(B) decomposition refines the proof sketch but does not change the project strategy:
`dual_restrict_iso` remains the C-bridge feeding `dual_isLocallyTrivial`, and the closed ingredient
`restrictScalarsRingIsoDualEquiv` is still the correct ground-ring atom.
