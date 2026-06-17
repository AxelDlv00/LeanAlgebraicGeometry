# Recommendations for iter-225 plan

## TL;DR
Sub-step 3 (the eval counit) is **DONE axiom-clean**; project 81→80. The funded build advances
to **sub-step 4: `lem:internal_hom_isSheaf` / `AlgebraicGeometry.Scheme.Modules.dual`** — the
sheaf condition for the presheaf internal hom. It does **not** depend on `internalHomEval`, so
it is unblocked. Sub-step 5 (`exists_tensorObj_inverse`) remains the genuine long pole.

## Priority 1 — next frontier: sub-step 4 (`lem:internal_hom_isSheaf`)
- The prover's handoff and the blueprint both name this as the natural next brick. It builds
  `Scheme.Modules.dual` by showing `ℋom(M, N)` satisfies the sheaf condition (glue morphisms of
  restricted modules across an open cover, using that `N` is a sheaf). HARD GATE: dispatch
  blueprint-reviewer first (per its mandatory-each-plan rule) and confirm the
  `Picard_TensorObjSubstrate.tex` chapter clears for `lem:internal_hom_isSheaf` before sending a
  prover. The chapter block (lines ~2675–2709) exists and is detailed; verify it is
  `complete + correct` in the reviewer's checklist.
- This is a `mathlib-build`-shaped lane (constructing a sheaf object), not a `prove` lane.

## Priority 2 — the genuine long pole: sub-step 5 `exists_tensorObj_inverse`
- Still blocked on the **sheaf-level** dual + evaluation counit + object descent;
  `MonoidalClosed (SheafOfModules R)` is Mathlib-absent. The presheaf-level
  `internalHom`/`dual`/`internalHomEval` are now the raw material. Do NOT dispatch a prover at
  this declaration until sub-step 4 lands `Scheme.Modules.dual` — the sheaf-level counit then
  descends from `internalHomEval`. Re-confirm the sheafification path with `mathlib-analogist`
  (api-alignment) before committing to sub-step 5 construction.

## Do NOT retry (blocked, off-route)
- `isLocallyInjective_whiskerLeft_of_W` — route-(e) residual; needs the d.2 stalk-⊗ commutation,
  a separate Mathlib-absent build. Leave parked.
- `addCommGroup_via_tensorObj` — gated downstream of `exists_tensorObj_inverse`. Leave parked.

## PROCESS LESSON (carry forward) — re-test stale "bomb" diagnoses before escalating
The iters-222/223 `whnf` heartbeat-bomb (and the iter-224 ts224dual analogist ALIGN escalation
built on it) was **STALE** — a Mathlib bump removed it. iter-224 closed the sorry on its *first
probe* with the plain reduction prior provers already had. **Before escalating a multi-iter-old
Lean-tactical "bomb"/timeout obstacle, re-run the plain tactic once on the current toolchain.**
A Mathlib version bump can silently retract an elaboration-cost wall. This cost ~2 iters
(222 stub + 223 mis-characterization). Memory `ts-assoc-flatness-gap.md` records the lesson.

## Subagent findings to action (from this review)

### MEDIUM — stale `.lean` docstrings (lean-auditor ts224, 3 major; NOT review-agent-editable)
The review agent cannot edit `.lean` files. Fold these into the next prover's ride-along
comment-cleanup directive (the prover owns `TensorObjSubstrate.lean`):
1. **File-header pin #3 (lines ~69–74)** lists `AlgebraicGeometry.Scheme.Modules.monoidalCategory`
   as a delivered pin, but §2 (lines ~1555–1567) says that instance is "deliberately not built"
   (iter-206 pivot) and the declaration does not exist. Header is actively misleading — fix the
   stated 4-pin scope.
2. **`exists_tensorObj_inverse` docstring header (line ~1907)** says "iter-218 INCOMPLETE gate"
   while its proof-body comment is current (iter-224). Reconcile the temporal framing.
3. **`addCommGroup_via_tensorObj` docstring (lines ~1966–1967)** carries 20+-iter-stale
   "iter-202 / iter-204+" labels. Refresh.
- LOW: `tensorObjOnProduct` docstring (L1942) "Complete (no sorry)" omits the sorry-transitivity
  note that `tensorObj_assoc_iso` carries; `internalHomEval` proof comments jump "Step 1 → Step 4".

### LOW — `erw` fragility (lean-auditor ts224, minor)
~15 `erw` sites (now incl. the new L1472 in `internalHomEval`'s naturality) each bridge a defeq
gap `rw` would reject. Not a current bug, but a regression vector: a future Mathlib restatement of
`ModuleCat.hom_comp` / `restrictScalars` could break the iter-224 close. Worth a hardening pass
(replace `erw` with explicit `rw [show … from rfl]` or `simp only` where feasible) eventually —
not urgent.

### INFRASTRUCTURE — missing proof-block `\leanok` on `lem:internal_hom_eval`
The proof is axiom-clean but the chapter proof block lacks `\leanok`; `sync_leanok` reported
added 0 / removed 0 on a snapshot sha (`591983cc`) that does not include the closure, and the
substrate `.lean` file is git-untracked. The next `sync_leanok` pass (run on the current tree)
should add it. If it persists across an iter where the file is committed, investigate the sync
attribution for untracked files. (Review agent cannot add `\leanok`.)

## Strategy note (for the planner, not a mandate)
With sub-step 3 retired, the funded Decision-1 build has elapsed ~6 iters (219→224) of its
~6–12 estimate, sub-steps 4–5 remaining, and sub-step 5 is the genuinely Mathlib-absent piece.
The standing USER directive (Route A bottom-up, RR/divisor route paused) is unchanged — no
strategy fork is open. But the planner may want the strategy-critic to weigh whether sub-step 5's
sheaf-level-`MonoidalClosed` gap warrants a divisor-route comparison, given it is the long pole.
