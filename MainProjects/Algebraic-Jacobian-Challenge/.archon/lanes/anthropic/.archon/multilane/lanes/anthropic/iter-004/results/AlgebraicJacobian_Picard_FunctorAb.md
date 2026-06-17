# AlgebraicJacobian/Picard/FunctorAb.lean

Iteration 004 — prover round, Objective 2 (Phase C step 3 codomain change).

## Summary

The single sorry in this file (L41 `AlgebraicGeometry.Scheme.PicardFunctorAb`)
is **closed**. The file now compiles cleanly with **no diagnostics** and **no
new axioms** (verified via `lean_verify`: only `propext`, `Classical.choice`,
`Quot.sound`).

Sorry count for this file: **0** (was 1).

## PicardFunctorAb (line 41)

### Attempt 1 — `MonoidHom.toAdditive` + `Additive`-wrapped quotient
- **Approach.** The plan-agent briefing suggested wrapping the multiplicative
  quotient `Pic(C ×_k S) / p_S^* Pic(S)` directly via `AddCommGrpCat.ofHom`
  applied to a `MonoidHom`. A `lean_loogle` query for `AddCommGrpCat.ofHom`
  showed its true signature is

  ```
  AddCommGrpCat.ofHom {X Y : Type u} [AddCommGroup X] [AddCommGroup Y]
      (f : X →+ Y) : AddCommGrpCat.of X ⟶ AddCommGrpCat.of Y
  ```

  i.e. it requires an `AddMonoidHom` between `AddCommGroup`s, not a
  `MonoidHom` between `CommGroup`s. The cleanest type-theory-only transport
  uses Mathlib's `Additive`/`Multiplicative` duality:
  - `Additive G` carries an `AddCommGroup` instance whenever `G : Type u`
    has `[CommGroup G]` (Mathlib's `Multiplicative.toAdd` / `Additive` API
    in `Mathlib.Algebra.Group.TypeTags`).
  - `MonoidHom.toAdditive : (α →* β) ≃ (Additive α →+ Additive β)` ports
    a `MonoidHom` to the corresponding `AddMonoidHom`.

  So `obj` wraps the quotient in `Additive`, and `map` post-composes
  `PicardFunctor.quotMap` with `MonoidHom.toAdditive` before bundling via
  `AddCommGrpCat.ofHom`.

- **Result.** RESOLVED. All four pieces (`obj`, `map`, `map_id`, `map_comp`)
  type-check; `lean_diagnostic_messages` reports zero items on the file.

- **Closure body.**

  ```lean
  noncomputable def PicardFunctorAb
      (C : Over (Spec (CommRingCat.of k))) :
      (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u} where
    obj S := AddCommGrpCat.of (Additive
      (Pic (Limits.pullback C.hom S.unop.hom) ⧸
        (Pic.pullback (Limits.pullback.snd C.hom S.unop.hom)).range))
    map {_ _} f :=
      AddCommGrpCat.ofHom (MonoidHom.toAdditive (PicardFunctor.quotMap C f.unop))
    map_id _ := by
      simp only [unop_id, PicardFunctor.quotMap_id, MonoidHom.toAdditive_id,
        AddCommGrpCat.ofHom_id]
    map_comp f g := by
      simp only [unop_comp, PicardFunctor.quotMap_comp]
      rw [show MonoidHom.toAdditive
          ((PicardFunctor.quotMap C g.unop).comp (PicardFunctor.quotMap C f.unop)) =
          (MonoidHom.toAdditive (PicardFunctor.quotMap C g.unop)).comp
            (MonoidHom.toAdditive (PicardFunctor.quotMap C f.unop)) from rfl,
        AddCommGrpCat.ofHom_comp]
  ```

- **Key Mathlib lemmas used.**
  - `MonoidHom.toAdditive` (and `MonoidHom.toAdditive_id`) — multiplicative
    ↔ additive equiv on `MulOneClass`.
  - `AddCommGrpCat.of`, `AddCommGrpCat.ofHom`, `AddCommGrpCat.ofHom_id`,
    `AddCommGrpCat.ofHom_comp` — bundled-category constructors and the
    standard simp lemmas in `Mathlib.Algebra.Category.Grp.Basic`.
  - `Additive G` instance machinery from
    `Mathlib.Algebra.Group.TypeTags`/`TypeTags.Hom` — gives `[AddCommGroup
    (Additive G)]` whenever `[CommGroup G]`.
  - From this project (iter-004): `PicardFunctor.quotMap`,
    `PicardFunctor.quotMap_id`, `PicardFunctor.quotMap_comp` in
    `AlgebraicJacobian/Picard/Functor.lean`.

- **Why the `rw [show ... from rfl, ...]` step?** The intermediate goal after
  `simp only [unop_comp, PicardFunctor.quotMap_comp]` is

  ```
  AddCommGrpCat.ofHom (MonoidHom.toAdditive
      ((PicardFunctor.quotMap C g.unop).comp (PicardFunctor.quotMap C f.unop))) =
    AddCommGrpCat.ofHom (MonoidHom.toAdditive (PicardFunctor.quotMap C g.unop)) ≫
      AddCommGrpCat.ofHom (MonoidHom.toAdditive (PicardFunctor.quotMap C f.unop))
  ```

  Lifting `MonoidHom.toAdditive` over the `MonoidHom.comp` is a definitional
  identity (the equiv is constructed from the `Additive.ofMul` /
  `Additive.toMul` adjunction, which preserves composition strictly), so the
  `show ... from rfl` rewrites it; then `AddCommGrpCat.ofHom_comp` fires.

### Forbidden-shortcut audit
- ❌ `:= sorry` (still): not used.
- ❌ `:= Discrete PUnit` / vacuous-functor placeholder: not used. The functor
  returns the actual `Pic(C ×_k S) / p_S^* Pic(S)` quotient transported
  through `Additive`, which is *the same set as* `(PicardFunctor C).obj S`
  with an additive-group structure (the `Additive`-tag is type-theoretic
  bookkeeping; the elements are the same).
- ❌ Constant `0` group: not used.
- ❌ Redefining `obj` to discard the quotient: not used.
- ❌ New `axiom` declarations: not introduced (verified via `lean_verify`,
  axiom set = `{propext, Classical.choice, Quot.sound}`).
- ❌ `decide` / `trivial` / `Discrete PUnit`: not used.

## Minor name adjustments required by Mathlib `b80f227`
None. The plan-agent briefing's hypothesis that `AddCommGrpCat.ofHom` might
"accept a `MonoidHom` directly" was not borne out — the bundled-category
API requires an `AddMonoidHom` between `AddCommGroup`s. The fix is the
canonical `Additive`-tag transport endorsed in path (a) of the briefing
("keep `Pic` multiplicative ... wrapped via `AddCommGrpCat.ofHom`"); no
declaration in `Functor.lean` needed to change.

The codomain of `obj` is `AddCommGrpCat.of (Additive (Pic ... ⧸ ...))`
rather than `AddCommGrpCat.of (Pic ... ⧸ ...)` — this is the only
differerence from a "naive" reading of the blueprint. The blueprint's
`def:Pic_functorAb` statement is unaffected: the abelian-group-valued
functor *is* this construction, and the `Additive` is invisible at the
mathematics level (just chooses which group operation the same set carries).

## Verification
- `lean_diagnostic_messages` on `Picard/FunctorAb.lean`: zero items.
- `lean_verify AlgebraicGeometry.Scheme.PicardFunctorAb`: axioms = `propext,
  Classical.choice, Quot.sound`; no warnings.
- `lake env lean AlgebraicJacobian/Picard/FunctorAb.lean`: exits silently.

## Proposed `\leanok` markers
Blueprint chapter `blueprint/src/chapters/Picard_FunctorAb.tex`:
- `def:Pic_functorAb` — **statement** `\leanok` (the declaration
  `AlgebraicGeometry.Scheme.PicardFunctorAb` exists, has the verbatim
  signature from the directive, and is fully filled with no `sorry`).
  Since this is a definition (`noncomputable def`), the "proof" `\leanok`
  is moot; the statement marker suffices.

The review agent should verify and add the marker.

## Status
**RESOLVED** — Objective 2 fully discharged. Sorry count for this file:
1 → 0. Aggregate sorry count for the project: 14 → 13 (or 14 → 10 if
Objective 1 also closes the three sorries in
`Cohomology/StructureSheafAb.lean`, returning to the 10 pre-iter-004
baseline of 9 protected + 1 deferred `representable`).
