# AlgebraicJacobian/Cohomology/CechToCohomology.lean

## Summary
- **Declarations added (7 new, all axiom-clean):**
  - `sectionsFunctor` (def, line ~239) — sections functor `Γ(V,-) : X.Modules ⥤ Ab`.
  - `faceShortComplex_shortExact_of_sheaf_ses` (theorem, ~253) — **per-face SES** (`lem:face_ses_of_sheaf_ses`).
  - `absoluteCohomology_one_eq_zero_of_basis` (theorem, ~290) — **L3** base case (`lem:absolute_cohomology_one_vanishing`).
  - `CovDatum` (abbrev, ~318) + `BasisCovSystem` (structure, ~336) — **def** `def:basis_cov_system`.
  - `HasVanishingHigherCech` (reducible def, ~349) — **def** `def:has_vanishing_higher_cech`.
  - `injSES`, `injSES_shortExact` (private helpers, ~363/367) — injective-embedding SES.
  - `absoluteCohomology_eq_zero_of_basis` (theorem, ~376) — **L4** dimension-shift induction (`lem:absolute_cohomology_pos_vanishing`).
  - `cech_eq_cohomology_of_basis` (theorem, ~430) — **TOP** (`lem:cech_to_cohomology_on_basis`).
- **Blocked: 0.** The entire 01EO chain (L1, L2 from prior iters + per-face-SES + L3 + 2 defs + L4 + top) is now built and axiom-clean. This EXCEEDS the iter-028 hedge target (which only required L3 + 2 defs + per-face SES).
- **sorry count: 0 → 0** across the file (file builds green via `lake env lean`, EXIT 0).
- **Axioms:** every theorem verified `{propext, Classical.choice, Quot.sound}` only (`lean_verify`).
- **One design carry (see "Design decisions"):** L4 + top carry `[EnoughInjectives X.Modules]` as an
  explicit hypothesis (the instance is genuinely ABSENT in Mathlib for sheaves of modules).

## Needs blueprint entry
All 7 new non-private declarations are `lean_aux` nodes that need their `\lean{}` pins confirmed /
helpers bundled (the planner's iter-029 task #1). Pin mapping:
- `lem:face_ses_of_sheaf_ses`  → `AlgebraicGeometry.faceShortComplex_shortExact_of_sheaf_ses`
  (proof relies on: `sectionsFunctor` left-exact via `PreservesFiniteLimits` of the composite
  `toPresheafOfModules ⋙ toPresheaf ⋙ evaluation`; `ShortComplex.Exact.map_of_mono_of_preservesKernel`;
  `AddCommGrpCat.epi_iff_surjective`). **NEW helper to bundle: `AlgebraicGeometry.sectionsFunctor`.**
- `lem:absolute_cohomology_one_vanishing` → `AlgebraicGeometry.absoluteCohomology_one_eq_zero_of_basis`
  (relies on: `absoluteCohomology_eq_zero_of_injective`, `absoluteCohomology_covariant_exact₁`,
  `absoluteCohomologyZeroAddEquiv` + its `_naturality`, `ShortComplex.ShortExact.comp_extClass`,
  `Ext.comp_assoc`, `Ext.comp_zero`).
- `def:basis_cov_system` → `AlgebraicGeometry.BasisCovSystem` (**NEW helper to bundle:
  `AlgebraicGeometry.CovDatum`**).
- `def:has_vanishing_higher_cech` → `AlgebraicGeometry.HasVanishingHigherCech`.
- `lem:absolute_cohomology_pos_vanishing` → `AlgebraicGeometry.absoluteCohomology_eq_zero_of_basis`
  (relies on: `injSES`/`injSES_shortExact` (**NEW private helpers — `private` is NOT `unmatched`-exempt;
  bundle their names into the L4 `\lean{...}` list**), L1 `cechComplex_shortExact_of_basis`, L2
  `quotient_cech_vanishing_of_basis`, per-face SES, L3, `absoluteCohomology_eq_zero_of_injective`,
  `absoluteCohomology_covariant_exact₁`, `ShortComplex.exact_cokernel`, `Injective.ι`/`under`).
- `lem:cech_to_cohomology_on_basis` → `AlgebraicGeometry.cech_eq_cohomology_of_basis`.

**Blueprint reconciliation needed (planner):** the blueprint `def:basis_cov_system` describes the
cofinality field (2) as a raw topological "cofinal system" statement and lists an injective-acyclicity
*lemma* application. The Lean `BasisCovSystem` instead carries TWO sheaf-theoretic fields —
`surj_of_vanishing` (condition (2) in the section-surjectivity shape it produces through `ses_cech_h1`)
and `injective_acyclic` (the `injective_cech_acyclic` output) — because deriving these from raw
cofinality is exactly the deferred `ses_cech_h1`-plumbing. This matches the effort-breaker's intent
("cofinality stated in precisely the shape `ses_cech_h1` consumes") and the strategy-critic ruling
(predicate stays abstract, `Q` not assumed QCoh). Please update the def's prose to the field shape.

## Per-declaration detail

### sectionsFunctor / faceShortComplex_shortExact_of_sheaf_ses — RESOLVED
- **Approach:** `faceShortComplex U (S.map toPresheafOfModules) σ` is *definitionally* `S.map
  (sectionsFunctor (⨅ k, U(σk)))` (verified `rfl`). The sections functor `toPresheafOfModules ⋙
  toPresheaf ⋙ (evaluation _ _).obj (op V)` has `PreservesFiniteLimits` automatically (each factor
  does). Mono + middle-exactness from `ShortComplex.Exact.map_of_mono_of_preservesKernel`; Epi from
  the surjectivity hypothesis via `AddCommGrpCat.epi_iff_surjective`. Built via
  `ShortComplex.ShortExact.mk`.
- **Key technique:** functor-instance synthesis through a `def` needs `unfold sectionsFunctor;
  infer_instance` to expose `PreservesZeroMorphisms` / `PreservesFiniteLimits`; the `Mono (S.map F).f`
  field of `mk` needs `inferInstanceAs (Mono (F.map S.f))` (projection-vs-application mismatch).

### absoluteCohomology_one_eq_zero_of_basis (L3) — RESOLVED
- **Approach:** Ext LES at `jShriekOU U`. `e.comp (mk₀ S.f) = 0` (injective vanishing on `I`);
  `covariant_exact₁` ⇒ `x₃ : Ext .. Q 0` with `x₃.comp extClass = e`; `H⁰(g)` surjective (transfer
  `hsurj` through the *natural* `absoluteCohomologyZeroAddEquiv`) ⇒ `x₃ = x₂.comp (mk₀ S.g)`; then
  `comp_assoc` + `hS.comp_extClass` (`g ≫ δ = 0`) + `Ext.comp_zero`.
- **Setup gotcha:** the file-local `HasExt` instance from `AbsoluteCohomology.lean` is imported but
  not active (`local instance`). Re-activate with `attribute [local instance] hasExtModules`,
  otherwise `Ext (...)` overloads to `_root_.Ext` / times out on `HasSmallLocalizedHom`.

### BasisCovSystem / HasVanishingHigherCech — RESOLVED (design carry above)
- `HasVanishingHigherCech` is `@[reducible]` so the field hypotheses unfold during application in L4.

### absoluteCohomology_eq_zero_of_basis (L4) — RESOLVED
- **Approach:** `induction n` on `p = n+1`, generalized over all `F` in the class. Quotient
  `Q = (injSES F).X₃` re-enters the class via per-face-SES → L1 → L2 with `injective_acyclic` field +
  `hF`. Base = L3; step = `covariant_exact₁` + IH on `Q` + `Ext.zero_comp`.
- **`injSES` reducible** so `(injSES F).X₁/.X₂/.X₃/.f` reduce to `F`/`Injective.under F`/`cokernel`/`Injective.ι F`
  for all the defeq unifications and instance searches.

## Why I stopped
**Real progress: 7 axiom-clean declarations added — the COMPLETE 01EO chain, beyond the hedge.**
Named: `sectionsFunctor`, `faceShortComplex_shortExact_of_sheaf_ses`,
`absoluteCohomology_one_eq_zero_of_basis`, `BasisCovSystem` (+`CovDatum`), `HasVanishingHigherCech`,
`injSES`/`injSES_shortExact`, `absoluteCohomology_eq_zero_of_basis`, `cech_eq_cohomology_of_basis`.
Nothing remains blocked in this file's 01EO objective.

## Critical handoff note — `[EnoughInjectives X.Modules]`
`EnoughInjectives X.Modules` is **genuinely absent in Mathlib** for sheaves of modules: it would
follow from `IsGrothendieckAbelian (SheafOfModules R)`, which does not exist (confirmed in
`analogies/p5a.md` and `blueprint/.../Cohomology_HigherDirectImage.tex` line 29; attempting to
synthesize it `whnf`-times-out even at `maxHeartbeats 2000000` in the real build). Following the
project's P5a convention ("carry the typeclass as a hypothesis exactly as the existing signatures
do"), **L4 and the top lemma carry `[EnoughInjectives X.Modules]` as an explicit instance
hypothesis** rather than synthesizing it. Downstream consumers (02KG/P5b assembly) must thread this
instance until the single missing `IsGrothendieckAbelian (SheafOfModules R)` instance is built
(separate task: needs `Abelian` ✓ + AB5/`HasColimits` + `HasSeparator`). This is the one residual
infrastructure gap of the otherwise-complete chain.

## Next iter
1. Confirm `\lean{}` pins (mapping above); bundle `sectionsFunctor`, `CovDatum`, `injSES`,
   `injSES_shortExact` into related `\lean{...}` lists (keep `unmatched` at 0).
2. Reconcile `def:basis_cov_system` prose with the two-field Lean encoding (above).
3. (02KG `affine_serre_vanishing`) instantiate `BasisCovSystem` at affine opens / standard covers:
   discharge `surj_of_vanishing` via `ses_cech_h1` + standard-cover cofinality, `injective_acyclic`
   via `injective_cech_acyclic` (note: that lemma is stated for `X.OpenCover`/`coverOpen 𝒰` with
   `Finite 𝒰.I₀` — a cover-representation bridge to `CovDatum`'s raw `ι → Opens` is required).
4. Build `IsGrothendieckAbelian (SheafOfModules R)` to discharge `[EnoughInjectives]` globally.
