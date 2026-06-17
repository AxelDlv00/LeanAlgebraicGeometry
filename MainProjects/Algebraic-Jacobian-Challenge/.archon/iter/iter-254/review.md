# Iter-254 (Archon canonical) — review

## Outcome at a glance

- **The "4th consecutive M=2 iter; the TS-cmp lane finally ELIMINATES the 5-iter STEP-A whisker wall
  axiom-clean (the iter-253 armed reversing signal's blocker), and the TS-inv lane reduces
  `homOfLocalCompat` to ONE isolated ring-bridge — but neither lane closes its assigned canonical target"
  iter.** Two prover lanes, both `opus`, mode `prove`.
  - **Lane TS-cmp** (`Picard/TensorObjSubstrate.lean`, D1′):
    - **`sheafifyTensorUnitIso_hom_natural`** (STEP A, the D1′ helper) — **CLOSED axiom-clean**
      (`{propext, Classical.choice, Quot.sound}`, verified first-hand). This is the lemma that defeated
      3 approaches in iter-253. Closed NOT via the analogist's literal δ/μ recast (didn't apply) but via
      the extracted *principle* — a `tensorHom`-PIN helper `sheafifyTensorUnitIso_hom_eq'` keeping every
      term in ONE monoidal instance, plus monoidal lemmas applied **as `(C := …)`-pinned TERMs**.
    - **`pullbackTensorMap_natural`** (D1′ target, L2004) — PARTIAL. Square-2 merge SOLVED
      (`erw [← Functor.map_comp_assoc]`); blocked on `δ_natural` failing to synthesize
      `MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)` — the instance lives only on the canonical
      `⋙ forget₂` spelling. Named structural blocker → **planner spelling-pin refactor**.
    - File sorry **3 → 2**.
  - **Lane TS-inv** (`Picard/TensorObjSubstrate/DualInverse.lean`):
    - **`homOfLocalCompat`** — `hf` RE-SIGNED (HEq → sectionwise; legal, not protected), sub-step **(a)
      `IsCompatible` CLOSED** (defeq proof-irrelevance), sub-step **(c) `𝒪_X`-linearity ~90% built**
      (separatedness `section_ext`, naturality/`map_smul`, the hard gluing-transport `hconn` fully proved,
      composite decomposition + M-leg `map_smul`). **SOLE residual** = the open-immersion ring-bridge /
      carrier-duality wall (L636), maximally isolated. New helper `image_preimage_of_le`.
    - **`dual_restrict_iso`** (Step-4, L256) — NOT entered (correctly gated by the Route-2 reversing signal).
    - File sorry **2 → 2** (internal sorries inside `homOfLocalCompat`: **2 → 1**).
- **Build GREEN both files** (verified first-hand: 8322 / 8367 jobs, exit 0). D2′ closer not regressed.
- **Canonical critical-path counter: FLAT** — no canonical Picard sorry eliminated (251/252/253/254);
  D2′ was the iter-250 win. STEP A is a real *helper-level* close of a 5-iter wall, not a target close.
- **`sync_leanok`** ran at sha `7d75a59b` (iter 254), **+17 / −0** across `Picard_RelPicFunctor.tex` +
  `Picard_TensorObjSubstrate.tex`. A clear positive net this iter (contrast iter-252/253's race-induced strips).
- **Blueprint-doctor:** ONE broken cross-ref — `Picard_RelPicFunctor.tex` `\uses{\leanok thm:relative_pic_quotient_well_defined}`
  (a `\leanok` jammed inside `\uses{}` — the recurring corruption — and/or undefined label). Needs a writer/plan fix.

## The defining tension — a genuine 5-iter wall falls, but still no canonical close in 4 M=2 iters

iter-251 opened M=2; iters 251–254 are four parallel iters and **all four closed zero assigned canonical
targets** (D1′ / a fully-closed `homOfLocalCompat`). The honest, verifiable forward motion this iter is
real and substantive:

1. **STEP A is genuinely dead as a blocker.** `sheafifyTensorUnitIso_hom_natural` defeated element-descent,
   whisker-calculus (`whnf` timeout), and the uniform-instance helper across iters 250–253. iter-254 closes
   it axiom-clean. The `(C := …)` term-level device is a real dissolution of the non-canonical-instance
   poisoning that has gated this file's monoidal work for ~5 iters — and it is reusable for the remaining
   D1′ squares (Sq4 already done).
2. **The dual-inverse A-bridge is down to one named lemma.** `homOfLocalCompat` was a bare sorry two iters
   ago; it now has a re-signed honest `hf`, a closed compatibility sub-step, and a 90%-built linearity
   sub-step whose only gap is the well-understood (historically-hard) carrier-duality ring-bridge — fully
   isolated, with a mapped route.

The other half is the recurring pattern the progress-critic has flagged: **breadth without a target close.**
Both lanes again reduced to a single named residual rather than finishing. Crucially, **both residuals are
now of the *same kind*** — the RingCat-vs-canonical-spelling / carrier-duality friction:
- TS-cmp's D1′ blocker is `δ_natural` not synthesizing `MonoidalCategory` on the `X.ringCatSheaf.obj`
  spelling (needs a structural spelling-pin restatement of `pullbackTensorMap`).
- TS-inv's residual is the `(U i).ringCatSheaf` vs `X.ringCatSheaf` action duality on a defeq carrier.

This convergence is itself a signal: the route's remaining cost is concentrated in *carrier/spelling
plumbing*, not in new mathematics. The iter-255 planner's committed actions (spelling-pin refactor for
D1′; the inline ring-bridge for `homOfLocalCompat`) are both well-scoped and both target this single theme.

## Honesty check

No defects found. All "CLOSED" claims this iter are accurate:
- `sheafifyTensorUnitIso_hom_natural` verified axiom-clean first-hand.
- The two task results explicitly label `pullbackTensorMap_natural` and `homOfLocalCompat` as PARTIAL with
  live sorries; in-file headers were updated (TWO residuals, STEP-A-closed note). The iter-253 false-"CLOSED"
  defect pattern did NOT recur.
- Build green verified independently; sorry counts match grep (TensorObjSubstrate L690/L2004; DualInverse
  L230/L512 → 2 each).

## Subagent findings (this iter)

- **lean-auditor aud254:** 0 must-fix. Confirms STEP A + `sheafifyTensorUnitIso_hom_eq'` axiom-clean &
  honestly labelled; the re-signed `hf` legitimate and **non-vacuous**; all sorry labels accurate (the
  iter-253 false-"CLOSED" pattern did NOT recur). 1 major = the pre-existing
  `set_option backward.isDefEq.respectTransparency false` (L1661, kernel-defeq hack — schedule a polish
  removal). 3 minors (off-path section, nested comments, unused args).
- **lean-vs-blueprint tscmp254:** 1 **MUST-FIX** = the `lem:pullback_tensor_map_natural` proof is
  Lean-inadequate (no spelling-pin guidance for the S2 `δ_natural` blocker) — **HARD-GATE blocker** for
  the next D1′ prover round; 1 major = stale TensorProduct-induction sketch for the now-closed STEP A.
  Both flagged with review `% NOTE:`; both need a blueprint-writer pass (recommendations #1).
- **lean-vs-blueprint dualinv254:** 0 must-fix, 0 major — the re-signed sectionwise `hf` MATCHES the
  blueprint (bw254's iter-254 update held). Minors only (optional `\lean{}` pins, a shorthand clarification).
- **blueprint-doctor:** 1 broken cross-ref = a `\leanok` jammed inside the `\uses{}` of
  `Picard_RelPicFunctor.tex:145` (the label `thm:relative_pic_quotient_well_defined` IS defined at
  `Picard_LineBundlePullback.tex:331`; the corruption is the only cause). Plan agent to relocate the
  `\leanok` (recommendations #2).

## Subagent skips

- (none — lean-auditor + two lean-vs-blueprint-checkers dispatched; findings folded into recommendations.md)
