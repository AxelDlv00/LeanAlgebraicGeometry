Could not reply to `debug` — SendMessage reports no agent by that name is reachable. Relaying the bottom line here instead; all three questions were covered, nothing skipped. (This was read-only reconnaissance: no files edited, no config touched.)

**(1) Main project (Algebraic-Jacobian-Challenge): NO.** The only Pic → ℤ-typed declaration is `AlgebraicGeometry.Scheme.PicScheme.degree` at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:1427`:
```
noncomputable def degree {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    (Spec (.of k) ⟶ (PicScheme C).left) → ℤ := sorry
```
Body is a bare `sorry` (`#print axioms` confirms `sorryAx`), and it is double-blocked: `[HasPicScheme C]`'s only instance is the standing conditional sorry in `FGAPicRepresentability.lean` (per protections I-0074 / I-0491). Its two consumers, `Pic0Scheme.finrank_eq_genus:1475` and `kPoints_iff_kerDegree:1504`, are also sorry. There is no invertible-sheaf / `X.Modules` → ℤ degree anywhere in AJC: `Polynomial.leadingCoeff` appears nowhere in the tree, and although `Scheme.hilbertPolynomial` (`Picard/HilbertPolynomial.lean:154`) is sorry-free, no leading coefficient is ever extracted from it. AJC's two sorry-free degrees are both on *divisors* with no map out of a Picard group: `Scheme.WeilDivisor.degree`/`degree_hom` (`RiemannRoch/WeilDivisor.lean:973`/`988`, unweighted — but `principal_degree_zero:1161` still carries a sorry at line 1194, so it does not descend to classes) and `Adelic.degK`/`degKHom` (`RiemannRoch/Adelic/SectionBounds.lean:114`/`109`, residue-weighted — its class-invariance results take an explicit `hledger` hypothesis that `Adelic/ChiUnconditional.lean:559` actually refutes on a genuine two-chart cover). `Picard/DivDegree.lean` is ℕ-valued fibre degrees of divisor families, not Pic → ℤ.

**(2) mathlib v4.31: NO.** No `WeilDivisor`, `CartierDivisor`, `Divisor.degree`, or `deg_divisor` anywhere; `Mathlib/AlgebraicGeometry/` contains no Divisor, Picard, RiemannRoch, or LineBundle file; `CommRing.Pic` exists (`RingTheory/PicardGroup.lean:400`) but has no homomorphism to ℤ (`Pic.*→+ ℤ` returns zero hits workspace-wide); `Analysis/Meromorphic/Divisor.lean` defines `MeromorphicOn.divisor` but that whole directory has no `degree`; `NumberTheory/FunctionField.lean` has no `degree` declaration.

**(3) Rebuild's `classDeg`** — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Degree.lean:150`:
```
noncomputable def classDeg (K : Type u) [Field K] {X : Scheme.{u}}
    [X.Over (Spec (CommRingCat.of K))]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
    [QuasiCompact (X ↘ Spec (CommRingCat.of K))]
    [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)] :
    Additive X.CechPic →+ ℤ
```
Sorry-free and axiom-clean (`[propext, Classical.choice, Quot.sound]`). Its input is a **Čech cocycle class, not a genuine invertible sheaf**: `X.CechPic` (`Picard/Pic.lean:60`) is `Quotient (cechPicSetoid X)` — Čech H¹ of the units presheaf, stabilized along refinement of pointed covers, with a `CommGroup` instance at `Pic.lean:117`. That distinction is the load-bearing one for a caller: AJCR has essentially no `SheafOfModules`/`X.Modules` layer at all (one file mentions it), so there is no `X.Modules → ℤ` there and no comparison from a locally-trivial sheaf of modules into `CechPic`. The value is anchored on divisors rather than sheaves via `classDeg_picClass:157` (`classDeg K (CurveDivisor.picClass K D) = CurveDivisor.deg K D`, with `CurveDivisor.deg` at `RiemannRoch/Divisor.lean:61`, residue-weighted `∑ nₓ·[κ(x):K]`). Surrounding interface: `classDeg_mul:164`, `classDeg_one:170`, `classDeg_inv:174`, `chi_divisorSheaf_classDeg:185`, curve form `:216`, iso-invariance `classDeg_map_iso` (`RiemannRoch/ClassDegMapIso.lean:196`); descendants `relPicDeg` (`RiemannRoch/RelPicDegree.lean:61`), `PicEtAff.degAff` (`Picard/DegreeZero.lean:263`), `degAt` (`Picard/Pic0Functor.lean:54`) — all sorry-free and axiom-clean.
