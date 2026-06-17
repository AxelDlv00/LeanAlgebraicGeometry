# Iter 039 — Plan (Quot-Foundations)

## TL;DR

iter-038 closed the **GR properness lane** (`Gr(d,r)` proper over ℤ, axiom-clean — E4→E5→E6) and landed the
**QUOT gap1 semilinearity wall** (σ_V + `gammaPullbackImageIso_hom_semilinear`). With those done, this iter
dispatches **2 import-independent prover lanes**, both now GATE-CLEAR per a fresh blueprint-reviewer:

1. **FBC `_legs_conj`** [fine-grained] — the scheduled (iter-038-ramp) conjugate-side prover round: build the
   two NEW frontier atoms conj-2b `reindex_conj_pullbackLeg` + conj-2d `reindex_conj_crossLayer` (neither
   exists in Lean), then attempt the single-`conjugateEquiv`-component reframing that discharges `_legs_conj`
   (sorry @1700) ⟹ `gstar_transpose` closes. **Kill-criterion armed** (see Decision).
2. **QUOT gap1 Hfr** [mathlib-build] — assemble the keystone descent `isLocalizedModule_basicOpen_descent`
   from the now-DONE ingredients (P1 + section transport + σ_V + semilinearity + bridges I/II), instantiate
   the cover-form descent, close gap1 `isIso_fromTildeΓ_of_isQuasicoherent`.

GR gets **no prover** (properness lane closed in-file; GR-quot/repr is a new-file phase needing scaffold +
blueprint, deferred 1–2 iters). No blueprint-writer needed: both target chapters were already complete; only
two small plan edits were owed (flip the σ_V displayed direction to match the built Lean; add the
`existence_chart_kpoint_eq` coverage block).

## Decision made — FBC: execute the conjugate prover round with a kill-criterion (KEEP, but bounded)

- **Option chosen:** dispatch the fine-grained FBC prover on conj-2b + conj-2d + the `_legs_conj` reframing,
  AND arm an explicit kill-criterion. NOT another analogist consult; NOT a pre-emptive refactor.
- **Why:** both critics converge on the prover round as the correct action. progress-critic (FBC STUCK)
  confirms the iter-039 work is **genuine new work** — conj-2b/2d are two non-existent decls and the
  `conjugateEquiv.injective` reframing is a different proof strategy than the iter-037 inline assembly that
  fired the tripwire — and it is the corrective both the iter-038 progress-critic AND analogist named.
  strategy-critic (FBC CHALLENGE) does NOT claim the route is mathematically dead (it certifies the math
  sound and the atoms Mathlib-anchored); it asks for a **kill-criterion** + **evidence** that element-`ext`
  is intractable rather than merely asserted. Both are now in STRATEGY (Q2 / Routes).
- **Reduction, not reformulation (answers the pivot-depth concern):** `_legs_conj`'s obligation is now three
  discrete named atoms — conj-2c PROVED, conj-2b/2d backed by Mathlib anchors verified present
  (`conjugateEquiv_leftAdjointCompIso_inv`, `conjugateEquiv_pullbackComp_inv`, `unit_conjugateEquiv_symm`,
  `conjugateEquiv_comp`). The opaque canonical-map≡iso identity has genuinely been cut down.
- **Element-`ext` evidence (not assertion):** it was *executed* a full iter (iter-035 pivot, `FlatBaseChange
  .lean:2097`) and produced no element-level normal form — the geometric counit/pullback/Γ have no element
  normal form to `ext` against — and was reverted on a strategy-critic inverted-sunk-cost CHALLENGE.
- **LOC/risk:** ~80–150 LOC, fine-grained. The reframing (3) is the heaviest node; conj-2b/2d are
  mechanical-ish (apply named coherences to free legs).
- **Kill-criterion (cheapest reversal signal):** if conj-2b/2d land axiom-clean but the reframing does NOT
  close `_legs_conj` this iter, the reframing is the genuine wall → iter-040 does NOT run another conjugate
  round; escalate via TO_USER.md and open the fallback (element-`ext` reopened with the built conj atoms as
  the change-of-rings dictionary, OR a refactor rebuilding `_legs` from `leftAdjointCompIso` primitives). The
  tripwire SUCCESS bar (route stays on the prover) = conj-2b/2d land compiling even if (3) is left partial.

## Critic dispositions (no silent overrides)

- **blueprint-reviewer `iter039`:** BOTH lanes GATE CLEAR. QuotScheme overturned from iter-038 partial→
  complete+correct (semilinearity targets now `\leanok`; all 9 `\uses` deps of `lem:section_localization_descent`
  `\leanok`). FBC complete+correct (conj-2b/2d Mathlib anchors verified). GR coverage block well-formed. ACCEPTED.
- **progress-critic `iter039`:** QUOT CONVERGING (proceed). FBC STUCK (must-fix) — corrective = prover on
  conj-2b/2d (executing) + kill-criterion (added) + don't open A2 before an api-alignment consult (recorded
  in ramp/Q5). ACCEPTED — the must-fix corrective is exactly this iter's dispatch.
- **strategy-critic `iter039`:** QUOT/GF SOUND. FBC CHALLENGE (must-fix: kill-criterion + element-`ext`
  intractability evidence + reduction-vs-reformulation) — ADDRESSED in STRATEGY Q2/Routes (not rebutted;
  the critic's asks were documentation gaps, now filled). Format DRIFT (must-fix: GR-proper still-active +
  oversized cells) — ADDRESSED (moved to Completed, cells trimmed). GF G3-parallelism note → STRATEGY Q6
  (deferred this iter; FBC+QUOT hold the 2 slots). Byte-size trim still owed (non-blocking).

## Subagent skips

- (none — all three highly-recommended critics dispatched: blueprint-reviewer, progress-critic, strategy-critic.)

## Plan edits (blueprint, this iter)

- `Picard_QuotScheme.tex` — flipped the displayed `σ_V` to source→image `Γ(O_U,V) → Γ(O_Y,j''V)` matching the
  built `gammaImageRingEquiv` (load-bearing for bridge (I)/semilinearity); cleaned the resolved direction NOTE.
- `Picard_GrassmannianCells.tex` — added coverage block `lem:gr_existence_chart_kpoint_eq` (pins the public
  helper `existence_chart_kpoint_eq`), wired into `lem:gr_existence_lift`'s `\uses`. (The other 11 coverage-debt
  decls are all `private` impl helpers — they leave the unmatched scan on sync; no blueprint block owed.)

## Coverage-debt status

Public unmatched cleared: `existence_chart_kpoint_eq` (GR) now has `lem:gr_existence_chart_kpoint_eq`. The
remaining leandag-listed unmatched (`det_one_updateCol`, `rotMid`, `transitionInv*`, `liftToBaseOfMemRange`,
`algebraMap_comp_liftToBaseOfMemRange`, `descent_*`, `res_comp`, `iSup_basicOpen_subtype_eq_top`,
`isIso_unitToPushforwardObjUnit_of_isIso'`) are ALL `private` — sanctioned implementation details that leave
the scan on the next leandag sync; no blueprint blocks owed.
