Confirmed: `IsLocallySurjective (Sigma.desc f)` is a genuine, non-vacuous instance obligation that an empty atlas cannot satisfy (the trivial Pic⁰ class over any test would have no preimage). So the empty-atlas case is blocked by a real gate, not silently admitted.

## Findings

**No vacuous gate found on the chart/certificate seam.** I enumerated the classes/structures and Prop-valued gates in scope and every one carries real mathematical content. Details, numbered:

1. **`/…/AlgebraicJacobian/Picard/DivisorFamily.lean:426` — `DivisorAdaptation.IsCertified` — CLEAN.** The seven fields are `Module.Finite`/`Module.Projective` of `A.colength j`, `Module.Finite`/`Projective` of `A.Glued`, `Module.rankAtStalk A.Glued p = n` at *every* prime, and two `Module.Flat` cokernel clauses. Nothing definitionally trivial; the rank clause pins an actual integer.

2. **`/…/Picard/DivisorFamilyAffAdaptation.lean:252` — `AffAdaptation.IsCertified` — CLEAN.** The R2-widened restatement, clause-for-clause identical to (1) over `AffCoverData` pieces.

3. **`/…/Picard/DivisorFamilyAffCover.lean:145` — `AffCoverData` — CLEAN, and notably not weakened by the widening.** `cover : (⨆ j, pieces j) = ⊤` is a real joint-covering demand; `ChartTyping` (line 204) is deliberately kept a *separate* datum so no certificate clause can require it.

4. **`/…/Picard/DivSchemeCertZarSep.lean:277` — `isCertified_of_separated` — CLEAN, and the strongest evidence against a vacuity finding.** This is the one place that gets clauses (c3)/(c4) "for free" from `hsep : ∀ i j, i ≠ j → Subsingleton (A.ovlColength i j)` — defect shape (c) on its face. It is not a defect, because the same file proves its own converse obstruction at line 201, `supportLocus_disjoint_chart_inter_of_separated`, showing `hsep` *forces* the support out of `V₀ ⊓ V₁`, and at line 257 `not_exists_unique_support_piece` refutes the "one support-meeting piece" shape outright. The docstring states the scope limit explicitly ("stated to record the scope of the separated route, not to suggest the hypothesis is generic").

5. **`/…/Picard/DivRepClassifyZar.lean:90` — `IsDivRepClassify` — CLEAN, non-vacuous premise.** It is `∀ T … (G : CertifiedDivisorFamily C T π g), (premise) → (conclusion)`, so vacuity would need the premise uninhabitable. It isn't: `exists_certChartCover` (used at line 128 of the same file) produces exactly such certified representatives, and `divRepClassifyZar_isDivRepClassify` is proved non-trivially at line 253.

6. **`/…/Picard/DivRepAffPullClause.lean:119` — `IsChartClause` — CLEAN.** Reduces to (5) at each chart; `IsChartClause.of_id` (line 156) collapses the `ω`-quantifier by real base-change bookkeeping, not by triviality. The file's own "What this does NOT do" says it produces no `IsChartClause`.

7. **`/…/Picard/DivRepChartClassUnivFree.lean:147` — `windowBound_pos_of_ne_zero` — CLEAN.** Discharges `hb : 0 < windowBound` from `g ≠ 0` via the contrapositive of `genus_eq_zero_of_windowBound_nonpos`. This is a genuine discharge, not a vacuous one; the `include hO hchi` is load-bearing and the file says so.

8. **`/…/Picard/DivSchemeQProj.lean:221` — `DivQProjBundle` — CLEAN.** Nine fields, all real scheme-theoretic properties, each discharged by a named theorem at line 245. Honest boundary noted: projectivity/Plücker deliberately excluded.

9. **`/…/Picard/DivSchemeFamily.lean:129` — `ThetaGeneratorSeed.IsGenerator` — CLEAN.** `dvd` is an `Ideal.span` membership; `fibre_regular` is `nonZeroDivisors` membership at every prime. Note its `eqn_rel` sibling (DivisorFamily.lean:232) *documents* that empty overlaps make the clause trivial — but that is per-`y` degeneracy inside a `∀ y`, not a vacuous gate, since non-empty overlaps carry the content.

10. **`/…/Picard/Pic0AtlasFiniteType.lean:208` — `jacobianDataOfMixedParamCharts` — SUSPICIOUS (degeneracy, not vacuity) — the one thing worth the caller's attention.** At `ι := Empty` every `∀ i` input (`rep`, `hf`, `hD`) holds vacuously, so three of the five inputs are free and the assembly would hand back a `JacobianData C` built on the empty glued object. It is *not* vacuous, because the unnamed instance argument `[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]` cannot be satisfied by an empty family — I verified this is a real obligation of `pic0RepresentableByOfCharts` (`Pic0SigmaSheaf.lean`) and not derivable. Confidence: the degeneracy is real but blocked; a "hypothesis discharged" claim about the fourth antecedent at this file is sound. This matches inbox I-0991/I-0992 independently.

11. **Absence-of-inhabitant check.** `HasCertifiedAdaptation` (`DivRepChartClassUnivAny.lean:155`) and `ForallPrimeAwayCertified` (`DivRepChartClassUnivZarLocal.lean:225`) have **no inhabitant anywhere in the tree** — every consumer takes them as a hypothesis. That is the reportable defect of the *opposite* kind you asked me to flag: not vacuous but unwitnessed. Both files say so in their own "What this does NOT do" sections.

Mechanical scans that came back empty across all of `Picard/`: no field or def of type `True`/`Unit`/`PUnit`; no `instance`/`theorem` closed by a bare `trivial`/`⟨⟩`/`Subsingleton.elim`; **no `Fin 0`, no `m := 0`, no `Fin.elim0`/`IsEmpty.elim`** anywhere — so defect shape (b) via an empty index type does not occur in the certificate cluster.

## Coverage

**Enumerated fully** (read every class/structure and every Prop-valued def): all 21 `DivSchemeCert*.lean`; all 24 `DivRep*.lean`; `DivisorFamily.lean`, `DivisorFamilyZar.lean`, `DivisorFamilyAffCover.lean`, `DivisorFamilyAffAdaptation.lean`, `DivSchemeQProj.lean`, `DivSchemeFamily.lean`, `Pic0AtlasFiniteType.lean`, `JacobianData.lean`, `JacobianDataCharts.lean`. I used a multi-line-aware AWK pass over all 175 `DivScheme*` + 24 `DivRep*` files, which found exactly 7 Prop-valued gates in scope 1+2 — all read above.

**Skimmed** (declaration signatures and docstrings, not every proof): the remaining ~150 `DivScheme*` files; the `Pic0Chart*` family (~35 files) and `Tangent/*Chart*` (~15 files) in scope 3. I read the three Prop gates found there (`IsSplitWitnessIsoInvariant`, `IsPlusHonest`, `ChartFibrePresented`) and all are substantive.

**Not done:** no elaboration probes. I did not run `lake env lean` — the two candidate probes (a `trivial` attempt at `IsCertified`, and inhabiting the seam gates) would each need the heavy chart-ring variable bundle, and my static reading of the field types was decisive enough not to need them. So every CLEAN verdict above rests on reading field types, not on a compiler check. Given the prior sweep's stale-import risk, that is the honest limit of this result.
