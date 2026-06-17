# Strategy Critic Directive

## Slug
iter188

## Project's stated final goal

Formalize Christian Merten's Jacobian challenge
(`references/challenge.lean`): nine protected declarations headlined
by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness`
— the existence of an Albanese / Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible
curve `C / k`, with NO `C(k) ≠ ∅` hypothesis. End-state: zero inline
`sorry`, kernel-only axioms. The witness object `J` is always real
(constructed unconditionally); only `isAlbaneseFor` is universally
quantified over `P : 𝟙_ _ ⟶ C`. Spine: **pointed vs. unpointed**.
`genus C := \dim_k H^1(C, O_C)` (arithmetic genus). Char-general:
protected signatures take `[Field k]` only — no `CharZero`.

## Current STRATEGY.md (verbatim)

```markdown
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C / k`, with **no** `C(k) ≠ ∅` hypothesis.
End-state: zero inline `sorry`, kernel-only axioms. **Char-general:** the
protected signatures take `[Field k]` only — NO `CharZero`. Any char-0
sub-case route is therefore PARTIAL only.

The witness OBJECT `J` is always real (constructed unconditionally); only
`isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. Spine:
**pointed vs. unpointed**. `genus C := \dim_k H^1(C, O_C)` (arithmetic
genus; protected — cannot be re-typed).

## Phases & estimations

LOC bands honored per-row velocity. A.1.a's realized ~50 LOC/it is the
EASIEST sub-phase; deeper substrate (Stacks 052H, Quot/Grassmannian,
codim-1) plausibly runs at ~10–25 LOC/it because each iter must first
invent missing Mathlib API. Velocity figures in
`LOC (remaining · realized/it)`. Cell-internal arithmetic: `remaining ÷
realized` should roughly match `Iters left`.

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **A.1.a — `RelativeSpec`** | 5-helper structured proof landed iter-183; 2 narrowly-scoped Tier-3 sorries remain — but progress-critic route185 verdict **STUCK + OVER_BUDGET**: 15 elapsed vs ~3-6 estimated; iter-183 added 5 helpers with net +1 sorry; recurring blocker "IsAffineOpen.map_fromSpec transparency" 2-of-2 dispatched iters | ~20–30 (revised) | ~100–250 · ~0/it (5-helper structural; no net closure) | qcoh-algebras → schemes; `IsAffineOpen.map_fromSpec`; transparency unfolds | iter-185 HARD BAR test mandatory; failure → blueprint expansion of 3-iso chain factorisation |
| **A.1.b — `LineBundle.Pullback`** | skeleton landed; body gated | ~2–4 | ~200–400 · ~50/it | line-bundle pullback; sheafification | small once A.1.a body lands |
| **A.1.c — `RelPic functor`** | skeleton landed; body gated | ~10–17 | ~300–500 · ~30/it | ét-sheafification; presheaf functoriality | gated on A.1.a real body |
| **A.2.a.i — Generic flatness** | chapter landed | ~16–28 | ~500–800 · gated | Stacks 052H pieces; generic flatness | unowned Mathlib gap |
| **A.2.a.ii — Noetherian induction over strata** | chapter landed | ~24–42 | ~800–1300 · gated | noetherian induction | iterates on A.2.a.i |
| **A.2.a.iii — Stratum-glueing & functoriality** | chapter landed | ~20–44 | ~700–1400 · gated | gluing along finite stratification | assembly |
| **A.2.b.i — Grassmannian scheme** | chapter landed | ~18–36 | ~600–1100 · gated | Plücker; projective embedding | absent from Mathlib |
| **A.2.b.ii — Flat-locus open subscheme** | chapter landed | ~24–48 | ~800–1500 · gated | flat-locus openness; descent | builds on A.1.a + A.2.a.i |
| **A.2.b.iii — Quot assembly** | chapter landed | ~36–72 | ~1200–2400 · gated | Quot via Hilbert | bundles A.2.b.i + ii + A.2.a |
| **A.2.c — FGA `Pic_{C/k}` assembly** | skeleton landed; body gated | ~12–16 | ~600–800 · gated | wires Quot + RelPic | small assembly |
| **A.3 — `Pic⁰` identity + degree** | chapter pending; substrate unowned | ~16–28 | ~600–900 · gated | `GroupScheme.IdentityComponent` (NEW PROJECT MATERIAL) | substrate not in Mathlib |
| **A.4.a — Lemma 3.3 codim-1 + Weil-divisor surface API** | skeleton landed; body gated | ~40–80 | ~1500–2500 · gated | codim-1 indeterminacy; Weil-divisor surface; valuative criterion | dominant Route-A risk |
| **A.4.b — Auslander–Buchsbaum import** | skeleton landed; iter-186 R⧸(x) bridge axiom-clean; iter-187 commits to **project-side Stacks 00NQ formalisation** per `analogies/isregularlocalring-isdomain.md` Option 2 (NO_USEFUL_ALTERNATIVE verdict from analogist — IsDomain & regular-sequence share the same induction). Sub-lanes: G1 cotangent-space dim drop ~80 LOC (iter-187+); G2 joint induction ~200 LOC (iter-188+). | ~10–18 (revised) | ~280–360 · gated | depth, projective dimension; Stacks 00NQ joint induction (prime avoidance + Krull intersection + Nakayama) | Mathlib gap; ~300 LOC across 2-3 iters |
| **A.4.c.0 — codim-≥2 conclusion of Milne 3.1 as standalone Lean lemma** | sub-helper exposure owed | ~2–4 | ~80–200 · gated on A.4.a | codim-≥2 extraction from `extend_of_codimOneFree_of_smooth` | bundled inside A.4.a body |
| **A.4.c.1 — Thm 3.2 assembly** | helper split landed; conjunction wrapper kernel-clean | ~8–14 | ~400–700 · gated | bundles A.4.a + A.4.b + A.4.c.0 | Lemma 3.3 alone insufficient; needs A.4.c.0 |
| **A.4.d.i — `Sym^g C` sub-build** | chapter landed; substrate unowned | ~10–18 | ~400–700 · gated | `S_g`-quotient; smoothness/properness | new project material |
| **A.4.d.ii — Albanese UP wiring** | skeleton landed; body gated | ~6–10 | ~200–400 · gated | uses A.4.d.i + A.3 + A.4.c | small assembly |
| **Genus-0 rigidity — chart-bridge cross-case body** | iter-187 progress-critic STUCK + OVER_BUDGET (5 elapsed vs ~2–4 est). (III.a) `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` route + (III.b) named-projection route both empirically blocked at Mathlib `b80f227` (iter-186 `simp made no progress`). iter-187 commits to **(III.c) separated-locus alternative** per iter-185 STRATEGY.md Open Q failure-mode trigger + iter-187 progress-critic STUCK corrective | ~3–5 (revised) | ~80–120 · gated | `IsSeparated.diagonal_isClosedImmersion` + `prod.lift` + `IsClosedImmersion.lift` (all present at b80f227) | category-theory chase via diagonal closed-immersion factorization |
| **Genus-0 rigidity — chart-bridge collapse-at-zero body** | honest sorry; uses `Cover.hom_ext` against `pointOfVec` (recipe NOT applicable) | ~2–4 | ~30–70 · NOT-YET-MEASURED | chart-1 ring-map identity `u ↦ u ⊗ λ` at `u=0` | cover-glue chase |
| **Genus-0 RR.1 — Weil divisors** | active body | ~4–8 | ~150–350 · ~30/it | divisors; closed-point order; degree map | parallel-startable |
| **Genus-0 RR.2 — RR formula for genus 0** | iter-187 progress-critic CHURNING + OVER_BUDGET (13 elapsed vs ~8–12 est). iter-186 Hartshorne IV.1 3-piece decomposition landed (`eulerCharacteristic_iso` axiom-clean; `_shortExact_add` + `_skyscraperSheaf` typed sorries). iter-187 blueprint-writer split H⁰ half (axiom-clean closable iter-187+) from H¹ half (Mathlib gap — flasque cohomology). | ~6–14 (revised) | ~400–600 · gated | LES-of-Ext carrier; H¹ flasque vanishing (Mathlib gap or ~150-300 LOC project formalisation off critical path) | dimension-count engine; H¹ half indefinitely gated until Mathlib upstream |
| **Genus-0 RR.3 — `O_C(P)` global sections** | skeleton landed; body gated — but progress-critic route185 verdict **CHURNING + OVER_BUDGET**: 18 elapsed vs ~8-12 estimated; iter-181/183 added 3 helpers with net 0 sorry closure; recurring blocker "carrierSet → Submodule upgrade gated" 2-of-2 dispatched iters; iter-185 dispatched `mathlib-analogist ocofp-carrierset-submodule-api` (verdict gates Lane A iter-186+ re-fire) | ~20–30 (revised) | ~400–600 · ~0/it | invertible sheaf at point; restriction sequence; **carrierSet → Submodule API** (pending analogist) | extracts non-constant function; iter-186 directive shape depends on analogist's verdict (BUILD_PROJECT_HELPER / ALIGN_WITH_MATHLIB / NEEDS_MATHLIB_GAP_FILL) |
| **Genus-0 RR.4 — rational ⟹ `≅ ℙ¹`** | skeleton landed; body gated | ~8–12 | ~400–600 · gated | `Proj.fromOfGlobalSections`; degree-1 iso | finishes the bridge |
| `genusZeroWitness` body + `k̄→k` descent | gated on rigidity + RR bridge | ~7–10 | ~350–850 · gated | terminal cluster on Spec k; faithfully-flat descent | descent LOCKED Spec-k-direct |
| `nonempty_jacobianWitness` body | gated on both arms | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

**Total positive-genus arm (Route A, in-tree build)**: ~280–500 iters /
~9000–16000 LOC (revised per strategy-critic finding 1: anchor on the
slower realized rate of deeper substrate, not the easy A.1.a rate).
**Total positive-genus arm (axiomatise-staging path)**: ~25–35 iters /
~2000–3000 LOC (admits temporary axioms; see Open Qs).
**Total genus-0 arm**: ~30–50 iters / ~1880–3400 LOC.

## Routes

Positive-genus arm = **Route A (Picard scheme via FGA)** — mandatory.
Genus-0 arm = **Route C (Milne §I.3 rigidity)** — `J = Spec k` trivial,
char-general.

### Route A — Picard scheme via FGA

`J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6. A.2 +
A.4 decomposed per table. A.4.a = dominant risk; A.4.b independently
startable.

Dependency graph: A.1.b ⊳ A.1.a; A.1.c ⊳ A.1.b; A.2.a.ii ⊳ A.2.a.i;
A.2.a.iii ⊳ A.2.a.ii; A.2.b.ii ⊳ A.1.a + A.2.a.i; A.2.b.iii ⊳ A.2.b.i +
A.2.b.ii; A.2.c ⊳ A.2.b.iii + A.1.c; A.3 ⊳ A.2.c; A.4.c ⊳ A.4.a +
A.4.b; A.4.d.ii ⊳ A.4.d.i + A.3 + A.4.c.

### Route C — genus-0 rigidity via Milne §I.3

`J = Spec k` trivial. Over `k̄`, every pointed `f : C → A` is constant.
Rigidity Lemma + Cor 1.5 + Cor 1.2 axiom-clean. Base case `ℙ¹→A const`
via 𝔾_m-scaling shortcut (chart-bridge currently axiom-laundered).
Genus-0 ⟹ ℙ¹ via RR bridge.

## Open strategic questions

- **End-state contract**: zero inline `sorry`, **kernel-only axioms**.
  Any project-introduced `axiom` violates this contract until retired.
- **`k̄→k` descent — LOCKED to Spec-k-direct.** Genus-0 witness body
  proves UP directly over `Over (Spec k)`. Reversal: descent-step
  reconsiders via `C_{k̄} ≅ ℙ¹`.
- **A.4.a ↔ RR.1 shared material.** Codim-1 order + divisor degree
  shared via `RiemannRoch/WeilDivisor.lean`. Cross-reference audit owed.
- **Axiomatise-then-replace — Route A.** Admit temporary `axiom`s for
  unowned-substrate needs marked `-- TODO: replace by Mathlib upstream`.
  Collapses critical path from ~280–500 iters to ~25–35 for an
  axiomatised build. TRACKED, NOT COMMITTED. Trigger: Route A velocity
  stays ~0/it on file-skeleton lanes for two consec iters.
- **Genus-0 separated-locus alternative**: off-path fallback for
  `ℙ¹ → A const` (extend `𝔸¹ → A` via valuative criterion, then a
  separate constancy argument). Trigger: either cross-case or
  collapse-at-zero sorry remains open after two iters with no analogist
  recipe surfacing.
- **Disclosure discipline**: a body that is structurally `sorry`-free
  but inherits `sorryAx` transitively is **kernel-clean modulo upstream
  X / Y**, NOT axiom-clean. Reserve "axiom-clean" for `#print
  axioms`-pure `{propext, Classical.choice, Quot.sound}`.
- **Signature-drift watchlist**: dispatch the
  lean-vs-blueprint-checker on any iff whose RHS does not bind the
  hypothesis variable (the chapter prose may use an informal predicate
  ("is in the image of …") that has several non-equivalent
  formalisations).
- **REJECTED alternative — `Sym^g`/theta-divisor AS THE JACOBIAN
  OBJECT**: needs `k`-rational base-point; no `Sym^g` in Mathlib.
  `Sym^g C` IS still used in A.4.d.i for the Albanese UP wiring
  (Milne's symmetric-power route), but the JACOBIAN OBJECT itself is
  `Pic⁰_{C/k}`, not `Sym^g / (theta)`.
- **REJECTED alternative — `Pic⁰`-functor-of-points Albanese-UP**:
  shifts codim-1 content rather than eliminates it.
- **OPEN literature consult**: `Pic⁰` via abstract sheafification of
  `Pic⁰` on the étale site (skip Quot)? Owed reference check —
  does sheafification produce a scheme outside char-0/k-finite?

## Mathlib gaps & new material

**Gaps to fill (CRITICAL PATH — Route A engine; all UNOWNED in Mathlib).**

- A.1.a `RelativeSpec` functor. ~200–400 LOC.
- A.1.b Line-bundle pullback. ~200–400 LOC.
- A.1.c Relative Picard presheaf + ét-sheafification. ~300–500 LOC.
- A.2.a Flattening stratification (Stacks 052H). ~2000–3500 LOC.
- A.2.b Quot + Grassmannian (Nitsure §5). ~2600–5000 LOC.
- A.2.c FGA `Pic_{C/k}` assembly. ~600–800 LOC.
- A.3 `Pic⁰` + degree. ~600–900 LOC. Substrate `GroupScheme.IdentityComponent`
  UNOWNED.
- A.4.a Lemma 3.3 codim-1 + Weil-divisor surface. ~1500–2500 LOC.
- A.4.b Auslander–Buchsbaum. ~500–700 LOC.
- A.4.c Thm 3.2 rational-map-extension. ~600–900 LOC.
- A.4.d.i `Sym^g` of schemes (`S_g`-quotient UNOWNED). ~400–700 LOC.
- A.4.d.ii Albanese UP wiring. ~200–400 LOC.

**Gaps to fill (genus-0 rigidity — Route C):**

- chart-bridge `σ_×:ℙ¹×𝔾_m→ℙ¹` body — 2 honest sorries
  (cross case + collapse-at-zero).
- genus-0 + k̄-point ⟹ `≅ ℙ¹`. RR.1–RR.4 under `AlgebraicJacobian/RiemannRoch/`.
- No `AbelianVariety` / no general Riemann–Roch in Mathlib (both verified absent).

**New project material introduced (summary):**
AbelianVarietyRigidity, RigidityLemma, Genus0BaseObjects/{BareScheme,
ChartIso, Points, GmScaling}, Rigidity, RiemannRoch/{WeilDivisor,
RRFormula, OCofP, RationalCurveIso}, Picard/{RelativeSpec,
LineBundlePullback, FlatteningStratification, RelPicFunctor, QuotScheme,
FGAPicRepresentability, IdentityComponent (planned)}, Albanese/{AuslanderBuchsbaum,
Thm32RationalMapExtension, CodimOneExtension, AlbaneseUP, SymmetricPower (planned)}.
```

## Short reference index

```
challenge.lean.ref — Original Christian Merten challenge signatures (authoritative).
stacks-{varieties, fields, algebra, coherent, constructions} — Stacks Project chapters supporting Route A substrate.
kleiman-picard — Kleiman, "The Picard scheme" (FGA Explained): §4 existence, §5 Pic⁰.
nitsure-hilbert-quot — Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained).
abelian-varieties — Milne, "Abelian Varieties" (course notes): §I.1 Rigidity Theorem, §I.3 Thm 3.2 (rational→AV const), §I.5 cube, §III.6 Albanese UP Prop 6.1/6.4.
mumford-abelian-varieties — Mumford, "Abelian Varieties" (TIFR): §4 Rigidity Lemma Form I.
hartshorne-algebraic-geometry — Hartshorne, "Algebraic Geometry" (GTM 52): genus-0 ⟹ ℙ¹ Ex IV.1.3.5, genus def IV.1.1, RR formula IV.1.3.
fga-explained — FGI-K-N-V, "FGA Explained" (AMS MSM 123): collected.
leinster-basic-category-theory — Leinster (CUP CSAM 143): Yoneda, limits/colimits.
atiyah-macdonald-commutative-algebra — Atiyah–Macdonald: primary decomposition, Krull dimension.
matsumura-commutative-ring-theory — Matsumura: depth/CM/regular-local (Ch 16-19).
```

## Blueprint summary (chapter titles + one-line topic)

```
AbelianVarietyRigidity.tex — Consolidated chapter (covers AbelianVarietyRigidity.lean + Genus0BaseObjects/{BareScheme, ChartIso, Points, GmScaling}.lean): Milne §I.3 rigidity, `ℙ¹ → A const` shortcut via 𝔾_m-scaling, chart bridge with III.a/III.b/III.c paths.
Albanese_AlbaneseUP.tex — Universal property of Pic⁰/Jacobian (Milne III §6 Prop 6.1/6.4) — body gated on A.3 + A.4.c + A.4.d.
Albanese_AuslanderBuchsbaum.tex — Auslander–Buchsbaum formula + Cohen–Macaulay infrastructure (Matsumura Ch 19); G1 cotangent dim drop + G2 joint induction substrate.
Albanese_CodimOneExtension.tex — Milne Lemma 3.3 codim-1 + Weil-divisor surface API; Stacks 00TT smooth→regular gap localized in narrow named sorry.
Albanese_CoheightBridge.tex — coheight-of-stalk-equals-Krull-dim bridge (done iter-183).
Albanese_Thm32RationalMapExtension.tex — Milne Thm 3.2 assembly (gated on CodimOneExtension body).
Cohomology_MayerVietoris.tex — Mayer-Vietoris for sheaf cohomology (substrate).
Cohomology_SheafCompose.tex — sheaf functorial composition substrate.
Cohomology_StructureSheafAb.tex — structure-sheaf abelian-group enrichment.
Cohomology_StructureSheafModuleK.tex — structure-sheaf k-module enrichment.
Genus.tex — genus C := dim_k H¹(C, O_C) (done).
Jacobian.tex — Jacobian witness assembly (gated terminal).
Picard_FGAPicRepresentability.tex — A.2.c FGA Pic representability (skeleton; body gated).
Picard_FlatteningStratification.tex — A.2.a Stacks 052H flattening stratification (chapter landed; gated).
Picard_IdentityComponent.tex — A.3 Pic⁰ identity component + abelian-variety wrap (iter-186 Path B split; iter-187 9 declarations).
Picard_LineBundlePullback.tex — A.1.b line-bundle pullback (iter-186 5 declarations axiom-clean; iter-187 IsLocallyTrivial subtype refinement).
Picard_QuotScheme.tex — A.2.b Nitsure Quot scheme construction (skeleton; iter-187 baseMap + IsBaseChange substrate work).
Picard_RelPicFunctor.tex — A.1.c relative Picard functor + ét-sheafification (skeleton; gated).
Picard_RelativeSpec.tex — A.1.a relative-spec functor (5-helper structured proof landed iter-183; STUCK).
RiemannRoch_OCofP.tex — RR.3 O_C(P) global-sections lane (iter-186-187 carrierSubmodule cascade; refactor Steps 3-5 landed iter-187).
RiemannRoch_OcOfD.tex — RR.1 sheafOf(D) (Lane J BLOCKED structurally on else-sorry transitive propagation).
RiemannRoch_RRFormula.tex — RR.2 RR formula (iter-186 3-piece decomposition; iter-187 H⁰/H¹ split).
RiemannRoch_RationalCurveIso.tex — RR.4 rational ⟹ ≅ ℙ¹ (iter-187 `Hom.poleDivisor` body via [Algebra K(ℙ¹) K(C)] binder; STUCK → SOLVED).
RiemannRoch_WeilDivisor.tex — RR.1 Weil divisors / closed-point order / degree map.
RigidityKbar.tex — off-critical path k̄ fallback artifact.
Rigidity.tex — abstract rigidity wiring.
Albanese_Thm32RationalMapExtension.tex — Milne 3.2 assembly.
AbelJacobi.tex — Abel-Jacobi morphism (done).
```

## Prior critique status

- iter-175 strategy-critic verdict was **CHALLENGE** on 4 items:
  1. Decompose A.2.a/A.2.b/A.4.d into named sub-phases.
  2. Widen LOC bands on A.2.a + A.2.b.
  3. Velocity claims inconsistent with `~0/it` realized — measure honestly.
  4. Format drift (size > 12 KB, iter-NNN narrative in cells).

  Addressed: 1 (decomposed iter-176-178 — A.2.a.i/ii/iii, A.2.b.i/ii/iii,
  A.4.d.i/ii as separate rows). 2 (widened — A.2.a totals ~2000-3500 LOC,
  A.2.b totals ~2600-5000 LOC). 3 (velocity column added per row). 4
  (still some iter-NNN narrative in Status cells — partially addressed,
  not fully).

- iter-176-186 strategy-critic SKIPPED by prior planners citing
  "SHA unchanged + prior SOUND" — but iter-175 verdict was CHALLENGE,
  not SOUND, so prior skips were arguably incorrect. iter-188 dispatch
  re-validates after 13 iters of strategy evolution.

## What I want from you

1. Verify iter-175 CHALLENGE items have been adequately addressed (or
   surface what remains live).
2. Audit the current strategy structure (per the canonical skeleton
   in `.archon/prompts/plan.md`).
3. Challenge any strategic choice that looks like sunk cost — is there
   an alternative we should reconsider?
4. Flag any phase that's been "gated" or "skeleton landed; body gated"
   for many iters without a clear unblock path.
5. Render an overall verdict (SOUND / CHALLENGE / REJECT) and per-route
   verdict (Route A / Route C).
