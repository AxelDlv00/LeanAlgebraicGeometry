# LeanAG — Scope Roadmap (condensed)

A high-level, mathematical checklist across the scope's member projects.

**Legend:** 
 * `- [x]` proved / sorry-free 
 * `- [~]` in progress 
 * `- [ ]` not started

**Status snapshot**:

| Project | Stage | Open `sorry` |
| --- | --- | --- |
| Algebraic-Jacobian-Challenge | prover | ~438  |
| Cech-Cohomology | ✅ polish | 0  |
| Line-Bundle-Comparison-Iso | prover | ~55 (6 seed lemmas) |
| Quot-Foundations | prover | ~43 |
| Related papers | scaffold | -  (blueprint only) |

---

## Dependency spine 


- `Line-Bundle-Comparison-Iso` → `Algebraic-Jacobian-Challenge` (largest leverage: unblocks the Picard substrate)
- `Cech-Cohomology` ↔ `Algebraic-Jacobian-Challenge` (the Čech engine is the cohomological substrate; already proved here)
- `Quot-Foundations` → `MR4213770`
- `Algebraic-Jacobian-Challenge` → `MR4228499`, `MR4213770`
- `MR4199442`, `MR4213770`, `MR4228499` → `MR4665779`

---

## Algebraic-Jacobian-Challenge  *(core engine — prover stage)*

**Goal:** the Jacobian of a smooth proper geometrically-irreducible curve — smooth of
relative dimension = genus, proper, geometrically irreducible, and the Albanese variety
(`exists_unique_ofCurve_comp`). Spine = pointed vs. unpointed; 0 project axioms.

- [~] **Presheaf-of-modules infrastructure** — restrict/extend-scalars monoidal structure, pushforward/pullback adjunctions, internal hom, stalk-tensor machinery
- [~] **Picard group construction** — tensor unitors → `picSetoid/picMul/picInv` → `PicGroup`/`picCommGroup` *(once tensor unitors proven)*
- [~] **Invertible sheaves & line bundles** — local triviality, pullback-tensor compatibility; line-bundle coherence substrate **done**
- [~] **Tensor/dual comparison substrate (A.1.c.sub)** — slice-dual transport iso, `sheafificationCompPullback` cancellation *(shared with Line-Bundle-Comparison-Iso)*
- [ ] **Group schemes** — `Ga`, `Gm`, `ProjectiveLineBar` (ℙ¹), identity component, `Pic⁰` is an abelian variety *(Gm/Ga once `ProjectiveLineBar` proven)*
- [~] **Weil divisors & rational maps** — order valuation, degree homomorphism, principal divisors, positive part
- [~] **Regular stalks & Kähler differentials** — standard-smooth ⇒ Krull dim, cotangent iso, stage-6 regular-stalk assembly
- [~] **Euler characteristic / Riemann–Roch core** — flasque acyclicity, skyscraper SES, `h⁰ − h¹ = 2` at a closed point
- [~] **Čech higher-direct-image engine (A.2.c)** — `pushPull` functoriality (`pushPullMap_id` landed); `pushPullMap_comp` blocked on a kernel `eqToHom` transport
- [~] **Flatness & generic flatness** — algebraic generic flatness (Nitsure §4) → flat-locus open → Noetherian stratification
- [ ] **Smooth proper curves** — projectivity, normalization iso, function-field equivalence *(held: classically RR-dependent; Route C paused)*
- [ ] **Top goal: `Pic_{C/k}` representability + Jacobian = Albanese** *(once the substrate + engine themes close)*

## Cech-Cohomology  *(polish stage — effectively complete)*

**Goal:** `cech_computes_higherDirectImage` — for a separated quasi-compact `f : X ⟶ S`,
a quasi-coherent `F`, and a finite affine open cover, the cohomology of the relative Čech
complex computes `Rⁱf_* F`. Unconditional (no enough-injectives appeal).

- [x] **Combinatorial / free Čech engine** — alternating coface complex, homotopy contraction, exactness
- [x] **Section Čech complex & localization comparison** — `AwayComparison`, `phi/phiL` naturality
- [x] **Affine acyclicity (Serre vanishing)** — tilde-vanishing ⇒ affine Čech vanishing
- [x] **Cover/nerve combinatorics** — Čech nerve, wide pullbacks, `pushPull` sigma iso, finitary-extensive distributivity
- [x] **Quasi-coherence on opens** — over-equivalences, restrict-to-basic-open, modules-over-opens equivalence
- [x] **Higher direct image & acyclicity** — injective resolutions, horseshoe lemma, pushforward acyclicity
- [x] **PushPull functoriality** — `pushPullMap` composition, leg coherence, pentagon
- [x] **Comparison theorem `cech_computes_higherDirectImage`** *(proved iter-079, 0 sorries)*

## Line-Bundle-Comparison-Iso  *(prover stage — extraction hub → Jacobian)*

**Goal:** the comparison-isomorphism substrate giving `Pic♯_{C/k}` its abelian-group
structure (the A.1.c.sub package; merges back into the Jacobian challenge).

- [~] **Tensor unitors** (left/right) — foundational
- [~] **Slice-dual transport iso (DUAL route)** — `sliceDualTransport(Inv)` naturality + round-trips → `dual_isLocallyTrivial`
- [~] **Pullback-tensor comparison (D3′ route)** — `sheafifyTensorUnitIso_comp`, `pullbackValIso_comp`, `pullbackTensorMap_restrict`
- [ ] **`pullbackTensorIsoOfLocallyTrivial`** (seed) *(once D3′ route closes)*
- [ ] **Picard group** `PicGroup` / `picCommGroup` *(once tensor unitors proven)*
- [ ] **`PicSharp.addCommGroup_via_tensorObj`** (consumer seed) *(once dual + tensor routes close)*

## Quot-Foundations  *(prover stage)*

**Goal:** the Čech-independent (i = 0) leg of FGA Picard representability — flat base
change, generic flatness, and Quot/Grassmannian foundations.

- [~] **Flat base change (degree 0)** — `baseChangeGammaPullbackEquiv`; pushforward Mayer–Vietoris / finite-generation criteria
- [~] **Generic flatness** — `genericFlatness` and the flat-locus chain *(shared root with the Jacobian engine)*
- [x] **Grassmannian construction** — rank-quotient setoid, charts, transition cocycle, gluing (`isIso_glueRestrictionHom` keystone closed)
- [~] **Universal / tautological quotient** — `represents` done; `tautologicalQuotient_epi` closing *(once gluing proven — done)*
- [~] **Matrix-endomorphism algebra** — `scalarEnd`/`matrixEnd`, free-module iso
- [~] **Relative tensor coequalizer**
- [~] **Graded section ring/module** — `sectionGradedRing/Module`, cast coherence (SNAP) → Hilbert polynomial *(χ-semantic; Hilbert-poly node owned by the sibling cohomology leg)*
- [ ] **RelativeSpec `RepresentableBy` upgrade** + Quot-representability core *(once SNAP-S0 + RelativeSpec land)*

## Downstream papers  *(scaffold stage — blueprint written, Lean formalization not begun)*

Each is a blueprint scaffold building toward the paper's main theorem; depends on the
algebraic-geometry base above.

### MR4199442 — Standard conjectures for abelian fourfolds *(7 blueprint chapters)*
- [ ] **Motives & realizations** — Chow/numerical motives, classical + Hyodo–Kato realizations, filtered φ-modules
- [ ] **CM & exotic decomposition** — CM structure, Honda–Tate lifting, exotic Frobenius relations
- [ ] **Period norms & local quadratic forms** — Hilbert symbols, ramified/unramified period dimensions, norm criterion
- [ ] **Main theorem** — standard conjecture of Hodge type for abelian fourfolds; Clozel ⇒ num = ℓ-adic hom *(once the above close)*

### MR4213770 — Universal secant bundles & syzygies *(2 blueprint chapters)*  ·  needs Jacobian + Quot
- [ ] **Universal secant bundles** — universal zero locus, secant bundles, local-freeness
- [ ] **Even-genus Voisin vanishing** — kernel-bundle reduction → even secant vanishing → `EvenVoisin`
- [ ] **Odd-genus Green** — projective-bundle model, multiplicity vanishings → `OddVoisin`, `GreenOddMain`
- [ ] **Geometric syzygy conjecture (even genus)** *(once even/odd Voisin close)*

### MR4228499 — Bounds for stalks of perverse sheaves *(5 blueprint chapters)*  ·  needs Jacobian + Čech
- [ ] **Singular support & characteristic cycle** — `singularSupport`, `characteristicCycle`, transversality
- [ ] **Index & polar-multiplicity formulas** — nearby/vanishing cycles, polar multiplicity, intersection comparison
- [ ] **Massey-type stalk bound** — `first_Massey`, global polar bound
- [ ] **Betti-number bound (Shende–Tsimerman)** — `theta_betti_bound`, equidistribution *(once the formulas close)*

### MR4665779 — Chabauty–Coleman bound for surfaces *(1 blueprint chapter)*  ·  needs MR4199442 + MR4213770 + MR4228499
- [ ] **Geometry interfaces & packages** — abelian-variety degrees, curve singularities, general-type package
- [ ] **One-parameter subgroups & local integrals** — log/exp linearization, `OmegaIntegral`, residue-disk bounds
- [ ] **Main local `Q_p` bound** — `MainLocal`, `MainQp`, number-field bound
- [ ] **Quadratic-points application** — symmetric-square embedding, `QuadraticPoints` *(once the local bound closes)*