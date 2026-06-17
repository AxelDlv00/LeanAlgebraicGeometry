# Mathlib Analogist Report — scheme-Frobenius scoping (iter-141)

## Slug

scheme-frobenius-iter141

## Iteration

141

## Question (verbatim)

Scope `AlgebraicGeometry.Scheme.absoluteFrobenius` PHANTOM against
Mathlib `b80f227`, using Stacks Tag 0CC4 as the canonical construction
reference and `Mathlib.Algebra.CharP.Frobenius` as the ring-side
baseline. Output: per-sub-piece LOC estimate, idiom-alignment cost
broken out explicitly (parallel-API risk; consumer-side bridge-lemma
cost), prerequisite gaps, and a verdict on whether the in-tree build
is sustainable at < 2000 LOC.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. `Scheme.absoluteFrobenius` def + functoriality + basic API (~150–300 LOC) | NEEDS_MATHLIB_GAP_FILL | informational |
| 2. Restriction compatibility `F_X|_U = F_U` (~80–150 LOC) | NEEDS_MATHLIB_GAP_FILL | informational |
| 3. Iterate `iterateFrobenius_X p n` (~50–120 LOC) | NEEDS_MATHLIB_GAP_FILL | informational |
| 4. Consumer "df=0 ⇒ f factors through F_C^n" (~400–800 LOC) | NEEDS_MATHLIB_GAP_FILL | informational |
| 5. Parallel-API risk on `Scheme.Spec.map` (~+10–30 LOC anchoring lemma) | PROCEED | informational |
| 6. Chart-algebra alternative bypasses scheme-Frobenius PHANTOM | CHART_ALGEBRA_BYPASSES_PHANTOM | major |

## Pivot criterion result

**Pivot threshold (verbatim from STRATEGY.md / directive)**: 2000 LOC.

**My estimate for sub-pieces 1–4 (the dispositive count)**: **680–1370 LOC**
(midpoint ~1025 LOC; close to the iter-128 strategy-critic estimate of
800–1500 LOC, validating that prior accounting).

**My estimate for sub-pieces 1–4 plus sub-piece 5 anchoring lemmas**:
**690–1400 LOC**.

**Result**: my estimate is **substantially below the 2000 LOC pivot
threshold**. The upper bound (1400 LOC) leaves 600 LOC of slack against
the threshold; even doubling sub-piece 4's local-form cost would still
keep the total below 2000 LOC.

**Pivot trigger does NOT fire on LOC grounds.** The named-gap-sorry
alternative does NOT need elevation from "active alternative" to
"preferred default" on LOC-pivot grounds. The in-tree scheme-Frobenius
build is sustainable at the projected envelope.

## Must-fix-this-iter

None. Every NEEDS_MATHLIB_GAP_FILL verdict here is an *upstream gap*,
not a project failure. No ALIGN_WITH_MATHLIB verdict fires (the
construction shape proposed by this analogist follows Mathlib idioms
for building `Scheme.Hom` cleanly; no parallel API is created).

## Major

- **Decision 6 (chart-algebra alternative)**: structurally identical to
  `analogies/direct-chart-algebra-rigidity-ib-ic.md` (iter-140)
  Decision 4. The chart-algebra route GENUINELY bypasses the *entire*
  scheme-Frobenius PHANTOM build for the M2.a-body consumer
  (~680–1370 LOC saved), absorbing only ~150–300 LOC of chart-level
  Frobenius work into piece (ii)'s scope. **Chart-algebra is the
  LOC-dominant route.**

  Two non-LOC considerations affect the recommendation:
  - Sub-pieces 1+3 (Mathlib-PR core, ~200–420 LOC) retain Mathlib-PR
    utility *independent* of M2.a-body need. They can ship as
    off-loop Mathlib-PR contributions under EITHER route.
  - Sub-piece 4 (the consumer lemma, ~400–800 LOC) is the only sub-
    piece chart-algebra *substantively* replaces, and it's the
    dominant cost.

- **Sub-pieces 2+4 are discretionary in the chart-algebra route**.
  Sub-pieces 1+3 alone (~200–420 LOC) are the durable Mathlib-PR
  contribution; sub-pieces 2+4 are higher-priority *only* if the
  project commits to building piece (iii) fully in-tree.

## Informational

- **Decision 5 (no parallel-API risk)**: confirmed. Mathlib's
  `AlgebraicGeometry.Spec.map` family
  (`Mathlib.AlgebraicGeometry.Scheme:499–730`) provides the affine-side
  Frobenius lift for free. The project's scheme-side construction
  *consumes* `Spec.map`; it does not parallel it. The single anchoring
  lemma `(Spec R).absoluteFrobenius p = Spec.map (CommRingCat.ofHom (frobenius R p))`
  is ~5–10 LOC, included in sub-piece 1's API count.

- **NEEDS_MATHLIB_GAP_FILL verdicts (sub-pieces 1–4)** are all
  informational at the project level — these are genuine upstream
  gaps that the project would fill in-tree if option (4) is chosen,
  but each construction follows Mathlib idiom cleanly:
  - sub-piece 1: build `LocallyRingedSpace.Hom X.toLRS X.toLRS` via
    `base = 𝟙`, `c = NatTrans` whose component at `U` is
    `CommRingCat.ofHom (frobenius (X.presheaf.obj U) p)`, naturality
    by `RingHom.frobenius_comm`, stalk-locality by `frobenius` being
    a local ring hom (`m^p ⊆ m`).
  - sub-piece 2: `Scheme.Hom.ext` + per-open `frobenius_comm`.
  - sub-piece 3: define `iterateFrobenius_X := (absoluteFrobenius X p)^[n]`
    via `Monoid.npow` on `End X`, mirroring `iterateFrobenius_eq_pow`
    ring-side.
  - sub-piece 4: local-form Kähler-kernel + `p`-th-power; quasi-
    compactness for uniform `n`; scheme-level factorization wrapper.

- **Char-p hypothesis shape**: cleanest is `[ExpChar Γ(X, ⊤) p]` at
  the global section level, which propagates to each `Γ(U)` via
  `RingHom.charP` applied to the restriction `Γ(X) → Γ(U)`. No new
  typeclass needed; `Mathlib.Algebra.CharP.Defs` + `.Algebra` cover
  the propagation.

## Cross-cutting LOC tally (re-stated for the report)

| Sub-piece | LOC range | Idiom alignment | Bypassable by chart-algebra? |
|---|---|---|---|
| 1. `absoluteFrobenius` def + functoriality + API | 150–300 LOC | Mathlib-aligned | Yes |
| 2. Restriction compatibility | 80–150 LOC | Mathlib-aligned | Yes |
| 3. `iterateFrobenius_X` | 50–120 LOC | Mathlib-aligned | Yes |
| 4. Consumer "df=0 ⇒ factors through F_C^n" | 400–800 LOC | No top-level Mathlib idiom; pieces clean | Yes (~150–300 LOC absorbed into piece (ii)) |
| 5. Anchoring lemma (`Spec.absoluteFrobenius_eq`) | +10–30 LOC (included in #1) | No parallel API | N/A |
| **Sub-pieces 1–4 sum** | **680–1370 LOC** | NEEDS_MATHLIB_GAP_FILL | **Yes, entirely** |

| Path | Piece (iii) LOC | Piece (ii) LOC (absorption) | Total | Residual named gap? |
|---|---|---|---|---|
| (1) Full in-tree scheme-Frobenius (sub-pieces 1–4) | 680–1370 | 300–600 (unchanged) | **980–1970** | No |
| (2) PR-shaped Mathlib-PR (sub-pieces 1+3) + named-gap on sub-piece 4 | 200–420 | 300–600 (unchanged) | **500–1020** | Yes (1) |
| (3) Chart-algebra (no scheme-Frobenius) | 0 | 450–900 (+150–300 chart-Frobenius) | **450–900** | No |
| (4) Named-gap-sorry only (no chart-algebra) | 0 | 300–600 (unchanged) | **300–600** | Yes (1) |

All four paths are **below the 2000 LOC pivot threshold**. Path (3)
chart-algebra is the LOC-cheapest with no residual named gap; path (1)
full in-tree is the most expensive but ships the full Mathlib-PR
contribution.

## Persistent file
- `analogies/scheme-frobenius-piece-iii-scoping.md` — full decision
  rationale; load-bearing read-input for the iter-144 MANDATORY
  chart-algebra-vs-bundled re-evaluation gate.

## Overall verdict

**HYBRID — in-tree build sustainable below the 2000 LOC pivot
threshold; chart-algebra alternative remains LOC-dominant and is
recommended for the M2.a-body consumer.** The pivot trigger does NOT
fire; the iter-144 re-evaluation should proceed as a *strategic*
choice between LOC-cheaper chart-algebra (option 3), full Mathlib-PR
in-tree (option 1), and PR-core + named-gap mixed (option 2), informed
by iter-140→iter-143 closure status.

scheme-frobenius-iter141: HYBRID — 6 decisions analyzed, 0 ALIGN_WITH_MATHLIB, 4 NEEDS_MATHLIB_GAP_FILL, 1 PROCEED, 1 CHART_ALGEBRA_BYPASSES_PHANTOM
- `analogies/scheme-frobenius-piece-iii-scoping.md`
- `.archon/task_results/mathlib-analogist-scheme-frobenius-iter141.md`
