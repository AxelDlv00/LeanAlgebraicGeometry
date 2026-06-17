# Iter 026 — Plan (Quot-Foundations)

## TL;DR

**First prover iter in the freshly-extracted project** (iter-025 was DAG-wiring; the FBC/QUOT task_results
were the parent's iter-024). I reconciled the live state, then drove the iter's load-bearing call: the QUOT
keystone's blocker `gap1` was hand-wavy, so a **mathlib-analogist** API study collapsed it to a concrete
foundation **G1-core** (section-localization for QC sheaves on `Spec R`, Stacks 01HA) — which is ALSO the
keystone's affine instance, and it exposed a **blueprint circularity I had introduced** (keystone `\uses`
gap1, backwards). I rewrote the QUOT chapter to the honest order **G1-core → gap1 → keystone**, cleared
coverage debt (the 2 iter-024 affine engines), fixed the FBC `inner_value_eq` must-fix (pre-subst route),
and — via the sanctioned same-iter fast-path re-review — cleared the HARD GATE for all three lanes.
**Dispatched 3 parallel import-independent lanes:** FBC `inner_value_eq` (pre-subst), QUOT **G1-core**
(mathlib-build), GR-glue `Grassmannian.scheme` (mathlib-build).

## State at entry (verified live)

- FBC: 3 `inner_eCancel` atoms + Seam B closed axiom-clean (parent iter-024). Live sorries: dead
  `fstar_reindex_legs` @1421, `inner_value_eq` @1627 (literal-form-lock), `gstar_transpose` @1810 (gated),
  affine @1983, FBC-B @2005.
- QUOT: 2 affine engines built axiom-clean; keystone not built (gap1 bottleneck). 4 protected stubs.
- GF: `genericFlatness` @2173 sole sorry, gated on keystone. `genericFlatnessAlgebraic` clean.
- GR/GHS: 0 sorries (charts+transitions+cocycle DONE; glue not started).
- All modules GREEN; one commit (extraction).

## Subagents this iter (5; all returned)

- **progress-critic `iter026`** — FBC **CHURNING** (PARTIAL×4, net sorry +1 over K=4); corrective =
  blueprint expansion (applied BEFORE the verdict as the pre-subst route); *"the dispatch IS the
  corrective"*; escalation = mathlib-analogist if still stuck next iter. QUOT-keystone + GR-glue UNCLEAR.
  Dispatch sanity OK.
- **blueprint-clean `iter026`** — scrubbed iteration/memory leakage from the FBC ordering paragraph + the
  3 new QUOT blocks; validated the Stacks §7 item-(4) quote, added a `% SOURCE QUOTE` for gap1 from
  `stacks-schemes.tex` lemma-quasi-coherent-affine.
- **blueprint-reviewer `iter026`** (whole) — FBC PASS, GR PASS-for-dispatch, QUOT **CONDITIONAL** (gap1
  globalization hand-waved).
- **mathlib-analogist `gap1`** (api-alignment, the QUOT corrective) — gap1 = genuine multi-step descent,
  no Mathlib idiom; all routes funnel through G1-core (Stacks 01HA); gave the concrete 4-step route and
  flagged the circularity. Persistent `analogies/quot-qcoh-affine-globalization.md`.
- **blueprint-reviewer `quot-fastpath`** (scoped, same-iter fast path) — after the rewrite: **HARD GATE
  CLEARS** for a G1-core mathlib-build (0 must-fix; soon-finding = add `\mathlibok` anchors, non-blocking).

## Decision made

### QUOT lane retarget: build G1-core, not the hand-wavy gap1/general keystone
- **Option chosen:** dispatch the QUOT mathlib-build lane at **G1-core**
  (`isLocalizedModule_basicOpen_of_isQuasicoherent`) — the section-localization for QC sheaves on `Spec R`
  — rather than the general keystone or the gap1 `IsIso fromTildeΓ` directly.
- **Why:** the mathlib-analogist established (with a Mathlib `grep` + API map) that gap1 and the general
  keystone BOTH reduce to G1-core, which is the single irreducible Mathlib-absent fact, and that the
  global-`Presentation` route (Route A) is strictly *harder*. G1-core has a concrete 4-step route; gap1 +
  keystone are then cheap glue on top. Building G1-core "pays twice" (GF-G1 ∩ QUOT-annihilator).
- **Trade-off:** G1-core is genuine descent (flat-localization of a finite sheaf-equalizer); mathlib-build
  may hand off a finer decomposition rather than fully close — acceptable per the Mathlib-gradient policy
  (no typed sorry; a precise decomposition is real progress).
- **Reversal signal:** if the prover reports the flat-equalizer step needs Mathlib infra that is itself
  absent (e.g. no usable finite-sheaf-condition-as-equalizer for `SheafOfModules`), pivot to the stalk
  route (Route B) or escalate that sub-gap as the next mathlib-build target.

### FBC CHURNING — corrective honored, NOT a reworded re-dispatch
The progress-critic's CHURNING corrective is **blueprint expansion**, which I applied as the pre-subst
"Order of operations" paragraph (the exact iter-024 checker must-fix), cleared by both reviewers. The
critic explicitly endorses dispatching on it this iter ("the dispatch IS the corrective"). This is the
sanctioned execute-the-corrective response, not another helper round. **Tripwire:** if `inner_value_eq`
is still stuck next iter, the next move is a mathlib-analogist cross-domain consult on the literal-form
lock — recorded so the next planner does not re-dispatch FBC blindly.

### Three lanes (parallelism directive honored)
FBC / QUOT / GR are different files, import-independent. Every QUOT-internal alternative (sectionGradedRing,
annihilator, P2, SNAP) is Mathlib-blocked / gated / protected — verified this iter — so G1-core is QUOT's
only gate-clear forward step; GR-glue is the one fully-unblocked clean lane. This is the honest maximum of
gate-clear parallel work, not a padded count.

## Subagent skips

- strategy-critic: routes are unchanged in substance — my STRATEGY edits are within-route status
  refinements (GR-glue NEXT→ACTIVE; naming gap1/G1-core and the SheafOfModules-tensor-powers gap as
  explicit Mathlib-gradient targets), no route swap / new route / decomposition change. The prior
  (iter-024) verdict was SOUND on all active routes; the one live CHALLENGE (QUOT Serre/S1 canonicity) is
  gated and NOT dispatched this iter (no S1 prover). Re-running would restate the same gated caveat with
  no new signal. The load-bearing strategic question this iter (gap1 tractability) was answered by the
  mathlib-analogist, the correct tool for it.

## Tool substitutions

- `archon-informal-agent.py` is unavailable (no DEEPSEEK/MOONSHOT/OPENROUTER/OPENAI/GEMINI key in env).
  For the gap1 route question I used the **mathlib-analogist** subagent (api-alignment) instead — the
  catalog equivalent for a Mathlib-API/route study — which is strictly better here (it greps live Mathlib
  rather than recalling from training). Recorded per the anti-fabrication substitution rule.

## Notes for iter-027
- If G1-core lands: chain gap1 + general keystone (gap2 transport), add the `\mathlibok` anchors, then
  open GF-G1 (shared-extraction decision first).
- If `gstar_transpose` closes: FBC dead-code refactor, then affine @1983 → FBC-B @2005.
- If `Grassmannian.scheme` lands: `lem:gr_separated` + `lem:gr_proper`.
- SheafOfModules tensor powers remains the SNAP blocker (Mathlib-gradient sub-build, owed).
