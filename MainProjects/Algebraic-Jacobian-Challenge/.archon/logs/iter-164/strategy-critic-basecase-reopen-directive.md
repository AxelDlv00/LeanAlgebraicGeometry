# Strategy-critic directive — iter-164: re-verify the RE-OPENED genus-0 base-case route

A fresh-context mathematician's audit. A material strategy change landed this iter: the
genus-0 base case `ℙ¹→A constant` was found to have a **circular dependency** on Milne
Theorem 3.2, so its sub-route was RE-OPENED (see STRATEGY.md "Open strategic questions").

## The specific question I need adjudicated

The committed Route C derives `ℙ¹→A const` (Milne Prop 3.9) by extending the
additive-defect map `ψ(x,y)=f(x+y)−f(x)−f(y)` from the affine surface `𝔾_a×𝔾_a` to the
complete `ℙ¹×ℙ¹` via Theorem 3.2, then collapsing it with the proven Rigidity Lemma.
A Mathlib-API survey established:
- The codim-1 half of Thm 3.2 (extension over each height-1 DVR) IS in Mathlib
  (`ValuativeCriterion`/`RationalMap`/`SpreadingOut`) — no divisors, no group.
- The EMPTINESS half (Milne Lemma 3.3, codim-1 indeterminacy into a group variety) is
  NOT a valuative trick: it needs Auslander–Buchsbaum (regular local ⟹ UFD), ABSENT in
  Mathlib, OR a "ruling reduction" that itself needs `ℙ¹→A const` — i.e. CIRCULAR for
  the base case.

So the base case cannot bootstrap through Thm 3.2 as blueprinted. Three candidate
independent base-case proofs are recorded in STRATEGY.md Open questions:
- **(A)** gap-fill Auslander–Buchsbaum + full Thm 3.2 (largest; no-regret for Route A).
- **(B)** the differential `H⁰(ℙ¹,Ω¹)=0` / `df=0` argument (Hartshorne reference card
  already in tree supplies `Ω_{ℙ¹}≅O(−2)` via Euler seq + `H⁰(ℙ¹,O(−2))=0` Thm
  III.5.1(a)); project has partial cotangent/chart-algebra infra; char-p subtlety
  (`df=0` ⇏ constant under Frobenius) is the known risk. Was "fallback (a)".
- **(C)** re-examine the theorem of the cube / seesaw (previously excised).

**Adjudicate:** Which candidate is the soundest + least-Mathlib-blocked path to
`ℙ¹→A const`? Is the circularity finding correct (does the base case genuinely require
the surface emptiness, or is there a 4th route — e.g. a direct product-rigidity argument
on `ℙ¹×ℙ¹` using `f(x)−f(y)`, or restricting to `𝔾_m` only)? Read Milne Prop 3.9/3.10
(`references/abelian-varieties.pdf`, PDF p.25–26) and the Hartshorne genus-0/differentials
card to verify. Note: the protected goal signature is char-general (no `[CharZero]`), so
a char-0-only base case would NOT close the challenge — weigh (B)'s char-p risk seriously.

Also do your standard STRATEGY.md skeleton/format audit + sunk-cost check on Route C
vs. Route A overall.

---

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine
protected declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese/Jacobian object
uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve
`C/k`, with NO `C(k)≠∅` hypothesis on the protected signature. The witness object `J` is
always real; only `isAlbaneseFor` is universally quantified over `P : 𝟙_ ⟶ C`. End-state:
zero inline `sorry`, kernel-only axioms. Char-general (no `[CharZero]`).

---

## STRATEGY.md (verbatim)

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
| **genus-0 rigidity** (object `J=Spec k` trivial) | Rigidity-Lemma chain + Cor 1.5 + Cor 1.2 CLOSED axiom-clean; **base-case sub-route RE-OPENED (iter-164)** — Thm 3.2 circularity (below) | ~18–35 | ~3000–6000 · chain+Cor done, base-case 0/it | codim-1 rational-map extension (Mathlib `ValuativeCriterion`/`RationalMap`/`SpreadingOut` — present); base-case independent of Thm 3.2 (TBD); genus-0⟹ℙ¹ RR bridge | **base case `ℙ¹→A const` cannot bootstrap through Thm 3.2 (circular — see Open questions); the emptiness half of Thm 3.2 needs Auslander–Buchsbaum (absent in Mathlib)**; RR bridge has no Mathlib support |
| codim-1 rational-map extension (Thm 3.1) — no-regret infra | committed (analogist-scoped); shared with Route A Albanese UP | 3–6 | ~300–600 · new | `ValuativeCriterion.Existence`, `IsProper.eq_valuativeCriterion`, `Scheme.PartialMap.ofFromSpecStalk`, DVR-via-`tfae_of_isNoetherianRing_…` | hand-rolled scheme-codim bookkeeping (no Mathlib codim API); the one non-Mathlib piece |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated | 3–5 | 350–850 · gated | terminal cluster on `Spec k`; faithfully-flat descent of a morphism equality along `Spec k̄ → Spec k` | descent direction unconfirmed; skeleton 6/7 fields closed, only the `key` rigidity equation open |
| `nonempty_jacobianWitness` genus-stratified body | gated | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

## Routes

The positive-genus OBJECT is built by **Route A (Picard scheme via FGA)** —
mandatory and essentially unavoidable. The genus-0 arm is a separate, lower-risk
rigidity statement (object trivial); its base-case proof route is **Route C (Milne
§I.3 rigidity completion)**, chosen because Milne §I.3 + §III.6 derive both the
genus-0 base case AND Route A's Albanese UP cube-free, and a Mathlib-support survey
found Route C far less blocked than the differential route.

### Route A (COMMITTED) — Picard scheme / Albanese via FGA

Hilbert/Quot representability + identity-component `Pic⁰` + Albanese universal
property. Decomposition A.1–A.4 in `Jacobian.tex` § "Route A". Literature in-tree:
`references/kleiman-picard.pdf` (§4 existence, §5 `Pic⁰`), `references/nitsure-hilbert-quot.pdf`
(Quot/Hilbert engine). **Positive-genus arm:** `J := Pic⁰_{C/k}`, a dim-`g`
abelian variety; the Albanese UP gives `isAlbaneseFor`. Critical path: the object
must be a real dim-`g` abelian variety even when `C(k)=∅`, so the FGA engine is
required unconditionally.

### Route C (COMMITTED) — genus-0 rigidity completion via Milne §I.3

The genus-0 witness OBJECT is the trivial `J = Spec k` (skeleton 6/7 closed); it
needs **no** Picard scheme. Remaining content: over `k̄`, every pointed `f : C → A`
from a genus-0 curve to an abelian variety is constant. The **Rigidity Lemma**
(Mumford Form I = Milne Rigidity Thm 1.1) is PROVEN axiom-clean and is the
foundation of this route. Milne §I.3 derives `ℙ¹→A constant` from it with **no
theorem of the cube**. Chain:

- **Cor 1.5** (additivity): `h : V×W → A`, `h(v₀,w₀)=0 ⟹ h = f∘p + g∘q` uniquely.
  Direct from the proven Rigidity Lemma (the difference `h − (f∘p+g∘q)` collapses on
  both axes). **No-regret** — Route A's Albanese UP (Milne Prop 6.4) also needs it.
- **Cor 1.2** (regular map of AVs sending `0↦0` is a homomorphism). From Cor 1.5.
- **Thm 3.2** (rational map from a nonsingular variety to an AV is everywhere
  defined). SPLITS (iter-164 mathlib-analogist `thm32-extend`): (i) the **codim-1 half**
  (Thm 3.1, extension over each height-1 DVR ⟹ complement codim ≥ 2) IS shippable in
  Mathlib now via `ValuativeCriterion.Existence`/`RationalMap`/`SpreadingOut` — NO
  divisors, NO group, no-regret (Route A's Albanese UP needs it too); (ii) the
  **emptiness half** (Milne Lemma 3.3, codim-1 indeterminacy into a group) is NOT a
  valuative trick — it needs Auslander–Buchsbaum (regular local ⟹ UFD), ABSENT in
  Mathlib, OR a rigidity reduction that is CIRCULAR for the base case (see Open
  questions). `analogies/thm32-extend.md`.
- **`Hom(𝔾_a,A)=0`** + the `𝔾_a/𝔾_m` incompatibility (Milne Prop 3.9): a homomorphism
  from the additive group to an AV is trivial. Char-free.
- **genus-0⟹ℙ¹** (RR bridge, Hartshorne IV.1.3.5) — shared, no Mathlib RR.

Assembly (AS BLUEPRINTED): Prop 3.9 (`ℙ¹→A const`) collapses the additive-defect map
`ψ(x,y)=f(x+y)−f(x)−f(y)` — extended from `𝔾_a×𝔾_a` to the complete surface `ℙ¹×ℙ¹`
(Thm 3.2 / Milne Thm 3.4) — by the Rigidity Lemma, then the `𝔾_a/𝔾_m` incompatibility.
**CIRCULARITY (iter-164):** this surface extension of `ψ` needs the emptiness half of
Thm 3.2, whose only Mathlib-feasible proof (the ruling reduction, since Auslander–
Buchsbaum is absent) itself needs `ℙ¹→A const` — i.e. the very goal. So the base case
**cannot** route through Thm 3.2 as blueprinted; its proof must be made independent
(see Open questions). Once `ℙ¹→A const` is proven independently, the surface Thm 3.2
follows for free via the ruling reduction (no-regret for Route A). Survey:
`analogies/route-support.md`, `analogies/thm32-extend.md`.

### Off-path fallbacks (kept in tree, NOT pursued)

- **(c-hybrid) differential + Frobenius**, **(c-cube) theorem of the cube**, **(b)
  `dim Pic⁰=0` byproduct of Route A**, **(a) Serre-duality `df=0`** (artifact:
  `rigidity_over_kbar` `[CharZero]` in `RigidityKbar.lean`). All rejected/superseded
  in favour of Route C — see `iter/iter-163/plan.md` for the comparison.

## Open strategic questions

- **Base-case route decision — RESOLVED = Route C (Milne §I.3).** Milne §I.3
  (Prop 3.9/3.10) and §III.6 (Prop 6.1/6.4, Albanese UP) both derive from the Rigidity
  circle (Thm 1.1 + Thm 3.2 + Cor 1.2/1.5) with the theorem of the cube on NEITHER
  path. Mathlib-support survey confirmed Route C least blocked.
- **RE-OPENED (iter-164): how is the genus-0 base case `ℙ¹→A const` proven, given it
  cannot route through Thm 3.2 (circular)?** The mathlib-analogist `thm32-extend`
  closed the "pointwise valuative side-step" question: NO — the valuative criterion
  reaches only codim ≥ 2, and the emptiness half needs Auslander–Buchsbaum (absent) or
  the `ℙ¹→A const` reduction (circular for the base case). Candidate independent
  base-case proofs to weigh (strategy-critic to adjudicate): **(A)** gap-fill
  Auslander–Buchsbaum + full Thm 3.2 (largest; no-regret for Route A); **(B)** the
  differential `H⁰(ℙ¹,Ω¹)=0`/`df=0` argument (project has partial cotangent/chart-algebra
  infra; char-p care needed — was fallback (a)); **(C)** re-examine the theorem of the
  cube / seesaw (previously excised). The codim-1 half of Thm 3.1 is buildable + no-regret
  REGARDLESS of which base-case route wins — committed now.
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
  the cube** (Milne §III.6). Shares Route C's Cor 1.5/Cor 1.2/Thm 3.2
  infrastructure. NOT yet itemised in ~5100 — true budget higher.

**Gaps to fill (genus-0 rigidity — Route C, Milne §I.3):**

- **Rigidity Lemma** (Mumford Form I §4 = Milne Thm 1.1; cube-free) — **DONE, axiom-clean**. Foundation of Route C AND Route A's Albanese UP.
- **Cor 1.5 (additivity) + Cor 1.2 (AV maps are homs)** — direct corollaries of the
  proven Rigidity Lemma; the next concrete targets. No-regret (Albanese UP needs them).
- **Rational-map extension to an AV, codim-1 half (Thm 3.1)** — COMMITTED no-regret
  infra (new file `RationalMapExtend.lean`): `ValuativeCriterion.Existence` +
  `IsProper.eq_valuativeCriterion` + `Scheme.PartialMap.ofFromSpecStalk` + DVR-via-
  `tfae_of_isNoetherianRing_of_isLocalRing_of_isDomain`; only hand-rolled piece = scheme
  codim bookkeeping. **Emptiness half (Lemma 3.3)** — needs Auslander–Buchsbaum (ABSENT)
  or the circular reduction; gated on the base-case route decision.
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

---

## References index (references/summary.md)

Milne "Abelian Varieties" (abelian-varieties.pdf): Rigidity Thm 1.1 §I.1; Thm 3.2 +
Prop 3.9/3.10 "rational→AV constant" §I.3 pp.15–20; theorem of the cube §I.5; Albanese UP
Prop 6.1/6.4 §III.6. Mumford "Abelian Varieties" (mumford-abelian-varieties.pdf):
Rigidity Lemma Form I §4; theorem of the cube §6/§10. Hartshorne (hartshorne-algebraic-geometry.pdf):
genus-0 curve ≅ ℙ¹ Ex IV.1.3.5; `Ω_{ℙ¹}≅O(−2)` Euler seq Thm II.8.13; `H⁰(ℙ¹,O(−2))=0`
Thm III.5.1(a). Kleiman "Picard scheme" + Nitsure "Hilbert/Quot" + FGA Explained: Route A
engine. Stacks chapters: varieties/fields/algebra/coherent (cohomology infra).

## Blueprint chapter index (title = topic)

- AbelianVarietyRigidity.tex: genus-0 curve → AV morphisms are constant (Route C; the active chapter)
- Jacobian.tex: the Jacobian as an abelian variety (witness assembly; Route A sketch)
- RigidityKbar.tex: rigidity over base field k (off-path fallback (a) artifact, [CharZero])
- Rigidity.tex: scheme-level rigidity (Mumford §4)
- Genus.tex: genus of a smooth proper curve
- AbelJacobi.tex: the Abel–Jacobi / Albanese consumer interface
- Differentials.tex: relative cotangent presheaf
- AlgebraicJacobian_Cotangent_GrpObj.tex: cotangent space at identity (thin pointer)
- Cohomology_*.tex (4 chapters): ModuleCat-valued sheaf cohomology, Mayer–Vietoris, structure sheaf (infra)

## Output
Standard verdict (SOUND / CHALLENGE / REJECT) + the base-case route adjudication above.
