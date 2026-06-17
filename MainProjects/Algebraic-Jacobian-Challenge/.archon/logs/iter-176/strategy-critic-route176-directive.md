# strategy-critic — directive (slug: route176)

## Mode

Fresh-context critic of the global strategy. Read `STRATEGY.md` verbatim
and challenge it against the references / blueprint / goal.

## Inputs

### `STRATEGY.md` (current; entering iter-176)

```
[paste of STRATEGY.md inserted verbatim below]
```

```markdown
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C / k`, with **no** `C(k) ≠ ∅` hypothesis.
End-state: zero inline `sorry`, kernel-only axioms.

The witness OBJECT `J` is always real (constructed unconditionally); only
`isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. Spine:
**pointed vs. unpointed**. `genus C := \dim_k H^1(C, O_C)` (arithmetic
genus; protected — cannot be re-typed).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **A.1.a — `RelativeSpec`** | chapter LANDED; file-skeleton open; QcohAlgebra carrier axiom-clean | ~3–5 | ~200–400 · ~50/it | qcoh-algebras → schemes; affine-base reduction | mechanical once skeleton lands |
| **A.1.b — `LineBundle.Pullback`** | chapter LANDED; file-skeleton landed | ~2–4 | ~200–400 · ~50/it | line-bundle pullback; sheafification | small once A.1.a body lands |
| **A.1.c — `RelPic functor`** | chapter LANDED; file-skeleton pending | ~2–4 | ~300–500 · gated | ét-sheafification; presheaf functoriality | wires Pic^♯ from A.1.a + A.1.b |
| **A.2.a.i — Generic flatness** | chapter LANDED (consolidated A.2.a); sub-phase pending | ~3–5 | ~500–800 · gated | Stacks 052H pieces; generic flatness | foundation for A.2.a.ii/iii |
| **A.2.a.ii — Noetherian induction over coherent strata** | chapter LANDED (consolidated A.2.a); sub-phase pending | ~3–5 | ~800–1300 · gated | noetherian induction; stratum definition | iterates on A.2.a.i |
| **A.2.a.iii — Stratum-glueing & functoriality** | chapter LANDED (consolidated A.2.a); sub-phase pending | ~3–5 | ~700–1400 · gated | gluing along finite stratification | assembly of A.2.a.i + ii |
| **A.2.b.i — Grassmannian scheme** | chapter LANDED (consolidated A.2.b); sub-phase pending | ~4–7 | ~600–1100 · gated | Plücker; projective embedding; functor of points | absent from Mathlib; precursor to A.2.b.ii |
| **A.2.b.ii — Flat-locus open subscheme** | chapter LANDED; sub-phase pending | ~3–5 | ~800–1500 · gated | flat-locus openness; descent of flatness | builds on A.1.a + A.2.a.i |
| **A.2.b.iii — Quot representability assembly** | chapter LANDED; sub-phase pending | ~4–7 | ~1200–2400 · gated | Quot via Hilbert; sub-scheme glueing | bundles A.2.b.i + ii + A.2.a |
| **A.2.c — FGA `Pic_{C/k}` assembly** | chapter LANDED iter-174 | ~4–7 | ~600–800 · gated | wires Quot + RelPic | small assembly |
| **A.3 — `Pic⁰` identity component + degree** | per-sub-phase in `Jacobian.tex` | ~5–8 | ~600–900 · gated | `GroupScheme.IdentityComponent`; `LocallyConstantPushforward` | gated on A.2.c |
| **A.4.a — Lemma 3.3 codim-1 + Weil-divisor surface API** | chapter LANDED; shares with RR.1 | ~13–20 | ~1500–2500 · gated | codim-1 indeterminacy; Weil-divisor surface; valuative criterion | dominant Route-A risk |
| **A.4.b — Auslander–Buchsbaum import** | chapter LANDED; file-skeleton LANDED iter-175 | ~4–7 | ~500–700 · gated | depth, projective dimension | independently startable on Mathlib side |
| **A.4.c — Thm 3.2 rational-map-extension assembly** | chapter LANDED; file-skeleton LANDED iter-175 | ~5–8 | ~600–900 · gated | bundles A.4.a + A.4.b | small assembly |
| **A.4.d.i — `Sym^g C` sub-build** | chapter LANDED (Albanese_AlbaneseUP §Sym^g) | ~4–6 | ~400–700 · gated | quotient by S_g; smoothness/properness; functor of points | new project material; prerequisite to A.4.d.ii |
| **A.4.d.ii — Albanese UP wiring** | chapter LANDED; Sym^g route ii committed | ~3–5 | ~200–400 · gated | uses A.4.d.i + A.3 + A.4.c; Milne Prop 6.1 verbatim | small assembly once Sym^g lands |
| **Genus-0 rigidity — `gmScalingP1` body chain** | STUCK 5 consec iters; iter-175 PARTIAL was session-limit damaged; option (a) STRICT one-shot iter-176 | ~2–4 | ~80–150 · ~0/it (5 iters realized) | chart-bridge structural pivot; `Scheme.Cover.glueMorphisms` | residual = chart_PLB_eq Step C + chart_agreement cross |
| **Genus-0 RR.1 — Weil divisors** | file body-fill open | ~3–6 | ~250–450 · ~30/it | divisors at scheme level; closed-point order; degree map | parallel-startable RR entry |
| **Genus-0 RR.2 — RR formula for genus 0** | chapter + file-skeleton landed | ~3–5 | ~400–600 · ~0/it | finite-rank cohomology; Euler-char; SES additivity (gap) | dimension-count engine |
| **Genus-0 RR.3 — `O_C(P)` global sections** | chapter LANDED; file-skeleton DIED to session-limit iter-175 | ~3–5 | ~400–600 · gated | invertible sheaf at point; restriction sequence | extracts non-constant function |
| **Genus-0 RR.4 — rational ⟹ `≅ ℙ¹`** | chapter LANDED | ~3–5 | ~400–600 · gated | `Proj.fromOfGlobalSections`; degree-1 iso | finishes the bridge |
| `genusZeroWitness` body + `k̄→k` descent | gated on genus-0 rigidity + RR bridge | 3–5 | 350–850 · gated | terminal cluster on Spec k; faithfully-flat descent | descent direction LOCKED to (i) Spec-k-direct (see Open Q) |
| `nonempty_jacobianWitness` body | gated on both arms | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

**Total positive-genus arm**: ~50–95 iters / ~9000–16000 LOC.
**Total genus-0 arm**: ~14–25 iters / ~1800–3000 LOC (gates the witness body).

## Routes

Positive-genus arm = **Route A (Picard scheme via FGA)** — mandatory.
Genus-0 arm = **Route C (Milne §I.3 rigidity)** — `J = Spec k` trivial,
chosen for least Mathlib blockedness; char-general.

### Route A — Picard scheme / Albanese via FGA

`J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6. A.2 and
A.4 are decomposed into named sub-phases (A.2.a.i/ii/iii, A.2.b.i/ii/iii,
A.4.a/b/c/d.i/d.ii) with per-sub-phase iter bands. A.4.a is the dominant
project risk; A.4.b is independently startable on the Mathlib side.

**Parallelism reality.** Dependency graph: A.1.b ⊳ A.1.a; A.1.c ⊳ A.1.b;
A.2.a.ii ⊳ A.2.a.i; A.2.a.iii ⊳ A.2.a.ii; A.2.b.ii ⊳ A.1.a + A.2.a.i;
A.2.b.iii ⊳ A.2.b.i + A.2.b.ii; A.2.c ⊳ A.2.b.iii + A.1.c; A.3 ⊳ A.2.c;
A.4.c ⊳ A.4.a + A.4.b; A.4.d.ii ⊳ A.4.d.i + A.3 + A.4.c. Parallel-startable
prover lanes THIS iter: A.1.a (active body), A.2.a.i (file-skeleton open),
A.2.b.i (file-skeleton open), A.4.b (active body — file-skeleton landed iter-175),
A.1.c (file-skeleton open), A.4.c (active body — file-skeleton landed iter-175),
genus-0 prover (active under option-(a) one-shot), RR.1 (active body).
Blueprint writers fan out concurrently across un-written sub-phases.

### Route C — genus-0 rigidity completion via Milne §I.3

Genus-0 witness OBJECT is the trivial `J = Spec k`; no Picard scheme.
Remaining content: over `k̄`, every pointed `f : C → A` is constant.
Rigidity Lemma + Cor 1.5 + Cor 1.2 are proven axiom-clean. Base case
`ℙ¹→A const` via the **`𝔾_m`-scaling shortcut**: `σ_×: ℙ¹ × 𝔾_m → ℙ¹`
fixes `0`, Cor 1.5 collapses the W-axis ⟹ `f(λx)=f(x)`; density of `𝔾_m`
in `ℙ¹` + `ext_of_isDominant` ⟹ constant. Genus-0 ⟹ ℙ¹ via the RR bridge.
NO cube, NO Thm 3.2, NO Auslander–Buchsbaum, NO `Hom(𝔾_a,A)=0`, NO
diff/Frob; char-general.

## Open strategic questions

- **`k̄→k` descent — LOCKED to (i) Spec-k-direct.** Decision: the
  genus-0 witness body proves `IsAlbanese C P J` directly over
  `Over (Spec k)` by checking the universal property at the structural
  morphism `C → Spec k`. A factorisation `α : J = Spec k → A` is
  constant on points; the equality `f = α ∘ P` of `Over k`-morphisms
  reduces to equality on the generic fibre, available via faithfully-flat
  descent along `Spec k̄ → Spec k`. No need to build `C_{k̄} ≅ ℙ¹` as a
  separate intermediate. (Reversal: if `genusZeroWitness.key` body fill
  blocks on the descent step iter-180+, reconsider via `C_{k̄} ≅ ℙ¹`.)
- **A.4.a ↔ RR.1 shared material.** Both need closed-point order, divisor
  degree, and codim-1 indeterminacy. Resolve via a single shared file
  (`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` populated by RR.1,
  then consumed by A.4.a). Cross-reference audit owed once RR.1
  spec-refinement settles.
- **Axiomatise-then-replace staging.**
  Open option: admit temporary `axiom`s for `flattening stratification`
  (Stacks 052H), `Grassmannian` representability, `Quot` representability,
  and `FGA Pic_{C/k}` representability. Status: TRACKED, NOT COMMITTED.
  Decision trigger: if iter-180 Route A velocity remains `~0/it` on the
  file-skeleton lanes opening this iter, escalate to user-level
  option-choice (axiomatise vs persist in-tree build) in `TO_USER.md`.
- **Alternative considered: `Sym^g C` / theta-divisor Jacobian (Mumford)
  for positive-genus arm.** REJECTED — no `Sym^g` in Mathlib; needs
  `k`-rational base-point. Recorded so re-planners don't re-litigate.
- **Alternative considered: `Pic⁰`-functor-of-points Albanese-UP (skip
  A.4.a's codim-1 surface API).** REJECTED on strict bypass.
- **Route-C genus-0 chart-bridge route — STRICT one-shot trigger iter-176.**
  iter-175 attempted PARTIAL via congrHom-arg restructure; analogist
  recipe option (a) (`simp only [Fin.isValue, Fin.zero_eta]`) was NOT
  applied before session-limit hit. iter-176 dispatches a STRICT
  one-shot directive that requires the prover to apply option (a) AS
  WRITTEN in `analogies/chart-bridge-structural-pivot.md`. **Reversal
  trigger**: if iter-176 closes 0 Step C sorries with option (a) on
  file, iter-177 escalates to user via `TO_USER.md` proposing route
  pivot to differential `H⁰(ℙ¹, O(-2))=0` char-0 sub-case.

## Mathlib gaps & new material

**Gaps to fill (CRITICAL PATH — Route A engine):**

- A.1.a `RelativeSpec` functor. ~200–400 LOC.
- A.1.b Line-bundle pullback on `C ×_k T`. ~200–400 LOC.
- A.1.c Relative Picard presheaf + ét-sheafification. ~300–500 LOC.
- A.2.a Flattening stratification (Stacks 052H absent; 3 sub-phases).
  ~2000–3500 LOC.
- A.2.b Quot scheme + Grassmannian (Nitsure §5; 3 sub-phases).
  ~2600–5000 LOC.
- A.2.c FGA `Pic_{C/k}` assembly. ~600–800 LOC.
- A.3 `Pic⁰` identity component + degree map. ~600–900 LOC.
- A.4.a Lemma 3.3 codim-1 + Weil-divisor surface API. ~1500–2500 LOC.
- A.4.b Auslander–Buchsbaum (at the required form). ~500–700 LOC.
- A.4.c Thm 3.2 rational-map-extension assembly. ~600–900 LOC.
- A.4.d.i Sym^g of schemes (quotient by `S_g`). ~400–700 LOC.
- A.4.d.ii Albanese UP wiring (Milne Prop 6.1 via Sym^g). ~200–400 LOC.

**Gaps to fill (genus-0 rigidity — Route C):**

- `σ_×:ℙ¹×𝔾_m→ℙ¹` scaling action as a TOTAL scheme morphism. Body
  skeleton landed; residual = chart_PLB_eq Step C + chart_agreement
  cross cases. Recipe in `analogies/chart-bridge-structural-pivot.md`.
- genus-0 + k̄-point ⟹ `≅ ℙ¹` — RR.1/RR.2/RR.3/RR.4.
- No `AbelianVariety` theory and no general Riemann–Roch in Mathlib
  (both verified absent).

**New project material introduced:**

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` +
  `AlgebraicJacobian/RigidityLemma.lean` — route-C AV-rigidity stack.
- `AlgebraicJacobian/Genus0BaseObjects/{BareScheme, ChartIso, Points,
  GmScaling}.lean` (4-way split iter-175).
- `AlgebraicJacobian/Rigidity.lean` `ext_of_eqOnOpen`.
- `AlgebraicJacobian/RiemannRoch/{WeilDivisor, RRFormula}.lean`.
- `AlgebraicJacobian/Picard/{RelativeSpec, LineBundlePullback}.lean`.
- `AlgebraicJacobian/Albanese/{AuslanderBuchsbaum, Thm32RationalMapExtension}.lean`
  (iter-175 file-skeletons).
- Planned: 5 more file-skeletons under `Picard/`, `Albanese/`,
  `RiemannRoch/` (re-dispatching iter-176 after iter-175 session-limit damage).
```

### `references/summary.md` (excerpt)

Short reference index (full file under `references/summary.md`):
- `references/challenge.lean.ref` — original AI challenge (protected signatures).
- `references/abelian-varieties.pdf` — Milne, Abelian Varieties (Route C rigidity).
- `references/kleiman-picard.pdf` — Kleiman, Picard scheme (Route A).
- `references/nitsure-hilbert-quot.pdf` — Quot scheme construction.
- `references/hartshorne-iii-iv.pdf` — Hartshorne III/IV (RR, divisors).
- `references/stacks-*.md` — Stacks Project sections for sub-phases.

### Project blueprint summary

(One-line topic per chapter — auto-injected by the plan harness; not
duplicated here. The blueprint covers AVR + RigidityLemma + Genus0BaseObjects
sub-files + Picard.{RelativeSpec, LineBundlePullback, FlatteningStratification,
RelPicFunctor, QuotScheme, FGAPicRepresentability} + Albanese.{AuslanderBuchsbaum,
Thm32RationalMapExtension, CodimOneExtension, AlbaneseUP} + RiemannRoch.{WeilDivisor,
RRFormula, OCofP, RationalCurveIso} + Jacobian + Rigidity + RigidityKbar +
AbelJacobi + Genus + Differentials + Cohomology.{StructureSheafAb, StructureSheafModuleK,
MayerVietorisCore, MayerVietorisCover, SheafCompose}.)

### Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge in Lean 4 + Mathlib: nine
protected declarations centred on `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C / k`. Spine: pointed-vs-unpointed split. Pointed case
via Route A (Picard scheme via FGA); unpointed reduces to genus-0 case via
Route C (Milne §I.3 rigidity, `J = Spec k` trivial).

## Standing CHALLENGEs from prior strategy-critic dispatches

iter-175 strategy-critic returned CHALLENGE on six findings; all six were
addressed in the iter-175 STRATEGY.md restructure. Confirm in your report
whether they remain addressed entering iter-176.

## What I'm asking you for

1. Verdict per route (A and C): SOUND / CHALLENGE / REJECT.
2. If CHALLENGE: which specific phases / sub-phases / decisions need
   re-thinking, with explicit corrective recommendation.
3. Velocity reality check: the `Genus-0 rigidity` row shows ~0/it for
   5 iters. Has this row's iter-band become fantasy, and should it be
   re-estimated?
4. Should iter-176's planned "STRICT option-(a) one-shot" attempt be
   redirected to a stronger pivot (e.g. differential `H⁰(ℙ¹, O(-2))=0`)?

Report at `.archon/task_results/strategy-critic-route176.md`.
