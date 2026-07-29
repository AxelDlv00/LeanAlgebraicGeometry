---
author: sync
content_type: theorem
created: '2026-07-30T05:53:10'
decl: AlgebraicGeometry.Scheme.exists_finiteSeparable_level_factorization
docstring: '**The form campaign `G1` consumes.** For a `k`-scheme locally of finite
  type, a point over the

  **separable closure** `k^s` is defined over a *finite separable* subextension `k''/k`,
  and the

  point''s factorization through `Spec k''` is exhibited.


  `FiniteDimensional k k''` is §3''s finiteness in field form; `Algebra.IsSeparable
  k k''` is free

  because `k''` sits inside `k^s` (`Algebra.isSeparable_tower_bot_of_isSeparable`).


  **What this does NOT give.** `G1` spreads `J5`''s datum to a finite **Galois** level.
  This produces

  a finite *separable* one. Separable-to-Galois is the normal-closure step

  (`IntermediateField.normalClosure`), a further obligation which is **not** discharged
  here; see

  the module docstring. Calling this "the finite Galois level" would be the one-word
  overstatement

  the 2026-07-29 audit exists to catch.'
file: AlgebraicJacobian/Curve/FiniteLevelRationalPoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.exists_finiteSeparable_level_factorization
type: lean
updated: '2026-07-30T07:02:15'
---
theorem exists_finiteSeparable_level_factorization {k : Type u} [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of k)) [LocallyOfFiniteType f]
    (p : Spec (CommRingCat.of (SeparableClosure k)) ⟶ X)
    (hp : p ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k)))) :
    ∃ (k' : IntermediateField k (SeparableClosure k)) (_ : FiniteDimensional k k')
      (_ : Algebra.IsSeparable k k') (q : Spec (CommRingCat.of k') ⟶ X),
      Spec.map (CommRingCat.ofHom (k'.val.toRingHom)) ≫ q = p := by
  obtain ⟨A, hAfin, q, hq⟩ := exists_moduleFinite_subalgebra_factorization f p hp
  obtain ⟨k', hk'⟩ := exists_intermediateField_toSubalgebra_eq A
  haveI hfd : FiniteDimensional k k' := by
    have h : Module.Finite k k'.toSubalgebra := hk' ▸ hAfin
    exact h
  haveI : Algebra.IsSeparable k k' :=
    Algebra.isSeparable_tower_bot_of_isSeparable k k' (SeparableClosure k)
  -- `k'.toSubalgebra = A`, so `Spec` of the two coincide; transport `q` along the induced
  -- ring equivalence in the direction `A ≃+* k'`.
  refine ⟨k', hfd, inferInstance,
    Spec.map (CommRingCat.ofHom
      ((Subalgebra.inclusion (le_of_eq hk'.symm) : A →ₐ[k] k'.toSubalgebra).toRingHom)) ≫ q,
    ?_⟩
  rw [← Category.assoc, ← Spec.map_comp, ← hq]
  congr 1

/-! ## §5. Non-vacuity: the hypotheses are jointly inhabited, and the level is a real restriction

Two things could have made §3–§4 true-about-nothing, and both are refuted here rather than
asserted.

* The binder set is inhabited **at the project's own curve hypotheses**: `LocallyOfFiniteType`
  follows from `[SmoothOfRelativeDimension 1 C.hom]` by synthesis, so
  `exists_finiteSeparable_level_factorization` applies to every curve `Challenge.lean` binds, with
  no added hypothesis (`level_factorization_of_curve` below).
* The conclusion is not secretly about `k' = k` *for every* `k`. If `k` were already separably
  closed then `k^s = k`, every level would be `k`, and the theorem would say nothing new;
  `not_isSepClosed_rat` exhibits a field that is **not** separably closed, so the hypothesis
  "`k` is separably closed" does not hold identically on the domain of the statement.

  **What that argument does and does not deliver, corrected after a fresh-context audit
  (`I-1310`).** An earlier revision of this bullet concluded "so `k^s ⊋ k` genuinely occurs".
  That step is *not* supplied by `not_isSepClosed_rat`: getting from `¬ IsSepClosed k` to
  `k^s ≠ k` needs the converse implication `(k^s = k) → IsSepClosed k`, and that direction is
  **absent** from mathlib in every spelling I probed (`⊥ = ⊤` on `IntermediateField`,
  `Function.Bijective (algebraMap k (SeparableClosure k))`, `k ≃+* SeparableClosure k`); only the
  direction that is not needed here is available (`eq_bot_of_isSepClosed_of_isSeparable`). So what
  is established is the weaker, sufficient statement above — the separably-closed case is not
  universal — and the strict-inclusion phrasing is withdrawn rather than left standing beside a
  caveat.
-/