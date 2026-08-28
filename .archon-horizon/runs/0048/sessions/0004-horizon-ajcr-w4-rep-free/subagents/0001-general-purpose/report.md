## Verdicts

Every file path below is relative to `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`.

---

### CLAIM A — **CONFIRMED (mathematically), but PARTIALLY-WRONG on status and on two details**

The mathematics is right. `F = sX₀² + X₀X₁ + sX₁²` over `k[s]`: coefficient `1` on `X₀X₁` ⇒ nonzero on every fibre ⇒ `Z(F)` finite flat of degree 2 over `𝔸¹`; `F|_{X₀=0} = sX₁²`, `F|_{X₁=0} = sX₀²` ⇒ meets `Θ_{[0:1]}` and `Θ_{[1:0]}` exactly at `s=0`; in the chart `X₁=1`, `s(x²+1)+x` is degree 1 in `s` with content `gcd(x²+1,x)=1` ⇒ irreducible over **any** field. So the "k infinite" hypothesis in Claim A is **superfluous** — the counterexample works over `𝔽₂`. That matters, because it kills the "just assume k infinite" escape at the same time it kills chart-avoidance.

Corrections:

1. **Not new.** The exact example is already in the tree as the model in the docstring of `not_forall_supportLeak_eq_empty_of_isPreconnected`, `AlgebraicJacobian/Picard/DivSchemeCertZarConn.lean:170-175`: *"the degree-two relative divisor `V(t x² + x y + t y²) ⊆ ℙ¹` over `k[t]` … whose fibre at `t = 0` is `{0, ∞}`."* The prompt's NOTE mischaracterizes the prior session: the `Spec(R[x]/(x²−t))` example in `informal/spec-dd-r.md:461-463` is deployed there for a *different* purpose (localization does not disconnect), for which it is adequate. So the NOTE's premise is wrong but harmless.
2. **Not a Lean fact.** Nothing instantiates it. `not_isCertified_of_isPreconnected_of_witnesses` (`DivSchemeCertZarVerdict.lean:62`) and its `DivEq`-class version `not_isCertified_of_divEq_of_isPreconnected_of_witnesses` (`DivSchemeCertZarConfine.lean:182`) are conditional theorems; no declaration exhibits a `d` satisfying their hypotheses. "Settled" is a paper argument, not a kernel-checked one. The three transport bricks needed to make it one **are** landed: `supportLocus_pullback` (`DivSchemeCertZarTransport.lean:81`), `DivEq.supportLocus_eq` (`DivSchemeCertZarConfine.lean:107`), `IsLocallyCertified` unfolds to a span-⊤ family of `Localization.Away (g i)` (`DivisorFamilyZar.lean:71`), and every open cover of `Spec k[s]` has a member containing `s=0`. Building the concrete `LocalEquations` on `relCurve (P1.asOver k) k[s]` and proving irreducibility of its support is the (substantial, ~500-line) missing work.
3. **Preconnectedness is not needed.** The sharper landed route: `supportLeak_eq_empty_of_finite_colength` (`DivSchemeCertZarC1.lean:105`) + `isClosed_supportLocus_inter_chart₀_of_forall_supportLeak_eq_empty` (`DivSchemeCertZarChartTrace.lean:106`) gives `IsCertified n ⇒ supp ∩ V₀` and `supp ∩ V₁` **both closed**, with no connectivity hypothesis. For the example, `D ∩ V₀ = D ∖ {([0:1], s=0)}` is dense-not-closed in the irreducible `D`. The composite is a 2-line lemma that is *not* landed; it should be, since it is the strongest form of the obstruction.

Typeclass side of the instantiation is clean: `IsProper (P1.asOver k).hom` (`AlgebraicJacobian/Curve/P1.lean:186`), `IsFinite (𝟙 _)` from mathlib `ContainsIdentities @IsFinite` / `[IsIso f] : IsFinite f` (`Mathlib/AlgebraicGeometry/Morphisms/Finite.lean:61,75`).

---

### CLAIM B — **PARTIALLY-WRONG** (right conclusion, wrong identification of the binding constraint)

The true constraint chain is finer, and there are **two** independent constraints, not one:

* **(β1) Per-piece.** `(c1)-finite ⟺ leak-free` (`DivSchemeCertZarC1.lean:123`) ⇒ each piece trace is clopen in the support ⇒ for connected support, each piece **swallows or misses** (`DivSchemeCertZarConn.lean:97`). Since the pieces cover the curve, a nonempty connected support lies **inside a single piece**. This has nothing to do with the pinned charts: *any* cover by opens imposes it. So the constraint survives every reshaping of `FinCoverData`.
* **(β2) Chart-wise covering.** `FinCoverData.partition₀/partition₁` (`DivisorFamily.lean:174,176`) force the chart-0 pieces to cover *all of* `V₀` and the chart-1 pieces *all of* `V₁` (`cover₀`/`cover₁`, `:199,204`). Combined with (β1): every chart-1 piece must swallow or miss, so either `supp ⊆ V₁` or `supp ∩ V₁ = ∅`. Hence certifiability forces `supp ⊆ V₀ ⊓ V₁` **or** `supp` inside one vertical fibre (`subset_chart₀_or_disjoint_chart₀`, `DivSchemeCertZarSwallow.lean:156`).

Consequences for the claim as stated:
* "SOLELY `FinCoverData` forcing pieces into `V₀`/`V₁`" — the pinned-chart restriction converts (β1)'s *one piece* into *one chart*; that part is right. But if you only relaxed the chart-wise covering (β2) to a joint `⨆ pieces = ⊤`, the requirement would drop from **avoid two points** to **avoid one point** — a strictly cheaper design that Claim B does not consider. It still cannot be dropped to zero, by (β1).
* "no repair that keeps pieces inside the two fixed pinned charts can work" — **CONFIRMED**, and the sharp version is: no repair keeping pieces inside the preimages of a *fixed pair of points of ℙ¹* can work. That is exactly why moving the points (Claim C) is the only structural way out.

---

### CLAIM C — genericity **CONFIRMED**; "costs NOTHING" **REFUTED**

Genericity, verified exhaustively: the *only* constraints ever imposed on `π` anywhere in `Picard/`, `RiemannRoch/`, `Cohomology/` are `[IsFinite π]` (286 occurrences), `[IsDominant π]` (176), `[IsAffineHom π]` (75), plus the propositional triangle `hπ : π ≫ P1.structureMap k = …` (148). No flatness, separability, degree bound, `Module.Free`. Representative: `RiemannRoch/WindowLedger.lean:94-102`. `windowBound` is `(exists_bound_… π hπ).choose` (`WindowLedger.lean:109`) — a function of `(π, hπ)` only; `thetaUnit` (`RiemannRoch/ThetaSections.lean:70`) and `FiberTwist.lean:79-127` impose *no* typeclass on `π` at all. All three properties and `hπ` are stable under `π ↦ π ≫ γ` for `γ` an iso over `k`. Decisively: **`DivScheme` is π-free** — `DivScheme k A B g r₁ r₂ b₁ b₂` (`Picard/DivScheme.lean:144`) takes two abstract `X.CurveDivisor`s; `π` enters only at the instantiation `A := windowS_choice π hπ g • fiberWeilDivisor π` (`Picard/DivSchemeSeedUniv.lean:138-143`). The only `Classical.choose`-pinned `π` in the repo is `thetaP1` (`Picard/ThetaShift.lean:251`), which lives on `(C ⊗ overSpec k k).left` and is consumed only through the integer `classDeg k (thetaCechClass C)` (`DivSchemeAbel.lean:354,373,385`) — harmless.

What refutes "costs nothing":

* **`γ` does not exist and cannot be cited.** There is no automorphism, coordinate change, PGL₂/GL₂ action, or even a coordinate *swap* of `P1 k` anywhere: the only morphism out of `P1 k` in the entire project is `P1.structureMap` (`Curve/P1.lean:170`). Mathlib supplies the raw material — `AlgebraicGeometry.Proj.map` with `map_comp`/`map_id` (`Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Functor.lean:144,204,211`), `GradedRingHom` (`Mathlib/RingTheory/GradedAlgebra/RingHom.lean:46`) — but there is **no `Proj.mapIso`/`IsIso` wrapper in mathlib either**, so `γ`, `IsIso γ`, and `γ ≫ P1.structureMap k = P1.structureMap k` are all new work (graded `aeval` of a linear substitution + irrelevant-ideal side condition + `map_id`/`map_comp` to get `IsIso`). Estimate: a new file, non-trivial.
* **There are no ℙ¹ rational points either.** `Curve/P1Points.lean` contains no `Spec k ⟶ P1 k`. The nearest thing is `P1.fromSpecChart k ρ i a` (`P1Points.lean:201`, `[1:a]` for `i=0`), never instantiated at `A := k`. `exists_mem_chartOpen_zero_notMem_one` (`RiemannRoch/FLVClass.lean:132`) *looks* like "the point `[1:0]`" but its proof picks an arbitrary maximal ideal (`:146-158`) and carries no residue-degree information — useless for counting avoidable points.
* **The predicate change is not local to one definition** — see the cost list below.

---

### CLAIM D — **PARTIALLY-WRONG**, with three independent defects

What is genuinely landed and free, as claimed:
* properness of the relative curve over an arbitrary test ring: `instIsProperRelCurveHom` (`Picard/SupportTube.lean:194`), needing only `[IsProper C.hom]` from the standing pack (`:179-180`);
* the closed-image/spread-out step: `exists_supportTube` (`SupportTube.lean:166`), already specialized to the chart overlap as `exists_opens_supportLocus_subset_chartInter` (`DivSchemeCertZarConfine.lean:133`), with openness of the confinement locus `isOpen_setOf_fibre_subset_chartInter` (`:151`). Claim D's topological half is done.

Defects:

1. **One point is not enough — you must avoid two.** The landed clause-(c1) discharge `forall_finite_colength_of_pieces_eq_chart` requires `hsub : supportLocus ⊆ V₀ ⊓ V₁` (`DivSchemeCertZarChartPair.lean:187`, via `:154`), not `⊆ V₀`. Claim D's "confined to the single affine chart `π⁻¹(ℙ¹∖{c})`" does not feed it. This is forced (β2 above) and was already flagged by the prior Ground review (`.archon-horizon/runs/0048/sessions/0002-horizon-ajcr-w4-rep-free/subagents/0003-ground/report.md:77`). The whole landed apparatus for the sufficient side is stated at `V₀ ⊓ V₁` (`Confine.lean:133,151`), which is the honest target.
2. **"supportLocus finite over the base" is not available and is not implied by anything.** A `LocalEquations` only requires germ-regularity (`SupportTube.lean:101,131`); `d.eqn ≡ r` for a non-unit `r ∈ R` is regular and has `supportLocus ⊇` a whole fibre `C_s`. Then *no* `γ` avoids it. So the repaired predicate still needs the geometric input "the support meets no fibre curve in its entirety", i.e. fibrewise-finite support. It is not circular (it is true for honest relative Cartier divisors and follows *a posteriori* from (c1)), but it is unproved for the DD-R seed and is precisely the input `informal/spec-dd-r.md:360` (Discipline (2)) forbids writing as a hypothesis. **The repair relocates the geometric input; it does not remove it.**
3. **`ofChartPair` is the wrong constructor for the general case.** It requires chart principality — one member of `d.cover` containing the *whole* pinned chart, with a comparison unit (`ofChartPair`, `DivSchemeCertZarChartPair.lean:116-127`). For the seed's own family `D ∈ |mΘ|` this is true (`O(mΘ)` is trivial on `V₀`, and `Θ ~ Θ'` since all points of ℙ¹ are linearly equivalent, so it is trivial on `V₁` too). For an **arbitrary** degree-`n` divisor on a curve of genus ≥ 1 it is false: `Cl(V_b) = Cl(C)/⟨components of π⁻¹(c_b)⟩` is nonzero, so `D|_{V_b}` need not be principal — and shrinking `Spec R` does not change a fibre class. The docstring's licence *"The pointwise gate licenses shrinking the base before asking for it"* (`DivSchemeCertZarChartPair.lean:44-47`) is therefore **wrong** for the backward (classify-an-arbitrary-family) direction. The correct adaptation is the roadmap's `swallow-adapt` shape (`D(σ_b)` swallowing + comaximal `D(τ_b)` with unit equation, `σ_b + τ_b = 1`), which additionally needs "`D` is principal on some open containing its support, inside one member of `d.cover`" — a real theorem (base-point-freeness of `|D + mΘ|`, plus a spread-out over a **non-Noetherian** arbitrary test ring `R`).
4. **`k` infinite is inadmissible.** There is not a single hypothesis on `k` stronger than `[Field k]` anywhere in `Picard/` or `RiemannRoch/` (exhaustive: 510 `Field k`, zero `IsAlgClosed`/`Infinite`/`IsSepClosed`/`PerfectField`). `Challenge.lean:57-63` and `Curve (k : Type u) [Field k]` (`:66-73`), and `Jacobian` (`:96-99`), are over an arbitrary field. The repair needs, at every base point, two `k`-rational points of ℙ¹ off `π(supp_s)` — i.e. `|ℙ¹(k)| = q+1 ≥ n+2`. For `k = 𝔽_q` with `q` small and `n ≳ 2g` this fails, and by the strengthened Claim A the obstruction is *real* over `𝔽₂`. The obvious workaround (a closed point of degree `d ≥ 2`) destroys the two facts the whole design rests on: `Γ(P1 k, chartOpen k i) ≃+* Polynomial k` (`Curve/P1Charts.lean:234,239`) and `isPrincipalIdealRing_chartSections` (`Curve/P1Points.lean:64`) — `Cl(ℙ¹∖{c}) = ℤ/d ≠ 0`. So finite fields are a genuine hole in the repair, not a footnote.

---

## The single strongest objection to the overall thesis

**The repair is not a repair of the interface; it is a re-labelling of the same unproved geometric input, and the re-labelled input is false over small finite fields where the challenge still demands a Jacobian.** Concretely: `IsCertified` demands the divisor sit inside one *piece*; pieces live in preimages of two points of ℙ¹; therefore the functor can only ever see divisors that avoid two `k`-rational points of ℙ¹, for *some* choice of the two. Quantifying over `γ` makes that choice free, but (a) you must still prove, for the family you care about, that its support is fibrewise finite and avoids two rational points — the forbidden `chart-avoid` input in a new costume; (b) over `𝔽_q` with `q+1 < n+2` no such pair exists, and Claim A's counterexample is field-independent; (c) `Challenge.lean:96-99` fixes `[Field k]` with no size hypothesis. So the thesis's "positively for a cheap repair" is not established: the *negative* half (A/B) is solid, the *positive* half is a plan with three unpriced items and one hard blocker.

---

## What makes the repair more expensive than claimed (declarations that must actually change)

New construction (nothing exists):
* `γ : P1 k ≅ P1 k` over `k` from `GL₂(k)`: graded `aeval` linear substitution → `𝒜 →+*ᵍ 𝒜` → `AlgebraicGeometry.Proj.map` (`Mathlib/.../ProjectiveSpectrum/Functor.lean:144`), `IsIso` via `map_id`/`map_comp` (`:204,211`), plus `γ ≫ P1.structureMap k = P1.structureMap k`.
* ℙ¹ `k`-rational points and a counting lemma (`P1.fromSpecChart k (𝟙 _) 0 a`, `Curve/P1Points.lean:201`), plus "a `k`-point of ℙ¹ stays a distinct point of `ℙ¹_{κ(s)}`".

Predicate layer (signature-changing):
* `IsLocallyCertified` (`Picard/DivisorFamilyZar.lean:71`) and, in the same file, `IsLocallyCertified.of_divEq:86`, `CertifiedDivisorFamily.isLocallyCertified:103`, `IsLocallyCertified.germ_pullbackEqn_mem_nonZeroDivisors:126`, `DivFamZar:225`, `mk:242`, `picClass:255`.
* `IsLocallyCertified.pullback` (`Picard/DivisorFamilyZarMapAlg.lean:111`).
* The 24 files that mention `DivFamZar`/`IsLocallyCertified`: `DivisorFamilyZar{,Kit,MapAlg,MapKit,Map,Sheaf,Vehicle,GlueKit,Glue}.lean`, `DivRepAffKit{,Zar}.lean`, `DivRepClassifyZar{,Kit,Compat}.lean`, `DivSchemeCertZar{Seed,Pointwise,Tube,C1,Confine}.lean`, `DivSchemeAbel.lean`, `DivSchemeMono.lean`, `DivisorDatumRankOne.lean`, `DivisorFamilyEpsNaturality.lean`, `DivisorFamilyH1Locus.lean`.

Mathematics still owed (the expensive part):
* fibrewise-finite support for the seed family (should follow from the window's fibre exactness — unproved);
* the `swallow-adapt` adaptation (`σ_b + τ_b = 1`) **replacing** `ofChartPair`, plus "principal on a neighbourhood of the support inside one cover member" over a non-Noetherian test ring;
* clauses (c2)/(c3)/(c4): still gated on `hspan` (kernel spanning, the blocked `away-kerspan`) and `hdeg` — see the real assembler signature `divisorAdaptation_isCertified_of_noLeak_kernel_spanning_degree` (`Picard/DivSchemeCertSeed.lean:59-79`). The `cert-collapse` conjecture that they become free is not landed.

Not a cost: the atlas. Because `DivScheme` is π-free (`DivScheme.lean:144`), the γ-family gives the *same* construction at different divisor inputs `A_γ = windowS_choice (π≫γ) … • fiberWeilDivisor (π≫γ)`; the classifying map into a *fixed* `DivScheme` can still be built from a high window, so no gluing over `γ` is needed for the representing object — only for the predicate. This is the one place the thesis is cheaper than it looks.

---

## Corrected plan

1. **Land the sharp obstruction first (cheap, high value):** `IsCertified n → IsClosed (supp ∩ V₀) ∧ IsClosed (supp ∩ V₁)` — two lines from `DivSchemeCertZarC1.lean:105` + `DivSchemeCertZarChartTrace.lean:106,116`. It needs no preconnectedness and is the honest statement of the design failure. Then, if a Lean witness is wanted, instantiate `C = P1.asOver k`, `π = 𝟙`, `R = k[s]`, `F = sX₀² + X₀X₁ + sX₁²` and refute `IsLocallyCertified` via `supportLocus_pullback` (`Transport:81`) + `DivEq.supportLocus_eq` (`Confine:107`) + `not_isCertified_of_divEq_of_isPreconnected_of_witnesses` (`Confine:182`).
2. **Fix the target of the avoidance:** the design condition is `supp ⊆ V₀ ⊓ V₁` (two points), not one chart. Everything landed on the sufficient side (`Confine:133,151`; `ChartPair:154,187`) is already stated that way; the roadmap leaf `chart-avoid` and Claim D must be restated to match.
3. **Consider relaxing (β2) before building PGL₂.** Replacing `FinCoverData`'s two chart-wise partitions of unity (`DivisorFamily.lean:174,176`) by a single joint covering condition `⨆ pieces = ⊤` halves the requirement (avoid **one** point, not two) and is a small, local edit to `DivisorFamily.lean` + `DivSchemeCertZarChartTrace.lean:80,92`. Check first whether `Cohomology/GluedSheafEngine.lean:78,85,89` (which consumes `partition₀/₁` as `Ideal.span_range_eq_top`) really needs chart-wise spans.
4. **Then build `γ`** as above and quantify `IsLocallyCertified` over it. Prove the avoidance lemma in the form: fibrewise-finite support + `|ℙ¹(k)| ≥ n+2` ⇒ `∃ γ` with `supp_s ⊆ V₀^γ ⊓ V₁^γ`, then spread out with `Confine:133`.
5. **Decide the finite-field question explicitly before step 4.** Either (a) accept a `q + 1 ≥ n + 2` hypothesis and record that `Challenge.lean:96-99` is then unreachable for small `q` — i.e. the challenge is not solved; or (b) plan a descent lane (the `divQProj` quasi-projectivity certificate, `Picard/DivSchemeQProj.lean`, is the right lever for fpqc descent from `k'/k`); or (c) generalize the pinned charts to complements of degree-`d` closed points, which costs `Curve/P1Charts.lean:234,239` and `Curve/P1Points.lean:64` and all the `Γ ≅ k[t]` machinery. This is the decision that should go back to the human, not "chart-avoid: yes/no".
