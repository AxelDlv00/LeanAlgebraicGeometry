I have all the evidence. Here is my report.

## Verdict: the importance argument is **wrong in its central inference**, and correct only in two peripheral factual claims.

The load-bearing sentence — "antecedent 3 `rep` cannot be satisfied on the carrier I-0492 mandates" — inverts the direction of the strictness theorem it cites. The two line numbers are accurate; the reasoning built on them is not.

### (1) Line numbers accurate; but antecedent 3 is not a binder of the cited declaration

`pic0RepresentableByOfCharts` is at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161`. Its **actual** binders are three, and **none is `rep`**:

```
(f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
(hf : ∀ i, IsOpenImmersion.presheaf (f i))
[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]
```

"Antecedent 3 = `rep`" is a project-wide convention (`Pic0ChartAtlasCoupling.lean:12`: `IsChartUniv` / local surjectivity / `rep i`) in which `rep` is antecedent 3 of the *board row*, not of the implication. So calling `rep` "antecedent 3 of `pic0RepresentableByOfCharts`" is loose but consistent with house usage. Note `Pic0AtlasFiniteType.lean:8-16` already flags this list as incomplete (a fourth, `hlft`, is unowned).

`abelSigmaChart` is at `Pic0AtlasFromDivRep.lean:205`, exact binder as claimed:

```
def abelSigmaChart {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
```

So the "chart-typed consumer" half is verified.

### (2) `isCertified_affine_and_not_isCertified_chart` — real theorem, sorry-free, but conditional and self-admittedly not certified non-vacuous

`DivisorFamilyAffStrict.lean:186`. Sorry-free (grep: zero). Conclusion:

```
(∃ (D : AffCoverData C R) (A : AffAdaptation D d), A.IsCertified n)
  ∧ ∀ (A : DivisorAdaptation C R pi d) (m : ℕ), ¬ A.IsCertified m
```

The second conjunct **is** genuinely universal over adaptations and degrees — stronger than I expected. But:

- The file's own SCOPE section (lines 43-66) states the separation is **not certified non-vacuous**: no witness is constructible in this tree (needs `Sym^g C`, out of scope by `informal/spec-dd-r.md` §4.5), and the existing `n = 0` witnesses **contradict** `hx`/`hy`.
- Two hypotheses are quantified over **all** `AffCoverData` and **all** `AffAdaptation`: `hfib` and `hrank` (lines 176-185). `hrank` demands *every* adaptation of *every* widened cover have `rankAtStalk = n`. That is a very strong universal, and it is not obviously satisfiable — it is a second vacuity risk the SCOPE section does not mention.

So: a genuine strictness *schema*, with no instantiation, resting on hypotheses whose joint inhabitation is unproven and partly suspect.

### (3) The adversarial answer — the argument runs the wrong way, so no bridge is needed

`divFunctorToAff` (`DivisorFamilyAffFunctorCompare.lean:91`) is **not** claimed to be an iso anywhere (grepped case-insensitively for iso/bijective/injective/surjective/equiv near both `divFunctorToAff` and `divFamZarToAffVehicle`: nothing). There is **no** `divFunctorAff*Representable*`, no widened `abelSigmaChart`, no widened `pic0RepresentableByOfCharts`. On the file's own terms, that census is right.

But the bridge is irrelevant, because **the strictness theorem does not obstruct `rep`**. Reading the predicates side by side:

- `IsLocallyCertified` (`DivisorFamilyZar.lean:71`) and `IsLocallyCertifiedAff` (`DivisorFamilyAffZar.lean:103`) are identical except the local certificate is `CertifiedDivisorFamily` vs `CertifiedDivisorFamilyAff`.
- `isLocallyCertifiedAff_of_isLocallyCertified` (`DivisorFamilyAffCompare.lean:250`) gives chart ⟹ aff, and the converse is false. So `divFamZar ⊆ divFamZarAff`: the chart-typed functor is the **smaller** one.

A functor being smaller is not an obstruction to representability. Strictness says the chart-typed functor **misses** straddling divisors — it says nothing about whether what remains is representable by a scheme. And the tree already has three sorry-free producers of exactly the binder the file calls unsatisfiable:

- `DivRepGlobalData.representableBy` — `DivRepKit.lean:113` → `(divFunctor C pi g).RepresentableBy DivOver`
- `DivRepAffinePullback.representableBy` — `DivRepGlobalClassify.lean:306`
- `divFunctor_representableBy_of_chartClause` — `DivRepAffPullClause.lean:482`, whose docstring says the ε-identity U2 is "the *only* remaining input of divisor representability"

All three files: zero sorries. So `rep` is not blocked by a typing mismatch with the widened carrier; it is blocked by one open per-chart clause (U2/G-4). The file's diagnosis and the tree's actual diagnosis are different obligations.

### (4) I-0492 mandates the widened **certificate carrier**, not the widened **divisor functor**

Operative text (clause 2): "*The widening target: FinCoverData s pieces become arbitrary affine opens rather than basic opens of a FIXED PAIR of pinned P1 charts.*" Clause 3: "*THE CHART-WISE PARTITIONS OF UNITY ARE WHAT HAS TO GO*", with the explicit warning "*do not smuggle the old typing back in by typing pieces INTO the charts*". Clause 5 confirms the no-go is about "*pieces inside the preimages of a FIXED PAIR of points of P1*".

I-0492 says nothing about `divFunctorAff`, about representability, or about which functor the Picard atlas must consume. It is a directive about `FinCoverData.pieces`. The file's "I-0492 mandates the WIDENED `divFunctorAff`" is an **overread**: the protection mandates the widened *certificate*, and `divFunctorAff` is a downstream construction one lane chose to build on it. Nothing in I-0492 forbids `divFunctor` from continuing to exist or from being represented. (I-0491 is not addressed to this team; `horizon inbox show I-0491` errors out. Context from I-0074's reply: it is the human étale-sheafify decision, unrelated.)

### (5) Judgement, and how much of the gap remains

**Overstated to the point of being wrong on the main inference.** Specifically:

- Correct: `abelSigmaChart` takes chart-typed `rep`; there was no widened Abel hook; `divFunctorToAff` is one-directional and not an iso; the widened side had no consumer reaching `picEt`.
- Wrong: "`rep` cannot be satisfied on the carrier I-0492 mandates." I-0492 does not mandate that carrier for `rep`; and strictness constrains the *contents* of the chart-typed functor, not its representability. Three sorry-free producers of `(divFunctor C pi g).RepresentableBy DivOver` exist in the tree.
- Misleading: presenting a conditional-with-uninstantiated-hypotheses ("puts a straddling divisor out of chart-typed reach") as though a divisor had been exhibited. The strictness file is scrupulous about this; the audited file's header drops the caveat.

Does landing the Abel hook on the widened carrier move `rep` closer? **No.** The file itself concedes it "does not prove the widened functor representable, does not discharge `rep`" (lines 51-54) — that concession is accurate, and it is in tension with the header's framing of the work as unblocking `rep`. Concretely, the remaining distance is *larger* than before this file:

1. no widened `chartValueTrans` (`chartValueAff` at line 234 is a value map, not a natural transformation into `pic0TypeFunctor`);
2. `chartValueAff_mem_pic0Subgroup` (line 262) **takes `hdegAff` as a hypothesis** — the widened degree ledger is unproven, and the file states why it is genuine content (`DivFamZar.classDeg_picClass` consumes `relCover_sup`, which R2 deletes);
3. no widened `abelSigmaChart`, hence nothing reaching `pic0SigmaSheaf`;
4. no widened `pic0RepresentableByOfCharts`;
5. and `rep` for `divFunctorAff` would still need a widened `DivRepGlobalData` analogue, which does not exist.

The file's honest self-assessment — "nothing is new mathematics, and that cheapness is the finding" — is the accurate description. Its importance header is not. One point in its favour: `degAt_abelDivAff'_toAff` (line 285) inhabits `hdegAff` on chart-typed images, and the docstring correctly refuses to call that evidence for the general case.
