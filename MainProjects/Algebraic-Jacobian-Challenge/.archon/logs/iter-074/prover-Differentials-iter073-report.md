# AlgebraicJacobian/Differentials.lean — Lane 1 (Phase B middle, cotangent exactness)

## Summary

**Status: IN PROGRESS** (no sorry closed; structural reduction added).

- **Target (iter-073).** Close `cotangentExactSeq_structure` sub-claims
  `h_zero` (L395), `h_exact` (L399), and stretch `h_epi` (L404).
- **Result.** Net sorry count unchanged at **7 → 7**. For `h_zero` a three-step
  tactic chain reducing the goal to a PresheafOfModules-level equation is now in
  place above the inner `sorry`, with the strategy for Steps 4-7 (drop to
  PresheafOfModules via `SheafOfModules.hom_ext`, apply `isUniversal'`-postcomp
  injectivity, and the d_app vanishing chain via adjunction coherence) documented
  in detailed comments. For `h_exact` and `h_epi`, detailed strategy + Mathlib
  leverage names are recorded in comments but the inner `sorry` is unchanged.
- **No new axioms.** No edits to any other file. No edits to protected
  declarations (none are present in this file anyway).
- **Build/validation gap.** The build environment remains broken
  (`lake env lean` fails with `unknown module prefix 'Mathlib'`; LSP
  `lean_diagnostic_messages` returns `success: false`; **`lean_run_code` MCP
  silently swallows compilation errors when any import is present, returning
  `success: true` even for trivially-false claims**). Provers in this iteration
  could not validate the partial proof; the `sync_leanok` phase will be the
  authoritative compilation check once the env is repaired.

## Per-declaration analysis

### `cotangentExactSeq_structure.h_zero` (L395)
**Before** (iter-072): bare `sorry` with a one-line comment.

**Iter-073 attempt:**
```lean
apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
unfold cotangentExactSeqAlpha
simp only [Equiv.apply_symm_apply]
-- Goal at this point:
--   `⟨(isUniversal' φ_g').desc d_target⟩ ≫ (Scheme.Modules.pushforward f).map β = 0`
--   in `Y.Modules`.
sorry
```

**Strategy.** The proof of `α ≫ β = 0` hinges on the universal property of
`relativeDifferentials' φ_g'` (Mathlib's
`PresheafOfModules.DifferentialsConstruction.isUniversal'`): two PresheafOfModules
morphisms out of `relativeDifferentials' φ_g'` agree iff they postcompose with
`derivation' φ_g'` to the same Derivation (`isUniversal'.postcomp_injective`).
Composed with the adjunction injectivity for the pullback/pushforward pair,
this reduces `α ≫ β = 0` to a Derivation equality at each open U ⊆ Y, which
reduces to a pointwise vanishing `(...).hom (D_X.d ((f.c.app U).hom b)) = 0`
for each `b ∈ Y.presheaf(U)`.

Inner identity chain (for the next iteration):
1. `(β.val.app (f⁻¹ U)).hom (D_X.d x) = d2.d x` by β's universal property
   (`(derivation' φ_fg').postcomp β.val = d1` with `d1.d := d2.d`).
2. `d2.d ((f.c.app U).hom b) = 0` by `derivation' φ2'.d_app` applied after the
   adjunction-coherence identity
   `f.c = adj_f.unit.app Y.presheaf ≫ (TopCat.Presheaf.pushforward _).map φ2'`,
   which gives `(f.c.app U).hom b = (φ2'.app (f⁻¹ U)).hom ((adj_f.unit.app _).app U b)`.

**Risk note.** The tactic chain is plausible but untested due to broken build env
+ broken `lean_run_code`. The three rewrites depend on:
- `Adjunction.homAddEquiv_zero` (requires `[(pullback f).Additive]` — instance
  exists in `Scheme.Modules` namespace).
- `Adjunction.homEquiv_naturality_right` — works on goal containing
  `homEquiv (f ≫ g)`.
- `unfold cotangentExactSeqAlpha; simp only [Equiv.apply_symm_apply]` — exposes
  the inner `(homEquiv).symm ⟨desc d_target⟩` form and cancels with the outer
  `homEquiv`.

If the chain fails to elaborate, the next prover should swap in: (i) `simp only`
preceded by `Adjunction.homEquiv_naturality_right` instead of `rw`, (ii) an
explicit `show` clause to pin the goal between rewrites, or (iii) replace
`unfold` with `delta cotangentExactSeqAlpha`.

### `cotangentExactSeq_structure.h_exact` (L399)
**Before** (iter-072): bare `sorry` with a one-line comment.

**Iter-073:** detailed strategy comment added, sorry unchanged.

**Strategy.** Use the abelian-category characterisation:
`ShortComplex.Exact (mk α β h_zero)` is equivalent to the canonical map
`im α → ker β` being an iso, or equivalently, homology vanishing.

The ring-level input is again `KaehlerDifferential.exact_mapBaseChange_map`
(`Function.Exact (mapBaseChange R A B) (map R A B B)`, i.e. range equals
kernel). To globalise, one of three routes:
- **Route (a):** project-local `SheafOfModules.exact_iff_stalkwise` helper
  (analogue of `Hom.isIso_iff_isIso_app`). Stalk functor on sheaves of modules
  over a scheme preserves+reflects exactness; the stalk at `x ∈ X` is
  `Ω_{X/S,x}`, where the cotangent short complex specialises to the ring-level
  exact sequence for the local ring chain `O_{S,g(f(x))} → O_{Y,f(x)} → O_{X,x}`.
- **Route (b):** `ShortComplex.exact_iff_of_concrete_homology` with abelian-cat
  infrastructure.
- **Route (c):** direct via affine charts.

Route (a) is the pragmatic choice; it requires staging a non-trivial lemma. Left
for the next iteration.

### `cotangentExactSeq_structure.h_epi` (L404, stretch)
**Before** (iter-072): bare `sorry` with a one-line comment.

**Iter-073:** detailed strategy comment added, sorry unchanged.

**Strategy.** The ring-level input is `KaehlerDifferential.map_surjective`
(`Function.Surjective (KaehlerDifferential.map R S B B)`).

PresheafOfModules-level: `PresheafOfModules.epi_iff_surjective` characterises
epi as locally-surjective.

SheafOfModules-level: requires a project-local `epi_iff_epi_presheaf` helper
to bridge from PresheafOfModules epi to SheafOfModules epi. Mathlib does not
provide this directly. Left for the next iteration.

## Sorries remaining (7, unchanged)

- L122 `relativeDifferentialsPresheaf_isSheaf` — downstream, not iter-073 target.
- L395 `h_zero` (in `cotangentExactSeq_structure`) — partial proof added.
- L399 `h_exact` — strategy comment added.
- L404 `h_epi` — strategy comment added.
- L449 `smooth_iff_locally_free_omega` — downstream.
- L466 `cotangent_at_section` — downstream.
- L608 `serre_duality_genus` — downstream.

## Mathlib leverage names (confirmed locations)

- `KaehlerDifferential.exact_mapBaseChange_map`
  (`Mathlib/RingTheory/Kaehler/Basic.lean` L753).
- `KaehlerDifferential.map_surjective`
  (`Mathlib/RingTheory/Kaehler/Basic.lean` L710).
- `PresheafOfModules.DifferentialsConstruction.isUniversal'`
  (`Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean` L216).
- `PresheafOfModules.DifferentialsConstruction.derivation'`
  (`Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean` L210).
- `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
  (`Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean` L189).
- `PresheafOfModules.Derivation.Universal.postcomp_injective`
  (`Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean` L101).
- `PresheafOfModules.Derivation.postcomp` (line ~82, definition).
- `Adjunction.homEquiv_naturality_right`
  (`Mathlib/CategoryTheory/Adjunction/Basic.lean` L232).
- `Adjunction.homAddEquiv_zero`
  (`Mathlib/CategoryTheory/Adjunction/Additive.lean` L66).
- `SheafOfModules.hom_ext`
  (`Mathlib/Algebra/Category/ModuleCat/Sheaf.lean` L53).
- `AlgebraicGeometry.Scheme.Modules.hom_ext`
  (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean` L120).
- `PresheafOfModules.epi_iff_surjective`
  (`Mathlib/Algebra/Category/ModuleCat/Presheaf/EpiMono.lean` L59).

## Blueprint markers

- `lem:cotangent_exact_structure` (Differentials.tex L71): no closure this
  iteration — `\leanok` should remain absent. Strategy aligned with blueprint.
- `def:cotangent_alpha`, `def:cotangent_beta`: unchanged, already closed
  iter-072.
- `thm:cotangent_exact_sequence`: still gated on `cotangentExactSeq_structure`.

## Dead-end warnings (preserve across iterations)

- `Function.Exact` for SheafOfModules.Hom does NOT reduce to PresheafOfModules
  exactness directly — the pullback functor involves sheafification, which can
  collapse PresheafOfModules-level non-exactness.
- The stalk-wise route for `h_exact` requires the stalk functor's exactness
  reflection, which exists but needs a project-local helper to package.
- A direct `SheafOfModules.epi_of_epi_presheaf` is NOT in Mathlib; do not search
  for it under that name (or variants).

## Next-iteration target

Steps 4-7 of `h_zero`:
- `apply SheafOfModules.hom_ext`
- `apply (PresheafOfModules.DifferentialsConstruction.isUniversal' _).postcomp_injective`
- Derivation extensionality (`@[ext]` on `Derivation`).
- Pointwise computation chaining `Universal.fac` for α and β with the
  adjunction-coherence identity and `derivation' φ2'.d_app`.

Estimated effort: ~40-80 LOC for the inner computation, with the existing
4-step prefix providing the framework.

## Validation status

- **Build env:** broken (root-owned `.lake/packages/{mathlib,doc-gen4,checkdecls}`).
- **`lake env lean`:** fails (`unknown module prefix 'Mathlib'`).
- **LSP `lean_diagnostic_messages`:** returns `success: false`.
- **`lean_run_code` MCP:** **broken when any import is present** — silently
  returns `success: true, diagnostics: []` for code that contains clear
  compilation errors (e.g. `1 + 1 = 3 := rfl`). Only useful with no imports.
- **`lean_multi_attempt`:** returns empty goals when LSP can't elaborate.
- **Concluding:** no per-iteration validation possible; rely on `sync_leanok`
  after env repair.
