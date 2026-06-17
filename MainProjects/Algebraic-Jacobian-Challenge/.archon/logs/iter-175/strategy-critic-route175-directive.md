# Strategy Critic Directive

## Slug
route175

## Project goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C / k`, with **no** `C(k) \neq \emptyset` hypothesis. The
witness OBJECT `J` is always real (constructed unconditionally); only
`isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. The spine is
**pointed vs. unpointed**, not genus-0 vs. positive. `genus C := \dim_k H^1(C, O_C)`
(arithmetic genus, protected — cannot be re-typed). End-state: zero inline
`sorry`, kernel-only axioms.

## Strategy under review

<inline copy of STRATEGY.md follows>

# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese / Jacobian
object uniform over the $k$-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with **no** `C(k) \neq \emptyset` hypothesis. End-state:
zero inline `sorry`, kernel-only axioms.

The protected signature quantifies over arbitrary `C` with no $C(k) \neq \emptyset$
assumption. The witness OBJECT `J` is always real (constructed unconditionally);
only `isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. The spine is
**pointed vs. unpointed**, not genus-0 vs. positive. `genus C := \dim_k H^1(C,O_C)`
(arithmetic genus; protected — cannot be re-typed).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **A.1.a — `RelativeSpec`** (CRITICAL PATH; parallel-startable) | chapter LANDED; file-skeleton lane open | ~3–5 | ~200–400 · ~0/it | `RelativeSpec` functor; affine-base reduction; base change | mechanical once file-skeleton lands |
| **A.1.b — `LineBundle.Pullback`** (CRITICAL PATH; gated on A.1.a) | chapter LANDED; file-skeleton lane gated | ~2–4 | ~200–400 · gated | line-bundle pullback by base change; sheafification | small once A.1.a lands |
| **A.1.c — `RelPic functor`** (CRITICAL PATH; gated on A.1.b) | chapter LANDED iter-174 | ~2–4 | ~300–500 · gated | ét-sheafification; presheaf functoriality | wires `Pic^♯` from A.1.a + A.1.b |
| **A.2.a — Flattening stratification** (CRITICAL PATH; parallel-startable) | chapter LANDED iter-174 | ~8–14 | ~1200–2000 · ~0/it | Stacks 052H; generic flatness; noetherian induction | dominant LOC under-count risk |
| **A.2.b — Quot scheme representability** (gated on A.2.a + A.1.a) | chapter LANDED iter-174 | ~10–17 | ~1500–2500 · gated | Grassmannian scheme; `QuotScheme`; flat-locus open subscheme | load-bearing FGA piece |
| **A.2.c — FGA `Pic_{C/k}` assembly** (gated on A.2.b + A.1.c) | chapter LANDED iter-174 | ~4–7 | ~600–800 · gated | wires Quot + RelPic | small assembly |
| **A.3 — `Pic⁰` identity component + degree** (gated on A.2.c) | per-sub-phase in `Jacobian.tex` | ~5–8 | ~600–900 · ~0/it | `GroupScheme.IdentityComponent`; `LocallyConstantPushforward` | gated on A.2.c |
| **A.4.a — Lemma 3.3 codim-1 + Weil-divisor surface API** (shares with RR.1) | chapter LANDED iter-174 | ~13–20 | ~1500–2500 · gated | codim-1 indeterminacy; Weil-divisor surface API; valuative criterion | dominant Route-A risk; project-fatal if it stalls |
| **A.4.b — Auslander–Buchsbaum import** (gated on A.4.a) | chapter LANDED iter-174 | ~4–7 | ~500–700 · gated | depth, projective dimension, regular local rings | independently startable on Mathlib-import side |
| **A.4.c — Thm 3.2 rational-map-extension assembly** (gated on A.4.a + A.4.b) | chapter LANDED iter-174 | ~5–8 | ~600–900 · gated | bundles A.4.a + A.4.b | small assembly |
| **A.4.d — Albanese UP wiring via Sym^g C** (gated on A.3 + A.4.c + Sym^g) | chapter LANDED iter-174; Sym^g writer re-dispatch THIS iter | ~5–10 | ~500–900 · gated | `Sym^g` of schemes (absent); `lem:rational_map_to_av_extends` | autoduality bypass FAILS (cube excised); Sym^g sub-build is the prerequisite |
| **Genus-0 rigidity — `gmScalingP1` body chain** | 4th consecutive PARTIAL; G0BO split + analogist structural pivot THIS iter | ~3–6 | ~100–170 · ~25/it | `Scheme.Cover.glueMorphisms`; `pullbackSpecIso`; chart-bridge structural pivot | residual concentrated in chart_PLB_eq Step C + chart_agreement cross |
| **Genus-0 RR.1 — Weil divisors on smooth curve** (parallel-startable) | file body-fill open | ~3–6 | ~300–500 · ~0/it | divisors at scheme level; closed-point order; degree map | parallel-startable RR entry |
| **Genus-0 RR.2 — RR formula for genus 0** (gated on RR.1) | chapter LANDED; file-skeleton landed iter-174 | ~3–5 | ~400–600 · ~0/it | finite-rank cohomology + Euler-char; SES additivity (Mathlib gap) | dimension-count engine |
| **Genus-0 RR.3 — `O_C(P)` global sections (`dim = 2`)** (gated on RR.2) | chapter LANDED iter-174 | ~3–5 | ~400–600 · gated | invertible sheaf at a point; restriction sequence; H⁰ identification | extracts non-constant function |
| **Genus-0 RR.4 — rational curve ⟹ `≅ ℙ¹`** (gated on RR.3) | chapter LANDED iter-174 | ~3–5 | ~400–600 · gated | `Proj.fromOfGlobalSections`; degree-1 morphism is iso | finishes the bridge |
| `genusZeroWitness` body + terminal cluster + `k̄→k` descent | gated on genus-0 rigidity + RR bridge | 3–5 | 350–850 · gated | terminal cluster on `Spec k`; faithfully-flat descent of morphism equality | descent direction unconfirmed |
| `nonempty_jacobianWitness` genus-stratified body | gated on both arms | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

## Routes

Positive-genus arm = **Route A (Picard scheme via FGA)** — mandatory.
Genus-0 arm = **Route C (Milne §I.3 rigidity)** — object trivial, lower risk,
chosen for least Mathlib blockedness.

### Route A — Picard scheme / Albanese via FGA

`J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6. A.4 split
into A.4.a (Lemma 3.3 codim-1, risk-dominant), A.4.b (Auslander–Buchsbaum),
A.4.c (Thm 3.2 assembly), A.4.d (Albanese UP wiring via Sym^g).

**Parallelism reality.** Dependency graph: A.1.b ⊳ A.1.a; A.1.c ⊳ A.1.b;
A.2.b ⊳ A.2.a + A.1.a; A.2.c ⊳ A.2.b + A.1.c; A.3 ⊳ A.2.c; A.4.c ⊳ A.4.a +
A.4.b; A.4.d ⊳ A.3 + A.4.c. Parallel-startable prover lanes: A.1.a (active),
A.2.a (file-skeleton iter-175), genus-0 prover (active under structural pivot),
RR.1 (active), A.4.b (file-skeleton iter-175). Blueprint writing fans out
across every un-written sub-chapter concurrently.

### Route C — genus-0 rigidity completion via Milne §I.3

Genus-0 witness OBJECT is the trivial `J = Spec k`; no Picard scheme.
Remaining content: over `k̄`, every pointed `f : C → A` from a genus-0 curve
to an abelian variety is constant. Rigidity Lemma + Cor 1.5 + Cor 1.2 are
proven axiom-clean. Base case `ℙ¹→A const` via the **`𝔾_m`-scaling shortcut**:
`σ_×: ℙ¹ × 𝔾_m → ℙ¹` fixes `0`, Cor 1.5 collapses the W-axis ⟹ `f(λx)=f(x)`;
density of `𝔾_m` in `ℙ¹` + `ext_of_isDominant` ⟹ constant. Genus-0 ⟹ ℙ¹ via
the RR bridge. NO cube, NO Thm 3.2/Lemma 3.3, NO Auslander–Buchsbaum, NO
`Hom(𝔾_a,A)=0`, NO differentials/Frobenius; char-general.

## Open strategic questions

- **A.4.a ↔ RR.1 shared material.** Both need closed-point order, divisor
  degree, and the codim-1 indeterminacy structure. Resolve via a single
  shared source file (`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
  populated by RR.1, then consumed by A.4.a) rather than parallel
  definitions.
- **`k̄→k` descent is route-dependent.** A `Pic⁰`-over-`k` argument may give
  `Alb(C)=Spec k` directly; a `C_{k̄}≅ℙ¹` argument incurs faithfully-flat
  descent of a morphism equality.
- **Alternative considered: `Sym^g C` / theta-divisor Jacobian (Mumford).**
  REJECTED for the positive-genus arm (no `Sym^g` in Mathlib; needs
  `k`-rational base-point which goal disallows). For A.4.d (NOT positive-genus
  Jacobian construction) Sym^g IS used as the Albanese-UP wiring path
  (Route ii).
- **A.4.d — Sym^g of schemes prerequisite (decided iter-174).** Committed to
  **Route (ii)**: Milne's verbatim Prop 6.1 proof via `Sym^g C ⇢ J` and
  `lem:rational_map_to_av_extends`. Rejected the moduli-theoretic Route (i)
  (autoduality `J ≅ J^∨` via cube — EXCISED iter-163). Sym^g sub-build is
  new project material; LOC envelope absorbed into A.4.d row.
- **Genus-0 rigidity STUCK escalation arm (iter-175).** Per iter-174 review
  with 4 consecutive PARTIAL on Lane A, this iter executes the deferred
  G0BO split refactor (1143 LOC → 4 sub-files) + a chart-bridge
  structural-pivot analogist consult, to relieve the Fin syntactic-mismatch
  bottleneck on chart_PLB_eq Step C.

## Mathlib gaps & new material

**Gaps to fill (CRITICAL PATH — Route A engine):**

- A.1.a `RelativeSpec` functor. ~200–400 LOC.
- A.1.b Line-bundle pullback on `C ×_k T`. ~200–400 LOC.
- A.1.c Relative Picard presheaf + ét-sheafification. ~300–500 LOC.
- A.2.a Flattening stratification (Stacks 052H absent). ~1200–2000 LOC.
- A.2.b Quot scheme representability (Nitsure §5); includes Grassmannian sub-build. ~1500–2500 LOC.
- A.2.c FGA `Pic_{C/k}` assembly. ~600–800 LOC.
- A.3 identity-component subgroup scheme `Pic⁰ ⊆ Pic`; degree map. ~600–900 LOC.
- A.4.a Lemma 3.3 codim-1 + Weil-divisor surface API. ~1500–2500 LOC.
- A.4.b Auslander–Buchsbaum. ~500–700 LOC.
- A.4.c Thm 3.2 rational-map-extension assembly. ~600–900 LOC.
- A.4.d Albanese UP wiring via Sym^g C. ~500–900 LOC (Route ii).
- Sym^g of schemes (A.4.d prerequisite): symmetric power of a curve as a
  quotient scheme by the `S_g` action. Absent from Mathlib.

**Gaps to fill (genus-0 rigidity — Route C):**

- `σ_×:ℙ¹×𝔾_m→ℙ¹` scaling action as a TOTAL scheme morphism. Body skeleton
  landed; residual = Step C of chart_PLB_eq + cross cases of chart_agreement.
- genus-0 + k̄-point ⟹ `≅ ℙ¹` (Hartshorne IV.1.3.5) — RR.1/RR.2/RR.3/RR.4.
- No `AbelianVariety` theory and no general Riemann–Roch in Mathlib (both
  verified absent).

**New project material introduced:**

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` + `AlgebraicJacobian/RigidityLemma.lean`
  — route-C AV-rigidity stack.
- `AlgebraicJacobian/Genus0BaseObjects.lean` (post-split iter-175 → 4 sub-files):
  `ProjectiveLineBar`/`Gm`/`Ga`/scaling-action infrastructure.
- `AlgebraicJacobian/Rigidity.lean` `ext_of_eqOnOpen` — dominant-source /
  separated-target rigidity packaging.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — RR.1 in-tree sub-build.
- `AlgebraicJacobian/Picard/{RelativeSpec, LineBundlePullback}.lean` —
  iter-173/174 file-skeleton landings.
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean` — iter-174 file-skeleton.
- Planned iter-175+ file-skeletons: 7 more sub-modules under Picard/, Albanese/,
  RiemannRoch/.

## References

References summary follows:

```
| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge by Christian Merten. |
| `stacks-varieties.md` → `.tex` | Stacks ch.33 Varieties — geom-reduced / smooth-over-fields / 8-part H^0 lemma. |
| `stacks-fields.md` → `.tex` | Stacks ch.9 Fields — purely inseparable / separable factorisation. |
| `stacks-algebra.md` → `.tex` | Stacks ch.10 Commutative Algebra — standard smooth ⇒ Ω free. |
| `stacks-coherent.md` → `.tex` | Stacks ch.30 Cohomology of Schemes — flat base change of R^i f_*. |
| `stacks-constructions.md` → `.tex` | Stacks ch.27 Constructions — relative spectrum. |
| `kleiman-picard.md` → `.pdf/.tex` | Kleiman, "The Picard scheme" — Route A source. §4/§5/§6. |
| `nitsure-hilbert-quot.md` → `.pdf/.tex` | Nitsure, "Construction of Hilbert and Quot Schemes" — Route A engine. |
| `abelian-varieties.md` → `.pdf` | Milne, "Abelian Varieties" — Rigidity Thm 1.1; Thm 3.2; cube §I.5; Albanese UP §III.6. |
| `mumford-abelian-varieties.md` → `.pdf` | Mumford, "Abelian Varieties" — alternative reference. |
| `hartshorne.pdf` | Hartshorne — RR / curves / II.6 divisors / IV.1 RR-formula. |
| ... and others ... |
```

## Blueprint summary

26 chapters; iter-174 landed 10 new chapter files. Recently-touched chapters:

- `AbelianVarietyRigidity.tex` — consolidated (covers AVR + G0BO + RigidityLemma).
- `Picard_RelativeSpec.tex` — landed iter-172.
- `Picard_LineBundlePullback.tex` — landed iter-173.
- `Picard_RelPicFunctor.tex` — landed iter-174 (NEW).
- `Picard_FlatteningStratification.tex` — landed iter-174 (NEW).
- `Picard_QuotScheme.tex` — landed iter-174 (NEW).
- `Picard_FGAPicRepresentability.tex` — landed iter-174 (NEW).
- `Albanese_CodimOneExtension.tex` — landed iter-174 (NEW).
- `Albanese_AuslanderBuchsbaum.tex` — landed iter-174 (NEW).
- `Albanese_Thm32RationalMapExtension.tex` — landed iter-174 (NEW).
- `Albanese_AlbaneseUP.tex` — landed iter-174 (NEW; needs iter-175 Sym^g re-dispatch per a4d-albanese writer's strategy-modifying finding).
- `RiemannRoch_WeilDivisor.tex` — landed iter-172.
- `RiemannRoch_RRFormula.tex` — landed iter-173.
- `RiemannRoch_OCofP.tex` — landed iter-174 (NEW).
- `RiemannRoch_RationalCurveIso.tex` — landed iter-174 (NEW).

## Prior critique status

- iter-174: A.2.a/A.2.b/A.4.a LOC bands undercounted — addressed (widened in STRATEGY.md).
- iter-174: 2 alternative-route omissions (Sym^g for positive-genus Jacobian; Pic⁰-functor-of-points UP) — addressed (recorded in `## Open strategic questions`).
- iter-174: STRATEGY.md format DRIFTED 14% over byte budget — addressed (trimmed).
- iter-174: A.4.d Route ii Sym^g committed; Route i (autoduality) REJECTED (cube excision conflict) — addressed (recorded as decision).
