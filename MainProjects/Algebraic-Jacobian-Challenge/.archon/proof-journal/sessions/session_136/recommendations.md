# Recommendations for the next plan-agent iteration (iter-137)

## HIGH — iter-137 PRIMARY DECISION: dispatch piece (i.b) Step 2 prover lane

Iter-136 substantively closed Step 3
(`relativeDifferentialsPresheaf_restrict_along_identity_section`) in
~27 LOC, kernel-only axioms, with both review audits returning
**0 must-fix / 0 major** and explicitly endorsing the closure as
honest and surgical. Per `iter/iter-136/plan.md` § "Predictions for
iter-136 prover phase" the iter-137 plan-agent action when Step 3
closes is:

> Route 4 flips UNCLEAR → CONVERGING per `progress-critic-iter136`
> next-tier PASS. Dispatch iter-137 prover lane on Step 2
> (L488, ~150–300 LOC).

**Iter-137 PRIMARY ACTION**: dispatch a prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean` targeting
`relativeDifferentialsPresheaf_basechange_along_proj_two` at L488
(the remaining iter-135 honest scaffold for piece (i.b) Step 2).

**Closure path** (per `blueprint/src/chapters/RigidityKbar.tex` § Piece
(i.b) `lem:GrpObj_omega_basechange_proj` proof block L471–L480 +
`analogies/mulright-globalises-cotangent.md` Decision 2): chain the
algebra-side `KaehlerDifferential.tensorKaehlerEquiv`
(`Mathlib.RingTheory.Kaehler.TensorProduct`) with the sheaf-side
`PresheafOfModules.pullback` and the project-side
`relativeDifferentialsPresheaf_obj_kaehler` (`Differentials.lean:60–66`),
using `Algebra.IsPushout` to bridge the chart-level Kähler iso to the
presheaf-of-modules level.

**LOC envelope**: ~150–300 LOC (Step 2 is the load-bearing
NEEDS_MATHLIB_GAP_FILL piece of piece (i.b); Mathlib has no
scheme-level relative cotangent sheaf, so this is a genuine upstream
PR-candidate).

**Why iter-137 / why now**: with Step 3 substantively closed and
the `Scheme.Hom.toRingCatSheafHom` / `PresheafOfModules.pullbackComp`
idiom verified in production, the prover has the load-bearing
infrastructure and a working pattern to lean on. Step 2 also gates
iter-138+ closure of the main lemma `mulRight_globalises_cotangent`
(L610), which depends on Steps 2+3 composed.

## HIGH — iter-137 mandatory critic dispatches (standard plan-phase)

1. **`strategy-critic-iter137`** — re-verification dispatch. The
   iter-136 critic's 3 absorbed CHALLENGEs (over-k qualitative
   defense; piece-(ii) `Differential.ContainConstants` alignment;
   sequencing-table row honest framing) all landed via STRATEGY.md
   edits. The minor-to-moderate alternative (partial-result shipping
   under iter-126 user-hint citation scope) was rebutted-with-scope-
   note (recorded as future TO_USER candidate for iter-151+); if the
   iter-137 critic re-raises it, ratify the iter-136 rebuttal in
   `iter/iter-137/plan.md` rather than re-litigate.

2. **`blueprint-reviewer-iter137`** — confirm `RigidityKbar.tex` stays
   `complete: true` / `correct: true` after the iter-136 review-agent
   edits (stripped `\notready` on lem:GrpObj_omega_restrict_to_identity_section
   + rewrote iter-135 NOTE block on the same lemma). Apply the HARD
   GATE per-file rule for the iter-137 prover dispatch on the two
   remaining sorry-bodied scaffolds (`_basechange_along_proj_two` +
   `mulRight_globalises_cotangent`).

3. **`progress-critic-iter137`** — apply iter-136 iter-137 PASS
   criteria for Route 4 (piece (i.b)):
   - **PASS-VERIFICATION (iter-136 next-tier criterion)**: already
     SATISFIED (Step 3 closed; Route 4 should flip UNCLEAR →
     CONVERGING).
   - **Iter-137 next-tier PASS**: iter-137 prover round substantively
     closes Step 2 OR (if Step 2 stalls) returns a coherent partial
     with new sub-helpers along the `KaehlerDifferential.tensorKaehlerEquiv`
     chain (NOT another hollow placeholder).
   - **FAIL (flips Route 4 to CHURNING)**: any iter-137 prover round
     that re-introduces the iter-134 anti-pattern (typed-tautology
     with intended-type-in-docstring-only). The Knowledge Base entry
     `Nonempty (X ≅ X) := ⟨Iso.refl _⟩` anti-pattern is the explicit
     rule; iter-136 demonstrated `change`-based reshape as a clean
     alternative when LOC budget is tight.

## MED-A — pre-dispatch hint-tightening for Step 2

Per `analogies/mulright-globalises-cotangent.md` Decision 2 + the
iter-136 lean-vs-blueprint-checker's "blueprint adequacy" verdict,
the Step 2 closure path through `KaehlerDifferential.tensorKaehlerEquiv`
+ sheaf-side promotion is documented but not yet proved-by-prover.
Two options for iter-137 plan agent before dispatch:

**Option (a)**: dispatch the prover lane as-is and let it discover the
exact Lean-shape; budget is generous (~150–300 LOC).

**Option (b)** *(recommended if iter-137 has any analogist budget left
after the mandatory critics)*: pre-dispatch a `mathlib-analogist` on
the `KaehlerDifferential.tensorKaehlerEquiv` ↔ `PresheafOfModules.pullback`
bridge, verifying via `lean_run_code` that the intended composite
elaborates. This mirrors the iter-135 `phi-compatibility-morphisms`
consult that de-risked iter-136 Step 3 and would persist as
`analogies/kaehler-tensorequiv-presheafpullback.md`.

Prior art: iter-135's `mathlib-analogist-phi-compatibility-morphisms-iter135`
returned PROCEED-WITH-INTENDED-TYPES-AS-WRITTEN in 1 session and saved
iter-136 from re-discovering the `toRingCatSheafHom` idiom.
Estimated cost: ~$1–2; preserves iter-137 from a Step 2 PARTIAL outcome
that would push iter-138+ work.

## MED-B — iter-136 docstring-drift cleanup (3 sites)

Per `lean-auditor-review136` (3 minor findings) +
`lean-vs-blueprint-checker-cotangent-grpobj-review136` (1 minor —
the iter-135 carry-over MED-C extends modestly): all six docstring-
drift sites are in `Cotangent/GrpObj.lean`:

1. **L506** — change "(`section_snd_eq_identity_struct` **below**)"
   → "(`section_snd_eq_identity_struct` **above**)". The helper is at
   L452, above the consumer at L508. (Iter-136 drift.)
2. **L596–L597** — change "Steps **2 and 3** are the two `def`s above
   (also `sorry`)" → "Step 2 (`relativeDifferentialsPresheaf_basechange_along_proj_two`)
   is the remaining `sorry` (`def` above); Step 3 closed iter-136".
   (Iter-136 drift on the consumer of the closed Step 3 lemma.)
3. **L427–L432** — change "Bodies are `sorry` — closure is iter-136+
   work" → "Bodies of Step 2 and the main lemma remain `sorry`; Step 3
   closed iter-136". (Iter-136 drift in section header.)
4. **L61/L107/L146/L155/L160** — file-header line-anchor drift
   (iter-135 MED-C; cite stale "line 198/244"; actual L210/L256).
   Iter-136 extended drift by ~+12 lines. (Iter-135 carry-over.)

**Recommendation**: bundle these 6 sites into a small refactor lane in
iter-137 (or fold into the iter-137 prover lane if the prover touches
the same file naturally for Step 2 — but be careful, the prover
should not be redirected away from Step 2 closure to do docstring
maintenance). Single refactor pass; ~30–60 min; no semantic change.

## MED-C — optional blueprint clarity note

Per `lean-vs-blueprint-checker-cotangent-grpobj-review136` (minor,
preventive): add a one-line `% NOTE` near `RigidityKbar.tex:490`
distinguishing `schemeHomRingCompatibility` (project-internal,
`pullbackPushforwardAdjunction` route) from
`(Scheme.Hom.toRingCatSheafHom _).hom` (the `pullback`-functor route
used by the iter-136 body). Prevents a future prover from
re-introducing a parallel helper. Not blocking; cheap; can be folded
into any iter-137+ blueprint-writer pass on `RigidityKbar.tex`.

## LOW — reusable proof patterns surfaced this iter

Three short patterns from iter-136 are codification-worthy:

1. **`change` over `show` for definitional-equality reshapes** when the
   syntactic form differs (Lean's linter warns on `show` for genuine
   shape changes; `change` accepts c-composition + whisker commutation
   reshapes without rewriting).
2. **`refine iso1 ≪≫ ?_ ≪≫ iso2.symm`** as the iso-equivalent of
   `refine ... ≫ ?_ ≫ ...` — the `.trans` API does NOT accept the
   literal `sorry` token in chained position (`«sorry».trans` parse
   error), so `≪≫` + `refine` is the idiomatic alternative.
3. **`Over.comp_left` + `lift_snd` + `Over.toUnit_left` + `rfl`** to
   close the canonical-section identity `s.left ≫ pr_2.left = G.hom ≫
   η[G].left` in `Over (Spec k)` for a `GrpObj G` (5 LOC private
   helper template).

These will be added to PROJECT_STATUS.md Knowledge Base in this review
phase.

## Targets the plan agent should NOT assign in iter-137

- **`mulRight_globalises_cotangent` (L610)** — the main lemma depends
  on Step 2 closure (iter-137 target above) plus Step 3 (iter-136
  closed). Premature dispatch in iter-137 risks the iter-134 anti-
  pattern (no scaffold available for Step 2, prover may invent
  another typed tautology under time pressure). Defer to iter-138+
  after Step 2 lands.

- **Any piece-(i.c) `omega_free` work**: depends on the full piece-(i.b)
  closure chain. iter-138+ at earliest.

- **`Jacobian.lean:197` (`genusZeroWitness`)**: M2.b body close
  scheduled iter-153–156 per STRATEGY.md sequencing table; off-limits
  iter-137.

- **`Jacobian.lean:223` (`positiveGenusWitness`)**: M3 user-
  escalation-gated; off-limits iter-137 (next TO_USER candidate iter-
  151+ per iter-136 plan.md § "Rebuttal to strategy-critic minor
  alternative").

- **`RigidityKbar.lean:87` (`rigidity_over_kbar`)**: M2.b
  body-pile-gated; off-limits iter-137.

## No CHURNING / STUCK signals

No prover lane this iter touched a CHURNING or STUCK route. Route 4
(piece (i.b)) flipped UNCLEAR → CONVERGING via the Step 3 closure.
Routes 1 (piece (i.a)), 2 (`Jacobian.lean`), and 3 (`RigidityKbar.lean`)
remain in their iter-136-classified states (CONVERGING / UNCLEAR-by-
design / UNCLEAR-by-design respectively). No iter-137 corrective
required for any route; the iter-137 plan agent operates in routine
mode.

## Predictions for iter-137 prover phase (Step 2 scope)

| Outcome | Iter-138 plan-phase action |
|---|---|
| Step 2 body substantively closed (L488 sorry → 0) | Route 4 stays CONVERGING. Dispatch iter-138 prover lane on the Main lemma `mulRight_globalises_cotangent` at L610 (~20–40 LOC composition; should be cheap once Steps 2+3 are both in hand). |
| Step 2 returns PARTIAL with coherent new helper(s) + sorry remaining | Dispatch mathlib-analogist on the bridge if not yet done; or blueprint-writer expansion on Step 2 proof sketch. Do NOT re-dispatch with same scope. |
| Step 2 returns INCOMPLETE or re-introduces typed-tautology placeholder | Route 4 flips CONVERGING → CHURNING per the iter-136 next-tier FAIL criterion. The `Nonempty (X ≅ X)` anti-pattern Knowledge Base entry is the binding rule; must-fix-this-iter under iter-138 plan agent. |
