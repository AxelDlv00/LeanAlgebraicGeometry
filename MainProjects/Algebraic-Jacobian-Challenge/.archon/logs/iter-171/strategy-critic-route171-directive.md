# Strategy Critic Directive

## Slug
route171

## Iter
171

## Re-dispatch context

iter-170 verdict was CHALLENGE on Route A (effort honesty + parallelism under-exploited + infrastructure-deferral) and SOUND on Route C. The iter-170 plan absorbed format edits (3) + per-sub-phase LOC/iter audit in `Jacobian.tex`. **Still live as of iter-170 end**: parallelism (Route A still serialised behind genus-0 in the planner's behaviour) + infrastructure-deferral inside both Route A and the RR-bridge.

iter-171 STRATEGY.md update absorbs the still-live findings:
- Route A row split into 4 rows (A.1 / A.2 / A.3 / A.4), each prover-ready-decomposed this iter via blueprint-writer dispatches.
- RR-bridge row changed from "deferred to upstream Mathlib" to "in-tree sub-build COMMITTED iter-171", with 4 sub-phases per `analogies/rrbridge-survey.md` option (1).
- New "Refactor — AVR split" row (1-iter housekeeping lane).

Re-audit the UPDATED STRATEGY.md (verbatim below) and verify the previous CHALLENGE on Route A is now addressed. Also verify the in-tree RR sub-build commitment is mathematically sound (vs the "defer upstream" alternative).

## Current STRATEGY.md (verbatim)

```markdown
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese / Jacobian
object uniform over the $k$-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with **no** `C(k) ≠ ∅` hypothesis on the protected
signature. End-state: zero inline `sorry`, kernel-only axioms.

The protected signature quantifies over arbitrary `C` with no $C(k) \neq \emptyset$
assumption. The witness OBJECT `J` is always real (constructed unconditionally);
only `isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. The spine is
**pointed vs. unpointed**, not genus-0 vs. positive. `genus C := dim_k H^1(C,O_C)`
(arithmetic genus; protected — cannot be re-typed).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **Route A.1 — Relative Picard / line-bundle pullback** (CRITICAL PATH; parallel-startable) | per-sub-phase decomposition in `Jacobian.tex`; iter-171 commits to splitting A.1 into A.1.a `RelativeSpec` + A.1.b `LineBundle.Pullback` + A.1.c `RelPic functor` (each ≤500 LOC, prover-ready file-skeleton lanes from iter-172) | ~6–10 | ~700–1100 · ~0/it | `RelativeSpec` functor (absent in Mathlib); line-bundle pullback on `C×T`; ét-sheafification (present) | smallest entry; first lane fires iter-172 once a sub-chapter clears HARD GATE |
| **Route A.2 — Hilbert/Quot + FGA `Pic_{C/k}` representability** (CRITICAL PATH; dominant block) | per-sub-phase decomposition landed in `Jacobian.tex`; flattening stratification + Quot construction are the two sub-builds, each ≤1500 LOC | ~15–25 | ~2200–3000 · ~0/it | `HilbertScheme`/`QuotScheme` (absent); cohomology-and-base-change Stacks 02KH (partial Mathlib) | A.2 representability is the riskiest, least-Mathlib piece; project-fatal if it stalls |
| **Route A.3 — `Pic⁰` identity component + degree map** (CRITICAL PATH) | per-sub-phase decomposition in `Jacobian.tex`; identity-component construction + locally-constant pushforward | ~5–8 | ~600–900 · ~0/it | `GroupScheme.IdentityComponent` (absent); `LocallyConstantPushforward` (absent); Mathlib `Group/{Smooth,Abelian}.lean` anchors | gated on A.2's `Pic_{C/k}` but blueprint-side decomposition can start in parallel |
| **Route A.4 — Albanese UP of `Pic⁰`** (CRITICAL PATH) | Milne III §6 (~3 pages); reuses in-tree Rigidity Lemma + Cor 1.2/1.5; no new Mathlib namespace | ~7–11 | ~900–1200 · ~0/it | seesaw / Picard-functor functoriality | gated on A.1+A.3 but blueprint-side can start now (consumes already-proven assets) |
| **genus-0 rigidity** — `gmScalingP1` body + collapse-at-zero | scaffold iter-165; body inline chart-glue committed iter-170 (option (c) per `routefork170`); body-first test never RAN iter-170 (API-500); iter-171 re-attempts | ~3–5 | ~200–270 · ~80/it | chart-glue via `Scheme.Cover.glueMorphisms` + `pullbackSpecIso` + `Proj.fromOfGlobalSections`; `Algebra.compHom` instance bridge per `tensoraway-instance.md` | LOC over-runs an iter-cap risk; cocycle agreement on `D₊(X 0·X 1)` is the structurally novel step |
| **genus-0 RR bridge** — `genusZero_curve_iso_P1` (in-tree sub-build COMMITTED iter-171) | iter-171 commits to in-tree RR sub-build per `rrbridge-survey.md` option (1): 4-sub-phase decomposition (RR.1 `WeilDivisor` on a scheme, RR.2 RR-formula on a genus-0 curve, RR.3 `\mathcal{O}_C(P)`-global-sections argument, RR.4 "rational ⟹ ≅ ℙ¹") — each landed as a sub-chapter ready for prover scaffolding from iter-172 | ~12–20 | ~1500–2500 · ~0/it | divisor/RR/Pic at scheme level (all absent in Mathlib — to be built in-tree, exportable as Mathlib PRs) | the 4 sub-phases are mutually serial; RR.1 is the lone parallel-startable entry |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated | 3–5 | 350–850 · gated | terminal cluster on `Spec k`; faithfully-flat descent of a morphism equality along `Spec k̄ → Spec k` | descent direction unconfirmed; skeleton 6/7 fields closed, only the `key` rigidity equation open |
| `nonempty_jacobianWitness` genus-stratified body | gated | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |
| **Refactor — `AbelianVarietyRigidity.lean` split** (HOUSEKEEPING; iter-171 lane) | iter-171 splits the 1198-LOC AVR into `RigidityLemma.lean` (Mumford chain + Cor 1.5 + Cor 1.2, axiom-clean) + `AbelianVarietyRigidity.lean` (genus-0 final assembly, the 2 gated sorries); G0BO refactor deferred to iter-172 (avoid contention with the active body-first test) | 1 | ~1198 redistributed | none — pure file-move | low; verified import boundary is L884/L1093 |

## Routes

The positive-genus OBJECT is built by **Route A (Picard scheme via FGA)** —
mandatory and essentially unavoidable. The genus-0 arm is a separate, lower-risk
rigidity statement (object trivial); its base-case proof route is **Route C (Milne
§I.3 rigidity completion)**, chosen because Milne §I.3 + §III.6 derive both the
genus-0 base case AND Route A's Albanese UP cube-free, and a Mathlib-support survey
found Route C far less blocked than the differential route.

### Route A (COMMITTED, parallel-decomposed iter-171) — Picard scheme / Albanese via FGA

Hilbert/Quot representability + identity-component `Pic⁰` + Albanese universal
property. Decomposition A.1–A.4 in `Jacobian.tex` § "Route A". Literature in-tree:
`references/kleiman-picard.pdf` (§4 existence, §5 `Pic⁰`), `references/nitsure-hilbert-quot.pdf`
(Quot/Hilbert engine). **Positive-genus arm:** `J := Pic⁰_{C/k}`, a dim-`g`
abelian variety; the Albanese UP gives `isAlbaneseFor`. Critical path: the object
must be a real dim-`g` abelian variety even when `C(k)=∅`, so the FGA engine is
required unconditionally.

**iter-171 parallel commitment.** A.1, A.3, A.4 are each blueprint-decomposed
this iter into prover-ready sub-chapters (~500 LOC sub-blocks), opening
parallel lanes from iter-172 onward (rather than the previous "serialise behind
genus-0 stack" stance which the strategy-critic iter-170 challenged). A.2's
flattening stratification + Quot construction is the dominant ≤1500-LOC block
that itself decomposes into prover-ready sub-chapters; A.2 sub-decomposition
follows iter-172. The genus-0 stall is no longer the gate for Route A work.

### Route C (COMMITTED) — genus-0 rigidity completion via Milne §I.3

The genus-0 witness OBJECT is the trivial `J = Spec k` (skeleton 6/7 closed); it
needs **no** Picard scheme. Remaining content: over `k̄`, every pointed `f : C → A`
from a genus-0 curve to an abelian variety is constant. The **Rigidity Lemma**
(Mumford Form I = Milne Rigidity Thm 1.1) is PROVEN axiom-clean and is the
foundation of this route, together with the proven **Cor 1.5** (additivity) and
**Cor 1.2** (AV maps are homs). The base case `ℙ¹→A const` is reached by the **`𝔾_m`-scaling shortcut** — NO theorem of
the cube, NO Thm 3.2/Lemma 3.3, NO Auslander–Buchsbaum, NO `Hom(𝔾_a,A)=0`, NO
differentials/Frobenius; char-general; uses only the already-proven Cor 1.5 + density.
Chain:

- **`σ_× : ℙ¹ × 𝔾_m → ℙ¹`** the `𝔾_m`-scaling action `(x,λ)↦λx`: a TOTAL scheme morphism
  fixing the point `0`. The only genuinely new ingredient. Needs concrete ℙ¹ and 𝔾_m as
  group objects over `Spec k̄`.
- **`h := σ_× ≫ f`**; normalise `f(0)=η`. Apply `hom_additive_decomp_of_rigidity`
  (**Cor 1.5**, first-factor-only-proper) with `V=ℙ¹` (proper), `W=𝔾_m`, base points
  `0,1`: the W-axis restriction `λ↦f(λ·0)=f(0)=η` COLLAPSES (0 is a scaling fixed point),
  so the decomposition degenerates to `σ_× ≫ f = pr₁ ≫ f`, i.e. `f(λx)=f(x)`.
- At `x=1`: `f|_{𝔾_m}≡f(1)` constant; **density** of `𝔾_m` in `ℙ¹` + `A` separated
  (`ext_of_isDominant`, present, used by `rigidity_core`) ⟹ `f` constant.
- **genus-0⟹ℙ¹** (RR bridge, Hartshorne IV.1.3.5) — shared, no Mathlib RR.

Why no Thm 3.2 / no `Hom(𝔾_a,A)=0`: the apparent Thm-3.2 circularity was illusory (it
conflated the base case with Milne's *general* Thm 3.4 for a NON-complete source); here
`f` is already total on the complete `ℙ¹`. The `𝔾_a`-additive route (`f(x+y)=f(x)+f(y)`
then `Hom(𝔾_a,A)=0`) was a stepping-stone but `Hom(𝔾_a,A)=0` standalone needs "image of a
group hom is a closed subgroup" (a Mathlib gap as deep as Thm 3.2); the `𝔾_m`-scaling
shortcut sidesteps it by exploiting the scaling fixed point so Cor 1.5 degenerates
directly. The full Thm 3.2 / codim-1 extension is now a **Route-A-only** item (Albanese
UP), off the genus-0 path. Survey: `analogies/route-support.md`, `analogies/thm32-extend.md`.

### Off-path fallbacks (kept in tree, NOT pursued)

- **(c-hybrid) differential + Frobenius**, **(c-cube) theorem of the cube**, **(b)
  `dim Pic⁰=0` byproduct of Route A**, **(a) Serre-duality `df=0`** (artifact:
  `rigidity_over_kbar` `[CharZero]` in `RigidityKbar.lean`). All rejected/superseded
  in favour of the direct `ℙ¹×𝔾_a` argument.

## Open strategic questions

- **Route A representability scheduling.** A.1–A.4 (esp. A.2 Quot/Hilbert repr)
  remain the dominant positive-genus cost. Per-sub-phase LOC + iter estimates landed
  iter-170 in `Jacobian.tex`. Schedule blueprint decomposition in parallel with the
  genus-0 prover lane; HARD GATE blocks a prover until the relevant chapter is
  complete+correct. Smallest entry point: `RelativeSpec` ~700–1100 LOC.
- **`k̄→k` descent is route-dependent**, not a fixed cost: a `Pic⁰`-over-`k` argument
  may give `Alb(C)=Spec k` directly (no descent); a `C_k̄≅ℙ¹` argument incurs the
  faithfully-flat descent of a morphism equality (direction unconfirmed).
- Should the chart-algebra envelope + GrpObj cotangent material be split out of the
  large `RigidityKbar.tex` into a dedicated off-path chapter (structural job)?

## Mathlib gaps & new material

**Gaps to fill (CRITICAL PATH — Route A engine, positive-genus object):**

- **A.1** Relative Picard functor + relative-line-bundles theory. ~700–1100 LOC.
- **A.2** Hilbert/Quot scheme representability + FGA `Pic_{C/k}` representability
  — the single highest-cost build. ~2200–3000 LOC.
- **A.3** identity-component subgroup scheme `Pic⁰ ⊆ Pic`; degree map `Pic → ℤ`.
  ~600–900 LOC.
- **A.4** Albanese universal property of `Pic⁰` (`isAlbaneseFor` for `g ≥ 1`):
  reuses the in-tree Rigidity Lemma + Cor 1.2/1.5. ~900–1200 LOC.

**Gaps to fill (genus-0 rigidity — Route C, Milne §I.3):**

- **Rigidity Lemma** (Mumford Form I §4 = Milne Thm 1.1; cube-free) — **DONE, axiom-clean**. Foundation of Route C AND Route A's Albanese UP.
- **Cor 1.5 (additivity) + Cor 1.2 (AV maps are homs)** — DONE axiom-clean iter-162.
  Reused by Route A's Albanese UP.
- **`σ_×:ℙ¹×𝔾_m→ℙ¹` scaling action** as a TOTAL scheme morphism — the base case's
  only new ingredient. Committed iter-170 to option (c) inline chart-glue at scale
  (~200–270 LOC across 2–3 iters), built via `Scheme.Cover.glueMorphisms` over
  the iter-168 `projectiveLineBarAffineCover`, with `pullbackSpecIso` for chart
  bases and the iter-170 `Algebra.compHom` bridge per `analogies/tensoraway-instance.md`.
- **genus-0 + k̄-point ⟹ `≅ ℙ¹`** (Hartshorne IV.1.3.5) — Riemann–Roch-flavoured
  sub-build; NO Mathlib RR at scheme level (verified absent). **iter-171 COMMITS
  to in-tree sub-build** per `analogies/rrbridge-survey.md` option (1): the four
  Hartshorne ingredients (divisor of a closed point, RR dimension formula on a
  genus-0 curve, linear equivalence, "rational ⟹ ≅ ℙ¹") land as 4 prover-ready
  sub-chapters this iter (`blueprint-writer rr-bridge-subbuild` lane), each
  ≤500 LOC; prover scaffolding from iter-172. The in-tree work is exportable
  as Mathlib PRs once axiom-clean.
- **Rational-map extension to an AV (Thm 3.1/3.2)** — now a **Route-A-only** item
  (Albanese UP), OFF the genus-0 path. Codim-1 half buildable via Mathlib
  `ValuativeCriterion`/`RationalMap`/`SpreadingOut`; emptiness half (Lemma 3.3) needs
  Auslander–Buchsbaum (absent) — re-examine the complete-source escape before scheduling.
- No `AbelianVariety` theory and no general Riemann–Roch in Mathlib (both verified
  absent).

**Gaps to fill (FALLBACK route (a) only — off critical path):**

- `df = 0` for general genus-0: `Ω_A` triviality + **Serre duality** `H^0(C,Ω_C)=0`
  (~3000–8000; no Mathlib dualizing sheaf / RR / genus↔Ω bridge). The chart
  `Ω_C(V)` is free rank-1, so the KDM stack cannot detect `df=0`. (c-hybrid)
  supersedes this by routing through the concrete `ℙ¹`.

**New project material introduced (in tree):**

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — the route-(c) AV-rigidity stack
  (Rigidity Lemma → base case → genus-0-curve-to-AV), UPSTREAM of `Jacobian.lean`;
  own chapter. Consumed by `genusZeroWitness.key`.
- `Cotangent/ChartAlgebra.lean` — chart-algebra envelope (KDM, constants,
  `df_zero_factors`, thin `ext_of_diff_zero`). CLOSED, axiom-clean. Reused by
  (c-hybrid) / fallback (a).
- `Cotangent/GrpObj.lean` — `cotangentSpaceAtIdentity` trio; `shearMulRight`.
  Design template for the `Ω_A` globalization in (c-hybrid).
- `Rigidity.lean` `ext_of_eqOnOpen` — dominant-source / separated-target rigidity
  packaging; consumed by the scheme-lift + Albanese uniqueness.

**Soundness rules (operational):** No new axioms (every closed decl `lean_verify`s
to `propext, Classical.choice, Quot.sound`). A `sorry` must be the body of a
top-level named declaration — never buried in a `letI`/`have`/anonymous-`fun`
inside another decl.

```

## Reference index

```markdown
# References

<!-- archon:references-summary -->

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
| [`stacks-varieties.md`](./stacks-varieties.md) → `stacks-varieties.tex` | Stacks ch.33 "Varieties" — tags **035U** (§geom-reduced), **04QM**/**056T** (smooth over fields ⇒ geom regular/normal/reduced), **0BUG** (8-part `H^0(X,𝒪)` lemma, part (4) geom-reduced⇒separable). Backs (S3.sep.*). |
| [`stacks-fields.md`](./stacks-fields.md) → `stacks-fields.tex` | Stacks ch.9 "Fields" — tags **09HD** (§purely inseparable), **030K** (separable-then-inseparable factorisation). Backs (S3.pi.2). |
| [`stacks-algebra.md`](./stacks-algebra.md) → `stacks-algebra.tex` | Stacks ch.10 "Commutative Algebra" — tag **00T7** (standard smooth ⇒ `Ω_{S/R}` free on `dx_{c+1},…,dx_n`), L37259. Backs (BR.2)–(BR.5). Large file: jump to line. |
| [`stacks-coherent.md`](./stacks-coherent.md) → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes" — tag **02KH** (flat base change of `R^i f_*`; part (2) `H^0`-with-base-change). Backs (S3.pi.1). |
| [`kleiman-picard.md`](./kleiman-picard.md) → `kleiman-picard.pdf` / `-src/*.tex` | Kleiman, "The Picard scheme" (FGA Explained / arXiv:math/0504020). Route A source. **Deep map**: §4 existence, §5 `Pic⁰` (Jacobian, pp.36–51), §6 `Pic^τ` finiteness. |
| [`nitsure-hilbert-quot.md`](./nitsure-hilbert-quot.md) → `nitsure-hilbert-quot.pdf` / `-src/*.tex` | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained / arXiv:math/0504590). Quot/Hilbert construction engine behind Route A. |
| [`abelian-varieties.md`](./abelian-varieties.md) → `abelian-varieties.pdf` | Milne, "Abelian Varieties" (course notes, 2008). **Rigidity Theorem 1.1** (§I.1, p.8); **Thm 3.2** + **Prop 3.10** "rational/unirational → AV is constant" = `Mor(ℙ¹,A)` constant via bare rigidity, NO Serre duality (§I.3, pp.15–20); **theorem of the cube** §I.5 p.21; **Albanese universal property** of `Pic⁰`/Jacobian **Prop 6.1/6.4** (§III.6, p.104). |
| [`mumford-abelian-varieties.md`](./mumford-abelian-varieties.md) → `mumford-abelian-varieties.pdf` | Mumford, "Abelian Varieties" (TIFR, 1970). **THE canonical route-(c) source.** **Rigidity Lemma (Form I)** + Cor.1 (§4, book p.43 / PDF p.54); **abelian-variety definition + conventions** (§4, p.39); **Theorem of the Cube** §6 p.55 (PDF p.66), scheme version §10 p.89. Offset +11 (body). Scanned image PDF — no text layer; quote from rendered page. "Mor(ℙ¹,A) constant" NOT separately labeled here (use Milne Prop 3.10). |
| [`hartshorne-algebraic-geometry.md`](./hartshorne-algebraic-geometry.md) → `hartshorne-algebraic-geometry.pdf` | Hartshorne, "Algebraic Geometry" (GTM 52, 1977). **Genus-0 curve ≅ ℙ¹**: Example IV.1.3.5 (doc p.297 / PDF p.314) + Exercise IV.1.3 (rational-point form); **genus def `g=dim H¹(O_X)`**: Prop IV.1.1 (doc p.294). **`Ω_{ℙ¹}≅O(−2)`**: Euler seq Thm II.8.13 (p.176) + ω_{ℙⁿ}≅O(−n−1) Ex.II.8.20.1 (p.182). **`H⁰(ℙ¹,O(−2))=0`**: Thm III.5.1(a) (p.225). Offset +17 (body). Scanned image PDF. |
| [`fga-explained.md`](./fga-explained.md) → `fga-explained.pdf` | Fantechi–Göttsche–Illusie–Kleiman–Nitsure–Vistoli, "FGA Explained" (AMS MSM 123, 2005). Route A engine, collected volume. **Kleiman Picard** = Ch.9 (book p.237): §9.4 existence p.262, §9.5 Pic⁰ p.275. **Nitsure Hilbert/Quot** = Ch.5 (p.107): §5.5 Quot construction p.126. **Vistoli descent/Yoneda** Ch.2 §2.1 p.13, Ch.4 stacks p.67. **Illusie Grothendieck existence** Ch.8 §8.4 p.204. Offset +10. Has text layer. Book numbering differs from arXiv `kleiman-picard`/`nitsure-hilbert-quot` cards. |

```

## Blueprint chapter summary

- `AbelJacobi.tex` — Abel-Jacobi statement, minimal (89 LOC).
- `AbelianVarietyRigidity.tex` — Mumford rigidity chain + genus-0 final assembly (1684 LOC; covers `AbelianVarietyRigidity.lean` + `Genus0BaseObjects.lean`).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — cotangent at identity (87 LOC; fallback-route asset).
- `Cohomology_*.tex` — Mayer-Vietoris + module-K structure sheaf (1731 LOC total; supports H¹(C, 𝒪_C)).
- `Differentials.tex` — Differentials boilerplate (209 LOC).
- `Genus.tex` — Genus = H¹ dim (75 LOC).
- `Jacobian.tex` — Headline + Route A per-sub-phase budget (613 LOC; the strategy-fork chapter).
- `Rigidity.tex` — `ext_of_eqOnOpen` (71 LOC).
- `RigidityKbar.tex` — `[CharZero]`-gated fallback route (a) artifact (2621 LOC; off critical path).

## Project goal (verbatim from STRATEGY.md ## Goal)

Formalize Christian Merten's Jacobian challenge: nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian object uniform over the k-rational pointing of a smooth proper geometrically irreducible curve C/k, with NO `C(k) ≠ ∅` hypothesis. End-state: zero inline `sorry`, kernel-only axioms.

## Specific questions for this re-audit

1. Does the 4-row Route A split (A.1/A.2/A.3/A.4) address the iter-170 "parallelism under-exploited" challenge? Or is the split cosmetic without behaviour change?
2. Does the "in-tree RR sub-build COMMITTED" decision dominate "defer to upstream Mathlib" given the project's axiom-clean target + the planner's stuck genus-0 stack?
3. Is the new "Refactor — AVR split" row appropriate as a 1-iter housekeeping lane, or is it scope-creep?
4. Any new SOUND/CHALLENGE/REJECT findings on the updated strategy?
