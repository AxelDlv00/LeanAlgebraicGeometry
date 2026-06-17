# AlgebraicJacobian/RiemannRoch/H1Vanishing.lean — iter-195 Lane H

## Session summary

- **HARD BAR MET (axiom-clean closure)**: `Scheme.IsFlasque.shortExact_app_surjective` —
  closed the residual `SAb.Exact` gap at the former L462. Sorry count for this
  lemma: 1 → 0. Helper used: **1** (well under the 2-helper budget).
- **PUSH-BEYOND on `HModule_flasque_eq_zero`**: NOT achieved — propagation
  remains blocked on the upstream `IsFlasque.injective_flasque` (Hartshorne III
  Lemma 2.4) typed sorry at L572, which itself requires the `j_!`
  extension-by-zero functor (Mathlib `b80f227` does not ship it; ~100–150 LOC).
- **File status**: 4 sorries → **3 sorries** (net −1). Build GREEN.
  `Scheme.IsFlasque.shortExact_app_surjective` axiom-clean
  (`{propext, Classical.choice, Quot.sound}`).
- **Remaining typed sorries**: `IsFlasque.constant_of_irreducible` (L138),
  `IsFlasque.injective_flasque` (L572), `skyscraperSheaf_eq_pushforward_const`
  (L760). All three are Tier-3 substrate gaps unrelated to the iter-195 Lane H
  closure target.

## sheafCompose_preservesFiniteLimits (NEW instance, helper #1, line ~340)

- **Approach**: project-local `instance` proving
  `PreservesFiniteLimits (sheafCompose J F)` for any `F : A ⥤ B` between
  abelian categories with finite limits, when `F` preserves finite limits and
  `J.HasSheafCompose F`.
- **Proof technique**: factor through `sheafToPresheaf J B`:
  ```
  sheafCompose J F ⋙ sheafToPresheaf J B
    = sheafToPresheaf J A ⋙ (whiskeringRight _ _ _).obj F      (by rfl)
  ```
  The right side preserves finite limits (each factor does, via
  `whiskeringRight_preservesLimitsOfShape` + `sheafToPresheaf` preserves
  finite limits). Since `sheafToPresheaf J B` is fully faithful and hence
  reflects isomorphisms, `preservesFiniteLimits_of_reflects_of_preserves`
  transports preservation back to `sheafCompose J F`.
- **Result**: RESOLVED — axiom-clean.

## SAb.Exact closure (formerly L462 sorry, now line ~497)

- **Approach**: invoke `Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono`
  in the forward direction. The lemma states that for an additive functor `F`
  between abelian categories, `PreservesFiniteLimits F ↔ ∀ S, S.ShortExact →
  (S.map F).Exact ∧ Mono (F.map S.f)`. We have:
  * `Fforget = sheafCompose (Opens.grothendieckTopology X) (forget₂
    (ModuleCat kbar) AddCommGrpCat)` is additive (via the existing
    `sheafCompose_additive` instance).
  * `Fforget` preserves finite limits (via the new
    `sheafCompose_preservesFiniteLimits` instance — `forget₂ ModuleCat AddCommGrpCat`
    preserves all limits, which transports to the sheaf level by our helper).
  * `S.ShortExact` is the lemma's hypothesis.
  The `.1` projection then yields `(S.map Fforget).Exact = SAb.Exact`.
- **Result**: RESOLVED — axiom-clean (verified via `lean_verify`
  on `Scheme.IsFlasque.shortExact_app_surjective`).
- **Note**: This route avoids the substantial PreservesFiniteColimits +
  PreservesSheafification machinery that would otherwise be needed if we
  went through `Functor.preservesHomologyOfExact` → `Functor.PreservesHomology`
  → `ShortComplex.Exact.map`. The key insight is that for `S.ShortExact`
  inputs, exact preservation requires only the LEFT half (PreservesFiniteLimits)
  on the additive functor side.

## HModule_flasque_eq_zero push-beyond (NOT achieved)

- **Approach 1**: attempt to make `HModule_flasque_eq_zero` axiom-clean by
  closing the upstream `IsFlasque.injective_flasque` sorry — FAILED because
  Hartshorne III Lemma 2.4 requires the `j_!` extension-by-zero functor for
  sheaves of modules, which Mathlib snapshot `b80f227` does not ship
  (~100–150 LOC project-side build). Out of budget for iter-195.
- **Approach 2**: NONE attempted — alternative routes (e.g., a direct
  Godement-style resolution argument bypassing flasqueness) would be a
  different and larger project.
- **Next step (iter-196+)**: USER escalation OR Mathlib upstream PR for `j_!`
  on sheaves of modules. Per the standing iter-195 strategic context, this
  is analogous to the Lane A.3.i `NEEDS_MATHLIB_GAP_FILL` decision.

## Why I stopped

**Real progress**: closed 1 axiom-clean declaration on the iter-195 critical
path (`Scheme.IsFlasque.shortExact_app_surjective`, formerly the residual L462
`SAb.Exact` sorry) via a single project-local helper instance
(`sheafCompose_preservesFiniteLimits`). HARD BAR MET; helper budget = 1/2
(well under cap). Push-beyond on `HModule_flasque_eq_zero` was blocked by the
unrelated `injective_flasque` Tier-3 sorry (Hartshorne III Lemma 2.4 / `j_!`
gap) which would itself require a multi-iter substrate build, and lies outside
the explicit iter-195 helper budget.

## Blueprint marker recommendations

- `lem:isFlasque_pushforward` — already `\leanok` (declaration was
  pre-existing axiom-clean).
- `lem:isFlasque_constant_irreducible` — unchanged (still typed sorry).
- `lem:flasque_cokernel_short_exact` — already `\leanok`.
- `lem:ext_succ_zero_of_injective_lower_zero` — already `\leanok`.
- `thm:H1_vanishing_flasque` — still has sorryAx via `injective_flasque`;
  recommend NO `\leanok` until that closes.
- The new project-local instance `sheafCompose_preservesFiniteLimits` is
  not blueprint-pinned (it's an unnamed structural infrastructure helper);
  no marker change needed.
