# Strategy Critic Directive — iter-143

## Slug
iter143

## Project goal

Formalize the nine protected declarations of Christian Merten's
Jacobian challenge (see `references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only
on them. `nonempty_jacobianWitness` quantifies over an arbitrary curve
`C : Over (Spec (.of k))` with `[SmoothOfRelativeDimension 1 C.hom]` — no
genus parameter, no $k$-rational-point hypothesis. End-state: zero
inline `sorry` (provisional on piece (iii) scheme-Frobenius closure
at a tractable LOC cost; the named-gap-sorry alternative is the honest
fallback at the iter-144+ scoping-analogist gate). Multi-year wall-clock
honest.

## Strategy under review

(Full `STRATEGY.md` verbatim — 621 LOC; paste from disk by reading
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`.)

The strategy was last substantively edited iter-142 (4 edits):
- Edit 1: Over-k operational convention collapse (one-paragraph
  header replacing layered "Direct over-k rigidity / Over-k re-defense
  / Iter-138 reframing" historical block; pile pieces formulated over
  arbitrary `k`; revert triggers (a')/(b)/(c) fire only on
  base-dependent pieces — currently none).
- Edit 2: Iter-141 obligation block marked DONE + iter-142+ rename
  (the iter-141 piece (iii) scheme-Frobenius scoping analogist DONE
  with HYBRID verdict; iter-144 mandatory chart-algebra-vs-bundled
  re-evaluation bullet cites both analogy files).
- Edit 3: Multi-month tail correction (acknowledges both
  `genusZeroWitness` + `positiveGenusWitness` scaffolds landed since
  iter-127 + iter-134; reframes "multi-month" to "multi-year" per
  iter-140 wall-clock correction).
- Edit 4: M3 RelativeSpec iter-150+ re-evaluation trigger concrete-ised
  (925-LOC + iter-160 dual threshold).

No edits planned this iter unless your verdict triggers them.

## Iter-142 prover-lane outcome you should know

The iter-142 prover lane on piece (i.b) Step 2 BUNDLED 3-sub-sorry
closure (d_app + d_map + IsIso) returned **PARTIAL — 1 of 3 closed
substantively (d_map at L643)**. This is the first strict-count closure
on this route since iter-138 (4 consecutive PARTIAL iters; helpers +3
across K=5; route was assessed STUCK-adjacent CHURNING iter-142
progress-critic).

**The iter-142 PROGRESS.md pre-committed iter-143 to a mid-iter
strategy-critic with a DIAGNOSTIC question** (NOT a route-pivot
pre-commitment, per the iter-141 must-fix #4 discipline rule on
CHURNING-trigger pre-commitments). That question is now folded into
this iter's mandatory strategy-critic dispatch (i.e., you).

The diagnostic question is:

> Iter-142 closed d_map substantively (the recipe worked) but did NOT
> close d_app (`change`-skeleton extended; Step 3 adjunction-transpose
> chase ~20–40 LOC bespoke NEEDS_MATHLIB_GAP_FILL remains) and did NOT
> close IsIso (Route (b'2) items 2–4, ~195–365 LOC bundled, deferred
> by the prover in favor of d_app + d_map). Is each of d_app +
> IsIso's remaining failure **recipe-level** (the chapter's recipe
> is wrong / too sketchy), **definition-level** (the Lean shape is
> wrong — e.g. the IsIso `letI := isIso_of_app_iso_module ... (fun _ => sorry)`
> pattern obscures the residual into a `letI` body and propagates a
> sorry-tainted iso downstream per lean-auditor-review142 MAJOR), or
> **strategy-level** (the over-k commitment / Replacement (B) /
> presheaf-level approach to piece (i.b) Step 2 is fundamentally
> over-engineered vs an alternative that the strategy hasn't yet
> surfaced)?

## References index (verbatim from `references/summary.md`)

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint summary (chapter titles + one-line topic)

| File | Topic |
|---|---|
| `AbelJacobi.tex` | Pointer chapter for `AlgebraicJacobian/AbelJacobi.lean`; three protected `Jacobian.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}` projections; uniform `letI`-load-then-`IsAlbanese.*`-project structure. |
| `AlgebraicJacobian_Cotangent_GrpObj.tex` | Pointer chapter for `AlgebraicJacobian/Cotangent/GrpObj.lean`; mathematical content lives in `RigidityKbar.tex` § Piece (i). |
| `Cohomology_MayerVietoris.tex` | Mayer–Vietoris on a 2-affine cover for `Scheme.HModule`; both `MayerVietorisCore.lean` + `MayerVietorisCover.lean` covered here. |
| `Cohomology_SheafCompose.tex` | `hasSheafCompose` instance for the `Scheme.HModule k` Grothendieck site. |
| `Cohomology_StructureSheafAb.tex` | Three single-line Ab-category instances (`Sheaf k` is `Cat (Sheaf Ab)` via `forget₂`). |
| `Cohomology_StructureSheafModuleK.tex` | The `k`-algebra-structure construction `Scheme.toModuleKSheaf` + the Čech-acyclicity transport pattern. |
| `Differentials.tex` | `relativeDifferentialsPresheaf` + the smoothness criterion `smooth_locally_free_omega` forward direction; M1.d off-loop PR candidate `kaehler_quotient_localization_iso`. |
| `Genus.tex` | `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. |
| `Jacobian.tex` | Protected `Jacobian` typeclass + `JacobianWitness` structure + `nonempty_jacobianWitness` (genus-stratified body `by_cases h : genus C = 0`); two scaffolds `genusZeroWitness` (M2) + `positiveGenusWitness` (M3). |
| `Rigidity.tex` | Mumford rigidity for pointed proper smooth morphisms; `Scheme.Over.ext_of_eqOnOpen`. |
| `RigidityKbar.tex` (1349 LOC; piece (i.b) prover-recipe heavy) | M2.a rigidity for genus-0 curve over `k` to smooth proper geom-irr group scheme; piece (i) cotangent-vanishing pile decomposition (i.a/i.b/i.c); Steps 1–3 + Main of piece (i.b); d_app + d_map + IsIso closure recipes for piece (i.b) Step 2 BUNDLE. |

## Prior critique status

Iter-142 strategy-critic returned **CHALLENGE** (8 routes; 2 CHALLENGE
on presentation / 0 REJECT; 3 alternatives surfaced; 0 NEW sunk-cost
flags — strategy now self-flags its own sunk-cost hazards). 3 must-fix
items absorbed via STRATEGY.md edits 1–4 above. 3 alternatives surfaced:
1. **Over-k presentation collapse** — adopted substantively as Edit 1.
2. **RelativeSpec in-loop scaffold** — recorded as available but not
   scheduled (Edit 4 added concrete iter-150 trigger).
3. **Piece (iii) named-gap earlier promotion** — recorded as available
   but not adopted (the iter-144 gate holds).

Watchpoints carried into iter-143:
- Iter-142 Edits 1–4 re-verification (over-k convention residue;
  iter-141 DONE marking; multi-year tail; RelativeSpec iter-150 trigger
  consistency).
- Iter-145+ piece (i.b) Step 2 route-pivot breakeven (per
  `progress-critic-iter141` secondary corrective; reinforced by
  `progress-critic-iter142` STUCK-adjacency): 5 consecutive iters of
  attention on (i.b) Step 2 without strict-count closure was the
  breakeven point. **Iter-142 closed d_map strict-count → the
  breakeven count partially resets; does the post-iter-142 reading
  still warrant iter-145+ breakeven pre-commitment or has the
  strict-count closure pushed it out?**
- Iter-150 5-consult overhead arm revisit (per iter-140 narrowed
  envelope-widening arm + Edit 1 sunk-cost residual; strategy-critic-
  iter141 noted the arm now mechanically fires this iter — is the
  watchpoint still well-defined?).

## Question for you

In addition to your standard whole-strategy audit (goal alignment,
mathematical soundness, alternative routes, sunk-cost reasoning,
prerequisite assumptions, effort estimates), please specifically
answer the iter-142 PROGRESS.md **diagnostic question** above:

> For each of d_app + IsIso, is the iter-142 PARTIAL **recipe-level**,
> **definition-level**, or **strategy-level**?

For each diagnosis, name the iter-143 corrective:
- **Recipe-level** → blueprint-writer dispatch on `RigidityKbar.tex` to
  refine the recipe with the iter-142 empirical shape-discoveries (the
  `rw [show ... from NatTrans.naturality_apply ...]` packaging pattern;
  the fully-explicit `change` on both sides; the Step 3 adjunction-
  transpose ~20–40 LOC bespoke chase). Then iter-144 prover.
- **Definition-level** → refactor subagent on the IsIso `letI` pattern
  (extract into a named sorry-bodied theorem per lean-auditor-review142
  MAJOR). Then iter-144 prover.
- **Strategy-level** → route pivot. Specifically, the iter-145+ breakeven
  pre-commitment is now one iter early per the iter-142 CHURNING-CONFIRMED
  arm. The alternative routes you should evaluate:
  - Fibre-free piece (i) reformulation (iter-133 evaluated 4-axis;
    STAY ON (B) was the verdict; piece (i.b) Step 2 LOC midpoint 525
    LOC vs fibre-free ~600 LOC; rejection on ~10% LOC differential).
    Iter-142 measured (i.b)-side build at ~575 LOC (iter-141 estimate
    ~745–975 LOC at iter-142 close per PROGRESS.md L137); is the LOC
    differential still under the 20% pivot threshold?
  - Iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation
    (`analogies/direct-chart-algebra-rigidity-ib-ic.md` iter-140 +
    `analogies/scheme-frobenius-piece-iii-scoping.md` iter-141) — should
    this be **pulled forward to iter-143** given iter-142's PARTIAL?
    The pull-forward cost is one mathlib-analogist consult; the pull-
    forward benefit is one iter sooner re-evaluation of whether
    piece (i.b) is being over-built.
  - Direct route pivot to off-route M-piece bodies (the iter-145+
    breakeven option; abandon BUNDLED Step 2 attempt; re-open
    STRATEGY.md). Iter-142 progress-critic's CHURNING (STUCK-adjacent)
    classification + the iter-142 close's strict-count closure on
    d_map argues against this — but the iter-141 secondary corrective
    + the iter-142 STUCK-adjacency argue for it.

## Strict context discipline reminder

You are intentionally NOT given iter sidecars, recent prover task
results, or per-iter narrative beyond the iter-142 outcome summary
above (which I include because it's the iter-143 decision context;
ignore it if you find it pollutes your fresh read). Your value is the
fresh-mathematician audit of `STRATEGY.md` against the project goal
+ blueprint summary. The iter-142 outcome is given only because
the diagnostic question explicitly depends on it.
