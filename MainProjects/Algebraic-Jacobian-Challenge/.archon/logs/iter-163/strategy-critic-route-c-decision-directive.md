# Strategy-critic directive (iter-163) — re-verify the now-RESOLVED base-case route CHALLENGE

You raised a CHALLENGE in iter-162 on route (c): the case for building the **theorem of the
cube** rested on two unverified premises — (i) that the cube is "shared with Route A's Albanese
UP" and (ii) that `ℙ¹→A const` "rests irreducibly on the cube." This iter the planner RESOLVED it
by reading the primary source. Re-verify the resolution as a fresh mathematician: is the new
committed route (Route C) sound, and is the cube correctly excised?

## What the planner did this iter (the resolution)
- Read Milne, *Abelian Varieties* §I.1 (Rigidity Thm 1.1), §I.3 (Prop 3.9/3.10 — `ℙ¹→A const`),
  and §III.6 (Prop 6.1/6.4 — the Jacobian's Albanese universal property), verbatim from
  `references/abelian-varieties.pdf`.
- FINDING: Milne's Rigidity Theorem 1.1 is exactly the Mumford Form-I Rigidity Lemma the project
  already PROVED axiom-clean (iter-162); its proof uses only completeness + "map from a complete
  connected variety into an affine is constant" — NO theorem of the cube.
- FINDING: `ℙ¹→A constant` (Milne Prop 3.9, the base case of Prop 3.10) is derived from Thm 1.1
  via: Thm 3.2 (rational map from nonsingular variety to AV extends, by the valuative criterion)
  + Cor 1.2 (AV map sending 0↦0 is a homomorphism, from rigidity) + the `𝔾_a`/`𝔾_m`
  incompatibility argument. NO theorem of the cube.
- FINDING: the Albanese UP (Prop 6.1/6.4) is derived via Thm 3.2 + Cor 1.2 + Cor 1.5 — again NO
  theorem of the cube. The cube (§I.5) is used only for projectivity (§I.6), seesaw, dual abelian
  variety, polarizations, Poincaré sheaf — none on the genus-0 or Albanese-UP path.
- A Mathlib-support survey (`analogies/route-support.md`) found Route C far less blocked than the
  differential route: the valuative criterion is in Mathlib, whereas the differential route needs
  scheme-level Kähler-differential sheaves + coherent-sheaf cohomology + Serre H⁰ + scheme
  relative Frobenius, all from scratch.
- DECISION: committed Route C (Milne §I.3 rigidity completion); EXCISED (c-cube); demoted
  (c-hybrid differential+Frobenius) and (a Serre-duality) to off-path fallbacks.

## Your job
Challenge the resolution. Specifically:
1. Is the cube-excision sound, or is there a hidden cube dependency the planner missed (e.g. does
   Thm 3.2's extension, or Cor 1.5, secretly need the cube/seesaw/theorem-of-the-square)?
2. Is Route C's riskiest piece correctly identified (the rational-map-extension surface gap,
   Milne Lemma 3.3 — pure-codim-1 indeterminacy on `ℙ¹×ℙ¹`, where Mathlib has no Weil-divisor
   theory)? Is the "pointwise valuative side-step" plausible, or is this an under-estimated risk?
3. Is anything else in the strategy now stale or internally inconsistent given the route swap?
Verdict: SOUND / CHALLENGE / REJECT, per route. If you still see a live problem, say so plainly.

## Context you may read (and ONLY this)
- `STRATEGY.md` (verbatim below).
- `references/summary.md` (reference index).
- Blueprint chapter titles (one line each):
  AbelJacobi: the Abel–Jacobi map; AbelianVarietyRigidity: morphisms from a genus-0 curve into an
  AV are constant; Cotangent_GrpObj: cotangent space at identity; Cohomology_* : sheaf cohomology
  with k-module coeffs (H¹(O_C)); Differentials: relative cotangent presheaf; Genus: genus of a
  smooth proper curve; Jacobian: the Jacobian as an AV; Rigidity: scheme-level rigidity (Mumford
  §4); RigidityKbar: rigidity over k for genus-0 curve→group scheme (fallback artifact).
- Project goal: formalize Christian Merten's Jacobian challenge — the existence of an
  Albanese/Jacobian object uniform over the k-rational pointing of a smooth proper geometrically
  irreducible curve C/k, with NO C(k)≠∅ hypothesis on the protected signature. End-state: zero
  inline sorry, kernel-only axioms.

You may read `references/abelian-varieties.pdf` to spot-check the cube-excision claim (use a
python pypdf snippet — `pdftotext` is not installed). Do NOT read iter sidecars, PROGRESS.md,
task files, or prover narrative.

----- STRATEGY.md (verbatim) -----
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
| **Route A — Picard/Quot/Hilbert FGA engine** (positive-genus OBJECT; CRITICAL PATH) | committed, blueprint sketch-level | ~40–70 | ~5100+ · 0/it | Hilbert/Quot repr (Nitsure §4–5); FGA `Pic_{C/k}` repr; `Pic⁰`; Albanese UP | A.2 representability is the riskiest, least-Mathlib piece; project-fatal if it stalls; mandatory regardless (the object is `Pic⁰`) |
| **genus-0 rigidity** (object `J=Spec k` trivial) | Rigidity-Lemma chain **CLOSED axiom-clean iter-162**; base-case route `ℙ¹→A const` **DECIDED iter-163 = Route C (Milne §I.3 rigidity completion)** | ~15–30 | ~3000–5500 · chain done, base-case 0/it | Cor 1.5 additivity + Cor 1.2 (from proven Rigidity Lemma); rational-map extension via valuative criterion (in Mathlib); `𝔾_a/𝔾_m` + `Hom(𝔾_a,A)=0`; genus-0⟹ℙ¹ RR bridge | rational-map-extension surface gap (Lemma 3.3 indeterminacy) is the riskiest piece; RR bridge has no Mathlib support |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated | 3–5 | 350–850 · gated | terminal cluster on `Spec k`; faithfully-flat descent of a morphism equality along `Spec k̄ → Spec k` | descent direction unconfirmed; skeleton 6/7 fields closed, only the `key` rigidity equation open |
| **char-`p` genus-0 rigidity** (arbitrary `[Field k]`, no `CharZero`) | gated; **Route C is uniformly char-free** | (subsumed by genus-0 row) | — · 0 | Route C (Milne §I.3) is char-free end-to-end — no Frobenius, no `df=0` | naive `df=0`-only route is char-`p`-false, but Route C never uses differentials so no char-`p` epicycle remains |
| `nonempty_jacobianWitness` genus-stratified body | gated | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

## Routes

The positive-genus OBJECT is built by **Route A (Picard scheme via FGA)** —
mandatory and essentially unavoidable. The genus-0 arm is a separate, lower-risk
rigidity statement (object trivial); its base-case proof route was **DECIDED in
iter-163 = Route C (Milne §I.3 rigidity completion)** after reading Milne §I.3
+ §III.6 (the theorem of the cube is on NEITHER the genus-0 nor the Albanese-UP
path) and a Mathlib-support survey (Route C far less blocked than the differential
route). See `iter/iter-163/plan.md` for the full decision record.

### Route A (COMMITTED) — Picard scheme / Albanese via FGA

Hilbert/Quot representability + identity-component `Pic⁰` + Albanese universal
property. Decomposition A.1–A.4 in `Jacobian.tex` § "Route A". Literature in-tree:
`references/kleiman-picard.pdf` (§4 existence, §5 `Pic⁰`), `references/nitsure-hilbert-quot.pdf`
(Quot/Hilbert engine). **Positive-genus arm:** `J := Pic⁰_{C/k}`, a dim-`g`
abelian variety; the Albanese UP gives `isAlbaneseFor`. Critical path: the object
must be a real dim-`g` abelian variety even when `C(k)=∅`, so the FGA engine is
required unconditionally.

### Route C (COMMITTED iter-163) — genus-0 rigidity completion via Milne §I.3

The genus-0 witness OBJECT is the trivial `J = Spec k` (skeleton 6/7 closed); it
needs **no** Picard scheme. Remaining content: over `k̄`, every pointed `f : C → A`
from a genus-0 curve to an abelian variety is constant. The **Rigidity Lemma**
(Mumford Form I = Milne Rigidity Thm 1.1) is **PROVEN axiom-clean (iter-162)** and
is the foundation of this route. Milne §I.3 derives `ℙ¹→A constant` from it with
**NO theorem of the cube** (verified by reading the source, iter-163). Chain:

- **Cor 1.5** (additivity): `h : V×W → A`, `h(v₀,w₀)=0 ⟹ h = f∘p + g∘q` uniquely.
  Direct from the proven Rigidity Lemma (the difference `h − (f∘p+g∘q)` collapses on
  both axes). **No-regret** — Route A's Albanese UP (Milne Prop 6.4) also needs it.
- **Cor 1.2** (regular map of AVs sending `0↦0` is a homomorphism). From Cor 1.5.
- **Thm 3.2** (rational map from a nonsingular variety to an AV is everywhere
  defined). Via the valuative criterion of properness (in Mathlib:
  `IsProper.of_valuativeCriterion`, `ValuativeCriterion`) + indeterminacy-locus pure
  codim 1 (Milne Lemma 3.3). The surface case (`ℙ¹×ℙ¹`) is the riskiest piece.
- **`Hom(𝔾_a,A)=0`** + the `𝔾_a/𝔾_m` incompatibility (Milne Prop 3.9): a homomorphism
  from the additive group to an AV is trivial. Char-free.
- **genus-0⟹ℙ¹** (RR bridge, Hartshorne IV.1.3.5) — shared, no Mathlib RR.

Assembly: Prop 3.9 (`ℙ¹→A const`) = Thm 3.2 (extend the difference map) + Cor 1.2 +
`𝔾_a/𝔾_m`; the headline `rigidity_genus0_curve_to_grpScheme` = Prop 3.9 + the iso.
**Route C is uniformly char-free** (no differentials, no Frobenius). Mathlib-support
survey (`analogies/route-support.md`): Route C far less blocked than the differential
route (valuative criterion present; the differential route needs Ω-sheaf + coherent
cohomology + Serre `H⁰` + scheme Frobenius, all from scratch).

### Off-path fallbacks (kept in tree, NOT pursued)

- **(c-hybrid) differential + Frobenius.** `Ω_A≅O^g` + `df=0` on the concrete `ℙ¹`
  (char 0) + relative Frobenius factorization (char `p`). Reuses chart-algebra +
  GrpObj. REJECTED iter-163: three from-scratch Mathlib foundations (Ω-sheaf, ℙ¹
  line-bundle cohomology, scheme Frobenius) vs Route C's single contained surface gap.
- **(c-cube) theorem of the cube.** EXCISED iter-163: reading Milne §I.3 + §III.6
  showed the cube is on NEITHER the genus-0 base case NOR Route A's Albanese UP — it
  would be a pure ~8–15-iter zero-Mathlib tax.
- **(b) byproduct of Route A** (`dim Pic⁰=0`). Couples genus-0 to the ~40–70-iter
  Route A monster; not pursued as an independent near-term route.
- **(a) Serre-duality `df=0`** for a general genus-0 curve, reusing the closed
  chart-algebra envelope (KDM converse `df=0 ⟹ const`). Char-`p` gap; superseded by
  Route C. `rigidity_over_kbar` (`[CharZero]`) in `RigidityKbar.lean` is its artifact.

## Open strategic questions

- **Base-case route decision — RESOLVED iter-163 = Route C (Milne §I.3).** Gating
  reads done: Milne §I.3 (Prop 3.9/3.10) and §III.6 (Prop 6.1/6.4, Albanese UP) both
  derive from the Rigidity circle (Thm 1.1 + Thm 3.2 + Cor 1.2/1.5) with the theorem
  of the cube on NEITHER path. Mathlib-support survey confirmed Route C least blocked.
- **Route C's riskiest piece: the rational-map extension surface gap (Milne Lemma 3.3).**
  Valuative criterion gives "defined in codim 1"; upgrading to "everywhere defined"
  for maps to a group variety needs the pure-codim-1 indeterminacy lemma on the
  surface `ℙ¹×ℙ¹`. Mathlib has no Weil-divisor theory — OPEN whether the pointwise
  valuative side-step (extend at each codim-1 point) avoids building divisor theory.
- **Architecture (settled).** Route-(c) declarations are UPSTREAM of `Jacobian.lean`
  (the import cycle `RigidityKbar → Rigidity → Jacobian` blocks `genusZeroWitness`
  from consuming the keystone). File `AlgebraicJacobian/AbelianVarietyRigidity.lean`
  (imports `Genus`, imported by `Jacobian`) + its own 1:1 chapter. The old
  `rigidity_over_kbar` (in `RigidityKbar.lean`, `[CharZero]`) is the fallback-(a)
  artifact, kept in tree.
- **Route A representability scheduling.** A.1–A.4 (esp. A.2 Quot/Hilbert repr)
  remain the dominant positive-genus cost; flesh to prover-ready blocks (entry:
  `RelativeSpec` ~700–1100 LOC) after the genus-0 stack. HARD GATE blocks a prover
  until the relevant chapter is complete+correct.
- **`k̄→k` descent is route-dependent**, not a fixed cost: a `Pic⁰`-over-`k` argument
  may give `Alb(C)=Spec k` directly (no descent); a `C_k̄≅ℙ¹` argument incurs the
  faithfully-flat descent of a morphism equality (direction unconfirmed).
- Should the chart-algebra envelope + GrpObj cotangent material be split out of the
  large `RigidityKbar.tex` into a dedicated off-path chapter (structural job)?

## Mathlib gaps & new material

**Gaps to fill (CRITICAL PATH — Route A engine, positive-genus object):**

- **Hilbert / Quot scheme representability** (Nitsure §4–5) + **FGA `Pic_{C/k}`
  representability** — the single highest-cost build, upstream of `Pic⁰`. ~3775 LOC.
- **identity-component subgroup scheme** `Pic⁰ ⊆ Pic`; degree map `Pic → ℤ`. ~800.
- **Albanese universal property** of `Pic⁰` (`isAlbaneseFor` for `g ≥ 1`): every
  `f : C → A` killing `P` factors uniquely through `Pic⁰`. Goal-required; uses the
  Rigidity Lemma + Cor 1.2/1.5 + Thm 3.2 (Milne Prop 6.1/6.4) — **NOT the theorem of
  the cube** (verified iter-163, Milne §III.6). Shares Route C's Cor 1.5/Cor 1.2/Thm 3.2
  infrastructure. NOT yet itemised in ~5100 — true budget higher.

**Gaps to fill (genus-0 rigidity — Route C, Milne §I.3):**

- **Rigidity Lemma** (Mumford Form I §4 = Milne Thm 1.1; cube-free) — **DONE,
  axiom-clean (iter-162)**. Foundation of Route C AND Route A's Albanese UP.
- **Cor 1.5 (additivity) + Cor 1.2 (AV maps are homs)** — direct corollaries of the
  proven Rigidity Lemma; the next concrete targets. No-regret (Albanese UP needs them).
- **Rational-map extension to an AV** (Milne Thm 3.2 / Lemma 3.3) — valuative
  criterion present in Mathlib (`IsProper.of_valuativeCriterion`); the codim-1
  indeterminacy upgrade is the contained gap (no Mathlib Weil divisors).
- **`𝔾_a`/`𝔾_m` group structures + `Hom(𝔾_a,A)=0`** — `AffineSpace 𝔸(n;S)` + `GrpObj`
  present in Mathlib; the additive-group structure on `𝔸¹` and the triviality lemma
  are to build (one lemma over existing API).
- **genus-0 + k̄-point ⟹ `≅ ℙ¹`** (Hartshorne IV.1.3.5) — Riemann–Roch-flavoured
  sub-build (no Mathlib RR). Shared / needed by Route C.
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
