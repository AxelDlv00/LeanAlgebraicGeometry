# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
presheaf-pullback-strong

## Design question
Is the comparison morphism `δ` of `PresheafOfModules.pullback φ` an **isomorphism**
(i.e. is `PresheafOfModules.pullback` STRONG monoidal, not merely oplax) in the pinned
Mathlib — either via an existing `Functor.Monoidal` / `CoreMonoidal` instance, or via a
short provable route from sectionwise `ModuleCat.extendScalars.Monoidal`
(`TensorProduct.AlgebraTensorModule.distribBaseChange`)? Concretely: can the project's
already-built map `pullbackTensorMap` (the sheaf-level `f^*(M⊗N) ⟶ f^*M ⊗ f^*N`,
assembled from this presheaf-level oplax δ + sheafification isos) be upgraded to an
**iso** for general `M, N` at a bounded cost — and if so, what is the precise Mathlib
idiom/path?

## Project artifact(s) under question
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1220` — `pullbackTensorMap` (δ_sheaf):
  the 4-step composite `(pullback f).obj (M ⊗ N) ⟶ (pullback f).obj M ⊗ (pullback f).obj N`.
  Step 2 is `a_Y.map (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val)`
  — the presheaf-level oplax comparison. The other 3 steps are already isos
  (`sheafificationCompPullback`, `sheafifyTensorUnitIso`, `pullbackValIso`). **So
  `pullbackTensorMap` is an iso IFF this presheaf-level δ is an iso.**
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — `presheafPullbackOplaxMonoidal`
  (landed iter-242): the `OplaxMonoidal` instance on `PresheafOfModules.pullback φ'`
  derived from `presheafPushforwardLaxMonoidal` via the adjunction (the
  `leftAdjointOplaxMonoidal` mate). `φ'` is the let-coerced
  `(X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶ (Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ …)`.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1203` — `pullbackValIso` (helper, iso).
- `analogies/pullback-tensor.md` (your OWN iter-242 file) — Analogue 2 already concluded
  Mathlib's endorsed pattern is to build the LEFT adjoint's strong-monoidal structure
  CONCRETELY via `(extendScalars f).Monoidal` (tensorator = `distribBaseChange`, an iso)
  and DERIVE the right adjoint's lax structure from the adjunction — "not the other way
  round." We need you to now pin down whether `PresheafOfModules.pullback` already carries
  that concrete strong structure, or how cheaply it can be given one.

## Why now
This is the load-bearing decision for the A.1.c critical path. The Stacks proof of
`IsInvertible.pullback` (Stacks `lemma-pullback-invertible`, tag in
`references/stacks-modules.tex:4142`) is THREE lines: pick the inverse `N` (M⊗N≅𝒪),
pull back, get `f^*M ⊗ f^*N ≅ f^*(M⊗N) ≅ f^*𝒪 ≅ 𝒪` **by `lemma-tensor-product-pullback`**
(= pullback is strong monoidal, proof "Omitted" as standard) **+ `pullbackUnitIso`
(already DONE)**. No local trivialization, no `IsInvertible⇒IsLocallyTrivial` forward
bridge, no finite-presentation spread-out — the iter-243 local-trivialization pivot was a
detour. So the ENTIRE remaining substrate collapses to: **is `pullbackTensorMap` an iso?**
which collapses to: **is the presheaf-level δ of `PresheafOfModules.pullback φ'` an iso?**
If yes (or cheaply provable yes), the planner re-routes Lane 1 to "prove `pullbackTensorMap`
iso (general M,N), then `IsInvertible.pullback` in 3 lines" and descopes the forward bridge.

## Hints
- `Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean`: `(extendScalars f).Monoidal`
  (concrete, tensorator = `TensorProduct.AlgebraTensorModule.distribBaseChange`, an iso) and
  `(restrictScalars f).LaxMonoidal := (adj).rightAdjointLaxMonoidal`.
- `PresheafOfModules.pullback` — does it carry a `Functor.Monoidal` (strong) / `CoreMonoidal`
  instance, or only `OplaxMonoidal`? Is `PresheafOfModules.pullback` defined sectionwise as
  `extendScalars` (so its monoidal structure is sectionwise `distribBaseChange`, strong), or
  abstractly as a left adjoint (so only oplax is free)? Check `Mathlib/Algebra/Category/
  ModuleCat/Presheaf/Pullback.lean` and `…/Presheaf/Monoidal*.lean` / `…/Sheaf/...`.
- Key sub-questions: (a) Is there `(PresheafOfModules.pullback φ).Monoidal` or a lemma
  `IsIso (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ) M N)`? (b) If not, is the
  presheaf δ provably iso by reducing to the sectionwise `extendScalars` strong-monoidality
  (i.e. does `PresheafOfModules.pullback` evaluate to `extendScalars` on sections)? (c) What
  is the precise bounded cost (which lemmas, how many) — is this a few-lemma upgrade or is it
  genuinely Mathlib-scale (as the iter-242 prover's "concrete inverse image absent" read
  claimed)? Reconcile against the fact that `PresheafOfModules.pullback φ'` already
  ELABORATES and is used in `pullbackTensorMap`.
- Negative result to respect (your iter-242 file): "oplax monoidal ⇒ preserves invertibles"
  is FALSE (Γ counterexample); we are NOT asking that — we are asking whether the SPECIFIC
  functor `PresheafOfModules.pullback` is STRONG (δ iso), which is genuine geometric content
  that the standard sectionwise base-change model supplies.

## Severity expectation
high-stakes — this decides whether the A.1.c critical path unblocks at bounded cost this
iter or commits to a multi-hundred-LOC forward-bridge / finite-presentation-spread-out build.
