# Strategy-critic directive — slug `route196`

You are reviewing the project strategy with fresh eyes. You do NOT have
access to past iter sidecars or prover history.

## Current STRATEGY.md (verbatim)

```markdown
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C / k`, **no** `C(k) ≠ ∅` hypothesis.
End-state: zero inline `sorry`, kernel-only axioms (`propext`,
`Classical.choice`, `Quot.sound`). **Char-general:** the protected
signatures take `[Field k]` only — NO `CharZero`.

Witness OBJECT `J` is always real (constructed unconditionally); only
`isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. Spine:
**pointed vs. unpointed**. `genus C := dim_k H^1(C, O_C)` (arithmetic
genus; protected — cannot be re-typed).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| A.1.a — `RelativeSpec` | sig-refinement | ~5–10 | ~80–150 · gated | qcoh→schemes | sig drift |
| A.1.c — RelPic functor | gated on A.2 | ~10–17 | ~300–500 · gated | ét-sheafify | gated on A.2 |
| A.2.a — Flattening | stalled | ~60–110 | ~2000–3500 · ~0/it | Stacks 052H | unowned |
| A.2.b — Quot+Grassmannian | stalled | ~75–150 | ~2600–5000 · ~0/it | Plücker; Hilbert | absent; A.4.d.0 may avoid |
| A.2.c — FGA Pic_{C/k} | gated | ~12–16 | ~600–800 · gated | wires A.2.b+A.1.c | gated |
| A.3.0 — tangent-space substrate | substrate unowned | ~6–10 | ~200–400 · gated | cotangent-at-id | shared substrate |
| A.3.i — IdentityComponent | iter-195 NEEDS_MATHLIB_GAP_FILL; PARKED body close | ~20–28 (gap-fill) | ~100–140 · ~0/it (regressive 5→9) | Stacks 04KU/04KV upstream PR needed | gap genuinely unowned; USER escalation candidate iter-196 |
| A.3.ii — Pic⁰ def | gated | ~2–4 | ~80–200 · gated | (PicScheme).IdentityComponent | small |
| A.3.iii — tangent iso | gated | ~3–5 | ~120–250 · gated | A.3.0 + A.3.ii | reduced by A.3.0 split |
| A.3.iv — Pic⁰ smoothness | gated | ~5–8 | ~200–350 · gated | local criterion via H¹ | reduced by A.3.0 split |
| A.3.v — Pic⁰ properness | gated | ~6–10 | ~250–400 · gated | Pic^d-translate | independent |
| A.3.vi — Pic⁰ geom irred | gated | ~4–8 | ~150–300 · gated | geom-conn; k̄ reduce | independent |
| A.3.vii — degree map | gated | ~2–4 | ~80–200 · gated | line-bundle degree | small |
| A.4.a — codim-1 + Weil-divisor | gated | ~40–80 | ~1500–2500 · gated | codim-1; valuative crit | dominant Route-A risk |
| A.4.b — Auslander–Buchsbaum | CONVERGING (n=0 closed iter-194); n=k+1 OFF-CRITICAL-PATH | ~6–12 | ~200–300 · ~50/it (recent) | route iii Krull-intersection | n=k+1 multi-iter |
| A.4.c.0 — codim-≥2 conclusion | gated | ~2–4 | ~80–200 · gated | codim-≥2 extraction | bundled in A.4.a |
| A.4.c.1 — Thm 3.2 assembly | gated | ~8–14 | ~400–700 · gated | A.4.a+A.4.b+A.4.c.0 | needs A.4.c.0 |
| A.4.d.0 — Pic^d component | substrate unowned | ~3–5 | ~120–250 · gated | EITHER Hilb-of-points via A.2.b OR Cartier-divisor on `C × Pic^d` | choice between routes |
| A.4.d.0.AJ — AJ Hilb→Pic^d | gated (Hilb route only) | ~3–5 | ~150–250 · gated | pull-push universal line bundle | Hilb route |
| A.4.d — divisor-map Albanese UP | gated | ~8–14 | ~280–550 · gated | universal effective divisor → Pic^d | replaces Sym^g gap |
| **Carrier-soundness refactor — PINNED iter-196** | iter-195 mathlib-analogist verdict ALIGN_WITH_MATHLIB on Option A (`Functor.IsRepresentable`); pulled forward from iter-200 | ~6–10 | ~600–950 · iter-196 dispatch | `Functor.IsRepresentable` + `Functor.reprX` re-encoding across 7+ load-bearing carriers | blast across 5+ files; FGAPicRepresentability slice first |
| Lane M↓ — `isRegularLocalRing_stalk_of_smooth` (Stacks 00TT) | STUCK (flat 4 iters); iter-200 sweep candidate | ~6–12 | ~100–300 · ~0/it (recent) | Stacks 00OE + 02JK + 0AVF gaps | unowned upstream |
| Genus-0 rigidity — chart-bridge (III.c separated) | iter-195 ANALOGUE_FOUND (`Proj.awayι_app_basicOpen` via `IsAffineOpen.fromSpec_app_self` pattern); ANALOGUE-DRIVEN iter-195 dispatch | ~2–4 | ~80–120 · ~30-50/it (post-pivot) | `Proj.awayι_app_basicOpen` 30-50 LOC port | analogue-confirmed; ungated |
| Genus-0 rigidity — chart-bridge collapse-at-zero | honest sorry; shares Lane E idiom | ~2–4 | ~30–70 · gated on Lane E | chart-1 ring-map identity at u=0 | cover-glue chase |
| Genus-0 RR.1 — Weil divisors | iter-194 instance #1 closed; instance #2 contingent on BareScheme | ~3–7 | ~150–300 · ~10/it | DVR-stalks-on-Proj; Hartshorne I.6.12 Hom.ofFunctionFieldEmbedding | Mathlib gap I.6.12 |
| Genus-0 RR.2.H¹ — flasque vanishing | Lane H CHURNING; SAb.Exact single residual | ~6–10 | ~150–300 · variable | `PreservesHomology` of `sheafCompose forget₂` | one more PARTIAL = STUCK |
| Genus-0 RR.2 assembly | gated | ~4–8 | ~150–300 · gated | LES-of-Ext; 6-term alternating-rank | gated on RR.2.H¹ |
| Genus-0 RR.3 — O_C(P) sections | 4 of 7 sorries axiom-clean; STUCK by Lane H gating | ~5–12 | ~120–300 · gated | invertible sheaf at point | unblocks as RR.2.H¹ closes |
| Genus-0 RR.4 — rational ⟹ ≅ ℙ¹ | OVER_BUDGET (16 elapsed); Pin 3 carving | ~20–26 | ~150–350 · ~10/it | helpers (a) per-fibre LQF + (d) IsNormalScheme + hLPUnif witness | substrate-heavy; USER escalation candidate |
| genusZero witness body + k̄→k descent | gated | ~7–10 | ~350–850 · gated | terminal cluster Spec k | descent Spec-k-direct |
| nonempty_jacobianWitness body | gated | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

**Total positive-genus arm (Route A)**: ~290–520 iters / ~9300–16600 LOC.
**Total genus-0 arm**: ~30–50 iters / ~1700–3000 LOC — the only
complete-able milestone within 1-2 months.

## Routes

Positive-genus arm = **Route A (Picard scheme via FGA)** — mandatory.
Genus-0 arm = **Route C (Milne §I.3 rigidity)** — `J = Spec k` trivial,
char-general. **Priority: close genus-0 arm; bottom-up build on Route A
substrates in parallel.**

### Route A — Picard scheme via FGA

`J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6.
A.2+A.3+A.4 decomposed per table. A.4.a dominant risk; A.4.b
independently startable.

Dependency graph: A.1.b ⊳ A.1.a; A.1.c ⊳ A.1.b; A.2.a.ii ⊳ A.2.a.i;
A.2.a.iii ⊳ A.2.a.ii; A.2.b.ii ⊳ A.1.a + A.2.a.i; A.2.b.iii ⊳ A.2.b.i +
A.2.b.ii; A.2.c ⊳ A.2.b.iii + A.1.c; A.3.0 parallel; A.3.i parallel;
A.3.ii ⊳ A.2.c + A.3.i; A.3.iii ⊳ A.3.0 + A.3.ii; A.3.iv ⊳ A.3.0 +
A.3.iii; A.3.v ⊳ A.3.ii (parallel iii/iv); A.3.vi ⊳ A.3.ii (parallel
iii/iv); A.3.vii ⊳ A.3.ii; A.4.c ⊳ A.4.a + A.4.b; A.4.d.0 ⊳ EITHER
A.2.b + A.3.ii + A.3.vii OR (Cartier-divisor) A.3.ii + A.3.vii alone;
A.4.d ⊳ A.3 + A.4.c + A.4.d.0; Lane M↓ ⊳ none.

**Bottom-up execution priority** (prover capacity flows to roots
first, mostly parallel): Lane H + BareScheme + Lane E + Lane I
substrate + A.4.b (CONVERGING); A.3.0 + A.3.i body PARKED pending
mathlib-analogist verdicts (A.3.i iter-195 returned
NEEDS_MATHLIB_GAP_FILL; Lane M↓ STUCK iter-200 candidate).

**Mathlib-analogist sweep**: nominal cadence every 10 iters
(next iter-200 for the broad substrate sweep). DIRECTED consults
fire on-demand (iter-195 fired 3: Lane E pivot, A.3.i, carrier-
soundness — all returned actionable verdicts).

### Route C — genus-0 rigidity via Milne §I.3

`J = Spec k` trivial. Over `k̄`, every pointed `f : C → A` constant.
Rigidity Lemma + Cor 1.5 + Cor 1.2 axiom-clean. Base case `ℙ¹→A const`
via 𝔾_m-scaling shortcut (chart-bridge III.c separated-locus). Genus-0
⟹ ℙ¹ via RR.1–RR.4 bridge; RR.2 H¹ skyscraper vanishing committed
project-side; Lane I Pin 2 closes via positivePart Weil-divisor
substrate.

## Open strategic questions

- **End-state contract**: zero inline `sorry`, kernel-only axioms
  (`propext`, `Classical.choice`, `Quot.sound`). Every named typed
  sorry must reduce to either a Mathlib upstream or a project-side
  substrate with an explicit iter budget — no permanent named sorries.
- **k̄→k descent LOCKED Spec-k-direct.** Genus-0 witness body proves
  UP directly over `Over (Spec k)`. Reversal: descent-step reconsiders
  via `C_{k̄} ≅ ℙ¹`.
- **A.4.a ↔ RR.1 shared material.** Codim-1 order + divisor degree
  shared via `RiemannRoch/WeilDivisor.lean`.
- **A.4.d.0 substrate choice**: Hilb-of-points route (gates A.2.b
  2600-5000 LOC) vs Cartier-divisor route (`𝓛 ↦ Div(𝓛)` on `C ×
  Pic^d`, avoids A.2.b). Cartier route preferred; iter-196+ decision
  pending Lane I body close (exercises divisor infrastructure).
- **A.2.a/A.2.b long-running**: stalled. Genus-0 + Route-A-via-Cartier
  avoid blocking on these; A.2.c gates iter-200+.
- **Carrier-soundness PINNED iter-196**: iter-195 mathlib-analogist
  verdict committed Option A (`Functor.IsRepresentable`); FGAPicRepresentability
  slice first; 6-10 iters / ~600-950 LOC total. **Observability trigger**:
  iter-196+ provers run `lean_verify` on touched protected declarations;
  if `sorryAx` propagation through carrier instances is observed in any
  consumer's verify output, that's the corrective signal for further
  refactor work.
- **Lane A.3.i NEEDS_MATHLIB_GAP_FILL**: iter-195 mathlib-analogist
  verdict returned 0 ALIGN_WITH_MATHLIB on Stacks 037Q + 04KU + 04KV +
  field-tensor-product. PARKED. iter-196+ candidate: Mathlib upstream
  PR (Route B per analogist, ~350 LOC) OR USER escalation.

## Mathlib gaps & new material

**Gaps to fill (Route A).** A.1.a `RelativeSpec` (~200–400);
A.1.c RelPic + ét-sheaf (~300–500); A.2.a flattening Stacks 052H
(~2000–3500); A.2.b Quot + Grassmannian Nitsure §5 (~2600–5000,
avoidable via Cartier); A.2.c FGA `Pic_{C/k}` (~600–800); A.3.0
scheme-level tangent space (~200–400); A.3.i Stacks 04KU/04KV
project-side OR Mathlib upstream PR (~80-350 LOC; iter-195 analogist
returned NEEDS_MATHLIB_GAP_FILL); A.3.iii-vi Pic⁰ AV wrap (~600–1300);
A.4.a codim-1 + Weil-divisor surface (~1500–2500); A.4.b Stacks 00NQ
`isDomain_of_regularLocal` (~200-300); A.4.c Thm 3.2 (~600–900);
A.4.d.0 + A.4.d divisor-map UP substrate (~280–550); Lane M↓ Stacks
00TT (~100–300, Stages 3-4); **carrier-soundness refactor 7+ load-
bearing `:= sorry` decls under `Functor.IsRepresentable` pattern
(~600–950, iter-196)**.

**Gaps to fill (Route C).** chart-bridge σ_× body (~30-70 LOC);
RR.1 Hartshorne II.6.9 body (`Hom.ofFunctionFieldEmbedding`);
RR.2 H¹ (Lane H `SAb.Exact` via `PreservesHomology` of
`sheafCompose forget₂`); RR.2 assembly; RR.3 sections (gated on
RR.2.H¹); RR.4 iso (`degree_one_morphism_iso` Pin 3 sub-tasks a/d
substrate-heavy; USER escalation candidate iter-196).

**New project material.** AbelianVarietyRigidity, RigidityLemma,
Genus0BaseObjects/{BareScheme, ChartIso, Points, GmScaling,
Cross01Substrate}, Rigidity, RiemannRoch/{WeilDivisor (+positivePart),
RRFormula, OCofP, RationalCurveIso, OcOfD, H1Vanishing}, Picard/
{RelativeSpec, LineBundlePullback, FlatteningStratification,
RelPicFunctor, QuotScheme, FGAPicRepresentability, IdentityComponent,
Pic0AbelianVariety}, Albanese/{AuslanderBuchsbaum, Thm32RationalMapExtension,
CodimOneExtension, AlbaneseUP (divisor-map)}.
```

## References summary

```
| File | Description |
| ---- | ----------- |
| challenge.lean.ref | Original challenge — protected signatures |
| stacks-varieties.md | Stacks ch.33 — 035U, 04QM/056T, 0BUG |
| stacks-fields.md | Stacks ch.9 — 09HD, 030K |
| stacks-algebra.md | Stacks ch.10 — 00T7 (standard smooth ⇒ Ω free) |
| stacks-coherent.md | Stacks ch.30 — 02KH (flat base change R^i f_*) |
| stacks-constructions.md | Stacks ch.27 — 01LL/01LO/01LQ/01LR/01LS (relative-spec) |
| kleiman-picard.md | Kleiman "The Picard scheme" |
| nitsure-hilbert-quot.md | Nitsure "Hilbert and Quot Schemes" |
| abelian-varieties.md | Milne notes — Rigidity 1.1; Thm 3.2; Prop 6.1/6.4 |
| mumford-abelian-varieties.md | Mumford "Abelian Varieties" |
```

## Blueprint chapters summary (1-line per chapter)

```
- AbelianVarietyRigidity.tex — genus-0 chart-bridge; III.c separated; BareScheme covered
- Albanese_AlbaneseUP.tex — Jacobian UP (Milne III.6)
- Albanese_AuslanderBuchsbaum.tex — Auslander-Buchsbaum formula
- Albanese_CodimOneExtension.tex — Milne 3.1 extension; codim-1 lemma
- Albanese_Thm32RationalMapExtension.tex — Milne 3.2 rational map extension
- Cohomology_StructureSheafModuleK.tex — H^i structure sheaf module
- Cohomology_MayerVietorisCore.tex — Mayer-Vietoris LES
- Picard_FGAPicRepresentability.tex — FGA Pic representability
- Picard_IdentityComponent.tex — Pic⁰ identity component
- Picard_LineBundlePullback.tex — line bundle pullback
- Picard_Pic0AbelianVariety.tex — Pic⁰ is abelian variety
- Picard_QuotScheme.tex — Quot scheme construction
- Picard_RelativeSpec.tex — relative Spec
- RiemannRoch_RRFormula.tex — Riemann-Roch χ formula
- RiemannRoch_H1Vanishing.tex — H¹ vanishing via flasque
- RiemannRoch_OCofP.tex — O_C(P) sections; genus-0 ⟹ ≅ ℙ¹
- RiemannRoch_RationalCurveIso.tex — rational curve iso to ℙ¹
- RiemannRoch_WeilDivisor.tex — Weil divisors; positivePart
```

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: existence of an
Albanese/Jacobian object uniform over the k-rational pointing of a
smooth proper geometrically irreducible curve `C / k`. Genus-0 arm
takes `J = Spec k` and proves the universal property via Milne §I.3
rigidity over `k̄`; positive-genus arm uses FGA-style Pic⁰ construction
per Kleiman §4-§5 + Nitsure §5 + Milne III §6.

## What I want from you

Fresh-context audit. Challenge the strategy. In particular:

1. **Carrier-soundness PINNED iter-196**: is pulling this 6-10 iter
   refactor forward to *now* the right call, vs. continuing to close
   the genus-0 arm first? The trade-off is: lean-auditor flagged 3
   silent-sorryAx propagators iter-195, so soundness is non-zero risk
   *now*; but the genus-0 arm is the only complete-able milestone
   within 1-2 months per STRATEGY.
2. **Lane A.3.i NEEDS_MATHLIB_GAP_FILL**: STRATEGY says iter-196+
   candidate USER escalation OR Mathlib upstream PR (~350 LOC). Is
   this the right framing, given A.3.i sits on the Route A critical
   path?
3. **Genus-0 arm priority**: STRATEGY commits to "close genus-0 arm
   first". Is the iter-196 8-lane proposal coherent with that priority,
   or is it over-spreading?
4. **Lane M↓ STUCK 4-iters**: should this be excised, or is iter-200
   sweep candidate still defensible?
5. Any other format / consistency / soundness issues with STRATEGY.md.

Return SOUND / CHALLENGE / REJECT with one-line rationale per item.
