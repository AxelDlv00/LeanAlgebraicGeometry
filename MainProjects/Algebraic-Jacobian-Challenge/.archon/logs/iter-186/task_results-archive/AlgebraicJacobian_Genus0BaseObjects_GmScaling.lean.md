# AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean — iter-185 Lane B

## Entry state

4 sorries / 0 axioms.

- L412 `gmScalingP1_chart_agreement_cross01` (primary target this iter)
- L606 `gmScalingP1_collapse_at_zero` (stretch target)
- L688 `gm_geomIrred` (Mathlib gap; off-target)
- L718 `projGm_isReduced` (Mathlib gap; off-target)

## Exit state

4 sorries / 0 axioms. **File compiles GREEN.**

Line numbers shifted by `+24 / +110 / +138` due to inline comment expansion
(`cross01 unchanged at L412`, `collapse_at_zero L606 → L620`,
`gm_geomIrred L688 → L716`, `projGm_isReduced L718 → L746`).

Sorry decrement gate **NOT MET** (4 → 4). Per directive
`iter/iter-185/objectives.md` Lane B failure outcome (iii): iter-186 should
re-trigger analogist for Recipes 2/3 AND open the genus-0 separated-locus
alternative for the chart-bridge cross-case (per STRATEGY.md Open Qs).

## gmScalingP1_chart_agreement_cross01 (L412)

### Attempt 1 — Recipe 3 from `analogies/gmscaling-projection-idiom.md`
- **Approach**: per directive, execute Recipe 2 + Recipe 3 without adding new
  helpers. Inline as much of Recipe 2 as possible via `simp only` instead of
  packaging the projection lemmas as top-level declarations.
- **Result**: PARTIAL — structural advance only; sorry stays.
- **Concrete progress committed**: appended a `simp only [..., Iso.trans_inv,
  Iso.symm_inv, Iso.inv_comp_eq, pullback.congrHom_inv, asIso_inv]` pass after
  the iter-183 `cancel_epi (iso.inv)` step. The simp:
  - unfolds the iso definition,
  - collapses every `pullbackSpecIso`/`pullback.congrHom` outer iso into
    `pullback.map (Spec.map (algMap …)) ... ≫ id` form (the LHS), and
  - leaves the RHS with a residual `(pullbackSpecIso).hom ≫ (pullbackSpecIso).inv`
    that is `≫ id` but not yet simplified (likely because the iso is appearing
    INSIDE another composition pattern that needs `Category.assoc`
    re-normalisation first).
- **Residual goal shape** (~120-line term equality on both sides): the LHS now
  starts with `pullback.map (Spec.map (algebraMap kbar (Away (X 0 * X 1)))) ...`
  and continues through `pullbackRightPullbackFstIso.inv`,
  `pullbackSymmetry.inv`, `pullbackLeftPullbackSndIso.inv`,
  `inv (pullback.map ... pullbackAwayιIso.hom ...)`, and ends in
  `pullback.fst ((cover).f 0) ((cover).f 1) ≫ chart 0`. The RHS has the same
  structural prefix but a `(pullbackSpecIso).hom ≫ (pullbackSpecIso).inv` at
  the front.
- **Why Recipe 2's named projection lemmas would unblock**: Mathlib ships
  `Proj.pullbackAwayιIso_inv_fst/_snd` and the inv-projection lemmas for
  `pullbackRightPullbackFstIso`, `pullbackLeftPullbackSndIso`,
  `pullbackSymmetry`, but they all require the IMMEDIATE next term to be
  `pullback.fst _ _` or `pullback.snd _ _`. The chained `Iso.inv_comp_eq`
  rewrites re-arrange terms in a way that breaks the syntactic pattern.
  Named lemmas would let the prover hand-write the `pullback.hom_ext`
  decomposition once and reuse the projection at each call site.

### Attempt 2 — `pullback.hom_ext` on goal directly
- **Approach**: maybe the goal can be reduced to two simpler equalities via
  `pullback.hom_ext`.
- **Result**: FAILED — `pullback.hom_ext` unifies on `pullback f g`, not on
  the post-composition `pullback ≫ pullback.fst ≫ chart`. The pre-composition
  with `iso.inv` blocks the pattern.
- **Dead end**: this direct route.

### Attempt 3 — `IsOpenImmersion.mono.right_cancellation` to lift through `awayι (X 0 * X 1)`
- **Approach**: `awayι (X 0 * X 1)` is mono (open immersion); both sides factor
  through it after `Proj.SpecMap_awayMap_awayι` rewrites.
- **Result**: FAILED — `IsOpenImmersion.mono.right_cancellation` is not a
  shipped namespace. The Mathlib-canonical path uses `cancel_mono` which I
  would need to thread through several intermediate `≫`s before applying.

### What blocks closure this iter
- **Helper budget = 0** (per directive). Recipe 2 explicitly requires adding
  two new top-level `@[reassoc (attr := simp)] private lemma`s
  (`gmScalingP1_cover_intersection_X_iso_inv_{fst,snd}`); inline `have` blocks
  do not have the same simp-set effect because the `Iso.trans_inv` chain
  re-introduces the same iso pattern at each unfold step. The directive's
  "WITHOUT adding new helpers" is incompatible with Recipe 2 as written; this
  conflict surfaced as the actual blocker.
- **iso shape**: even with Recipe 2 helpers, the iso's tactic-mode
  construction (`refine … ≪≫ ?_; refine …; exact …`) means the elaborated
  term does NOT present as a single `Iso.trans`-spine that simp can walk.
  iter-186+ pickup path (a) per the lemma's docstring is to refactor the iso
  to term-mode.

### Next-iter pickup
- iter-186 plan-phase should dispatch the analogist again with the directive
  "execute Recipes 2 + 3 as written, accepting the +2 helper budget violation".
  Alternatively the analogist could be re-tasked to either:
  - Refactor `gmScalingP1_cover_intersection_X_iso` to term-mode (path (a));
  - Bypass the iso via the per-chart `gmScalingP1_chart_PLB_eq` bridge plus a
    separating sheaf argument (path (c)).
- Open the genus-0 separated-locus alternative per STRATEGY.md Open Qs if
  iter-186 also stalls.

## gmScalingP1_collapse_at_zero (L620)

### Attempt 1 — `Over.OverMorphism.ext` structural lift
- **Approach**: lift to `.left` equality on Scheme, then apply
  `Cover.hom_ext` on `gmScalingP1_cover` to reduce to per-chart identity.
- **Result**: PARTIAL — `apply Over.OverMorphism.ext; simp only [Over.comp_left,
  Over.lift_left]` lands cleanly. Goal is now:
  ```
  pullback.lift ((toUnit Gm).left ≫ zeroPt.left) ((𝟙 Gm).left) _
    ≫ gmScalingP1.left = (toUnit Gm).left ≫ zeroPt.left
  ```
  Next step would be to unfold `gmScalingP1 = Over.homMk (glueMorphisms …) …`
  and reduce via `ι_glueMorphisms`. This requires either:
  - A `pullback.lift … ≫ glueMorphisms.f 1` chase factoring through chart-1
    of the cover (needs the `pullback.lift _ _ _ ≫ pullback.fst = _` step plus
    the chart-1 factorisation of `(toUnit ≫ zeroPt).left`); OR
  - Explicit construction of the section `s : Gm.left ⟶ (cover).X 1` from
    `analogies/intersection-ring-cross01.md` Decision 4 (~30-50 LOC), inlined
    as `have`s to respect the helper budget.

### Dead-end warnings
- Bare `aesop` / `simp` after the structural lift make no progress (the
  `glueMorphisms` unfold needs the cocycle hypothesis term, which Lean cannot
  synthesize without the explicit per-chart equality).

## gm_geomIrred (L716)

### Attempt 1 — `infer_instance`
- **Approach**: see if Mathlib can synthesize the instance directly.
- **Result**: FAILED — Mathlib does not ship a `Spec(domain over alg-closed)
  → GeometricallyIrreducible` bridge. The closest is
  `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms` which would
  require proving `IrreducibleSpace (pullback Gm.hom (Spec.map (algMap kbar K)))`
  for every K, i.e. `Spec(K[t, t⁻¹])` is irreducible.
- **Why hard**: requires the tensor-product-is-domain-over-field bridge
  (`Algebra.TensorProduct.isDomain_of_isAlgClosed_left` or similar) which
  is itself a Mathlib gap noted in STRATEGY.md.

## projGm_isReduced (L746)

### Attempt 1 — chart-cover via `IsReduced.of_openCover` over `gmScalingP1_cover`
- **Approach**: each chart is `Spec((Away (X i)) ⊗[kbar] GmRing)`; both factors
  are domains, so the tensor (over a field) is a domain (hence reduced).
- **Result**: NOT ATTEMPTED — blocked by the same tensor-of-domains-over-field
  Mathlib gap as `gm_geomIrred`.

## Summary

| Sorry | Outcome | Type |
|---|---|---|
| `cross01` (L412) | PARTIAL (simp advance, sorry kept) | structural |
| `collapse_at_zero` (L620) | PARTIAL (Over.ext + simp advance, sorry kept) | structural |
| `gm_geomIrred` (L716) | NO_PROGRESS | Mathlib gap |
| `projGm_isReduced` (L746) | NO_PROGRESS | Mathlib gap |

Net sorry delta: 0 (4 → 4). Helper budget consumed: 0/0. Decrement gate
**failed**; iter-186 escalation triggered per directive.

## Mathlib lemmas confirmed present (iter-185)

- `Proj.SpecMap_awayMap_awayι` (`ProjectiveSpectrum/Basic.lean:250-255`,
  `@[reassoc]`) — factors `awayι X` through `awayι (X * Y)` after
  `Spec.map (awayMap …)`.
- `Proj.pullbackAwayιIso_inv_fst` / `_inv_snd`
  (`ProjectiveSpectrum/Basic.lean:291-301`, `@[reassoc (attr := simp)]`).
- `Proj.pullbackAwayιIso_hom_SpecMap_awayMap_left` / `_right`
  (`ProjectiveSpectrum/Basic.lean:275-289`, `@[reassoc (attr := simp)]`).
- `GeometricallyIrreducible` class
  (`Geometrically/Irreducible.lean:42-43`), with
  `GeometricallyIrreducible.comp` (`:121-127`),
  `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms`
  (`Geometrically/Basic.lean:136-144`).

## Mathlib lemmas NOT shipped (confirmed gaps)

- `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` or any equivalent
  bridge from "factor is alg-closed + other factor is domain" to "tensor is
  domain". Blocks both `gm_geomIrred` and `projGm_isReduced`.
- Direct `Spec(domain) ⟶ Spec kbar` ⟹ `GeometricallyIrreducible` shortcut
  for the localised case. Blocks `gm_geomIrred`.
- `pullback.lift_fst/snd` as `@[simp]` (only `@[reassoc]` shipped). Project
  patched via `pullback_map_fst_proj/snd_proj` helpers in iter-184.

## Directive conflict (for planner)

The iter-185 directive contains an internal contradiction that surfaced as
the load-bearing blocker for this iter:

> Lane B Critical constraint: Helper budget = 0. Do not add any new
> `private lemma` or `local def` declarations.

vs

> Lane B Recipe 2: Prove `gmScalingP1_cover_intersection_X_iso_inv_fst`
> and `gmScalingP1_cover_intersection_X_iso_inv_snd` via simp chain ...

Recipe 2 literally adds two new `private lemma` declarations. Without them,
Recipe 3 (the cross01 closure) cannot fire because inline `have` blocks do
not give the same simp-set effect (simp walks each occurrence of
`Iso.trans_inv` afresh and the resulting term is too large for `simp` to
find the inline hypothesis).

iter-186 planner needs to either:
1. Relax the helper budget to +2 (matching Recipe 2's explicit cost), OR
2. Re-dispatch the analogist with a directive variant that produces a
   recipe with literally zero new helpers (e.g. refactor the iso definition
   to term-mode so Mathlib's existing simp lemmas walk it).
