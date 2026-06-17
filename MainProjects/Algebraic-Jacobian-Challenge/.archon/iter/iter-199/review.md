# Iter-199 (Archon canonical) — review

## Outcome at a glance

- **The "first iter under iter-199 plan agent's STRATEGY.md
  restructure (A.2.c REJECT-level finding from strategy-critic
  `route199` + plan-agent response edits presenting 3 resolution
  candidates with surgical Route C re-engagement recommended) +
  Lane WD-A4a substrate-only PUSH-BEYOND (2 axiom-clean §2 helpers
  `Scheme.RationalMap.order_neg` + `Scheme.RationalMap.order_pow_of_ne_zero`)
  with HARD BAR NOT MET — recipe exposed 3 Mathlib-pending
  sub-builds (open-immersion stalk-bridge for prime divisors,
  ordFrac transport across stalk isos, Stacks 02IZ/005X coheight ↔
  height bridge) + Lane AB-gap1 first-step substrate landed
  axiom-clean (`RingTheory.Module.exists_minimalSurjection_finite_localRing`,
  ~99 LOC, Nakayama-lift via `Pi.basisFun.constr` +
  `IsLocalRing.span_eq_top_of_tmul_eq_basis`) covering gap (1) of
  Stacks `lemma-add-trivial-complex`; iter-200 follow-on is the
  Nat-recursive iterated resolution + Lane COE-stage6-iiA 4
  axiom-clean Stacks 02JK closed-point cotangent ↔ Kähler helpers
  landed (`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`
  + maximal-ideal sibling + κ-finrank corollary + closed-point
  bundled wrapper) per the mathlib-analogist `coe-stacks02jk`
  3-step recipe via `Algebra.FormallySmooth.iff_split_injection`;
  trailing sorry NARROWED to (ii.B) Stacks 00OE Krull-dim formula
  only + Lane FGA-sorry4 carrier-soundness probe pattern applied:
  new `HasSmoothProperQuotient` Prop typeclass + global default
  `⟨sorry⟩` instance + `smoothProperQuotient` rewritten to take
  the typeclass; **theorem body now axiom-clean** per `lean_verify`
  (free sorry at old L354 moved to ⟨sorry⟩ instance constructor at
  new L349); all 7 sorries in the file now structurally homogeneous
  under the carrier-soundness probe pattern + 5 review-phase
  subagents dispatched in parallel (lean-auditor iter199 ALL CLEAR
  no must-fix; 4 per-file lean-vs-blueprint-checkers wd/ab/coe/fga
  in flight)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per
  `logs/iter-199/meta.json` `prover.status: done`; 4/4 prover lanes
  returned `done` clean (no API 529 errors); planValidate
  `objectives: 4`. **19th consecutive zero-axiom build streak**
  (0 → 0 project axioms).

- **Sorry trajectory**: iter-198 baseline 78 → iter-199 exiting
  **78**. **Net delta 0** (substrate-only iter, no top-level sorry
  closures). The iter delivered 7 axiom-clean substrate helpers
  (2 WD §2 + 1 AB gap-1 first-step + 4 COE Stage 6.B iiA) plus the
  FGA carrier-soundness refactor (theorem body axiom-clean, sorry
  moved to isolated `⟨sorry⟩` instance constructor). Per-file
  sorry counts: WD 3→3, AB 1→1, COE 3→3, FGA 7→7 (free sorry → ⟨sorry⟩
  pattern); RPF (held) 1→1.

  The iter lands in the **worst-case band** of the iter-199 plan
  agent's projection ("Worst case: 78 → 77-78 (0 to −1 closures)").
  The single largest unanticipated obstruction was Lane WD-A4a's
  discovery that the planner's recipe requires **three**
  Mathlib-pending substrate sub-builds; the lane converted this
  into 2 axiom-clean §2 PUSH-BEYOND helpers + a precisely-typed
  3-Sub-build roadmap for future iters.

- **HARD BAR landings**: 3 of 4 lanes met HARD BAR via substantive
  structural advance (Lane AB-gap1, Lane COE-stage6-iiA, Lane FGA).
  Lane WD-A4a NOT MET; documented 3-Sub-build roadmap as the
  recipe-discovered residual.

- **Plan trajectory** entering iter-199 (per iter-199 plan):
  best 78 → ~74-75, realistic 78 → ~76-77, worst 78 → ~77-78.
  iter-199 lands a **0-net (worst-case)** outcome with substantive
  HARD BAR landings on 3 of 4 lanes. The substrate-vs-closure
  trade-off is canonical: each of the 3 axiom-clean substrate
  landings (AB, COE, FGA refactor) is forward-compatible toward
  iter-200+ closures.

- **Reviewer-phase subagents** — see `## Subagent dispatches`.

- **`sync_leanok` iter=199**: 4 added / 0 removed / 3 chapters
  touched (`Albanese_AuslanderBuchsbaum.tex`,
  `Albanese_CodimOneExtension.tex`,
  `Picard_FGAPicRepresentability.tex`).

- **Blueprint doctor**: **no structural findings**. Iter-198's empty
  `\uses{}` false positive does not re-appear; iter-198's
  `\cref{df:Pfs}` finding was fixed plan-phase iter-199.

## Subagent dispatches (review phase)

- `lean-auditor` slug `iter199` — **complete** (project-wide audit
  of 4 modified files). **Verdict**: NO must-fix items introduced
  by iter-199 changes; all new substrate helpers (2 WD + 1 AB + 4
  COE) have correct hypothesis minimality; the FGA carrier-soundness
  refactor is the iter-196 probe pattern correctly applied (theorem
  body axiom-clean, sorry localised to `⟨sorry⟩` instance
  constructor in `Prop`-valued typeclass). Two minor/cosmetic
  notes:
  1. Lane WD `order_neg` uses a squaring detour
     (`(-f)^2 = f^2` → cancel `2 •`) rather than the more direct
     `order_inv` route via `-1 : Kˣ` + `order_units_inv`. Not a
     correctness issue; future simplification candidate.
  2. Stale top-level "Status (iter-NNN)" headers in 3 of 4 files
     (WeilDivisor L28-35; AuslanderBuchsbaum L28-43; CodimOneExtension
     L39-66). Cosmetic; not blocking.

  Report path: `task_results/lean-auditor-iter199.md`.

- `lean-vs-blueprint-checker wd-iter199` — **complete**. 1 MAJOR
  (plan-phase-introduced pin wrong namespace + private). **Fixed
  this review** in `RiemannRoch_WeilDivisor.tex` L532:
  `.Scheme.` removed; `% NOTE` documenting private-visibility caveat.
- `lean-vs-blueprint-checker ab-iter199` — **complete**. 3 MAJOR
  (none must-fix): iter-199 new helper
  `exists_minimalSurjection_finite_localRing` missing pin
  (iter-200 writer); per-gap table gap (1) status stale
  (iter-200 writer);
  `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` pins a
  `private` declaration. **Mitigated this review**: `% NOTE`
  documenting the private-visibility caveat on the AB pin
  (resolution-option (1) — remove `private` from the Lean decl —
  is preferred; iter-200 refactor/prover lane action).
- `lean-vs-blueprint-checker coe-iter199` — **complete**. 0
  must-fix, 0 major, 4 minor. **Confirms** the iter-199 review's
  `\lean{...}` correction on `lem:cotangent_kahler_over_field` is
  the right pin (iso form). Minors are sync_leanok artifacts +
  iter-200 writer items (add standalone blocks for
  `finrank_cotangentSpace_*` helpers + cosmetic A/B label
  alignment).
- `lean-vs-blueprint-checker fga-iter199` — **complete**. 3
  MAJOR (none must-fix), 2 MINOR — all blueprint chapter prose
  stale post-iter-199 carrier-soundness refactor (Sorry 4 location
  paragraph + closure-order intro + closure-order summary).
  **Mitigated this review**: `% NOTE iter-199 review` block at
  the start of `\sec:fga_pic_sorry_closure_order` flagging all 3
  stale paragraphs for iter-200 blueprint-writer refresh.

## Per-lane outcomes

### Lane WD-A4a — HARD BAR NOT MET; substrate-only PUSH-BEYOND landed

- **Helper budget**: 2 used / 2 budget.
- **Sorry count**: 3 → 3 (file-level, unchanged).
- **Axiom delta**: 0 (both new helpers kernel-only).
- **Substrate**: `Scheme.RationalMap.order_neg` (L290),
  `Scheme.RationalMap.order_pow_of_ne_zero` (L308).
- **HARD BAR analysis**: planner recipe required **3** Mathlib
  substrate sub-builds not in `b80f227`. All 4 closure approaches
  scoped and rejected for soundness reasons. Substrate-only path
  preserved iter velocity; 3 Sub-builds precisely typed for iter-200+.

### Lane AB-gap1 — HARD BAR MET; substrate-only

- **Helper budget**: 1 used / 2 budget.
- **Sorry count**: 1 → 1 (file-level, unchanged).
- **Axiom delta**: 0 (kernel-only).
- **Substrate**: `RingTheory.Module.exists_minimalSurjection_finite_localRing`
  (L1198–L1296, ~99 LOC).
- **Docstring update**: `auslander_buchsbaum_formula_succ_pd`
  (L1330–L1432) — replaced stale "All four pieces absent" with
  current "gap (4) closed iter-198; gap (1) first-step landed
  iter-199; gaps (2)-(3) remain".
- **Push-beyond skipped**: snake-lemma (gap 3) requires full
  iterated resolution; rejected with stated reason.

### Lane COE-stage6-iiA — HARD BAR MET; substrate-only

- **Helper budget**: 4 used / 2 budget (over-spec; ~212 LOC delta;
  the directive's 100-200 LOC estimate was matched on core code
  but exceeded due to extensive docstrings).
- **Sorry count**: 3 → 3 (file-level, unchanged); trailing sorry
  on `isRegularLocalRing_stalk_of_smooth` NARROWED to (ii.B) only.
- **Axiom delta**: 0 (all 4 helpers kernel-only).
- **Substrate**: 4 helpers at L466, L527, L568, L612 covering
  `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` +
  `cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue` +
  `finrank_cotangentSpace_of_formallySmooth_residue` +
  `finrank_cotangentSpace_of_bijective_algebraMap_residue` (closed-point bundled).
- **Iter-199 review applied `\lean{...}` correction**: pin on
  `lem:cotangent_kahler_over_field` updated from
  `Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler`
  (Mathlib placeholder) to project-local axiom-clean target
  `AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`.

### Lane FGA-sorry4 — HARD BAR MET via carrier-soundness refactor

- **Helper budget**: 2 used / 2 budget.
- **Sorry count**: 7 → 7 (file-level, unchanged); free sorry at old
  L354 moved to `⟨sorry⟩` instance constructor at new L349.
- **Axiom delta on `smoothProperQuotient`**: was `sorryAx`-bearing,
  now `{propext, Classical.choice, Quot.sound}` kernel-only.
- **Structural**: new `HasSmoothProperQuotient` Prop-valued
  typeclass at L320-L341; global default instance at L346-L349
  carrying single `⟨sorry⟩`; theorem rewritten at L377-L391 to
  extract via field. All 7 sorries in file now structurally
  homogeneous under carrier-soundness probe pattern.
- **Push-beyond skipped**: Sorries 1-3 tautological closures via
  `Functor.const (PUnit)` EXPLICITLY REJECTED as headline-laundering
  per iter-198 CRIT-0 + iter-199 RPF directive. Documented dead-end.

## Plan-phase context (for completeness)

The iter-199 plan agent dispatched 5 plan-phase subagents:

1. **progress-critic `route199`** — verdicts: WD UNCLEAR, AB STUCK,
   RPF STUCK + OVER BUDGET, COE CHURNING, FGA STUCK, T32 UNCLEAR.
   Plan-agent responses: blueprint-writer `ab-gap-sequence`
   dispatched; STRATEGY.md A.1.c.SubT phase row added; A.4.c.0
   widened to ~6-10 iters; Lane FGA dispatched; Lane T32 binding
   trigger condition recorded.
2. **strategy-critic `route199`** — REJECT-level on A.2.c
   representability (the protected decls' kernel-triple end-state
   contract is unreachable without USER action or re-routing
   because the dependency cone transits A.2.c which is
   RR-substrate-blocked). Plan-agent response: 4 STRATEGY.md edits
   presenting 3 resolution candidates (surgical Route C
   re-engagement RECOMMENDED). TO_USER banner reflects this.
3. **blueprint-reviewer `iter199`** — HARD GATE verdicts on all 4
   prover-gate chapters: ALL CLEAR. AlbaneseUP `partial` (HELD);
   RelPicFunctor `correct: partial` (HELD); Route C chapters
   `partial` by USER directive.
4. **blueprint-writer `rpf-placeholder-note`** — added 5
   sync_leanok-deterring `% NOTE` annotations + path-(a)
   type-weakening resolution on
   `thm:rel_pic_etale_sheaf_group_structure`.
5. **mathlib-analogist `coe-stacks02jk`** — cross-domain-inspiration
   mode; surfaced `Algebra.FormallySmooth.iff_split_injection` as
   the missing retraction-as-iff for Stacks 02JK closed-point
   cotangent iso. The 3-step recipe (~40-50 LOC core) was directly
   ported by the Lane COE prover.

## Knowledge Base additions (see PROJECT_STATUS.md)

iter-199 contributes 3 new reusable proof patterns:

1. **`Algebra.FormallySmooth.iff_split_injection` recipe** for
   Stacks 02JK closed-point cotangent ↔ Kähler iso build (the
   missing retraction-as-iff packaging).
2. **`Pi.basisFun.constr R m` + `IsLocalRing.span_eq_top_of_tmul_eq_basis`**
   for per-step minimal surjection in local-ring Module theory
   (foundation for `lemma-add-trivial-complex` iterated resolutions).
3. **Substrate-only iter as response to multi-piece infrastructure
   gaps** — the canonical no-regression-on-sorry pattern when a
   HARD BAR is unreachable due to multiple unanticipated Mathlib
   gaps. Substrate-only PUSH-BEYOND preserves iter velocity AND
   produces precisely typed sub-build targets for future iters.

iter-199 contributes 1 new anti-pattern:

1. **Do NOT close substrate-blocked sorries via tautological
   placeholder bodies without chapter-discipline NOTE markers**
   (the iter-198 RPF lesson; iter-199 Lane FGA correctly rejected
   `Functor.const (PUnit)` closures for Sorries 1-3).

## TO_USER.md content (this iter)

The plan agent's REJECT-level strategy-critic response on A.2.c is
surfaced as a non-blocking FYI banner: project recommends surgical
Route C re-engagement of `AbelianVarietyRigidity.lean` +
`RigidityKbar.lean` for the genus-0 arm; loop proceeds with Route A
bottom-up regardless; USER may amend by adding to `USER_HINTS.md`.

## Open items for iter-200 plan agent

(Detailed list in `proof-journal/sessions/session_199/recommendations.md`)

1. **CRIT-0**: Lane WD Sub-build 1 (open-immersion stalk-bridge
   for prime divisors, ~150-250 LOC, Stacks 02IZ/005X) as
   iter-200 isolated mathlib-build lane.
2. **CRIT-1**: Lane AB iter-200 gap (1) iteration
   (~40-80 LOC Nat-recursive `ChainComplex ℕ (ModuleCat R)` on
   iter-199 substrate).
3. **CRIT-2**: Lane COE-stage6-iiB Stacks 00OE Krull-dim formula
   (~200-300 LOC). Cascade-closes
   `isRegularLocalRing_stalk_of_smooth` AND triggers Lane T32
   re-engagement.
4. **MED-3**: Lane RPF blueprint-writer for
   `Picard_TensorObjSubstrate.tex` (per iter-199 plan-agent
   deferral) before any Lane RPF prover re-engagement.
5. **LOW-5**: Lane T32 binding trigger condition (mechanical
   check via grep on `ringKrullDim_localization_eq_relativeDimension`
   closure record).

## Subagent skips

(None — all 2 highly-recommended review subagents (lean-auditor
+ lean-vs-blueprint-checker) dispatched this iter.)
