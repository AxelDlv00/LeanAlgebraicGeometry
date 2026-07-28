# W4-DAT-B WORKSHEET — coverage + injectivity: every pic⁰ point is Zariski-locally a chart point

*2026-07-19, Fable design lane (`AJCR.w4-rep.datum.dat-b`, worksheet-first).  BINDING
parents: `informal/w4-datum-worksheet.md` §2.3 (V-rel-B), §4 DAT-B row, §5 risk 7 (the
k^s-vs-finite staging, deliberately open there — DECIDED here §0.3), §3.2 (RE-5, landed);
`informal/dat-d-worksheet.md` §4.2 (the DAT-B consumption row) + Addendum;
`informal/w4-datc-worksheet.md` (the sibling worksheet, landed mid-flight TODAY — its
CHART-U interface and GAP list are consumed verbatim, §1.6/§3.1 below; the shared bricks
are co-signed in §3.1); `informal/wave3-picard-design.md` §5–6 (the pinned
`JacobianData`/pic⁰ shapes), `informal/route-decision.md` (the Milne-style Σ-chart pin).
Inbox absorbed: I-0229 (Φ-pack/field dictionary), I-0233/I-0234 (P-fib-N + the windowS
seam — the reason ledger constants never transport, honored in §1.4), I-0236…I-0245
(the landed layers and gotcha lists; REQUIRED READING for implementation lanes).  Every
`file:line` below was verified by DIRECT READ this pass; no Lean edited, no lake run,
no LSP (index empty — grep + read only).*

## §0 Verdicts up front

### §0.1 The deliverable is frozen by landed code — DAT-B is ONE instance plus its feed

`pic0RepresentableByOfCharts` (`Picard/Pic0SigmaSheaf.lean:161-169`) already consumes
exactly what Stage C needs:

```
noncomputable def pic0RepresentableByOfCharts
    {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (hf : ∀ i, IsOpenImmersion.presheaf (f i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)] :
    (pic0TypeFunctor C).RepresentableBy (Over.mk (…))
```

`f`/`hf` are DAT-C's (w4-datc §3.2–§3.3, frozen).  **DAT-B = the
`Presheaf.IsLocallySurjective` instance** (mathlib
`CategoryTheory/Sites/LocallySurjective.lean:94`: `imageSieve_mem` — every section of
`pic0SigmaSheaf` is Zariski-locally in the image of the chart family), plus the
injectivity bookkeeping of §2 (which turns out to be LANDED, §0.4) and the qc/effectivity
export for DAT-J (§3.3).  Elementwise (`imageSieve`, `LocallySurjective.lean:38-52`):
for every scheme `T`, structure `a : T ⟶ Spec k`, and `λ ∈ pic0Subgroup C (Over.mk a)`
(`Picard/Pic0Functor.lean:107`, membership `Iff.rfl` `:121`), the opens on which
`(a, λ)` restricts to a chart value must cover `T`.  With DAT-C's CHART-U(a)/(c)
(w4-datc §3.3) this reduces to the **pointwise coverage theorem** (§1.2): the chart
loci `{chartLocus c λ}_{c}` cover `T`.

### §0.2 The main structural finding: coverage proper is FIELD-LEVEL; RE-5/engine enter only through the shared openness brick

The parent §2.3 chain (extraction → RE-5 → engine → transport) is where the roadmap
title's "RE-5 descent + engine" live — but in the landed architecture that chain is
the mechanism of **CHART-U(b)** (openness of the chart locus, co-owned with DAT-C,
§1.6), NOT of the coverage theorem itself.  Membership of a point `t` in a chart locus
is a statement about the FIBRE class at `κ(t)` alone (CHART-U(a) is a field-point
predicate), so the coverage theorem is a per-fibre field-level argument:
degree bookkeeping (landed, §1.3) + the h⁰-drop normalization (B-1, §1.4) + the
separable-point density transfer (B-2, §1.5).  Consequences, each a route-around
recorded so no prover rebuilds retired machinery:

1. **The RE-5 (1d-ii) seam is NOT on DAT-B's path.**  `DatumDescent.lean:38-49` records
   "threading the kernel onto `H⁰(D.sheaf)` on the nose is the remaining (1d-ii)
   clause … the one open SEAM".  DAT-B never threads `H⁰` across `B₀ → B`: the
   openness brick consumes the engine over the stage (`descentRigidEngine`,
   `Cohomology/DatumDescent.lean:547`) and transports only OPENS (preimage) and
   CLASSES (`descent_cechPicClass`, `:525`), never section modules.  The seam stays
   with the DAT-1 lane; nothing here gates on it.
2. **The m-strata do NOT collapse** (correcting a tempting simplification): DAT-0a's
   uniform bound `b` (`RiemannRoch/UniformVanishing.lean:71`) is a bound *per field*
   `b = b(Y_K, π_K)`, and per I-0204/I-0234 ledger constants never transport across
   `k → κ(t)`.  So the twist exponent `m` in the chart index must range: at a fibre
   `L` the coverage argument picks `m_t` with `m_t·d₁ ≥ b_L + …` against the fibre's
   OWN DAT-0a instance (§1.4 step 3).  Statements quantify `∃ c = (m, Σ)`; no uniform
   `m₀` exists.  (Per-chart membership stays a single collapsed condition — parent §5.5
   discipline unaffected.)
3. **DAT-B needs NO relative high-twist certificate.**  w4-datc §3.4 expects DAT-B to
   need CERT-Σ "at high twist" (the parent §2.2.3a projective-generator argument).  In
   the design below the high-twist divisor presentation is needed only at FIELD fibres
   (the DAT-J effectivity export, §3.3), where the FIELD dictionary suffices — the
   `hsurj` completion (B-3, §1.7), not relative CERT-Σ.  The only relative certificate
   DAT-B consumes is DAT-C's own CERT-Σ at degree `g`, through CHART-U(c), untouched.

### §0.3 The staging DECISION (parent §5.7 residue): sep-closed assembly level; finite-level extraction is post-glue and owned by DAT-glue/DAT-G

**Decided:** the coverage theorem (hence the 01JJ assembly) is stated at a
**separably closed instantiation** `K_s` of the standing pack (a separable closure of
`k`; every Stage-B statement is generic in its base field, so this is an
instantiation, not new machinery).  The chart index is the full DAT-C index
`c = (m, Σ)` with `Σ` an effective `CurveDivisor` on the `K_s`-curve — an INFINITE
`Type u` index, which mathlib's 01JJ accepts as-is (`AlgebraicGeometry/Sites/
Representability.lean:56-58` takes any `ι : Type u`).  Coverage at a FIXED finite
separable level is **neither claimed nor needed**: the per-fibre drop argument
requires rational points adapted to the fibre (the parent §2.5(d) genus-2/ℚ
obstruction is exactly this), and no proof at finite level is known to this design.

**The finite-level extraction is post-glue**: once `J_{K_s}` exists, its chart images
are OPEN (each chart is an open subfunctor of the now-represented functor), they cover
`J_{K_s}` (coverage), and `J_{K_s}` is quasi-compact by the DAT-J image argument
(`|J| =` the image of the qc `DivScheme` under the Abel morphism — `compactSpace_divScheme`
`Picard/DivSchemeQProj.lean:194` + the §3.3 effectivity export).  A finite chart
subfamily follows topologically; its finitely many `Σ_i` (finitely many `K_s`-points
of a finite-type scheme) are defined over one finite separable `k'/k`, which is how
`k'` is CHOSEN.  Descending the representing property from `K_s` to `k'` (so that
DAT-G's finite-Galois Speiser machinery applies from `k'` down to `k`) is a genuine
brick **nobody's scoreboard carries** (the w4-ddr9 §0.2 pattern): named here
**DAT-G0 — finite-level transfer of the representing datum** (spreading out the
finite chart/gluing data + the fpqc-locality of "yoneda(J) ⟶ pic0-sheaf is an iso").
It belongs to the DAT-glue/DAT-G boundary, NOT to DAT-B; this worksheet's obligation
is to have FLAGGED it (orchestrator echo, end note).  Nothing in §1–§2 depends on how
DAT-G0 is discharged.

### §0.4 Injectivity is LANDED — the second half of the node title is bookkeeping

Every injectivity/separation input the 01JJ engine needs is in the tree (§2): the
big-site sheaf certificate `pic0SigmaFunctor_isSheaf` (`Picard/Pic0SigmaSheaf.lean:90`
region, bundled `:147`), the arbitrary-test separation and S-lemma
(`pic0Subgroup_ext_of_le_cover` `Picard/Pic0ZariskiSheaf.lean:263`,
`mem_pic0Subgroup_of_cover` `:277`), the affine basic-open half
(`PicEtAff.eq_of_away_eq`, `Picard/PicEtAffZariskiSep.lean:137`), (C1) étale unit
injectivity (`PicEtAff.unit_injective` `Picard/EtaleSeparatedness.lean:16`,
closed via `unit_injective_of_ker` `Picard/EtaleSeparatednessClose.lean:193`), and the
classify-uniqueness (`IsDivRepClassify` + `divClassifyZar` ∃!-form,
`Picard/DivRepClassifyZar.lean:90/:206`).  The chart-functor mono is DAT-C's §3.2.
**DAT-B builds no injectivity file**; §2 records the consumption map so no lane
re-proves any of it.

### §0.5 Launchability summary (details §4)

* Launchable NOW, field-level, no gates: **B-1** (drop normalization), **B-2**
  (separable-point density), **B-3** (field-dictionary `hsurj` completion — F4
  `divRepClassifyZar` is landed, I-0243, so the DivScheme-point corollary closes too).
* Launchable after a one-note co-sign with the DAT-C lane: **B-4** (CHART-U(a)
  arbitrary-plus-class spelling + CHART-U(b) openness — every chain input landed:
  extraction `Cohomology/GluedSheafExtraction.lean:301`, RE-5
  `Cohomology/DatumDescent.lean:514`, engine open `Cohomology/GluedSheafEngine.lean:221`).
* Gated on DAT-C names only (their C5, launchable now on their plan): **B-5** (the
  pointwise coverage theorem).
* Gated on divRep(F7)+CERT-Σ through DAT-C's C9: **B-6** (the `IsLocallySurjective`
  instance + DAT-glue handoff) — the ONLY row of this plan that waits for `divRep`.

**B-5 STATUS 2026-07-28 (run 0072, lane `ajcr-charts`): three of its inputs are now Lean, and
the row's own step-6 typing gap is diagnosed (see the §1.2 amendment).**  Landed this pass:

| input | name | file |
|---|---|---|
| step 1, splitting with the twist carried | `picEtAffineEquiv_map_chartTwistFactor_eq_unit` | `Picard/Pic0ChartTwistSplit.lean` |
| the `chartLocus` intro rule | `isSplitWitness_of_witness_twistClass` | same |
| steps 2–4, degree of the presenting class | `classDeg_chartTwistClass_baseChange`, `classDeg_of_presenting` | `Picard/Pic0ChartCoverageDegree.lean` |
| step 6, chart index base change — **HALF: transport upward from a `k`-point only** | `graphPicClass_base_of_field`, `classDeg_graphPicClass_base` | `Picard/Pic0ChartRationalGraph.lean` |

**WHAT B-5 STILL OWES — corrected 2026-07-28 later the same session (issues I-0614, I-0615),
after a degree probe and a fresh-context review each refuted part of the paragraph that stood
here.  It claimed steps 1/2/4/5/6 discharged and step 3 the sole residue.  THREE residues:**

1. **step 3 — the twist exponent `m`**, chosen against the fibre's OWN DAT-0a bound.  No uniform
   `m₀` exists (§0.2.2, I-0204), so this is irreducibly a per-fibre `∃ m` and no formulation can
   produce it for a caller.  (This was correctly identified.)
2. **step 2 — the degree of the presenting class.**  `classDeg_of_presenting` relates
   `classDeg L M` to the plus-class degree **at `L`**, while the coverage argument holds it at
   `K`.  Bridging them needs **base-field invariance of `degAff` under `PicEtAff.map`**, which
   does not exist in the tree (measured: nothing matches it).  Small, real, shaped like the
   landed `degAff_baseFieldShuffle` (`Picard/Pic0ThetaAssembly.lean:67`).
3. **step 6 — the FEEDBACK.**  The drop runs at `Z := 0` (where `chartTwistClass C m 0 = θᵐ`,
   degree `m·d₁`, so the budget `e = m·d₁ − g` is nonzero); its output `Σ` is then the chart
   index's `Z`, at which the twisted degree is `g`.  **One `Z` is an input and the other an
   output**, and the landed graph transport goes upward from a `k`-point rather than from the
   `L`-level `Σ` the drop produces.  Machine-derived: under the single-`Z` reading the hypothesis
   pack forces `e = 0`, i.e. a zero drop budget.

Steps 1, 4 and 5 are discharged.  None of the three residues is `divRep`- or certificate-gated;
all three are statements about the fibre curve over `L` or the `k`-level index.

### §0.6 Standing context

The w4-datc §0.5 pack verbatim (= the `DivRepClassifyZar.lean:56-81` context), at the
instantiation `k := K_s` for §1.2–§1.6 (generic `k` elsewhere): `{k} [Field k]`,
`C : Over (Spec (.of k))`, `π : C.left ⟶ P1 k` `[IsFinite π]`, curve instances,
`hπ`, `g`, `hO`, `hχ`, windows `s/M`, `F̄`, `DivScheme!`/`divSchemeOver!`
(`Picard/DivScheme.lean:144/:156`), `VOver` and the chart data per w4-datc §1/§3.
`d₁ := classDeg k (thetaCechClass C)` (`Picard/ThetaShift.lean:263`, `1 ≤ d₁` `:270`).
Fibre fields are written `L` (with the standing pack via the base-change instances and
`[Module.Finite L H⁰/H¹]` from the finiteness lane, as in
`RiemannRoch/UniformVanishing.lean:60-66`).

---

## §1 The coverage statement pins

### §1.1 The final target (verbatim, stateable the day DAT-C's `f_c` exists)

```
instance pic0Charts_isLocallySurjective :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun c : ChartIndex C => f_c))
```

where `ChartIndex C := (m : ℕ) × {Σ : (C ⊗ overSpec k k).left.CurveDivisor //
0 ≤ Σ ∧ CurveDivisor.deg k Σ = (m : ℤ) * d₁ - g}` (w4-datc §3.2, dat-d §1.3 —
`Type u`) and `f_c` is DAT-C's chart map into `(pic0SigmaSheaf C).1`
(`Picard/Pic0SigmaSheaf.lean:147`).  Unfolding `imageSieve_mem`
(`CategoryTheory/Sites/LocallySurjective.lean:94`) on the Zariski pretopology, the
obligation is: for every `T : Scheme`, every section `(a, λ)` of `pic0SigmaFunctor C`
over `T` (`Pic0SigmaSheaf.lean:125`-region; `λ ∈ pic0Subgroup C (Over.mk a)`), the
sieve of maps along which `(a, λ)` becomes a chart value contains an open cover of
`T`.  By CHART-U(c) (w4-datc §3.3 — on `chartLocus c λ` the class IS a chart value,
through the classified normalized family), the covering family can be taken to be the
chart loci themselves, so the instance follows from §1.2 + CHART-U(b)+(c).  The
Σ-component bookkeeping (`a` restricted along the loci) is the landed
`Over.sigmaExtension` calculus (`Picard/OverSigmaExtension.lean:118-125`).

### §1.2 (COV-1) the pointwise coverage theorem — DAT-B's keystone

```
theorem pic0_chartLocus_cover
    (T : Over (Spec (.of k))) (lam : pic0Subgroup C T) (t : T.left) :
    ∃ c : ChartIndex C, t ∈ chartLocus c lam
```

at the `K_s`-instantiation (`[IsSepClosed k]` in the standing context), with
`chartLocus` the CO-SIGNED CHART-U(a) predicate (§1.6): the fibre class
`λ_t · θ^m · (Σ-shift)⁻¹` at `κ(t)` has, after some (equivalently any) finite
separable splitting `L` of the plus class, `h⁰ = 1` and `h¹ = 0` — equivalently an
effective degree-`g` witness with vanishing `H¹` (the two spellings agree by the
rank anchor `h0_eq_deg_add_chi_of_subsingleton_hModule_one`,
`RiemannRoch/FLVClass.lean:412`, at `deg = g`, `χ = 1`, and by GAP-2/Σ-UNIQ-fld the
witness is unique).  Proof chain, every step pinned:

1. **Fibre collapse.**  Restrict along `t` (as `overSpec k κ(t) ⟶ T`):
   `picEtAffineEquiv` (`Picard/PicEt.lean:235`, naturality
   `Picard/PicEtMap.lean:354`) reads the restriction in `PicEtAff C κ(t)`; a plus
   class is `PicEtAff.mk E x` (`Picard/PicEtAff.lean:224`); the field-cofinality
   theorem of the étale-cover layer (`Algebra/EtaleCover.lean`, wave3-design §9
   OPEN-3 CLOSED — étale covers of a field are refined by finite separable
   extensions) produces a finite separable `L/κ(t)` over which the class is an
   honest `relPic`/Čech class `μ₀` on `C_L`.
2. **Degree.**  `degAt λ t = 0` (`mem_pic0Subgroup_iff`, `Pic0Functor.lean:121`);
   the fibre degree of `λ·θ^m` is `m·d₁` on the nose: `degAt_pic0_mul_pow`
   (`Picard/DegreeSeam.lean:145`), `degAt_thetaFamily_pow`
   (`Picard/ThetaShift.lean:149`), with the `κ(t) → L` leg through E-iv-alg
   (`RiemannRoch/DegreeBaseFieldInvariance.lean`, the `relPicDeg_relPicAlgMap` face)
   — the deg-d5b D1 discipline: no other cross-field degree route.
3. **Choose `m`.**  DAT-0a AT THE FIBRE FIELD:
   `exists_bound_subsingleton_hModule_one_of_isFinite_toP1`
   (`RiemannRoch/UniformVanishing.lean:71`) over `L` gives `b_L`; pick `m` with
   `m·d₁ ≥ max b_L (g + 1)` (so the drop budget `e := m·d₁ − g ≥ 1` and the start
   class clears the bound).  This is where §0.2.2 bites: `b_L` is the fibre's own
   bound, `m` exists per-fibre, never uniformly.
4. **Kill `h¹` at the start.**  `μ := μ₀ · (θ_L)^m` is a divisor class
   (`CurveDivisor.exists_picClass_eq`, `Picard/DivisorClassMeromorphic.lean:118`,
   over the integral `C_L`); any representative `W` has `deg = m·d₁ ≥ b_L`, so
   `Subsingleton H¹(𝒪(W))` (step-3 bound), transported across representatives by
   W6-lite class-invariance (`subsingleton_hModule_one_of_picClass_eq`,
   `RiemannRoch/ClassCohomology.lean:111`).  (The θ-class transports to the fibre
   through the landed generic-exponent theta layer:
   `cechPicClass_map_thetaChartDatum`, `Picard/ThetaChartClassNaturality.lean`, and
   the DAT-4 collapse `degAt_of_affineEquiv_eq_unit_*`,
   `Picard/DegreeSeam.lean:67-107`.)
5. **Greedy drop (B-1, §1.4)** with points supplied by **density (B-2, §1.5)**:
   `e` rational points `x₁, …, x_e ∈ C(K_s)`, base-changed into `C_L` (each is
   `L`-RATIONAL there — residue-field-`k` points have singleton fibres), each chosen
   outside the base locus of the current system, give
   `h⁰(μ − x₁ − … − x_e) = 1` and `h¹ = 0`.
6. **Package.**  `Σ := Σᵢ single(xᵢ)` is an effective `K_s`-divisor of degree
   `m·d₁ − g` — a legal `ChartIndex` entry; the predicate of CHART-U(a) holds at `t`
   with splitting `L`; splitting-independence is E-iv-alg + class-invariance
   (dimension conditions only, step 4's tools).  ∎

**AMENDMENT TO STEP 6, 2026-07-28 (run 0072, lane `ajcr-charts`) — the step as written
hides a typing gap, and the natural repair is the WRONG obligation.**

The gap: `ChartIndex`'s `Σ` is a `CurveDivisor` on the **base** curve
`(C ⊗ overSpec k k).left` (frozen, `w4-datc` §3.2), while steps 5's `xᵢ` and the drop divisor
live over the **fibre field** `L`.  "`Σ := Σᵢ single(xᵢ)` is a legal `ChartIndex` entry" is
therefore not a typing identity, and closing it looks like it needs a base-change operation on
`CurveDivisor`.

Two findings, both measured:

* **There is no such operation anywhere in the tree** — no `CurveDivisor.pullback`, `.comap`
  or `.baseChange`.  Only `picClass` and the `LocalEquations` pullback route exist.  So a lane
  that budgets step 6 as "transport the divisor" is budgeting a construction.
* **It does not need one.**  Everything downstream of step 6 mentions only the *class*: the
  witness clause of `IsSplitWitness` is `picClass L W = M`, and the chart-index constraint is
  about `deg_k Z`.  For the divisors that actually occur — one-point divisors at the
  `k`-rational points step 5 draws from the density oracle — the class-level base change is
  **already landed** and was never cited by either lane:

  ```
  Over.graphLocalEquations_base_change      Curve/GraphDivisor.lean:263
      graphPicClass C (g ≫ t) = CechPic.map (C ◁ g).left (graphPicClass C t)
  presentationDivisor_graphLocalEquations   RiemannRoch/GraphDegree.lean:422
  classDeg_graphPicClass                   RiemannRoch/GraphDegree.lean:445  (degree = 1)
  ```

  i.e. a rational point's graph class *is* the class of its one-point divisor, of degree
  exactly one, and it base-changes.  Landed in this spelling as
  `graphPicClass_base_of_field` / `classDeg_graphPicClass_base`
  (`Picard/Pic0ChartRationalGraph.lean`).

**Restated step 6:** build the chart index from the `k`-points' *graph classes* at the base,
check `deg_k Z = m·d₁ − g` there **once**, and transport by E-iv-alg — the degree then holds at
every fibre field with no per-field computation, honouring I-0204 (ledger constants do not
cross).  Never transport a coefficient function.

### §1.3 What is spent where (the parent's clause map)

| roadmap-title clause | mechanism in this design |
|---|---|
| "every pic⁰ point is Zariski-locally a chart point" | COV-1 (§1.2) + CHART-U(b) openness + CHART-U(c) universal element |
| "RE-5 descent + engine" | inside CHART-U(b) ONLY (§1.6): extraction `GluedSheafExtraction.lean:301` → `exists_fg_isNoetherianRing_baseChange_eq` `DatumDescent.lean:514` → `datumRigidEngine_isOpen_vanishing` `GluedSheafEngine.lean:221` |
| "DAT-P points" | inside B-2 ONLY (§1.5): `Over.exists_rationalPoint_mem` `Curve/SeparablyClosedPoints.lean:157` at the base `K_s` |
| "injectivity from the separatedness lane" | §2 — landed, consumed not proved |
| dat-d §4.2 row: "degree-`g` class with `h⁰ ≥ 1` has an effective witness = a `DivScheme`-point" | §3.3 (DAT-J's qc export): `riemann_inequality` `RiemannRoch/ChiLedger.lean:137` + B-3 + `divRepClassifyZar` `Picard/DivRepClassifyZar.lean:244` |
| dat-d §4.2 row: "injectivity bookkeeping" | §2 consumption map |

### §1.4 (COV-2 = B-1) the h⁰-drop normalization — honest new work #1

Field-level, over any standing-pack field `L`, parametrized by an **admissible point
oracle** so the density discharge decouples (B-2 plugs in `P :=` base-changed
`C(K_s)`-points):

```
theorem exists_effective_sub_h0_eq_one
    (P : Set Y)   -- admissible points; each L-rational (residueDeg = 1)
    (hdense : ∀ W : Y.Opens, (W : Set Y).Nonempty → (P ∩ W).Nonempty)
    (hP : ∀ x ∈ P, Y.residueDeg L x = 1)
    (W : Y.CurveDivisor) (e : ℕ)
    (hdeg : CurveDivisor.deg L W = (g : ℤ) + e)
    (h1 : Subsingleton (Sheaf.HModule (Y.divisorSheaf L W) 1)) :
    ∃ Σ : Y.CurveDivisor, 0 ≤ Σ ∧ CurveDivisor.deg L Σ = e ∧
      (∀ x, coeffAt _ Σ ≠ 0 → x ∈ P) ∧
      Sheaf.h0 (Y.divisorSheaf L (W - Σ)) = 1 ∧
      Subsingleton (Sheaf.HModule (Y.divisorSheaf L (W - Σ)) 1)
```

(Spelling of the support clause lane-owned; the content is `Σ` supported in `P`.)
Route, by induction on `e`; per step, for the current `W'` (`h¹ = 0`,
`deg = g + e' ≥ g + 1`, so `h⁰ = e' + 1 ≥ 2` by the rank anchor `FLVClass.lean:412`):

* **The bad locus is small.**  A nonzero section exists (`h⁰ ≥ 1`); its effective
  witness `E` (`exists_effective_of_h0_pos`, `RiemannRoch/SectionBound.lean:175`;
  cf. `exists_effective_of_picClass`, `RiemannRoch/FLVClass.lean:208`) has finite
  support; every base point of the system lies in `supp E` (a point where ALL
  sections vanish in particular kills this one; read through the `divisorSections`/
  `ord` calculus — the `BaseDivisor` kit is the landed vocabulary:
  `Scheme.baseDivisor` `RiemannRoch/BaseDivisor.lean:80`,
  `le_divisorSections_sub_baseDivisor` `:160`,
  `exists_coeffAt_eq_baseDivisorAt` `:143`).  So the non-base locus contains a
  nonempty open (complement of a finite closed set in the curve), and `hdense`
  supplies `x ∈ P` there.
* **Exact drop at a rational non-base point.**  `h⁰(W' − x) ≤ h⁰(W') − 1` (sections
  of `W' − x` are sections of `W'` vanishing at `x` — a proper subspace, since a
  non-base `x` has a non-vanishing section; one linear condition as
  `residueDeg x = 1`), and `h⁰(W' − x) ≥ χ(W' − x) = h⁰(W') − 1` (χ-ledger
  `chi_divisorSheaf` through `ChiLedger`, `h¹ ≥ 0`).  Equality forces BOTH
  `h⁰(W' − x) = h⁰(W') − 1` AND `h¹(W' − x) = 0` — the induction invariant.
  (The `h¹`-monotonicity conveniences `h1_le_h1_sub_single`/`h1_add_single_le`,
  `RiemannRoch/SectionBound.lean:67/:89`, are the adjacent landed calculus; the
  strict-drop precedents `h0_normalization_sub_single_lt`
  `RiemannRoch/PFib.lean:71` and `h0_window_sub_single_lt`
  `RiemannRoch/CarveDegreePinch.lean:76` are window-specific mirrors of this step —
  imitate their `deg_single`/`coeffAt` bookkeeping, do not consume them.)
* Terminate at `e' = 0`: `h⁰ = 1`, `h¹ = 0`.  ∎

Size M→L; all substrate landed; NO scheme beyond the fibre curve (the DD-F
discipline: a relative object appearing in B-1 is the stop signal).

### §1.5 (COV-3 = B-2) the separable-point density transfer — honest new work #2

```
theorem dense_baseChange_rationalPoints
    [IsSepClosed k]   -- the base K_s
    {L : Type u} [Field L] [Algebra k L]
    (W : (relCurve C L).Opens) (hW : (W : Set (relCurve C L)).Nonempty) :
    ∃ (p : Spec (.of k) ⟶ C.left) (hp : p ≫ C.hom = 𝟙 _),
      (baseChangePoint p : relCurve C L) ∈ W   -- the L-point under p, spelling lane-owned
```

— base-changed `K_s`-points of the curve are dense in `C_L` for EVERY field
`L ⊇ K_s`.  Route (elementary, no flatness-openness):

1. `C(K_s)` is dense in `C.left`: DAT-P density form, `Over.exists_rationalPoint_mem`
   (`Curve/SeparablyClosedPoints.lean:157`; scheme form `:135`).
2. A rational point has a SINGLETON fibre under `relCurve C L → C.left` (residue
   field `k`; the fibre is `Spec (κ(x) ⊗_k L) = Spec L`), so membership in an open
   upstairs is equivalent to membership of the image of the open's "trace".
3. The trace argument is the tensor linear-independence computation: on an affine
   chart, a function `f = Σ gᵢ ⊗ cᵢ ∈ Γ(U) ⊗_k L` (`cᵢ` a `k`-basis slice of `L`,
   through the landed on-the-nose chart identification `Over.sectionsBaseChange`,
   `Cohomology/SectionsBaseChange.lean`) vanishing at every base-changed `K_s`-point
   has each `gᵢ` vanishing on the dense set of step 1, hence `gᵢ = 0` on the
   REDUCED chart (integrality of the standing pack), hence `f = 0`.  So no proper
   closed subset of `C_L` contains all base-changed rational points.  ∎

Size M.  Consumed by COV-1 step 5 (as the `hdense` oracle for `P :=` base-changed
`C(K_s)`-points, which have `residueDeg = 1` by step 2).

### §1.6 CHART-U(a)/(b) — the CO-SIGNED shared brick (w4-datc §3.3, accepted with two amendments)

**ACKNOWLEDGED AND BUILT, 2026-07-28 (run 0072, lane `ajcr-charts`).**  Both amendments
are accepted as written and are now Lean:

* the (a-amendment) split form is `AlgebraicGeometry.IsSplitWitness`, and `chartLocus`
  (`Picard/Pic0ChartLocus.lean`) is defined against it — general test, twisted class,
  split predicate.  Sorry-free.
* the (b-amendment) route of record is assembled in `Picard/Pic0ChartLocusIsOpen.lean`;
  its header carries a link-by-link status table.
* the division of labour below is honoured, with one correction to its *sizing*: DAT-C's
  half was budgeted as "the shifted-datum constructor".  Its **inverse** part is small and
  is landed (`BasicOpenCocycleDatum.invDatum`, `Picard/Pic0ChartShiftedDatum.lean`); its
  **mul/tensor** part is not.  ~~and it — not transports (i)/(ii) — is what still gates the
  openness.~~  **RETRACTED later the same day** (`a5da2f1a1`,
  `Picard/Pic0ChartTwistCollapse.lean`): the mul/tensor half never gated CHART-U(b).  The
  twist is ONE `thetaFamily` — `sigmaFamily` *is* a `thetaFamily` by definition and
  `thetaFamily` is multiplicative in its class, so Σ and `θᵐ` fuse in `CechPic` over the
  fixed base before any datum is extracted (`chartTwist_collapse`) — and in any case
  `exists_cechPicClass_eq` presents an arbitrary class, product or not, outright.  See
  `w4-datc` §0.3 GAP-1 for the full retraction and for why the error survived (a gate
  inferred from an absent NAME rather than from the obligation).  Transports (i)/(ii) reduce,
  given a presentation, to the landed `hasWitnessH1Vanishing_iff_of_separable` plus carrier
  bookkeeping — and that carrier bookkeeping is now landed too (`e6a7b0582`;
  `Pic0ChartLocusIsOpen.lean` is sorry-free).  ~~The one remaining input of the row is the
  pointwise `IsChartDatumPresentation`.~~  **Corrected: TWO inputs remain, and neither is
  bookkeeping** (issue I-0558): (i) **honesty over a general affine base** — the extraction
  corollary takes an honest Čech class over `B` as a *hypothesis*, and nothing in the tree
  supplies one, since the splitting theorem needs `[Field K]` (its engine is étale
  field-cofinality) and the only other plus-unit surjectivity is field-only too; obtaining it IS
  the (b-amendment)'s "collapse over the étale carrier" step, i.e. a construction; and (ii) the
  **pointwise `IsChartDatumPresentation`**, which wants one datum over `A` matching, at every
  residue field simultaneously, a split predicate whose splitting field varies point to point.
* **A SIGN ERROR IN THE CO-SIGNED BRICK, found by review and fixed 2026-07-28 (`8ef9493ff`,
  issue I-0514).**  `chartTwist` had applied the SAME twist as `chartValue` rather than its
  inverse, giving fibre degree `−g`; since `h¹ = 0` forces `deg ≥ g − 1`, `chartLocus` was
  **empty for every `g ≥ 1`**, so §1.2's COV-1 would have been *unprovable* against it rather
  than merely unproved.  Now `λ · θᵐ · Σ⁻¹`, degree `+g`, with the direction pinned by
  `chartTwist_chartValue` (a round-trip law, false of the old definition) rather than by a
  degree — the wrong-signed ledger was internally consistent, which is exactly why a ledger
  could not catch it.
* **a FOURTH input, prior to all three listed, had to be built first**: nothing in the tree
  converted a point of a general test into a field point at which a class could be read.
  That is `Over.testPoint` (`Picard/Pic0ChartTestPoint.lean`); see w4-datc §3.3 for the
  detail and for the affine-chart route that was tried and abandoned.

DAT-C froze `chartLocus c λ` and flagged CHART-U(b) as co-owned.  **DAT-B co-signs
the interface with these amendments** (to be acknowledged by the DAT-C lane before
either builds — this section is the coordination handle, the DDR9-U pattern):

* **(a-amendment) the predicate for arbitrary plus classes is the SPLIT form.**
  `t ∈ chartLocus c λ` iff for some (equivalently every) finite separable
  `L/κ(t)` splitting the collapsed plus class (§1.2 step 1), the honest `L`-class of
  `λ_t·θ^m·(Σ-shift)⁻¹` satisfies `h⁰ = 1 ∧ h¹ = 0` (dimension form; witness form
  equivalent per §1.2 preamble).  Well-definedness across splittings: E-iv-alg +
  `ClassCohomology.lean:111`.  For classes hit by `chartValue` this collapses to
  DAT-C's (V1a) reading, as their §3.3 asserts.
* **(b-amendment) the openness route of record** (replacing "étale-image descent has
  no landed avatar" with a pinned chain): reduce to affine `T' = Spec A` pieces
  (vehicle evaluation); collapse `λ|` to `PicEtAff.mk E x`; over the étale carrier
  `B := E.Carrier` the class is honest — extraction
  (`exists_cechPicClass_eq`, `Cohomology/GluedSheafExtraction.lean:301`) gives a
  cocycle datum, twisted into the `λθ^m(Σ-shift)⁻¹`-datum by the theta layer +
  DAT-C's GAP-1 inverse datum (their C0 file — the shifted-datum constructor is
  INSIDE the co-owned brick's scope; budget it there); RE-5
  (`exists_fg_isNoetherianRing_baseChange_eq`, `Cohomology/DatumDescent.lean:514`)
  descends it to a Noetherian stage `B₀`; the engine open fires there
  (`datumRigidEngine_isOpen_vanishing`, `Cohomology/GluedSheafEngine.lean:221`,
  Noetherian-free; pair↔fibre dictionary `Cohomology/GluedSheafFibre.lean:113/:123`
  + witness form `Cohomology/GluedSheafDatumFibre.lean:169`).  Then THREE transports,
  all point-set + field-dimension bookkeeping: (i) `Spec B → Spec B₀`: the locus over
  `B` is the PREIMAGE of the stage open (fibre classes pull back along
  `κ(p₀) → κ(p)`, `descent_cechPicClass` `DatumDescent.lean:525` + faithfully-flat
  dimension invariance); (ii) `Spec B → Spec A` étale: the locus over `A` is the
  IMAGE of the locus over `B` (the predicate is a fibre-field condition, invariant
  under the separable extensions `κ(q) → κ(p)`, and `Spec B → Spec A` is surjective
  — an étale cover), and étale maps are OPEN — this is the Kleiman tex 2204-2244
  step, now one `IsOpenMap` application; (iii) affine pieces glue by (V1c)-style
  locality.  Keystone: `isOpen_chartLocus`.
* Division of labour inside the brick: DAT-B owns (i)/(ii) (the descent/image
  transports — they are coverage-side bookkeeping); DAT-C owns the shifted-datum
  constructor + the (V1b)-style datum dictionary at the shifted class (their GAP-1/
  GAP-6 files).  One file each, one statement, no duplication (§4 rows B-4/C9).

### §1.7 (COV-4 = B-3) the field-dictionary `hsurj` completion — honest new work #3

The landed dictionary is conditional: `divFamFieldEquivOfDegOfSurj`
(`Picard/DivisorFamilyFieldEquiv.lean:199`) with `hdeg` DISCHARGED unconditionally
(`deg_divFamDivisor`, `Picard/DivisorFamilyFieldCRT.lean:376`) and `hsurj` half-done:
`exists_localEquations_presentationDivisor_eq`
(`Picard/DivisorFamilyBackward.lean:121`) realizes every effective `D` by a
`LocalEquations` product of tracked point equations; the docstring (`:113-119`) names
the residue: **the certified support-separated adaptation**.  Pin:

```
theorem exists_divFam_divFamDivisor_eq (D : (relCurve C K).CurveDivisor)
    (hD : 0 ≤ D) (hdeg : CurveDivisor.deg K D = (n : ℤ)) :
    ∃ F : DivFam C K π n, divFamDivisor F = D
```

Route: the point-equations product of `Backward.lean:121` + a support-separated
finite chart adaptation (each support point in a basic open of its pinned chart —
finitely many closed points, the `PointPresentation` tracking `Picard/
PointPresentation.lean:255`), whose certificate is the SEPARATED case landed as
`deg_divFamDivisor_of_separated` (`Picard/DivisorFamilyFieldDegree.lean:376-383`)
plus the field-level colength reading (`ChartColength` legs through the CRT kit,
`FieldCRT.lean:85-190` per w4-datc §3.4 row (c2)).  Corollaries, closing the row:
`divFamFieldEquiv` (unconditional), and **the DivScheme-point of an effective
degree-`g` class**: `DivFam.toZar` (`Picard/DivisorFamilyZar.lean:272`-region) +
`divRepClassifyZar` (`Picard/DivRepClassifyZar.lean:244`, LANDED I-0243) give
`overSpec k K ⟶ divSchemeOver!` — the §3.3 export.  Size M→L, launchable NOW.

---

## §2 Injectivity bookkeeping — the consumption map (nothing to build)

The node title's "injectivity from the separatedness lane" resolves into four landed
layers plus one DAT-C obligation; DAT-B's §2 deliverable is THIS TABLE (echoed in the
files' docstrings), not code:

| need | landed answer |
|---|---|
| the 01JJ engine's sheaf/separation input | `pic0SigmaFunctor_isSheaf` / `pic0SigmaSheaf` (`Picard/Pic0SigmaSheaf.lean:147`); beneath it `existsUnique_glue_of_le_cover` (`Picard/Pic0ZariskiSheaf.lean:246`), `pic0Subgroup_ext_of_le_cover` (`:263`), S-lemma `mem_pic0Subgroup_of_cover` (`:277`); affine half `PicEtAff.eq_of_away_eq` (`Picard/PicEtAffZariskiSep.lean:137`) |
| étale-level injectivity (C1) — why the plus construction is separated | `PicEtAff.unit_injective` (`Picard/EtaleSeparatedness.lean:16`), closed through `unit_injective_of_ker` (`Picard/EtaleSeparatednessClose.lean:193`) |
| chart-functor mono (uniqueness of the normalized representative) | DAT-C §3.2 (their C4 file; consumes GAP-2 + (N5); the relPic base-twist hazard is THEIRS, recorded w4-datc risk 3) |
| uniqueness of the classified morphism inside CHART-U(c) | `IsDivRepClassify` uniqueness layer (`Picard/DivRepClassifyZar.lean:90-206`: `divClassifyZar` ∃!, `divRepClassifyZar_eq_of_isDivRepClassify`, `isDivRepClassify_unique` — I-0243) |
| injectivity of the FINAL `homEquiv` | free: it is an `Equiv` produced by 01JJ (`representableBy`, mathlib `Sites/Representability.lean:192`) — never a separate obligation |

Guard (recorded): no DAT-B statement may re-derive separation through
representative-level `relPic` comparisons — the Hilbert-90-class trap of w4-datc
§3.2 lives entirely on the DAT-C side of the boundary; DAT-B touches classes only
through `degAt`/`picEtAffineEquiv`/dimension predicates.

---

## §3 What DAT-glue (and DAT-J, DAT-G) consume

### §3.1 The Stage-C handoff (frozen shapes)

DAT-glue's input is the triple `(f, hf, inst)` of §0.1 fed to
`pic0RepresentableByOfCharts` (`Picard/Pic0SigmaSheaf.lean:161`): `f`/`hf` from
DAT-C (their C9), `inst` = §1.1 from DAT-B (B-6).  The represented object's `.left`
is `(Scheme.LocalRepresentability.glueData hf).glued` and `.hom` the universal
element's Σ-component, both definitional (docstring `:153-160`); the lft certificate
of the chart family is per-chart: `VOver.left` is an open of `DivScheme!` whose
structure map inherits `locallyOfFiniteType_divSchemeOverHom`
(`Picard/DivSchemeQProj.lean:199`; bundle `DivQProjBundle`/`divQProj` `:221/:245`) —
consumed by DAT-glue directly, no DAT-B mediation.

### §3.2 The ε⁺ seam (DAT-J)

The glued object represents `pic0TypeFunctor` DIRECTLY (the chart values are already
degree-0 — w4-datc §4.2's ledger), so `representableByOfShift`
(`Picard/ThetaShift.lean:225`) is NOT consumed on this route at assembly time; it
remains DAT-J's tool if the final packaging prefers the layer spelling.  Record to
prevent double-shifting: `chartValue` (w4-datc §3.2) has the `θ^{-m}` shift INSIDE
it; the 01JJ output needs no further twist.

### §3.3 The qc/effectivity export (DAT-J's image argument; the dat-d §4.2 row)

```
theorem pic0_field_point_effective   -- shape; instantiated at the assembly level
    {K} [Field K] [Algebra k K] (lam : pic0Subgroup C (overSpec k K)) (c : ChartIndex C)
    (hmem : chartLocus-condition at the unique point) :
    ∃ v : overSpec k K ⟶ divSchemeOver!, chart-shifted class of v = lam
```

— every field point of the (chart-shifted) functor is in the image of `DivScheme`:
`h⁰ ≥ 1` at degree `g` is FREE (`χ = 1` and `h⁰ − h¹ = χ` at the fibre — the
rank-anchor reading; in particular the parent row's "class with `h⁰ ≥ 1`" is every
class), effective witness by `riemann_inequality` (`RiemannRoch/ChiLedger.lean:137`)
via `exists_effective_of_picClass` (`RiemannRoch/FLVClass.lean:208`), DivScheme-point
by B-3 (§1.7).  DAT-J composes with the Abel morphism (`rep.homEquiv.symm` of the
chart-shifted `abelDiv` family, w4-datc §4) and `compactSpace_divScheme`
(`Picard/DivSchemeQProj.lean:194`) to get `|J|` quasi-compact — image of qc is qc.
DAT-B delivers the theorem above; the image argument itself is DAT-J's.

### §3.4 The DAT-G0 flag (finite-level transfer — NOT DAT-B's)

Per §0.3: post-glue finite chart subfamily (topological, from `J`-qc) + spreading the
finite datum to a finite separable `k'` + descending the representing property
`K_s → k'` (fpqc-locality of the sheaf-iso `yoneda(J) ≅ pic0`-sheaf, or a
colimit/limit argument along `k' → K_s` in the RE-5 style).  Owned by the
DAT-glue/DAT-G worksheets; DAT-B's coverage statement is deliberately
level-parametric (generic base field, `[IsSepClosed]` only where §1.2 needs it) so
that whatever level DAT-G0 lands on, the statements instantiate without edits.

---

## §4 File plan, sizes, gates, lane order

Discipline inherited in full: private-index CAS commits
(`informal/protocol-concurrent-lanes.md` §1), root-import rule (§4 there), mkdir lake
mutex, ≤ 500 L, one heavy declaration per unit, `lean_verify` on keystones, axioms
exactly `[propext, Classical.choice, Quot.sound]`; the I-0236…I-0245 gotcha lists are
required reading (semireducible rw targets, `include … in`, pinned multipliers as
defs, maxRecDepth near window defeq, no two-level `letI` algebra towers).

| # | file (new) | contents | size | gated by | launchable |
|---|---|---|---|---|---|
| B-1 | `RiemannRoch/CoverageDrop.lean` | §1.4: the oracle-parametrized greedy drop `exists_effective_sub_h0_eq_one` + the exact-drop step lemma | M→L | none | **NOW** |
| B-2 | `Curve/SepPointsDense.lean` | §1.5: `dense_baseChange_rationalPoints` (DAT-P + singleton-fibre + tensor argument) | M | none | **NOW** |
| B-3 | `Picard/DivisorFamilyFieldSurj.lean` | §1.7: `exists_divFam_divFamDivisor_eq`, unconditional `divFamFieldEquiv`, the field DivScheme-point corollary | M→L | none (F4 landed) | **NOW** |
| B-4 | ~~`Picard/Pic0ChartLocusOpen.lean`~~ → **landed as `Pic0ChartLocus{,IsOpen,Split,TwistCollapse}.lean`** | §1.6: the split predicate (a-amendment) **DONE** (`IsSplitWitness`, plus the unconditional `exists_splitting_of_picEt`); `isOpen_chartLocus` assembled conditionally and now **sorry-free**; the twist collapse retracts the GAP-1 gate | M→L | ~~co-sign~~ **acknowledged**; ~~residue is DAT-C GAP-1's mul/tensor half~~ residue is the pointwise `IsChartDatumPresentation` ONLY | **partly done 2026-07-28** |
| B-5 | `Picard/Pic0Coverage.lean` | §1.2: `pic0_chartLocus_cover` (COV-1) at the `K_s` instantiation | M→L | B-1, B-2, ~~B-4(a-part)~~ **available**, DAT-C C5 (`chartValue`/`sigmaFamily` names — landed) | **NOW** — `chartLocus` exists, so the statement is expressible |
| B-6 | `Picard/Pic0CoverageSurj.lean` | §1.1 instance + §3.3 export + the §2 consumption-map docstring | M | B-4, B-5, DAT-C C9 (CHART-U(c) — gated on divRep F7 + CERT-Σ) | no |

Lane order under the memory constraint: B-1 ∥ B-2 ∥ B-3 (light, disjoint imports) →
[co-sign note] → B-4 → B-5 → [DAT-C C9 lands] → B-6.  **Three of six rows are
launchable cold today; five of six before divRep.**  B-6 is a bounded assembly the
day DAT-C's C9 lands (which itself waits on F7 + CERT-Σ).

---

## §5 Honest risks, ranked

1. **CHART-U(b) (medium-high, shared).**  Ranked first by DAT-C too (their risk 2).
   The chain §1.6(b) is pinned name-by-name, but the shifted-datum constructor
   (DAT-C's side) and the image-transport (our side) have no landed avatar; the
   étale-image step, though now a one-application `IsOpenMap`, sits atop the plus
   collapse + étale-carrier bookkeeping — the standing elaboration-weight profile.
   Mitigation: the co-sign freezes one statement; both lanes' halves are separately
   S/M-sized; the fibre-transport dictionary halves are landed
   (`GluedSheafFibre.lean:113/:123`, `GluedSheafDatumFibre.lean:105/:169`).
2. **The staging finding / DAT-G0 (high-impact coordination, externalized).**  §0.3
   corrects the parent's surface reading ("01JJ over a finite separable k'"): honest
   coverage lives at sep-closed level; the finite-level transfer is new debt at the
   DAT-glue/DAT-G boundary.  Risk: DAT-G's worksheet (unwritten) prices it high or
   the fpqc-locality argument grows.  Mitigation: the post-glue finite subfamily is
   genuinely topological (J-qc via §3.3 — all inputs landed or B-3); the flag is
   loud, early, and level-parametric statements keep DAT-B unaffected.  MUST be
   echoed to the orchestrator with the roadmap update.
3. **B-1's section/vanishing bookkeeping (medium).**  "Sections of `W − x` =
   sections of `W` vanishing at `x`" and the one-condition count at a rational
   point need the `divisorSections`/`ord`/`coeffAt` calculus run once more (the
   `BaseDivisor`/`SectionBound` kit is adjacent but window-flavoured).  Mitigation:
   pure field level; the PFib strict-drop proofs are line-by-line templates
   (`PFib.lean:71`, `CarveDegreePinch.lean:76`).
4. **B-2's reduced-chart argument (low-medium).**  Needs the chart-level
   `Γ(U) ⊗_k L` identification (`Over.sectionsBaseChange` — on the nose, landed) and
   integrality of the instantiated pack; the density induction is elementary.  Watch
   the `K_s`-point base-change spelling (`Over`-plumbing; keep it a named def with a
   characterizing lemma, the I-0243 pattern).
5. **B-3's CRT/support-separation bookkeeping (low-medium).**  The separated-case
   degree law is landed (`FieldDegree.lean:376`); the residue is assembling the
   adaptation with separation witnesses — Finset/basic-open bookkeeping of the
   recorded I-0193/I-0238 hazard class.
6. **Fibre-collapse plumbing in B-5 (medium).**  Step §1.2.1 (plus class → honest
   class over a finite separable `L`) composes `picEtAffineEquiv`, the `mk`-carrier,
   and étale field-cofinality — vocabulary from three lanes.  Mitigation: state the
   collapse ONCE as a named lemma with a characterizing property (input to the
   CHART-U(a) split form, so B-4 and B-5 share it); the DAT-4 collapse lemmas
   (`DegreeSeam.lean:67-107`) are the template.
7. **Scope guard (recorded to prevent creep).**  NOT DAT-B: the chart maps/`hf`
   certificates, mono, normalization, CERT-Σ (DAT-C); the 01JJ invocation, lft
   bundle, glueing (DAT-glue — landed seams); the ε⁺ shift (DAT-J); Galois descent +
   DAT-G0 (DAT-G/DAT-glue); any second openness mechanism (every open here is a
   `datumRigidEngine_isOpen_vanishing` instance through CHART-U(b) — dat-d §3.5
   binding); any `∀ n ≥ m` tail (parent §5.5 — the per-chart condition stays
   collapsed even though `m` ranges, §0.2.2).

*End of worksheet.  To echo to the orchestrator: the §0.2 route-arounds (1d-ii seam
not on DAT-B's path; m-strata do not collapse; no relative high-twist certificate),
the §0.3 staging decision + the DAT-G0 flag (new debt at the DAT-glue/DAT-G
boundary), the §1.6 CHART-U co-sign amendments (awaiting DAT-C lane acknowledgment),
and the §0.4 finding that the node's injectivity half is landed.  B-1/B-2/B-3 can be
handed to implementation lanes cold, today; B-4 the moment the co-sign note is
acknowledged; B-6 is the only divRep-gated row.*
