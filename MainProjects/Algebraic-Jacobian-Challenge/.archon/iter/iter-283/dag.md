# DAG iter-283 narrative

## Headline: NOT a no-change iter. Broke the 5-iter "no-change" streak by empirically testing the one persistently-deferred item (the blueprint-doctor's "blocks the build" claim) and discovering the real cause of the long-standing `leanblueprint web` crash: SEVEN genuine circular `\uses` dependency cycles in the proof-edge graph — NOT the 127 flagged malformed_refs. Fixed all 7 (each verified against the actual Lean definitional order); `leanblueprint web` now builds EXIT 0 and regenerates `dep_graph_document.html`. `leandag` clean (878 nodes, 1490→1484 edges, still acyclic, 0 broken refs).

## Why this iter diverged from the 278–282 no-change pattern

iters 278–282 treated the 127 doctor `malformed_refs` as "100% out of scope" (protected
/ paused chapters) and never verified the doctor's headline claim that they *block the
build*. This iter I tested it directly:

1. **`leanblueprint web` DOES crash** — `RecursionError` in `plastexdepgraph`'s recursive
   `ancestors()`.
2. **It is a TRUE cycle, not a depth overflow** — re-running with
   `sys.setrecursionlimit(400000)` + a 2 GB thread stack still overflows. (A deep-but-
   acyclic graph would have completed; `leandag` already proves the statement-`\uses`
   graph is finite/acyclic.)
3. **The cycles live in the PROOF-edge graph** — `leandag` builds from statement-`\uses`
   only (acyclic ✓); `plastexdepgraph` also includes proof-`\uses` + `\proves` edges,
   where the cycles hide. This is exactly why 5 prior iters + every prior blueprint-reviewer
   (which uses `leandag`) missed them, and why no one caught it: **a clean `leandag build`
   does NOT imply `leanblueprint web` builds.**
4. **The doctor's diagnosis was wrong about the cause.** The 127 `literal-ref`/`math-delim`
   are cosmetic — the build now succeeds with all 127 still present. The crash was the 7
   cycles, which the doctor did NOT flag.

## What I did — detection + 7 Lean-verified edge cuts

Detection recipe (reusable, recorded in memory `ts283-leanblueprint-web-cycle-crash`):
monkeypatch `DepGraph.ancestors` with a DFS cycle-detector over `predecessors`
(white/grey/black), print the grey back-edge, abort; fix one, re-run, repeat until
"NO CYCLE DETECTED". Seven rounds:

1. `Albanese_AuslanderBuchsbaum` — `lem:auslander_buchsbaum_formula_succ_pd` statement
   dropped `thm:auslander_buchsbaum`. The inductive-step lemma takes "AB formula for
   pd≤k" as a HYPOTHESIS (induction hyp), not a dependency on the full theorem; the
   theorem's proof uses this lemma (thm→lem is the only genuine direction). Verified:
   lemma proof-`\uses` (L445) already omits the theorem.
2 & 3. `Picard_FGAPicRepresentability` — `def:pic_scheme` `\uses` reduced to
   `{def:has_pic_scheme}` only (removed BOTH `thm:pic_is_group_scheme` and
   `thm:fga_pic_representability`). Verified against Lean L223:
   `PicScheme := (HasPicScheme.has_pic_scheme C).choose` — the bare scheme depends ONLY
   on the `HasPicScheme` carrier; the group-scheme structure (`PicSchemeGroupObject` →
   `groupSchemeStructure`) and the representability identification (`representable`,
   extracted from `PicSharpRepresentable` whose statement references `PicScheme`) are
   both layered ON TOP. Also corrected the inaccurate Lean-encoding prose bullet
   (claimed extraction "from RepresentableBy produced by representable"). One edit
   killed two cycles.
4. `Picard_RelativeSpec` — `thm:relative_spec_univ` statement dropped
   `thm:relative_spec_base_change`. Verified against Lean L264: `UniversalProperty`'s
   body is pure affine-gluing (`isAffineHom_of_forall_exists_isAffineOpen` /
   `relativeGluingData`), never references `base_change`; `base_change` (L679) is the
   downstream corollary that uses `UniversalProperty`.
5. `Picard_QuotScheme` — `def:pullback_app_isoTensor_sigma` `\uses` swapped
   `def:quot_pullback_app_isoTensor` → `def:quot_pullback_app_isoTensor_baseMap`.
   Verified against Lean L867: `...baseMap_sectionLinearEquiv` is built from
   `tildeIso_of_isQuasicoherent_isAffineOpen`/`pullback_tildeIso` and its statement
   references `pullback_app_isoTensor_baseMap`, NOT the high-level final iso (which is
   built FROM this Σ-pair). A naming confusion (baseMap vs final iso).
6. `Picard_SheafOverEquivalence` — `def:over_equiv_inverse_is_continuous` dropped its
   ONLY `\uses` entry `def:sheafofmodules_over_equivalence` (the `\uses` annotation was
   removed entirely, not left empty — an empty `\uses{}` is itself malformed). Verified
   against Lean L105: `overEquivInverseIsContinuous` is a property of the SITE
   equivalence's inverse functor (`(Opens.overEquivalence U).inverse.IsContinuous`,
   closed by `infer_instance`) — a PREREQUISITE that `pushforwardPushforwardEquivalence`
   demands to build the modules-level equivalence, not a consequence.
7. `Cohomology_CechHigherDirectImage` — `lem:push_pull_functor` `\uses` dropped
   `def:cech_nerve`. Verified against Lean L216/278: `pushPullMap_id`/`pushPullMap_comp`
   signatures never mention `CechNerve`; `CechNerve` (L89) is built FROM the push-pull
   functor (cech_nerve→push_pull_functor is the genuine direction).

Each edited block carries an inline `% NOTE iter-283:` documenting the cut + the Lean
line. All removed/changed labels still exist (no broken refs introduced); the one
re-pointed edge (`def:quot_pullback_app_isoTensor_baseMap`) is a real label. Net edges
1490→1484 (six spurious edges removed; cut #5 was a relabel, net 0 there).

## Verification

- `python3 /tmp/findcycle.py` → **NO CYCLE DETECTED — graph is acyclic.**
- `leanblueprint web` → **EXIT 0**, all 38 chapter HTMLs + `dep_graph_document.html`
  (1.6 MB) regenerated.
- `leandag build` → clean: 878 blueprint nodes (443 proved, 1 mathlib), 54 lean-aux,
  1484 edges, 2 ∞-effort (unchanged), 0 broken `\uses{}`.
- No empty `\uses{}` introduced (grep-confirmed; the one apparent match is text inside a
  `% NOTE` comment).

## Scope discipline

- The 127 `malformed_refs` (literal-ref / math-delim) remain UNTOUCHED — confirmed
  cosmetic (build succeeds with them present) and all in protected (`Jacobian`,
  `AbelJacobi`) or permanently-USER-paused Route-C (`RiemannRoch_*`) chapters. Correct to
  defer per governance; I corrected the *record* (DAG_STATUS) that they "block the build".
- The A.1.c.sub prover-lane chapter (`Picard_TensorObjSubstrate.tex`) and its 54
  lean-aux were NOT touched; the criterion-5 deferral stands unchanged.
- Did NOT commit (following the established pattern — iters 278–279 rendering work is
  also uncommitted; the loop accumulates blueprint edits).

## Subagent skips

- strategy-critic: STRATEGY.md mtime unchanged (06-04 19:46, predates iter-280) and prior
  verdict (iter-272, carried clean 273–282) was SOUND with no live CHALLENGE/REJECT. My
  edits are `\uses` dependency-correctness fixes that do not alter any route or strategic
  claim, so no re-verification is warranted.
- blueprint-writer: not dispatched up front — my edits were surgical corrections, not
  gap-fills, and no chapter was flagged incomplete. Will dispatch one only if the
  blueprint-reviewer (dispatched this iter) flags a must-fix.

## blueprint-reviewer (cyclefix283) — HARD GATE CLEARS, no findings

Whole-blueprint audit (38 chapters) returned **`complete: true` + `correct: true` for all
38**, zero must-fix, zero unstarted-phase proposals. Crucially it **independently verified
all six iter-283 `\uses` corrections are accurate AND complete** — "no genuine dependency
edge was wrongly removed and the corrected sets contain no missing edges." Confirmed
acyclic (`leanblueprint web` EXIT 0; `leandag` 0 conflicts / 0 unknown_uses / 0 broken_refs
/ 0 orphan chapters / 0 new axioms). The 127 `malformed_refs` (protected/Route-C-paused)
and 54 isolated `lean_aux` are pre-known/out-of-scope. One informational `unmatched_lean`
(`lem:push_pull_functor` / `pushPullMap_comp`, iter-264-documented — the Lean decl is still
a deferred in-file comment, not a `sorry` stub) gates nothing. **No follow-up writer
dispatched** (nothing flagged). Report:
`.archon/logs/iter-283/blueprint-reviewer-cyclefix283-report.md`.
