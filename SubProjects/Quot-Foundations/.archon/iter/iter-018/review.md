# Iter 018 — Review (Quot-Foundations)

## Verdict

Build GREEN (all 3 modified modules `lake build` EXIT 0; only expected `sorry` + style/deprecation
warnings; blueprint-doctor clean; sync_leanok ran on this tree, +15 `\leanok`). **3-lane prover
dispatch (FBC fine-grained, GF prove, QUOT mathlib-build); net 0 sorries closed; +20 axiom-clean
declarations (all QUOT).** lean-auditor PASS with **0 must-fix** — every `sorry` is honest scaffolding,
no fake statements, no axioms, no excuse-comments, all new decls `{propext, Classical.choice,
Quot.sound}`. This is a low-closure iter, but two of three lanes made real structural progress (QUOT
Route-2 foundation complete; GF L4 foundation F1–F6 proved), and the third (FBC) documented a genuine
new wall rather than churning a helper.

## Overall progress this iter (active sorry per file)

- **FBC 4→4** — Seam-2 step-iii `base_change_mate_fstar_reindex_legs` did NOT move. The only edits were
  a comment rewrite + one scaffolding line `rw [he, hinclA] at key`. New finding: the post-`subst`
  **literal-form lock** — `set e/inclA` fail to fold the goal's legs, and re-folding via `rw [← he]`
  re-fires "motive is not type correct" (dependent leg-equality proofs). `pullbackPushforward_unit_comp`
  in `e`-form never matches; must literalize `key`, then INVERT it (not `rw [← key]`). Residual is a
  ~150-LOC categorical telescoping (5-step recipe pinned in-file + task result). Seam 3 / affine / FBC-B
  untouched (gated). This is the **5th consecutive iter (014–018) with the Seam-2 goal unmoved**.
- **FlatteningStratification (GF) 3→3** — L4 `exists_localizationAway_finite_mvPolynomial` PARTIAL: six
  proved `g`-independent foundation steps (F1 `A↪B`, F2 `B_K` localisation, F3 common denominator,
  F4 `IsIntegral K[X] B_K`, F5 generating set, F6 generator alg-independence) now precede a single
  honest assembly `sorry`. All closure API confirmed present. `genericFlatnessAlgebraic`,
  `genericFlatness` untouched (gated on L4).
- **QuotScheme (QUOT) 4→4 (+20 axiom-clean decls, additive)** — Route-2 foundation: poly-module
  structure (9: `polyEndHom`/`polyModule`/`polySubmodule` + simp lemmas), kernel/cokernel ambient
  calculus (8), `SubquotientDatum` structure + `.hilb` + base-case finiteness (3). The design unlock
  (state finiteness over the FREE poly ring without a derived graded carrier) is realized and compiling;
  **no `isDefEq`/`whnf` runaway fired**. The 4 protected stubs unchanged.
- **GrassmannianCells / RegroupHelper 0/0** — DONE, untouched.

## What shaped iter-019 (live frontiers)

1. **GF L4 is one prove-pass from closed AFTER a blueprint round** (lean-vs-blueprint-checker MUST-FIX):
   Step-3 AlgHom assembly/injectivity is under-specified in the chapter (the in-file roadmap is the real
   guide). Blueprint-writer round naming `AlgHom.algebraicIndependent_iff`,
   `AlgebraicIndependent.restrictScalars`, the `ν` lift → then prove. Highest-leverage closure.
2. **FBC step-iii: blueprint-expansion has now failed once as the corrective.** The iter-018
   gate-passed step-iii sketch was still inadequate (checker: the ~150-LOC cancellation mechanism is
   absent). Escalate: promote the prover's 5-step recipe into the chapter AND/OR effort-break the goal
   AND/OR mathlib-analogist cross-domain — NOT a verbatim re-dispatch.
3. **QUOT must now CLOSE a stub, not add helpers.** Two additive iters (017 +13, 018 +20) with 0 stub
   closures; foundation is complete. Next lane = the induction body (constructors →
   `subquotient_finite_transfer` via `Module.Finite.of_surjective` along `Fin(r+1)↠Fin r` → base/step
   → `(⊤,⊥)` bridge). If iter-019 again adds helpers without closing a stub, treat as CHURNING.
4. **Coverage debt: 20 new unmatched `lean_aux` nodes** (all QUOT) + 4 QUOT blueprint findings (M1–M4)
   + 11 GF `private` decls invisible to sync_leanok. One QUOT writer pass + one GF de-`private` pass.

## Anomalies / debt surfaced (not blocking)

- **0 sorries closed across 3 lanes.** Genuine progress is in additive decls (QUOT) and in-proof
  foundation (GF) + a documented wall (FBC), not in the sorry count. The progress-critic should watch
  QUOT (additive, 2 iters) and FBC (unmoved, 5 iters) closely next iter.
- **GF chapter under-represents progress** — 11 closed axiom-clean NagataNormalization decls are
  `private` → `\lean{}` pins don't resolve by name, sync_leanok can't pin them. (recommendations H5.)
- **QUOT `IsRatHilb` toolkit (9 decls) is `private`** with public `\lean{}` pins — sync_leanok found
  them by file scan; the pins are name-fragile. (recommendations H4/M1.)
- **2 broken-pin / prose findings** in `Picard_QuotScheme.tex` — `lem:graded_subquotient_ker_coker`
  `\lean{}` names a non-existent decl (split into 8); `def:graded_subquotientHilb` finiteness prose says
  "M finite" but Lean records "N/N' finite". Both `% NOTE:`-annotated this review; prose/pins to writer.

## Review subagents dispatched (4; all returned)

- **lean-auditor `iter018`** — PASS, 0 must-fix, 2 minor (dead `have` in RelativeSpec:286; triplicated
  `letI` in QuotScheme:1002–1019).
- **lean-vs-blueprint-checker `quot`** — 0 must-fix, 0 red flags, 4 major (M1–M4 above).
- **lean-vs-blueprint-checker `gf`** — 1 must-fix (L4 Step-3 blueprint under-specified) + 1 major (11
  private decls).
- **lean-vs-blueprint-checker `fbc`** — 0 must-fix, 1 major (step-iii mechanism absent from blueprint).

Reports in `.archon/task_results/`, archived to `logs/iter-018/`. Findings landed in
`session_18/recommendations.md`.

## Blueprint markers updated (manual)

- `Picard_QuotScheme.tex`, `lem:graded_subquotient_ker_coker`: added `% NOTE:` (broken `\lean{}` pin →
  split across 8 component lemmas; planner to bundle or re-pin).
- `Picard_QuotScheme.tex`, `def:graded_subquotientHilb`: added `% NOTE:` (finiteness is of N/N' not M;
  add `SubquotientDatum`/`.hilb` pins — blueprint-writer task).
- No `\leanok` touched; no `\mathlibok` added; no `\lean{}` renames; no stale `\notready` found.

## Subagent skips

- (none — all HIGHLY RECOMMENDED review subagents dispatched: lean-auditor + one
  lean-vs-blueprint-checker per prover-touched file.)
