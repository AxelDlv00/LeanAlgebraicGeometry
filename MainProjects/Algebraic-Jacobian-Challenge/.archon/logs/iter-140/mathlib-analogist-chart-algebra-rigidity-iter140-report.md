# Mathlib Analogist Report

## Slug

chart-algebra-rigidity-iter140

## Iteration

140

## Question

Compare the bundled **(i.b) `mulRight_globalises_cotangent` +
(i.c) chart-localisation/freeness/rank** path (~610–1310 LOC) against
a **direct chart-algebra rigidity alternative** that restricts `f^#`
per affine chart `V ⊆ A.left`, uses
`Algebra.IsStandardSmooth.free_kaehlerDifferential` directly, and
glues via in-tree `Scheme.Over.ext_of_eqOnOpen`. Verdict shape:
`ALIGN_WITH_BUNDLED` | `PIVOT_TO_CHART_ALGEBRA` | `HYBRID` |
`NEEDS_MATHLIB_GAP_FILL`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: Both paths need same genus-0 → vanishing-1-forms input | PROCEED | informational |
| 2: Chart-algebra cannot cleanly skip (i.b); restructures rather than eliminates | DIVERGE_INTENTIONALLY (short-term continue bundled) | high-stakes |
| 3: Compatibility with piece (ii) iter-138 PIN-path-(b) | PROCEED (chart-algebra inflates piece (ii) to 600–1050 LOC) | informational |
| 4: Chart-algebra ELIMINATES piece (iii) scheme-level Frobenius PHANTOM (800–1500 LOC) | NEEDS_MATHLIB_GAP_FILL (the PHANTOM is the gap; chart-algebra bypasses it) — **STRONGEST PIVOT DRIVER** | high-stakes |
| 5: API value of `omega_free` / `omega_rank_eq_dim` named consumers | DIVERGE_INTENTIONALLY (moderate loss, not load-bearing) | informational |

**Overall verdict shape**: **HYBRID — short-term ALIGN_WITH_BUNDLED on
iter-140 prover lane + iter-141 conditional pivot trigger if CHURNING
fires + iter-144 mandatory re-evaluation at piece (iii) gate.**

## Must-fix-this-iter

None. The bundled (i.b)+(i.c) path is the iter-140 prover-lane target
already, and the iter-138 substantive Route (b) work narrows (i.b) Step
2 to 3 concrete sub-sorries with closure recipes. No shipped divergent
code to refactor.

## Major

**Iter-144+ piece (iii) gate (pre-conditional)**: when the iter-144
scheme-level absolute Frobenius PHANTOM build is scheduled, the plan
agent **MUST** re-dispatch a chart-algebra-vs-bundled analysis with
this analogy file as the read-input. The piece-(iii) PHANTOM
elimination (~800–1500 LOC) is the single strongest pivot driver and
dominates the LOC-savings argument. Failure to re-evaluate at this gate
risks a sunk-cost trap on the scheme-Frobenius PHANTOM (which is
800–1500 LOC IN-TREE work with no Mathlib precedent in `b80f227`,
verified this iter via `lean_local_search`).

## Informational

- **Iter-140+ short-term**: continue bundled (i.b) Step 2 prover lane
  with Route (b'2) for IsIso per `analogies/isiso-basechange-along-proj-two-inv.md`
  (iter-139 verdict). The 3 sub-sorries are narrowed and closure
  recipes are in hand; iter-138 sunk cost makes a short-term pivot
  net-negative.
- **Iter-141 conditional pivot trigger**: if iter-140 fires the
  CHURNING criterion (0–1 sub-sorries closed, third consecutive PARTIAL
  on the piece (i.b) Step 2 family), AND a 5th analogist-overhead
  consult fires per iter-139 STRATEGY.md Edit 2, dispatch a fresh
  chart-algebra strategy-critic re-consult.
- **API loss under chart-algebra pivot**: `omega_free`,
  `omega_rank_eq_dim`, and `mulRight_globalises_cotangent` as
  Mathlib-PR-candidate named lemmas are not built. Moderate loss
  consistent with the project's Mathlib-contributor framing per
  iter-121 user directive.
- **Piece (ii) iter-138 PIN-path-(b) is unchanged** by either pivot
  decision. The chart-algebra alternative absorbs (i.b)+(i.c) into
  piece (ii)'s upstream input (~+300–450 LOC inflation), not into its
  body machinery.
- **Genus-0 → vanishing-1-forms input is invariant** across paths.
  Both bundled and chart-algebra need either piece (iv) Serre duality
  (3000–8000 LOC named gap, deferred) or piece (iii) char-p Frobenius
  to supply this. No path saves on this load-bearing dependency.
- **Scheme-level absolute Frobenius `F_X` PHANTOM verified absent**
  in Mathlib `b80f227` this iter (`lean_local_search` on
  `Scheme.absoluteFrobenius` and `Scheme.frobenius` returned `[]`).
- **Chart-level `Algebra.IsPushout`-from-affine-product helper**
  (~80–150 LOC, NEEDS_MATHLIB_GAP_FILL) is shared between Route (b'2)
  for (i.b) IsIso AND the chart-algebra alternative. Not a route
  discriminator.

## Persistent file

- `analogies/direct-chart-algebra-rigidity-ib-ic.md` — full design-
  rationale captured for iter-141+ planners and iter-144+ piece-(iii)-
  gate re-evaluation.

## Iter-140+ schedule recommendation

| Iter | Action |
|---|---|
| 140 | Continue bundled (i.b) Step 2 prover lane on 3 sub-sorries per PROGRESS.md plan; Route (b'2) for IsIso. |
| 141 | If iter-140 closes ≥2 sub-sorries: continue bundled. Else: fresh chart-algebra strategy-critic consult with this analogy as input + iter-140 STRATEGY.md Edit 1/2 triggers. |
| 143 | Schedule piece (ii) `ext_of_diff_zero` per iter-138 PIN-path-(b); 300–600 LOC envelope unchanged. |
| 144 | **MANDATORY** chart-algebra re-evaluation BEFORE committing scheme-Frobenius PHANTOM build (~800–1500 LOC). |

## Mathlib infrastructure check (verified this iter)

Present in `b80f227`:

- `Algebra.IsStandardSmooth.free_kaehlerDifferential`
  (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`) ✓
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  (same module) ✓
- `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`
  (`Mathlib.AlgebraicGeometry.Morphisms.Smooth:136`) ✓
- `KaehlerDifferential.exact_mapBaseChange_map`,
  `KaehlerDifferential.map_surjective`
  (`Mathlib.RingTheory.Kaehler.Basic`) ✓
- `KaehlerDifferential.polynomialEquiv` + `polynomialEquiv_D`
  (`Mathlib.RingTheory.Kaehler.Polynomial`) ✓
- `KaehlerDifferential.tensorKaehlerEquiv` + `_tmul_D` + `_symm_D_tmul`
  (`Mathlib.RingTheory.Kaehler.TensorProduct`) ✓
- `Polynomial.eq_C_of_derivative_eq_zero` (char-0 via `IsAddTorsionFree`)
  (`Mathlib.Algebra.Polynomial.Derivative`) ✓
- `iterateFrobenius` + `_def` + `_eq_pow` + `_comm`
  (`Mathlib.Algebra.CharP.Frobenius`) ✓
- `AlgebraicGeometry.pullbackSpecIso` + companions
  (`Mathlib.AlgebraicGeometry.Pullbacks`) ✓
- `AlgebraicGeometry.ext_of_isDominant_of_isSeparated'`
  (`Mathlib.AlgebraicGeometry.Morphisms.Separated`) ✓ — consumed by
  in-tree `Scheme.Over.ext_of_eqOnOpen`

Absent in `b80f227`:

- `AlgebraicGeometry.Scheme.absoluteFrobenius` or `Scheme.frobenius`
  — **NO**. Confirms iter-127/iter-128 framing of piece (iii) PHANTOM
  cost (800–1500 LOC IN-TREE per iter-128 strategy-critic honest LOC
  accounting). Chart-algebra alternative bypasses this PHANTOM.

The Mathlib roster is **identical** for both paths. Neither path
uncovers a Mathlib piece the other was missing.

## Overall verdict (one sentence)

Stay on bundled (i.b)+(i.c) through iter-140+ to honour iter-138 sunk
cost and preserve named API; conditionally pivot to chart-algebra at
iter-141 if (i.b) Step 2 CHURNING fires; **mandatorily re-evaluate at
iter-144 piece (iii) gate** where chart-algebra's scheme-Frobenius
PHANTOM-elimination (~800–1500 LOC saved) becomes the strongest
pivot driver.
