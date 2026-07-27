Confirmed the key facts needed for the final report:

- AJCR's `RiemannRoch/WeilDivisor.lean` does not exist — checked, no `sorry` there (grep found nothing) since the file itself doesn't exist in AJCR.
- AJC's `RiemannRoch/WeilDivisor.lean:1194` has the one `sorry`, in the non-constant branch of `principal_degree_zero`, exactly where finite-map-to-P1 degree multiplicativity would be invoked.
- AJCR's `DegreePullback.lean` `classDeg_cechPicMap_eq_finrank_mul` / `classDeg_cechPicMap_of_isFinite` are sorry-free (full bodies read, closed with `exact`/`rw` chains, no `sorry` token).
- AJCR's `DegreeBaseFieldInvariance.lean` `classDeg_cechPicMap_baseFieldTransition` is sorry-free (full proof by `Finsupp.induction` read to completion).
- AJCR's `H1BaseFieldInvariance.lean` base-change results are for the structure sheaf only (D = 0); confirmed by grep that no general "L(D) base-change for arbitrary D" statement exists elsewhere (`CarveDegree.lean:99`'s `finrank_tensor_divisorSections` uses generic `Module.finrank_baseChange` on the tensor `K ⊗[k] L(D)` plus `finrank_divisorSections_top`, not an actual iso between `K ⊗ L(D)` and `L(D_K)` on the base-changed curve — a real gap for general D).

Now composing the final report.

## Report: AJCR survey for field-extension uniformity, bounded H¹ vanishing, and principal-divisor/finite-map degree machinery

**Central architectural fact:** AJCR and AJC use genuinely different divisor abstractions, and AJC itself contains two parallel RR layers only one of which matches AJCR's style.

- AJCR has no `PrimeDivisor`/`WeilDivisor` and no `Adelic/` folder at all. Its divisor type is `Scheme.CurveDivisor := {x : X // x ≠ genericPoint X} →₀ ℤ` (`AlgebraicJacobian/RiemannRoch/Divisor.lean:1-20`, direct Finsupp on closed points), and its RR machinery is sheaf-cohomology based: `Sheaf.HModule`, `Sheaf.chi`, `Sheaf.h0`, `X.divisorSheaf K D`, `X.moduleKSheaf K`, `X.CechPic`.
- AJC has (a) an older layer in `RiemannRoch/WeilDivisor.lean` with `Scheme.PrimeDivisor`/`Scheme.WeilDivisor = X.PrimeDivisor →₀ ℤ` + `Sheaf.chi`-style cohomology (architecturally close to AJCR), and (b) the newer `Adelic/` layer (`Substrate.lean`, `ChiLedger.lean`) with function-field-subgroup carriers `sectionOfDivisor`/`sectionSub : Submodule k X.functionField`, `AddSubgroup X.functionField`, `chi k U₀ U₁ D`, `residueDeg k P` — the abstraction the task named as AJC's baseline. AJCR is architecturally closer to AJC's *older* WeilDivisor layer than to the Adelic layer, so portability into the Adelic abstraction requires a full re-derivation regardless of AJCR's proof status.

### (1) Field-extension uniformity

| AJCR statement | file:line | Signature (essence) | Sorry-free | Ambient |
|---|---|---|---|---|
| `finrank_h1_baseField`, `finrank_h0_baseField` | `Cohomology/H1BaseFieldInvariance.lean:344,354` | `finrank K H¹(C_K,O) = finrank k H¹(C,O)` (and H⁰), any field ext. K/k | yes | `Sheaf.HModule`, two-cover Čech, structure sheaf only (D=0) |
| `h1BaseFieldEquiv`, `h0BaseFieldEquiv` | `Cohomology/H1BaseFieldInvariance.lean:328,336` | `K ⊗[k] H¹(C,O) ≃ₗ[K] H¹(C_K,O)` | yes | same |
| `genus_baseField` | `Cohomology/H1BaseFieldInvariance.lean:373` | `genus(C_K) = genus(C)` | yes | consequence of above |
| `finrank_tensor_divisorSections` | `RiemannRoch/CarveDegree.lean:96-99` | `finrank K (K⊗[k] L(a·F)) = h0(O(a·F))` | yes | but just `Module.finrank_baseChange` (generic tensor fact) + `finrank_divisorSections_top`; **not** an iso `K⊗L(D) ≃ L(D_K)` |
| `classDeg_cechPicMap_baseFieldTransition` | `RiemannRoch/DegreeBaseFieldInvariance.lean:456-461` | `classDeg K₂ (CechPic.map π L) = classDeg K₁ L` for k-algebra map φ:K₁→ₐ[k]K₂, π the base-field transition | yes | `Scheme.CechPic` degree, not section dimension |

Gap: AJCR proves dim base-change uniformity for H⁰/H¹ of the **structure sheaf only** (D=0/genus), and separately proves **degree**-invariance of Picard classes under base field transition. It does **not** have a "dim_k L(D) = dim_K L(D_K)" statement for a general divisor D — that would need `relSectionsBaseChange`-style base change applied to `divisorSections`/`Sheaf.HModule (divisorSheaf K D)` rather than `moduleKSheaf`. Confirmed by grep across the repo (no such lemma found).

Portability into AJC's Adelic abstraction: (b) proof-idea-only, and even that is partial. AJCR's engine is "two-cover Čech complex base-changes termwise, cokernel is right exact" (`relSectionsBaseChange`, `Cohomology/RelativeSectionsLinear.lean`). AJC's Adelic layer has no two-cover Čech complex — `sectionSub`/`H1` are defined via `AddSubgroup`/`Submodule X.functionField` and open-cover coboundaries directly on the function field. The base-change argument would need to be re-derived from scratch there (tensor a `Submodule k X.functionField` and relate to `Submodule K X.functionField ⊗ K`, none of which AJC currently has). AJCR's `classDeg_cechPicMap_baseFieldTransition` is (c) irrelevant to AJC's Adelic layer since AJC has no `CechPic` object at all.

### (2) UniformVanishing.lean (read in full, 116 lines) — bounded H¹ vanishing

Full statement, `RiemannRoch/UniformVanishing.lean:71-73`:
```
theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
```
Ambient context (section variables): `{K : Type u} [Field K] {Y : Scheme.{u}} [IsIntegral Y] [Y.Over (Spec (.of K))] [SmoothOfRelativeDimension 1 (Y ↘ Spec(.of K))] [LocallyOfFiniteType ...] [QuasiCompact ...]`. Requires an explicit finite-dominant map `π : Y ⟶ P1 K` supplied as hypothesis (not constructed here), plus finiteness of H⁰/H¹ of the structure sheaf. No `sorry` in the file. Proof cites `zero_lt_deg_fiberWeilDivisor`, `exists_effective_of_picClass`, `peel_effective`, `subsingleton_hModule_one_of_picClass_eq` — all from `FLVClass.lean`/`FLVFiberToolkit.lean`.

Compare against AJC's Adelic single-field version `exists_bound_subsingleton_h1Mod` / `exists_bound_subsingleton_h1Mod_of_residualLedger` (`Adelic/BoundedVanishing.lean`, no sorry): same shape (`∃ b, ∀ D, b ≤ deg D → Subsingleton H1`), but hypotheses are a ledger identity `chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D` plus a `Peel` predicate over `X.WeilDivisor`/`X.PrimeDivisor` — no P1 map required, entirely combinatorial once the ledger identity is assumed. AJCR's version instead derives the bound geometrically from an explicit finite map to P1 and fiber-divisor positivity. These are (b) proof-idea related at best (both are "peel effective divisors off a base case" arguments) but built on incompatible primitives (`CurveDivisor`+`Sheaf.chi` fiber geometry vs. `WeilDivisor`+ledger-identity combinatorics). Neither can import the other's proof text.

Also note AJC's own module docstring in `BoundedVanishing.lean` explicitly states this vanishing bound is **not uniform over field extensions** — a direct, self-reported limitation of AJC's own Adelic version, worth keeping in mind when comparing "uniformity" claims across the two projects.

### (3) Principal divisor degree zero + finite-map-to-P1 degree machinery

| Statement | AJCR file:line | AJC file:line | Sorry-free |
|---|---|---|---|
| principal divisor has degree 0 | `RiemannRoch/ChiLedger.lean:` `deg_divOf (g : X.functionFieldˣ) : CurveDivisor.deg K (Scheme.divOf (X ↘ Spec(.of K)) g) = 0` | `RiemannRoch/WeilDivisor.lean:1162-1198` `principal_degree_zero` | AJCR: yes. AJC: **no** — `sorry` at line 1194, exactly in the non-constant/finite-map-to-P1 branch |
| finite morphism degree multiplicativity: `deg φ*D = [K(X):K(Y)]·deg D` | `RiemannRoch/DegreePullback.lean:267-303` `classDeg_cechPicMap_eq_finrank_mul`, and Over-form `classDeg_cechPicMap_of_isFinite` (:320-352) | not present (this is the missing piece feeding the sorry above) | AJCR: yes |
| nonconstant rational function ⇒ finite map to P1 | `Curve/RationalToP1.lean`, `Curve/MapToP1.lean`, `Curve/P1.lean`: `exists_isFinite_toP1`, `exists_locallyQuasiFinite_isDominant_toP1`, `isFinite_toP1_of_locallyQuasiFinite` | `Adelic/FiniteMapToP1.lean`, `Adelic/NonconstantToP1.lean`: `ExistsNonconstantMapToP1`, `HasFiniteMapToP1`, via Zariski main theorem (`IsFinite.of_isProper_of_locallyQuasiFinite`) | need to check for sorries in these AJC files (not verified this session) |

This is the most actionable finding: AJC's own `principal_degree_zero` sorry is in exactly the spot AJCR has already filled in — degree multiplicativity under a finite map to P1. But the two proofs are not interchangeable:
- AJCR's route: `principal f hf = φ*([0]-[∞])` is never phrased that way at all; instead AJCR proves `deg_divOf` directly via the χ-ledger telescoping (`chi_step`/`chi_divisorSheaf`, devissage induction over closed points, `RiemannRoch/ChiLedger.lean:1-140`) — it does **not** go through finite-map-to-P1 pullback for this particular theorem. The pullback-degree machinery (`classDeg_cechPicMap_eq_finrank_mul`) is a separate, independently useful theorem about `CechPic` classes, not literally invoked inside `deg_divOf`.
- AJC's stated proof plan (in the docstring at `WeilDivisor.lean:1148-1157`) explicitly wants the Hartshorne II.6.10 route: `div(f) = φ*([0]-[∞])` then apply finite-pullback degree-multiplicativity. AJCR's `classDeg_cechPicMap_eq_finrank_mul`/`classDeg_cechPicMap_of_isFinite` is the right *shape* of lemma for that missing step, but it is stated over `X.CechPic` (Picard classes) and `X.CurveDivisor`, not over `X.WeilDivisor = X.PrimeDivisor →₀ ℤ` and not about `principal f hf` directly. Importability: (b) proof-idea transfers (the mathematical content — degree multiplicativity under finite pullback — is exactly what's needed) but the Lean text is not portable; someone would need to either (i) restate AJC's `principal_degree_zero` in terms of `CechPic`/`CurveDivisor` and reuse AJCR's lemma after a rewrite, or (ii) re-derive `deg φ*D = deg φ · deg D` natively over `PrimeDivisor →₀ ℤ` and `Scheme.RationalMap.order`, following AJCR's proof strategy (fiber decomposition + `Module.finrank` of the function-field extension) but rewritten against AJC's carriers. Given AJC already has its own finite-map-to-P1 existence machinery (`Adelic/FiniteMapToP1.lean`, `NonconstantToP1.lean`) built independently and apparently not yet finished (this sorry is downstream of it), the more direct win is (ii): port the *proof strategy* of `classDeg_cechPicMap_eq_finrank_mul`, not its text.

### Bottom line

Nothing in AJCR is a drop-in import for AJC (no shared dependency is possible; separate lake packages, incompatible divisor types: `CurveDivisor` on closed points + sheaf cohomology vs. `PrimeDivisor →₀ ℤ` + function-field submodules). The most valuable transferable ideas are: (1) the two-cover-Čech-termwise-base-change technique for H⁰/H¹ uniformity (currently only proved for D=0 in AJCR, so even there it's incomplete for the general L(D) case AJC would need), and (3) the finite-pullback degree-multiplicativity proof strategy, which is exactly the missing ingredient for AJC's open `principal_degree_zero` sorry. Everything else (bounded H¹ vanishing, degree base-field invariance for Picard classes) is proof-idea-adjacent at best, built on AJCR's `CechPic`/`Sheaf.chi`/`CurveDivisor` stack which has no counterpart in AJC's Adelic layer.
