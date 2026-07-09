<!-- Campaign plan for instHasPicScheme — synthesized 2026-07-09 by the run-0019 recon+design workflow (4 recon agents, 3 designs, judge). Route decision: D3 Milne–Kollár (section trick + finite Galois quotient + coproduct assembly), grafts from D1/D2. Wave tracking lives in T16 comments. -->
# FINAL — Campaign plan for `instHasPicScheme` (judge + synthesis, 2026-07-09)

Target: `instHasPicScheme` — `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:305-309` (verified this session: `⟨sorry⟩` body at :309; statement `∃ X, Nonempty ((picSharp C).RepresentableBy X) ∧ LocallyOfFiniteType X.hom ∧ IsSeparated X.hom` under `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] [HasRationalPoint C]`). Project paths relative to `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`; mathlib paths relative to `.lake-packages/mathlib/Mathlib/`.

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

**Feasibility 8.5 / Effort 8 / Risk 8.5**: maximal reuse of verified substrate (adelic `RiemannRoch/` lane — verified this session: the only genuine sorry in the lane is `RiemannRoch/WeilDivisor.lean:1281`; the `Cokernel.lean:133` / `CechAcyclicInstance.lean:73` grep hits are docstring text; plus `DivFunctor` `DivFunctorDef.lean:875`, `Grassmannian.representable` `GrassmannianRepresentability.lean:595-599`, mathlib coproducts `AlgebraicGeometry/Limits.lean:187/:224` (verified: `HasColimitsOfShape (Discrete σ) Scheme.{u}` + `CoproductsOfShapeDisjoint`), 01JJ `Sites/Representability.lean:207`, `sigmaDesc` `Morphisms/Basic.lean:303`, equalizer-closed `Morphisms/Separated.lean:356`). Its three XLs (P5, B3, G2) are **pairwise independent and all start by wave 2** — the best risk shape of the three designs. The B2 filtered-colimit brick is the correct systematic answer to the noetherian/arbitrary-`T` tension that D1 pushes into its engine statement and D2 leaves unresolved.

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
(i) Instances for `ExistsNonconstantMapToP1 C` (`RiemannRoch/Adelic/FiniteMapToP1.lean:437`, verified: class carries no instance, everything downstream to `HasFiniteMapToP1` is proved) and `P1HasLaurentChartData`; audit whether the `HasExt`-shaped inputs are already unconditional in `CechComparisonGate.lean:114-136`.
(ii) `RiemannRoch/Adelic/GateInstances.lean`. (iii) trdeg-1 function field; in-lane substrate. (iv) **M**. (v) 🔍 **AUDIT-FIRST**: kernel-build the whole `RiemannRoch/` closure before relying on "sorry-free" (memory lesson: verify inherited closures; the lane's only true sorry must remain `WeilDivisor.lean:1281`, off-path).

**P2 — h⁰/h¹/χ kit over all field extensions.**
(i) For every field κ/k and invertible `M` on `C_κ`: `h0 κ M`, `h1 κ M : ℕ` finite; pinned on the **Čech carrier** (`AffineCoverMVSquare`, `RiemannRoch/Adelic/Substrate.lean`) with cover-independence proved Čech-to-Čech (structurally avoids the `HasCechToHModuleIso` gate); flat-base-change stability `h^i(C_κ, M) = h^i(C_{κ'}, M_{κ'})`.
(ii) `RiemannRoch/CohomologyKit.lean`. (iii) P1; `GenusFiniteness.lean:64`. (iv) **L**. (v) 🔍 AUDIT: Λ-stability instances for `C_κ` (smooth proper geometrically integral over κ) + base-change of `AffineCoverMVSquare` — record as named lemmas, don't inline.

**P3 — Riemann–Roch χ-ledger.**
(i) `χ(M) = deg M + 1 − g` with `deg` the residue-weighted Weil degree (`RiemannRoch/WeilDivisor.lean:1047`); point-sequence induction from `χ(O) = 1 − g`; `M ≅ O(div s)` for `0 ≠ s ∈ H⁰` (integrality ⟹ regular section). Byproduct: closes the input to the `WeilDivisor.lean:1281` sorry (off-path bonus).
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

Order: P1 → (P5, B3, G2 in parallel) → D4' → J5 → G3 → G5. Final state: **zero campaign gates**; `HasRationalPoint` (:139) remains as an honest hypothesis; `HasSmoothProperQuotient` (:541) remains empty, unused, docstring-flagged. Off-path and untouched: Quot-lane sorries (`QuotRepresentability.lean:79`, `QuotFunctorDef.lean:464/:719`, `SerreFiniteness.lean:79/:262`), `WeilDivisor.lean:1281` (P3 may close it as a bonus).

### Wave-1 parallel work list (6 agent tasks)

**W1-A — Adelic gate discharge + closure certification (P1).**
Do: kernel-build `RiemannRoch/` (`lake build`, check PIPESTATUS); prove the `ExistsNonconstantMapToP1` instance (trdeg-1 nonconstant function); assess/finish `P1HasLaurentChartData`; audit `CechComparisonGate.lean:114-136` for conditionality.
Accept: instances compile axiom-clean (`lean_verify`); a note listing every remaining gate in the lane with file:line; confirmation the only sorry is `WeilDivisor.lean:1281`.

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
