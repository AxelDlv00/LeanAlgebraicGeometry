# Strategy-critic — iter-205 fresh strategy read

You are a fresh mathematician reviewing this project's strategy with NO
investment in its momentum. Challenge sunk cost. Verdict: SOUND /
CHALLENGE / REJECT per strategic claim, with reasoning.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: existence of an
Albanese/Jacobian object (nine protected Lean declarations headlined by
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness`)
uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with NO `C(k) ≠ ∅` hypothesis, over an
arbitrary field (`[Field k]`, no `CharZero`).

## Current STRATEGY.md (verbatim)

# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge
(`references/challenge.lean.ref`): the nine protected declarations
headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese/Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C/k`, with **no** `C(k) ≠ ∅`
hypothesis. Char-general: `[Field k]` only, no `CharZero`.

The witness object `J` is always real (constructed unconditionally);
only `isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`.
Spine: **pointed vs. unpointed**. `genus C := dim_k H¹(C, O_C)`
(arithmetic genus; protected, cannot be re-typed).

**End-state — option (c), operative under USER 2026-05-28 ROUTE C
PAUSE.** The kernel-triple `#print axioms` contract cannot be delivered
unconditionally while every path to the protected decls transits A.2.c
(FGA Pic representability), which is RR-substrate-blocked. Operative
target: protected `#print axioms` verifies modulo the explicit residual
sorries in the post-Route-A cone audit, with consumers carrying the
RR-substrate dependency in commentary, not in the type signature.
Holds until the USER amends to (a) `J := Spec k` via Mumford rigidity
(carve `AbelianVarietyRigidity` + `RigidityKbar` out of the pause,
~300–500 LOC) or (b) full Route C re-engagement. Loop runs Route A
substrate continuously under (c); when all priority-1/2 roots close, a
TO_USER re-escalation surfaces the cone audit. Currently 0 project
axioms (24-consecutive-zero-axiom streak).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| A.1.c.SubT — `Scheme.Modules.tensorObj` substrate | active; sole productive lane | ~2–4 | ~120–250 · ~2/it | `MorphismProperty.IsMonoidal` for the module-sheafification localization | Cone reduced to ONE gap (see Routes); `monoidalCategory := sorry` is a contamination-guard instance |
| A.1.c — RelPic functor | held (placeholder bodies) | ~3–5 post-SubT | ~50–150 · 0/it | A.1.c.SubT + ét-sheafify on `Over S` | RE-ENGAGEMENT GATE: must replace dishonest `PicSharp := const PUnit` first |
| A.4.a — codim-1 + Weil-divisor substrate | substrate DONE; terminal closure USER-blocked | ~0 active | ~40–80 · 0/it | terminal needs `[IsNoetherian X]`/`[CompactSpace X]` sig | sig strengthening is USER-gated |
| A.4.c.0 — codim-≥2 conclusion | **STUCK + PAUSED** pending USER | USER-gated | ~0/it sorry-progress | Step A2 = Stacks 02JK conormal-localisation iso | 27 iters flat at 3 sorries; "one more input" receded 4× |
| A.4.c.1 — Thm 3.2 assembly | priority-3 | ~8–14 | ~400–700 · 0/it | A.4.c.0 | re-engages iff COE L1262 closes |
| A.3.0 — tangent-space substrate | priority-3 (parallel) | ~6–10 | ~200–400 · 0/it | cotangent-at-id | shared substrate |
| A.2.c — FGA Pic_{C/k} representability | priority-4 | ~12–16 | ~600–800 · 0/it | A.1.c + Quot OR Sym^d via RR | RR-substrate-blocked (USER-conditional) |
| A.3.vii–vi — degree map, Pic⁰ AV-structure | priority-4 (gated A.2.c) | ~20–35 | ~900–1700 · 0/it | Hilbert-poly decomp; tangent iso; smoothness; properness; geom-irred | scheme Hilbert poly absent in Mathlib |
| A.4.d.0/d — Pic^d + divisor-map Albanese UP | priority-5 (gated A.2.c + RR) | ~11–19 | ~400–800 · 0/it | Cartier divisor on `C × Pic^d`; RR genus formula | hidden Route C dependency |
| genusZero arm — `J = Spec k` | priority-6 (gated A.3.iii/iv/vi) | ~4–6 | ~200–400 · 0/it | tangent-iso + smoothness + connectedness | hidden A.2.c transit |
| nonempty_jacobianWitness body | priority-6 | 1 | <50 · 0/it | `by_cases genus C = 0` | trivial once both arms close |

**Total Route A**: ~140–230 iters / ~4400–8200 LOC.

## Routes

`J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6.
`Pic⁰_{C/k} := PicScheme.degComp C 0` (Kleiman thm:Pphifin, Hilbert-poly
open-closed decomposition); the identity-component construction is
EXCISED from the critical path (rationale: `analogies/pic0-ker-deg-pivot.md`).

**Dependency graph**: A.1.c ⊳ A.1.c.SubT; A.2.c ⊳ A.1.c + carrier-probe;
A.3.vii ⊳ A.2.c; A.3.ii ⊳ A.3.vii; A.3.iii ⊳ A.3.0 + A.3.ii; A.3.iv ⊳
A.3.0 + A.3.iii; A.3.v/vi ⊳ A.3.ii; A.4.c ⊳ A.4.a + A.4.b (CLOSED
iter-202); A.4.d.0 ⊳ A.3.ii + A.3.vii; A.4.d ⊳ A.3 + A.4.c + A.4.d.0.

**Bottom-up execution** (USER 2026-05-28): prover capacity flows to
ungated roots in parallel; never a gated target before its roots close.
Default Route A prover mode `mathlib-build`. Every directive cites
Kleiman/Nitsure/Milne/Mumford/Hartshorne/Stacks/Matsumura/Atiyah–Macdonald.

**A.2.c is RR-substrate-blocked.** Both the FGA Quot route (Kleiman §4 +
Nitsure §5) and the curve-specific Sym^d alternative (FGA Ch.9 §9.5 +
Milne III.4) need Riemann–Roch. Mitigation: `FGAPicRepresentability.lean`
encodes A.2.c as 6 Prop-valued typeclasses with `⟨sorry⟩` constructors;
downstream Route A proceeds under these abstractions. Carrier-soundness
CONFIRMED — sorryAx isolation is sound; the carrier hypotheses stay
USER-action-conditional per Goal.

**Lane TS monoidal cone — reduced to one gap (iter-204).** The whole TS
cone (`tensorObj_isLocallyTrivial` + `monoidalCategory` +
`exists_tensorObj_inverse` + `addCommGroup_via_tensorObj`) collapses to a
single Mathlib-absent ingredient: a `MorphismProperty.IsMonoidal`
instance for the inverse-image morphism property of the module
sheafification. Given it, `CategoryTheory.Localization.Monoidal` + the
existing `sheafification.IsLocalization` instance yield the monoidal
structure on `Scheme.Modules`, closing the cone. This is a `mathlib-build`
target, NOT a Mathlib-PR wait.

**Route C — Riemann–Roch chain — PAUSED (USER 2026-05-28).** Files
`H1Vanishing`, `RRFormula`, `OCofP`, `OcOfD`, `RationalCurveIso`,
`BareScheme`, `GmScaling`, `RigidityKbar`, `AbelianVarietyRigidity`, plus
RR.1 sections of `WeilDivisor`. Carry inline sorries satisfied modulo
option (c); stay imported (no excision).

**Genus-0 arm — two candidates.** (a) Route A Pic⁰-via-AV-wrap (A.3.iii/iv/vi);
NOT Route-C-independent (transits A.2.c). (b) Direct `J := Spec k` via
Mumford rigidity (`C_{k̄} ≅ ℙ¹`, `Mor(ℙ¹, A) = const`, descend); substrate
`AbelianVarietyRigidity`/`RigidityKbar` partially built but PAUSED;
~300–500 LOC under USER amendment (a).

## Open strategic questions

- **USER goal-amendment** (recommended order): (a) carve Rigidity out of
  the pause → cheapest genus-0 closure; (b) full Route C → unconditional
  end-state, highest cost; (c) keep operative holding pattern.
- **Genus-0 may need only `AbelianVarietyRigidity`, not `RigidityKbar`**:
  if the target is `Spec k` (not an arbitrary AV), descent is trivial and
  only `Mor(ℙ¹, A) = const` + base-change to `k̄` is needed — halving the
  carve-out. Audit against Milne §1 before sharpening the recommendation.
- **A.2.c alternative**: IsEtale functor-of-points representability for
  `Pic⁰` directly, bypassing Quot/Sym^d. Needs Mathlib infra audit.
- **Lane COE STUCK/PAUSED pending USER** (iter-204): genuine residual =
  Stacks 02JK conormal-localisation iso (Step A2), a real Mathlib gap;
  Step A1 + Step B bridges all axiom-clean but never connect to the pinned
  sorry. USER picks: (a) concrete Lean path through 02JK, (b) pivot
  `isRegularLocalRing_stalk_of_smooth` 02JK-free, (c) axiom-guard the 3
  pinned decls and proceed downstream. Substrate map in the COE chapter.
- **Lane TS monoidal**: close `monoidalCategory` via
  `CategoryTheory.Localization.Monoidal`, gated on building the
  `W.IsMonoidal` instance (see Routes). Recipe in the TS chapter.

## Mathlib gaps & new material

**Gaps to fill (Route A).**

- A.1.c.SubT: `W.IsMonoidal` for the module-sheafification localization →
  monoidal `Scheme.Modules` (~120–250 LOC).
- A.1.c: ét-sheafify on `Over S`; `LineBundle.OnProduct` carrier (~50–150 LOC).
- A.4.a: Stacks 02RV codim-1 finite-support; DVR-stalk valuation API (~40–80 LOC).
- A.4.c.0: Stacks 02JK conormal-localisation iso (Step A2); Stage 6.A
  Stacks 00OE capstone — both USER-gated.
- A.2.c: FGA Pic_{C/k} representability (~600–800 LOC; USER-conditional).
- A.3.0: scheme-level tangent space (~200–400 LOC).
- A.3.ii/vii: Hilbert-poly open-closed decomposition + Pphifin (~300–600 LOC).
- A.3.iii–vi: Pic⁰ AV-structure wrap (~600–1300 LOC).
- A.4.c.1: Thm 3.2 assembly (~400–700 LOC).
- A.4.d.0/d: divisor-map UP substrate (~280–550 LOC).
- Connected étale group scheme over a field, dim 0 = `Spec k` (~50–100 LOC).

**Gaps to fill (Route C — paused).** Not budgeted; documented in the
chapter files for future re-engagement.

**New project material.** AbelianVarietyRigidity, RigidityLemma,
Genus0BaseObjects/{BareScheme, ChartIso, Points, GmScaling, Cross01Substrate},
RiemannRoch/{WeilDivisor, RRFormula, OCofP, RationalCurveIso, OcOfD, H1Vanishing},
Picard/{RelativeSpec, LineBundlePullback, RelPicFunctor, FGAPicRepresentability,
IdentityComponent, Pic0AbelianVariety, QuotScheme, FlatteningStratification,
TensorObjSubstrate}, Albanese/{AuslanderBuchsbaum, Thm32RationalMapExtension,
CodimOneExtension, CoheightBridge, AlbaneseUP}.

## Reference index (references/summary.md)

Kleiman "The Picard scheme" (FGA Explained) — Route A source, §4 existence, §5 Pic⁰/Jacobian, §6 Pic^τ.
Nitsure "Construction of Hilbert and Quot Schemes" (FGA Explained) — Quot/Hilbert engine behind Route A.
Milne "Abelian Varieties" — Rigidity Thm 1.1; Thm 3.2 + Prop 3.10 (rational→AV constant, no Serre duality); Albanese UP of Pic⁰ Prop 6.1/6.4.
Mumford "Abelian Varieties" — theorem of the cube, rigidity §4.
Stacks Project — Varieties, Fields, Commutative Algebra, Cohomology, Constructions (relative spec), tags as cited per chapter.

## Blueprint chapters (titles only)

AbelJacobi; AbelianVarietyRigidity (genus-0 curve → AV constant); Albanese_AlbaneseUP (Pic⁰ UP); Albanese_AuslanderBuchsbaum; Albanese_CodimOneExtension (A.4.a); Albanese_CoheightBridge; Albanese_Thm32RationalMapExtension; Cotangent_GrpObj; Cohomology_{MayerVietoris,SheafCompose,StructureSheafAb,StructureSheafModuleK}; Differentials; Genus; Genus0BaseObjects_Cross01Substrate; Jacobian; Picard_{FGAPicRepresentability, FlatteningStratification, IdentityComponent, LineBundlePullback, Pic0AbelianVariety, QuotScheme, RelPicFunctor, RelativeSpec, TensorObjSubstrate}; RiemannRoch_{H1Vanishing, OCofP, OcOfD, RRFormula, RationalCurveIso, WeilDivisor}; Rigidity; RigidityKbar.

## Focus questions

1. Is the option-(c) operative end-state (verify protected `#print axioms`
   modulo explicit RR-substrate residual sorries, under the ROUTE C PAUSE)
   a sound holding pattern, or does it disguise an unreachable goal?
2. The critical path A.2.c (Pic representability) is RR-substrate-blocked
   AND Route C (RR) is USER-paused. Is the loop's continuous Route-A
   substrate work genuinely forward-compatible with all 3 USER resolutions
   (a/b/c), or is some of it wasted under the most likely resolution?
3. Lane COE (A.4.c.0) is STUCK + PAUSED at 27 iters after the residual
   receded 4× (A1→A2→A3→capstone→L1262). Is pausing-pending-USER the right
   disposition, or is there a strategic re-route the planner is missing?
4. Is the genus-0 Candidate-(b) `J := Spec k` Mumford-rigidity route
   (recommended USER amendment (a)) correctly the cheapest closure, and is
   the "may need only AbelianVarietyRigidity, not RigidityKbar" audit live?

Do NOT read iter sidecars, PROGRESS.md, task files, or review reports —
you do not have them and must not request them. Judge the strategy as written.
