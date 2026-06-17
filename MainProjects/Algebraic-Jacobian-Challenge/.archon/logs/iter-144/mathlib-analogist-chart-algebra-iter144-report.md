# Mathlib Analogist Report

## Slug

chart-algebra-iter144

## Iteration

144

## Question

Given (a) iter-140 chart-algebra rigidity HYBRID verdict (~450–900 LOC
bundled vs ~980–1970 LOC full in-tree), (b) iter-141 scheme-Frobenius
scoping HYBRID-pivot-does-NOT-fire (LOC midpoint ~1025; in-tree
sustainable below 2000 LOC pivot threshold), (c) iter-143 piece (i.b)
Step 2 d_app PARTIAL with type-coercion (`Eq.mpr` / `eqToHom` between
pushforward composites) as the reported obstacle (NOT recipe-level),
(d) iter-144 user-hint M3 Route A commitment dropping "off-loop PR
lane" framing, (e) piece (i.b) Main `mulRight_globalises_cotangent`
body not yet attempted, **should the iter-144+ piece (iii) scheme-
Frobenius commitment switch to the chart-algebra alternative, OR is
the bundled in-tree scheme-Frobenius path still the right choice?**

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. iter-143 d_app type-coercion foreshadow piece (iii) tooling tax | PROCEED | informational |
| 2. Chart-algebra restructures piece (i.b) Step 2 d_app to chart-side | DIVERGE_INTENTIONALLY | informational |
| 3. iter-143 evidence on named-gap-sorry attractiveness | PROCEED (not elevated) | informational |
| 4. Iter-144 re-weighed pivot decision | **PIVOT_TO_CHART_ALGEBRA** | **critical** |
| 5. Execution shape | HYBRID EXECUTION | informational |

## Must-fix-this-iter

The iter-144 mandatory chart-algebra-vs-bundled re-evaluation gate
(committed iter-140 + iter-141 STRATEGY.md L601–L612) discharges with
**PIVOT_TO_CHART_ALGEBRA**. The iter-141 strategy-critic deferral of
the iter-140 chart-algebra analogist's "Strongest recommendation
(option 2 chart-algebra unless ≥2 sub-sorries closed iter-140)"
**activates** at iter-144 — iter-140 closed 0 sub-sorries; cumulative
iter-140/142/143 closed 1 of 3 (d_map only); the CONTINUE_BUNDLED
criterion was never met.

The iter-144 plan agent must land 3 substantive STRATEGY.md edits:

- **Decision 4 must-fix**: M2.body-pile § rewrite (drop piece (i.c)
  sub-pieces 1/2/3 + piece (iii) scheme-Frobenius PHANTOM; inflate
  piece (ii) to 600–1050 LOC absorbing chart-algebra (α)+(β)
  upstream).
- **Decision 4 must-fix**: § Iter-142+ scheduled obligations § retire
  the iter-144 mandatory chart-algebra-vs-bundled gate (discharged
  this analogist call; PIVOT committed); retire the iter-147+ piece
  (iii) sub-piece-build schedule.
- **Decision 4 must-fix**: § End-state PROVISIONAL relax — piece
  (iii) PHANTOM build descoped; **zero-sorry PROVISIONAL end-state
  preserved under chart-algebra route at ~450–900 LOC piece (ii)
  envelope** with NO residual named-gap (chart-algebra route preserves
  zero-sorry, unlike the named-gap-sorry alternative).

## Major

The iter-144 d_app bundled prover lane (counter at 3 entering iter-144;
breakeven at 5 of 5) is recommended to **fire as last technique-
capitalisation** per iter-143 review Arm A (~40–80 LOC closure
attempt; small scope; counter discharge candidate). Its outcome does
NOT alter the chart-algebra pivot commitment — iter-145+ trajectory
restructures regardless.

## Informational

- **Decision 1** (iter-143 d_app foreshadow piece (iii) tooling tax):
  PROCEED. The iter-143 obstacle is **localized to scheme-level
  pushforward-composite chases**. Piece (iii) sub-piece 2 (restriction
  compatibility `F_X |_U = F_U`) inherits a structurally-similar
  ~+20–40 LOC `Eq.mpr`/`eqToHom` tax within the iter-141 envelope
  ~80–150 LOC. Sub-pieces 1 (`Scheme.absoluteFrobenius` definition,
  single Hom on X), 3 (iterate, no composite), and 4 (consumer
  "df=0 ⇒ f factors through F_C^n", ring-side local-form) do NOT
  inherit the foreshadow. The iter-141 estimate ~680–1370 LOC for
  piece (iii) sub-pieces 1–4 remains credible with mild upward
  pressure on sub-piece 2 only.

- **Decision 2** (chart-algebra restructures (i.b) Step 2 d_app):
  DIVERGE_INTENTIONALLY. Chart-algebra **structurally avoids** the
  iter-143 d_app type-coercion obstacle — the chart-level (α)
  `Algebra.IsPushout` helper + (β) per-chart translation-invariance
  argument use ring-level `KaehlerDifferential` API directly, with
  no `pullbackPushforwardAdjunction.homEquiv.symm`-transposed
  compatibility-morphism chase. Cost: ~558 LOC sunk-cost on bundled
  (i.b)-side investment (Step 1 `shearMulRight` + Step 2 body +
  d_map closure + Step 3 restrict + IsIso scaffold + Main scaffold +
  helpers + docstrings); d_map technique-advance does NOT transfer
  cleanly to chart-algebra (sheaf-NatTrans chase vs ring-level
  construction).

- **Decision 3** (iter-143 evidence on named-gap-sorry): PROCEED — not
  elevated. iter-141 verdict carries forward (in-tree below 2000 LOC
  pivot threshold). The iter-144 user-hint reframing of in-tree work
  affects bundled-vs-chart-algebra weighting, NOT bundled-vs-named-gap
  weighting. The named-gap-sorry alternative is strictly worse than
  chart-algebra under iter-144 framing: chart-algebra preserves
  zero-sorry PROVISIONAL end-state at ~450–900 LOC, while named-gap-
  sorry leaves one residual named-gap at ~300–600 LOC; ~150–300 LOC
  delta buys the zero-sorry guarantee.

- **Decision 5** (execution shape): HYBRID EXECUTION. Iter-144 d_app
  bundled prover lane fires (~40–80 LOC; iter-143 review Arm A: wire
  `have hw` through to Step 3.b lift via `PresheafedSpace.comp_c_app`;
  extract Step 3.b/c into a named helper lemma per iter-143 STRATEGY.md
  Edit 1 sorry-must-be-named-declaration discipline). Iter-145+
  STRATEGY.md commits chart-algebra; piece (i.c)+(i.b) Main descoped;
  piece (ii) PIN-path-(b) inflated; piece (iii) scheme-Frobenius
  PHANTOM descoped; iter-150 RelativeSpec trigger preserved (chart-
  algebra pivot reduces M2.body-pile ~450–900 LOC, well under 925 LOC
  trigger).

## LOC delta and iter delta (per directive verdict shape)

- **Net LOC saving**: ~740–1840 LOC midpoint ~1290 LOC over bundled
  scheme-Frobenius (revised upward from iter-141's ~480–1070 LOC by
  ~258 LOC due to sunk-cost capitalisation + scheme-Frobenius sub-
  pieces 1+2+3 retirement, partially offset by piece (ii) inflation
  ~300–450 LOC).
- **Iter delta**: ~5–10 iter at midpoint (piece (iii) sub-pieces
  1+2+3+4 retire 5–10 iter; piece (i.c) retires 2–3 iter; offset by
  piece (ii) +1–2 iter inflation).
- **Risk-adjusted**: the iter-141 verdict's "in-tree sustainable"
  assessment held; chart-algebra saves significantly but doesn't slash
  an unsustainable trajectory. The pivot's value is **load-bearing for
  long-run wall-clock** (multi-year framing per iter-140
  strategy-critic), not project-emergency.

## Impact on iter-143 d_app PARTIAL on Route 1

- Chart-algebra **structurally avoids** the iter-143 d_app type-
  coercion obstacle. The chart-level (β) per-chart Kähler-derivation
  construction is the ring-level analog of bundled d_app; it does NOT
  face the pushforward-composite `Eq.mpr` tax (no
  `Pushforward.comp_eq` chained with propositional `≫ = `).
- Iter-144 d_app close attempt **still recommended** as technique-
  capitalisation: small scope (~40–80 LOC), small cost, counter
  discharge candidate (3 → 2 if d_app closes substantively). But its
  closure is **no longer load-bearing** for iter-145+ trajectory under
  pivot commitment.
- The d_map technique-advance (iter-142 close; 3-step ALIGN_WITH_MATHLIB
  chase via `pushforward_obj_map_apply'` + `NatTrans.naturality_apply`
  + `relativeDifferentials'_map_d`) **does NOT transfer cleanly** to
  chart-algebra — it's a sheaf-NatTrans naturality chase, not a ring-
  level construction. The chart-algebra (β) helper uses
  `KaehlerDifferential.D` API directly.

## Mathlib citations (verified iter-144)

- `RingHom.iterateFrobenius_comm` — `Mathlib.Algebra.CharP.Frobenius`
  (verified via `lean_loogle` iter-144): the **load-bearing chart-
  algebra route Mathlib piece** for piece (iii). For each chart W,
  `f^# ∘ iterateFrobenius_{Γ(W), p, n} = iterateFrobenius_{Γ(f^{-1}W),
  p, n} ∘ f^#` follows directly from this RingHom-commutation lemma.
  No scheme-level absolute Frobenius PHANTOM needed.
- `Algebra.IsStandardSmooth.free_kaehlerDifferential` —
  `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`: per-chart
  Kähler free of rank n; load-bearing for chart-algebra (β).
- `pullbackSpecIso` + `_hom_fst` / `_inv_fst` —
  `Mathlib.AlgebraicGeometry.Pullbacks`: chart-algebra (α) helper
  foundation; ring-level `Algebra.IsPushout` from affine product, no
  pushforward composites.
- `PresheafedSpace.comp_c_app` —
  `Mathlib/Geometry/RingedSpace/PresheafedSpace.lean:176`: load-bearing
  for piece (iii) sub-piece 2 restriction compatibility AND for the
  iter-143 d_app Step 3.b lift attempt. **Same shape as the iter-143
  d_app blocker** when chained with propositional `(fst).w` /
  `(snd).w` and `Pushforward.comp_eq` definitional rfl.
- `Scheme.absoluteFrobenius` — **ABSENT** in `b80f227`; bundled piece
  (iii) PHANTOM (~800–1500 LOC) under iter-141 verdict.

## Persistent file

- `analogies/chart-algebra-vs-bundled-iter144.md` — full design-
  rationale captured for future iters; 5 decisions analyzed; iter-145+
  watch criteria documented.

## Watch criteria for iter-145+ under PIVOT

1. **Iter-145 plan agent**: confirm 3 STRATEGY.md edits land (M2.body-
   pile rewrite + iter-142+ obligations retire + end-state
   PROVISIONAL relax).
2. **Iter-145 mandatory blueprint-writer**: `RigidityKbar.tex` § Piece
   (i) restructure to chart-algebra (~50–100 LOC of prose churn);
   § Piece (iii) Frobenius prose descope (~30 LOC becomes historical
   note); § shared_pile prose update.
3. **Iter-145 mandatory strategy-critic re-verification**: confirm the
   iter-141 strategy-critic override on chart-algebra is reversed
   iter-144 (vs preserved); verify STRATEGY.md edits' internal
   consistency.
4. **Iter-146+ piece (ii) PIN-path-(b) prover lane**: scope envelope
   600–1050 LOC; if mid-iter `lean_diagnostic_messages` shows piece
   (ii) absorbing chart-algebra upstream is hitting > 1050 LOC, fire a
   mid-iter mathlib-analogist on the inflation breakdown (chart-
   algebra (α)+(β) helpers may need their own LOC envelope tightening).
5. **Iter-148+ piece (iv) Serre duality**: unchanged (deferred named
   gap; chart-algebra pivot does not affect piece (iv)).
6. **Optional off-loop**: `Scheme.absoluteFrobenius` retains
   Mathlib-PR candidate utility (sub-pieces 1+3 at ~200–420 LOC are
   the clean Stacks Tag 0CC4 construction); NOT a project deliverable
   under iter-144 user-hint reframing.

## Overall verdict

**PIVOT TO CHART-ALGEBRA committed iter-144 STRATEGY.md** with HYBRID
EXECUTION (iter-144 d_app bundled lane fires as last technique-
capitalisation attempt; iter-145+ piece (i.c)+(i.b) Main descoped,
piece (ii) PIN-path-(b) inflated to absorb chart-algebra upstream at
600–1050 LOC, piece (iii) scheme-Frobenius PHANTOM descoped); net
saving ~740–1840 LOC midpoint ~1290 LOC and ~5–10 iter at midpoint;
the iter-140 chart-algebra analogist's "Strongest recommendation"
CONTINUE_BUNDLED criterion was mechanically not met (iter-140 closed
0 sub-sorries; cumulative iter-140/142/143 closed 1 of 3); the iter-
141 strategy-critic deferral to iter-144 discharges at this analogist
call.

## Severity

**high-stakes.** This verdict re-shapes the iter-144+ M2 critical-
path trajectory by ~5–10 iter and ~1290 LOC at midpoint. The PIVOT
commitment is binding through iter-145+ strategy lock-in; reverting
post-iter-145 would compound sunk-cost (chart-algebra (α)+(β) work
becomes its own sunk-cost ~230–450 LOC if abandoned).
