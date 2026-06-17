# Session 28 review (iter-028)

## Metadata
- **Session / iter**: session_28 = iter-028.
- **Sorry count**: 2 → 2 (no regression). Both intentional/frozen: superseded relative-form
  `CechAcyclic.lean:110` (`affine`) + frozen P5b `CechHigherDirectImage.lean:679`.
  `CechToCohomology.lean` itself is 0 sorry. (A third `sorry` token at `CechAcyclic.lean:18` is a
  docstring word, not a proof body.)
- **Lanes planned 1, ran 1** — `CechToCohomology.lean`, single mathlib-build lane.
- **+7 axiom-clean declarations** (the whole remaining 01EO chain); **0 new sorries**.
- **Build**: GREEN. `lake env lean AlgebraicJacobian/Cohomology/CechToCohomology.lean` → EXIT 0.
  Both `AbsoluteCohomology` and `CechToCohomology` are imported into the root barrel
  (`AlgebraicJacobian.lean:9-10`) — the iter-027 orphan-import must-fix is resolved.
- All four probed named targets `lean_verify`-clean (`{propext, Classical.choice, Quot.sound}`; the
  only warning is the documented `attribute [local instance] hasExtModules` at line 24).

## Headline: the entire Stacks-01EO comparison chain landed in one lane, beyond the hedge
The iter-028 plan drove the whole remaining 01EO chain in a single mathlib-build lane with a hedge that
only required L3 + the two defs + the per-face SES. The prover **exceeded the hedge**: per-face SES +
L3 + `BasisCovSystem`/`HasVanishingHigherCech` defs + L4 dimension-shift induction + the top comparison
theorem all landed axiom-clean. Combined with L1/L2 (iter-027), the 01EO chain
`cech_eq_cohomology_of_basis` is **complete**. Fifth consecutive strong iter; zero churn, zero new
sorries, zero blockers on what was attempted.

## Targets (all solved)

### `faceShortComplex_shortExact_of_sheaf_ses` (per-face SES, `lem:face_ses_of_sheaf_ses`)
- **Solved** after 3 attempts. New helper `sectionsFunctor (V) : X.Modules ⥤ Ab` =
  `toPresheafOfModules ⋙ toPresheaf ⋙ evaluation(op V)`. The face short complex is *definitionally*
  `S.map (sectionsFunctor (⨅ k, U(σk)))`.
- Attempt 1 (`show … ShortExact`): `failed to synthesize (sectionsFunctor …).PreservesZeroMorphisms`
  — instance synthesis does not see through the `def`. **Fix**: `unfold sectionsFunctor; infer_instance`
  to expose `PreservesZeroMorphisms` / `PreservesFiniteLimits`.
- Attempt 2 (anonymous-constructor `{ exact := map_of_mono_of_preservesKernel …, mono_f := …}`):
  `unexpected token '('` + type mismatch on `map_of_mono_of_preservesKernel`; the `Mono (S.map F).f`
  field needs `inferInstanceAs (Mono (F.map S.f))` (projection-vs-application mismatch).
- Attempt 3 (success): build `hex : (…).Exact` separately via
  `ShortComplex.Exact.map_of_mono_of_preservesKernel`, then `ShortComplex.ShortExact.mk hex` with the
  Mono/Epi instances in scope. Epi from `AddCommGrpCat.epi_iff_surjective` + the surjectivity
  hypothesis. `change` preferred over `show` for the defeq goal switch.

### `absoluteCohomology_one_eq_zero_of_basis` (L3 base case, `lem:absolute_cohomology_one_vanishing`)
- **Solved** after 2 attempts. Ext LES at `jShriekOU U`: injective vanishing on `I` gives
  `e.comp (mk₀ S.f) = 0`; `covariant_exact₁` produces `x₃` with `x₃.comp extClass = e`; `H⁰(g)`
  surjectivity transferred through the *natural* `absoluteCohomologyZeroAddEquiv` (the iter-027
  naturality landing) gives `x₃ = x₂.comp (mk₀ S.g)`; then `comp_assoc` + `hS.comp_extClass`
  (`g ≫ δ = 0`) + `Ext.comp_zero`.
- Attempt 1: `@_root_.Ext (jShriekOU U)` type mismatch — `jShriekOU U : X.Modules` but `_root_.Ext`
  expects `Type u`; overload to `_root_.Ext` then `failed to synth HasSmallLocalizedHom`.
- **Fix** (attempt 2): `attribute [local instance] hasExtModules` re-activates the file-local `HasExt`
  instance imported from `AbsoluteCohomology.lean` (it lands as `local instance`, inactive on import),
  so the project `Ext` (absolute cohomology) resolves without the slow `HasSmallLocalizedHom` search.

### `BasisCovSystem` (+ `CovDatum`) / `HasVanishingHigherCech` (`def:basis_cov_system` / `def:has_vanishing_higher_cech`)
- **Solved** first try. `CovDatum X := Σ ι, ι → Opens X` (lightweight cover record). `BasisCovSystem`
  carries the cover datum + two sheaf-theoretic fields `surj_of_vanishing` and `injective_acyclic`, in
  precisely the shape `ses_cech_h1` / `injective_cech_acyclic` consume (effort-breaker-sanctioned).
  `HasVanishingHigherCech` is `@[reducible]` so the field hypotheses unfold during L4 application.
- **Design carry (planner, not Lean)**: the blueprint `def:basis_cov_system` prose still describes
  condition (2) as raw cofinality + an acyclicity-lemma application, and omits the `injective_acyclic`
  field. The Lean encoding is faithful but more concrete; the prose lags (see recommendations / lvb).

### `absoluteCohomology_eq_zero_of_basis` (L4 dimension-shift induction, `lem:absolute_cohomology_pos_vanishing`)
- **Solved** after 2 attempts. `induction n` on `p = n+1` generalized over all `F` in the class:
  `Q = (injSES F).X₃` re-enters the class via per-face SES → L1 → L2 with the `injective_acyclic` field
  + `hF`; base = L3; step = `covariant_exact₁` + IH on `Q` + `Ext.zero_comp`.
- Attempt 1 tried to synthesize `EnoughInjectives X.Modules` (via `unfold Scheme.Modules; infer_instance`
  and `(inferInstance : EnoughInjectives (SheafOfModules X.ringCatSheaf))`) — **whnf-timeout even at
  `maxHeartbeats 2000000`**. The instance is **genuinely absent in Mathlib** (would follow from
  `IsGrothendieckAbelian (SheafOfModules R)`, which does not exist).
- **Fix** (attempt 2): carry `[EnoughInjectives X.Modules]` as an explicit instance hypothesis (P5a
  convention). `set P := (injSES F).map toPresheafOfModules with hP` stabilizes the per-face `hface`
  derivation; `injSES`/`injSES_shortExact` `@[reducible]` private so `(injSES F).X₁/.X₂/.X₃/.f` reduce
  to `F`/`Injective.under F`/`cokernel`/`Injective.ι F` for the defeq unifications.

### `cech_eq_cohomology_of_basis` (TOP, `lem:cech_to_cohomology_on_basis`)
- **Solved** first try. Reduce `p > 0` to `p = n+1` via `Nat.exists_eq_succ_of_ne_zero`, apply L4.
  Carries `[EnoughInjectives X.Modules]`.
- **NOTE (auditor minor)**: the name suggests an isomorphism but the theorem proves only *vanishing*
  given Čech vanishing. The docstring is accurate; the name is cosmetically misleading. Not a
  correctness issue.

## Key findings / reusable patterns
- **Functor-instance synthesis through a `def`**: `unfold <funcDef>; infer_instance` to expose
  `PreservesZeroMorphisms` / `PreservesFiniteLimits` of a composite functor hidden behind a `def`.
- **`ShortComplex.ShortExact` from a left-exact functor**: build `hex : (S.map F).Exact` via
  `ShortComplex.Exact.map_of_mono_of_preservesKernel`, get Mono via `inferInstanceAs (Mono (F.map S.f))`,
  Epi via `AddCommGrpCat.epi_iff_surjective`, assemble with `ShortComplex.ShortExact.mk hex`. Anonymous
  `{ exact := …, mono_f := …, epi_g := … }` constructor is fragile here.
- **Project `Ext` overload trap**: an imported file-local `HasExt` instance is inactive; re-activate
  with `attribute [local instance] hasExtModules`, else `Ext (X.Modules object)` overloads to
  `_root_.Ext` (`Type u` arg) and times out on `HasSmallLocalizedHom`.
- **`@[reducible]` on SES/predicate helpers** (`injSES`, `HasVanishingHigherCech`) so their projections
  / field hypotheses unfold during defeq unification and instance search in an induction.
- **`EnoughInjectives X.Modules` is absent in Mathlib** — carry it as an explicit `[EnoughInjectives …]`
  hypothesis (P5a convention); do NOT attempt to synthesize (whnf-timeout).

## Audit results
- **lean-auditor** `iter028`: axiom-clean, **0 critical / 0 major / 4 minor**, no must-fix.
  `BasisCovSystem` fields non-vacuous, `[EnoughInjectives]` is a genuine (used) hypothesis not a trick,
  `attribute [local instance] hasExtModules` is a documented perf annotation. Minors: stale module
  header (L9-14 says "L1/L2 chain"); misleading `cech_eq_cohomology_of_basis` name; 4× `show`→`change`
  linter (L57/70/135/180); line-length L79. Report:
  `task_results/lean-auditor-iter028.md`.
- **lean-vs-blueprint-checker** `cechtocohom-iter028`: **0 Lean red flags**, all proofs faithful; 3
  major **blueprint-side** items (planner's writer job, NOT Lean): (1) `def:basis_cov_system` prose
  diverges from the two-field Lean encoding + omits `injective_acyclic`; (2) 3 stale
  `% NOTE: not yet formalized` annotations — **fixed by me this iter** (see below); (3)
  `[EnoughInjectives X.Modules]` hypothesis absent from blueprint statements of
  `lem:absolute_cohomology_pos_vanishing` / `lem:cech_to_cohomology_on_basis`. Report:
  `task_results/lean-vs-blueprint-checker-cechtocohom-iter028.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `def:basis_cov_system`: stripped stale
  `% NOTE: not yet formalized — scaffold this iter` (decl now landed + `\leanok`).
- `Cohomology_CechHigherDirectImage.tex`, `def:has_vanishing_higher_cech`: stripped stale
  `% NOTE: not yet formalized — scaffold this iter`.
- `Cohomology_CechHigherDirectImage.tex`, `lem:face_ses_of_sheaf_ses`: stripped stale
  `% NOTE: target not yet formalized — scaffold this iter`.
- No `\mathlibok` / `\lean{...}` rename / `\notready` changes needed: all 6 chain pins already match the
  landed names (`BasisCovSystem`, `HasVanishingHigherCech`, `faceShortComplex_shortExact_of_sheaf_ses`,
  `absoluteCohomology_one_eq_zero_of_basis`, `absoluteCohomology_eq_zero_of_basis`,
  `cech_eq_cohomology_of_basis`).

## Bookkeeping
- `sync_leanok` iter=28: added 15, removed 2 (net positive, healthy). The iter-025/026 `\leanok`
  mis-removal anomaly did not recur.
- `archon dag-query gaps` = 0; `unmatched` = 4 (the new helpers `CovDatum`, `injSES`,
  `injSES_shortExact`, `sectionsFunctor` — listed in recommendations for the planner to blueprint).
- blueprint-doctor: clean (no orphan chapters, no broken refs, no new axioms).

## Recommendations for next session
See `recommendations.md`. Headline: 01EO chain complete → next frontier is **02KG affine Serre
vanishing** (instantiate `BasisCovSystem` at affine opens / standard covers, discharging
`surj_of_vanishing` via `ses_cech_h1` + cofinality and `injective_acyclic` via `injective_cech_acyclic`
— note a cover-representation bridge `X.OpenCover`/`coverOpen 𝒰` → `CovDatum`'s raw `ι → Opens` is
required), then the frozen P5b `cech_computes_higherDirectImage`. Blueprint-side: reconcile
`def:basis_cov_system` prose to the two-field encoding and add `[EnoughInjectives]` to the L4/top
statements.
