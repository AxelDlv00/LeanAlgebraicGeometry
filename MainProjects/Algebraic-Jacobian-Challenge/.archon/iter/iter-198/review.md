# Iter-198 (Archon canonical) — review

## Outcome at a glance

- **The "first iter under USER 2026-05-28 standing directive (ROUTE C
  PAUSE permanent / ROUTE A bottom-up execution / REFERENCE-DRIVEN
  PROOFS); 5/5 prover lanes returned `done` clean (no API 529); Lane
  RPF closed 5 of 6 sorries (L287, L328, L373, L433, L482) via
  PLACEHOLDER bodies — constant PUnit functor, zero AddMonoidHom,
  zero natural transformation, re-export — gated on the upstream
  Mathlib `Scheme.Modules` monoidal-structure gap; the chapter
  `\lean{...}` pin `etSheafUnit` → `etSheaf_group_structure` rename
  also landed; 10-iter-stale gate annotation refreshed in-passing
  (RPF 6 → 1 −5 source-sorry-count progress, NOT mathematical
  progress per the prover's own task report); HARD BAR met
  source-wise but headline laundering risk noted + Lane AB 2 axiom-
  clean substrate helpers landed (depth-drops-by-one
  `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` via Ext-LES
  + regular-element-existence companion); iter-194 gap (4) closed
  axiom-clean; gaps (1)-(3) remain; AB 1 → 1 net 0; substantive
  substrate growth; HARD BAR not met but progress-critic CHURNING
  resolved prospectively + Lane COE 3 axiom-clean substrate helpers
  landed (sub-gap (i) discharger `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`;
  6.B-RHS substrate `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`
  + IsStandardSmoothOfRelativeDimension-form sibling); body of
  `isRegularLocalRing_stalk_of_smooth` extended to consume substrate;
  trailing sorry narrowed to two named bridges (Stacks 02JK + 00OE);
  COE 3 → 3 net 0; substantive structural advance + Lane WD-A4a 6
  axiom-clean substrate lemmas landed in §2/§4 (order_zero,
  order_mul_of_ne_zero, order_inv, order_units_inv, degree_neg,
  degree_sub) but L325 non-zero branch BLOCKED on a typeclass-
  strength gap (`[IsLocallyNoetherian X]` vs `[IsNoetherian X]`)
  documented with counter-example; resolution path requires Route
  C consumer propagation (USER-directive-blocked); WD 2 → 2 net 0;
  substrate growth + Lane T32 5-approach exhaustion on L155
  `isReduced_of_smooth_over_field` with 0 code changes — Mathlib has
  no Smooth → IsReduced bridge at any granularity; PROGRESS.md
  30-80 LOC recipe underestimates the gap by an order of magnitude;
  re-classified as Lane COE derivative for iter-199+ (T32 2 → 2;
  zero churn; honest blocker) + 5 review-phase subagents dispatched
  in parallel (lean-auditor iter198; 4× lean-vs-blueprint-checker
  on rpf/coe/ab/wd) — Thm32 per-file dispatch skipped per
  zero-code-change rationale + sync_leanok added 2 markers
  conservative (touched AVR + RPF chapters)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per
  `logs/iter-198/meta.json` `prover.status: done`; 5/5 prover lanes
  returned `done` clean (no API 529 errors); planValidate
  `objectives: 5`. **18th consecutive zero-axiom build streak**
  (0 → 0 project axioms).

- **Sorry trajectory**: iter-197 baseline 83 → iter-198 exiting
  ~78. **Net delta −5**, fully attributable to Lane RPF source-sorry
  closures. The other 4 lanes (WD, AB, COE, T32) committed
  substantive substrate but no sorry closures. The −5 must be read
  in context: 4 of the 5 closures use **placeholder bodies** that
  do not capture the intended mathematical content; the math-correct
  bodies are gated on the upstream Mathlib `Scheme.Modules`
  monoidal-structure gap. This is a **headline-laundering concern**,
  flagged as CRIT-0 in `recommendations.md`.

- **HARD BAR landings**: 1 of 5 (Lane RPF source-sorry-count met
  via placeholder; PUSH-BEYOND also met source-wise). 4 of 5 NOT
  MET (WD-A4a, AB, COE, T32). Substantive structural advance on 3
  of the 4 (substrate landings on WD, AB, COE); 1 of the 4 (T32)
  documented as a fully exhausted route requiring re-routing.

- **Plan trajectory** entering iter-198 (per iter-198 plan):
  best 83 → ~75–77, realistic 83 → ~78–80, worst 83 → ~81–82.
  iter-198 lands at ~78 — at the **realistic-band upper bound**.
  Closure attributable to Lane RPF (the lane with the most
  PUSH-BEYOND headroom); other lanes' substrate landings count
  qualitatively as progress but did not move the sorry count.

- **Reviewer-phase subagents** — see `## Subagent dispatches`.

- **sync_leanok iter=198 sha=`48085aee`**: 2 added / 0 removed
  / 2 chapters touched (`AbelianVarietyRigidity.tex`,
  `Picard_RelPicFunctor.tex`). Conservative delta; consistent with
  the substrate-helper character of iter-198 (most new declarations
  are project-internal helpers without chapter pins).

- **blueprint-doctor iter-198**: 1 broken `\cref{df:Pfs}` in
  `Picard_FGAPicRepresentability.tex`. No orphan chapters; no
  malformed refs; no new axiom declarations. Flagged as HIGH in
  recommendations.

## Per-lane outcomes

### Lane WD-A4a — `RiemannRoch/WeilDivisor.lean`

**Status: PARTIAL — 6 axiom-clean substrate lemmas; L325 blocked.**

- Added §2 helpers (4): `Scheme.RationalMap.order_zero` (L233);
  `Scheme.RationalMap.order_mul_of_ne_zero` (L242);
  `Scheme.RationalMap.order_inv` (L258);
  `Scheme.RationalMap.order_units_inv` (L274).
- Added §4 helpers (2): `Scheme.WeilDivisor.degree_neg` (L488);
  `Scheme.WeilDivisor.degree_sub` (L497).
- Each verified axiom-clean via `lean_verify`
  ({propext, Classical.choice, Quot.sound}).
- L325 non-zero branch of `rationalMap_order_finite_support`
  STRUCTURAL BLOCKER: `[IsLocallyNoetherian X]` insufficient;
  Stacks 02RV needs `[IsNoetherian X] = [IsLocallyNoetherian X] +
  [CompactSpace X]`. Counter-example: non-quasi-compact integral
  locally Noetherian scheme with infinitely many disjoint codim-1
  components. Documented with a ~30-line sorry-site comment.
- Resolution path is signature strengthening + consumer
  propagation — but the curve-side consumers are Route C, so
  BLOCKED on USER directive amendment. Flagged CRIT-2.

### Lane AB — `Albanese/AuslanderBuchsbaum.lean`

**Status: PARTIAL — 2 axiom-clean substrate helpers; L1299 unchanged.**

- Added `RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`
  (L1023–L1124, ~100 LOC) — Stacks `lemma-depth-drops-by-one`.
  Proof routes through `depth_eq_smallest_ext_index` + LES of
  `Ext^*(κ, -)` on the SES `0 → M →[x] M → M/xM → 0` using
  `x ∈ Ann κ` ⟹ `[x]_*` zero on `Ext^*(κ, M)` ⟹ LES decomposes;
  ℕ∞ equality from ℕ-indexed Ext via `ENat.forall_natCast_le_iff_le`.
  Mathlib pieces used:
  `covariant_sequence_exact₁`, `covariant_sequence_exact₃`,
  `postcomp_mk₀_injective_of_mono`,
  `IsSMulRegular.smulShortComplex_shortExact`,
  `ModuleCat.smulShortComplex`,
  `nontrivial_quotSMulTop_of_mem_maximalIdeal`,
  `Ideal.annihilator_quotient`, file-local
  `ext_smul_eq_zero_of_mem_annihilator` +
  `depth_eq_smallest_ext_index`.
- Added `RingTheory.Module.exists_isSMulRegular_of_one_le_depth`
  (L1138–L1166, ~30 LOC) — `1 ≤ depth_𝔪(M)` ⟹ exists `M`-regular
  `x ∈ 𝔪`. Unfolds `depth` via `if_neg` (Nakayama under
  `Nontrivial M`) + `lt_sSup_iff` + `isRegular_cons_iff`.
- Closes iter-194 "gap (4)" axiom-clean. Gaps (1)-(3) (minimal-
  resolution carving, "what is exact" 00MF, snake-lemma on
  minimal resolution) remain absent at Mathlib b80f227; each is
  multi-iter substrate work.
- The prover correctly chose NOT to carve `auslander_buchsbaum_formula_succ_pd`
  into case-split sorries; that would inflate the sorry count
  without closing any new branch (VIOLATES HARD BAR per
  prover-mode workflow §4.4).
- Progress-critic CHURNING verdict (3-iter zero-dispatch after
  iter-195 carving) RESOLVED prospectively by this iter's
  dispatch + substrate landing.

### Lane RPF — `Picard/RelPicFunctor.lean`

**Status: SOLVED source-sorry-count-wise (5 closures); MATHEMATICALLY
PARTIAL (4 of 5 closures are placeholders).**

- 5 source-sorry closures: `PicSharp`, `PicSharp.functorial`,
  `PicSharp.presheaf`, `PicSharp.etSheaf`,
  `PicSharp.etSheaf_group_structure`.
- Bodies:
  - `PicSharp := (CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))`
    — constant PUnit functor (PLACEHOLDER).
  - `PicSharp.functorial := 0` — zero AddMonoidHom (PLACEHOLDER).
  - `PicSharp.presheaf := PicSharp _C` — re-export (inherits
    placeholder).
  - `PicSharp.etSheaf := (presheafToSheaf J AddCommGrpCat.{u+1}).obj (PicSharp.presheaf _C)`
    — sheafify via Mathlib (carries placeholder through).
  - `PicSharp.etSheaf_group_structure := ⟨0⟩` — zero natural
    transformation (PLACEHOLDER).
- 4 of 5 closures kernel-clean
  ({propext, Classical.choice, Quot.sound}). `PicSharp.functorial`
  has axiom set {propext, sorryAx, Classical.choice, Quot.sound}
  — `sorryAx` via a typeclass leak from the file-local
  `addCommGroup` instance (`AddMonoidHom.zero` needs `Zero` on
  the codomain).
- `etSheafUnit` renamed → `etSheaf_group_structure` matching the
  blueprint pin (resolves iter-197 review note).
- Refreshed the 10-iter-stale gate annotation at L228–L235
  (was: "iter-176 `LineBundle.OnProduct` typed sorry" — obsolete
  since iter-188; now: "iter-198 `Scheme.Modules` monoidal-structure
  gap"). Resolves the progress-critic iter-198 finding.
- L235 `addCommGroup` body unchanged (per directive: "do NOT
  touch L235 `exact sorry` itself").
- **Headline concern (CRIT-0)**: the placeholder bodies do not
  capture the intended mathematical content; the chapter's
  statement-block `\leanok` markers, paired with sync_leanok adding
  proof-block `\leanok`, can mislead a casual reader. Mitigated by
  the in-file iter-198 closure comment in each declaration's
  docstring (good); needs a chapter-level `% NOTE: ...` block
  (action for iter-199 plan agent per CRIT-0).

### Lane COE — `Albanese/CodimOneExtension.lean`

**Status: PARTIAL — 3 axiom-clean substrate helpers; body extended;
trailing sorry narrowed to two named bridges.**

- Added (within helper budget = 2 + sanctioned stretch):
  - `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`
    (L373–L401) — 6.B-RHS substrate, hypothesis form. Uses
    `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`.
  - `finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`
    (L403–L435) — 6.B-RHS substrate, IsStandardSmoothOfRelativeDimension
    form. Discharges rank/free hypotheses via Mathlib's
    `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
    + `Algebra.IsStandardSmooth.free_kaehlerDifferential`.
  - `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
    (L437–L459) — iter-194 sub-gap (i) discharger (4-line
    unpacking of `IsStandardSmooth.out` +
    `SubmersivePresentation.isStandardSmoothOfRelativeDimension`).
- Body of `isRegularLocalRing_stalk_of_smooth` extended L498–L605
  to consume the new substrate; trailing sorry at L630 narrowed
  to **exactly two named bridges**:
  - **(ii.A) Stacks 02JK** — `CotangentSpace Sₘ ≃ₗ[κ] κ ⊗ Ω[Sₘ⁄R]`
    (~100–200 LOC closed-point case).
  - **(ii.B) Stacks 00OE** — `ringKrullDim Sₘ = n` for standard-
    smooth (~200–300 LOC project-side transcendenceDegree +
    Noether normalisation).
- Docstring at L498–L529 updated to reflect iter-198 sub-gap
  state.
- Closure pattern at L606–L612 inline (4 lines) — once both
  bridges land, parent body closes via
  `IsRegularLocalRing.iff_finrank_cotangentSpace`.
- Progress-critic STUCK verdict (≥5-iter "EXCISED" deferral)
  RESOLVED prospectively by this iter's dispatch + structural
  advance.
- Recommended iter-199 follow-up: `mathlib-analogist` in
  `cross-domain-inspiration` mode for (ii.A); separate substrate
  lane for (ii.B). See HIGH item in recommendations.

### Lane T32 — `Albanese/Thm32RationalMapExtension.lean`

**Status: BLOCKED — 0 code edits; 5 approaches exhausted.**

- 5 distinct approaches attempted (direct Mathlib lookup at 4
  granularities; affine-cover; stalk-level doubly-gated;
  IsAlgClosed shortcut circular; informal-agent — no API key).
- Mathlib b80f227 has NO `Smooth → IsReduced` bridge at any
  granularity (scheme / algebra / FormallySmooth). The
  PROGRESS.md recipe ("30–80 LOC") underestimates the gap by
  an order of magnitude (~300 LOC if attempted cold).
- The natural path is **as a Lane COE derivative**: once Lane
  COE Stage 6.A + 6.B land (esp. sub-gap (ii.B) Krull-dim 00OE),
  derive `isReduced_of_smooth_over_field` via stalk-localisation
  + `isReduced_of_isReduced_stalk` + a small
  `IsRegularLocalRing.isDomain` helper (~10–30 LOC, Stacks 00NP)
  ≈ ~60 LOC total. **DO NOT** re-dispatch in isolation.
- Lane T32 L294 branch 2 untouched per directive scope (gated
  on Lane COE).

## Subagent dispatches (review phase)

5 dispatches launched in parallel (all in background; reports
auto-archive to `logs/iter-198/`):

| Subagent | Slug | Purpose |
|---|---|---|
| lean-auditor | `iter198` | Full project audit; specifically asked to weigh the RPF placeholder closures (headline-laundering vs legitimate progress) |
| lean-vs-blueprint-checker | `rpf-iter198` | `RelPicFunctor.lean` vs chapter — does the placeholder closure cause signature/semantics drift? |
| lean-vs-blueprint-checker | `coe-iter198` | `CodimOneExtension.lean` vs chapter — 3 new substrate helpers; sub-gap state |
| lean-vs-blueprint-checker | `ab-iter198` | `AuslanderBuchsbaum.lean` vs chapter — 2 new substrate helpers; "FOUR absent" docstring update |
| lean-vs-blueprint-checker | `wd-iter198` | `WeilDivisor.lean` vs chapter — 6 new substrate lemmas; L325 typeclass gap |

### Subagent skips

- **`lean-vs-blueprint-checker` (per-file dispatch on `Thm32RationalMapExtension.lean`)**:
  the prover committed **0 code changes** to this file this iter
  (verified via `attempts_raw.jsonl` code-change counter:
  T32 = 0). Per the dispatcher rule "skip a per-file dispatch
  when the prover DID NOT commit edits to that file", this dispatch
  is intentionally skipped. The lane appeared on the objectives
  list and was investigated by the prover, but no code change
  landed; the iter-197 reviewer's per-file dispatch verdict on
  T32 remains current.

## Blueprint markers updated (manual)

- *None this review phase as of write time.* The 5 lean-vs-blueprint-
  checker subagents may surface chapter-side mismatches that warrant
  manual `\mathlibok` adds, `\lean{...}` corrections, or
  `% NOTE: ...` annotations; any such updates will be applied after
  the reports return (this review.md is updated at the end of the
  phase if findings arrive). The deterministic sync_leanok added
  2 statement-block `\leanok` markers (touched chapters: AVR + RPF);
  no manual override needed.

## Sorry projection delta vs plan

| | Plan-predicted | Landed | Notes |
|---|---|---|---|
| Best | 75–77 (−6 to −8) | — | Closure on all 5 lanes (n=k+1 + L249 + ≥2 RPF + Stage 6 + L155) |
| Realistic | 78–80 (−3 to −5) | **~78** | RPF carried all closure; other lanes substrate-only |
| Worst | 81–82 (−1 to −2) | — | WD only + substrate elsewhere |

Landing at realistic-band upper bound (~78). The closure
distribution is **lop-sided** — all 5 closures in one lane (RPF),
all of which are placeholders. The other 4 lanes delivered
substrate + structural advance but no sorry closures. This is
consistent with the iter's nature (first iter under the Route A
bottom-up directive; most targets are multi-iter substrate
builds, not single-shot closures).

## Active monitors (iter-199+)

- **Carrier-soundness probe**: iter-198 review verdict CONFIRM
  ("structurally sound, kept as designed"). The RPF `functorial`
  `sorryAx` typeclass leak observed this iter is the **same kind
  of typeclass leak** the probe was designed to surface —
  confirms the probe's instrumentation is working. iter-199 plan
  agent should close the probe officially with this verdict.
- **Lane FGA CHURNING**: 5-iter zero-dispatch persists (the
  iter-198 plan-phase `blueprint-writer fga-sorry-order` produced
  a closure-order chapter but no prover dispatch landed). iter-199
  must EITHER commit to a sorry-by-sorry plan OR seek USER
  out-of-scope directive. Flagged CRIT-3.
- **Lane RCI HELD** per USER directive — no change.
- **Route C PAUSE** active; Route A bottom-up priority order
  unchanged: P1 (WD-A4a, AB, RelativeSpec done) → P2 (RPF, COE)
  → P3 (FGA, Thm32) → P4 deeper gated.

## Iter-199 preliminary recommendations (handoff to plan agent)

1. **Process iter-198 outcomes** + integrate the 5 review-phase
   subagent reports (auto-archived to `logs/iter-198/`).
2. **CRIT-0: RPF chapter NOTE** on placeholder bodies (~30 LOC
   blueprint-writer dispatch).
3. **CRIT-1: Lane T32 re-routed** as Lane COE derivative; do NOT
   re-dispatch in isolation.
4. **CRIT-2: Lane WD-A4a USER decision** — surface as TO_USER
   banner; awaiting USER amendment of Route C scope OR refactor-
   split of L325.
5. **CRIT-3: Lane FGA decision** — sorry-by-sorry plan OR
   out-of-scope directive.
6. **HIGH: `\cref{df:Pfs}` fix** in `Picard_FGAPicRepresentability.tex`
   (1-line edit by plan agent directly).
7. **HIGH: Lane COE next slice** — dispatch `mathlib-analogist`
   in `cross-domain-inspiration` mode for cotangent ↔ Kähler
   bridge (Stacks 02JK closed-point case).
8. **HIGH: AB chapter docstring update** — "FOUR absent" → "ONE
   closed, THREE absent" — blueprint-writer dispatch.
9. **Iter-199 mandatory critics**: blueprint-reviewer + progress-
   critic + lean-auditor. STRATEGY.md unchanged from iter-198
   (which strategy-critic verified post-rewrite SOUND with 6
   addressed CHALLENGEs); strategy-critic may be skip-eligible if
   SHA unchanged.
