# Iter 036 — Review (Quot-Foundations)

## Verdict
Build GREEN — all three prover-touched modules (`FlatBaseChange.lean`, `GrassmannianCells.lean`,
`QuotScheme.lean`) `lake build` exit 0 (pre-existing `sorry` + linter long-line/deprecation/
maxHeartbeats warnings only; GrassmannianCells & QuotScheme 8317 jobs). New decls `lean_verify` =
`{propext, Classical.choice, Quot.sound}` (provers + lean-auditor). blueprint-doctor: **0 findings**.
`sync_leanok` (iter 36, sha `0b6513b`): **+24 `\leanok`, 0 removed** (chapters: FlatBaseChange /
GrassmannianCells / QuotScheme). leandag `gaps=0`, `unmatched=13` (coverage debt).

**+7-axiom-clean-decl infrastructure iter: net 0 active sorry (FBC 4→4, QUOT 4→4 stubs, GR 0→0,
GF 1 untouched).** Each of the three lanes hit its assigned objective; the two hard residuals
(FBC gstar steps a/c, QUOT Hfr chaining) are precisely characterized with named Mathlib-absent
blockers. The FBC iter-035 explicit-inverse pivot was **reverted** by the planner and FBC-A resumed
the conjugate-`huce` route — landing step (b) met the iter-036 tripwire SUCCESS condition, so the
route is NOT escalated.

## Overall progress this iter (active `sorry` per file)
- **FBC-A 4 → 4 (step (b) of gstar_transpose LANDED).** `base_change_mate_extendScalars_inner_value_counit`
  axiom-clean (the cleanest of the three decomposed steps): `ext x` → `ExtendScalars.map'` →
  `Counit.map_apply_one_tmul` reduces the LHS to the bare affine inner value `ρ(x)`, then
  `exact congrArg _ rfl` (defeq) closes `ρ(x) = regroupEquiv.inv (1⊗x)`. `gstar_transpose`@2167 sorry
  unchanged (steps (a) inline reindex + (c) dictionary cancellation remain; the `huce` master identity
  is landed and ready). conj-2a@1700 now **off the critical path** (the reverted pivot targeted it).
- **GR 0 → 0 (E1/E2/E3-core LANDED; E3-full blocked).** `existence_chart_factorization` (E1, route per
  blueprint via `IsOpenImmersion.lift`/`Spec.preimage`), `existence_minimal_valuation` (E2,
  `Finite.exists_max` on `ValuationRing.valuation`), `existence_lift_transitionPreMap_minorDet_mul`
  (E3 ratio core, `IsLocalization.Away.lift` of the ring identity). All axiom-clean. E3-full
  (`existence_factor_through_valuationRing`) blocked on the **blueprint-flagged** cofactor-expansion
  matrix gap (`det (1.updateColumn p (X q)) = ±(X q) p` — no Mathlib scaffold). E4/E5 gated on E3.
- **QUOT 4 → 4 stubs (lane objective COMPLETE; Hfr blocked).** `gammaPullbackTopIso` (pinned
  `lem:pullback_gamma_top_iso`) + `gammaPullbackImageIso` (general-in-`U`) +
  `gammaPullbackImageIso_hom_naturality`, all axiom-clean via `Functor.mapIso` of the
  `restrictFunctorIsoPullback` component (sidestepping a `IsIso (φ.app U)` synthesis failure). The
  downstream Hfr/named-descent/gap1 are **NOT one-liners** (blueprint NOTE corrected this review): two
  Mathlib-absent ingredients remain — (I) ring-iso-semilinear `IsLocalizedModule` transport, (II)
  base-change-of-localization `R→R_r`.
- **GF 1 (untouched), gated on gap1.**

## Critic / auditor dispositions (all dispatched this review phase)
- **lean-auditor `iter036`** (3 files): 4 must-fix / 3 major / 3 minor. The 4 must-fix are the
  **pre-existing iter-176 protected scaffold stubs** in QuotScheme (`hilbertPolynomial`/`QuotFunctor`/
  `Grassmannian`/`Grassmannian.representable` `:= sorry`) — frozen-signature skeletons, not new dead
  code. All 7 new decls confirmed honest + axiom-clean; FBC's 4 sorries characterized (2 off critical
  path). → recommendations §3.
- **lean-vs-blueprint-checker ×3** (all prover-touched): `fbc` **0 must-fix** (NOTE accurate, step-b
  prose matches Lean); `gr` **0 must-fix**, 1 major (E3 ratio-core coverage debt), 9 private-pin minor
  (cosmetic, `sync_leanok` accepted); `quot` **1 must-fix** (over-optimistic "one-liner" NOTEs —
  FIXED this review) + 2 major (missing pins for `gammaPullbackImageIso`/`_hom_naturality`). →
  recommendations §1/§2.

## Blueprint markers updated (manual, this review)
- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_fstar_reindex_legs_conj`: stale `% NOTE`
  ("iter-035 tripwire fired … iter-036 executes the explicit-inverse pivot") → corrected to "pivot
  reverted; FBC-A resumed conjugate-`huce` and landed step (b); conj-2a now off the critical path".
- `Picard_QuotScheme.tex`, `lem:pullback_gamma_top_iso`: `% NOTE` ("decl does NOT yet exist … both
  one-liners once it lands") → "LANDED axiom-clean; CORRECTION: NOT one-liners — two Mathlib-absent
  ingredients (I)+(II) remain".
- `Picard_QuotScheme.tex`, `lem:section_localization_descent`: added `% NOTE (iter-036, review)`
  correcting the "both one-liners" claim; named the two remaining ingredients.
- No `\leanok` touched; no `\mathlibok` added (new decls are bespoke project infra).

## What shaped iter-037 (live frontiers)
1. **FBC: prove steps (a)+(c), stay conjugate-`huce`.** Build the inline `Γ_R(θ_in)=ρ` reproof from
   the proved standalone inputs, then the dictionary cancellation against the landed `huce`, then plug
   step (b) to close `gstar_transpose`. NOT element-ext (reverted), NOT conj-2a (pruning debt).
2. **QUOT: build ingredients (I)+(II) as standalone steps.** Recommend a mathlib-analogist
   (api-alignment) consult on ring-iso-semilinear `IsLocalizedModule` transport before bespoke build.
   Do not re-task Hfr/descent/gap1 as a trivial chain.
3. **GR: build the column-substituted-identity determinant helper, then E3-full.** Scout
   `Matrix.det_updateColumn_*`/`updateColumn`/`det_succ_column`/`cramer`.
4. **Coverage debt:** blueprint the 4 net-new helpers (2 QUOT, 1 GR, 1 FBC); note that marking helpers
   `private` does NOT remove them from `dag-query unmatched`.
