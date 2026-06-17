# AlgebraicJacobian/Differentials.lean

## Iter-083 outcome — Lane 2: `cotangentExactSeq_structure` body

**Status: STRUCTURAL PROGRESS (helper extracted) + iter-082 sorry preserved.**

- File compiles cleanly (0 errors, 5 sorries — no regression).
- Sorry budget: 5 → 5 (hard cap respected).
- Helper `cotangentExactSeqBeta_hη` landed top-level **fully closed** (no sorry).
- `cotangentExactSeqBeta` refactored to use the helper via `.choose`/`.choose_spec`.

## Sorry locations (post iter-083)

| L#   | Declaration                                       | Status   |
|------|---------------------------------------------------|----------|
| 113  | `relativeDifferentialsPresheaf_isSheaf`           | unchanged (Phase B step 1, deferred) |
| 517 (former L576) | `cotangentExactSeq_structure` `case h_rest` | unchanged (`h_exact ∧ h_epi` absorbed; iter-082 state preserved) |
| 922  | `smooth_iff_locally_free_omega`                   | unchanged (Phase B downstream, deferred) |
| 938  | `cotangent_at_section`                            | unchanged (Phase B downstream, deferred) |
| 1082 | `serre_duality_genus`                             | unchanged (Phase B downstream, deferred) |

Sorry line numbers shifted **+59 LOC** for L517 (was L576) and similar for downstream
sorries due to the new `cotangentExactSeqBeta_hη` top-level lemma + its docstring +
the comment block above `cotangentExactSeqBeta` documenting the refactor.

## What landed this iter

### Helper extraction: `cotangentExactSeqBeta_hη` (NEW, FULLY CLOSED)

Top-level lemma above `cotangentExactSeqBeta` (around L341–L411 of the new layout):

```lean
lemma cotangentExactSeqBeta_hη (f : X ⟶ Y) (g : Y ⟶ S) :
    ∃ (η : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶
            (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf),
        η ≫ ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
              Y.presheaf X.presheaf).symm f.c =
          ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
              (f ≫ g).base).homEquiv S.presheaf X.presheaf).symm (f ≫ g).c := by
  ...
```

Body is the **verbatim iter-082 inline proof** of `hη` lifted out of `cotangentExactSeqBeta`,
wrapped in `refine ⟨η, ?_⟩` + `change`. Heartbeat budget preserved
(`set_option maxHeartbeats 16000000 in`).

**Type correction** during extraction: the η codomain is `(pullback f.base).obj Y.presheaf`,
NOT `(pushforward f.base).obj ((pullback f.base).obj Y.presheaf)` as the plan-recipe
suggested. The actual inline `let η` in iter-082's `cotangentExactSeqBeta` body produces
the former type. The naming convention in the blueprint chapter
(`(g ∘ f)^{-1}\mathcal O_S ⟶ f_* (g^{-1}\mathcal O_S)`) is consistent with the *blueprint
description* but the *actual code* uses `pullback f.base Y.presheaf` as the target ring
presheaf — equivalent up to the Mathlib choice of adjunction phrasing.

### `cotangentExactSeqBeta` refactor

Modified to use the extracted helper:

```lean
noncomputable def cotangentExactSeqBeta (f : X ⟶ Y) (g : Y ⟶ S) :
    relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f := by
  let φ1' := ...
  let φ2' := ...
  let η := (cotangentExactSeqBeta_hη f g).choose
  have hη : η ≫ φ2' = φ1' := (cotangentExactSeqBeta_hη f g).choose_spec
  ...
```

**Important nuance**: cannot use `obtain ⟨η, hη⟩ := cotangentExactSeqBeta_hη f g` inside
a `noncomputable def` body — `obtain` (which uses `cases` under the hood) fails with
"recursor `Exists.casesOn` can only eliminate into `Prop`" because the surrounding
type is `Type`. The `.choose`/`.choose_spec` pattern is the correct workaround.

## What did NOT land this iter

### `h_exact ∧ h_epi` of `cotangentExactSeq_structure`

Single absorbed `sorry` preserved at the new L517 (formerly L576). Per the iter-083 plan's
conditional clause, the alternative (Option C: stalkwise-only via `exact_iff_stalkwise`)
was *not* pursued either, because adding `exact_iff_stalkwise` as a free-floating sorry
without closing the `_structure` body would be a regression (5 → 6).

### Concrete attack record (iter-083)

Three attempts on `h_epi` via Route 2:

1. `convert _root_.KaehlerDifferential.map_surjective`:
   produces an iff residual whose RHS is the FULL statement of `map_surjective`, i.e.
   ```
   Function.Surjective ⇑(ConcreteCategory.hom ((cotangentExactSeqBeta f g).val.app U)) ↔
     ∀ (R S B : Type _) [CommRing R] [CommRing S] [Algebra R S] [CommRing B] [Algebra S B]
       [Algebra R B] [IsScalarTower R S B], Function.Surjective ⇑(KaehlerDifferential.map R S B B)
   ```
   The iff residual cannot be closed without identifying the descent with
   `_root_.KaehlerDifferential.map` for specific `R,S,B` choices — exactly the
   bundled-vs-unbundled bridge documented as a blocker by iter-081/iter-082.

2. `convert _root_.KaehlerDifferential.map_surjective using 1`:
   produces the same iff residual but with `ModuleCat.Hom.hom` exposed on LHS via
   `show ... .hom`. Identical blocker.

3. `exact _root_.KaehlerDifferential.map_surjective`:
   type mismatch — `KaehlerDifferential.map_surjective` is a `∀ R S B ...` Π-type
   needing concrete instances which don't unify with the bundled `ConcreteCategory.hom`
   form.

### Underlying structural blocker

The descent `(isUniversal' φ1').desc d1 .app U` and `CommRingCat.KaehlerDifferential.map fac`
agree on the generators `d b` (both send `d b ↦ d b` by `desc_d` + `map_d` + the universal
property), so they should be equal by `CommRingCat.KaehlerDifferential.ext`. However, the
identification requires:

- A `fac : η.app U ≫ (φ2'.app U) = (φ1'.app U) ≫ 𝟙 _` coherence, obtainable from
  `congr_arg (NatTrans.app · U) hη` + `Category.comp_id`.
- The bundled `Module ((relativeDifferentials f).val.obj U)` instance is over the
  `forget₂`-image ring `(X.presheaf ⋙ forget₂ CommRingCat RingCat).obj U`, NOT directly
  over `X.presheaf.obj U`. Submodule.span_induction over this bundled module fails.
- `algebraize [(φ1'.app U).hom, (φ2'.app U).hom, (η.app U).hom]` sets up
  Algebra/IsScalarTower instances for the unbundled types but they do not unify with
  the bundled instance — `algebraize` introduces fresh instances, the bundled
  `ModuleCat.of` carries instances from the `letI := f.hom.toAlgebra` block in
  `CommRingCat.KaehlerDifferential`'s body, and the two synthesise differently even
  when definitionally equal.

A future iter-084+ closure would need either:

- (a) A new Mathlib API `CommRingCat.KaehlerDifferential.map_surjective` (bundled
  surjectivity), reducing this to its application.
- (b) A precise `KaehlerDifferential.ext`-based identification chain that survives
  the bundled-vs-unbundled instance gap. Requires careful sequencing of `letI := ...
  toAlgebra` *outside* the goal context.
- (c) A direct `Submodule.range = ⊤` argument via `KaehlerDifferential.span_range_derivation`,
  showing the range contains all `d b` and is therefore the whole module. The descent's
  action on `d b` is computable via `desc_d`. Same instance gap surfaces, but with a
  smaller surface.

## h_exact concrete obstacle

Beyond the bundled-vs-unbundled bridge, `h_exact` additionally requires:

- A `SheafOfModules.exact_iff_stalkwise` criterion: not in Mathlib. Defining it requires
  the `SheafOfModules.stalkFunctor`, which is also not in Mathlib (only `TopCat.Presheaf.stalkFunctor`
  exists at the abelian-group level — bridging to `SheafOfModules` requires the
  `ModuleCat`-stalk infrastructure which is absent).
- A stalk identification: for each `x : X.toTopCat`, the stalk
  `(relativeDifferentials f).stalk x ≅ _root_.KaehlerDifferential (𝒪_{S,(g∘f)(x)}) (𝒪_{X,x})`.
  Not in Mathlib.
- Ring-level exactness from `KaehlerDifferential.exact_mapBaseChange_map`.

Per the iter-083 plan: **do NOT introduce `SheafOfModules.exact_iff_stalkwise` as a
free-floating sorry** — that would be a regression. The iter-083 prover therefore did
not introduce it.

## Recommendation for iter-084+

**Phase B forward priority** (in order of tractability):

1. **`h_epi` closure via `_root_.KaehlerDifferential.span_range_derivation`** (Option c above).
   Skip the bundled-vs-unbundled identification entirely; show range contains all `d b`
   directly. Estimated 1-2 iters with careful `letI` sequencing.

2. **`h_exact` upstream**: requires `SheafOfModules.stalkFunctor` to be defined as a
   project-local helper (multi-iter task, likely 3-5 iters of Mathlib gap-fill). Alternative
   route via `_root_.KaehlerDifferential.exact_mapBaseChange_map` applied chart-by-chart
   on affine covers is also viable but requires substantial Phase A infrastructure.

3. **Downstream of `_structure`**: `cotangent_exact_sequence` already assembles to a
   sorry-free statement (iter-073), so no follow-on work needed there once `_structure`
   closes.

## Helpers landed across the iter-079/081/083 chain (cumulative)

| Helper | Iter | Status | File location (post iter-083) |
|--------|------|--------|-------------------------------|
| `SheafOfModules.epi_of_epi_presheaf` | 079 | closed | L496–502 |
| `_root_.PresheafOfModules.Derivation.postcomp_comp` | 081 | closed | L512–523 |
| `cotangentExactSeqBeta_hη` | 083 | closed | L341–411 (this iter) |
| `_root_.SheafOfModules.exact_iff_stalkwise` | (pending) | not introduced | — |

## Blueprint chapter

`blueprint/src/chapters/Differentials.tex` already has `\lean{...}` macros for all four
helpers (including `cotangentExactSeqBeta_hη` and `exact_iff_stalkwise`). The `\leanok`
marker on `cotangentExactSeqBeta_hη` should be added by the deterministic `sync_leanok`
phase (it now has a body without `sorry`). The `\leanok` marker on
`cotangent_exact_structure` should remain absent (the body still has 1 sorry).

The blueprint chapter `lem:cotangent_exact_seq_beta_hη` (line 119–127 of the .tex) closes
with `\end{lemma>` — a typo `lemma>` should be `lemma}` (env close). Not in this prover's
write-scope. Flagging for the review agent.

## Per-section log

### `cotangentExactSeqBeta_hη` (NEW, L341–411)
#### Attempt 1
- **Approach**: Top-level extraction of the iter-082 inline η + hη body.
- **Result**: type error initially — η codomain mis-typed as `(pushforward f.base).obj ((pullback f.base).obj Y.presheaf)` per the plan's recipe.
- **Fix**: corrected codomain to `(pullback f.base).obj Y.presheaf` to match actual usage.

#### Attempt 2
- **Approach**: Use `obtain ⟨η, hη⟩ := cotangentExactSeqBeta_hη f g` inside `cotangentExactSeqBeta`.
- **Result**: FAILED — `cases` cannot eliminate `Exists` into `Type _` (the def's return type).
- **Fix**: Replaced with `let η := (cotangentExactSeqBeta_hη f g).choose; have hη := (cotangentExactSeqBeta_hη f g).choose_spec`.

#### Attempt 3
- **Approach**: `show η ≫ φ2' = φ1'` after `refine ⟨η, ?_⟩`.
- **Result**: WORKS but emits `linter.style.show` warning (changed goal). Replaced with `change`.

### `cotangentExactSeq_structure` `case h_rest` (L495–517)
#### Attempts (this iter)
- See "Concrete attack record" section above. Three Route 2 attempts; all blocked.
- Preserved iter-082 single absorbed sorry per conditional clause.
- Documentation expanded; scaffold for iter-084+ continuation embedded as comment block.

## Compilation snapshot

```
 lean_diagnostic_messages: 5 warnings (all `declaration uses sorry`), 0 errors.
 Sorry count: 5 (L113, L517, L922, L938, L1082).
 Compilation time: well within budget.
 Heartbeat budget preserved at L431 (cotangentExactSeqBeta) and the new L341
 (cotangentExactSeqBeta_hη).
```
