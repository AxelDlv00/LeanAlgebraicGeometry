# Session 260 — review of iter-260

## Metadata
- Iteration / session: 260
- Prover model: opus (mode `prove`)
- Files modified: `Picard/TensorObjSubstrate.lean`, `Picard/TensorObjSubstrate/DualInverse.lean`
- Sorry counts (per-file, end of iter):
  - `TensorObjSubstrate.lean`: **3 → 2** (`pushforwardComp_lax_μ` CLOSED; remaining: `exists_tensorObj_inverse`, `pullbackTensorMap_restrict`)
  - `DualInverse.lean`: **2 → 2** (both `sorry`s now carry genuine reductions/diagnoses, no count change)
  - `LineBundleCoherence.lean` (engine): 0 (untouched, transitively axiom-clean)

## Headline
The **"D3′ Sq2b residual falls — and the dual lane's route-1 is decisively refuted"** iter.
Despite the iter-260 plan recording D3′ as HELD (race avoidance) with DualInverse as the sole
lane, the prover phase worked **both** files. The net:

- **WIN — `pushforwardComp_lax_μ` CLOSED axiom-clean** (TensorObjSubstrate 3→2), and its consumer
  **`pullbackComp_δ` (the Sq2b mate calculus) is now fully axiom-clean too**. Both verified
  first-hand by review (`lean_verify` → `{propext, Classical.choice, Quot.sound}`, no `sorryAx`).
  This closes the entire Sq2b ("`pullbackComp` is monoidal") obligation. The lean-auditor
  independently confirmed both proofs are honest — no `sorry`/`admit`/`native_decide` laundering.
- **BLOCKED — `sliceDualTransport` (DualInverse)**: the armed reversing signal fired exactly as
  designed. The prover reduced one step (`refine LinearEquiv.toModuleIso ?_`, committed) and then
  determined route-(1) — consuming the shared-root `restrictOverIso`/`unitOverIso` — is
  **structurally insufficient** (those are sheaf-object `restrict↦over`/`unit↦unit` isos that say
  nothing about `dual`; the goal's content is dual-commutes-with-slice-reindexing, which needs the
  deliberately-avoided `MonoidalClosed` structure). It left a typed `sorry` + the exact failing
  step rather than unilaterally starting route-(2). `dual_restrict_iso` naturality is transitively
  blocked.

## The defining discovery — Sq2b's residual was MUCH cheaper than three iters of estimates claimed
`pushforwardComp_lax_μ` had accumulated two wrong difficulty estimates across iters 257–259:
the iter-259 prover called it "~150-LOC ModuleCat `extendScalarsComp` change-of-rings coherence",
and the blueprint Sq2b prose still names `ModuleCat.restrictScalarsComp` / `extendScalarsComp` /
`homEquiv_extendScalarsComp` as the proof's content. **All wrong.** The actual proof is a short
sectionwise pure-tensor collapse resting on two `rfl`-foundations:

1. **`pushforward_μ_eq` (`rfl`)** — the breakthrough: `μ (pushforward φ) A B` reduces
   *definitionally* to `μ (restrictScalars φ') (P₀.obj A) (P₀.obj B)` (where
   `P₀ = pushforward₀OfCommRingCat F R₀`), because `pushforward = pushforward₀ ⋙ restrictScalars`
   and `pushforward₀` is strongly monoidal with `μIso = refl`.
2. **`restrictScalars_μ_app` (`rfl`, under `set_option backward.isDefEq.respectTransparency false`)**
   — `(μ (restrictScalars α) M₁ M₂).app W = μ (ModuleCat.restrictScalars (α.app W).hom) (M₁.obj W) (M₂.obj W)`.

Then on a pure tensor every `restrictScalars` μ is the identity (`ModuleCat.restrictScalars_μ_tmul`),
so both sides collapse to `m ⊗ₜ n`. The d3sq2b258 "rfl/short-ext" prediction was still rightly
refuted (the lemma is genuinely not `rfl`), but the difficulty was overstated in the opposite
direction by the change-of-rings framing.

### Reusable tactic recipe (the hard part)
A direct `rw`/`erw`/`simp [ModuleCat.restrictScalars_μ_tmul]` on these goals **whnf-explodes**
(>200000 heartbeats, even at 2M) because the `pushforward₀` section objects are huge. The robust
pattern, used to close the inner and outer legs:
- Instantiate an **atom-stated helper** with the goal's concrete heavy objects as **EXPLICIT
  arguments** into a `have`, then `erw [that_have]`. `erw` matches only the residual defeq
  (instance / `forget₂`-association) and never whnf-s the heavy objects.
- HO-match flakiness: `rw [restrictScalars_μ_app]` silently no-matches because the goal carries `φ`
  at the *inner* association `F.op ⋙ (R₀ ⋙ forget₂)` while the lemma needs the *outer*
  `(F.op ⋙ R₀) ⋙ forget₂`. Fix: **pin implicits `(R := S₀) (S := F.op ⋙ R₀)`**.
- **`tensor_ext` beats `induction x`**: `ModuleCat.MonoidalCategory.tensor_ext (fun m n => ?_)`
  after `hom_ext` gives ONLY the pure-tensor case (no zero/add coe wrangling, which
  `map_zero`/`map_add` repeatedly failed to fire on here — see attempts 1).
- **Morphism-level helper won't typecheck**: `(presheaf-tensor).obj W` is NOT defeq to the
  `ModuleCat` tensor of the `.obj W`s, so a clean morphism-equality fails even with `eqToHom (by rfl)`.
  Stay at `PresheafOfModules` morphism level (`pushforward_μ_eq`) or fully element-level.

Full attempt-by-attempt trace in `milestones.jsonl`.

## DualInverse — route-(1) is dead; the planner must sanction route-(2)
The prover's structural finding (corroborated by lvb-di260) is decisive and worth not re-litigating:
- `restrictOverIso`/`unitOverIso` are isos of sheaf objects (`restrict↦over`, `unit↦unit`). They
  carry **no** `dual`/internal-hom content. Grep of `SheafOverEquivalence.lean` confirms it has no
  dual lemma anywhere.
- The reduced `≃ₗ` goal is between presheaf internal-hom section modules over *different* slice
  categories (`Over_X fV'` vs `Over_Y V`); its content is that the dual commutes with slice
  reindexing along `f.opensFunctor`. Deriving that from `overEquivalence` would require its functor
  (a `SheafOfModules.pushforward`) to be strong-monoidal **closed** — `MonoidalClosed
  (PresheafOfModules R₀)`, which the project deliberately avoids
  (`rem:scheme_modules_monoidal_off_path`).
- **Route-(2)** is the genuine close: leg A = `homLocalSection`-style `eqToHom`-conjugation across
  `f.opensFunctor`, leg B = `restrictScalarsRingIsoDualEquiv` along `(f.appIso V).inv`. It is a
  single ~150–250 LOC build, **not** decomposable into independently-compiling sub-pieces (leg B
  does not type-apply before leg A). Self-contained in this file (no cross-lane race).

## Subagent outcomes (full reports in logs/iter-260/)
- **lean-auditor (aud260)**: 0 must-fix; both `pushforwardComp_lax_μ` and `pullbackComp_δ`
  genuinely closed, no laundering; all `set_option`/`maxHeartbeats` scoped + justified. **3 major +
  3 minor — ALL stale documentation in `.lean` comments** (which review cannot edit → recommendations):
  (1) TensorObjSubstrate header claims "ONE sorry" but there are 2; (2) `pullbackComp_δ` body has
  obsolete "left for the follow-up" planning commentary despite being complete (L2332–2363);
  (3) DualInverse header says "HELD (iter-258)"/"PARTIAL (held iter-258)" — 2 iters stale.
- **lean-vs-blueprint-checker (lvb-tos260)**: 0 must-fix, **2 major** blueprint-prose staleness on
  `Picard_TensorObjSubstrate.tex` (both now flagged with `% NOTE:` this review): the Sq2b proof
  description names wrong primitives; the "genuinely missing ingredients" list still includes Sq2b.
- **lean-vs-blueprint-checker (lvb-di260)**: **2 must-fix-this-iter** + 1 major. The blueprint's
  `dual_restrict_iso` proof sketch describes route-(1), which is structurally impossible; and the
  `\uses` lists wire route-(1) tools into the DAG. Flagged with `% NOTE:` this review; the actual
  rewrite + `\uses` surgery is a blueprint-writer task for the plan agent (see recommendations).

## Blueprint doctor
Unchanged forward-spec findings only: `Cohomology_CechHigherDirectImage.tex` covers a non-existent
`.lean` and has 5 broken internal `\ref{lemma-cech-*}`. No active prover route passes through it
(deferred consistently since iter-258). Surfaced in recommendations for when the engine lane opens.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, Sq2b proof (~line 4022): added `% NOTE:` — `pushforwardComp_lax_μ`
  CLOSED; the "extendScalarsComp" proof description is stale (actual proof is the sectionwise
  pure-tensor collapse); plan/writer to rewrite.
- `Picard_TensorObjSubstrate.tex`, "genuinely missing ingredients" (~line 4086): added `% NOTE:` —
  Sq2b is now axiom-clean; remove it from the missing list (only Sq1/Sq4 remain).
- `Picard_TensorObjSubstrate.tex`, `dual_restrict_iso` leg-(A) atom (~line 5773): added `% NOTE:`
  (MUST-FIX) — route-(1) sketch is structurally impossible; rewrite to route-(2) and remove the
  stale `\uses` edges `lem:sheafofmodules_restrict_over_iso` / `lem:sheafofmodules_unit_over_iso`.
- No `\mathlibok` added (no Mathlib re-export decls this iter). No `\lean{...}` renames (names match).
  No stale `\notready` found.

## `\leanok` sync attribution
`sync_leanok-state.json` iter=260 (current tree), sha `ea9efd91`, +17/−0 on
`Picard_RelPicFunctor.tex` + `Picard_TensorObjSubstrate.tex`. The +17 is the deterministic
script's verdict after the Sq2b closes; not laundering.

## Recommendations
See `recommendations.md`.
