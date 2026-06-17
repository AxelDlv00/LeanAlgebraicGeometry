# Iter 039 — Review (Quot-Foundations)

## Verdict
Build GREEN — both prover-touched modules (`FlatBaseChange.lean`, `QuotScheme.lean`) `lake build`
exit 0 (8317 jobs each; pre-existing protected scaffold `sorry` + style/deprecation/maxHeartbeats
warnings only). All 5 new decls `lean_verify` = `{propext, Classical.choice, Quot.sound}`.
blueprint-doctor: **0 findings**. `sync_leanok` (iter 39, sha `780828a`): **+4 `\leanok`, 0 removed**
(Cohomology_FlatBaseChange, Picard_GrassmannianCells). leandag `gaps=0`, `unmatched=15`.

**0-net-sorry, +5-axiom-clean-decl infrastructure iter (FBC 4→4, QUOT 4→4 stubs, GR 0, GF 1).
Both lanes advanced their named ingredients; NEITHER closed its keystone. The FBC kill-criterion
armed by the iter-039 planner has FIRED — conj-2b/2d landed but the reframing did not close
`_legs_conj` — so iter-040 must pivot off the conjugate route to the fallback. QUOT landed every
algebra/category feeder (progress-critic CONVERGING); only the geometric Hfr producer remains.**

## Overall progress this iter (active `sorry` per file)
- **FBC 4 → 4 (conj-2b + conj-2d LANDED; reframing keystone BLOCKED — KILL-CRITERION FIRED).**
  +2 axiom-clean decls: `base_change_mate_reindex_conj_pullbackLeg` (conj-2b, one-liner via
  `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` once generalized to free legs `f g`) and
  `base_change_mate_reindex_conj_crossLayer` (conj-2d, the ring-map-general port of Seam-1's
  `base_change_mate_unit_value`; `erw [reassoc_of% huce]` + simp under 4M heartbeats, controlled
  `rfl` at `hpullinv`). `base_change_mate_fstar_reindex_legs_conj` (sorry @1822) UNCHANGED — the
  single-`conjugateEquiv`-component reframing did not close. All three legs (conj-2b/2c/2d) now in
  hand ⟹ a **pure reframing obstruction, no missing ingredient**. Third consecutive iter the node
  resisted; per the armed kill-criterion, iter-040 does NOT run another conjugate round.
- **QUOT 4 → 4 stubs (all gap1 algebra/category FEEDERS landed; geometric Hfr producer remains).**
  +3 axiom-clean non-private decls: `isLocalizedModule_powers_transport` (combined bridge I+II),
  `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` (the instantiable basic-open form; the
  general-U `_of_cover` form is a recorded unprovable trap), `isIso_fromTildeΓ_of_iso` (iso-invariance
  via `isIso_fromTildeΓ_iff` + `essImage.ofIso`). `descent_surj` signature gained an
  `(∃ s, U = basicOpen s)` precondition, both call sites updated. The named keystone descent + gap1
  were NOT attempted — only the slice→`Spec R_r` geometric section-transport producer remains.
  progress-critic CONVERGING.
- **GR 0 (untouched — properness lane closed iter-038).** GR-quot/repr is a new-file phase
  (scaffold + blueprint), deferred.
- **GF 1 (untouched), gated on gap1.**

## Strategic state — the FBC fork
The conjugate route is NOT mathematically dead (math certified sound by the iter-039 strategy-critic;
both atoms Mathlib-anchored). What is exhausted is the **conjugate-component reframing idiom**. The
planner's armed cheapest-reversal-signal resolves the fork deterministically: iter-040 opens the
fallback — element-`ext` reopened with the now-built conj-2b/2c/2d as the change-of-rings dictionary
(the missing dictionary that sank iter-035), OR a refactor rebuilding `_legs` from `leftAdjointCompIso`
primitives. Recommend an api-alignment analogist consult ("section composite ↔ single conjugateEquiv
value" typing) to pick A vs B before committing. See `recommendations.md §0`.

## Critic / auditor dispositions (this review phase)
- **lean-auditor `iter039`** (both files): 0 critical / 0 major / 3 minor. All 5 new decls honest +
  axiom-clean; `descent_surj` change coherent; all FBC sorries carry honest roadmap comments (the
  `gstar_transpose` scaffold correctly warns against citing the sorry-backed
  `base_change_mate_fstar_reindex`). Minor: missing heartbeat comment on `crossLayer`; stale inherited
  `iter-NNN` numbering. → recommendations §3.
- **lean-vs-blueprint-checker `fbc039`**: 1 major — stale `% NOTE` (iter-036) claiming "conj-2b/2d not
  typed in Lean," false post-iter-039. **FIXED this review.** Minor: `_legs_conj` sketch doesn't pin the
  concrete `adjL`/`adjR` for the reframing (superseded by the fallback pivot). → recommendations §2/§3.
- **lean-vs-blueprint-checker `quot039`**: 0 red flags; major coverage debt (3 new public decls
  unblueprinted). → recommendations §1.

## Blueprint markers updated (manual, this review)
- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_fstar_reindex_legs_conj`: rewrote the stale
  iter-036 `% NOTE` to the current iter-039 state (conj-2b/2d built axiom-clean; reframing keystone
  alone remains; kill-criterion fired; fallback path A/B).

## Coverage debt (for planner)
3 new public QUOT decls unmatched (recommendations §1). 12 remaining unmatched nodes are all `private`
impl helpers — sanctioned, no blueprint owed.
