# Iter 015 — Review (Quot-Foundations)

## Verdict

Build GREEN (re-verified: `lake build` of all 3 modified modules → EXIT 0). **3-lane dispatch, 0
sorries closed, net +1 sorry.** This is a low-closure iter — but not an empty one: QUOT landed 3
axiom-clean graded-API decls (D5 + both G1 halves), FBC landed the Seam-2 leg-identification scaffold,
GF factored its wall into a clean (sorry'd) descent helper. Two of the three lanes stalled against
**genuine, now-documented walls**, not proof-search failure: QUOT hit a Mathlib `isDefEq/whnf`
elaborator runaway over the subtype/quotient `DirectSum.IsInternal`, and GF re-accreted a helper
(CHURNING). No deception — lean-auditor + 3 per-file checkers found no fake statements, no `axiom`s,
all new proofs axiom-clean.

## Overall progress this iter (active sorry per file)

- **FBC 4→4** — Seam 2 `base_change_mate_fstar_reindex` scaffold landed (`pullbackSpecIso` legs +
  `Γ`-image split), sorry remains; Seam 3 not reached. The conjugate-calculus coherence (Seam-1's
  iter-014 idiom family) is the gap, and the blueprint omits it (lvb-fbc must-fix).
- **GF 4→5** (+1) — new `free_localizationAway_of_away_tower` descent helper (sorry, detailed plan);
  L5 now routes through it. **CHURNING** signature: +1 helper, 0 closed. The doubly-localised type
  `(T_g)_h` can't be stated for `N⧸range φ` (OreLocalization/Quotient instance diamond) → phrased the
  IH+descent output in single-localisation form.
- **QUOT 4→4** (+3 axiom-clean decls, additive) — `degreewise_finrank_diff` (D5),
  `homogeneousSubmodule_inf_iSupIndep` (G1 indep), `homogeneousSubmodule_iSup_inf_eq` (G1 sup). Bundled
  G1 + G2–G4 BLOCKED by the isDefEq pathology. 4 public stubs unchanged.
- **GR 0 / RegroupHelper 0** — DONE, untouched.
- **Net axiom-clean decls this iter: 3** (all QUOT, `{propext, Classical.choice, Quot.sound}`,
  re-verified via the prover's `lean_verify` + my `lake build`).

## What shaped iter-016 (live frontiers)

1. **All three lanes need a blueprint-writer round BEFORE the next prover** (HARD GATE — each chapter
   carries a must-fix blueprint finding): FBC Seam 2/3 mechanism; GF helper block + Step-4 fix; QUOT
   G1 split + pins. See `session_15/recommendations.md` HIGH #1–#3.
2. **QUOT bundled `IsInternal`/`Decomposition` is a hard do-not-retry blocker** — corrective is a
   mathlib-analogist consult or an ambient-`M`-only architecture, not a bigger heartbeat budget.
3. **GF must close, not decompose** — the progress-critic's CHURNING corrective stands; next GF
   dispatch = prove `free_localizationAway_of_away_tower` (after blueprinting), no more helpers.
4. **FBC Seam 2 is the highest-leverage closure** once its sketch is expanded (cascades to 4
   downstream decls); the prover reached the exact coherence gap.

## Anomalies / debt surfaced (not blocking)

- **sync_leanok removed 25 `\leanok`, added 1** (sha `48f7838`, iter 15 = current tree). Recalibration
  artifact per the established PROJECT_STATUS note (broken QUOT G1 pin + renamed/split decls); prover
  diffs were near-purely additive, no existing proof touched. Not laundering, not a regression.
- **Cold-build vs warm-LSP heartbeat gap** (GF file): `lake env lean` timed out near L1146; `lake build`
  green. Recorded in Knowledge Base; trust `lake build`.
- **Broken QUOT G1 pin** `homogeneousSubmodule_decomposition` → I added a `% NOTE:`; planner does the
  split/retarget.
- **3 unmatched `lean_aux`** (the new GF helper + 2 QUOT G1 sub-lemmas) — listed in recommendations.
- **Stale/cross-project comments** (lean-auditor majors): dead RegroupHelper import + iter-234/236
  STATUS in FBC; stale scaffold in GrassmannianCells; RegroupHelper docstring. Prover-cleanup.
- **GF helper witness concern** (lean-auditor minor): proof-plan `hf0 hf0` would give freeness at `f²`
  not `f` — verify when closing.

## Review subagents dispatched (4; all returned)

- **lean-auditor `iter015`** — 4 must-fix (the QUOT skeleton-stub excuse-comments, pre-existing) / 5
  major / 3 minor.
- **lean-vs-blueprint-checker `fbc`** — 31 decls, all pinned; must-fix = Seam 2/3 blueprint adequacy.
- **lean-vs-blueprint-checker `gf`** — 23/24 pinned; must-fix = missing helper block + wrong Step-4 lemma.
- **lean-vs-blueprint-checker `quot`** — D5 + both G1 halves correct; broken G1 pin flagged.

Reports under `.archon/task_results/`, archived to `logs/iter-015/`. Findings landed in
`session_15/recommendations.md`. blueprint-doctor: CLEAN.

## Blueprint markers updated (manual)

- `Picard_QuotScheme.tex`, `lem:graded_homogeneousSubmodule_decomposition`: added `% NOTE:` (broken
  pin; decl split into two sub-lemmas; planner to split block / retarget). No `\leanok` touched, no
  `\mathlibok` candidates, no stale `\notready`.
