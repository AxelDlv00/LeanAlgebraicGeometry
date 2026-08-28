Read-only throughout; no tree edits. Report below.

## DAT-J residues, measured

**A. The interface** (`Picard/JacobianDataAbelSquare.lean`, 183 lines, **sorry-free as a term** — the one `grep` hit is docstring prose at :23; rooted at `AlgebraicJacobian.lean:607`).

`IsAbelClassifyCompatible` (:133) takes `abel : DivSch ⟶ J` **plus a second parameter `pt`**, a function `∀ (K) [Field K] [Algebra k K] [IsIntegral (relCurve C K)] [Smooth…] [QuasiCompact…], (relCurve C K).CurveDivisor → (Spec (.of K) ⟶ J)`, and asserts `∀ K … (D) (hD : 0 ≤ D) (hdeg : deg K D = g), (effectiveDivisorClassifyZar hpi g hO hchi r1 r2 b1 b2 D hD hdeg).left ≫ abel = pt K D`.

**This is the finding: `pt` is universally quantified in the theorem, not pinned.** I proved in Lean (axiom-clean, `[propext, Classical.choice, Quot.sound]`) that for **any** `J` and **any** `abel`, `∃ pt, IsAbelClassifyCompatible … abel pt` — witness `fun K … D => if h : 0 ≤ D ∧ deg K D = g then (effectiveDivisorClassifyZar … D h.1 h.2).left ≫ abel else fallback K`, closed by `dif_pos`. And the converse: `hlift` plus bare existence of an effective degree-`g` divisor per residue field reconstructs `pt`, `hsq` **and** `heff`, with the `hlift` binder reported *unused* by the linter.

So `exists_residueField_lift_of_abelCompatible` is an **equivalence, not a reduction**. All content sits in `heff`, whose real conjunct is not `pt K D = fromSpecResidueField y` in the abstract but `(effectiveDivisorClassifyZar … D …).left ≫ abel = J.fromSpecResidueField y` — i.e. the square *at the residue-field points*, restated. The docstring's "the bookkeeping content is this square" inverts the actual split. Obligation 1 as stated is discharged by `probe_square_vacuous`; it demands nothing.

**B. Effectivity.** `exists_effective_of_picClass` (`RiemannRoch/FLVClass.lean:208`):
```lean
lemma exists_effective_of_picClass (W : X.CurveDivisor)
    (hW : 1 ≤ CurveDivisor.deg K W + Sheaf.chi (X.moduleKSheaf K)) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧ CurveDivisor.picClass K E = CurveDivisor.picClass K W
```
`riemann_inequality` (`RiemannRoch/ChiLedger.lean:137`, **not** FLVClass:205): `deg K D + Sheaf.chi (X.moduleKSheaf K) ≤ (Sheaf.h0 (X.divisorSheaf K D) : ℤ)`.

The **degree arithmetic is genuinely free** — I proved it: from `deg W = g` and `chi = 1 - g`, `hW` is `omega`, and the returned `E` has `deg E = g` via `classDeg_picClass` (`RiemannRoch/Degree.lean:157`). No `g`-vs-`n` shift.

Three real gaps, all confirmed by failed `infer_instance`:
- **`Algebra k (J.residueField y)` does not synthesise**, even for `J.Over (Spec (.of k))`. Mathlib's `ResidueField.lean` has no such instance (only `Hom.residueFieldMap`, :123, and `FormallyUnramified.lean:157`'s local `letI … .hom.toAlgebra`). This is why `heff` bundles it as *data* — correctly. The missing construction is `(J ↘ Spec (.of k)).residueFieldMap y` composed with the affine `Γ`-identification.
- **relCurve-alias keying**: `IsIntegral (relCurve C K)`, both `Module.Finite … HModule 0/1`, `Smooth`, `QuasiCompact` all fail at the alias but succeed at `(C ⊗ overSpec k K).left`, and `relCurve C K = (C ⊗ overSpec k K).left` is `rfl`. `DivSchemeAbel.lean:280-288` works around this with explicit `haveI`s naming `instIsIntegralBaseChange` etc. (`Curve/BaseChangeInstances.lean:152/167/176`).
- **`chi` at the residue field** is `chi_relCurve_baseField` (`DivSchemeSeedUnivAssembleKappa.lean:68`); available, needs the `Algebra` datum first.

**C. There is no campaign `abel`.** Grep for anything whose *type produces* `DivScheme … ⟶ J`: every occurrence is a **hypothesis** (`JacobianDataAbelImage.lean:79,107,117,146`, `JacobianDataAbelSurj.lean:120,152`, `JacobianDataFromPicRepDatum.lean:133`). The only constructed `DivScheme`-source morphism is `divSchemeι : DivScheme … ⟶ grPair k g r₁ g r₂` (`DivScheme.lean:148`), wrong target. `DivSchemeAbel.lean` builds the Abel map only as a **natural transformation** `abelDivTrans : divFunctor C π n ⟶ picDegLayerFunctor C n` (:302), and `abelSigmaChart` (`Pic0AtlasFromDivRep.lean:205`) turns it into a presheaf map — both need `(divFunctor C π n).RepresentableBy D`, i.e. **divRep**. So "prove `IsAbelClassifyCompatible` for the campaign's Abel morphism" has no subject: the scheme-level `abel` is itself divRep-gated. `effectiveDivisorClassifyZar_spec` (`DivisorFamilyFieldSurj.lean:231`) pins only the *left* side (`= divRepClassifyZar … F.toZar` with `divFamDivisor F = D`); nothing in the tree relates `divRepClassifyZar` to any `abel` — zero grep hits for a composition lemma.

**D. Producers** — `JacobianData.ofAbelLifts` (`JacobianDataAbelSurj.lean:149`), `ofChartsOfAbelLifts` (:193), `PicRepDatum.toJacobianData` (`JacobianDataFromPicRepDatum.lean:83`, four fields, `hqc` the only argument), `toJacobianDataOfAbelLifts` (:132). All sorry-free. The conversion `surjective_of_forall_exists_residueField_lift` (:82) is real, cheap, and complete.

**E. Verdict.** Nothing is *already discharged under another name* (workspace search: AJC's `Scheme.PicScheme.HasAbelMap`/`abelMap` in `FGAPicRepresentability.lean:661` is a different category and sits behind protection I-0074's 4 sorries). Ranking:

1. **`Algebra k (J.residueField y)` for `J` over `Spec k`** — the only fully divRep-independent, U2-independent target, small, and it unblocks the `heff` shape plus the `chi`/finiteness transport. Best next Lean target.
2. `heff`'s degree half — already provable (I proved it); needs only (1) plus the alias `haveI`s.
3. `IsAbelClassifyCompatible` — **not a target**: vacuous as stated. It needs restating with `pt` pinned (e.g. via a landed class-to-point morphism) before it means anything, and its honest form is divRep-gated because `abel` does not exist.

The roadmap row's "three things" should be re-scoped: obligation 1 is currently satisfiable by `fun _ => fallback`, and obligation 2 carries the content the docstring assigns to obligation 1.
