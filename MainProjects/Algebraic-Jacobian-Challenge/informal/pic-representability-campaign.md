<!-- Campaign plan for instHasPicScheme — synthesized 2026-07-09 by the run-0019 recon+design workflow (4 recon agents, 3 designs, judge). Route decision: D3 Milne–Kollár (section trick + finite Galois quotient + coproduct assembly), grafts from D1/D2. Wave tracking lives in T16 comments. -->
# FINAL — Campaign plan for `instHasPicScheme` (judge + synthesis, 2026-07-09)

> **This document is the route of record.** The blueprint chapter
> `Picard_FGAPicRepresentability.tex` and the roadmap cone `AJC.picrep` were
> re-aimed at the D3 Milne–Kollár route selected here (run 0054); the Quot
> endgame they previously described in the present tense is retained as
> mathematics but is not the path being built. The Quot-lane leaves listed under
> "Off-path and untouched" at the end of Part II remain off-path.
>
> **Two things this plan does not settle.**
>
> 1. *The rational point.* Every milestone below keeps `[HasRationalPoint C]` as
>    an honest hypothesis, which makes the resulting theorem strictly weaker than
>    the challenge statement — a smooth proper geometrically integral curve need
>    not have a `k`-rational point. The alternative is to étale-sheafify the
>    Picard functor and drop the hypothesis, which is Kleiman's own formulation
>    and needs no section precisely because sheafifying supplies étale-locally
>    what the section would supply globally. Mathlib v4.31 does carry the étale
>    topology, so this is a design decision, not a platform limitation. Open with
>    the human as inbox `I-0372`, roadmap node `AJC.picrep.rational-point`.
>    Neither branch is assumed anywhere in this plan.
>
>    The scope of this decision narrowed on 2026-07-27, and it is worth being
>    precise about what remains. The headline leaf used to assert the rational
>    point *and* geometric integrality together. Geometric integrality of a smooth
>    proper geometrically irreducible curve is not a decision at all: it follows
>    from `Smooth ⇒ GeometricallyReduced`, now proved in mathlib generality at
>    `AlgebraicJacobian/Curve/GeometricallyReduced.lean`, so `[GeometricallyIntegral
>    C.hom]` in the target statement above is *free* given the challenge
>    hypotheses. What the owner must decide is only the rational point, and that
>    half is genuinely false in general rather than merely unproved.
>
>    It narrowed again on 2026-07-28, in a direction that bounds the decision
>    rather than settling it. Over an algebraically closed field the rational
>    point is a *theorem*, not a decision:
>    `hasRationalPoint_of_curve_of_isAlgClosed` (`Jacobian.lean`) is axiom-clean,
>    routed through `Albanese.hasRationalPoint_of_isAlgClosed`, and
>    `picardJacobianWitnessOfIsAlgClosed` assembles the headline witness over `k̄`
>    on four obligations instead of five. So the branch point is exactly about
>    what is claimed over an *arbitrary* base field. Neither branch is chosen, and
>    nothing below assumes one; what is now settled is that the general-field leaf
>    is the only place the decision bites.
> 2. *Cluster P's provenance.* Cluster P (χ-ledger, section drops, uniform `H¹`
>    vanishing) is the longest pole, and the sibling
>    `Algebraic-Jacobian-Challenge-Rebuild` carries a large sorry-free
>    `RiemannRoch/` development covering much of it. Whether each statement is
>    reused, ported, adapted or rederived is being decided theorem by theorem;
>    the milestones below assume none of it has landed.
>
> **Axiom frontier.** `scripts/axiom-frontier.lean` (run with `lake env lean`)
> is the reproducible check that a milestone claimed clean actually is, and it is
> also the record of what such a check *cannot* establish. A clean axiom set means
> exactly one thing: no `sorry` is reachable from that proof term. Five separate
> ways a milestone can still be short of unconditional mathematics have each been
> measured in this tree (the first five listed under "Gate-table status" below):
>
> - `#print axioms` on a theorem that *quantifies over* a gate reports clean axioms
>   regardless, because the hypothesis is discharged by the caller — measure at a
>   call site where the instance is synthesised.
> - A named hypothesis in the *statement* that is unproved is invisible to the
>   check. Several cluster-P results are clean in exactly this way: they carry the
>   closed χ-ledger or a peel-surjectivity datum as a hypothesis.
> - A named hypothesis that is *false* is worse: the theorem is then vacuously true
>   and reports clean axioms like any other. This is not hypothetical — it happened
>   to a leaf of the rigid-pushforward gate, whose consumers were vacuous until the
>   leaf was restated.
> - An *instance binder* nothing can instantiate for the ambient object actually
>   used reads as unconditional at the call site and is equally invisible; an
>   instance for a more structured cousin does not count. This cost a claimed
>   discharge in the Riemann–Roch lane (retracted).
> - An *unrooted* module is not probed at all: `import AlgebraicJacobian` never
>   reaches it, so no `#print axioms` line for it can even be written.
>
> A sixth way, found after the other five and worse than any of them, is recorded
> under "Gate-table status": an *instance diamond* that re-pins a definition's
> meaning survives both a clean axiom line and an instantiability probe, because
> the binders do synthesise — just to the wrong instance.
>
> A seventh, found 2026-07-28 and the hardest to defend against, is a hypothesis
> the project can **refute**. Not "false as stated", which someone must notice,
> but false *derivably from declarations already in the tree*, so the project
> proves `H → C` and `¬H` at every instance anyone would use. The theorem is then
> true, axiom-clean, consistent, instantiable, non-vacuous by the trap-(c) test,
> and empty. Measured on `chi_eq_of_bump`'s `hbump` in
> `RiemannRoch/Adelic/LedgerClosure.lean`, which is refutable at every prime
> outside the affine cover's overlap (I-0449, lesson I-0451; the catalogue entry
> with the machine-checked step is §2b of the probe). The check that finds it is
> not a probe at all: read the *producer's* side conditions, and for a hypothesis
> quantified over a family, ask where the tree derives the negation.
>
> An eighth, from the same audit, is the cheapest of all to check and therefore the
> one to check first: a hypothesis **equivalent** to the conclusion it is supposed to
> buy. `chi_eq_of_bump` proves `hbump → closed ledger`, and the converse is three
> lines, so the theorem is a restatement rather than a reduction and "is `hbump`
> satisfiable" *is* "is the closed ledger satisfiable". Before believing that `H → C`
> reduces `C` to `H`, try to prove `C → H` (I-0456, probe §2c).
>
> `G5` below already says to verify axiom-cleanliness of `instHasPicScheme`; the
> same discipline, in all eight forms, applies to every gate discharge in the
> table. A milestone is done when its statement is true and unconditional, not when
> its axiom line is short.
>
> **Line numbers in this document have drifted and will drift again.** Every
> `file.lean:NNN` citation below was accurate when written in July 2026 and most are
> now off by tens of lines, because the files kept growing. Treat a bare line number
> as a hint about *where to look*, never as evidence that a declaration exists or
> says what the surrounding prose claims — resolve the declaration by name, with
> `horizon search` or the LSP. Load-bearing citations are being converted to
> declaration names as they are touched.

Target: `instHasPicScheme` — `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:259-263` (re-verified 2026-07-27: `⟨sorry⟩` body at :263; statement `∃ X, Nonempty ((picSharp C).RepresentableBy X) ∧ LocallyOfFiniteType X.hom ∧ IsSeparated X.hom` under `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] [HasRationalPoint C]`). Project paths relative to `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`; mathlib paths relative to `.lake-packages/mathlib/Mathlib/`.

---

## Part I — Judgment

### Scores

| Criterion | D1 (Kleiman fidelity) | D2 (curve specialisation) | D3 (minimal infra) |
|---|---|---|---|
| Mathematical soundness | 8 | 7.5 | 8 |
| Lean feasibility (v4.31 + in-tree substrate) | 6 | 7 | 8.5 |
| Total effort | 4 | 6.5 | 8 |
| Risk concentration | 4 | 7 | 8.5 |
| Fidelity to honest `HasPicScheme` | 10 | 10 | 10 |
| **Overall** | **6.0** | **7.5** | **8.5 — WINNER** |

All three target the honest `picSharp` statement, keep `[HasRationalPoint C]` as a hypothesis (never a gate), and leave the vacuous `HasSmoothProperQuotient` (`FGAPicRepresentability.lean:541`, verified: its consumer `smoothProperQuotient` :561 extracts the conclusion from the hypothesis class) permanently instance-free and off-path. No circularity found in any design.

### D1 — 6.0

**Sound** (8): Kleiman-faithful; the duality-free `P^d_m` tower is genuinely sound; the fpqc-epi injectivity trick replacing descent at N9.5 is correct in outline (flat+surjective+qc ⟹ epi in Sch suffices; note mathlib's `EffectiveEpi.lean:49` is the *topological* effective-epi instance — D1's cite is slightly off but the scheme-level fact assembles). Two unflagged soundness/scope gaps: (i) M15(a)'s seesaw pushforward is along `id_C × q` over the **non-affine** base `C × Q`, outside the pinned scope of M1/M2 (projective family over affine `T`) — an extra relative-base-change generality D1 never budgets; (ii) M14b's explicit `O(c)` computation on `Gr(·,1)`-bundles is novel synthesis with no source anchor.

**Feasibility 6 / Effort 4 / Risk 4**: The unique design that avoids the separably-closed detour and Galois descent entirely (correct observation: `Gr(E,1)`-bundles are Zariski-locally trivial, so Kleiman's covering works over `k` directly). But it pays with the AK80 quotient: M14a (flatness from locally-constant Hilbert function over reduced base = Hartshorne III.9.9 + a "constant fibre rank ⟹ free over reduced local ring" brick missing from mathlib) + M14b + M14c + M15 form a **sequential XL chain on the critical path** — the exact "one XL milestone that sinks it" shape, times four. Its M2 engine must also carry ambient-`ℙ^M` generality (for M14) that the other routes never need. ~7 XL total, longest critical path.

**Best ideas to graft**: the audit discipline (arbitrary-`T` quantification; `GeometricallyIntegral` fibre semantics; `Limits.pullback` vs pointwise; Grassmannian quotient-convention — which I verified: `QuotFunctorDef.lean:1076-1092` defines `Grassmannian V d` via rank-`d` locally free **quotients**, the Grothendieck `P(E)` convention); the `C^d` universal-divisor-family trick (M7) as a duality-free fallback for uniform vanishing; increasing-union separatedness (not needed on the winning route but sound).

### D2 — 7.5

**Sound** (7.5): right architecture (Milne–Kollár + finite Galois quotient); explicit `M0` (universal H⁰), Γ-stable common-Σ refinement, and char-p separability care are the best-worked Galois details of the three. Deductions: M12 separatedness via the valuative criterion is self-flagged risky (mathlib's criterion quantifies over ALL valuation rings, `ValuativeCriterion.lean:245`, vs the noetherian-pinned M1 engine; DVR-sufficiency is an acknowledged mathlib TODO) — and it is **unnecessary** (see B6 below); M3's suggested proof routes include Serre duality (scope-creep risk D3 correctly avoids).

**Feasibility 7 / Effort 6.5 / Risk 7**: builds a fresh Čech layer instead of reusing the in-tree adelic lane; three big blocks (M1c, M3, M8b) are reasonably independent.

**Best ideas to graft**: explicit M0; Γ-stable `V_Σ := ⋂_γ P^{γΣ}` cover + orbit-in-affine via EGA II 4.5.4 pattern (this *repairs a real gap in D3's G2* — see below); finite **Galois** field selection with separability of Σ; hygiene wave + `PicScheme.degree` repin (`IdentityComponent.lean:1452`, verified sorried).

### D3 — 8.5 (winner)

**Sound** (8): pins are systematically truth-safe (∃-form vanishing bound; separably-closed-only covering; orbit-in-affine quotient; Čech-carrier cohomology kit avoiding the `HasCechToHModuleIso` gate). Two gaps found in judging, both repairable:
1. **Separatedness of `J'_r` is asserted in J5 but never milestoned.** Gluing the `J^Σ` along nontrivial transition isos does not give separatedness for free; it needs closedness of the transition graphs = closedness of the class-agreement locus. Repaired by the new milestone **B6** (closed-triviality-locus device), which is cheaper and safer than D2's valuative route.
2. **G2's hypothesis "immersion `X' ↪ ℙ^N`" may be unavailable for the *glued* `J'_r`** — a scheme glued from finitely many quasi-projective opens is not obviously quasi-projective, and proving it would smuggle in the ample-bundle problem the Milne route dodges. Repaired by D2's form of the hypothesis: *every finite Γ-orbit lies in an affine open*, supplied by the Γ-stable cover `V_Σ` whose members carry Gr-immersions (finite point-set in a quasi-projective scheme lies in an affine open).

**Feasibility 8.5 / Effort 8 / Risk 8.5**: maximal reuse of verified substrate (adelic `RiemannRoch/` lane — verified this session: the only genuine sorry in the lane is `WeilDivisor.principal_degree_zero`; the `Cokernel.lean:133` / `CechAcyclicInstance.lean:73` grep hits are docstring text; plus `DivFunctor` `DivFunctorDef.lean:875`, `Grassmannian.representable` `GrassmannianRepresentability.lean:595-599`, mathlib coproducts `AlgebraicGeometry/Limits.lean:187/:224` (verified: `HasColimitsOfShape (Discrete σ) Scheme.{u}` + `CoproductsOfShapeDisjoint`), 01JJ `Sites/Representability.lean:207`, `sigmaDesc` `Morphisms/Basic.lean:303`, equalizer-closed `Morphisms/Separated.lean:356`). Its three XLs (P5, B3, G2) are **pairwise independent and all start by wave 2** — the best risk shape of the three designs. The B2 filtered-colimit brick is the correct systematic answer to the noetherian/arbitrary-`T` tension that D1 pushes into its engine statement and D2 leaves unresolved.

### Judge's additional finding (adopted into the plan)

**P5/M3 (uniform H¹ vanishing) has a duality-free, field-uniform proof that shrinks it from XL to L–XL**, resolving the one place where D1's "avoid duality" critique of the Milne route had bite:
- `i(D) := h¹(O(D))` is monotone decreasing under adding points (from `0 → O(D) → O(D+p) → κ(p) → 0`).
- Pick `n₀` over the base field `k` with `h¹(C, O(n₀·x₀)) = 0` (single-bundle Serre-type vanishing; in reach of the adelic lane's finiteness + `HasFiniteMapToP1` machinery). Flat base change makes this bound **uniform over all field extensions κ/k**: `h¹(C_κ, O(n₀·x₀)_κ) = 0`.
- For any invertible `M` on `C_κ` with `deg M ≥ n₀·deg(x₀) + g`: `h⁰(M(−n₀x₀)) ≥ χ = deg − n₀ − g + 1 ≥ 1` (Riemann inequality direction of P3, no duality), so `M ≅ O(n₀x₀ + E)` with `E ≥ 0`, hence `h¹(M) ≤ h¹(O(n₀x₀)_κ) = 0`.
This discharges the ∃-form bound `b := n₀ + g` exactly as D3 pinned it, with the rational point supplying the ample divisor — a use of `[HasRationalPoint C]` all three designs missed. Fallbacks: D1's `C^d`-family trick; Clifford over `κ̄` (last resort, scope-creep warning).

---

## Part II — THE PLAN

**Architecture**: D3's Milne–Kollár route (section trick on the Div substrate + finite Galois quotient + coproduct assembly), with grafts: D2's M0/Γ-stable-cover/orbit-in-affine/separability/hygiene; D1's audit discipline and fallback tricks; new milestone B6 (separatedness device); P5 via the judge's uniform elementary route.

Fixed notation: `g := h¹(C, O)`; `x₀` the rational point; `b` the P5 bound; `r` chosen with `r ≥ b` and `r ≥ 2g+1` (classically `r = 2g+1`); `k'` runs over finite Galois subextensions of `k^s/k`; Λ = the four instance hypotheses of `instHasPicScheme`.

Sizes: S ≤ 1 session, M ≈ 1–2, L ≈ 3–5, XL ≥ 6.

### Milestone DAG

#### Cluster P — curve cohomology kit (reuse the adelic lane)

**P1 — Discharge the adelic lane's gates.**
(i) Instances for `ExistsNonconstantMapToP1 C` (**since discharged**: `existsNonconstantMapToProjInt_of_ajc` and `existsNonconstantMapToP1_of_existsNonconstantMapToProjInt`, `RiemannRoch/Adelic/NonconstantToP1.lean`, so the whole chain to `HasFiniteMapToP1` synthesises for an AJC curve) and `P1HasLaurentChartData`; audit whether the `HasExt`-shaped inputs are already unconditional in `CechComparisonGate.lean:114-136`.
(ii) `RiemannRoch/Adelic/GateInstances.lean`. (iii) trdeg-1 function field; in-lane substrate. (iv) **M**. (v) 🔍 **AUDIT-FIRST**: kernel-build the whole `RiemannRoch/` closure before relying on "sorry-free" (memory lesson: verify inherited closures; the lane's only true sorry must remain `WeilDivisor.principal_degree_zero`, off-path).

**P2 — h⁰/h¹/χ kit over all field extensions.**
(i) For every field κ/k and invertible `M` on `C_κ`: `h0 κ M`, `h1 κ M : ℕ` finite; pinned on the **Čech carrier** (`AffineCoverMVSquare`, `RiemannRoch/Adelic/Substrate.lean`) with cover-independence proved Čech-to-Čech (structurally avoids the `HasCechToHModuleIso` gate); flat-base-change stability `h^i(C_κ, M) = h^i(C_{κ'}, M_{κ'})`.
(ii) `RiemannRoch/CohomologyKit.lean`. (iii) P1; `GenusFiniteness.lean:64`. (iv) **L**. (v) 🔍 AUDIT: Λ-stability instances for `C_κ` (smooth proper geometrically integral over κ) + base-change of `AffineCoverMVSquare` — record as named lemmas, don't inline.

**P3 — Riemann–Roch χ-ledger.**
(i) `χ(M) = deg M + 1 − g` with `deg` the residue-weighted Weil degree (`RiemannRoch/WeilDivisor.lean:1047`); point-sequence induction from `χ(O) = 1 − g`; `M ≅ O(div s)` for `0 ≠ s ∈ H⁰` (integrality ⟹ regular section). Byproduct: closes the input to the `WeilDivisor.principal_degree_zero` sorry (off-path bonus).
(ii) `RiemannRoch/RiemannRochChi.lean`. (iii) P2; `WeilDivisor.lean` linear equivalence :1471. (iv) **L**. (v) 🔍 AUDIT: degree invariance under linear equivalence over **non-perfect** κ — keep the residue-field-weighted convention.

**P4 — h⁰ bounds, drops, rational-point density.**
(i) (a) `deg < 0 ⟹ h⁰ = 0`; (b) `h⁰ > 0 ⟹ h⁰ ≤ deg + 1`; (c) κ **separably closed**, `h⁰ ≥ 2` ⟹ ∃ rational x with exact drop `h⁰(M(−x)) = h⁰(M) − 1` (evaluation map at a rational non-base point); (d) closed points of `C_κ` (κ sep. closed) are rational and dense (smooth ⟹ separable residue fields).
(ii) `RiemannRoch/SectionDrops.lean`. (iii) P2, P3. (iv) **M/L**. (v) 🔍 AUDIT: (c)/(d) pinned **separably closed only** — the R3 trap zone; never generalize.

**P5 — Uniform H¹ vanishing (∃-form pin).**
(i) `∃ b, ∀ κ/k, ∀ M invertible on C_κ, b ≤ deg M → h1 κ M = 0 ∧ GloballyGenerated M`. **Primary route (judge's)**: `i(D)`-monotonicity + one Serre-type vanishing `h¹(O(n₀x₀)) = 0` over `k` + flat base change of the bound + `h⁰(M(−n₀x₀)) ≥ 1` from P3 ⟹ `b := n₀ + g` works uniformly. Global generation from `h¹(M(−x)) = 0` for all closed x (raise b by the max residue degree ≤ … pin as `b' := b + 1` and check at each closed point via the drop sequence).
(ii) `RiemannRoch/UniformVanishing.lean`; gate `HasH1VanishingBound C b`. (iii) P2–P4; `[HasRationalPoint C]` (supplies `x₀`, the ample divisor). (iv) **L–XL** (down from D2/D3's XL). (v) 🔍 AUDIT: keep the ∃-form; quantify over ALL κ including imperfect; do NOT upgrade to Serre duality. Fallback 1: D1-M7 `C^d` universal-family + semicontinuity + κ̄-exhaustion + flat descent. Fallback 2: Clifford over κ̄.

#### Cluster B — base-change engines over the constant curve

**B0 — Universal H⁰** (D2's M0, made explicit).
(i) For every k-algebra A: unit `A ≅ Γ(C_A, O)`; fibre form: `Γ(C_κ, O) = κ` for all fields κ/k.
(ii) `Picard/SectionRingUniversal.lean`. (iii) `GeometricallyIntegral C.hom`; `Picard/GeometricallyConnectedSection.lean` (:101, :377); qcqs section engine `Picard/QuotScheme.lean:2739/:3952`. (iv) **M**. (v) 🔍 AUDIT: the in-tree `GeometricallyIntegral` class must yield "fibres integral after arbitrary field extension" (D1's W1f audit — run it here).

**B1 — picSharp is a Zariski sheaf + `RigidifiedPic` API.**
(i) `IsZariskiSheafOver (picSharp C)` (predicate `ZariskiDescentRepresentability.lean:103`; `picSharp` at `FGAPicRepresentability.lean:173`, verified `Type (u+1)`-valued). Sub-lemmas = Kleiman lm:fff/lm:idn/lm:aut: x₀-rigidified representative exists, unique, automorphism-free (needs B0); glue via `Modules.glue` (`GlueDescent.lean:106`, verified). Build `RigidifiedPic` as a named structure — G3 and B6 reuse it.
(ii) `Picard/PicSharpZariskiSheaf.lean`. (iii) B0; `RelPicFunctor.lean:582/:702/:1004/:1057`; `HasRationalPoint` (:139). (iv) **L**. (v) 🔍 AUDIT: FALSE without the section (docstring `FGAPicRepresentability.lean:35-59`) — `[HasRationalPoint C]` in every pin.

**B2 — Filtered-colimit reduction brick.**
(i) On affine `T = Spec A`, `A = colim A_i` (f.g. k-subalgebras): invertible sheaves on `C_A` (2-affine cocycle presentation), `DivFamily`s, and picSharp-class equalities descend to some `A_i`; picSharp/`DivFunctorDeg` restricted to affines preserve filtered colimits.
(ii) `Picard/FinitePresentationFunctor.lean`. (iii) 2-affine cover (`Adelic/Substrate.lean`); mathlib f.p.-module colimit lemmas (`Algebra/Module/FinitePresentation.lean` — 🔍 audit exact names; absorb an S/M mathlib-gap brick if absent). (iv) **L**. (v) Pin the affine statement only (Stacks 0B8W-grade).

**B3 — THE rigid pushforward engine (hardest single lemma).**
(i) `pushforward_locallyFree_of_h1_vanishing`: A f.g. (hence noetherian) k-algebra, `q : C_A → Spec A`, `L` invertible with `h1 κ(t) (L_t) = 0` at **all scheme points** t: then `q_*L` locally free of rank `χ(L_t)`, formation commutes with **arbitrary** ring maps `A → A'`. Corollary (`h⁰ ≡ 1, χ ≡ 1`): `q_*L` invertible; counit section fibrewise nonzero ⟹ regular (integral fibres) ⟹ canonical `DivFamily`. Route: push along the finite map `C_A → ℙ¹_A` (base change of `HasFiniteMapToP1`) + Mumford AV II.5 two-term finite-free replacement on the explicit 2-chart Čech complex of `ℙ¹_A`. B2 extends every consumer to arbitrary affine T.
(ii) `Picard/RigidPushforward.lean`; optional gate `HasRigidPushforward C`. (iii) P1, P2, P3. (iv) **XL**. (v) 🔍 **AUDIT-FIRST (top item)**: quantifier "all scheme points" (A noetherian is not Jacobson — closed points do NOT suffice); base change for arbitrary `A → A'` in the *statement*; two-step pin (rank-χ form, then rank-1 corollary). Fallback: direct Čech on a 2-affine cover of `C_A` (D2-M1); second fallback: D1-M1/M2 ambient-`ℙ^M` engine.

**B4 — Degree decomposition of picSharp.**
(i) Fibre degree `t ↦ deg L_t` Zariski-locally constant (B3 rank + B2); invariant under `⊗ q^*Pic T` (needed for well-definedness on the quotient functor); disjoint subfunctors `picSharpDeg C d` clopen-decomposing every T-point.
(ii) `Picard/PicSharpDegree.lean`. (iii) B2, B3, P3. (iv) **M**. (v) 🔍 AUDIT: representative-independence lemma `deg(L ⊗ q*N)_t = deg L_t` stated and proved, not assumed. When later repinning the sorried `PicScheme.degree` (`IdentityComponent.lean:1452`, verified) reuse THIS definition.

**B5 — Semicontinuity both ways.**
(i) Over noetherian T: `{t : h⁰(L_t) ≤ n}` **open** and `{t : h⁰(L_t) ≥ n}` **closed** (minors of the B3 complex); extended to arbitrary affine T by B2. (The closed direction feeds B6 — D3 only pinned the open direction.)
(ii) with B3. (iii) B3. (iv) **M**. (v) low.

**B6 — Separatedness/triviality device (NEW, replaces D2-M12's valuative route; fills D3's J5 gap).**
(i) (a) For invertible `L` on `C_T` of fibre degree 0: `{t : L_t ≅ O_{C_t}} = {h⁰(L_t) ≥ 1} ∩ {h⁰(L_t^{-1}) ≥ 1}` is **closed** (B5-closed + P3/P4: on an integral proper curve, `deg = 0` and a nonzero section force `L_t ≅ O`, since the zero divisor has degree 0). (b) On that closed locus, `h⁰ ≡ 1` and the B3 corollary give `L ∈ q^*Pic`: the two picSharp classes **agree as functor points** there. (c) Consequence: for any two T-points of picSharp of equal degree, the agreement locus is a closed subscheme representing the agreement subfunctor.
(ii) `Picard/PicSharpSeparatedDevice.lean`. (iii) B3, B5, P3, P4(a); B0 (h⁰(O)=1 on integral fibres). (iv) **M/L**. (v) 🔍 AUDIT: geometric integrality of fibres is load-bearing in (a); pin (c) exactly at the "closed subscheme represents the subfunctor" level J5 consumes. Fallback: D2-M12 valuative criterion (`ValuativeCriterion.lean:245`) accepting its arbitrary-valuation-ring vs noetherian friction.

#### Cluster A — bookkeeping on proved substrate

**A1 — Degree translation isos.** `picSharpDeg C d ≅ picSharpDeg C d'` via `⊗ O((d'−d)·x₀ × T)`, natural, setoid-compatible (`RelPicFunctor.lean:582/:702/:1004`). One direction-convention audit lemma. (iv) **M**.

**A2 — Degree-refined Abel map.** `abelDeg d : DivFunctorDeg C d ⟶ picSharpDeg C d` refining `abelMapWitness` (`FGAPicRepresentability.lean:453`, verified proved: `abelKernelNatTrans ≫ picNeg`). (iii) D1', B4. (iv) **S/M**. (v) Sign: `[D] ↦ [O(D)] = −[ker q]` — one sign audit, upstream naturality proved.

#### Cluster D' — `Div^d` representability (Div lane; Quot tensor-sorries stay off-path)

**D1' — Degree-d Div functor + clopen decomposition.**
(i) `DivFunctorDeg C d` ⊆ `DivFunctor` (`DivFunctorDef.lean:875`, verified axiom-clean; `DivFamily` :747) via rank-d of the finite-flat pushforward of `O_D` (02KE/02KH engine, `SchematicSupport.lean`); `DivFunctor = ⨿_d DivFunctorDeg` (rank clopen; NO cohomology needed).
(ii) `Picard/DivDegree.lean`. (iii) in-tree only. (iv) **M**. (v) carry `[IsProper C.hom]` for `properSupport` faithfulness (R4 regime).

**D2' — Grassmannian comparison.**
(i) Fix m with `m·deg(O(1)-fibre) − d ≥ b`. `α : DivFunctorDeg C d ⟶ Grassmannian (Γ(C,O(m)))-rank-d-quotients`: `D ↦ [Γ(C,O(m))_T ↠ q_*(O_D(m))]`; surjectivity of the evaluation from `h¹(I_D(m)) = 0` (P5) through B3 on the ideal side; α mono from global generation of `O(m)(−D)` (P5 clause 2).
(ii) `Picard/DivGrassmannianEmbedding.lean`. (iii) P5 (gate), B3, flat base change of sections (`Cohomology/FlatBaseChange.lean`, `QuotScheme.lean` ~:4647/:6108). (iv) **L**. (v) Convention audit **done this session**: in-tree `Grassmannian V d` = rank-d locally free **quotients** (`QuotFunctorDef.lean:1076-1092`) — matches. 🔍 AUDIT remaining: index arithmetic `d ≤ h⁰(O(m))` via P3; α-mono diagram (R4 gap 3).

**D3' — Locally closed carving.**
(i) The locus over which a Grassmannian T-point arises from a degree-d `DivFamily` is locally closed, universally. Extend `flatLocusStratification_universal` (`FlatteningStratificationUniversal.lean:878`, verified: currently the n=0 form `F : S.Modules` over S itself) to the family `C × G → G`; invertible-kernel condition open via `DivFunctorDef.lean:610/:686` bricks.
(ii) `Picard/DivLocallyClosed.lean`. (iii) `flatteningStratification` (`GenericFlatnessGeometric.lean:1831`, verified `[IsNoetherian S] [IsProper π]`), B3. (iv) **L**. (v) 🔍 AUDIT: the universal-property extension over nontrivial π is the only new content; no Hilbert-polynomial labels needed (degree = D1' rank).

**D4' — `Div^d` is a scheme + quasi-projectivity certificate.**
(i) `∃ Z_d, Nonempty ((DivFunctorDeg C d).RepresentableBy Z_d)`, FT + separated, **plus data**: locally closed immersion `Z_d ↪ Gr` (the quasi-projectivity certificate feeding G2's orbit-in-affine; mathlib has no `QuasiProjective` class, cf. `FGAPicRepresentability.lean:517-529`).
(ii) `Picard/DivRepresentability.lean`; gate `HasDivDegScheme C d`. (iii) D1'–D3'; `Grassmannian.representable` (`GrassmannianRepresentability.lean:595-599`, verified proved via `representable_of_openCover` + `isZariskiSheaf`). (iv) **M**. (v) low given D2'/D3'.

#### Cluster J — Milne §4 over separably closed k'

All milestones over sep. closed k' ⊇ k with `C' := C ×_k k'` (Λ-stability instances, `IdentityComponent.lean:1138` pattern). `Z := Z_r` from D4'.

**J1 — Σ-opens.** For Σ an (r−g)-tuple of **rational points** of C': `C^Σ` := open of Z where `h⁰(O(W−Σ)_t) = 1` at every scheme point (open by B5; `{h⁰≤1} = {h⁰=1}` since `h⁰ ≥ χ = 1` at degree g by P3). Pin Σ as a tuple, not a divisor class. (iv) **M**.

**J2 — Canonical section + `J^Σ` as an equalizer.** B3-corollary on `L := O(W−Σ)` gives the canonical degree-g `DivFamily`, hence `s : C^Σ → Z` (add Σ back); `J^Σ := equalizer(ι_{C^Σ}, s : C^Σ ⇉ Z)`, **closed** in `C^Σ` by mathlib `Morphisms/Separated.lean:356` (verified: `IsClosedImmersion (Limits.equalizer.ι f g)` for separated target; Over-version :273). (iii) B3, J1, A2, D4'. (iv) **L**.

**J3 — `J^Σ` represents `P^Σ`.** `P^Σ` := subfunctor of `picSharpDeg C' r` with fibrewise `h⁰(L_t(−Σ)) = 1` (all scheme points); representable by `J^Σ`; `P^Σ ⊆ picSharpDeg r` open (B5 + invariance of the h⁰-condition under `⊗q^*N` — separate lemma). Hard direction: Zariski-local honest representative (B1) + B3/B2 canonical divisor + add Σ. (iii) J2, B1, B2, B3. (iv) **L**. (v) 🔍 AUDIT: all-scheme-points quantifier; quotient-functor invariance lemma.

**J4 — Covering over k'.** Every T-point of `picSharpDeg C' r` lies Zariski-locally in some `P^Σ`: pointwise via P4(c) drops from `h⁰ = r+1−g` (P5 kills h¹ at degree r), spread by B5. **Γ-refinement (graft from D2-M6)**: for any finite Galois orbit of classes, a **common** good Σ exists (finite intersection of dense opens), and Σ can be chosen with separable (= rational over k') coordinates whose Galois orbit is finite. (iii) P4, P5, B5. (iv) **L**. (v) 🔍 AUDIT: **separably closed only** (genus-2/ℚ counterexample survives `HasRationalPoint`); char p: subtract only rational points.

**J5 — Glue: `Pic^r` over k', with separatedness.**
(i) `∃ J'_r` with `Nonempty ((picSharpDeg C' r).RepresentableBy J'_r)`, FT, **separated (via B6)**, covered by opens `J^Σ` each carrying Gr-immersion data. Engine: mathlib 01JJ (`Sites/Representability.lean:207`, verified; NOT the in-tree `representable_of_openCover` `ZariskiDescentRepresentability.lean:1347`, verified base-opens-only at `Scheme.{0}`/`Type 1`). Separatedness: transition graphs closed by B6(c). Quasi-compactness: Z_r qc + α_r pointwise surjective (J4) ⟹ finite Σ-subcover; record it, chosen Γ-stable per J4's refinement, together with the Γ-stable opens `V_Σ := ⋂_{γ∈Γ} P^{γΣ}` (graft from D2-M7d).
(ii) `Picard/MilneGlue.lean`; optional gate `HasPicDegSchemeSepClosed`. (iii) J3, J4, B1, B6. (iv) **L–XL**. (v) 🔍 AUDIT: universe bridging — 01JJ wants a `Type u`-valued Zariski sheaf on `Scheme.{u}` (`Sites/Representability.lean:56`, verified) while picSharp is `Type (u+1)`-valued: reuse the in-tree smallness pattern (`ZariskiDescent.gluedFunctor`, `ZariskiDescentRepresentability.lean` §1–8) or a small rigidified-pairs model from B1. Budget one session.

#### Cluster G — Galois descent + total assembly

**G1 — Spread to a finite Galois level.** J5's finite datum (finitely many `J^Σ ↪ Gr`, gluing isos, universal families, Γ-stable `V_Σ`) descends to finite **Galois** k'/k (B2 colimit argument over k^s = colim; Galois closure; separability of Σ from J4). The twists `γ^*J'_r` all represent the same functor-defined-over-k, so `RepresentableBy`-uniqueness yields a canonical descent datum with free cocycle identity. (iii) J5, B2. (iv) **L**. (v) Imperfect k: k^s, never k̄.

**G2 — Finite Galois quotient engine (the only quotient; reusable).**
(i) X' over k', Γ = Gal(k'/k), semilinear Γ-action, **hypothesis: every finite Γ-orbit lies in an affine open** (STRICTLY this form — graft from D2-M8b; NOT D3's global `X' ↪ ℙ^N`, which is unavailable for glued J'_r): then ∃ X over k, Γ-equivariant `X ×_k k' ≅ X'`, `Hom_k(T,X) ≅ Hom_{k'}(T_{k'},X')^Γ`. Sub-lemmas: (a) orbit-in-affine from a Γ-stable cover by Gr-immersed opens (finite point-set in quasi-projective lies in an affine open — EGA II 4.5.4 pattern); (b) **Speiser**: semilinear descent `k' ⊗_k A^Γ ≅ A`, and its module form over `k' ⊗_k B` for arbitrary k-algebra B (D2-M8a; the module form over a general base is what G3 consumes); seeds: `Algebra.isInvariant_of_isGalois` (`RingTheory/Invariant/Basic.lean:67`, verified — note it is AKLB-shaped, adapt), `FieldTheory/Fixed`; (c) glue `Spec(A^Γ)` via `Scheme.GlueData`.
(ii) `Picard/FiniteGaloisQuotient.lean` (+ `GaloisDescent/SemilinearModules.lean`); gate `HasGaloisDescent`. (iii) mathlib only — **fully independent, wave 1**. (iv) **XL** — reusable for `Sym^d`/Albanese (T9 lane wants Sym^g substrate). (v) 🔍 AUDIT: orbit-in-affine essential (Hironaka trap family — same genus as the `HasSmoothProperQuotient` counterexample); prove `A^Γ = A₀` by descent, never Noether invariant-finiteness.

**G3 — Galois descent of picSharp points.**
(i) `picSharp C (T) ≅ (picSharp C_{k'} (T_{k'}))^Γ` naturally, via **rigidified pairs** (B1's automorphism-free `RigidifiedPic` ⟹ descent datum canonical; 2-affine cocycle modules descend by Speiser G2(b)). Conclude `J_r := J'_r/Γ` (G2) represents `picSharpDeg C r` over k.
(ii) `Picard/PicSharpGaloisDescent.lean`. (iii) B0, B1, G1, G2. (iv) **L**. (v) 🔍 AUDIT (Hilbert-90 trap): invariant **classes** vs equivariant **objects** — every statement must route through rigidified pairs; the naïve `Pic(C_{T'})^Γ` pin is FALSE-adjacent.

**G4 — Coproduct assembly.**
(i) `X := ∐_{d:ℤ} X_d`, each `X_d` := copy of `J_r` relabelled through A1's translation `picSharpDeg d ≅ picSharpDeg r`. Mathlib verified: `HasColimitsOfShape (Discrete σ) Scheme.{u}` + `CoproductsOfShapeDisjoint` + disjoint `Sigma.ι` open covers (`AlgebraicGeometry/Limits.lean:187-225`); `LocallyOfFiniteType` along `Sigma.desc` via `sigmaDesc` (`Morphisms/Basic.lean:303`, verified) + FT-descent along `Spec k' → Spec k` (D2-M13: `k'⊗_k A₀` FT ⟹ A₀ FT). New bricks: `hom_sigma_decompose` (T-map = clopen partition + components, matched to B4), `isSeparated_sigma` (verified absent from mathlib; provable via `IsZariskiLocalAtTarget` + disjoint cover).
(ii) `Picard/PicTotalAssembly.lean`. (iii) A1, B4, G2, G3. (iv) **M**. (v) `Small.{u} ℤ` trivial; audit the clopen-decomposition equivalence once, standalone.

**G5 — Discharge `instHasPicScheme`.** `⟨X, ⟨representableBy⟩, lft, sep⟩` at `FGAPicRepresentability.lean:309`. Kernel-build the full inherited closure (memory lesson); `lean_verify` axiom-cleanliness of `instHasPicScheme`. (iv) **S**.

**H0 — Hygiene (anytime).** Fix stale docstrings (`QuotFunctorDef.lean:456`, `DivFunctorDef.lean:76-79`, `QuotScheme.lean:230/:301`, `IdentityComponent.lean:262`); note `HasDivFunctor` vacuity (`FGAPicRepresentability.lean:185`); repin `PicScheme.degree` (`IdentityComponent.lean:1452`) through B4's `picSharpDeg`; docstring-flag `HasSmoothProperQuotient` (:541) as permanently off-path.

**Edges (summary):** G5←{G3,G4}; G4←{A1,B4,G2,G3}; G3←{B0,B1,G1,G2}; G1←{J5,B2}; J5←{J3,J4,B1,B6}; J4←{P4,P5,B5}; J3←{J2,B1,B2,B3}; J2←{B3,J1,A2,D4'}; J1←{D4',B5,P3}; D4'←{D1',D2',D3'}; D3'←{B3}; D2'←{P5,B3,P3}; D1'←∅; A2←{D1',B4}; A1←{B4}; B6←{B3,B5,P3,P4,B0}; B5←{B3}; B4←{B2,B3,P3}; B3←{P1,P2,P3}; B2←∅; B1←{B0}; B0←∅; P5←{P2,P3,P4}; P4←{P2,P3}; P3←{P2}; P2←{P1}; P1←∅; G2←∅.

**Critical path:** P1 → P2 → P3 → {P4→P5 ∥ B3} → D2'/D3' → D4' → J1–J3 → J4/J5 → G1/G3 → G4 → G5, with B3 and G2 running as independent poles from wave 1. Totals: **3 XL (B3, G2, J5≤XL or P5≤XL), ~10 L, ~10 M/S** — the three largest blocks pairwise independent.

### Gate plan and discharge order

House pattern: Prop-classes, **no sorried instances**, deleted on discharge.

| Gate | Content | Unblocks | Discharged by |
|---|---|---|---|
| adelic inherited gates (`ExistsNonconstantMapToP1`, `P1HasLaurentChartData`, `HasExt`-shaped) | in-lane | P2 | **P1** (wave 1) |
| `HasH1VanishingBound C b` | P5 ∃-form | D2', J4 | **P5** (wave 2) |
| `HasRigidPushforward C` (optional) | B3 | D2', J2, J3, B4–B6 dev | **B3** (wave 2) |
| `HasDivDegScheme C d` | D4' + Gr-certificate | J-cluster | **D4'** (wave 3) |
| `HasPicDegSchemeSepClosed` (optional) | J5 | G1 | **J5** (wave 4) |
| `HasGaloisDescent` (optional) | G2 | G3 | **G2** (wave 2–3) |

Order: P1 → (P5, B3, G2 in parallel) → D4' → J5 → G3 → G5. Final state: **zero campaign gates**; `HasRationalPoint` remains as an honest hypothesis; `HasSmoothProperQuotient` remains empty, unused, docstring-flagged. Off-path and untouched: the Quot-lane sorries in `QuotRepresentability.lean`, `QuotFunctorDef.lean` (two) and `SerreFiniteness.lean` (two), and `WeilDivisor.principal_degree_zero` (P3 may close it as a bonus).

**Gate-table status, re-measured 2026-07-28.** The table above is the plan; this is the
state. Resolve everything by declaration name — the wave sections below cite line numbers
that have drifted. Every count below is regenerable: the frontier from `lake env lean
scripts/axiom-frontier.lean` (111 declarations, 71 clean, 40 carrying `sorryAx`, with the
root build green at 8,744 jobs), the carrier list from `lake build AlgebraicJacobian 2>&1 |
grep 'declaration uses' | sort -u` (26 over 11 modules).

- **`instHasPicScheme` — still the target, and still the only genuine synthesis leak on this
  route.** Of the tree's 26 `sorry` carriers exactly *two* are instances, so exactly two can
  reach a consumer without being named in the statement it depends on: `instHasPicScheme`
  itself and `pullback_preservesFiniteLimits` (the flat-pullback left-exactness of the
  cohomology lane, off this route). Everything else on the route is honest debt — visible in
  the signature of whatever depends on it. That is the useful shape of the remaining work: the
  campaign has one hidden obligation, not a diffuse cloud of them, and G5 closes it.

- **`HasRigidPushforward C` — DISCHARGED (2026-07-27, commits `d6bfd59be`/`f4a56a754`).**
  `Adelic.instHasRigidPushforwardOfCurve`
  (`Picard/RigidPushforwardGammaBaseChange.lean`) is a global instance for every curve
  smooth of relative dimension one, proper and geometrically integral. Both fields are
  theorems: `locallyFree` is `Adelic.rigidPushforwardLocallyFree_proved`, resting on
  `IsIntegral (ℙ¹_k)` (`Adelic.instIsIntegralP1OverLeft`, from the chart-ring
  identification `Γ(ℙ¹_k, D₊(Xᵢ)) ≃ₐ[k] k[T]` plus a two-chart irreducibility argument)
  and the rank identity (`Adelic.p1RankIdentity_proved`, for every `k`-algebra);
  `baseChange` comes by affine-target descent from
  `Adelic.rigidPushforwardGammaBaseChange_proved`, the classical `H⁰` base-change
  statement. Measured at the *synthesis* site, not merely as stated: the three extraction
  theorems of `Picard/RigidPushforward.lean` are restated without the
  `[HasRigidPushforward C]` binder in §4 of that file and come out clean. Read
  `hasRigidPushforward_of_leaves` as a four-leaf factorisation, not as the frontier.
  `Picard/RigidPushforwardP1Witness.lean` exhibits `ℙ¹` itself as a curve satisfying the
  three hypotheses, so neither the instance nor the extraction theorems are vacuous.
- **`HasStableAffineCover` — discharged** (`hasStableAffineCover_of_orbitsInAffineOpen`),
  under `OrbitsInAffineOpen`, which the Hironaka trap shows cannot be dropped.
  `HasGaloisQuotient` remains instance-free; G2's affine model is proved
  (`isGaloisQuotient_spec`), and Speiser descent and the affine Hom property are proved
  (`SemilinearAction.descentAlgEquiv`, `SemilinearAction.invariantAlgHomEquiv`).
- **Cluster P has landed further than the table suggests, and conditionally.** The χ-ledger
  is closed on effective divisors from the one-point bump
  (`Adelic.chi_eq_of_bump_of_nonneg`), the negative part is stated as an equivalence rather
  than reduced (`Adelic.chi_eq_iff_step_of_bump`), and bounded vanishing and global
  generation are assembled (`Adelic.exists_bound_forall_generatedAt`). All of it is
  axiom-clean and almost all of it is **conditional in the statement** on the closed ledger
  and/or a peel-surjectivity datum. `scripts/axiom-frontier.lean` §6b/§6d carry the
  per-declaration open-hypothesis columns; a clean axiom line in this lane is not a
  discharge.
- **The eight ways a milestone can look done and not be** are catalogued, the first five each
  measured in `scripts/axiom-frontier.lean`: a gate discharged by the caller; an unproved
  named hypothesis; a *false* named hypothesis; an instance binder nothing can instantiate
  for the ambient object; and an unrooted module, which no axiom check reaches at all. The
  sixth was found in the Riemann–Roch lane after the other five and is the only one that
  defeats *both* a clean axiom line and an instantiability probe: an **instance diamond**
  that silently re-pins a definition's meaning. Two different `Algebra k K(C)` instances can
  supply the binder that the Adelic definitions (`sectionSub`, `orderGeSub`, `residueDeg`,
  `chi`) are stated over, they are not definitionally equal, and both are in scope in a file
  that opens the wrong pair of namespaces. A file that picked up the second would prove
  correct-looking theorems about a `residueDeg` pinned to a different `k`-action than every
  consumer uses. The tell is not the axiom output and not "does it elaborate": it is a
  cross-file identity that *ought* to be `rfl` and is not.

  The **seventh** was found in the same lane (2026-07-28) and defeats even a consistency
  witness: a hypothesis whose negation the tree *already derives* at the instances that
  matter. `chi_eq_of_bump`'s `hbump` is quantified over every prime divisor, but its only
  producer requires the prime to lie in the affine cover's overlap, and off the overlap the
  same file proves the section space unchanged — so the χ-jump is `0` where `hbump` asserts
  `residueDeg P ≥ 1`. The theorem is true, axiom-clean, consistent (vacuously, on a scheme
  with no prime divisors), instantiable, and empty at every prime outside the overlap. For a
  hypothesis quantified over a family, "is it satisfiable" is the wrong question; ask where
  the tree derives the negation (I-0449, I-0454, lesson I-0451, probe §2b).

  The **eighth** is the cheapest to check and belongs first in any audit: a hypothesis
  *equivalent* to the conclusion it is supposed to buy. `hbump` and the closed χ-ledger are
  interderivable — the converse is `rw [hledger (D+P), hledger D, degK_add,
  degK_pointDivisor]; ring` — so `chi_eq_of_bump` is a restatement, not a reduction, and no
  axiom or vacuity check can see it. Attempt `C → H` before believing `H → C` reduces
  anything (I-0456, probe §2c).

### Wave-1 parallel work list (6 agent tasks)

**W1-A — Adelic gate discharge + closure certification (P1).**
Do: kernel-build `RiemannRoch/` (`lake build`, check PIPESTATUS); prove the `ExistsNonconstantMapToP1` instance (trdeg-1 nonconstant function); assess/finish `P1HasLaurentChartData`; audit `CechComparisonGate.lean:114-136` for conditionality.
Accept: instances compile axiom-clean (`lean_verify`); a note listing every remaining gate in the lane with file:line; confirmation the only sorry is `WeilDivisor.principal_degree_zero`.

**W1-B — B3 statement-pin + scaffold, and B5.**
Do: run the B3 statement audit (all-scheme-points quantifier, arbitrary base-change ring maps, two-step pin) BEFORE writing Lean; pin `pushforward_locallyFree_of_h1_vanishing` + corollary behind a finiteness gate; build the `ℙ¹_A`-pushforward reduction and the 2-chart Čech complex; prove B5 both directions modulo the gate.
Accept: statement file compiles; audit verdict recorded in the docstring; the reduction "B3 for `C_A` ⟸ two-term complex for `ℙ¹_A` + finite pushforward" sorry-free modulo the named gate.

**W1-C — G2 Galois quotient engine (independent longest pole).**
Do: Speiser semilinear descent for k'-vector spaces, then modules over `k'⊗_k B`; `galoisDescendScheme` pinned with the **orbit-in-affine** hypothesis (never global ℙ^N); affine case `A = k' ⊗_k A^Γ` proved; orbit-in-affine-from-quasi-projective-cover sub-lemma stated.
Accept: `SemilinearModules.lean` axiom-clean; `FiniteGaloisQuotient.lean` compiles with the affine heart proved and gluing reduced to named sub-lemmas; a Hironaka-trap audit note on the hypothesis.

**W1-D — B0 + B1 (universal H⁰, Zariski sheaf, rigidification API).**
Do: B0 with the `GeometricallyIntegral` semantics audit; `RigidifiedPic` structure; lm:aut automorphism-freeness; `picSharp_isZariskiSheafOver` via `Modules.glue`.
Accept: B0 axiom-clean; sheafness proved or reduced to ≤3 explicitly-listed B3-free lemmas; `[HasRationalPoint C]` present in every statement; audit verdict on `GeometricallyIntegral` recorded with file:line.

**W1-E — D1' + A2 (Div degree slices + refined Abel; no cohomology).**
Do: `DivFunctorDeg` via 02KE/02KH rank; clopen decomposition `DivFunctor = ⨿_d`; `abelDeg` refinement of `abelMapWitness`.
Accept: both axiom-clean (kernel build); the sign/degree coherence lemma (`deg [O(D)] = rank push(O_D)`) proved, not asserted.

**W1-F — Audit batch + hygiene (H0).**
Do: run the mandatory audit checklist items 1–8 below that are wave-1-relevant (B3 quantifiers, J4 sep-closed pin, `GeometricallyIntegral`, `Limits.pullback` vs pointwise at `FGAPicRepresentability.lean:566`, B4 representative-independence, universe bridge plan for J5, B2 mathlib lemma names, P5 route feasibility check on `h¹(O(n₀x₀))`); fix stale docstrings.
Accept: one audit note per item with verdict + file:line evidence; hygiene commits.

### Risk register with fallbacks

| # | Risk | Likelihood/Impact | Fallback |
|---|---|---|---|
| R1 | B3 via ℙ¹-pushforward stalls (finite-pushforward friction) | M/H | Direct Čech on a 2-affine cover of `C_A` (D2-M1, Mumford AV II.5); second: D1's ambient-`ℙ^M` engine M1/M2 |
| R2 | P5 primary route stalls at `h¹(O(n₀x₀)) = 0` over k | L/M | D1-M7 `C^d`-family + semicontinuity + κ̄-exhaustion + flat descent; last resort Clifford/duality over κ̄ (contain scope) |
| R3 | J5 universe bridge (Type (u+1) vs 01JJ's Type u) | M/M | Reuse `ZariskiDescent.gluedFunctor` smallness pattern (in-tree, solved once for base-opens); else small rigidified-pairs model of picSharp from B1 |
| R4 | G3 Hilbert-90: invariants of classes ≠ classes of invariants | M/H | Enforced rigidified-objects routing (B1 API); audit before each G3 lemma; fallback explicit cocycle computation on the 2-affine cover |
| R5 | B6 device gap (deg-0 + sections ⟹ trivial on non-perfect fibres) | L/M | D2-M12 valuative criterion (`ValuativeCriterion.lean:245`) accepting arbitrary-valuation-ring work + B2 |
| R6 | G2 orbit-in-affine unobtainable for glued J'_r | L/H | Already mitigated by design (Γ-stable `V_Σ` + Gr-immersion certificates carried as data from D4'/J5); fallback: refine the Σ-family until orbits are chart-local |
| R7 | D3' universal-property extension of the flattening stratification over nontrivial π | M/M | Nitsure §5 reduction using D2''s local freeness to avoid the general case; the stratification itself EXISTS (`GenericFlatnessGeometric.lean:1831`) |
| R8 | B2 mathlib f.p.-colimit lemmas missing | M/L | Absorb an S/M mathlib-gap brick (pattern: memory's "reusable Mathlib-gap bricks") |
| R9 | Char-p traps in J4/G1 (inseparable points, non-Galois k') | L/H | P4(c)/(d) pinned separably-closed; Σ rational over k'; always take Galois closure at G1 |
| R10 | False-as-pinned statement slips through | M/H | The mandatory audit checklist below is BLOCKING: no proof work on a flagged statement before its audit verdict is recorded |

### Mandatory statement-audit checklist (run BEFORE proving — the tree has been burned before)

1. **B3** (top item): `h¹ = 0` at ALL scheme points (noetherian ≠ Jacobson: closed points insufficient); base change along ARBITRARY `A → A'`; the two-step pin.
2. **P5**: ∃-form only; all κ including imperfect; global-generation clause; no silent Serre-duality upgrade.
3. **J4**: separably-closed-only pin (genus-2/ℚ counterexample survives `HasRationalPoint`); rational-point density needs smooth + sep. closed; char p subtractions.
4. **J1/J3**: `h⁰ = 1` at all scheme points; `P^Σ`-membership invariant under `⊗ q^*N` (quotient-functor well-definedness) as a named lemma.
5. **B1**: `[HasRationalPoint C]` in every sheafness/rigidification pin (FALSE without it — `FGAPicRepresentability.lean:35-59`).
6. **B0**: in-tree `GeometricallyIntegral` semantics = "fibres integral after arbitrary field extension"?
7. **B4/A1**: `deg(L ⊗ q^*N)_t = deg L_t` proved; translation direction conventions.
8. **G2**: orbit-in-affine hypothesis essential (Hironaka trap); never state for general X'.
9. **G3**: rigidified-objects routing everywhere (Hilbert-90).
10. **D2'**: sub-vs-quotient Grassmannian convention — ✅ CLOSED this session: quotients (`QuotFunctorDef.lean:1076-1092`).
11. **`Limits.pullback` vs pointwise fibre product** wherever overlap/relation functors are formed (`FGAPicRepresentability.lean:566` region) — pin pointwise + comparison.
12. **D3'**: the ∃!-property extension of `flatLocusStratification_universal` (:878, currently n=0 form) over nontrivial π.
13. **Kernel-build every inherited "sorry-free" closure** before relying on it (adelic lane, DivFunctorDef, GrassmannianRepresentability) — check PIPESTATUS.
14. **P2**: Λ-stability of `C_κ` + `AffineCoverMVSquare` base-change as named instances.
15. **B6**: geometric integrality load-bearing in "deg 0 + section ⟹ trivial"; pin (c) at the represents-the-subfunctor level.

---

## Part III — RECON CORRECTION (run-0020 session 0002, T15, 2026-07-09; supersedes stale Part-I/II recon where noted)

Baseline kernel build green (`lake build AlgebraicJacobian` = 8617 jobs, exit 0). Corrections to the wave plan after auditing the actual tree state — several Part-I/II claims were stale at authoring time:

**C1 — P1 is essentially DONE, not a wave-1 task.** The map-to-ℙ¹ gate chain is already sorry-free and *unconditional* under the ambient AJC hypotheses `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]`:
- `existsNonconstantMapToProjInt_of_ajc` (`NonconstantToP1.lean:1067`, sorry-free) ⟹ `ExistsNonconstantMapToProjInt C`;
- `existsNonconstantMapToP1_of_existsNonconstantMapToProjInt` (`NonconstantToP1.lean:136`) ⟹ `ExistsNonconstantMapToP1 C`;
- `hasFiniteMapToP1_of_existsNonconstantMapToP1` (`FiniteMapToP1.lean:452`) ⟹ `HasFiniteMapToP1 C`;
- `instP1HasLaurentChartData` (`P1ChartData.lean:1179`, *unconditional* for every field) discharges gate 2.
So P1's "prove the `ExistsNonconstantMapToP1` instance" and "`P1HasLaurentChartData`" line items are already closed. **The `HasExt.{u}`/`HasExt.{u+1}` gates are also non-issues**: `hasExt_moduleKSheaf`/`hasExt_succ_moduleKSheaf` (`CechComparisonGate.lean`) prove them by `inferInstance` (Grothendieck-abelian + enough injectives on the `ModuleCat k`-sheaf site).

**C2 — The TRUE root bottleneck of Cluster P is `IsAffineHModuleVanishing` (affine Serre vanishing), NOT P1.** The genus/cohomology keystone `module_finite_hModule_one_unconditional` (`CechAcyclicInstance.lean:172`) still requires the gate `∀ S, HasCechToHModuleIso (toModuleKSheaf C) S.coverFamily`, whose only residual is `IsAffineHModuleVanishing k C (toModuleKSheaf C)` (`StructureSheafModuleK/Carriers.lean:222`): for every affine open `U` and `i>0`, `Subsingleton (HModule' k F i U)`. Its own docstring flags it a **Mathlib-gap, multi-iteration project-local build** (no scheme-level Serre vanishing on affines for the `ModuleCat k` flavour). Since P2/P3 need `h¹(C_κ,M)` *finite/computable*, this gate gates the whole P-cluster. **Re-sequencing: elevate affine Serre vanishing (`IsAffineHModuleVanishing`) to a wave-1 XL pole alongside B3 and G2.** It is arguably the single highest-leverage remaining root — it also unblocks the T16 north-star `finrank_eq_genus`/`tangentSpaceIso`.

**C3 — B0 partially landed this session.** The H⁰-*finiteness* half was already present (`instIsHModuleHomFinite_toModuleKSheaf`, `Carriers.lean:498`, iter-046: `Module.Finite k Γ(C,𝒪)` for proper integral C). This session added `Picard/SectionRingUniversal.lean` (axiom-clean, kernel-green): `isField_globalSections` (`Γ(C,𝒪)` is a field), `finiteDimensional_globalSections` (finite field extension of k), and `globalSectionsAlgEquivBase : Γ(C,𝒪) ≃ₐ[k] k` **modulo the honest gate `HasTrivialConstants C`** (= `k → Γ(C,𝒪)` surjective = field-of-constants-is-k). The one remaining input to discharge `HasTrivialConstants` unconditionally is **degree-0 H⁰ flat base change** `Γ(C_{k̄},𝒪) ≅ k̄ ⊗_k Γ(C,𝒪)` (Mathlib v4.31 has no scheme-level H⁰ base change; leansearch confirms). NB: degree-0 flat base change is a *much* smaller brick than the general `Rⁱf_*` FBC engine and is reused across B2/B3/B4/B5/D2' — worth building as standalone infra (candidate wave-1 item, feeds C3's gate discharge).

**C4 — Wave-1 re-scoping recommendation.** Given C1–C3, the effective independent wave-1 poles are: **(i)** `IsAffineHModuleVanishing` (affine Serre vanishing, XL — new top item); **(ii)** B3 rigid pushforward (XL); **(iii)** G2 Galois quotient engine (XL); **(iv)** degree-0 H⁰ flat base change (L, feeds B0/B2/B4/B5); **(v)** D1' Div degree slices (M, in-tree); **(vi)** B0 gate discharge (S, once (iv) lands). P1 and the HasExt gates are struck from wave 1 (done).

---

## Part IV — WAVE LANDINGS (run-0020 session 0006, T15, 2026-07-09)

**G2(b) Speiser semilinear descent — LANDED (algebraic heart complete, axiom-clean).**
New file `Picard/GaloisDescent/SemilinearModules.lean` (~390 LOC, kernel-green, full
project build 8690 jobs exit 0; headline decls `descentMap_bijective`,
`finrank_invariants` verified `[propext, Classical.choice, Quot.sound]`, no `sorryAx`).

Content: for a **finite Galois** extension `L/K` (`[FiniteDimensional K L] [IsGalois K L]`)
and **any** `L`-module `V` (`[Module K V] [Module L V] [IsScalarTower K L V]`) carrying a
**semilinear** `Gal(L/K)`-action (`IsSemilinear K L V`: `σ • (a•v) = σa • σ•v`):

- `SemilinearAction.invariants K L V : Submodule K V` — the `K`-form `V^G`;
- `SemilinearAction.descentEquiv : L ⊗[K] V^G ≃ₗ[L] V` — **Speiser's theorem**, the descent
  isomorphism `a ⊗ w ↦ a•w`;
- `SemilinearAction.finrank_invariants : finrank K V^G = finrank L V`.

NB **no finiteness on `V` is assumed** — this is the full module-form descent (not just the
finite-dimensional vector-space case), i.e. exactly the reusable brick G3 consumes (`G2(b)`
"module form over a general base"; also serves `Sym^d`/Albanese).

Proof architecture (pure field theory, mathlib-only — no AG machinery, no cohomology):
- **Dedekind independence** (`linearIndependent_algHom_toLinearMap`) transported through
  evaluation at a `K`-basis `b` of `L` gives the "Galois matrix" rows
  `σ ↦ (i ↦ σ(b i))` `L`-independent, hence (card `= [L:K] = |Gal|`) spanning
  (`galoisRow_span`); the annihilation criterion `galoisMatrix_eq_zero_of`
  (`∀σ ∑ σ(b i)•t i = 0 ⟹ t = 0`, for coefficients in **any** `L`-module) and column
  spanning `galoisCol_span` follow.
- **Surjectivity**: `avg a v = ∑_σ σa•(σ•v) ∈ V^G`; `v` is an `L`-combination of the
  `avg (b i) v` via `galoisCol_span` (`span_invariants_eq_top`).
- **Injectivity**: `tensorFromPi` decomposes `L ⊗[K] V^G` via the `L`-basis `b`; the composite
  `t ↦ ∑ b i • (t i:V)` is injective by `galoisMatrix_eq_zero_of` (using invariance of the
  `t i`), and `tensorFromPi` is surjective.

**Remaining for full G2** (this session closed only the algebraic heart `G2(b)`; `G2(a)`/`G2(c)`
scheme-side are untouched): (a) orbit-in-affine hypothesis + gluing `Spec(A^Γ)` via
`Scheme.GlueData` (`galoisDescendScheme`); (c) the `Hom_k(T,X) ≅ Hom_{k'}(T_{k'},X')^Γ`
scheme-point statement. These consume the landed `descentEquiv` (Speiser) as the key module
input, exactly as the plan's `G2`→`G3` edge intends.

**No blueprint node yet** (campaign blueprint scaffolding for cluster `G` does not exist);
`descentEquiv`/`finrank_invariants` are genuinely new project mathematics available for a node
once the `sec:galois_descent` scaffolding is written. Nothing depends on the file in Lean yet
(no invisible-dependency risk).

---

## Part V — WAVE LANDINGS (run-0020 session 0010, T15, 2026-07-09)

**B0 field-of-constants residual — CLOSED (`HasTrivialConstants` now unconditional, axiom-clean).**
`Picard/SectionRingUniversal.lean` (leaf file, nothing imports it yet — isolated change,
kernel-green `lake build` 8558 jobs exit 0). New decls verified `[propext, Classical.choice,
Quot.sound]` (no `sorryAx`):

- `surjective_constMap_of_isAlgClosed_baseChange` — for a proper geometrically integral `C/k`
  and **any** algebraically closed field extension `K/k`, `k → Γ(C, 𝒪_C)` is surjective;
- `instHasTrivialConstants` — the **unconditional** global instance `HasTrivialConstants C`
  from `[IsProper C.hom] [GeometricallyIntegral C.hom]` alone (via `K := AlgebraicClosure k`).

This discharges the C3 residual: `globalSectionsAlgEquivBase : Γ(C, 𝒪_C) ≃ₐ[k] k` is now
**unconditional** (the `[HasTrivialConstants C]` binder auto-synthesises), the exact
field-of-constants input `B1`/`B3`-corollary/`B6`/`J1`/`G3` consume.

**Route (the standard proof, no new mathlib gap needed).** The degree-0 H⁰ flat base change
`Γ(Spec K, 𝒪) ⊗_{Γ(Spec k,𝒪)} Γ(C, 𝒪) ≅ Γ(C_K, 𝒪)` is **already in Mathlib v4.31** —
`AlgebraicGeometry.isIso_pushoutSection_of_isQuasiSeparated_of_flat_right`
(`Mathlib/AlgebraicGeometry/Morphisms/Flat.lean`), the qcqs `pushoutSection` engine. Over the
field base `Spec k` the base-change morphism `Spec K → Spec k` is **automatically flat** (the
`[Subsingleton Y] [IsIntegral Y] ⟹ Flat` instance, `Flat.lean:110`), and `C` is qcqs
(proper). The `≃ₐ` is assembled exactly as `Mathlib/AlgebraicGeometry/Normalization.lean:631`
(`isPushout_tensorProduct`.flip.isoPushout ≪≫ `pushout.congrHom` ≪≫ `asIso`). A `finrank`
count over `Γ(Spec K,𝒪)` (`Module.finrank_baseChange` + `Algebra.finrank_eq_one_iff_bijective_algebraMap`),
using the already-landed `instHasTrivialConstants_of_isAlgClosed` on `C_K` for `finrank = 1`,
forces `dim_{Γ(Spec k,𝒪)} Γ(C,𝒪) = 1`. **Correction to C3:** no scheme-level H⁰ base-change
brick had to be built from scratch — Mathlib's `pushoutSection` already provides it. The
whole argument stays in the `Γ(Spec ·, 𝒪)`-ring world via the project's `MulEquiv.isField`
Field-transport idiom (no `k`-vs-`Γ(Spec k)` scalar transport).

**Recipe notes (v4.31, for reuse):** the `Normalization.lean` `e`-template needs the
`isPushout_tensorProduct` ring args passed **explicitly** (`..`-inference fails to invert
`ofHom (algebraMap ?) = f.appTop`); `algebraize` via `.appTop` (not `.app ⊤`) so the induced
`Algebra` carriers read `Γ(X,⊤)` (declared type) rather than `Γ(X, f⁻¹ᵁ⊤)`, matching
downstream `↥Γ(·,⊤)` forms; `f ⁻¹ᵁ ⊤ = ⊤` and `appTop = app ⊤` are `rfl`, removing all
preimage-transport bookkeeping. `set_option backward.isDefEq.respectTransparency false` scoped
per declaration.

**Reusable brick extracted (item iv delivered):** `globalSectionsBaseChangeAlgEquiv`
(`SectionRingUniversal.lean`, axiom-clean `[propext, Classical.choice, Quot.sound]`) is the
standalone H⁰ flat base-change iso for the structure sheaf — for a **qcqs** `k`-scheme `X`
(`[CompactSpace X] [QuasiSeparatedSpace X]`) and **any** `k`-algebra `A`, a
`Γ(Spec A,𝒪)`-algebra iso `Γ(Spec A,𝒪) ⊗_{Γ(Spec k,𝒪)} Γ(X,𝒪) ≅ Γ(X ×_k Spec A, 𝒪)`. The
tensor's non-canonical `Algebra` instances are supplied via `letI`-in-return-type (they come
from the `appTop`/`appLE` section maps); consumers `B2`/`B4`/`B5`/`D2'` that need degree-0
section base change over the constant curve can call it directly. Nothing consumes B0 in Lean
yet (B1 rigidification unwritten), so no invisible-dependency risk.

---

## Part VI — WAVE LANDINGS (run-0020 session 0014, T15, 2026-07-09)

**B1 sheaf-level H⁰ base change brick + `lm:aut` — LANDED (unconditional for ALL `T`, axiom-clean).**
New file `Picard/StructureSheafPushforward.lean` (~370 LOC), imported into the aggregator
(`AlgebraicJacobian.lean:51`); full `lake build AlgebraicJacobian` green (8691 jobs, exit 0); all
headline decls verified `[propext, Classical.choice, Quot.sound]` (no `sorryAx`). This is the
highest-fan-out B1 sub-brick a 4-agent feasibility recon (this session) selected: the
**degree-0 cohomology-and-base-change** statement generalising B0 from affine `T` to arbitrary `T`.

Content (`namespace AlgebraicGeometry.Scheme`, `{k}[Field k]`; `π := pullback.snd C.hom πT`):
- **P1 (affine base):** `bijective_snd_appTop_baseChange C A` and its generalisation to ANY affine
  base scheme + ANY structure map `bijective_snd_appTop_of_isAffine C (h : W ⟶ Spec k)`
  (`[IsAffine W]`) — `Γ(W,𝒪) → Γ(C ×_k W, 𝒪)` bijective. Proof: B0's `globalSectionsBaseChangeAlgEquiv`
  gives `Γ(W)⊗_{Γ(Spec k)}Γ(C) ≅ Γ(C×W)`; `Γ(C,𝒪)=k` (`globalSectionsAlgEquivBase`,
  `bijective_hom_appTop`) collapses the right factor so `includeLeft = algebraMap` is bijective; its
  `commutes'` identifies `π.appTop`. Any affine `W` via `W.isoSpec` + `Spec.map_preimage`.
- **P2 (arbitrary base — THE brick, UNCONDITIONAL):** `isIso_snd_appTop C πT :
  IsIso ((pullback.snd C.hom πT).appTop)` for ANY `T : Scheme.{u}`. Route: `isIso_snd_app_of_isAffineOpen`
  (per affine open `V`, `IsIso (π.app V)` — P1 at base `V.toScheme`/struct map `V.ι ≫ πT`, transported
  via `pullbackLeftPullbackSndIso` (pasting) + `pullbackRestrictIsoRestrict` + `morphismRestrict_appTop`
  + `isIso_comp_right_iff` + `Scheme.Opens.ι_image_top`), then STALK ASSEMBLY: package `π.c` as a
  `TopCat.Sheaf CommRingCat` hom `𝒪_T ⟶ π_*𝒪_{C×T}`, apply per-affine-open iso over
  `T.isBasis_affineOpens`, `stalkFunctor_map_injective_of_isBasis` + germ-lift ⟹ all stalk maps
  bijective ⟹ `app_isIso_of_stalkFunctor_map_iso α ⊤` (⊤-component defeq `π.appTop`). Mirrors
  `QuotScheme.isIso_sheaf_of_isIso_app_basicOpen` but on the affine-opens basis. Gate
  `HasStructureSheafPushforwardIso` retained as a lightweight interface, discharged unconditionally
  by `instHasStructureSheafPushforwardIso`.
- **P3 (`lm:aut`, Kleiman §2):** `retraction_appTop_of_section` (a section `σ` of `π` retracts
  `π.appTop`) + `eq_one_of_section_of_restrict_eq_one(_of_gate)`: a global function on `C×T` rigidified
  to `1` along `σ` is `1`. Unconditional for arbitrary `T`. This is the automorphism-rigidity heart
  of B1: a line-bundle automorphism restricting to `id` along the `x₀`-section is `id`.

**Consumers now unblocked:** B1's remaining `RigidifiedPic`/lm:fff/lm:idn/full `IsZariskiSheafOver`
(the sheaf brick + lm:aut are the load-bearing inputs), and B3/B6/J1/G3 whenever they need degree-0
section base change (they mostly work over AFFINE noetherian bases, which the P1 form already covered;
the arbitrary-`T` P2 form is what the Zariski sheaf axiom itself needs). Recipe notes: the affine-base
P1 trick — *any* `S`-alg iso `S⊗_R M ≃ₐ[S] S` forces `algebraMap S (S⊗M) = ε.symm` bijective, built
from `Γ(C)≅k` via `Algebra.TensorProduct.congr` + `rid`; `set π := …` breaks `rw` under the dependent
`pullback.snd π V.ι` type (close the pasting square with the `_hom_snd` simp instead); `op` not in
scope, use `Opposite.op`. `CompactSpace`/`QuasiSeparatedSpace C.left` are NOT auto — derive from
proper via `QuasiCompact.compactSpace_of_compactSpace` / `quasiSeparatedSpace_of_quasiSeparated`.

**No blueprint node yet** (would dangle — no downstream `\uses` consumer node until B1's Zariski-sheaf
or RigidifiedPic node exists; same reasoning as B0). `instHasPicScheme` remains a single `⟨sorry⟩`
(`FGAPicRepresentability.lean:317`) — this is one milestone of the ~30; not closed.

---

## Part VII — WAVE LANDINGS (run-0020 session 0018, T15, 2026-07-09)

**B1 `lm:fff` (rigidified representative exists) — LANDED (axiom-clean); `lm:aut` faithfulness half landed; surjectivity blocked.**

New file `Picard/RigidifiedPic.lean` (~150 LOC, imported into the aggregator; all headline decls
verified `[propext, Classical.choice, Quot.sound]`, no `sorryAx`). This is the natural consumer of
the s0014 B1 brick (`StructureSheafPushforward` sheaf-level H⁰ base change + ring-level `lm:aut`),
selected by a 4-agent substrate-mapping recon this session:

- `sectionPullbackProjIso σ hσ N : σ^*(π_T^* N) ≅ N` — the section base-change iso for a section
  `σ` of the projection `π_T = pullback.snd πC πT` (the `pullbackComp ≪≫ pullbackCongr hσ ≪≫ pullbackId`
  chain, mirroring `LineBundle.pullback_pullback_eq`). General `{S C T}`, no curve hypotheses.
- `Rigidification σ L` — structure carrying a trivialisation `σ^* L ≅ 𝒪_T`.
- **`exists_rigidification_relPicRel σ hσ L`** (Kleiman `lm:fff`): every `L : OnProduct πC πT` is
  `H_T`-equivalent (`PicSharp.relPicRel`) to the rigidified twist `L' = L ⊗ π_T^*((σ^*L)⁻¹)`. The
  canonical rigidification of `L'` is `pullbackTensorIsoOfLocallyTrivial ≪≫ tensorObjIsoOfIso (refl) (sectionPullbackProjIso) ≪≫ eN`
  where `eN` is the tensor-inverse iso from `Modules.exists_tensorObj_inverse`; the `H_T`-witness is
  `tensorObj_braiding` with `N := (σ^*L)⁻¹`. Fully general (no `[HasRationalPoint]`/curve hypotheses;
  works for any section of the projection).
- `rationalPointSection πT x₀ hx₀ = pullback.lift (πT ≫ x₀) (𝟙 T) _` + `rationalPointSection_comp_snd`
  (`= pullback.lift_snd`): the projection-section from a rational point `x₀` of `C`, matching the
  hypothesis shape of the `StructureSheafPushforward` `lm:aut` lemmas. Parametrised by explicit
  `x₀` (NOT `[HasRationalPoint]`) to keep the file upstream of / independent from
  `FGAPicRepresentability` (and its `instHasPicScheme` sorry).

**`lm:aut` faithfulness half** — new file `Picard/ScalarEndFaithful.lean` (imports `GrassmannianQuot`
for its `scalarEnd`; axiom-clean):
- `scalarEnd_injective : Function.Injective (scalarEnd (X := X))` — scalar endos of `𝒪_X` are
  faithful; recovered by evaluating at the unit section `1` over `⊤` (via `scalarEnd_val_app_one`
  + `Subsingleton.elim ((homOfLE le_top).op) (𝟙 (op ⊤))` + `Functor.map_id` + `ConcreteCategory.id_apply`).
- `scalarEnd_eq_one_iff : scalarEnd a = 𝟙 ↔ a = 1` — the identity-rigidity criterion.

**REMAINING for geometric `lm:aut`** (next session, precise route):
1. **Surjectivity `scalarEnd_self : scalarEnd (χ.val.app (op ⊤) 1) = χ`** (every endo of `𝒪_X` is
   scalar) — reduces to `unitHomEquiv.injective` + `unitHomEquiv_scalarEnd` + `sections_ext` +
   `SheafOfModules.unitHomEquiv_apply_coe` + `PresheafOfModules.naturality_apply` +
   `PresheafOfModules.unit_map_one`. BLOCKED on the `(SheafOfModules.unit R).val` vs
   `PresheafOfModules.unit R.obj` coercion wall: `rw`/`simp` cannot fire `unit_map_one` under the
   `ConcreteCategory.hom` wrapper of `χ.val.app`, and the `.val`-rewrite motive is not type-correct
   (dependent). Way through: a `SheafOfModules`-level `unit_map_one` restatement, or a `conv`/`@[congr]`
   route. The naturality identity itself (`naturality_apply`) elaborates fine; only the `map 1 = 1`
   collapse stalls.
2. **End(L) ≅ End(unit) bridge**: conjugate `φ : L ≅ L` through `Modules.exists_tensorObj_inverse`
   (`e : L ⊗ L⁻¹ ≅ 𝒪`) to `χ := e.inv ≫ (φ ⊗ 𝟙) ≫ e.hom : End(𝒪_{C×T})`; injective (⊗L⁻¹ faithful).
3. **Pullback-of-scalarEnd compatibility** (hardest, ~50–100 LOC): `σ^*(scalarEnd u) ≅ scalarEnd(σ.appTop u)`
   under `pullbackUnitIso`, so the rigidified condition `σ^*φ = id` gives `σ.appTop u = 1`, then the
   ring-level `lm:aut` (`eq_one_of_section_of_restrict_eq_one_of_gate`, unconditional for arbitrary T
   under `[IsProper][GeometricallyIntegral]`) gives `u = 1`, and (1)+(2) give `φ = id`.

**No blueprint node yet** for `lm:fff`/`sectionPullbackProjIso`/`scalarEnd`-faithfulness (would dangle —
same B0/B1 reasoning; author under a `sec:rigidification` node when the Zariski-sheaf consumer
(`IsZariskiSheafOver (picSharp C)`) lands, which is the natural downstream `\uses`). `instHasPicScheme`
still `⟨sorry⟩` — one milestone of the ~30.

---

## Part VII — WAVE-1′ LANDINGS (run-0019 interactive session, 2026-07-09; 6 lanes, all green)

All files kernel-green, axiom-clean (`[propext, Classical.choice, Quot.sound]`, no sorryAx), registered in the root aggregator (full build 8701 jobs, exit 0).

**B3 pinned + scaffolded (`Picard/RigidPushforward.lean`, 738 LOC; commits `cb4a125aee`/`265bd321e8`/`bebc37f75d`).** Fibrewise vocabulary P2-independent (`Hom.fiberH0`, ∃-form `Hom.FiberH1Vanishing` on 2-affine Čech covers); pins `RigidPushforwardLocallyFree` (rank = fiberH0 = χ) + `RigidPushforwardBaseChange` (∀ ring maps, tautological-square form); gate `HasRigidPushforward` (NO instance); rank-one corollary PROVED from the gate (`LineBundle.isLocallyTrivial_of_pointwise_free_one`); ℙ¹-reduction skeleton fully proved: finite `C_A → ℙ¹_A` base change, `q_* ≅ p_*∘π_*`, 2-chart cover, and `rigidPushforwardLocallyFree_of_p1` = "B3 for C_A ⟸ B3 for ℙ¹_A + finite pushforward", sorry-free modulo 4 NAMED transfer hypotheses (π_*-coherence, π_*-base-flatness, fibrewise h⁰/h¹ transfer — Stacks 01XZ/02KE dévissage; wave-2 target). CORRECTIONS: f.g. k-algebras ARE Jacobson (all-scheme-points pin justified by B2/noetherian-extension reasons instead); B0's `globalSectionsBaseChangeAlgEquiv` does NOT supply the L-twisted base-change clause (structure sheaf only).

**B5 pinned, closed direction proved (`Picard/SemicontinuityH0.lean`; commit `a4b41ff88f`).** Gate `HasH0Semicontinuity` (open direction); `{n ≤ h⁰}` closed derived as exact complement — ONE gate suffices for both directions (plan implied two engines; corrected).

**G2 scheme-side (a)+(c) (`Picard/GaloisDescent/SemilinearAlgebras.lean` 387 LOC `35a20d251f`; `Picard/FiniteGaloisQuotient.lean` 547 LOC `d32714dcb3`).** Speiser upgraded to algebras: `descentAlgEquiv : L ⊗[K] A^Γ ≃ₐ[L] A` (no Noether finiteness); `(L⊗[K]B)^Γ = B`; `invariantAlgHomEquiv` (affine Hom property, all K-algebras B). Scheme layer: `SemilinearGalAction` (squares over Spec γ; conventions VALIDATED by the compiling affine model), pullback action + naturality, `OrbitsInAffineOpen` (Hironaka-trap audit recorded), `IsGaloisQuotient` predicate with the universal T-points clause, gates `HasStableAffineCover`/`HasGaloisQuotient` (no instances; discharge recipes in docstrings), and the PROVED scheme-level affine Hom property `affineGaloisQuotientHomEquiv`.

**D1′+A2 (`Picard/DivDegree.lean`, 710 LOC; commit `e88443887e`).** `DivFamily.fiberDeg` (colength of O_D at t, Kleiman ex:DivC) with Rel-invariance + base-change stability through the twist-free 02KH i=0 core (dodging the sorried tensor leaf); fibre Cartier SES + colength-d degree ledger for `ker q` ([D] ↦ −[ker q] sign audit recorded); clopen degree decomposition hypothesis-parametrized behind instance-free `HasLocallyConstantDivDeg`; `abelDeg d = ι ≫ abelMapWitness` with `rfl` defining property.

**GENUS BREAKTHROUGH — degree-1 affine vanishing CLOSED, no gate (`Cohomology/StructureSheafModuleK/SectionsBridge.lean` ~520 LOC `f1a04e1194`; `AffineDegreeOneVanishing.lean` 727 LOC `b6b1bced23`).** `HModule'_zero_sectionsLinearEquiv : H⁰(U,F) ≃ₗ[k] Γ(U,F)` on any site + BOTH naturality companions (MV degree-0 corners; second-variable Ext-LES rungs). Then `Scheme.subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen`: `H¹(U, 𝒪_C) = 0` for EVERY affine open of EVERY Spec-k-scheme — dimension shift through an injective embedding + finite basic-open lifts + the 01EW splitting brick + sheaf gluing. No properness/noetherian/curve hypotheses. This closes the Part-III C2 bottleneck at degree 1 (the i ≥ 2 clauses of `IsAffineHModuleVanishing` remain open and are NOT needed for genus; consumers should use the degree-1 statement directly). Remaining for unconditional genus: the MV (0,1)-slice assembly `HModule 1 ≃ H1Cok S` → keystone (wave-2 lane).

**Audit dossier (W1-F, read-only).** Highlights: functor-level overlap/relation objects must be pinned POINTWISE (not `Limits.pullback`); J4's separably-closed detour confirmed necessary (genus-2/ℚ sketch); D3′ needs the ∃!-clause extension of `flatLocusStratification_universal` over nontrivial π; B2 is stale-pessimistic — mathlib engines EXIST; NEW: `HasDedekindChart` + `IsConstantField` are undischarged adelic gates missing from the Part-II gate table — `IsConstantField` nearly free via B0's `globalSectionsAlgEquivBase`; line drifts recorded (instHasPicScheme now :313/:317).

## Part VIII — WAVE-3 LANDINGS (run-0022 interactive session, 2026-07-10; 5 lanes, all adversarially verified)

All kernel-green and axiom-clean; registered in the root aggregator (full build 8709 jobs, exit 0). Precondition banked first: the two wave-2 orphans were repaired and landed — **genus keystone** `Adelic.instModuleFiniteHModuleOne` (`RiemannRoch/Adelic/GenusUnconditional.lean`, commit `7dc611b7d1`; `Module.Finite k H¹(C,𝒪_C)` gate-free, plus the cover-independent bridge `hModuleOneEquivH1Cok_curve`) and the **B2 brick** (`Picard/FinitePresentationFunctor.lean`, `d69fd1a472`, FGDescent kit + Div consumers, field-injectivity strengthening recorded).

**W12 tangent space REDUCED to one dimension identity (`Picard/Pic0TangentSpace.lean` new 184 LOC sorry-free + `Pic0AbelianVariety.lean`; commits `d6f5453331`/`b2d254a8cc`/`7add8787b4`/`d8b21e04ab`).** `Pic0.tangentSpaceIso` (Kleiman 5.11) now has a single sorry site = `finrank κ(e) (m_e/m_e²) = finrank k H¹(C,𝒪_C)`, fed to the PROVED reduction `nonempty_cotangentSpaceAddEquiv_of_finrank_eq` (finite-dim double-dual + κ(e)≅k transport). New proved connectors: `Subsingleton (PrimeSpectrum k[ε])`, open-immersion transport of pointed dual-number points, and `pointedDualNumberPoints_equiv_picScheme` (T_e Pic⁰ = T_e Pic through the identity-component open immersion; the inclusion ι is existentially quantified — future legs must re-obtain the SAME ι). ⚠ For the remaining legs (representability kernel + truncated-exponential Čech cocycle): carry κ(e)-(semi)linear structure or explicit finrank chains — a bare type `Equiv` does NOT determine finrank over an infinite field. Hygiene: stale run-0008 status headers corrected.

**B3 transfer (a)+(b) DISCHARGED (`Picard/RigidPushforwardTransfer.lean` new 674 LOC; commits `8e61c82334`/`38f0f5e13f`).** `hfp` and `hflat` of `rigidPushforwardLocallyFree_of_p1` discharged VERBATIM (consumption probe compiled by the verifier): `pushforward_finiteMapToP1BaseChange_isFinitePresentation` + `_coherentSheafFlat`. New reusable engine: `Modules.isFinitePresentation_of_finite_sections` (noetherian coherence criterion: qcoh + locally noetherian + finite sections ⟹ IsFinitePresentation). Item (c) substrate landed (fibre map `finiteMapToP1FiberMap` + IsPullback + IsFinite; definitional Čech bridges `moduleSectionDiff_pushforward` = rfl, naturality, surjectivity across isos); the remaining wall is the fibre-compatibility iso `(fiberι t)^* (π_A)_* L ≅ (π_t)_* (fiberι t)^* L` — Stacks 02KG for the affine π_A glued from `affinePushforwardPullbackBaseChange` over the 2-chart cover (κ(t) NOT flat over A — use the arbitrary-pushout brick, never the flat 02KE engine).

**B3 brick: two-term finite replacement LANDED with an AUDITED statement correction (`Picard/TwoTermFiniteFree.lean` new; commits `f4e52f6b70`/`52e223f70c`).** Mumford AV II §5 Lemma 1: `TwoTermFiniteReplacement` structure (K⁰ finite PROJECTIVE, k : K⁰ →ₗ A^n, H⁰/H¹ base-change isos for every A-algebra B) + `exists_twoTermFiniteReplacement` (A noetherian, M⁰/M¹ flat, ker/coker f.g.). ⚠ The classical "finite FREE K⁰" form is FALSE globally — Dedekind/Steinitz counterexample (nonprincipal ideal; universal H¹-comparison forces the split), independently re-derived by the verifier; projective is what B3's locally-free conclusion needs (stalkwise free via `Module.free_of_flat_of_isLocalRing`). Split-off corollary: fibrewise H¹ = 0 ⟹ the replacement differential surjects onto A^n split. Missing (deliberate): matrix-level minors API for B5 — needs LocalizedModule transport of the whole replacement (not cheap; next wave candidate). Bonus mathlib-gap bricks: `TwoTerm.flat_prod`, `cokerBaseChangeEquiv` (any B : Type v), Nakayama lid-descent `surjective_of_baseChange_self`.

**G2 affine quotient COMPLETE (`Picard/FiniteGaloisQuotientAffine.lean` new 590 LOC; commit `301029a228`).** `isGaloisQuotient_spec`: the affine model `specSemilinearGalAction` with `Y = Spec (A^Γ)` IS an `IsGaloisQuotient` — all three parts: base-change iso (pullbackSpecIso ∘ TensorProduct.comm ∘ descentAlgEquiv.symm, tensor-swap handled), affine T-points via `affineGaloisQuotientHomEquiv` transport, and the ∃!-clause extended to ALL schemes T via affine-cover gluing with affine-case uniqueness on overlaps. Gates `HasStableAffineCover`/`HasGaloisQuotient` remain instance-free. Reusable bricks: `pullbackSpecLIso`, `specRingEquivIso`, `pullbackBaseChange_comp` (@[reassoc]). Next G2 milestone: `HasStableAffineCover` discharge (prime avoidance + Galois norm; XL).

**P2 substrate COMPLETE (`RiemannRoch/CurveBaseChange.lean` new; commit `2dc474cef3`).** `Scheme.baseChangeField` (C_κ) with the full named Λ-stability package (audit item 14): `SmoothOfRelativeDimension 1`, `IsProper`, `GeometricallyIntegral` (audit item 6 CONFIRMED: the mathlib class = integral total space under every field-valued base change, so field-extension stability is mathlib-provided), `HasRationalPoint`, and the `instIsConstantField` hypothesis instances (`IsIntegral`/`IsLocallyNoetherian`/`IsRegularInCodimensionOne` — the last quantifying over ALL coheight-1 points). Cover base change `AffineCoverMVSquare.baseChangeField` reuses `preimage` (no duplication). Follow-up noted: NonconstantToP1.lean:975-996 inline haveI block can now consume these named instances.

## Part IX — WAVE-4 LANDINGS (run-0022 interactive session, 2026-07-10 afternoon; 5 lanes; one credit-cap wipe survived, resumed same run)

All kernel-green, axiom-clean, adversarially verified; registered (full build 8713 jobs). Two independent lanes converged on the SAME missing brick — see the convergence note at the end.

**G2(a) gate DISCHARGED (`Picard/StableAffineCover.lean` new 287 LOC; commit `fa6c94ffae`).** `hasStableAffineCover_of_orbitsInAffineOpen : HasStableAffineCover` under exactly `[FiniteDimensional K L] [IsGalois K L] [ρ.OrbitsInAffineOpen]` (core theorem needs only FiniteDimensional). The flagged-XL EGA II 4.5.4 wall collapsed in one session via the KEY TRICK: Γ-stability of `D(N) = ⋂_γ γ⁻¹D(s)` proved at the level of OPENS by reindexing the `Finset.inf` (γ ↦ γτ), never via section-transport of the norm; affineness from `D(N) ≤ D(s)` basic-open-of-affine — NO separatedness needed (gate docstring's assumption was superfluous). Reusable: `exists_basicOpen_le_of_finite` (finite prime avoidance in an affine open), `preimage_finset_inf`, `basicOpen_finset_prod`; `Finset.inf` not `iInf` for Opens (iInf takes interiors). G2 remaining: ONLY G2(c) `HasGaloisQuotient` gluing — now fully unblocked (stable covers + affine `isGaloisQuotient_spec`).

**W12 representability leg landed; sorry now a NAMED sub-lemma (`Picard/Pic0AbelianVariety.lean` + `Pic0DualNumberCocycle.lean`; commits `2918d02351`/`967e2b246f`).** `pointedDualNumberPoints_equiv_relPicKernel`: T₀ Pic⁰ = ker(Pic♯(Spec k[ε]) → Pic♯(Spec k)), axiom-clean over `[HasPicScheme C]`; Mumford ε↦aε scaling substrate (`DualNumber.scaleRingHom`, `overDualNumberScale`, `relPicKernelSMul` with `_one/_mul/_zero`; scalar-distributivity deliberately NOT claimed — falls out of the cocycle identification later). The W12 sorry is now `Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne` (:556). ⚠ POISONED-INHERITANCE CATCH: wave-3's `Pic0DualNumberCocycle.lean` "proved" claim was false — the file had NEVER compiled (12+ errors); now genuinely sorry-free. Recipes: `Over.Hom` is semireducible — `simpa`/`rw` fail on `.left` defeq, use `Over.OverMorphism.ext` + term-level `congrArg CommaMorphism.left`; never `closedPoint k` as a `.base` argument (use `default`); CommRingCat hom equalities via `← ofHom_comp` + RingHom lemmas, never `ext` (TrivSqZeroExt @[ext] derails). Remaining: the COCYCLE LEG (line bundles on C ×ₖ Spec k[ε] ↔ transition units in `Γ(U₁⊓U₂,𝒪)[ε]ˣ`, truncated exponential → H1Cok, k-linearity bookkeeping along κ(e) ≃+* k).

**B3 transfer: hH0 DISCHARGED — 3 of 4 hypotheses now closed; hH1 reduced to cover-independence (`Picard/RigidPushforwardTransfer.lean` → 1363 LOC; commits `165ab24f51`/`559949c209`).** NEW HEADLINE THEOREM: `isIso_pushforwardBaseChangeMap_of_isPullback` — Stacks 02KG (i=0) for AFFINE f along ARBITRARY (non-flat) g: the adjunction-mate `pushforwardBaseChangeMap` (FlatBaseChange.lean:91) is an iso. The recorded mate↔cancelBaseChange coherence wall (FlatBaseChange.lean:797-800) was DODGED: characterize the mate on adjunction-unit images only (homEquiv_counit + unit naturality + right triangle + Subsingleton-opens res-res collapse), extend by Γ(𝒪)-linearity over the Lane-F section-formula tensor generators. Corollary: `fiberPushforwardCompatIso : (p.fiberι t)^*((π_A)_*L) ≅ (π_t)_*((q.fiberι t)^*L)`, all scheme points. `pushforward_finiteMapToP1BaseChange_fiberH0` = hH0 VERBATIM (in-file consumption probe :1344, κ(t)-LINEAR transport, no FiniteType needed beyond the hfp inheritance). hH1: pinned-statement AUDIT — the hypothesis's existential cover points the wrong way (arbitrary cover of C_t vs the needed π_t-preimage cover); discharged MODULO the single `hindep` hypothesis = Čech-to-Čech cover-independence of Ȟ¹-vanishing for quasi-coherent modules on the fibre curve (`fiberH1Vanishing_…_of_coverIndependence`).

**B3 ℙ¹-engine: H¹-finiteness + Mumford endgame algebraic half (`Picard/RigidPushforwardP1Engine.lean` new 1280 LOC; 5 commits `64d51dc1f9`…`6e5e2afe8a`).** Base-linear Čech complex (`baseSectionsModule`/`moduleSectionDiffBase`, any family, any 2-affine cover), sheaf-condition kernel identification `Γ(X,M) ≃ₗ ker d`, `flat_baseSections_of_coherentSheafFlat` (consumes the pinned CoherentSheafFlat by direct application), A-coefficient two-lattice cores + Laurent-ladder producer → `module_finite_h1_p1BaseChange` (H¹ of the ℙ¹_A Čech complex f.g. over any f.g. k-algebra A, noetherian-free two-lattice argument), and `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing` (endgame: fibrewise h¹=0 ⟹ H⁰-formation base-changes + locally-free conclusion, on the TwoTermFiniteFree brick). ⚠ AUDITED HARD LEAF (docstring verdict): H⁰ finite generation over A is NOT derivable from the Laurent ladder (two-lattice intersection ≠ span/extension consequence); all classical proofs are Serre-finiteness-grade (twist global generation + LES + explicit O(n) cohomology — EGA III 3.2.1 / FAC §66 / Stacks 01YS). Consumed as the named hypothesis of the endgame. Candidate routes for the leaf: in-tree SerreTwist O(m) machinery (T14, sorry-free), graded Rees via the sectionGradedModule lanes, or ℙ¹-explicit degree bounds.

**P2 kit COMPLETE for this wave (`RiemannRoch/CohomologyKit.lean` new; commits `18794f5d4c`/`6cf8539707`; 37 decls).** κ-linear Čech carrier (`sectionDiffₗ`/`H0ₗ`/`H1Cokₗ` with the pinned Module.compHom scalar path), `h0/h1/chi` cover-parameterized, `globalSectionsEquivH0ₗ` (H⁰ = Γ via sheaf gluing — cover-independence of h0 for ALL M), `h1_unit_eq_genus` (genuine k-linear chain), `h0_unit_eq_one`, **`chi_unit_eq_one_sub_genus`: χ(𝒪_C) = 1 − g** — the first honest P3 χ-ledger anchor; base-change finiteness transport for 𝒪 at every field extension (Λ-package consumption). Explicitly out of scope & documented: general-M cover-independence, general-M finiteness, genus(C_κ) = genus(C).

**⚠ CONVERGENCE NOTE (wave-5 keystone).** B3-fibre's `hindep` and B3-engine's geometric fibre bridge are the SAME brick: **degree-1 Čech cover-independence for quasi-coherent modules on a separated 2-affine-coverable scheme**. Cheapest route: generalize `AffineDegreeOneVanishing` from 𝒪 to arbitrary quasi-coherent sheaves of k-modules (`H¹(U affine, M) = 0`, same dimension-shift proof shape), then `hModuleOneEquivH1CokOfSubsingleton` gives `H1Cok S ≃ H¹` for EVERY 2-affine cover at once — cover-independence for free, closing hH1 (→ full B3 transfer package) and the engine's fibre bridge simultaneously.
