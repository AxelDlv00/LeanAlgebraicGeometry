All four items filed (I-0514, I-0515, I-0517 issues; I-0519 memory).

## Verdict: FAKING PROGRESS — the central object is vacuous

The lane built five files, sorry-free but for one, all building green (8879 jobs, one declared `sorry`, axiom-clean otherwise). But CHART-U(a) — the object the whole task turns on — is **defined wrong in a way that makes it the empty set**, and CHART-U(b)'s "conditional assembly" is mostly hypotheses restated as lemmas. Real new mathematics this session: roughly `Over.testPoint`, `Scheme.IsGluingCocycle.inv`, and `chartHom_restrictChart`. Everything else is definitions, signatures, or a wrongly-oriented twist.

### 1. `chartTwist` is inverted; `chartLocus` is empty for g ≥ 1 (I-0514)

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartLocus.lean:147`

```lean
def chartTwist (m : ℕ) (Z : ...) (T : ...) (lam : picEt C T) : picEt C T :=
  lam * sigmaFamily C Z T * (thetaFamily C (thetaCechClass C) T ^ m)⁻¹
```

That is the *same* twist as `chartValue`, not its inverse. The worksheet's `λ·θ^m·(−Σ)` is `lam * θ^m * (sigmaFamily)⁻¹` — θ up, Σ down. Kernel-checked consequences:

- `chartTwist (chartValue s) = abelDiv s * Σ² * (θ^m)⁻¹²`, whereas `chartValue s * θ^m * Σ⁻¹ = abelDiv s` (by `group`). The correct untwist is the other one.
- `degAt_chartTwist` gives `deg Z − m·d₁` = **−g**, not +g.
- Membership forces a witness divisor of degree −g with h¹ = 0; but `h0_eq_deg_add_chi_of_subsingleton_hModule_one` (`RiemannRoch/FLVClass.lean:412`) + `h0 ≥ 0` forces `deg W ≥ g − 1`. Contradiction for g ≥ 1.

So CHART-U(b) is the openness of ∅, and DAT-B coverage against this locus is unprovable rather than unproved. The fix is one line plus its ledger; nothing else in the five files depends on the direction.

Your claim 1 does **not** survive as a pass. The degree ledger *is* internally consistent with `degAt_chartValue` — but the comparison is made at `n = 0` where the chart index is calibrated at `n = g`, and the file states "this is −g" as if it were the ledger working.

Notably the lane posted this arithmetic to I-0494 itself ("the twisted fibre degree is then exactly -g") and read the wrong conclusion off it.

### 2. Nine advertised declarations don't exist (I-0515)

Zero grep hits across the project for `isSplitWitness_iff_forall`, `mem_chartLocus_iff_forall`, `chartLocus_preimage_subset`, `Over.testPointAffine`, `testPointField_affineOpen_iso`, `Over.testPoint_comp`, `chartLocus_eq_cechWitnessLocus_of_presentation`, `isOpen_chartLocus_of_presentation`, `isOpen_chartLocus`. Two phantoms name exactly the open obligations: `testPointAffine` is the sorry's content, and `chartLocus_eq_cechWitnessLocus_of_presentation` is the transport that was not done. `isOpen_chartLocus` exists in no form — the conditional statement is about an inline set over an affine test, never about `chartLocus`.

Your claim 2 partly survives: `IsSplitWitness` is **not** vacuous — the class equation `PicEtAff.map … = PicEtAff.unit … (relPicMk M)` genuinely pins M's class, and I verified it pins the witness degree via `degAff_unit`/`relPicDeg_relPicMk`/`classDeg_picClass`. It is that pinning which proves the locus empty. But the "(equivalently every)" half of the amendment is unbuilt: only a one-directional upward-closure lemma exists.

### 3. The sorry is scoped wrong, not merely unfinished (I-0517)

`Pic0ChartLocusIsOpen.lean:146` ∀-quantifies `alg`/`tow`, so it claims openness for *every* `Algebra A` structure. The advertised route (`Spec.residueFieldIso`) only works for the canonical one — `HasWitnessH1Vanishing` depends on the instance through `relCurveMap C A L`. Verified by instantiation that arbitrary pairs typecheck. Your claim 3's suspicion is right: the explicit-argument trick makes the *theorem* harder, not vacuous, and the "transcription, not mathematics" comment is wrong.

### 4. `IsChartDatumPresentation` is not circular, but the lemma consuming it is empty

Claim 4 survives on the honesty question: the hypothesis is a genuine pointwise-agreement obligation, weaker than class equality, and plausibly dischargeable. But `mem_chartLocus_iff_hasWitnessH1Vanishing` (`:191`) has proof term `(hpres t).symm` — a restatement, advertised as "transports (0) and (iii) discharged".

### 5. `Scheme.IsGluingCocycle.inv` is correct

Real, valid, and the commutativity remark is accurate (`ring` is used exactly where `(ab)⁻¹ = a⁻¹b⁻¹` needs it). `invDatum` is well-formed. The file is honest that `cechPicClass_inv` is absent — which means `invDatum` produces an inverse-*looking* datum with no proof it has the inverse class, and it has zero consumers. Claim 5 survives.

### 6. `Pic0ChartPair` disclaimer is accurate

`isOpenImmersion_presheaf_restrictChart` proves only the composition half; the header says so in bold, twice, and `isChartUniv_of_unrestricted` explicitly records that its hypothesis is false at V = ⊤. `chartHom_restrictChart` is real work. Claim 6 survives — this is the best-behaved of the five files.

### 7. No undeclared sorries, no axioms

`#print axioms` on all key declarations: `[propext, Classical.choice, Quot.sound]`, with `sorryAx` only in `isOpen_setOf_isSplitWitness_of_presentation`, exactly as declared.
