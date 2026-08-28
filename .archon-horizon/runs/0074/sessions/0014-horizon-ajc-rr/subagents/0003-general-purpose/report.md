All three claims are now resolved. Here are the findings.

## CLAIM A — `AffineTwoCover` does not occur anywhere in AJC

**VERDICT: HOLDS** (with one self-referential caveat).

`AffineTwoCover` occurs in AJC **only inside docstring prose that itself asserts the absence**. No `.lean` code, no import, no declaration:

- `/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/ExtensionUniformity.lean:90, 141, 142`
- `/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/GenusFieldInvariance.lean:62, 64, 65`

Case-insensitive `affine.{0,3}two.{0,3}cover` finds only informal prose ("affine two-cover") at `Ledger/FiberVanishing.lean:42`, `Ledger/FiberLattice.lean:14`, `Ledger/TwoCover.lean:199`. AJC's actual carrier is `AlgebraicGeometry.TwoCover` (`/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/TwoCover.lean:108`), an *unbundled* namespace taking `k X U₀ U₁` as loose arguments — not a structure. So the docstring's claim is literally true, but note it is now self-falsifying in the weak sense that the string exists only because the docstring says it doesn't.

**Where it IS defined in AJCR** — `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/AffineTwoCover.lean:51`:

```lean
structure Scheme.AffineTwoCover (Y : Scheme.{u}) : Type u where
  V₀ : Y.Opens
  V₁ : Y.Opens
  isAffineOpen₀ : IsAffineOpen V₀
  isAffineOpen₁ : IsAffineOpen V₁
  sup_eq_top : V₀ ⊔ V₁ = ⊤
  isAffineOpen_inf : IsAffineOpen (V₀ ⊓ V₁)
```

A bundled 6-field structure. Existence for the curve at `:91` (`nonempty_of_curve`), pullback at `:146` (`pullbackProd`). This confirms the "two distinct carrier boundaries" reading: AJCR bundles, AJC does not.

## CLAIM B — AJC has no analogue of `LinearMap.quotRangeBaseChangeEquiv`

**VERDICT: FAILS.** Two independent counterexamples.

**Counterexample 1 (AJC-internal, the decisive one).** `/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TwoTermFiniteFree.lean:276`:

```lean
noncomputable def cokerBaseChangeEquiv (f : M0 →ₗ[A] M1)
    (B : Type v) [CommRing B] [Algebra A B] :
    ((B ⊗[A] M1) ⧸ range (f.baseChange B)) ≃ₗ[B] B ⊗[A] (M1 ⧸ range f)
```

Full name `AlgebraicJacobian.TwoTerm.cokerBaseChangeEquiv`. This is **the same lemma up to `.symm`** as AJCR's `LinearMap.quotRangeBaseChangeEquiv` and AJC's own new `quotRangeBaseChangeField`. Compare AJCR's at `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/RelativeH1BaseChange.lean:82` and the new AJC one at `/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/GenusFieldInvariance.lean:113` — byte-identical statements modulo variable naming and direction:

```
A ⊗[R] (N ⧸ LinearMap.range f) ≃ₗ[A] (A ⊗[R] N) ⧸ LinearMap.range (f.baseChange A)
```

Not weaker in any respect: same generality (arbitrary `CommRing A`, arbitrary algebra `B`, no flatness, no finiteness), and its docstring even says so explicitly — "Right-exactness of the tensor product; no flatness and no finiteness." Its proof at `:279-297` uses the identical `lTensor_exact B f.exact_map_mkQ_range (Submodule.mkQ_surjective _)` step that `GenusFieldInvariance.ker_mkQ_baseChangeField:101` uses. It is more general in one axis: `B : Type v` (independent universe) versus `A : Type u` pinned to `R`'s universe in both the AJCR and the new AJC version.

Note the docstring at `GenusFieldInvariance.lean:67-68` and `ExtensionUniformity.lean:91` says the brick "is not in AJC either". It was in AJC, in `Picard/`, under a different name. The `RiemannRoch/` lane did not find it — `TwoTermFiniteFree` is **not** in the 142-module import closure of `GenusFieldInvariance.lean`, though 43 other `Picard/` modules are, so it was reachable by adding one import.

**Counterexample 2: mathlib has the content.** `TensorProduct.AlgebraTensorModule.tensorQuotientEquiv` (`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/LinearAlgebra/TensorProduct/Quotient.lean:270`) gives `M ⊗[R] (N ⧸ n) ≃ₗ[A] (M ⊗[R] N) ⧸ range (lTensor A M n.subtype)`, and `LinearMap.lTensor_range` (`.../RightExactness.lean:130`) converts `range (lTensor A f.range.subtype)` to `range (lTensor A f) = range (f.baseChange A)`. I verified this compiles: the exact AJCR/AJC statement follows from mathlib alone via `tensorQuotientEquiv A R A (range f)` composed with `Submodule.quotEquivOfEq`. The gap is real but small — the range-carrier translation needs a hand-written `Submodule.ext` because the `restrictScalars`/`AlgebraTensorModule.lTensor` spelling does not `rw` cleanly, which is presumably why nobody found it. So mathlib provides the mathematics; the `quotRange…` form is a convenience repackaging, done three times.

**Other AJC near-misses, judged:**
- `Picard/EntryIdeal.lean:172-175` — `Function.Exact (P.relMatrix.mulVecLin.baseChange A) …` via `lTensor_exact`. Strictly weaker: exactness of a specific presentation, no equiv.
- `Picard/FlatKernelBase.lean:82-88` — `lTensor_exact`/`rTensor_exact` in a diagram chase. Unrelated (flatness-side).
- `Picard/TensorObjSubstrate/Vestigial.lean:144` — `Module.Flat.lTensor_exact`. Weaker and flatness-hypothesised.
- `Picard/TwoTermFiniteFree.lean:339` `surjective_of_baseChange_quotient_surjective` — a *consumer* of counterexample 1, not the lemma.
- `Ledger/SectionsFieldBaseChange.lean:343` — prose "right-exactness of `⊗` to pass to the cokernel", the AJC lane's own plan.

## CLAIM C — no Serre duality / canonical divisor / dualizing sheaf in AJC, AJCR, or mathlib

**VERDICT: HOLDS.**

- **mathlib**: `dualizing` appears zero times as a mathematical object (only 10 hits of "obtained by dualizing" in file-header prose, e.g. `Mathlib/CategoryTheory/Functor/Derived/LeftDerived.lean:27`). `SerreDuality`, `serre.duality`, `canonicalDivisor`, `canonical divisor`: zero hits. `Serre` appears zero times under `Mathlib/AlgebraicGeometry/`. There is no `RiemannRoch` file, no `genus` declaration, and no sheaf of differentials on schemes — `Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean` is the presheaf-of-modules differentials, not `Ω¹_{X/k}` as a canonical sheaf. The only Serre-named mathematics is unrelated: `ObjectProperty.epiModSerre` (Serre classes, `Mathlib/CategoryTheory/Abelian/SerreClass/`), `Derivative.serreDerivative` (modular forms). "Grothendieck duality" appears only as a *bibliography citation* in `Mathlib/Algebra/Homology/HomotopyCategory/HomComplex.lean:29`.
- **AJC**: `dualiz` occurs once, in the docstring asserting the absence (`Ledger/ExtensionUniformity.lean:74`). `Serre` occurs only as *Serre vanishing* (`Cohomology/AffineSerreVanishing.lean`), *Serre twist* (`Picard/SerreTwist.lean`, `SerreTwistSections.lean`), *Serre finiteness* (`Picard/SerreFiniteness.lean`), and *Hilbert–Serre* (`Picard/GradedHilbertSerre.lean`) — all cohomology-vanishing/finiteness, none dual. The word "duality" elsewhere is linear-algebra dual (`Pic0AbelianVariety.lean:953` `Subspace.dual_finrank_eq`), monoidal unit self-duality (`TensorObjInverse.lean:3248`), or hom-coproduct duality (`CechBridge.lean:89`) — no coherent duality anywhere.
- **AJCR**: no `dualiz`, no `SerreDuality`, no `canonicalDivisor`. The 15 hits for "canonical divisor" are all the phrase *"canonical divisor window/fibre window"* in `Picard/DivSchemeHighWindow*.lean` — a different use of "canonical" (the canonically-chosen window `H^0(N+nS-D)`), not `K_X`.
- **`Ω`/`ω` check** (the trap): `KaehlerDifferential`/`Ω[S⁄k]` *is* used in both projects — `AJC/Albanese/CodimOneExtension.lean` (62 hits), `AJC/Albanese/SmoothPrimeRegularity.lean` (52), `AJC/RiemannRoch/Adelic/FiniteMapToP1.lean` (32), and AJCR counterparts. But it is used purely as a **regularity/dimension detector**: at `FiniteMapToP1.lean:110-135` it feeds `ringKrullDim_le_one_of_isStandardSmoothOfRelativeDimension_one` via `rank Ω[S⁄k] = 1` and formal unramifiedness. Affine-algebra `Ω`, never assembled into a sheaf on `X`, never paired against `H¹`, never a canonical divisor class. Every `ω` binder is a local variable name.

So the parenthetical in `ExtensionUniformity.lean:73-75` — including its strongest sub-claim, "mathlib has no Serre duality for curves at all" — is accurate, and the `2g − 1` retraction it justifies stands.

**Net:** A holds, C holds, **B fails**. The concrete correction needed is in two docstrings — `GenusFieldInvariance.lean:67-68`/`87-88` and `ExtensionUniformity.lean:91` — which should say the brick existed in AJC as `AlgebraicJacobian.TwoTerm.cokerBaseChangeEquiv` (`Picard/TwoTermFiniteFree.lean:276`) and is also derivable from mathlib's `AlgebraTensorModule.tensorQuotientEquiv`, rather than that it was absent. This is the "found the weaker cousin and stopped" failure mode running in reverse: the lane searched for the *name* and, finding none, concluded absence, while the same statement sat under a different name one import away.
