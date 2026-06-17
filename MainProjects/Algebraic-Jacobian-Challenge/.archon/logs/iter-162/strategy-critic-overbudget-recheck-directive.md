# Strategy Critic Directive

## Slug
overbudget-recheck

## Project goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`): nine protected
declarations, headlined by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` —
the existence of an Albanese / Jacobian object uniform over the $k$-rational pointing of a smooth
proper geometrically irreducible curve $C/k$, with **no** $C(k) \neq \emptyset$ hypothesis on the
protected signature. The witness OBJECT $J$ is always real; only `isAlbaneseFor` is universally
quantified over $P : \mathbf 1 \to C$. `genus C := \dim_k H^1(C, O_C)` (arithmetic genus, protected).
End-state: zero inline `sorry`, kernel-only axioms.

## Strategy under review

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
| **Route A — Picard/Quot/Hilbert FGA engine** (witness OBJECT for positive genus; CRITICAL PATH) | committed, blueprint sketch-level | many (~40–70) | ~5100+ · 0/it | Hilbert/Quot representability (Nitsure §4–5); FGA `Pic_{C/k}` repr; identity component `Pic⁰`; Albanese universal property | A.2 representability is the riskiest, least-Mathlib-supported piece; smallest entry `RelativeSpec` ~700–1100 LOC. Project-fatal if it stalls — but mandatory regardless (the positive-genus object is `Pic⁰`) |
| **genus-0 rigidity** (committed route (c); object `J=Spec k` already trivial) | Rigidity-Lemma chain CLOSING (iter-162: lone deep Step-1 residual, prover recipe in hand); cube + RR + ℙ¹→A + headline all UNSTARTED ahead. NEW home: own upstream file/chapter `AbelianVarietyRigidity` (breaks the import cycle) | **re-est ~18–32 (was ~10–18; OVER_BUDGET confirmed iter-162)** — cube ~8–15 + genus-0⟹ℙ¹ RR ~5–10, both zero-Mathlib, dominate; chain ≈12 elapsed | ~3500–6500 · chain ~40/it, cube+RR 0/it | (i) **Rigidity Lemma** (Mumford Form I §4 — CUBE-FREE, CLOSING iter-162); (ii) **theorem of the cube** (Mumford §6/§10 — REQUIRED; seesaw + flat/proper cohomology base-change + semicontinuity + line bundles on products); (iii) ℙ¹→A const (Milne Prop 3.10, induction cube-free via Cor 1.5; base case via cube); (iv) genus-0+k̄-pt ⟹ ≅ℙ¹ (Hartshorne IV.1.3.5, Riemann–Roch — **no Mathlib RR**) | cube DOMINATES — comparable to a chunk of representability; SHARED with Route A's Albanese UP (Milne §III.6), so NOT throwaway. The RR genus-0⟹ℙ¹ bridge is a SECOND major unstarted sub-build. Re-est licensed by >30% change (cube+RR at 0/it). rigidity_lemma closes early but is necessary-not-sufficient. Decisive reason for (c): char-freeness (see Routes) |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated | 3–5 | 350–850 · gated | terminal-object cluster on `Spec k`; **faithfully-flat descent of morphism equality** along `Spec k̄ → Spec k` (route-dependent: a `Pic⁰`-over-`k` argument may avoid it; a `C_k̄≅ℙ¹` argument incurs it) | descent right-cancellation direction unconfirmed; skeleton already built (6/7 fields closed, only the `key` rigidity equation open) |
| **char-`p` genus-0 rigidity** (protected goal over arbitrary `[Field k]`, no `CharZero`) | gated; may dissolve under route (c) | ? | ? · 0 | none if the rigidity lemma is char-free (it is); a Frobenius-descent plan only if the differential fallback (a) is used | the differential fallback carries `[CharZero k]`; the rigidity-lemma route (c) is char-free, likely removing this gap entirely — confirm when route (c) is settled |
| `nonempty_jacobianWitness` genus-stratified body | gated | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

## Routes

The witness OBJECT for positive genus is built by **Route A (Picard scheme via
FGA)** — mandatory and essentially unavoidable. The genus-0 arm is a separate,
lower-risk rigidity statement (object trivial); its proof route is under
determination, with two fallbacks held live.

### Route A (COMMITTED) — Picard scheme / Albanese via FGA

Hilbert/Quot representability + identity-component `Pic⁰` + Albanese universal
property. Decomposition A.1–A.4 in `Jacobian.tex` § "Route A". Literature in-tree:
`references/kleiman-picard.pdf` (§4 existence, §5 `Pic⁰`), `references/nitsure-hilbert-quot.pdf`
(Quot/Hilbert engine).

**Positive-genus arm:** `J := Pic⁰_{C/k}`, a dim-`g` abelian variety; the Albanese
UP gives `isAlbaneseFor`. This is the project's critical path: the object must be a
real dim-`g` abelian variety even when `C(k)=∅`, so the FGA engine is required
unconditionally.

### Genus-0 rigidity — the keystone `rigidity_over_kbar`, decoupled

The genus-0 witness OBJECT is the trivial `J = Spec k` (skeleton already 6/7
closed); it needs **no** Picard scheme. What remains is a single rigidity
STATEMENT: over `k̄`, a genus-0 curve is `≅ ℙ¹`, and any pointed `f : C → A` killing
`P` is constant. Three candidate proof routes, ranked:

- **(c) [COMMITTED] targeted char-free AV-rigidity lemma.** "Every morphism from a
  genus-0 curve (`≅ ℙ¹` over `k̄`) to an abelian variety is constant." **Minimal chain**
  (sources now in tree — Mumford + Hartshorne + Milne): (i) **Rigidity Lemma** (Mumford
  *Abelian Varieties*, Form I, §4 p.43; = Milne Thm 1.1) — `V` complete, `V×W→Z` trivial
  on `V×{w0}` ⟹ factors through `W`; this is **CUBE-FREE** (a properness/closedness
  argument, NOT the theorem of the cube). (ii) `ℙ¹ → A` constant (Milne Prop 3.10's
  packaged corollary; Mumford leaves it as a consequence of the rigidity lemma). (iii)
  genus-0 + `k̄`-point ⟹ `≅ ℙ¹` (Hartshorne IV.1.3.5 / Ex IV.1.3, Riemann–Roch-flavoured).
  Uses NEITHER Serre duality NOR Picard representability. **Decisive reason (c) beats the
  cheap-ℙ¹ `df=0` route:** over `k̄`, `H^0(ℙ¹,Ω)=H^0(ℙ¹,O(−2))=0` is *elementary* (the
  iter-155 chart-by-chart refutation does NOT touch the concrete `ℙ¹`), so `df=0` is reachable
  — but `df=0 ⟹ constant` is **FALSE in char `p`** without Frobenius descent. The protected
  goal is arbitrary `[Field k]`, so char-freeness is decisive. **Cube question RESOLVED
  iter-157** (NEGATIVE): the split is opposite the iter-156 hope — the multi-factor induction
  (Cor 1.5) is cube-free, but the *base case* "`ℙ¹→A` constant" (an AV has no rational curves)
  rests irreducibly on the cube. So `rigidity_lemma` is cube-free + prover-ready but does NOT
  alone close the arm; the cube is the heavy keystone, SHARED with Route A's Albanese UP (not
  throwaway). (c) stays cheaper than (b) (= cube AND representability). Decoupled from FGA.
- **(b) byproduct of the engine.** Once Route A exists, `Alb(genus-0)=Pic⁰(ℙ¹)=0`,
  so `f` factors through `Spec k̄`. Free, but couples genus-0 to A.2 representability
  — only attractive if (c) proves infeasible.
- **(a) fallback — differential route via Serre duality.** `df=0` via {`Ω_A`
  cotangent-triviality (~800–1500) + Serre duality `H^0(C,Ω_C)=0` (~3000–8000)},
  REUSING the closed, axiom-clean chart-algebra envelope (KDM,
  `constants_integral_over_base_field`, `df_zero_factors_through_constant_on_chart`)
  which supplies the converse `df=0 ⟹ constant`. **Kept in tree, off path** — not
  deleted. Carries a char-`p` gap. Reversal signal: if (c) is infeasible AND Route
  A's A.2 stalls, this decouples genus-0 from FGA risk.

## Open strategic questions

- **Sequencing (updated iter-162):** the **Rigidity Lemma** chain is CLOSING (iter-162 lands the
  lone deep Step-1 residual). Its `ℙ¹→A` corollary then rests on the **theorem of the cube** — the
  next deliverable AND the dominant unstarted cost, shared with Route A's Albanese UP. Once the chain
  closes, blueprint the cube (Mumford §6/§10) to prover-ready detail (decompose: seesaw principle,
  flat/proper cohomology base-change, line bundles on products) BEFORE opening its prover lane.
  Build the whole genus-0 stack BEFORE the Quot/Hilbert representability. Lives in its OWN
  chapter+file (below); the cube may warrant splitting out into its own chapter/file given its size.
- **Cube avoidance (RESOLVED iter-157, NEGATIVE):** the base case `ℙ¹→A constant` rests
  irreducibly on the theorem of the cube (char-free); only the Rigidity Lemma and the
  multi-factor induction are cube-free. The cube cannot be dodged for char-free genus-0 —
  it is the dominant cost of route (c), shared with Route A's Albanese UP. No budget cut.
- **Architecture (decided iter-157):** the route-(c) declarations must be UPSTREAM of
  `Jacobian.lean` (an import cycle `RigidityKbar → Rigidity → Jacobian` blocks
  `genusZeroWitness` from consuming the keystone). NEW file
  `AlgebraicJacobian/AbelianVarietyRigidity.lean` (imports `Genus`, imported by
  `Jacobian`) + its OWN 1:1 chapter `AbelianVarietyRigidity.tex` (blueprint-reviewer:
  separate chapter, NOT a consolidated `covers` on `Jacobian.tex`). The old
  `rigidity_over_kbar` (in `RigidityKbar.lean`, `[CharZero]`) becomes the fallback-(a)
  artifact, kept in tree.
- **Route A representability scheduling:** A.1–A.4 (esp. A.2 Quot/Hilbert repr) remain
  the dominant positive-genus cost; flesh to prover-ready blocks (entry: `RelativeSpec`
  ~700–1100 LOC) after the rigidity-lemma stack. HARD GATE blocks a prover until the
  relevant chapter is complete+correct.
- **`k̄→k` descent is route-dependent**, not a fixed cost: a `Pic⁰`-over-`k` argument
  may produce `Alb(C)=Spec k` directly (no descent); a `C_k̄≅ℙ¹` argument incurs the
  faithfully-flat descent of a morphism equality (direction unconfirmed). Cost it
  per genus-0 route once chosen.
- Should the chart-algebra envelope + GrpObj cotangent material be split out of the
  large `RigidityKbar.tex` into a dedicated off-path chapter (structural job)?

## Mathlib gaps & new material

**Gaps to fill (CRITICAL PATH — Route A engine, positive-genus object):**

- **Hilbert / Quot scheme representability** (Nitsure §4–5) + **FGA `Pic_{C/k}`
  representability** — the single highest-cost build, upstream of `Pic⁰`. ~3775 LOC.
- **identity-component subgroup scheme** `Pic⁰ ⊆ Pic`; degree map `Pic → ℤ`. ~800.
- **Albanese universal property** of `Pic⁰` (`isAlbaneseFor` for `g ≥ 1`): every
  `f : C → A` killing `P` factors uniquely through `Pic⁰`. Goal-required; uses the
  rigidity lemma; NOT yet itemised in ~5100 — true budget higher.

**Gaps to fill (genus-0 rigidity, route (c) — COMMITTED, the next deliverable):**

- **Rigidity Lemma** (Mumford Form I §4 p.43; cube-free) — the prover-ready entry,
  iter-158. Necessary but NOT sufficient for genus-0.
- **Theorem of the cube** (Mumford §6 p.55) — REQUIRED (the base case `ℙ¹→A constant`
  rests on it char-free; resolved iter-157). The DOMINANT cost: drags seesaw + flat/proper
  cohomology base-change + semicontinuity + line bundles on products, ALL absent from
  Mathlib — comparable to a chunk of representability. SHARED with Route A's Albanese UP
  (Milne §III.6), so not throwaway.
- **`ℙ¹ → A` constant** (Milne Prop 3.10) — induction cube-free (Cor 1.5); base case needs
  the cube.
- **genus-0 + k̄-point ⟹ `≅ ℙ¹`** (Hartshorne IV.1.3.5) — Riemann–Roch-flavoured; a real
  sub-build (Mathlib has no Riemann–Roch).
- All absent from Mathlib (no `AbelianVariety` theory).

**Gaps to fill (FALLBACK route (a) only — off critical path):**

- `df = 0` production: `Ω_A` global cotangent-triviality (~800–1500;
  `cotangentSpaceAtIdentity`/`shearMulRight` design templates) + **Serre duality**
  `H^0(C,Ω_C)=0` (~3000–8000; no Mathlib dualizing sheaf / Riemann–Roch / genus↔Ω
  bridge). The chart `Ω_C(V)` is free rank-1, so the KDM stack cannot detect `df=0`.

**New project material introduced (in tree):**

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (NEW iter-157) — the committed route-(c)
  AV-rigidity stack (Rigidity Lemma → `ℙ¹→A` constant → genus-0-curve-to-AV), UPSTREAM of
  `Jacobian.lean`; its own chapter `AbelianVarietyRigidity.tex`. Consumed by
  `genusZeroWitness.key`.
- `Cotangent/ChartAlgebra.lean` — chart-algebra envelope (KDM, constants,
  `df_zero_factors`, thin `ext_of_diff_zero`). CLOSED, axiom-clean. Route-(a)
  fallback asset, off critical path.
- `Cotangent/GrpObj.lean` — `cotangentSpaceAtIdentity` trio; `shearMulRight`. Design
  template for the `Ω_A` globalisation (fallback only).
- `Rigidity.lean` `ext_of_eqOnOpen` — dominant-source / separated-target rigidity
  packaging; consumed by the scheme-lift + Albanese uniqueness.

**Soundness rules (operational):** No new axioms (every closed decl `lean_verify`s
to `propext, Classical.choice, Quot.sound`). A `sorry` must be the body of a
top-level named declaration — never buried in a `letI`/`have`/anonymous-`fun`
inside another decl.

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Christian Merten's original challenge file; authoritative signatures. |
| `stacks-varieties.md` → `.tex` | Stacks ch.33 Varieties — geom-reduced, smooth-over-fields, `H^0(X,O)` 8-part lemma. |
| `stacks-fields.md` → `.tex` | Stacks ch.9 Fields — purely inseparable, sep-then-insep factorisation. |
| `stacks-algebra.md` → `.tex` | Stacks ch.10 Commutative Algebra — standard smooth ⇒ `Ω` free. |
| `stacks-coherent.md` → `.tex` | Stacks ch.30 Cohomology of Schemes — flat base change of `R^i f_*`, `H^0` base change. |
| `kleiman-picard.md` → `.pdf`/`.tex` | Kleiman "The Picard scheme" (FGA Explained / arXiv:math/0504020). Route A: §4 existence, §5 `Pic⁰`, §6 `Pic^τ`. |
| `nitsure-hilbert-quot.md` → `.pdf`/`.tex` | Nitsure "Construction of Hilbert and Quot Schemes". Route A Quot/Hilbert engine. |
| `abelian-varieties.md` → `.pdf` | Milne "Abelian Varieties" (2008). Rigidity Thm 1.1; Prop 3.10 (rational/unirational→AV constant, NO Serre); cube §I.5; Albanese UP Prop 6.1/6.4. |
| `mumford-abelian-varieties.md` → `.pdf` | Mumford "Abelian Varieties" (TIFR 1970). Canonical route-(c) source. Rigidity Lemma Form I §4 p.43; AV def §4 p.39; Theorem of the Cube §6 p.55, scheme version §10 p.89. Scanned image PDF. |
| `hartshorne-algebraic-geometry.md` → `.pdf` | Hartshorne "Algebraic Geometry" (GTM 52). Genus-0 curve ≅ ℙ¹ Ex IV.1.3.5; genus def IV.1.1; `Ω_{ℙ¹}≅O(−2)`; `H⁰(ℙ¹,O(−2))=0`. Scanned image PDF. |
| `fga-explained.md` → `.pdf` | FGA Explained (AMS MSM 123). Route A engine collected volume; Kleiman Picard Ch.9, Nitsure Hilbert/Quot Ch.5, Vistoli descent Ch.2/4, Illusie Grothendieck existence Ch.8. |

## Blueprint summary

- `AbelJacobi.tex` — The Abel–Jacobi map (transits `nonempty_jacobianWitness`).
- `AbelianVarietyRigidity.tex` — committed route-(c) AV-rigidity stack: Rigidity Lemma → ℙ¹→A constant → genus-0-curve-to-AV; cube recorded as deferred input.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — cotangent space at the identity (fallback-(a) design template).
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES for sheaf cohomology with k-module coefficients.
- `Cohomology_SheafCompose.tex` — sheaf condition along the structure-sheaf forget composite.
- `Cohomology_StructureSheafAb.tex` — structure sheaf as sheaf of abelian groups; sheafification, Ext.
- `Cohomology_StructureSheafModuleK.tex` — sheaves of k-modules; sheafification, Ext, structure sheaf.
- `Differentials.tex` — the relative cotangent presheaf.
- `Genus.tex` — genus of a smooth proper curve (`g = dim H¹(O_C)`).
- `Jacobian.tex` — the Jacobian as an abelian variety; Route A decomposition A.1–A.4.
- `Rigidity.tex` — scheme-level rigidity (`ext_of_eqOnOpen`).
- `RigidityKbar.tex` — rigidity over a base field; the fallback-(a) `rigidity_over_kbar` (`[CharZero]`).

## Prior critique status

- iter-157: route-(c) architecture (upstream `AbelianVarietyRigidity` file + char-free chain, cube as shared keystone) — addressed (route committed, file built, chain now CLOSING).
- NEW this iter (re-verify): the **OVER_BUDGET re-estimate** of the genus-0 arm (~10–18 → ~18–32 iters), dominated by the theorem of the cube (~8–15) and the genus-0⟹ℙ¹ Riemann–Roch bridge (~5–10), both entirely unstarted with zero Mathlib support. Question for the fresh reader: given the cube's true cost is "comparable to a chunk of representability" AND it is also required by Route A's Albanese UP, is committing route (c) (build the cube + RR sub-build now, for the genus-0 arm) still the right call versus letting the genus-0 arm wait on Route A's machinery? Is the char-freeness justification load-bearing enough to pay this cost, or is it sunk-cost momentum?
