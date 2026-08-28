All five claims checked against source, with `#print axioms` verification on each keystone.

## Verdict table

| # | Claim | Verdict | Declaration | What it really says |
|---|---|---|---|---|
| a | coverage-drop | **TRUE as a lemma; FALSE if read as "coverage"** | `AlgebraicGeometry.exists_effective_sub_h0_eq_one` — `AlgebraicJacobian/RiemannRoch/CoverageDrop.lean:213` | A real `theorem`, fully proved, no `sorry`, axioms `[propext, Classical.choice, Quot.sound]`. But it is **oracle-parametrized**: `P : Set Y` is an argument with three *hypotheses* `hdense`, `hPcl : ∀ x ∈ P, x ≠ genericPoint Y`, `hPdeg : ∀ x ∈ P, residueDeg K Y x = 1`. It is the B-1 h⁰-drop only — the coverage theorem COV-1 (`pic0_chartLocus_cover`) and its file `Picard/Pic0Coverage.lean` **do not exist**. |
| b | separably-closed points | **TRUE** | `AlgebraicGeometry.SeparablyClosed.exists_rationalPoint_mem` — `AlgebraicJacobian/Curve/SeparablyClosedPoints.lean:135` (`Over.` form `:157`); `AlgebraicGeometry.Over.dense_baseChange_rationalPoints` — `AlgebraicJacobian/Curve/SepPointsDense.lean:278` | Both proved, no `sorry`, axiom-clean. DAT-P: nonempty open of a smooth-rel-dim-1 scheme over `IsSepClosed K` contains a `K`-point. B-2: over `[IsSepClosed k]`, `k`-points base-change densely into `relCurve C L`. |
| c | divisor-family field surjectivity | **TRUE** | `AlgebraicGeometry.exists_divFam_divFamDivisor_eq` — `AlgebraicJacobian/Picard/DivisorFamilyFieldSurj.lean:147` | Unconditional over a field: `(D : CurveDivisor) (hD : 0 ≤ D) (hdeg : deg K D = n) : ∃ F : DivFam C K π n, divFamDivisor F = D`. Hover-checked: **no** `DivisorAdaptation`/certificate section variable leaks in. Closes `divFamFieldEquiv` (`:162`) and yields `effectiveDivisorClassifyZar`/`_spec` (`:217`/`:231`). Axiom-clean. |
| d | local chart openness | **PARTIALLY TRUE (headline is FALSE)** | `BasicOpenCocycleDatum.isOpen_setOf_exists_witness_h1_vanishing` — `AlgebraicJacobian/Picard/Pic0ChartLocusOpen.lean:80`; `isOpen_cechWitnessLocus` — `AlgebraicJacobian/Picard/Pic0ChartLocusClass.lean:123` | `chartLocus` **is not defined anywhere in the tree**, and `isOpen_chartLocus` does not exist. What is proved is openness in `Spec B` (an **affine** base) of the witness locus of an **untwisted** Čech class — a repackaging of `datumRigidEngine_isOpen_vanishing` through the C1 dictionary, plus two pure-topology lemmas (`:118`, `:129`). The file says so itself: *"It is strictly weaker than the reserved `isOpen_chartLocus` (dat-b row B-4) … do not cite it as that."* Missing: shifted-datum constructor (DAT-C GAP-1), the split predicate, transports (i)/(ii). |
| e | fibre-field invariance | **TRUE** | `BasicOpenCocycleDatum.hasWitnessH1Vanishing_iff_of_fieldExtension` — `AlgebraicJacobian/Picard/Pic0ChartLocusFibreField.lean:142` (+ `_of_separable` `:157`, module core `subsingleton_tensorProduct_field_ext_iff` `:91`, `_congr_of_cechPicClass_eq` `:177`) | For a fixed datum `D` over `B` and any field extension `L → L'` in the `B`-tower, witness h¹-vanishing transfers both ways. Genuinely unconditional (faithful flatness; separability not used). Axiom-clean. Does **not** deliver transport (ii): the `comap`-preimage identity still needs the shifted-datum class identity (I-0252 gap 1), flagged as residual in the file header. |

## Key signatures

```lean
-- (a) CoverageDrop.lean:213
theorem exists_effective_sub_h0_eq_one (g : ℕ) (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (g:ℤ))
    (P : Set Y) (hdense : ∀ U : Y.Opens, (U:Set Y).Nonempty → (P ∩ U).Nonempty)
    (hPcl : ∀ x ∈ P, x ≠ genericPoint Y) (hPdeg : ∀ x ∈ P, Y.residueDeg K x = 1)
    (W : Y.CurveDivisor) (e : ℕ) (hdeg : CurveDivisor.deg K W = (g:ℤ) + e)
    (h1 : Subsingleton (Sheaf.HModule (Y.divisorSheaf K W) 1)) :
    ∃ S : Y.CurveDivisor, 0 ≤ S ∧ CurveDivisor.deg K S = (e:ℤ) ∧ … ∧
      Sheaf.h0 (Y.divisorSheaf K (W - S)) = 1 ∧ Subsingleton (…(W - S)) 1)
```

```lean
-- (d) Pic0ChartLocusOpen.lean:80  — note: base is `Spec B`, class is untwisted
theorem BasicOpenCocycleDatum.isOpen_setOf_exists_witness_h1_vanishing
    (D : BasicOpenCocycleDatum C B π) (hπ : π ≫ P1.structureMap k = C.hom) :
    IsOpen {q : PrimeSpectrum B | ∃ W, picClass κ(q) W = CechPic.map … D.cechPicClass ∧ … }
```

## Adversarial findings the roadmap summary hides

1. **The two "landed" field-level bricks (a) and (b) have zero consumers.** `grep` over the whole tree: `exists_effective_sub_h0_eq_one`, `exists_admissible_nonbase_point`, `h0_sub_single_of_rational_nonbase`, `dense_baseChange_rationalPoints` are referenced **only inside their own files**. Nothing assembles the oracle.

2. **(a) and (b) do not compose yet.** B-1 demands `hPdeg : residueDeg K x = 1`; `SepPointsDense.lean:36` states outright *"The residue-degree bookkeeping of the base-changed point (`residueDeg L = 1`, the `hP` oracle input of B-1) is **not** proved here; B-5 extracts it from the rationality certificate"* (`rationalPointBaseChange_snd`, `SepPointsDenseKit.lean:134`). B-5 does not exist. `hPcl` (closedness) is likewise undischarged for these points.

3. **The terminal DAT-B deliverable is a hypothesis, not a theorem.** `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)` occurs only as a section variable / instance-argument at `Picard/JacobianDataCharts.lean:117` and `Picard/Pic0SigmaSheaf.lean:165`. It is never proved. (The roadmap does concede B-6.)

4. **`sorry` status:** none of the eight DAT-B files contain `sorry`. Transitive import cones do pick up `AlgebraicJacobian/Challenge.lean` (18 sorries), but those are the top-level `Jacobian`/`ofCurve`/`baseChangeIso` statement stubs; all seven keystones I checked with `lean_verify` report axioms `[propext, Classical.choice, Quot.sound]` only, so no `sorryAx` leaks in.

5. **Honest wording check:** the roadmap's own tail — *"Remaining B5/B6/chart-locus packaging is divRep/C9-gated"* — partially covers (d). But listing "local chart openness" among five things that "are landed" is misleading when `chartLocus` is not a definition in the codebase and the file that proves the nearest statement explicitly forbids citing it as that.
