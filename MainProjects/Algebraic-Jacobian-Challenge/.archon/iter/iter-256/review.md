# Iter-256 (Archon canonical) — review

## Outcome at a glance

- **The "the 5-iter `DualInverse.lean` CHURNING streak finally BREAKS — `homOfLocalCompat` CLOSED axiom-clean (the
  A-bridge of the ⊗-inverse), the engine lane opens with a green skeleton + positive site-instance de-risk, and the
  TS-cmp D3′ reversing signal fires correctly to disprove the planner's blueprint recipe" iter.** Three prover
  lanes, all `opus`, mode `prove`.
  - **Lane TS-inv** (`Picard/TensorObjSubstrate/DualInverse.lean`):
    - **`homOfLocalCompat`** — **CLOSED axiom-clean** (`{propext, Classical.choice, Quot.sound}`, verified
      first-hand via `lean_verify`). The CHURNING must-fix (file-sorry stuck 2→2 ×5). Closed INLINE per the pc256
      corrective (no new top-level helper, local `have`s only): the inner f-leg native↔`restrictScalars 𝟙` smul
      bridge via `erw [ModuleCat.restrictScalars.smul_def']` + full `simp [Scheme.Opens.ι_appIso]` + a thinness
      scalar-reconcile TERM. The `-- TO CLOSE (next iter)` excuse-comment was removed.
    - **`dual_restrict_iso` Step-4** (L259) — correctly NOT entered (pc256 guardrail; structural hard wall).
    - File proof-body sorry **2 → 1**.
  - **Lane TS-cmp** (`Picard/TensorObjSubstrate.lean`):
    - **`pullbackTensorMap_restrict`** (D3′, new decl L2138) — **PARTIAL**, reversing signal fired as armed. The
      statement is scaffolded + typechecks (general composition coherence). The planner's recipe
      ("MIRROR `pullbackObjUnitToUnit_comp`") is **structurally FALSE** — `pullbackTensorMap` is not an adjunction
      transpose (verified via `simp only [pullbackTensorMap]` = a hand-built 4-fold composite), so the mirror's
      opening stalls. Prover left a typed `sorry` + an in-proof ROADMAP (the 4-square comp_δ route). File proof-body
      sorry **1 → 2** (new scaffold; `exists_tensorObj_inverse` untouched).
    - Cleanup: status block (~L41) updated D1′-CLOSED — but the auditor flags it still undercounts (says ONE
      residual; there are now TWO).
  - **Lane engine** (`Picard/LineBundleCoherence.lean`, NEW file):
    - File-skeleton: 5 sorry-stub decls matching the chapter `\lean{}` pins; compiles clean (0 errors). **Site-
      instance de-risk POSITIVE** — all four `J.over U` instances resolve automatically. Bar MET.
- **Builds:** all three files `success:true`, 0 errors (verified via `lean_diagnostic_messages`).
- **Canonical critical-path counter:** the ⊗-inverse `exists_tensorObj_inverse` is still open (gated on
  `dual_restrict_iso` Step-4), but its **A-bridge** `homOfLocalCompat` is now landed — a real frontier close, the
  first down-move on `DualInverse.lean` in 5 iters.
- **`sync_leanok`** sha `4479ed1c`, **+8 / −24** — a marker under-mark: three closed axiom-clean proof blocks
  (`homOfLocalCompat`, D1′, D2′) LACK proof-`\leanok` despite being sorry-free (race/stale-olean strip, NOT a Lean
  regression). Plus a FALSE proof-`\leanok` on the new chapter (root cause: unimported file).
- **Blueprint-doctor:** one broken cross-ref — the recurring `\leanok`-jammed-in-`\uses` at
  `Picard_RelPicFunctor.tex:144-146`.

## The defining tension — a real close + engine open, but two blueprint must-fixes block the next prover passes

iters 251–255 were a long M=2 substrate breadth with one canonical-target close (D1′, iter-255). iter-256 lands a
second frontier close (`homOfLocalCompat`, the A-bridge) AND opens the engine lane — the most forward motion in a
single iter for a while. But the iter ends with **both new prover lanes blocked on blueprint corrections**, and the
honest read is that the next prover round cannot simply re-dispatch:

1. **D3′'s blueprint recipe is disproven.** The reversing signal worked exactly as designed: the prover detected
   that "mirror `pullbackObjUnitToUnit_comp`" cannot start (not a transpose) and scaffolded rather than forcing a
   bad device. lvb-tensorobj256 confirms a deeper problem: the chapter STATEMENT is the base-change-square form
   while the Lean proves the general composition coherence — a content mismatch, not just a sketch gap. Both must be
   realigned before a prover builds Sq1/Sq4/Sq2. (A `% NOTE:` is in the chapter; recommendations name the writer fix.)

2. **The engine chapter is under-specified on finiteness + carries a false marker.** lvb-linebundle256: the
   `isFinitePresentation` finiteness path (`chartPresentation` → `IsFinite` via `Presentation.ofIsIso`) is not in
   the prose, and there is a false proof-`\leanok` at tex:187. The auditor independently flags `chart_free_rank_one`
   as a near-restatement of `IsLocallyTrivial`. The file is also not imported into the root — which is the root
   cause of the false marker (sync couldn't evaluate it).

Neither blocker is a Mathlib wall; both are cheap blueprint-writer + one mechanical import. The risk is purely that
the planner re-dispatches a prover before the chapters are corrected (the HARD GATE exists for exactly this).

## Subagent dispatches (all four; none skipped)

- lean-auditor (iter256): 0 must-fix, 2 major (status-block undercount; `chart_free_rank_one` near-restatement),
  4 minor. `task_results/lean-auditor-iter256.md`.
- lvb-dualinverse256: 0 must-fix, 0 major. `homOfLocalCompat` faithful. `task_results/lean-vs-blueprint-checker-dualinverse256.md`.
- lvb-tensorobj256: **2 must-fix** (D3′ statement/sketch), 2 major (D1′/D2′ sync gaps).
  `task_results/lean-vs-blueprint-checker-tensorobj256.md`.
- lvb-linebundle256: **2 must-fix** (false proof-`\leanok`; finiteness under-spec), 1 major.
  `task_results/lean-vs-blueprint-checker-linebundle256.md`.

## Manual blueprint markers
- `Picard_TensorObjSubstrate.tex`, `lem:pullback_tensor_map_basechange`: added `% NOTE:` flagging the
  statement/signature divergence + disproven sketch.
- No `\mathlibok`, no `\lean{}` renames, no stale `\notready` found. Did NOT touch `\leanok` (including the false
  one at LineBundleCoherence.tex:187 — flagged for the planner; only sync can correct it once the file is imported).

## What the next plan iter must do (see recommendations.md for detail)
1. Blueprint-writer on `Picard_TensorObjSubstrate.tex` (D3′ realign) — HARD GATE before any TS-cmp prover.
2. Blueprint-writer on `Picard_LineBundleCoherence.tex` (false `\leanok`, finiteness route, rank decl) — HARD GATE.
3. `import AlgebraicJacobian.Picard.LineBundleCoherence` into `AlgebraicJacobian.lean` (mechanical).
4. Reflow `\uses{}` at `Picard_RelPicFunctor.tex:144-146`; verify the D1′/D2′/homOfLocalCompat `\leanok` re-sync.
