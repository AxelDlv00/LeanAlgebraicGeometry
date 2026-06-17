# Iter 028 — Plan (Quot-Foundations)

## TL;DR

First plan phase processing the **iter-026 prover round** (iter-027 was dag-only). Three lanes returned
real progress: FBC broke its 4-iter literal-form lock (`erw`), QUOT wired the entire `G1-core ⟹ gap1 ⟹
keystone` glue axiom-clean (only G1-core descent remains), GR built the 11-decl transition layer + linchpin
pullback iso. I drove three correctives and re-dispatch the same three import-independent lanes:

1. **progress-critic flagged FBC CHURNING** (mechanical: PARTIAL×4, 1 sorry in 4 iters, OVER_BUDGET) — its
   named corrective is **blueprint expansion**. Executed: a blueprint-writer (`fbc-reroute`) reconciled the
   Seam-A routing narrative — the chapter had it BACKWARDS (claimed inline-through-atoms, labelled `_legs`
   "superseded/dead-code"), but the iter-026 prover proved the inline route WALLED and the live route runs
   THROUGH `_legs`. Extracted the residual ~100-LOC telescoping into one named target
   `lem:base_change_mate_inner_eCancel_assemble`.
2. **mathlib-analogist found a shorter G1-core route (Route F, not E).** Realise G1-core as the module
   analogue of Mathlib's `isLocalization_basicOpen_of_qcqs` — a 3-field `IsLocalizedModule` constructor via
   `compact_open_induction_on` + sheaf gluing, **no equalizer object, no flat-descent chaining**. A
   blueprint-writer (`quot-routef`) rewrote the G1-core proof + added the 4 coverage-debt nodes + 12
   `\mathlibok` anchors.
3. **GR coverage debt + glued-scheme prover-readiness.** A blueprint-writer (`gr-glue`) blocked the 11 new
   helpers + expanded `def:gr_glued_scheme` with the `Scheme.GlueData` field map.

Cleared coverage debt (15 unmatched `lean_aux` → ~0). strategy-critic SOUND (all 4 iter-024 challenges
addressed). blueprint-clean + blueprint-reviewer gate the three chapters before dispatch.

## State at entry (verified from iter-026 task_results + leandag)

- **FBC** 5 sorries (dead-but-now-live `_legs` @1413, `inner_value_eq` @1646, `gstar_transpose` @1829,
  affine @2002, FBC-B @2024). Seams B/C closed; the 3 eCancel atoms proved. iter-026: literal-form lock
  broken via `erw` (`_legs` unit expansion fires); residual = the `_legs` cancellation assembly.
- **QUOT** 4 sorries (protected stubs). iter-026: +5 axiom-clean glue decls; keystone obligation = exactly
  G1-core. `isLocalizedModule_tilde_restrict` + `..._restrict_of_isIso_fromTildeΓ` already present.
- **GR** 0 sorries. iter-026: +11 axiom-clean decls (7 GlueData easy fields + `awayPullbackIso`(+2 legs) +
  `awayMulCommEquiv` orderSwap). GlueData itself (`t'/t_fac/cocycle/.glued`) not yet built.
- **GF** 1 sorry (geo @2173, gated on the keystone = G1-core).
- Coverage debt: 15 unmatched `lean_aux` (11 GR + 4 QUOT).

## Subagents this iter (7; all returned)

- **progress-critic `iter028`** — FBC **CHURNING** (must-fix; corrective = blueprint expansion; also
  OVER_BUDGET, FBC-A entered iter-018 est 2–4, 10 elapsed). QUOT **UNCLEAR** (2 data pts; infra accelerating;
  analogist-first is the right move). GR **UNCLEAR** (1 GR-glue iter; volume task; flag at iter-030 if
  t_fac/t_id not landed). Dispatch sanity OK (3 files).
- **mathlib-analogist `g1core-descent`** (api-alignment) — **ALIGN_WITH_MATHLIB: Route F**, the module
  analogue of `isLocalization_basicOpen_of_qcqs` (3-field constructor; no equalizer; no flat-descent).
  Confirmed: no direct `IsQuasicoherent → IsIso fromTildeΓ`; no `QuasicoherentData → finite cover` helper
  (step 1 is the irreducible manual core, shared E/F); no one-step "flat localizes a finite module
  equalizer" (argues against E). Persistent `analogies/g1core-affine-descent.md`.
- **strategy-critic `iter028`** — **SOUND**, no CHALLENGE/REJECT. All 4 iter-024 challenges ADDRESSED
  (GF-geo re-est, G1/G3 named, `[IsIntegral S]` required, Serre/S1 gated-not-active). Minor format DRIFT
  (2.3KB over budget + bare-iter phrases in active table) → trimmed two rows.
- **blueprint-writer `gr-glue`** — 11 helper blocks + 4 `\mathlibok` anchors + prover-ready
  `def:gr_glued_scheme`. Coverage debt 11→4 (GR cleared). leandag 0 unknown_uses.
- **blueprint-writer `quot-routef`** — G1-core rewritten to Route F; 4 coverage-debt nodes + gap1 rewire
  (NOT re-pointed, per lvb) + 12 `\mathlibok` anchors. Coverage debt 4→0 (QUOT cleared). Name correction:
  the Mathlib presentation lemma is `AlgebraicGeometry.isIso_fromTildeΓ_of_presentation` (no `Modules.`).
- **blueprint-writer `fbc-reroute`** — Seam-A routing reconciled; `_legs`/`fstar_reindex` un-superseded;
  new single target `lem:base_change_mate_inner_eCancel_assemble`; `inner_value_eq \uses fstar_reindex`.
- **blueprint-clean `iter028`** — stripped Lean leakage + 5 `% LEAN SIGNATURE` blocks + tactic commentary
  from the FBC reroute; QUOT/GR confirmed clean.
- **blueprint-reviewer `iter028`** (whole) — gate the three edited chapters (pending; see disposition).

## Decision made

### FBC CHURNING response — blueprint reroute, NOT a reworded re-dispatch
- **Corrective taken:** dispatched `blueprint-writer fbc-reroute` to fix the chapter's falsified Seam-A
  routing (inline-through-atoms was the documented route; the prover proved it walled; the live route is
  via `_legs`). Extracted the residual telescoping into one named closeable target
  `lem:base_change_mate_inner_eCancel_assemble`. This is a structural blueprint edit — the exact corrective
  the critic named — not another helper round on the same recipe.
- **Why not pivot the route:** the critic explicitly notes the iter-026 `erw` advance is a genuine
  structural advance (not discarded-helper churn); CHURNING fired on the mechanical PARTIAL×4 rule. The
  route is sound and now one named target from closing. Pivoting would discard a live, de-risked path.
- **Reversal signal:** if `inner_eCancel_assemble` does not close next iter (the assembly stalls on the
  codomain-read unfold / atom-cancellation), escalate to a mathlib-analogist cross-domain consult on the
  telescoping — do NOT re-dispatch the same lane a third time.

### QUOT G1-core — Route F over Route E
- **Option chosen:** build G1-core as the module analogue of `isLocalization_basicOpen_of_qcqs` (Route F),
  NOT the explicit finite-equalizer + flat-descent (Route E).
- **Why:** the analogist established Route E reinvents a flat-descent of a finite module limit that
  Mathlib's own qcqs proof was written to avoid, and that NO single Mathlib lemma localizes a finite module
  equalizer (the costly step). Route F sheds the equalizer object + the unit-ideal obligation, reusing the
  generic sheaf-gluing Mayer–Vietoris that holds for any concrete sheaf.
- **Trade-off:** both routes share step 1 (finite basic-open tilde cover from `QuasicoherentData`) — the
  irreducible manual core and the prover's first target. Route F is strictly cheaper above step 1.
- **Reversal signal:** if the `compact_open_induction_on` module-Mayer–Vietoris step proves harder to port
  than the equalizer chase (unlikely per the analogist), reconsider — but step 1 is shared, so no work is
  wasted either way.

## Stale .lean comments (lean-auditor iter-026, prover-domain riders)
The lean-auditor flagged 3 FBC stale/false-completion comments (235–247 claim `pushforward_spec_tilde_iso`
has an open QC obligation — it's proved; 1575–1577 docstring claims `inner_value_eq` is inline-proved — it
ends in sorry; 1848–1852/1917–1919 misleading sorry attribution). The plan agent cannot edit `.lean`; these
ride onto the FBC prover objective as a cleanup task.

## Blueprint-reviewer gate result + unstarted-phase proposal dispositions

**Gate:** all three edited chapters returned **complete: yes / correct: yes**, zero must-fix — all three
lanes (FBC `inner_eCancel_assemble`, QUOT Route-F G1-core, GR GlueData) cleared for dispatch THIS iter.
leandag: 0 isolated, 0 unknown uses, 0 broken refs, 0 axioms; coverage debt cleared.

**Unstarted-phase proposals (acted on — both deferred with rationale):**
- **Proposal A (FBC-B chapter "higher cohomology"): DEFERRED — out of scope as framed.** The project leg
  is **Čech-independent, i=0 only** (STRATEGY Goal). The reviewer's "higher cohomology / Čech-to-cohomology
  spectral sequence" framing is for i>0, which is NOT in this cone. The actual FBC-B (i=0 globalization /
  H⁰-as-equalizer) is ALREADY blueprinted inside `Cohomology_FlatBaseChange.tex` (the `affineBaseChange…`
  @2002 + `flatBaseChange…` @2024 blocks with proof sketches). No new chapter needed; no coverage hole.
- **Proposal B (SNAP-S1/S3 Snapper chapter): DEFERRED — genuinely gated.** Per STRATEGY Open questions,
  SNAP-S1 must FIRST resolve the Serre `m≫0` canonicity question (the "Hartshorne II.5.17" attribution is
  flagged likely-wrong and owes a reference read) AND the Mathlib sheaf-tensor-powers gap
  (`def:sectionGradedRing` blocked). Authoring the chapter now would hard-code an undecided route. The
  strategy-critic confirmed this is correctly handled as gated-not-active. Revisit when QUOT-defs keystone
  lands and the Serre question is settled.

## Post-review coverage-integrity fix (planner spot-check caught a reviewer miss)
A final `leandag stats` spot-check showed **7 isolated blueprint nodes** — the Route-F `\mathlibok` anchors
the `quot-routef` writer added — despite the blueprint-reviewer reporting "0 isolated" (it read a stale
`dag.json`). Root cause: leandag builds edges from **statement-level `\uses` only**, and the writer wired
the 7 anchors only in G1-core's PROOF `\uses`. Fixed directly (planner blueprint remit): added the 7
anchors to `lem:qcoh_affine_section_localization`'s statement `\uses`, then `leandag build` → **0 isolated,
0 lean-aux, 0 ∞-effort, 0 unknown uses**. Recorded as memory `leandag-statement-uses-only` (durable gotcha
for future writer rounds; also: don't fully trust subagent leandag numbers — spot-check after anchor-adding
writer rounds).

## Subagent skips
- (none — all three [HIGHLY RECOMMENDED] critics dispatched: progress-critic, strategy-critic, blueprint-reviewer.)
