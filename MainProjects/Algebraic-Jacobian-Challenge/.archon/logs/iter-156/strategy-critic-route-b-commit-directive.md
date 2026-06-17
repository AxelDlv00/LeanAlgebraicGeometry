# Strategy Critic Directive

## Slug
route-b-commit

## Project goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`): nine
protected declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese/Jacobian object
uniform over the `k`-rational pointing of a smooth proper geometrically irreducible
curve `C/k`, with NO `C(k) ≠ ∅` hypothesis on the protected signature. The witness
object `J` is always real (constructed unconditionally); only `isAlbaneseFor` is
universally quantified over `P : 𝟙_ ⟶ C`. `genus C := dim_k H^1(C,O_C)` (arithmetic
genus) is a PROTECTED definition (cannot be re-typed). End-state: zero inline
`sorry`, kernel-only axioms.

The single most consequential decision under review this iter: the strategy has
just COMMITTED to "route (b)" — routing the genus-0 rigidity (`rigidity_over_kbar`)
through Route A's Pic⁰/Albanese engine (via `Alb(genus-0 curve)=0`) rather than
through the differential `df=0` argument (which would need a standalone Serre-duality
build). The committing argument is: Route A's Pic⁰ engine is mandatory anyway for
the positive-genus object, so amortising genus-0 onto it beats adding Serre duality
on top. A side effect is that the closed, axiom-clean chart-algebra envelope (~10
iters of work) drops OFF the critical path (kept as a fallback asset, not deleted).
Challenge this decision hard — including whether it is sunk-cost-blind in the OTHER
direction (discarding proven work to chase a riskier FGA engine).

## Strategy under review

<paste verbatim below>

---
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
(arithmetic genus; protected).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **Route A — Picard/Quot/Hilbert FGA engine** (now CRITICAL-PATH, serves BOTH arms) | committed (route-b decision), barely scaffolded | many (~40–70) | ~5100+ · 0/it | Hilbert/Quot representability (Nitsure §4–5); FGA `Pic_{C/k}` repr; identity component `Pic⁰`; Albanese universal property | A.2 representability is the riskiest, least-Mathlib-supported piece; smallest entry `RelativeSpec` ~700–1100 LOC. Project-fatal if it stalls — but mandatory regardless (positive-genus object) |
| **genus-0 rigidity via Route A** (`rigidity_over_kbar` re-proved through `Pic⁰`/Albanese) | gated on Route A engine | 2–4 | ~500–2000 · gated | `Pic⁰(ℙ¹)=0` / `Alb(genus-0)=Spec k̄`; Albanese factorization for `f : C → A` killing `P` | small increment ONCE the engine exists; replaces the refuted differential `df=0` route |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated | 3–5 | 350–850 · gated | terminal-object cluster on `Spec k`; **faithfully-flat descent of morphism equality** along `Spec k̄ → Spec k` | descent (right-cancellation direction unconfirmed); skeleton already built iter-155 (6/7 fields closed, only `key` rigidity equation open) |
| **char-`p` genus-0 rigidity** (protected goal over arbitrary `[Field k]`, no `CharZero`) | gated, required, UNSCOPED | ? | ? · 0 | descent of constancy through Frobenius; OR a char-free Albanese argument | the differential route carried `[CharZero k]`; route-(b) Albanese argument MAY be char-free (Pic⁰ works in all char) — re-assess once the engine exists. No concrete plan yet |
| `nonempty_jacobianWitness` genus-stratified body | gated | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

## Routes

Single committed route for the witness OBJECT and BOTH universal-property arms:
**Route A (Picard scheme via FGA)**. One fallback (route a) is kept live with an
explicit reversal signal.

### Route A (COMMITTED, both arms) — Picard scheme / Albanese via FGA

Hilbert/Quot representability + identity-component `Pic⁰` + Albanese universal
property. Decomposition A.1–A.4 in `Jacobian.tex` § "Route A". Literature in-tree:
`references/kleiman-picard.pdf` (§4 existence, §5 `Pic⁰`), `references/nitsure-hilbert-quot.pdf`
(Quot/Hilbert engine).

**Positive-genus arm:** `J := Pic⁰_{C/k}`, a dim-`g` abelian variety; the Albanese
UP gives `isAlbaneseFor`. **Genus-0 arm:** `Alb(C_k̄) = Pic⁰(genus-0) = Spec k̄`
(`Pic⁰(ℙ¹)=0`), so any `f : C → A` killing `P` factors through `Spec k̄` ⟹
constant — this is `rigidity_over_kbar` re-proved through the engine, NOT through
differentials. Both arms therefore share ONE engine.

**The route-(b) decision (iter-156).** The keystone `df = 0` for the differential
route is irreducibly a **global-sections** fact: `df = 0 ⟺ H^0(C,Ω_C)=0` given
`Ω_A` triviality (analogist `df-zero-production-iter155`). Since `genus := h^1(O_C)`
(protected), genus-0 does NOT give `h^0(Ω_C)=0` without **Serre duality**
(`h^0(Ω)=h^1(O)`, ~3000–8000 LOC, absent from Mathlib). Producing `df=0` thus needs
{Serre duality + `Ω_A` globalisation}. Because Route A's `Pic⁰` engine is
**mandatory anyway** for the positive-genus object, routing genus-0 rigidity through
it (`Alb(ℙ¹)=0`) amortises against required work; the differential route would add
a standalone Serre-duality build on top. **Route A wins on total budget.**

**Cost displaced downstream (unchanged by the route choice):** rigidity proved over
`k̄` means `genusZeroWitness` over arbitrary `k` must descend the constancy
conclusion along `Spec k̄ → Spec k` — faithfully-flat descent of a morphism equality
(`f_{k̄} = g_{k̄} ⟹ f = g`), NOT the right-cancellation `Flat.epi_of_flat_of_surjective`
gives. Assess against Mathlib's scheme-descent API when `genusZeroWitness` activates.

### Fallback (route a) — differential route via Serre duality

`df = 0` via {`Ω_A` global cotangent-triviality (~800–1500) + Serre duality
`H^0(C,Ω_C)=0` (~3000–8000)}, REUSING the **closed, axiom-clean chart-algebra
envelope** (`mem_range_algebraMap_of_D_eq_zero` (KDM), `constants_integral_over_base_field`,
`df_zero_factors_through_constant_on_chart`, thin `ext_of_diff_zero`) which supplies
the converse `df=0 ⟹ constant`. **Kept in tree, off the critical path** — NOT
deleted. **Reversal signal:** if Route A's A.2 representability stalls beyond ~10
iters of genuine effort, revisit route (a) for the genus-0 arm only (the chart
envelope is still available, and Serre duality decouples genus-0 from FGA risk).

## Open strategic questions

- **char-`p` genus-0 rigidity:** does the route-(b) Albanese argument close char-`p`
  for free (`Pic⁰` is char-agnostic), removing the need for the Frobenius-descent
  plan the differential route required? Re-assess once the engine exists. This is the
  most likely place the protected `[Field k]` goal silently fails.
- **Route A scheduling:** start scaffolding at the smallest entry (`RelativeSpec`
  functor, ~700–1100 LOC) immediately, or flesh the A.1–A.4 blueprint to
  prover-ready detail first? (Blueprint is currently a sketch — HARD GATE blocks a
  prover until a Route A chapter is complete+correct.)
- **`Pic⁰(ℙ¹)=0` cost:** is computing `Pic(ℙ¹)=ℤ` / identity-component `= 0` a small
  increment on the engine, or does it need its own divisor-theory build?
- Should the chart-algebra envelope + GrpObj cotangent material be split out of the
  ~2600-line `RigidityKbar.tex` into a dedicated off-path chapter (structural job)?

## Mathlib gaps & new material

**Gaps to fill (CRITICAL-PATH, route (b)):**

- **Hilbert / Quot scheme representability** (Nitsure §4–5) + **FGA `Pic_{C/k}`
  representability** — the single highest-cost build, upstream of `Pic⁰`. ~3775 LOC.
- **identity-component subgroup scheme** `Pic⁰ ⊆ Pic`; degree map `Pic → ℤ`. ~800.
- **Albanese universal property** of `Pic⁰` (`isAlbaneseFor`): every `f : C → A`
  killing `P` factors uniquely through `Pic⁰` — goal-required for BOTH arms
  (genus-0 via `Alb=0`, positive-genus via the full UP); NOT yet itemised — true
  budget above ~5100.
- **`Pic⁰(genus-0)=0`** (`Pic(ℙ¹)=ℤ`): the genus-0 rigidity keystone under route (b).
- **faithfully-flat descent of morphism equality** along `Spec k̄ → Spec k` (in
  `genusZeroWitness`): injectivity-of-restriction, not right-cancellation.

**Gaps to fill (FALLBACK route a only — off critical path):**

- `df = 0` production: `Ω_A` global cotangent-triviality (~800–1500;
  `cotangentSpaceAtIdentity`/`shearMulRight` design templates) + **Serre duality**
  `H^0(C,Ω_C)=0` (~3000–8000; no Mathlib dualizing sheaf / Riemann–Roch / genus↔Ω
  bridge). The chart `Ω_C(V)` is free rank-1, so the KDM stack cannot detect `df=0`.

**New project material introduced (in tree):**

- `Cotangent/ChartAlgebra.lean` — chart-algebra envelope (KDM, constants,
  `df_zero_factors`, thin `ext_of_diff_zero`). CLOSED, axiom-clean. Now route-(a)
  fallback asset, off critical path.
- `Cotangent/GrpObj.lean` — `cotangentSpaceAtIdentity` trio; `shearMulRight`. Design
  template for the `Ω_A` globalisation (fallback only).
- `Rigidity.lean` `ext_of_eqOnOpen` — dominant-source / separated-target rigidity
  packaging; consumed by the scheme-lift + Albanese uniqueness.

**Soundness rules (operational):** No new axioms (every closed decl `lean_verify`s
to `propext, Classical.choice, Quot.sound`). A `sorry` must be the body of a
top-level named declaration — never buried in a `letI`/`have`/anonymous-`fun`
inside another decl.
---

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — formal statement of the missing definitions/theorems for the Jacobian of an algebraic curve. Signatures here are authoritative. |
| `stacks-varieties.md` → `.tex` | Stacks ch.33 "Varieties" — geom-reduced, smooth⇒geom regular/normal/reduced, `H^0(X,O)` lemma. |
| `stacks-fields.md` → `.tex` | Stacks ch.9 "Fields" — purely inseparable, sep-then-insep factorisation. |
| `stacks-algebra.md` → `.tex` | Stacks ch.10 "Commutative Algebra" — standard smooth ⇒ `Ω` free. |
| `stacks-coherent.md` → `.tex` | Stacks ch.30 "Cohomology of Schemes" — flat base change of `R^i f_*`. |
| `kleiman-picard.md` → `.pdf` | Kleiman, "The Picard scheme" (FGA Explained). Route A source. §4 existence, §5 `Pic⁰` (Jacobian, pp.36–51), §6 `Pic^τ` finiteness. |
| `nitsure-hilbert-quot.md` → `.pdf` | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained). Quot/Hilbert construction engine behind Route A. |

## Blueprint summary

- `AbelJacobi.tex` — the Abel–Jacobi map; transits `nonempty_jacobianWitness`.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — cotangent space at identity (piece (i)); `shearMulRight`.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES for sheaf cohomology (k-module coeffs).
- `Cohomology_SheafCompose.tex` — sheaf condition along the structure-sheaf forget composite.
- `Cohomology_StructureSheafAb.tex` — structure sheaf as sheaf of abelian groups; sheafification, Ext.
- `Cohomology_StructureSheafModuleK.tex` — sheaves of k-modules; structure sheaf as k-module sheaf. Computes `H^1(O_C)`; NO `H^0`-vanishing / genus↔Ω bridge.
- `Differentials.tex` — relative cotangent presheaf; `smooth_locally_free_omega` (discloses the false-converse pitfall).
- `Genus.tex` — genus of a smooth proper curve; `genus := dim_k H^1(C,O_C)`.
- `Jacobian.tex` — the Jacobian as an abelian variety; `nonempty_jacobianWitness`, `genusZeroWitness`, `positiveGenusWitness`; Route A (A.1–A.4) + Route B (historical, not pursued).
- `Rigidity.tex` — scheme-level rigidity (`ext_of_eqOnOpen`); Mumford §4 abelian-variety case.
- `RigidityKbar.tex` — rigidity over k̄: genus-0 curve → group scheme constant; `rigidity_over_kbar` (NAMED GAP); chart-algebra envelope (KDM, constants, df_zero_factors); GrpObj cotangent-globalisation design-template blocks (off-path).

## Prior critique status

- iter-155: Route C "resolve the df=0 production question" — addressed (route-(b) decision made this iter).
- iter-155: Route A "itemise the g≥1 Albanese universal property" — addressed (now itemised under Mathlib gaps).
- iter-155: format DRIFTED (per-iter narrative / DONE row / over budget) — addressed (file rewritten, 125 lines / 8.7 KB).
