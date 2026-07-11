All green. Final report:

## Deliverable

**Two files** (split as the mandate allows, both ≤ 500 lines, pure algebra, no scheme imports):

- `/home/Axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/ModuleDescent.lean` — **331 lines** (datum, equalizer, effectivity, Amitsur, uniqueness)
- `/home/Axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/InvertibleModule.lean` — **304 lines** (property + invertibility descent)

No other file touched.

## Public declarations

**ModuleDescent.lean** (namespace `Module`):
- `Module.actionMap A B M : B ⊗[A] M →ₗ[B] M` — action map `b ⊗ₜ m ↦ b • m` (simp: `actionMap_tmul`; `actionMap_one_tmul`)
- `Module.actionMap_baseChange` — naturality of the action map in B-linear maps
- `Module.actionMap_baseChange_mk` — the action map retracts base change of `1 ⊗ₜ ·`
- `Module.DescentDatum A B M` — descent datum in **comodule (Sweedler-coring) form**: `coaction : M →ₗ[B] B ⊗[A] M` + `counit` + `coassoc` (docstring gives the dictionary to the classical `B⊗B`-linear cocycle iso `φ`)
- `Module.DescentDatum.baseChange A B N` — canonical datum on `B ⊗[A] N` (simps: `baseChange_coaction`)
- `Module.DescentDatum.coactionSub` (`coactionSub_apply`), `.descended : Submodule A M` = `{m | δ m = 1 ⊗ₜ m}` as `ker coactionSub`, `.mem_descended`
- `Module.DescentDatum.comparison : B ⊗[A] M₀ →ₗ[B] M` (`comparison_tmul`, `comparison_eq_actionMap`), `.coaction_actionMap` (the contracting homotopy)
- `Module.DescentDatum.comparison_bijective [Module.Flat A B]` — **THE KEYSTONE** (effectivity); `.descentEquiv : B ⊗[A] M₀ ≃ₗ[B] M` (`descentEquiv_tmul`)
- `Module.DescentDatum.exact_mk_coactionSub [FaithfullyFlat]` — **Amitsur exactness ≤ 1**; `.unitEquiv : N ≃ₗ[A] (baseChange A B N).descended` (`unitEquiv_apply_coe`)
- `Module.DescentDatum.equivDescended` — **uniqueness**: any `N` with datum-compatible `B ⊗[A] N ≃ₗ[B] M` is canonically `≃ₗ[A] M₀` (`equivDescended_apply_coe`); two descents compose to a canonical iso

**InvertibleModule.lean**:
- `Module.FinitePresentation.of_finitePresentation_tensorProduct_of_faithfullyFlat` — FP descends (new; mathlib only had it for algebras)
- `Module.Projective.of_projective_tensorProduct_of_faithfullyFlat` — finite projectivity descends
- `Module.dualBaseChange A B P : B ⊗[A] Dual A P →ₗ[B] Dual B (B ⊗[A] P)` (`dualBaseChange_tmul`, `dualBaseChange_naturality`)
- `Module.bijective_dualBaseChange` — dual commutes with **arbitrary** base change for finite projective `P` (retract argument from the finite-free case)
- `Module.Invertible.of_invertible_tensorProduct_of_faithfullyFlat` — invertibility descends
- `Module.DescentDatum.{finite,flat,finitePresentation,projective,invertible}_descended` — the descended module inherits each property; **`invertible_descended` is the lane deliverable**

## What mathlib already had (for blueprint sources)

Confirmed **absent**: any Amitsur complex, any effective descent of modules (Sites/Descent is abstract stack machinery only; survey conclusion still valid). **Present and used**: `Module.FaithfullyFlat` (`lTensor_exact_iff_exact` exactness reflection, `lTensor_bijective_iff_bijective`, `tensorProduct_mk_injective` = Amitsur degree 0), `Module.Finite.of_finite_tensorProduct_of_faithfullyFlat`, `Module.Flat.of_flat_tensorProduct`, `Module.Invertible` (RingTheory/PicardGroup: finite/projective instances, `rTensor_bijective_iff`, `contractLeft` definition), `Module.Flat.projective_of_finitePresentation`, `IsBaseChange.linearMapLeftRight` (finite-free Hom base change), `Module.Flat.lTensor_exact`.

**Mathematical bonus discovered**: effectivity (`comparison_bijective`) needs only **`Module.Flat A B`** — counit+coassoc make the augmented complex contractible after `B ⊗ −`; faithfulness is needed only for uniqueness/Amitsur and property descent. Documented in the docstring.

## Verification

- `flock /tmp/ajc-lake.lock ~/.elan/bin/lake build AlgebraicJacobian.Descent.InvertibleModule` → `✔ [2396/2396] ... Build completed successfully`.
- Axiom audit (9 declarations incl. `comparison_bijective`, `descentEquiv`, `exact_mk_coactionSub`, `unitEquiv`, `equivDescended`, `invertible_descended`, FP descent, `bijective_dualBaseChange`): all exactly `[propext, Classical.choice, Quot.sound]`.
- Three consumer smoke tests kernel-checked: `equivDescended` with the identity on `B ⊗[A] N`; `invertible_descended` instantiation; a consumer-style datum on `M := B` built via `LinearMap.toSpanSingleton B (B ⊗[A] B) u` with `u = 1 ⊗ₜ 1`.

## Nothing cut. Gotchas for Picard/Separatedness + Rigidification

1. **Unit-cocycle recipe**: for `u : (B ⊗[A] B)ˣ` on `M = B`, `coaction := LinearMap.toSpanSingleton B (B ⊗[A] B) u.val` (i.e. `x ↦ x • u = (x ⊗ₜ 1) * u`, B-linear for free); `counit` = the normalization `μ(u) = 1`; `coassoc` = the Čech 1-cocycle condition.
2. **Left-factor action**: the `B`-structure on `B ⊗[A] M` is mathlib's left-factor instance; `coaction` must be B-linear for that action.
3. **Dot-notation trap**: for `f : Dual A P`, `f.baseChange B` resolves to `LinearMap.baseChange` (the wrong map). Write `Module.Dual.baseChange B f`.
4. `equivDescended`'s compatibility hypothesis orientation: `D.coaction (e x) = (e.toLinearMap.restrictScalars A).baseChange B ((baseChange A B N).coaction x)`.
5. For (C2): effectivity holds under mere flatness, so the rigidified reduction can invoke `descentEquiv` before any faithfulness bookkeeping; coherence enters only through `coassoc`.
