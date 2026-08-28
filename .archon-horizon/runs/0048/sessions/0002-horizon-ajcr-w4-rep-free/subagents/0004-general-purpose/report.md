## Answer to the central question

**There is no avoid-the-fibres condition anywhere in the DD-R charts as they are actually defined in Lean.** Not in the `Z(♦)` chart rings, not in `ThetaGeneratorSeed`, not in `FinCoverData`/`DivisorAdaptation`/`IsCertified`/`DivFamZar`. The spec deliberately forbids one. But the Lean tree *itself* contains landed theorems proving that the certificate interface **forces** exactly that condition, plus doc comments stating in so many words that it is **owed and not yet supplied**. So: absent by design, and provably necessary.

---

## 1. The spec (`informal/spec-dd-r.md`, read in full, 408 lines)

§1 "ADJUDICATION A", lines 130–135 — the condition is *explicitly excluded*:

> **The EXACT hypotheses DD-R's bricks carry**: `adaptation.IsCertified g` plus carve membership (the pair `ε(F)` satisfies `(♦)`, corank exactly `g`) — **never a support condition `supp D ∩ π⁻¹(Gm) = ∅`**, never `hdeg`, never `hsurj`. Any DD-R prover writing a support-separation hypothesis (`hsep`, `subsingleton_ovlColength_of_sep`) has left the route…

§1(i), lines 102–113: "**NO — P-fib's divisor cannot be arranged off-overlap.**"

§Discipline, line 360, binding: "(2) **no support-separation hypotheses** (§1)".

**ADDENDUM 1 §2** (lines 385–390), the claim you asked about, verbatim:

> **What is UNAFFECTED (adjudicated in I-0213 itself):** DDR-1 through DDR-8. The universal family of DDR-3/4 is **honestly certified over each `Z(♦)`-chart ring**, hence locally certified a fortiori (`DivFam.toZar` after `mapAlg`)…

This claim is **not backed by any landed unconditional Lean theorem** — see §6 below.

---

## 2. The two pinned charts: `relPinnedChart`

`/home/axel/…/AlgebraicJacobian/Picard/DivSchemeFamilySide.lean:115`

```lean
noncomputable def relPinnedChart : Bool → (relCurve C R).Opens
  | false => (relCover C R (fiberTwoCover π)).V₀
  | true  => (relCover C R (fiberTwoCover π)).V₁
```

`fiberTwoCover` (`AlgebraicJacobian/Cohomology/RigidEngine4Relative.lean:75`) has `V₀ := fiberChart₀ π`, `V₁ := fiberChart₁ π`, and (`AlgebraicJacobian/RiemannRoch/FiberTwist.lean:79,82`):

```lean
@[reducible] noncomputable def fiberChart₀ : Y.Opens := π ⁻¹ᵁ P1.chartOpen K 0
@[reducible] noncomputable def fiberChart₁ : Y.Opens := π ⁻¹ᵁ P1.chartOpen K 1
```

So `V₀` misses `π⁻¹(∞)`, `V₁` misses `π⁻¹(0)`, `V₀ ⊔ V₁ = ⊤` (`relCover_sup`, `Cohomology/RelativeTwoCover.lean:139`). These are the two *chart opens*, not loci of divisors — nothing about supports is attached to them.

---

## 3. `ThetaGeneratorSeed` and `relThetaSections` — no fibre hypothesis

`/home/axel/…/AlgebraicJacobian/Picard/DivSchemeFamily.lean:74–86` (verbatim, complete):

```lean
structure ThetaGeneratorSeed (C : Over (Spec (.of k))) (R : Type u) [CommRing R]
    [Algebra k R] (π : C.left ⟶ P1 k) [IsFinite π] (a : ℕ)
    (K : Submodule R (relThetaSections C R π a)) : Type u where
  side : relCurve C R → Bool
  h : ∀ z : relCurve C R, Γ(relCurve C R, relPinnedChart C R π (side z))
  mem_basicOpen : ∀ z : relCurve C R, z ∈ (relCurve C R).basicOpen (h z)
  sec : relCurve C R → relThetaSections C R π a
  sec_mem : ∀ z, sec z ∈ K
```

Five fields. `side z` picks *one* chart containing `z` — crucially it does **not** require `z ∈ V₀ ⊓ V₁`. A point of `π⁻¹(0)` is perfectly legal (it just gets `side = false`).

The two clauses (`DivSchemeFamily.lean:129–137`):

```lean
structure IsGenerator : Prop where
  dvd : ∀ (z : relCurve C R) ⦃ψ : relThetaSections C R π a⦄, ψ ∈ K →
    relThetaResSide a (D.side z) (D.piece_le z) ψ ∈ Ideal.span {D.eqn z}
  fibre_regular : ∀ (z : relCurve C R) (p : PrimeSpectrum R)
      (f : Γ(relCurve C R, D.piece z)),
    ((relCurve C R).resHom ((relCurve C R).basicOpen_le f) (D.eqn z) ⊗ₜ[R]
        (1 : p.asIdeal.ResidueField)) ∈
      nonZeroDivisors
        (Γ(relCurve C R, (relCurve C R).basicOpen f) ⊗[R] p.asIdeal.ResidueField)
```

Local generation + fibrewise regularity. **Nothing forces the associated divisor to avoid the pinned fibres.** The DDR-3 deliverables are `localEquations` (`:349`) and `divisorAdaptation` (`:367`); both take only `[IsNoetherianRing R]` and `hD : D.IsGenerator`.

`relThetaSections` (`Picard/DivisorFamilyTheta.lean:59`) is `↥(twistSubmodule R V₀ V₁ (relThetaCocycle C R π a) ⊤)` — global twisted pairs, unconditioned.

The concrete universal seed confirms it: `seedUniv` (`Picard/DivSchemeSeedUnivGen.lean:283`) sets `side := fun z => (exists_seedPoint … z).choose`, and `exists_seedPoint` opens with `obtain ⟨b, hzb⟩ := exists_mem_relPinnedChart z` — "*some* chart containing `z`". The redesigned `seedUniv'` (`Picard/DivSchemeRedesignSeedUniv.lean:180`) reuses that `side` verbatim; its extra hypotheses are `hrdn : SeedUnivRDN` (a support-avoidance of a *module stalk prime*, `:130`) and `hfib` — both pointwise algebraic, neither about `π⁻¹(0)/π⁻¹(∞)`.

---

## 4. `FinCoverData`, `IsCertified`, `DivFamZar`, `hnoLeak`, clause (c1)

`FinCoverData` — `/home/axel/…/AlgebraicJacobian/Picard/DivisorFamily.lean:160`: `m₀ m₁ : ℕ`, `h₀ h₁` basic-open generators of `V₀`/`V₁`, `a₀ a₁` partition coefficients, `partition₀ : ∑ j, a₀ j * h₀ j = 1`, `partition₁` likewise. Pure cover data — no support condition.

`DivisorAdaptation` — `DivisorFamily.lean:232`, extends `FinCoverData`, adds `eqn` and `eqn_rel` (unit-ratio refinement). No support condition.

`IsCertified` — `/home/axel/…/AlgebraicJacobian/Picard/DivisorFamily.lean:426–441`, verbatim, all seven clauses:

```lean
structure IsCertified (n : ℕ) : Prop where
  finite_colength : ∀ j, Module.Finite R (A.colength j)          -- (c1)
  projective_colength : ∀ j, Module.Projective R (A.colength j)   -- (c1)
  finite_glued : Module.Finite R A.Glued                          -- (c2)
  projective_glued : Module.Projective R A.Glued                  -- (c2)
  rankAtStalk_glued : ∀ p : PrimeSpectrum R, Module.rankAtStalk A.Glued p = n
  flat_coker_incl : Module.Flat R (A.chartProd ⧸ A.gluedSubmodule) -- (c3)
  flat_coker_diff :
    Module.Flat R (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight)) -- (c4)
```

So **(c1) = `finite_colength` + `projective_colength`**, i.e. each `Γ(D(h_j)) ⧸ (f_j)` is finite projective over `R`. No fibre language.

`DivFamZar` — `/home/axel/…/AlgebraicJacobian/Picard/DivisorFamilyZar.lean:235`, carrier `IsLocallyCertified` (`:71`):

```lean
def IsLocallyCertified (n : ℕ) (d : (relCurve C R).LocalEquations) : Prop :=
  ∃ (m : ℕ) (g : Fin m → R), Ideal.span (Set.range g) = ⊤ ∧
    ∀ i : Fin m, … ∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) π n,
        Scheme.LocalEquations.DivEq G.eqns (d.pullback …)
```

Span-⊤ family + away-local certified families. Again no support/fibre clause.

**`hnoLeak`** — the assembler hypothesis, `/home/axel/…/AlgebraicJacobian/Picard/DivSchemeCertUniv.lean:104–108`:

```lean
theorem isCertified_of_noLeak_kernel_spanning [IsNoetherianRing R] {n : Nat}
    (hnoLeak : forall (j : A.index) (s : Spec (.of R)),
      ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces j : Set (relCurve C R))) <=
        (A.pieces j : Set (relCurve C R)))
    … : A.IsCertified n
```

Read: *over every base point, the fibre trace of the closure of the piece-support-trace stays inside the piece.* It is the **sole route to `finite_colength` (c1)** — `finite_colength_of_forall_fibre_closure_subset`, `/home/axel/…/AlgebraicJacobian/Picard/SupportTubeFinite.lean:302`. It is a condition on *pieces*, not on `π⁻¹(0)/π⁻¹(∞)`. Same clause reappears in `DivSchemeCertSeed.lean:61`, `DivSchemeCertUniv.lean:144`, `DivSchemeCertZarKerSpan.lean:63,:123`.

---

## 5. The decisive finding: the tree proves the condition is *necessary*, and records it as MISSING

This is the substantive answer to your question — the lane has already discovered the gap.

**`/home/axel/…/AlgebraicJacobian/Picard/DivSchemeCertZarChartTrace.lean:126`** — `hnoLeak` implies a statement about the *pinned charts alone*:

```lean
theorem isClosed_supportLocus_inter_chart_of_forall_noLeak
    (hnoLeak : ∀ (j : A.index) (s : Spec (.of R)),
      ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces j : Set (relCurve C R))) ⊆
        (A.pieces j : Set (relCurve C R))) :
    IsClosed (d.supportLocus ∩ ((relCover C R (fiberTwoCover π)).V₀ : Set (relCurve C R)))
      ∧ IsClosed (d.supportLocus ∩ ((relCover C R (fiberTwoCover π)).V₁ : Set (relCurve C R)))
```

with the contrapositives `not_forall_noLeak_of_not_isClosed_chart₀` (`:154`) / `…chart₁` (`:164`) — *no* adaptation of such a system can satisfy the assembler's clause.

**`/home/axel/…/AlgebraicJacobian/Picard/DivSchemeCertZarSwallow.lean`**, doc comment lines 29–33 and 143–152, verbatim:

> Since `V₀ ⊔ V₁` is the whole relative curve, a nonempty support therefore lies in `V₀ ⊓ V₁` — **the divisor must avoid both vertical fibres `pi⁻¹(0)` and `pi⁻¹(∞)`** — or be confined to one of them. That is the honest chart-design hypothesis of the lane, and it is where the DD-R atlas has to do its work…

> This is the statement the DD-R atlas **owes**: **the chart's divisors avoid `pi⁻¹(0)` and `pi⁻¹(∞)`.** It is a hypothesis about the chart, and it is the only remaining geometric input of the (c1) side of the certificate.

with theorems `subset_chart₀_or_disjoint_chart₀` (`:156`) and `subset_chart₁_or_disjoint_chart₁` (`:171`).

**`/home/axel/…/AlgebraicJacobian/Picard/DivSchemeCertZarConn.lean:130`** — the satisfiability verdict:

```lean
theorem supportLocus_subset_chart_of_isPreconnected
    (hconn : IsPreconnected d.supportLocus) (hne : d.supportLocus.Nonempty)
    (hleak : ∀ j : A.index, d.supportLeak (A.pieces j) = ∅) :
    d.supportLocus ⊆ ((relCover C R (fiberTwoCover π)).V₀ : Set (relCurve C R))
      ∨ d.supportLocus ⊆ ((relCover C R (fiberTwoCover π)).V₁ : Set (relCurve C R))
```

and the obstruction `not_forall_supportLeak_eq_empty_of_isPreconnected` (`:154`), whose docstring gives the counterexample: `V(t x² + x y + t y²) ⊆ ℙ¹` over `k[t]`, connected, fibre `{0, ∞}` at `t = 0`. Its header (lines 26–35) says:

> …the certificate interface can only ever be satisfied by divisors confined to one pinned chart of `pi` — a **chart-design** condition. … the honest obligation of the lane is to make the DD-R atlas produce chart-confined divisors.

These three files **are** in the build (`AlgebraicJacobian.lean:327–329`). The only occurrences of `pi⁻¹(0)` / `pi⁻¹(∞)` anywhere in the Lean tree are in these two docstrings — never in a `def`, `structure` field, or hypothesis.

Note the tension with the spec: §Discipline (2) forbids support-separation hypotheses, while `DivSchemeCertZarChartTrace/Swallow/Conn` prove that (c1) cannot be had without one.

---

## 6. Status of the ADDENDUM-1 claim ("honestly certified over each `Z(♦)`-chart ring")

Every landed route to `IsCertified` takes the gap as a hypothesis. Exhaustive list:

- `DivSchemeCertUniv.lean:53` `isCertified_of_kernel_spanning` — takes `hfin`, `hregular`, `hovlFinite`, `hovlFlat`, `L/hle/hspan`, `hdim`.
- `DivSchemeCertUniv.lean:104` `isCertified_of_noLeak_kernel_spanning` — takes `hnoLeak`.
- `DivSchemeCertUniv.lean:144` `divisorAdaptation_isCertified_of_noLeak_kernel_spanning` — takes `hnoLeak`.
- `DivSchemeCertSeed.lean:61` `divisorAdaptation_isCertified_of_noLeak_kernel_spanning_degree` — takes `hnoLeak` + `hdeg`.
- `DivSchemeCertZarKerSpan.lean:63,:123` — take `hnoLeak`.
- `DivSchemeCertZarSep.lean:277` `isCertified_of_separated` — takes support-separation (exactly what §Discipline (2) bans).
- `DivSchemeCertZarSwallow.lean:115` — takes swallow-or-miss, which *implies* chart-confinement.
- `ThetaGeneratorSeed.certifiedFamily` (`Picard/DivSchemeEps.lean:237`) — takes `(hc : (D.divisorAdaptation hD).IsCertified g)` as an **input**.
- `ThetaGeneratorSeed.isLocallyCertified_of_isCertified` (`DivSchemeCertZarSeed.lean:150`) — takes `hc : … IsCertified n`.

There is **no** theorem in the tree of the form "the DDR-3 universal seed's adaptation over `DivCarveChartRing …` is `IsCertified g`" with no support/leak/separation hypothesis. The `Z(♦)` chart ring itself (`Picard/DivSchemeFamilyUniv.lean:55`) is just

```lean
abbrev DivCarveChartRing (i : (glueData k g r₁).J) (j : (glueData k g r₂).J) : Type u :=
  PairChartRing k g r₁ g r₂ i j ⧸ divCarveIdeal k A B g r₁ r₂ b₁ b₂ i j
```

— a quotient by the closed carve ideal `(♦)`. `DivScheme`/`carveScheme` (`Picard/DivScheme.lean`) is the `IdealSheafData.subscheme` of `carveIdealSheaf = ⨅ … .ker`; the atlas maps in `Picard/DivSchemeAtlasFactor.lean:58,:361` are pure morphism plumbing. **No support/fibre datum appears in any of them.**

The strategic escape actually taken is not a chart condition but a weakening of the target: `DivSchemeCertZarSeed.lean` (header, lines 11–35) drops the global certificate for `IsLocallyCertified`, and `DivSchemeCertZarPointwise.lean` / `DivSchemeCertZarTube.lean` supply `hnoLeak` only over a *shrunken base* (leak-free outside the closed base image of the leak locus). `DivSchemeCertZarTube.lean` header is candid: "what a fibre analysis is still needed for is the base points *inside* that closed image."

---

## 7. `Pic0ChartLocusOpen.lean` / `Pic0ChartLocusFibreField.lean`

Both are the Pic⁰/CHART-U(b) openness lane, not the `Z(♦)` atlas, and `chartLocus` **is not defined in Lean at all** — `Pic0ChartLocusFibreField.lean:20-21` says "That content is `chartLocus`-free (I-0252's phrasing through the **still-undefined `chartLocus`**, DAT-C C9, is pure plumbing on top)". The landed content:

- `Pic0ChartLocusOpen.lean:80` `BasicOpenCocycleDatum.isOpen_setOf_exists_witness_h1_vanishing` — openness in `Spec B` of `{q | ∃ W, picClass W = … ∧ Subsingleton (H¹ …)}`.
- `Pic0ChartLocusFibreField.lean:115` `BasicOpenCocycleDatum.HasWitnessH1Vanishing`, `:142` `…_iff_of_fieldExtension`, `:177` `…_congr_of_cechPicClass_eq`.

Predicates indexed by *base primes* `q`, conditions on `H¹` of a witness divisor. **No fibre-avoidance clause.**

---

## 8. What I searched (so the negatives are auditable)

- `grep -rn "Disjoint"` over `AlgebraicJacobian/Picard/` — only hits: the `DivSchemeCertZar{Swallow,Conn}` dichotomies above and `EffectivityInvertibleAvoid.lean:133` (unrelated ideal disjointness).
- `grep -rni "avoid|awayFrom|missesFibre|offFibre|pinnedFibre|zeroFibre|infFibre"` over all of `AlgebraicJacobian/` — no fibre-avoidance definition; hits are prose or `SeedUnivRDN`-style module-support avoidance.
- `grep -rn "π⁻¹(0)|pi⁻¹(0)|π⁻¹(∞)|pi⁻¹(∞)|π⁻¹(Gm)|pi⁻¹(Gm)"` over `--include=*.lean` — **5 hits, all doc comments**, all in `DivSchemeCertZarSwallow.lean` (30, 150, 151) and `DivSchemeCertZarConn.lean` (127, 148).
- `grep -rn "supportLocus ⊆|supportLocus ∩"` — all hits are the piece/leak machinery (`SupportTube*.lean`, `DivSchemeCertOverlapFinite.lean`, `DivSchemeCertUniv/Seed.lean`) plus the CertZar necessity files.
- `grep -rn "chartLocus"` — 6 hits, all doc comments; no definition.
- `grep -rn "hnoLeak|noLeak"` — enumerated in §4/§6 above.
- Read in full: `DivSchemeFamily.lean` (503), `DivSchemeFamilySide.lean` (216), `DivSchemeFamilyUniv.lean` (149), `Pic0ChartLocusOpen.lean` (137), `Pic0ChartLocusFibreField.lean` (187), `DivSchemeCertUniv.lean` (177), `DivSchemeCertZarChartTrace.lean` (176), `DivSchemeCertZarSwallow.lean` (188), `DivSchemeCertZarConn.lean` (164), `DivSchemeRedesignSeedUniv.lean` (229), `DivisorFamily.lean:100–500`, `DivisorFamilyZar.lean:40–160`, plus headers/outlines of `DivScheme.lean`, `DivSchemeAtlasFactor.lean`, `DivSchemeEpsCarve.lean`, `DivSchemeEpsCarveKit.lean`, `DivSchemeCertificate.lean`, `DivSchemeCertSeed.lean`, `DivSchemeCertZarSeed.lean`, `DivSchemeCertZarPointwise.lean`, `DivSchemeCertZarTube.lean`, `DivSchemeCertZarSep.lean`, `DivSchemeCertZarLeak.lean`, `SupportTubeFinite.lean`, `DivSchemeSeedUnivGen.lean`, `DivSchemeRedesignKappaZSeed.lean`.

**One thing I could not find** (stated as an explicit negative): `DivSchemeCertZarChartTrace.lean:35` cites `DivSchemeCertZarChartPair.lean` as realizing the sufficient direction ("the two-piece adaptation whose pieces are the pinned charts themselves"). **That file does not exist** in `AlgebraicJacobian/Picard/`. Also, `DivSchemeCertUniv/CertSeed/CertZarSeed/CertZarPointwise/CertZarTube/CertZarSep`, `DivSchemeRedesignSeedUniv`, `DivSchemeRedesignKappaZSeed` are **not reachable from the root `AlgebraicJacobian.lean`** (487 imports; the CertZar chain enters only at `ChartTrace`/`Swallow`/`Conn`) — a hygiene observation, not a correctness one. No files were edited.
