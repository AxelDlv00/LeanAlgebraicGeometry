# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of the three seed declarations
+ kernel-only axioms**, for the **Line-Bundle Comparison Iso** subproject
(A.1.c.sub of the Algebraic-Jacobian-Challenge). Seeds:

- `lem:pullback_tensor_iso_loctriv` — `pullbackTensorIsoOfLocallyTrivial` (D3′; SCAFFOLD, not in Lean yet)
- `lem:dual_isLocallyTrivial` — `dual_isLocallyTrivial` (DUAL route, in `DualInverse.lean`)
- `thm:rel_pic_addcommgroup_via_tensorobj` — `PicSharp.addCommGroup_via_tensorObj` (consumer; SCAFFOLD)

**Completeness audit (user-requested):** the three-seed cone is COMPLETE vs the AJC parent — all 108
cone nodes present, local cone sizes match AJC exactly (52/36/32), `DualInverse.lean` carries all 18
AJC decls (+1). The only Lean diffs are AJC's dead `extendScalars`/`pullback0`/`pullbackLanDecomposition`
Lan block (never referenced downstream — do NOT port) and out-of-scope Route-A representability. Nothing
required is missing; the remaining work is the same frontier `sorry`s AJC itself has not closed.

## Build state

ALL modules GREEN — `lake build` exit 0 (8323 jobs). **iters 008 AND 009 were verified no-ops**
(both prover lanes died at session start on the `fable-prover` model; 0 edits each) → state is
byte-identical to the iter-007 end state; the recipes below were validated on the iter-007 forward
square but the 008/009 re-dispatches never executed. **iter-010 FIX:** the plan agent switched the
prover role off the crashing `fable` model — `config.json` `loop.roles.prover` override removed so
the prover now inherits `loop.model: opus` (the proven-working default plan/review run on). Both
lanes execute this iter. DUAL layout + open sorries:
- **`DualInverse/SliceTransport.lean`** (733 LOC) — `sliceDualTransport`/`sliceDualTransportInv` +
  ring-swap helpers. **3 real, dispatchable sorries**: `sliceDualTransportInv.naturality` (**L444, ROOT**),
  `sliceDualTransport.left_inv` (L724), `.right_inv` (L726). The forward `sliceDualTransport.toFun.naturality`
  (+ map_add/map_smul) was CLOSED via the morphism-level recipe.
- **`DualInverse.lean`** (638 LOC) — `dual_restrict_iso`, `dual_unit_iso`, `dual_isLocallyTrivial`,
  `homOfLocalCompat` etc.; sorry-FREE (consumes SliceTransport).
- **`TensorObjSubstrate.lean`** GREEN, 3152 LOC, 2 sorries: L712 `exists_tensorObj_inverse` (deferred,
  import-cycle); L3144 `pullbackTensorMap_restrict` (Sq3/Sq4 paste — 3 blueprint bricks ready to scaffold).
Repository has a single commit; all iter work is uncommitted working tree.

**Blueprint HARD GATE cleared this iter** for `Picard_TensorObjSubstrate.tex` (covers both objective
files): the DUAL `lem:slice_dual_transport_inv` block had its `hβ` hypothesis + step-(b) naturality
prose + 4th `unitRelabelSwap` leg fixed (blueprint-writer), and a scoped re-review returned the chapter
adequate for both lanes. D3′ bricks confirmed adequate for formalization.

## Current Objectives

1. **`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean`** — **DUAL route,
   `prove` mode. progress-critic = CONVERGING.** Blueprint: `chapters/Picard_TensorObjSubstrate.tex`
   (`lem:slice_dual_transport`, `lem:slice_dual_transport_inv`). **Recipe: `analogies/dualnat006.md`
   + the now-closed forward `sliceDualTransport.toFun.naturality` is the working template — mirror it.**
   GREEN file, 3 typed sorries; fill in dependency order:
   - **(ROOT, do FIRST) `sliceDualTransportInv.naturality` (L444).** This is the mirror of the
     already-closed forward naturality square; all helpers are now in place. **NEVER apply
     `inv ε` (`dualUnitRingSwap`) pointwise** — `ext z; simp [..., dualUnitRingSwap_apply]` forces
     `whnf` on the deep `inv ε` composite → heartbeat timeout (documented dead end). Rotate
     MORPHISM-LEVEL: `apply PresheafOfModules.hom_ext; intro W;` then
     `haveI := isIso_ε_restrictScalars_appIso f _; rw [IsIso.inv_comp_eq]` to push the `inv ε`
     edge to the RHS → goal becomes the FORWARD `ε`-naturality square. Close by gluing
     `φ.naturality i.op` to the ε-leg, exactly as the forward square does, through the proven
     pointwise lemmas `appIso_hom_naturality_apply` + `dualUnitRingSwap_apply`
     (NOT through a deep `inv ε` composite). Re-use `restrictScalarsComp'App`/`restrictScalarsId'App`
     [verified — file already uses them in the `collapse` step].
   - **(then) `sliceDualTransport.left_inv` (L724) + `.right_inv` (L726)** — `hom_inv_id` round-trips
     that unblock once the inv-naturality root lands (the inverse is built from `sliceDualTransportInv`).
     Use `PresheafOfModules.hom_ext` / the linear-equiv round-trip — NOT `ext z` on the `∀`-typed goal.
   - **RACE MITIGATION:** imports `TensorObjSubstrate.lean` (objective 2 this iter). Do NOT change any
     exported signature; commit only compiling states (typed sorry acceptable for a field that does not
     close — never hand back RED).
   - **Bar:** close the ROOT (L444) by mirroring the forward template, then propagate to L724/L726.
     Attempt the body — the recipe is concrete and was validated on the forward square last iter.

2. **`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`** — **D3′ route, `prove` mode. progress-critic
   = CONVERGING. Blueprint gate CLEARED (D3′ bricks adequate).** Blueprint:
   `chapters/Picard_TensorObjSubstrate.tex` (`lem:sheafify_pullbackcomp_hom_inv_cancel`,
   `lem:sheafify_tensor_unit_iso_comp`, `lem:pullback_val_iso_comp`, `lem:pullback_tensor_map_basechange`).
   The 3 bricks do NOT exist in Lean yet — **introduce each declaration (signatures from the chapter
   `\lean{}` pins) then prove it, bottom-up:**
   - **`sheafifyMap_pullbackComp_hom_inv_id`** (`lem:sheafify_pullbackcomp_hom_inv_cancel`) — easiest;
     `a_Z.map(PrPbComp.hom.app T) ≫ a_Z.map(PrPbComp.inv.app T) = id` via `Iso.hom_inv_id_app`
     [verified] + `Functor.map_comp`/`Functor.map_id`. No project `\uses{}`.
   - **`sheafifyTensorUnitIso_comp`** (Sq3, `lem:sheafify_tensor_unit_iso_comp`) — reduce hom-legs via
     `sheafifyTensorUnitIso_hom_eq'` (in file, [verified]) to one `a.map(η ⊗ η)`; composite-vs-interleaved
     = `a_Z.map` of η-naturality against `PrPbComp`, recombined by `⊗` bifunctoriality. Splice with `erw`
     (Sheaf.val Z carrier mismatch — `rw` won't fire).
   - **`pullbackValIso_comp`** (Sq4, `lem:pullback_val_iso_comp`) — substitute
     `pullbackValIso = sheafCompPb⁻¹ ≫ counit`; the `sheafCompPb⁻¹` parts reassemble by
     `sheafificationCompPullback_comp` (Sq1 twin, in file), the counit parts by counit naturality across
     `pullbackComp h f`. Splice with `erw`.
   - **(then) `pullbackTensorMap_restrict` (L3144)** — replace the typed sorry by the interleaved
     four-square merge using the 3 bricks + the cancellation, per the chapter proof of
     `lem:pullback_tensor_map_basechange`. Attempt the body — recipe is concrete. Partial progress
     (bricks proved, paste partially assembled) > a re-pinned sorry.
   - **RACE MITIGATION:** keep all existing exported signatures unchanged; commit only GREEN states.

(`exists_tensorObj_inverse` (L712) stays deferred — closes via the DUAL chain once SliceTransport is
sorry-free. Consumer `RelPicFunctor.lean` stays BLOCKED on both routes.)

## Standing deferrals

- **Scaffold targets (decls do not exist yet — NOT fill-sorry):** `pullbackTensorIsoOfLocallyTrivial`
  (seed 1), `pullback_tensorObj_iso` (`lem:pullback_compatible_with_tensorobj`),
  `PicSharp.addCommGroup_via_tensorObj` (seed 3). Build these AFTER their cones close. (Both
  scaffold seeds are also absent from AJC's Lean — local is not behind.)
- **Import architecture (in scope):** `LineBundlePullback → TensorObjSubstrate → SliceTransport →
  DualInverse`; `TensorObjSubstrate → RelPicFunctor` (no cycle).
- **Dual bridge directions:** FORWARD `IsInvertible⟹IsLocallyTrivial` is Mathlib-scale + off-path
  (do NOT build). REVERSE `IsLocallyTrivial⟹IsInvertible` (`exists_tensorObj_inverse`) closes via the dual chain.
- **`RelPicFunctor.lean`** — `addCommGroup`/`functorial` bodies gated on the dual chain + D4′;
  re-open once the substrate closes. Consumer holds the third seed.
- **AJC Lan-decomposition block** (`extendScalars`/`pullback0`/`pullbackLanDecomposition`) —
  NOT ported: confirmed dead code in AJC (never used downstream); not in any seed cone. Do not add.
- **Coverage debt:** ~97 `lean_aux` decls with no blueprint entry (`leandag unmatched`); blueprint-reviewer
  dispositioned non-blocking. Dedicated `Coverage + file-split cleanup` phase (STRATEGY): author blocks
  for load-bearing helpers, mark genuine internals `private`; also split `TensorObjSubstrate.lean`
  (3152 LOC) per user policy on >1000-LOC files. Not gate-blocking.
- **Extraction note:** module names, file paths, blueprint labels unchanged from the parent so
  proved seeds merge back cleanly. Sibling extracts (Cech-Cohomology, Quot-Foundations) cover the
  disjoint A.2.c-engine cones — out of scope here.
