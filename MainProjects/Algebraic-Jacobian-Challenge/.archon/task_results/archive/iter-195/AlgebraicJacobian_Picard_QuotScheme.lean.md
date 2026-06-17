# AlgebraicJacobian/Picard/QuotScheme.lean

## Status: PARTIAL — documented proof skeleton + Stage 1 `have` axiom-clean; 12 sorries (unchanged)

iter-195 Lane F target: close Beck-Chevalley intertwining at L815-area
(`pullback_app_isoTensor_baseMap_sectionLinearEquiv`) using the iter-195
plan-phase Σ-pair refactor's identities `_step1_apply` and `_step2_apply`.

**Result**: documented partial proof skeleton with named substrate gaps
(N1)-(N4). Stage 1 of the 6-stage intertwining chain is now landed as a
named `have stage1 := _step2_apply x` axiom-clean in scope, providing the
iso-characterizing identity at ⊤-sections from `step2`. The remaining
Stages 2-6 require four project-side naturality sub-lemmas (estimated
~100-150 LOC total) that are NOT in Mathlib at the pinned commit.

HARD BAR (≥1 axiom-clean closure): **NOT MET** — no full sorry closure,
but the structural advance reduces the iter-196 prover's remaining work
to closing four well-typed naturality sub-lemmas about
`pullback_app_isoTensor_baseMap`.

## `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (line 867)

### Attempt 1 (this iter): structured proof skeleton

- **Goal**: `f (1 ⊗ₜ[Γ(X,V)] x) = baseMap g N e x` where
  `f = toTensor.symm ≪≫ₗ step3` is the composition of the abstract iso
  chain at ⊤-sections (via `tilde.isoTop` + `composedIso.inv`) with the
  open-immersion section transport `step3`.

- **Approach**: decompose the chain `composedIso.inv` into 6 stages.
  With the iter-195 Σ-pair refactor providing `_step1_apply` and
  `_step2_apply` (identities at ⊤-sections), Stages 1 and 2 USE these
  identities; Stages 3-5 require `baseMap`-composition naturality
  lemmas; Stage 6 requires `step3`'s inversion identity.

- **Stage 1 (axiom-clean, landed this iter)**:
  ```lean
  have stage1 := _step2_apply x
  -- stage1 : step2.hom .app ⊤ (baseMap (Spec.map φ) (tilde ΓNV) le_top
  --           (tilde.toOpen ΓNV ⊤ x))
  --        = tilde.toOpen TR ⊤ (1 ⊗ x)
  ```
  Combined with `step2.hom_inv_id` cancellation, this gives:
  `step2.inv .app ⊤ (tilde.toOpen TR ⊤ (1 ⊗ x))
    = baseMap (Spec.map φ) (tilde ΓNV) le_top (tilde.toOpen ΓNV ⊤ x)`.

- **Stages 2-6 (substrate gaps, named in comments)**:
  - (N1) `baseMap` naturality in input sheaf — ~20-30 LOC,
    direct from `pullbackPushforwardAdjunction.unit` naturality.
  - (N2) `baseMap` compatibility with `pullbackComp` — ~30-40 LOC,
    adjunction-composition rule for the unit at a morphism triple.
  - (N3) `baseMap` compatibility with `pullbackCongr` — ~10-20 LOC,
    transport along propositional equality.
  - (N4) `step3` inversion identity for `_hU.fromSpec` — ~20-30 LOC,
    from `restrictFunctorIsoPullback` for open immersions.

- **Result**: PARTIAL — Stage 1 landed in-line as a named `have`;
  Stages 2-6 documented as a structured comment block pinning the four
  Mathlib-shaped gaps. The body still has 1 sorry at line 1078, but the
  iter-196 prover has a concrete 100-150 LOC roadmap.

### Dead-end warning

- Writing Stages 2-6 inline as `have ... := sorry` with explicit type
  signatures **fails** due to the `Γ(X, V) : CommRingCat / Ab` notation
  ambiguity at the `tilde (ModuleCat.of ↑Γ(X, V) ↑Γ(N, V))` reading.
  The elaborator cannot disambiguate when `Γ(X, V)` appears in a
  fresh `have`-type position; it succeeds inside `_step2_apply` because
  the function signature there fixes the reading.
- **Workaround for iter-196**: chain the stages via `have stageN := _`
  *without* explicit types, using `Iso.inv_hom_id_apply` /
  `_step1_apply` / Mathlib naturality lemmas to derive the form. Type
  inference will be driven by the chain composition.
- Attempted `set ΓNV : ModuleCat ↑Γ(X, V) := ModuleCat.of ↑Γ(X, V) ↑Γ(N, V)`
  to rebind step1/step2, but `set` renames the original to `step1✝`
  etc., breaking the `step2.hom_inv_id` rewrite (the iso name no longer
  matches). Avoid `set` rebinding inside this body.

### Next-iter recipe (iter-196 Lane F)

```lean
-- After stage1 in scope:
have stage2_input := -- inverse-direction of stage1 via Iso.inv_hom_id_apply
  Iso.inv_hom_id_apply step2 ⊤ x -- or similar
have stage2 := -- baseMap-naturality (N1) applied to step1.inv
  baseMap_natural (Spec.map φ) step1.inv ⊤ -- not yet in scope
-- Continue through stages 3-6 similarly.
exact (stage6).trans (?_)
```

## Other sorries (no progress this iter)

- `hilbertPolynomial` body (line 170) — Snapper's Lemma. Deep.
- `QuotFunctor` body (line 208) — substantive functor. Deep.
- `Grassmannian` body (line 245) — substantive functor. Deep.
- `Grassmannian.representable` body (line 272) — deep representability.
- `QuotScheme` body (line 326) — main theorem. Deep.
- `pullback_tildeIso` body (line 562) — Stacks 01HQ. Mathlib gap.
- `pushforward_isQuasicoherent` body (line 613) — Stacks 01XJ. Mathlib gap.
- `tildeIso_of_isQuasicoherent_isAffineOpen` body (line 641) — Stacks 01I8. Mathlib gap.
- `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
  body (line 1196) — Beck-Chevalley compatibility chain.
- `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` body (line 1255) —
  base-side Mayer-Vietoris descent.
- `canonicalBaseChangeMap_app_app_isIso_of_affineCover` body (line 1297) —
  target-side Mayer-Vietoris descent.

## Why I stopped

**Partial progress**: Stage 1 of 6 landed axiom-clean as a named `have`
(documented building block); proof skeleton with (N1)-(N4) substrate
naming added. Did NOT fully close the Beck-Chevalley intertwining;
HARD BAR (≥1 sorry closure) NOT MET.

**Infrastructure missing**: The four substrate helpers (N1)-(N4) are
not in Mathlib at the pinned commit. Each is a project-side
adjunction/naturality lemma about `pullback_app_isoTensor_baseMap`,
`Scheme.Modules.pullbackPushforwardAdjunction.unit`, and
`Scheme.Modules.restrictFunctorIsoPullback`. Total estimated
substrate work: ~100-150 LOC for iter-196.

**Could the intertwining have been closed this iter?** Per the
architectural note iter-194 + my iter-195 analysis: NO. With the
Σ-pair identities in scope, Stages 1, 2 are *reducible* to identities,
but Stages 3, 4, 5 each require a `pullbackComp`/`pullbackCongr`
naturality + baseMap-composition rule that is genuinely missing from
both Mathlib AND the project. Stage 6 requires step3's inversion
characterization. The plan agent's "USING the new identities. ~10-30 LOC"
estimate was too optimistic; realistic estimate is ~100-150 LOC over
4 named substrate helpers.

## Blueprint marker recommendations

- `lem:pullback_app_isoTensor_baseMap_sectionLinearEquiv` — KEEP as
  `\leanok` for statement; the proof body is still `sorry` (do NOT
  add `\leanok` for proof). The Stage 1 in-body progress is internal;
  the blueprint statement is unchanged.

## Lemmas found this iter

- `Scheme.Modules.Hom.comp_app` and `Hom.id_app` (Mathlib `Sheaf.lean:117-118`):
  simp lemmas for natural-transformation composition at fixed open.
  Used in Stage 1's hom_inv_id rewrite chain.
- `tilde.isoTop_hom`: `(tilde.isoTop M).hom = tilde.toOpen M ⊤` (Mathlib
  `Tilde.lean:177` with `@[simps! hom]`). Useful for Stage 1 unfolding.
- `IsQuasicoherent.of_coversTop` (Mathlib `Quasicoherent.lean`):
  cover-based quasi-coherence checker. Would feed
  `pushforward_isQuasicoherent` body via affine cover of `S`.

## Files / regions touched

- `AlgebraicJacobian/Picard/QuotScheme.lean` lines 999-1080 (body of
  `pullback_app_isoTensor_baseMap_sectionLinearEquiv` — the Step (d)
  intertwining check). Added Stage 1 `have` + (N1)-(N4) structured
  comment block.
- No other files touched. No protected signatures modified.

## Build status

GREEN: 12 sorries (unchanged from iter-194 baseline), 0 axioms, no errors.
