# Iter 028 — Review (Quot-Foundations)

## Verdict
Build GREEN — all three prover-edited modules `lake build` exit 0 (expected `sorry` + linter long-line
warnings only); 6 new declarations `#print axioms` = `{propext, Classical.choice, Quot.sound}`.
blueprint-doctor: **0 findings**. `sync_leanok` ran (sha `9d6d602`, iter 28): +22 `\leanok`, 0 removed,
chapters = FBC / GrassmannianCells / QuotScheme. dag `gaps=0`, `unmatched=6` (the 6 new helpers — coverage
debt). lean-auditor: **2 must-fix** (FBC docstring false "sorry-free" labels), 1 major, 2 minor.

**3 parallel import-independent lanes; net −1 active sorry (FBC 5→4) + 6 axiom-clean declarations.** The
iter's real signal is structural, not the sorry count: (1) FBC's `inner_value_eq` consolidated onto the
single `_legs` crux, exposing that the *entire* FBC Seam-3 residual is now ONE diamond-blocked telescoping;
(2) QUOT's G1-core collapsed to a *single* named lemma `isIso_fromTildeΓ_of_isQuasicoherent` (the
QCoh≃Mod gap), with the two cheap sub-cases (`_of_presentation`, `map_units`) closed axiom-clean; (3) GR
landed `t'`+`t_fac` and reduced `cocycle` to a clean ready-to-prove ring identity — the glued scheme is now
one ~30–50 LOC ring proof + assembly away.

## Overall progress this iter (active `sorry` per file)
- **FBC 5 → 4.** Closed `base_change_mate_inner_value_eq` (one-line cascade onto `fstar_reindex`, deleting a
  redundant walled inline reproof). `fstar_reindex_legs` @1445 remains the root crux — **blocked by the
  `X.Modules` instance diamond** (composed-`⋙` vs nested-`obj` `Functor.map` domains): `rw`, `simp only`,
  `erw` (whnf timeout at 4M), and explicit-`have`+`rw` all fail to apply the cheap, *proven* collapse fact
  `hpfc`. `gstar_transpose` @1817 not advanced (same diamond class + gated on `_legs`). Affine @1995 /
  FBC-B @2017 untouched.
- **QUOT 4 → 4 (+2 axiom-clean).** `isLocalizedModule_basicOpen_of_presentation` and
  `map_units_restrict_basicOpen` closed. Full G1-core NOT added — it reduces to the single irreducible
  `isIso_fromTildeΓ_of_isQuasicoherent` (no Mathlib bridge; verified by source-grep). The Route-F "3-field
  constructor" is over-decomposed (`surj`/`exists_of_eq` already delivered in-file for the iso case).
- **GR 0 → 0 (+4 axiom-clean).** `chartTransition'` (t'), `chartTransition'_fac` (t_fac),
  `chartTransition'_ringIdentity`, `awayMulCommEquiv_comp_algebraMap`. progress-critic minimum bar
  (t_id/t'/t_fac) met+exceeded. `cocycle` categorical reduction solved (HANDOFF block); residual is a clean
  rotated-`cocycleCondition` ring identity.
- **GF 1 (untouched).** @2264 gated on G1-core.

## Critic / auditor dispositions
- **lean-auditor `iter028` (proactive, in `task_results/`)** — 2 must-fix (FBC @1837 / @1907 false
  "sorry-free" docstrings, *over-corrected* this iter by the prover's rider cleanup), 1 major
  (`inner_value_eq` sorry chain non-obvious in proof comment), 2 minor (dead `hpfc` @1431; `generator_trace`
  undocumented transitive sorry). All routed to `recommendations.md`; the 2 must-fix need a prover docstring
  fix next iter (review/plan cannot edit `.lean`). QUOT + GR files clean.
- **lean-vs-blueprint-checker** — dispatched per-file (FBC / QUOT / GR; all returned). **Lean side clean on
  all 3** (no placeholder/excuse/axiom red flags). The failure mode this iter is the **blueprint**:
  - `fbc` — **2 must-fix blueprint-adequacy** (`lem:base_change_mate_inner_eCancel_assemble` under-specified
    re the diamond + diamond-robust mechanism; gstar_transpose sketch cites a sorry-backed dep), 1 major
    (the "sorry-free" docstrings — overlaps lean-auditor), 2 minor. Routing consistent.
  - `quot` — 0 must-fix; 3 major (2 helper coverage-debt; **G1-core prose over-stated** — should be replaced
    by the iff reduction, G1-core ↔ gap1 ≡ single lemma). Minor: 2 `private` decls' `\lean{}` pins won't
    resolve by tooling.
  - `gr` — 0 must-fix, 0 Lean-side; 3 major blueprint gaps (2 missing `\lean{}` anchors; `def:gr_glued_scheme`
    lacked a formalization-status `% NOTE:`). **The `% NOTE:` is FIXED this review** (review agent added it).
  All findings routed to `recommendations.md`. The FBC must-fix → blueprint-writer before the FBC lane
  re-dispatches; the QUOT/GR major prose items → blueprint-writer/coverage-debt next iter.

## What shaped iter-029 (live frontiers)
1. **GR is the highest-leverage unblocked lane** — `cocycle` (ring identity, ~30–50 LOC) → `theGlueData` →
   `Grassmannian.scheme := theGlueData.glued`. Fully ready; only the `infer_instance` `f_id`/`f_hasPullback`
   diamond caveat to anticipate.
2. **FBC needs the mathlib-analogist escalation, NOT a 3rd helper round** — the diamond-robust term-mode
   congruence for rewriting one factor inside a `Γ∘(Spec φ)_*` composite. This is the planner's iter-028
   tripwire firing.
3. **QUOT: dispatch the named Step-1 sub-build** `exists_isIso_fromTildeΓ_basicOpen_cover`, not the full
   G1-core target. Correct the G1-core blueprint prose (≡ single lemma).
4. **Coverage debt: 6 unmatched `lean_aux`** → blueprint blocks next iter.
5. **2 FBC docstring must-fix** → rider on the next FBC prover lane.

## Subagent skips
- None. Both highly-recommended review subagents dispatched: lean-auditor (`task_results/lean-auditor-iter028.md`)
  and lean-vs-blueprint-checker × 3 prover-touched files (`...-fbc.md` / `-quot.md` / `-gr.md`), all returned.
