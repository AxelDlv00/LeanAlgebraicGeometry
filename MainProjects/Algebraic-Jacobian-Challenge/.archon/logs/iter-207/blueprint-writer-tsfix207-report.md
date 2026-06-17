# Blueprint Writer Report

## Slug
tsfix207

## Status
COMPLETE — all five directive fixes applied to the single target chapter; LaTeX environments balanced (36/36); no `\leanok`/`\mathlibok` markers touched.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **FIX 1 (must-fix F1) — rewrote the proof of `lem:tensorobj_restrict_iso`** into a four-step formalizable categorical route, replacing the old "flat-exactness alone gives the iso" sketch:
  - Step 1: reduce `·|_f` to the abstract pullback via `Scheme.Modules.restrictFunctorIsoPullback`.
  - Step 2: move pullback inside sheafification via `SheafOfModules.sheafificationCompPullback` (explicitly correcting the older "sheafification does not commute with pullback" claim).
  - Step 3: the comparison map IS the oplax-monoidal `δ` of the left adjoint, from the already-present Mathlib `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` applied to `PresheafOfModules.pullbackPushforwardAdjunction φ`; its hypothesis `[(pushforward φ).LaxMonoidal]` is supplied by the new `lem:restrictscalars_laxmonoidal`.
  - Step 4: flatness (`Module.Invertible ⇒ Projective ⇒ Flat`, `Module.Invertible.lTensor_bijective_iff`) **upgrades** `δ` to an iso — stated explicitly as NOT a substitute for constructing the map.
  - Gluing via `hom_ext`.
- **FIX 1 — replaced the stale `% NOTE (iter-206 review)` block** inside `lem:tensorobj_restrict_iso` with a short accurate `% NOTE`: comparison map comes from the already-present `leftAdjointOplaxMonoidal`; sole remaining project-side ingredient is `lem:restrictscalars_laxmonoidal`; this is a bounded `mathlib-build` target (~40–90 LOC), not a multi-file wall.
- **FIX 2 (must-fix F1, cont.) — added new lemma `lem:restrictscalars_laxmonoidal`** (with proof sketch) immediately before `lem:tensorobj_restrict_iso`: states `PresheafOfModules.restrictScalars φ` is lax monoidal (CommRingCat-factored φ), hence `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ` is lax monoidal via `Functor.LaxMonoidal.comp`. Proof sketch = sectionwise lift of `ModuleCat.restrictScalars` lax-monoidal lemma (`rightAdjointLaxMonoidal` of `extendRestrictScalarsAdj`), assembled as a `Functor.CoreLaxMonoidal`; ~40–90 LOC; CommRingCat setup constraint noted (project's `φ` is structure-sheaf-valued). No `\lean{...}` pin added (per directive). Added `\uses{def:scheme_modules_tensorobj}`; `lem:tensorobj_restrict_iso` statement + proof now `\uses{... lem:restrictscalars_laxmonoidal}`.
- **FIX 3 (M2) — narrowed `lem:scheme_modules_tensorobj_functoriality`**: statement now delivers only the bifunctor morphism action `f ⊗ g`; the λ/ρ/α/β monoidal coherence data are stated as NOT outputs (no Lean decl, off critical path) and pointed to `rem:scheme_modules_monoidal_off_path`. Proof trimmed correspondingly to the bifunctorial action only.
- **FIX 4 (M3) — annotated `lem:tensorobj_lift_onproduct`** with a `% NOTE` that the Lean target `tensorObjOnProduct` provides ONLY operation-closure on the subtype; unit-membership, dual/inverse, and group-law existence-of-iso data are SEPARATE items each blocked on `lem:tensorobj_restrict_iso` (→ `lem:restrictscalars_laxmonoidal`).
- **FIX 5 (M4) — added blocking `% NOTE`s** to `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`, `lem:pullback_compatible_with_tensorobj`: "no Lean declaration yet; blocked on lem:tensorobj_restrict_iso (which is blocked on lem:restrictscalars_laxmonoidal)."
- **Minor (required by FIX 2) — internal-consistency check**: added a bullet for the new `lem:restrictscalars_laxmonoidal` and updated the `lem:tensorobj_restrict_iso` bullet's `\uses` to keep the dependency-graph description accurate.

## Cross-references introduced
- `\uses{lem:restrictscalars_laxmonoidal}` added in `lem:tensorobj_restrict_iso` (statement + proof) — target `lem:restrictscalars_laxmonoidal` is defined in this same chapter (new block).
- FIX 3/4/5 NOTEs reference existing in-chapter labels (`rem:scheme_modules_monoidal_off_path`, `lem:tensorobj_restrict_iso`, `lem:restrictscalars_laxmonoidal`) — all resolve in this chapter.

## References consulted
None. Per directive, this is primarily a Mathlib-formalization-route statement and the classical-fact citation was optional; no reference-retriever was dispatched and no new `% SOURCE`/`% SOURCE QUOTE` blocks were written. (The pre-existing Kleiman citation blocks in the motivation and consumer theorem were left untouched.)

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Out-of-scope prose now mildly inconsistent with the corrected route.** Two unaffected sections still use the old "for line bundles it is elementary flat-exactness already available in Mathlib" framing, which the FIX 1 rewrite supersedes (flatness now only *upgrades* an abstractly-constructed map):
  - Motivation section (`sec:tensorobj_motivation`), the paragraph ending "...for *line bundles*, which are flat, that compatibility is *elementary flat-exactness*, not internal-hom machinery."
  - API survey (`sec:tensorobj_api_survey`), "...and for line bundles it is elementary flat-exactness already available in Mathlib." Also the LOC-estimate Piece 2 bullet describes `tensorObj_restrict_iso` purely as "elementary flat-exactness" without the mate/`leftAdjointOplaxMonoidal` step.
  The directive explicitly placed motivation / API survey / LOC estimates out of scope, so I did not edit them. Consider a follow-up writer round to align this framing if the reviewer flags it.
- The new `lem:restrictscalars_laxmonoidal` has no `\lean{...}` pin by design; the prover creates the Lean declaration this iter and `sync_leanok` will add the pin/marker afterward.

## Strategy-modifying findings
None. The corrected route (per `analogies/mate207.md`) is sound and reduces the project-side obligation to a single bounded sectionwise lax-monoidal instance; nothing surfaced that contradicts STRATEGY.md.
