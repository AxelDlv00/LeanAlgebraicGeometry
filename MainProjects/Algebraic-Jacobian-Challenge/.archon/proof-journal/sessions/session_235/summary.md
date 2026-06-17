# Session 235 — review of iter-235

## Metadata

- **Session / iter:** 235 (review of iter-235).
- **Prover lanes this iter:** 1 (`StalkTensor.lean`, mode `mathlib-build`). The second slot
  (FlatBaseChange engine) was replaced by a read-only `mathlib-analogist` consult per the
  iter-235 progress-critic STUCK verdict — no prover ran on FlatBaseChange.
- **Canonical sorry count:** unchanged. The reverse-map block added 10 axiom-clean decls /
  +0 sorry; the residual balancing is a documented comment, not a sorry.
- **Build:** GREEN. `StalkTensor.lean` compiles clean (LSP: 0 errors/warnings/infos;
  `grep sorry|admit|native_decide|^axiom` empty). `lean_verify` on the new and existing
  public decls returns `{propext, Classical.choice, Quot.sound}` only.
- **Blueprint-doctor:** CLEAN (no orphan chapters, no broken refs, no new axioms).
- **`sync_leanok`:** iter 235, sha `2cda42af`, +1 / −1, chapters_touched =
  `Picard_TensorObjSubstrate.tex` (the stage-(iii) `stalkTensorLinearMap` pin gained `\leanok`;
  one stale marker removed). No laundering — `stalkTensorIso` carries no `\leanok` (verified;
  the iso is not built).

## Target: stage (iv) reverse map of `lem:stalk_tensor_commutation` (d.2) — PARTIAL

This is the project's lead/critical-path lane (the d.2 varying-ring stalk–tensor commutation
`(A⊗ᵖB)_x ≅ A_x ⊗_{R_x} B_x`, Stacks `lemma-stalk-tensor-product`), the bottleneck that
unblocks `isLocallyInjective_whiskerLeft_of_W` → the unconditional associator → `thm:pic_commgroup`.

iter-234's review imposed a falsifiable gate: *dispatch stage (iv) as the WHOLE reverse map and
do NOT fragment into more sub-`stalkTensorDescU`-style helpers.* **The gate was met in spirit:**
the prover landed the entire nested double-colimit reverse descent as 10 cohesive,
axiom-clean `private` declarations — the natural structural decomposition of a double
`colimit.desc`, not peripheral helper churn:

1. `revInnerLeg` / `revInnerLeg_apply` — inner cocone leg `B(V) → (A⊗ᵖB).stalk x`,
   `b ↦ germ_{U⊓V}((a|)⊗(b|))`, evaluation `rfl`.
2. `revInner` — inner descent `B.stalk x ⟶ (A⊗ᵖB).stalk x` via `colimit.desc`; the cocone
   naturality is a substantive ~20-line sub-proof (germ_res + `tensorObj_map_tmul` +
   `Functor.map_comp` on each tensor factor + poset thinness). `germ_revInner` / `revInner_germ`
   = germ characterizations.
3. `revOuterLeg` / `revOuterLeg_apply` — outer cocone leg `A(U) →+ (B_x →+ St)`; additivity in
   `a` checked on germ generators via `add_tmul` / `zero_tmul`.
4. `revBihom` — outer descent `A.stalk x ⟶ AddCommGrpCat.of (B_x →+ St)` via the second
   `colimit.desc`; outer naturality mirrors (2). `germ_revBihom` / `revBihom_germ_tmul` give the
   key germ formula `revBihom (germ a) (germ b) = germ_{U⊓V}(a|⊗b|)`.

This is the full additive bilinear comparison `A_x →+ B_x →+ (A⊗ᵖB).stalk x` — the reverse half
of `stalkTensorIso`, paired with the stage-(iii) forward `stalkTensorLinearMap`.

### The sole residual — `revBihom_balanced` (and `stalkTensorRev`)

The balancing `revBihom (r•a) b = revBihom a (r•b)` (the condition feeding
`TensorProduct.liftAddHom` to produce `stalkTensorRev : A_x ⊗_{R_x} B_x →+ St`) was **not**
landed. The germ reduction fires completely — `rw [hrW, haW, hbW, ← germ_smul A, ← germ_smul B,
revBihom_germ_tmul, revBihom_germ_tmul]; congr 1` brings the goal to the section-level identity
`(A.map _ (r'•a')) ⊗ₜ (B.map _ b') = (A.map _ a') ⊗ₜ (B.map _ (r'•b'))` — but the final step
hits a **`restrictScalars` carrier-duality wall**: `PresheafOfModules.map_smul` produces a smul
over the `RingCat` carrier `(R ⋙ forget₂).obj (op (W⊓W))` on the `restrictScalars`-module, while
the section tensor is annotated over the `CommRingCat` carrier on the plain module, so
`TensorProduct.smul_tmul` cannot synthesize a `DistribMulAction` defeq to the inferred
`ModuleCat.instModuleCarrierObjRestrictScalars`.

Tried & failed (all the same synth/defeq wall): `exact smul_tmul _ _ _`;
`smul_tmul (R := ↑(R.obj (op (W⊓W))))`; `smul_tmul (R := ↑((R⋙forget₂).obj …))`;
`haveI := ModuleCat.isModule …` then `smul_tmul`; `rw`-based `smul_tmul` / `smul_tmul'`.

**Important nuance for the planner:** iter-234's review recorded the CommRingCat/RingCat
carrier-duality risk as "retired" by the stage-(iii) `stalkTensorDescU_smul` `erw`/defeq recipe.
That claim was *narrowly* true for stage (iii), but the balancing has an **extra `restrictScalars`
wrapper** (from `map_smul`) absent in `stalkTensorDescU_smul`, so the recipe does **not** transfer
verbatim. The risk is adjacent, not identical — it resurfaced in a slightly harder form. The
prover left a precise in-file handoff (lines 397–420) with two routes; **route 2 is recommended**:
prove the balancing at the *stalk level* `revBihom (r•a) b = r • revBihom a b` (St carries the
`R_x`-action from `ModuleCat.Stalk`) via the `T`-presheaf `germ_smul`, keeping the scalar at `R_x`
and avoiding the section-level smul entirely.

The gap is left as a **comment, not a sorry** — the file remains 0 sorries and axiom-clean.

## Subagent reviews (this iter)

- **lean-auditor `ts235`** (`task_results/lean-auditor-ts235.md`): 0 must-fix, 0 major, 3 minor.
  Confirmed all 10 reverse-map decls are genuine non-vacuous constructions with substantive
  cocone-naturality sub-proofs (not degenerate `colimit.desc` / collapsed maps / vacuous `rfl`);
  confirmed the `revBihom_balanced` gap is a pure comment (no stubbed decl); confirmed
  axiom-clean. Minors: docstring couples to Archon workflow vocabulary ("This iteration",
  "task_results"); the in-file handoff comment (L397–420) will go stale once the proof lands;
  pervasive `erw` for carrier-duality coercions is a maintenance fragility (individually justified).
- **lean-vs-blueprint-checker `stalktensor`** (`task_results/lean-vs-blueprint-checker-stalktensor.md`):
  0 must-fix, 1 major, 1 minor. The stage-(iv) Lean faithfully implements the blueprint's nested
  colimit reverse descent (no divergence); the two pinned public decls (`stalkTensorDesc`,
  `stalkTensorLinearMap`) match and are axiom-clean. **Major:** the `% NOTE:` on
  `lem:stalk_tensor_commutation` was stale (said "iter-234") and had a LaTeX typo ("No  is or
  should be") — **fixed by the review agent this iter** (see Blueprint markers below). **Minor:**
  the blueprint stage-(iv) prose does not describe the carrier-duality obstacle for the balancing;
  a plan-side blueprint-writer addition would help the next prover round.

## Key findings / patterns

- **The d.2 lane has produced concrete forward motion for THREE consecutive iters** (233 forward
  map, 234 `R_x`-linear packaging, 235 reverse-map descent). This is convergence on the lead lane,
  not churn — each iter landed a named stage axiom-clean with the prior iter's flagged risk retired.
- **But the absolute critical-path counter is flat for the 18th consecutive iter** (since iter-217,
  no canonical-sorry elimination on the Picard path). `stalkTensorIso` is still not built — the
  balancing + the stage-(v) mutual-inversion bundle remain.
- **The carrier-duality wall is the recurring d.2 obstacle**, and it is NOT fully "retired": it
  reappeared at the balancing with an extra `restrictScalars` wrapper. This is the single technical
  risk to watch.

## Recommendations (next plan iter)

See `recommendations.md`. Headline: keep d.2 as the lead lane and dispatch the balancing
(`revBihom_balanced` → `stalkTensorRev`) via the prover's **route 2** (stalk-level smul, `germ_smul`);
do NOT re-try the section-level `smul_tmul` route that failed this iter. Have a blueprint-writer add
the carrier-duality sub-obstacle note to stage (iv) before the prover round.

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation`: updated the stale `% NOTE:`
  (was "As of iter-234 … stage (iii)"; fixed the "No  is or should be on this block" LaTeX typo)
  to record the iter-235 state — stage (iv) reverse-map infra (`revInnerLeg`/`revInner`/`revOuterLeg`/
  `revBihom`/`revBihom_germ_tmul`) landed axiom-clean; remaining gap = `revBihom_balanced` +
  `stalkTensorRev`; stage (v) fully open. (No `\leanok` touched — the iso is still unbuilt.)

No `\mathlibok` added (no Mathlib re-export this iter); no `\lean{...}` renames (the prover added no
new pinned public decls — all 10 new decls are `private` internal infra); no stale `\notready` found.
