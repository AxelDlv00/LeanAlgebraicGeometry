# Iter-253 (Archon canonical) — review

## Outcome at a glance

- **The "3rd consecutive M=2 iter with ZERO target closures — both lanes hit hard, named obstacles: TS-cmp's
  armed REVERSING SIGNAL fired (STEP A friction-bound across 3 approaches), and DualInverse's `homOfLocalCompat`
  hit a signature-restructure blocker on `hf`" iter.** Two prover lanes, both `opus`, mode `prove`.
  - **Lane TS-cmp** (`Picard/TensorObjSubstrate.lean`, D1′):
    - **`sheafifyTensorUnitIso_hom_natural`** (STEP A, L1962) — **BLOCKED.** The plan's armed binary close-test
      ("does STEP A close with the in-file element recipe + bw253b roadmap?") fired **NEGATIVE.** Three approaches
      failed — element-descent (LSP-clean / real-build-not-closed), whisker calculus (`whnf` timeout at 6.4M
      heartbeats via the `erw` `≫`-instance bridge), uniform-instance helper (4× `synthInstanceFailed` at the
      statement level). Root cause = the recurring `restrictScalars (𝟙)`-over-sheafification `whnf` wall; the
      hand-derivation is mathematically complete, the obstacle is pure tactic friction.
    - **`pullbackTensorMap_natural`** (STEP B/D1′, L2027) — **PARTIAL**, genuine compiling advance: Square 1
      (`sheafificationCompPullback` naturality) + setup landed; full S2–S4 chain authored in-file; blocked on the
      Square-2 `Sheaf.val`/`.obj` `Functor.comp_map` merge (and S3 cites the OPEN STEP A). File sorry **3 → 3**.
  - **Lane TS-inv** (`Picard/TensorObjSubstrate/DualInverse.lean`):
    - **`homOfLocalCompat`** — sub-step **(b) CLOSED** (two new compiling helpers `topSectionToHom` +
      `topSectionToHom_app`: terminal-`⊤` section → global morphism, glued via `.choose` + `hsup ▸`). Sub-step
      **(a) IsCompatible BLOCKED** on `hf`: the goal reduces (verified in-context) to the explicit sectionwise
      core equation, but `hf` — an `HEq` between `Scheme.Modules.pullback`-images — is unconsumable because the
      source/target objects are sheafifications, only *isomorphic*, not propositionally equal (scratch-verified:
      `rfl`/`exact?`/`congr 1`/HEq-elim all fail; no `SheafOfModules` HEq-ext exists). Sub-step **(c)** linearity
      transitively gated on (a). File sorry **2 → 3** by occurrence (decl-with-sorry: 2 → 2; (b) closed, the single
      scaffold sorry split into named (a)+(c)).
    - **`dual_restrict_iso` Step-4** (L256) — not attempted (the sibling `TensorObjSubstrate.lean` was
      non-compiling the whole session → `failed_dependencies`; can't-verify environment). Cleanup only.
- **Build:** TS compiles clean (D2′ closer `pullbackTensorMap_unit_isIso` verified axiom-clean first-hand — **no
  regression**); DualInverse facts scratch-verified in an isolated `import Mathlib` file (sibling broken).
- **Canonical critical-path counter: FLAT** (D2′ was the iter-250 win; no canonical Picard sorry eliminated 251/252/253).
- **`sync_leanok`** net **−14** (16 removed / 2 added) at sha `beec0117`, chapters `Picard_RelPicFunctor.tex` +
  `Picard_TensorObjSubstrate.tex` — flagged as an ambiguity (most likely the recurring parallel-race / stale-olean
  strip; iter-252 KB predicted a *restore*, which did not clearly happen). Not a Lean regression (D2′ verified clean).
- **Blueprint-doctor: CLEAN.**

## The defining tension — three iters of M=2 breadth, zero closes, and now TWO named structural walls

iter-251 opened M=2; iter-252 and iter-253 are the second and third parallel iters, and **all three closed zero
assigned targets.** The forward motion is real and per-lane verifiable (iter-251: 6 closed helper lemmas; iter-252:
`homLocalSection` + a disproved-route pivot; iter-253: sub-step (b) of `homOfLocalCompat` + Square 1 of D1′ + the
new `topSectionToHom` helpers). But the *targets* — D1′ and `homOfLocalCompat` — have not moved to closed, and the
honest read after this iter is that **both lanes have reached obstacles that are NOT proof-filling labor:**

1. **TS-cmp / STEP A** is friction-bound on the `restrictScalars (𝟙)`-over-sheafification `whnf` wall — the SAME
   root that gated D2′ for 11 iters, now re-appearing on D1′'s square-3 helper. The plan ARMED the correct response
   (the binary signal + the pc253b SECONDARY mathlib-analogist consult). The signal fired; the next iter MUST execute
   the consult and should treat the carrier shape itself as suspect (3 iters / 3 disproved approaches: whisker252
   `letI`, element-descent, uniform-instance helper). This is a candidate for **cross-domain-inspiration** mode, not
   another api-alignment retry.
2. **TS-inv / `homOfLocalCompat`** has a genuine **signature-restructure** need: `hf` (HEq-of-pullback-images) is
   unconsumable and arguably unsatisfiable. `homOfLocalCompat` is **not** in `archon-protected.yaml`, so this is the
   loop's to fix — but it is a planner/blueprint/refactor decision (re-sign `hf` sectionwise or via `restrictFunctor`
   transport, update `lem:sheofmodules_hom_of_local_compat`), not a prover retry. Re-dispatching against the current
   `hf` would hit the identical object-equality wall.

Neither obstacle is a reason to abandon Route A bottom-up — both are addressable — but the planner should NOT
re-dispatch either lane against its current shape. The progress-critic flagged Route 1 CHURNING entering this iter;
the reversing signal firing makes the CHURNING read correct, and Route 2 has now surfaced its own structural blocker.

## Verification done first-hand
- `lean_verify pullbackTensorMap_unit_isIso` (D2′ closer) → `{propext, Classical.choice, Quot.sound}`, no `sorryAx`.
  The L481 "opaque" warning is the iter-250 prose-comment false-positive. **No regression of the prior win.**
- Term-level sorry counts confirmed by grep: TS L708/L1962/L2027; DualInverse L256/L565/L581.
- `homOfLocalCompat` confirmed absent from `archon-protected.yaml` (the prover's "PROTECTED" label is informal).
- `sync_leanok-state.json`: `iter == 253`, sha `beec0117`, +2/−16.

## Subagent dispatches (review-phase)
| Subagent | Slug | Purpose | Verdict (folded into recommendations.md) |
|---|---|---|---|
| lean-auditor | aud253 | Lean-as-Lean audit of both files (honest sorry/label accounting, new `topSectionToHom` defs, `hf` obstacle, fragile `erw`/heartbeat proofs) | see `task_results/lean-auditor-aud253.md` |
| lean-vs-blueprint-checker | di253 | `DualInverse.lean` vs `Picard_TensorObjSubstrate.tex` — does the blueprint's `hf`-bridge match the Lean signature? | see `task_results/lean-vs-blueprint-checker-di253.md` |

## Subagent skips
- lean-vs-blueprint-checker (TS-cmp / `TensorObjSubstrate.lean`): the `Picard_TensorObjSubstrate.tex` chapter was
  re-written this iter by bw253/bw253b and re-confirmed by the planner's same-iter HARD-GATE fast-path re-review
  (br-fix253, `correct: true`, 0 must-fix). Re-running the checker on the TS side would duplicate the planner's
  in-iter blueprint verification; the live blueprint↔Lean question is on the DualInverse side (`hf` bridge), which
  IS dispatched (di253).
- strategy-critic / progress-critic: not review-phase subagents (plan-phase only).
