# progress-critic pc252 — directive

Assess convergence for the two active prover routes the planner is considering for
iter-252 dispatch. K=5 window (iters 247–251). Return a per-route verdict
(CONVERGING / CHURNING / STUCK / UNCLEAR) and dispatch-sanity for the proposed M=2.

---

## Route 1 — Lane TS-cmp — `Picard/TensorObjSubstrate.lean` (comparison iso D1′→D3′→D4′)

Critical path. Goal: upgrade the pullback–tensor comparison map δ to an iso on
locally-trivial line bundles (D4′), via D1′ (δ-naturality), D3′ (δ vs base-change
square), assembled by chart-chase.

Per-iter signals:
- iter-247: PARTIAL. η-bridge (a D2′ sub-obligation) reduced to one square; several
  helpers added. Blocker phrase: "presheaf↔sheaf defeq-laden labor".
- iter-248: PARTIAL. D2′ 2/3 ★ mate-lemmas closed + `rfl` linchpin. Blocker: `.val`-composite friction.
- iter-249: PARTIAL. D2′ abstract telescope assembled into ONE compiling proof, 1 concrete residual.
  Blocker: `Category.assoc`/`rw` silently fail to match on PresheafOfModules-over-Sheaf.val composites.
- iter-250: **COMPLETE**. D2′ CLOSED axiom-clean (`pullbackTensorMap_unit_isIso`); the (∗∗) residual
  eliminated; verified no sorryAx. File sorry 2→1. (First canonical critical-path sorry-elimination of this route.)
- iter-251: PARTIAL. D1′ `pullbackTensorMap_natural` authored; reduced to ONE whisker identity. Two NEW
  closed lemmas (`pullbackValIso_hom_natural` axiom-clean; `sheafifyTensorUnitIso_hom_eq` `:= rfl`).
  File sorry 1→3 (the +2 are the authored D1′ + its helper, both honest typed sorries with named residual).
  Blocker: Mathlib whisker lemmas (`whisker_exchange`, `comp_whiskerRight`, `whiskerLeft_comp`) do not fire
  because the goal's `▷`/`◁` come from a file-local `MonoidalCategoryStruct` (forget₂ carrier),
  defeq-but-not-syntactic to the canonical instance. Fix identified: a second carrier-normalisation
  brick (analogue of the closed `sheafifyTensorUnitIso_hom_eq`).

- File sorry counts per iter (247→251): 2, 2, 2, 1, 3
- Prover statuses (247→251): PARTIAL, PARTIAL, PARTIAL, COMPLETE, PARTIAL
- Recurring blocker across the WHOLE window: `.val` / forget₂-carrier defeq-not-syntactic friction
  (rw/simp/Mathlib lemmas silently not unifying). Each new construction needs its own
  carrier-normalisation `_eq` lemma; once built, Mathlib lemmas fire. This is the same class that gated
  D2′ for 11 iters and was DEFEATED at iter-250 with the propositional `:= rfl` strip + `erw` keyed-defeq merge.

STRATEGY `Iters left` for this phase: "D1′ frontier (easy); D3′+D4′ ~5–10". Phase entered its current
sub-state (post-D2′-close) at iter-250.

Proposed iter-252 objective: build the ONE named whisker-carrier-normalisation brick → close D1′ →
attempt D3′ (pre-armed by `analogies/d3-251.md`) → D4′ stretch.

---

## Route 2 — Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean` (dual-inverse chain)

NEW file (scaffolded iter-251); independent of Route 1; feeds `RelPicFunctor.addCommGroup` via
`exists_tensorObj_inverse`. Only 1 iter of data.

Per-iter signals:
- iter-251: PARTIAL. Four NEW closed axiom-clean decls (`unitDualSectionEquiv`, `dualUnitIsoGen`,
  `presheafDualUnitIso`, `dual_unit_iso` — the eval-at-1 dual-of-unit iso with non-trivial left_inv +
  naturality, scratch-verified). `dual_isLocallyTrivial` assembled (transitively partial: depends on
  `dual_restrict_iso`'s Step-4 sorry). `dual_restrict_iso` advanced from bare sorry to Steps 1–3 + H1,
  one residual sorry at the Step-4 presheaf goal `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`.
  `homOfLocalCompat` (the planner's stated minimum, frontier base, all deps closed) NOT started — prover
  judged the dual chain higher-value. File sorry 3→2.
- Blocker: Step-4 pushforward-commutes-with-dual presheaf residual; the prover deliberately did NOT
  thrash it (honoring a prior warm-context warning) and flagged it for a targeted analogist consult.

- File sorry counts: 3 → 2 (one iter)
- Status: PARTIAL (1 iter)

STRATEGY: this lane is part of A.1.c.sub, de-gated by the iter-250 D2′ close. No standalone Iters-left row.

Proposed iter-252 objective: close `homOfLocalCompat` (frontier base, pure gluing labor, no consult
needed) + close `dual_restrict_iso` Step-4 (to be pre-armed with a focused mathlib-analogist consult on
the pushforward-dual sectionwise ring-iso).

---

## Dispatch-sanity question

Proposed `## Current Objectives` for iter-252 (M=2, file count = 2):
1. `Picard/TensorObjSubstrate.lean` [prove]
2. `Picard/TensorObjSubstrate/DualInverse.lean` [prove]

Both files are independent (Route 1 owns TensorObjSubstrate.lean; Route 2 owns DualInverse.lean, which
imports the former). No other route is structurally available this iter (RPF gated cross-file on D4′ +
the dual chain; A.2.c engine HELD; Route C PAUSED by user). Is M=2 right, under-, or over-dispatch?

Note a coordination hazard observed iter-251: Route 1 editing TensorObjSubstrate.lean left it broken
mid-session, transiently blocking Route 2's LSP verification (DualInverse imports it). Final build was green.
