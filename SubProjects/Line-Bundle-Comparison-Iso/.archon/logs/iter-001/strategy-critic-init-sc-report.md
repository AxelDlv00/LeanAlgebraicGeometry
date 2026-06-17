# Strategy Critic Report

## Slug
init-sc

## Iteration
001

## Routes audited

### Route: D3′ — the comparison iso (`TensorObjSubstrate.lean`)

- **Goal-alignment**: PASS — `f^*(M⊗N) ≅ f^*M ⊗ f^*N` on loc-triv pairs is exactly the additivity-of-pullback the relative-Picard group hom needs; feeds `map_add` of the third seed.
- **Mathematical soundness**: PASS — the chart-wise upgrade of δ (`pullbackTensorMap`) to an iso via `isIso_of_isIso_restrict` over `{f⁻¹(Uᵢ)}`, each chart reduced to the unit pair via `pullbackUnitIso`, is the standard monoidal-functor argument. Verified the supporting decls exist: `pullbackTensorMap` (TensorObjSubstrate.lean:1205), `pullbackUnitIso` (:1045), `IsLocallyTrivial.pullback` (LineBundlePullback.lean:156).
- **Sunk-cost reasoning detected**: no — the "D1′/D2′/Sq2…CLOSED" listing is status, not a merits-substitute justification; the route is argued on the reduction-to-unit-pair, and a non-circular fallback for Sq1 is recorded.
- **Infrastructure-deferral detected**: no — the one hard step (Sq1 mate-calculus) is named, scoped, and carries an explicit non-circular fallback (`conjugateEquiv` surjectivity/injectivity). It is on the critical path and the strategy keeps it there with a plan, not a deferral.
- **Phantom prerequisites**: `Adjunction.Mates.conjugateEquiv_whiskerLeft` is listed under "Key Mathlib needs" but does not exist in Mathlib under that name (the base `CategoryTheory.conjugateEquiv` and `_id`/`_comm`/`_comp` companions do; no `_whiskerLeft`). It is a to-build project helper, not a free import — see Prerequisite verification.
- **Effort honesty**: reasonable — ~3–5 iters / ~120–300 LOC for a mate-calculus square plus a chart-chase is defensible, though Sq1 is the term most likely to overrun; the LOC ceiling absorbs that.
- **Parallelism under-exploited**: no — runs concurrently with DUAL in its own file.
- **Verdict**: SOUND

### Route: DUAL — the dual-inverse (`DualInverse.lean`)

- **Goal-alignment**: PASS — dual of loc-triv is loc-triv plus `L⊗Linv≅𝒪` is precisely the group inverse, and the witness stays in the `IsLocallyTrivial` carrier, so group closure holds.
- **Mathematical soundness**: PASS — `L^∨⊗L≅𝒪` for an invertible sheaf is standard; the route-2 sectionwise transport (leg-A slice-Hom base-change ∘ leg-B unit ε-iso) is a concrete realization. Seed `dual_isLocallyTrivial` already exists as a declaration (DualInverse.lean), and `exists_tensorObj_inverse` (TensorObjSubstrate.lean:690) is in place.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — `sliceDualTransport` / `restrictScalarsLaxε` are explicitly flagged as by-hand project material in `## Mathlib gaps & new material`, with the building mechanism (ε-naturality via the lax structure) named. The construction is on the critical path and the strategy builds it.
- **Phantom prerequisites**: `PresheafOfModules.restrictScalarsLaxε` does not exist in Mathlib (base `PresheafOfModules.restrictScalars` does); the strategy correctly treats it as built-by-hand, so this is a labeling note, not a broken dependency.
- **Effort honesty**: reasonable — ~3–5 iters / ~100–250 LOC; the `dual_restrict_iso` naturality chase is the realistic overrun risk and is the named single remaining link.
- **Parallelism under-exploited**: no — independent of D3′, self-contained file.
- **Verdict**: SOUND

### Route: Consumer — `PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`)

- **Goal-alignment**: PASS — assembles the third seed (the `AddCommGroup` on `Pic♯_{C/k}`) from the two routes: `map_add` ← D3′, `map_zero` ← `pullbackUnitIso`, inverse ← DUAL.
- **Mathematical soundness**: PASS — by-hand `AddCommGroup` on loc-triv iso-classes modeled on the existing `CommRing.Pic.mapAlgebra` (verified `CommRing.Pic` exists, Mathlib/RingTheory/PicardGroup.lean). The justification for going by-hand (no varying-ring monoidal structure on `X.Modules` in Mathlib) is correct: a fixed-`MonoidalCategory` sheaf-monoidal structure cannot host the change-of-base tensor here. Minor observation, not a blocker: the strategy attributes `map_add` to the comparison iso while `map_zero` comes from the unit iso — the blueprint should make explicit which group axioms (assoc/comm) ride the monoidal associator vs. the comparison iso, so the consumer doesn't silently assume the iso discharges more than additivity-of-pullback.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none — `RelPicFunctor.lean` compiles clean today.
- **Effort honesty**: reasonable — ~1–2 iters / ~30–80 LOC for an assembly gated on two ready isomorphisms; the by-hand axiom bundle is mechanical once both inputs land.
- **Parallelism under-exploited**: no — correctly marked BLOCKED and gated on both routes; serializing it is forced by a genuine data dependency, not a planning miss.
- **Verdict**: SOUND

## Format compliance

- **Size**: ~95 lines / ~5 KB — within budget.
- **Headings**: FAIL — section order is `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, **`## Out of scope`**. The last is not in the canonical skeleton (`## Goal`, `## Phases & estimations`, `## Completed`(optional), `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`). `## Completed` is correctly omitted (no whole phase is done; the "CLOSED" items are sub-steps inside ACTIVE phases).
- **Per-iter narrative detected**: no — "Sq1/Sq2…CLOSED" are step labels, not iter references; no "this iter"/"last iter" prose.
- **Accumulation detected**: no — no completed phase squatting in the active table, no excised routes, no prose-history bloat.
- **Table discipline**: PASS — `## Phases & estimations` has the canonical columns (Phase | Status | Iters left | LOC | Key Mathlib needs | Risks), inline `ACTIVE`/`BLOCKED` status tags, and `LOC` as remaining-range cells.
- **Format verdict**: DRIFTED

The only deviation is the extra `## Out of scope` section. Its content (sibling-extract boundaries: Quot-Foundations, Cech-Cohomology, parent-scope drops) is genuinely useful, but it belongs folded into `## Open strategic questions` (or a one-line note in `## Goal`) rather than as a non-canonical top-level heading that re-enters the plan agent's context every iter. Recommend folding this iter; not escalated to NON-COMPLIANT since every other format dimension is clean.

## Prerequisite verification

- `CategoryTheory.conjugateEquiv`: VERIFIED (Mathlib/CategoryTheory/Adjunction/Mates.lean).
- `Adjunction.Mates.conjugateEquiv_whiskerLeft`: MISSING — no Mathlib lemma of this name (only `conjugateEquiv` + `_id`/`_comm`/`_comp`). Treat as a to-build project helper, not a Mathlib import; the recorded Sq1 fallback (conjugateEquiv surjectivity/injectivity) does not need it, so the route survives either way.
- `CategoryTheory.Adjunction.leftAdjointUniq`: VERIFIED (Mathlib/CategoryTheory/Adjunction/Unique.lean).
- `leftAdjointUniqUnitEta_app`: VERIFIED — project-local (TensorObjSubstrate.lean), already built.
- `PresheafOfModules.restrictScalars`: VERIFIED (Mathlib/Algebra/Category/ModuleCat/Presheaf/ChangeOfRings.lean).
- `PresheafOfModules.restrictScalarsLaxε`: MISSING as named — built-by-hand per `## Mathlib gaps & new material`; labeling is consistent with the strategy's own gap list.
- `CommRing.Pic` (model for `mapAlgebra`): VERIFIED (Mathlib/RingTheory/PicardGroup.lean).

## Overall verdict

All three routes are mathematically sound and goal-aligned: the comparison iso supplies additivity-of-pullback, the dual supplies the group inverse within the loc-triv carrier, and the consumer assembles the `AddCommGroup` on `Pic♯_{C/k}` by hand on a verified Mathlib model (`CommRing.Pic`). There is no infrastructure-deferral pattern — the two genuinely-hard prerequisites (Sq1 mate-calculus, `dual_restrict_iso` naturality) are named, kept on the critical path, and carry concrete plans/fallbacks rather than being shipped "upstream" or to "future work." Parallelism is properly exploited (D3′ ∥ DUAL, consumer correctly gated). Two named "Key Mathlib needs" — `conjugateEquiv_whiskerLeft` and `restrictScalarsLaxε` — are not Mathlib lemmas; they are project helpers to build, so the planner should relabel `conjugateEquiv_whiskerLeft` out of the "Key Mathlib needs" column (its base `conjugateEquiv` is the real import) to avoid implying a free dependency. The single format deviation (`## Out of scope` non-canonical heading) is DRIFTED, not blocking — fold it into `## Open strategic questions` this iter. No CHALLENGE or REJECT verdicts.
