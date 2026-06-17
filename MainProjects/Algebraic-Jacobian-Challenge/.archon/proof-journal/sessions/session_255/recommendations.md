# Recommendations — after iter-255 (for the iter-256 plan agent)

## CRITICAL / HIGH (from review subagents)

1. **[lean-auditor MUST-FIX] Strip the excuse-comment on the `homOfLocalCompat` sorry**
   (`DualInverse.lean:651`, `"TO CLOSE (next iter):"`). This is a `.lean` comment fix — fold it into the
   next TS-inv prover directive (the prover owns the file; review cannot edit `.lean`). Replace with the
   precise residual characterization, not a deferral note.

2. **[lean-auditor MAJOR] Fix the stale module-header status block** in `TensorObjSubstrate.lean:41–43`
   — it still lists `pullbackTensorMap_natural` as one of two open sorries; it is now CLOSED axiom-clean.
   Only `exists_tensorObj_inverse` (L712) remains. Fold into the next TS-cmp prover directive (or a cleanup
   pass).

3. **[lvb-dualinv255 MAJOR ×2 — blueprint] Dispatch a blueprint-writer on `Picard_TensorObjSubstrate.tex`**
   for two gaps before re-dispatching the DualInverse prover:
   - sub-step (c) of `homOfLocalCompat` is labelled "sectionwise linearity — mechanical," but the Lean
     shows it needs the native `Module Γ(X,image)` ↔ `restrictScalars 𝟙` smul bridge
     (`ModuleCat.restrictScalars.smul_def` + `(U i).ι.appIso = Iso.refl`). Update the prose.
   - Step-4 of `dual_restrict_iso` is framed as Leg(A) Beck-Chevalley + Leg(B) ring-iso transport, but the
     Lean uses H1 (adjunction uniqueness via `pushforwardPushforwardAdj∘leftAdjointUniq`) leaving a
     different residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`. Align the
     blueprint to the H1 route so a prover does not formalize the wrong decomposition.
   This is a HARD-GATE concern for both DualInverse decls — clear it (writer → green → scoped re-review
   fast-path) before the next DualInverse prover lane.

## Closest-to-completion target — prioritize

4. **`homOfLocalCompat` f-leg smul bridge** (DualInverse.lean L656) — the obstacle is now the cleanest
   possible mismatch: native action vs `restrictScalars 𝟙` (identity ring map, SAME base ring). All
   ingredient lemmas named and verified live: `Scheme.Modules.map_smul` (M/N legs, native — already wired
   in), `ModuleCat.restrictScalars.smul_def` / `restrictScalarsId'App`, `(U i).ι.appIso = Iso.refl`. The
   closing recipe is left in the file at the sorry. This is a **bounded** build (one small helper bridging
   native → `restrictScalars 𝟙`, then `erw[hfl]; erw[Scheme.Modules.map_smul N]; congr 1; rw [← comp_apply,
   ← Functor.map_comp]; simp`). Closing it makes `homOfLocalCompat` the first canonical close in the
   dual-inverse A-bridge in many iters and unlocks `dual_restrict_iso` Step-4.

   **DO NOT** re-attempt the M-leg via `PresheafOfModules.map_smul` — it bakes the wrong `restrictScalars e₁`
   over a different base ring and is a confirmed dead end (attempt 1 this iter).

## Blocked / do-not-reassign-as-is

5. **`dual_restrict_iso` Step-4** (DualInverse.lean L256) — keep gated on `homOfLocalCompat` AND on the
   blueprint Step-4 realignment (rec. 3). Do not dispatch until both are cleared.

6. **`exists_tensorObj_inverse`** (TensorObjSubstrate.lean L712) — the d.2 stalk-tensor route is a DEAD END
   per the in-file docstring + `informal/exists_tensorObj_inverse.md`; only the gluing route escapes. Do not
   re-assign without the structural gluing pivot. With D1′ now closed, the pullback-monoidality machinery
   (`pullbackTensorMap` + naturality + unit-iso) is in place to feed that route if/when the planner
   re-prioritizes it.

## Blueprint structural fixes (from blueprint-doctor iter-255)

7. **Broken cross-refs — the recurring `\leanok`-jammed-in-`\uses{}` corruption.** Six occurrences across
   `Picard_RelPicFunctor.tex` (1) and `Picard_TensorObjSubstrate.tex` (5: islocallyinjective_whiskerleft_via_stalk,
   leftadjointuniq_app_unit_eta, sheafify_tensor_unit_iso_natural, tensorobj_assoc_iso_invertible,
   tensorobj_comm_iso). A `\leanok` token is inside the `\uses{...}` argument and/or the label is undefined.
   Hand to a blueprint-writer/cleanup pass — this has recurred for several iters and should be fixed at the
   source (likely a writer copy-paste pattern).

8. **`% archon:covers` dangling file.** Chapter `Picard_LineBundleCoherence.tex` covers
   `AlgebraicJacobian/Picard/LineBundleCoherence.lean`, which does not exist (engine chapter authored ahead
   of its Lean file). Either scaffold the Lean file or adjust the covers declaration so the dispatch gate is
   not mis-routed.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)

- **`.val`/`.obj` connecting-object boundary** (when an iso typed on `…ringCatSheaf.val` meets a `.obj`-normalised
  helper): `erw[Category.assoc]` to right-assoc across the gap; `erw[Iso.cancel_iso_hom_left]` to peel iso
  prefixes; a `refine`-chain of `Functor.map_comp` TERMS to merge two functor-applications via isDefEq (erw's
  keyed matching fails this); `congr 1` to descend to the presheaf level; `tensorHom_comp_tensorHom (C:=…)` as a
  pinned TERM for bifunctoriality.
- **Carrier-correct section linearity over varying rings:** use Γ-level `Scheme.Modules.map_smul` (native module
  action), NOT `PresheafOfModules.map_smul` (semilinear codomain bakes a wrong `restrictScalars` over a different
  base ring).
- **Pre-dispatch analogist consult on a suspected structural refactor** (whisker252, mapin255): two iters running,
  it disproved the refactor and supplied a one-line fix. Continue dispatching the analogist BEFORE committing a
  load-bearing refactor.

## Process note

The 4-iter zero-close streak (251–254) is broken: D1′ closed axiom-clean. The TS-cmp pullback-monoidality lane
has now delivered D2′ (iter-250) + D1′ (iter-255). The remaining substrate frontier is concentrated in
DualInverse (`homOfLocalCompat` → `dual_restrict_iso` → `exists_tensorObj_inverse`). Prioritize closing
`homOfLocalCompat` (bounded, rec. 4) over opening new breadth.
