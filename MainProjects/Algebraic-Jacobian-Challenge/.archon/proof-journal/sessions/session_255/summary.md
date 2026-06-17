# Session 255 (review of iter-255)

## Metadata
- **Iteration:** 255 · two prover lanes, both `opus`, mode `prove`.
- **Files touched:** `Picard/TensorObjSubstrate.lean`, `Picard/TensorObjSubstrate/DualInverse.lean`.
- **Proof-body sorry count:**
  - `TensorObjSubstrate.lean`: **2 → 1** (closed `pullbackTensorMap_natural`; remaining = `exists_tensorObj_inverse` L712, out of scope, DEAD-END d.2 route).
  - `DualInverse.lean`: **2 → 2** (no net change; `homOfLocalCompat` L656 advanced, `dual_restrict_iso` L256 untouched/out of scope).
- **Build:** both files green under `lake env lean` (exit 0; only deprecation/style warnings).
- **`sync_leanok`:** ran at sha `9f86ac7b` (iter 255), **+30 / −0** across `Picard_RelPicFunctor.tex` + `Picard_TensorObjSubstrate.tex`. Strongly positive net — contrast the race-induced strips of 252/253.

## Headline outcome — the 4-iter zero-close streak is broken

iter-251 opened the M=2 substrate breadth; iters 251–254 each closed **zero** assigned targets.
**iter-255 closes one of its two assigned targets axiom-clean** — `pullbackTensorMap_natural` (D1′),
the TS-cmp lane's target across all of 251–254. This is a genuine, verified target close, not
helper-churn.

## Target 1 — `pullbackTensorMap_natural` (D1′) · SOLVED, axiom-clean

`lean_verify` → axioms `{propext, Classical.choice, Quot.sound}` (no `sorryAx`, no project axioms).
First-hand verified.

**Square 2 (δ-commutation) — the planner mapin255 LIGHT recipe, fired exactly as predicted.**
```lean
erw [← Functor.OplaxMonoidal.δ_natural
  (F := PresheafOfModules.pullback
    (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
      from (Hom.toRingCatSheafHom f).hom))
  a.val b.val]
dsimp only []      -- strips the cosmetic `have this := …; this` wrapper
```
The iter-254 prover claimed "there is no place to inject the instance into `δ_natural`'s domain-ring
argument." mapin255 (api-alignment consult, dispatched by the planner BEFORE the prover) **disproved
this live**: the injection point IS the `F :=` argument via a `show … from` ascription. NO structural
spelling-pin refactor was needed (iter-254 + pc255 both expected one). D2′ (`pullbackTensorMap_unit_isIso`)
untouched and green. This is the whisker252 pattern repeating: the pre-dispatch analogist consult caught
that the load-bearing refactor was unnecessary, saving a structural-refactor iter.

**Square 3+4 assembly — the genuinely new work this iter.** The hard part was merging the two `a_Y.map`s
across the `pullbackValIso` `.val`-vs-helper-`.obj` connecting-object boundary. That boundary is
defeq-but-not-syntactic and blocks **every** kabstract-based tactic (`rw [Category.assoc]`,
`Iso.cancel_iso_hom_left` as `rw`, `rw/erw [← Functor.map_comp]`, `congr_arg₂ (·≫·)` — all "pattern not
found"; `simp only [Category.assoc]` "no progress"; plain `congr 1` on the unmerged composite yields
`HEq`). The reusable recipe that bridges it:
- `erw [Category.assoc]` (NOT `rw`/`simp only`) right-associates across the gap.
- `erw [Iso.cancel_iso_hom_left]` peels the common `S3(M,N)` iso prefix across the gap.
- `refine ((Functor.map_comp _ _ _).symm.trans ?_).trans (Functor.map_comp _ _ _)` merges BOTH `a_Y.map`s
  into `a_Y.map (_ ≫ _) = a_Y.map (_ ≫ _)` via `isDefEq` — `refine`'s isDefEq is strictly stronger than
  `erw`'s keyed matching here (erw FAILS this merge).
- `congr 1` → presheaf-level `A ≫ B = C ≫ D`.
- Square 4: per-leg `hleg` (`rw [← map_comp]; erw [pullbackValIso_hom_natural]; rw [map_comp]; rfl`) +
  `MonoidalCategory.tensorHom_comp_tensorHom (C := …⋙forget₂…)` applied as a `(C:=…)`-pinned TERM, with
  `erw [hleg a, hleg b]` again bridging the `.val`/`.obj` gap.

lvb-tscmp255 (file-vs-blueprint): **CLEAN** — name/signature/proof all match `lem:pullback_tensor_map_natural`;
4-square sketch was adequate to guide formalization.

## Target 2 — `homOfLocalCompat` · PARTIAL (M-leg closed, f-leg bridge remains)

The iter-254 "carrier-duality ring-bridge" wall (sub-step (c) linearity) was **mis-decomposed**.

- **Attempt 1 (planner's literal recipe) FAILED.** `PresheafOfModules.map_smul M.val e₁` produces a smul
  over the *semilinear codomain* `(ModuleCat.restrictScalars (X.ringCatSheaf.map e₁)).obj (M.val.obj (op image))`
  — an `X(W)`-module — while the f-leg `(f i).val.app P`'s `map_smul` is over `restrictScalars 𝟙` — an
  `X(image)`-module. Different base rings; genuinely not defeq; rejected even under
  `backward.isDefEq.respectTransparency false`.
- **Attempt 2 (KEY FIX) closed the M-leg.** Use the Γ-level `Scheme.Modules.map_smul M`
  (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`) — stated at the native Γ-module level, NO
  `restrictScalars` artifact: `erw [Scheme.Modules.map_smul M]` fires and closes the M-leg. The obstacle
  is now narrowed from `restrictScalars e₁` (different base ring) to `restrictScalars 𝟙` (identity ring
  map, same base ring) — the cleanest possible mismatch. Bridge ingredients all named and verified to
  exist: `Scheme.Opens.ι_appIso = Iso.refl` ⇒ the `restrict` ring map is `𝟙`; reconcile with
  `ModuleCat.restrictScalars.smul_def` / `restrictScalarsId'App`.

lvb-dualinv255: **major blueprint gap** — the chapter labels sub-step (c) "sectionwise linearity —
mechanical," but it actually requires the native↔`restrictScalars 𝟙` smul bridge; only the Lean comment
documents the fix. Blueprint needs an update before the next dispatch.

## Target 3 — `dual_restrict_iso` Step-4 · NOT ENTERED (correctly gated)

Untouched per the reversing-signal guardrail (gated on `homOfLocalCompat` closing first). lvb-dualinv255
flagged a **major blueprint-vs-Lean mismatch**: the chapter frames Step-4 as Leg(A) Beck-Chevalley +
Leg(B) ring-iso transport, but the Lean uses H1 (adjunction uniqueness via
`pushforwardPushforwardAdj∘leftAdjointUniq`) leaving a *different* residual. A prover following the
blueprint legs will hit a structure mismatch — align the blueprint before dispatch.

## Subagent findings (this iter)

- **lean-auditor iter255** (1 must-fix / 4 major / 5 minor):
  - MUST-FIX: excuse-comment `"TO CLOSE (next iter):"` on the load-bearing `homOfLocalCompat` sorry
    (`DualInverse.lean:651`).
  - MAJOR: stale module-header status block (`TensorObjSubstrate.lean:41–43`) still lists
    `pullbackTensorMap_natural` as open — now closed; factually misleading.
  - MAJOR: `pullbackTensorMap_natural` carries five `.val`/`.obj` defeq workarounds + `maxHeartbeats 3200000`
    (16×) — correct today, brittle against upstream churn.
  - MAJOR: `set_option backward.isDefEq.respectTransparency false in` scopes the whole `homOfLocalCompat`
    declaration when only one sub-step needs it (`DualInverse.lean:441`).
  - Report: `.archon/task_results/lean-auditor-iter255.md`.
- **lvb-tscmp255**: CLEAN; 2 minor — `tensorObj_unit_iso` and `pullbackValIso` lack `\lean{...}` pins.
- **lvb-dualinv255**: 0 must-fix; 2 major blueprint gaps (sub-step (c) "mechanical" mislabel; Step-4
  Leg(A)/(B) vs H1 structure mismatch) — both feed blueprint-writer directives next iter.

## Blueprint doctor (iter-255)

- **`% archon:covers` problem:** chapter `Picard_LineBundleCoherence.tex` covers
  `AlgebraicJacobian/Picard/LineBundleCoherence.lean`, which **does not exist** (an engine chapter authored
  ahead of its Lean file — bw255-eng).
- **Broken cross-refs (the recurring `\leanok`-jammed-in-`\uses{}` corruption):**
  `Picard_RelPicFunctor.tex` → `\uses{\leanok thm:relative_pic_quotient_well_defined}`;
  `Picard_TensorObjSubstrate.tex` → five `\uses{\leanok lem:...}` (islocallyinjective_whiskerleft_via_stalk,
  leftadjointuniq_app_unit_eta, sheafify_tensor_unit_iso_natural, tensorobj_assoc_iso_invertible,
  tensorobj_comm_iso). All for the plan agent / blueprint-writer to fix.

## Blueprint markers updated (manual)
- None. No rename occurred (lvb confirmed `pullbackTensorMap_natural` name matches). `\leanok` is
  sync-managed (+30 this iter). No `\mathlibok` applies (both closed/advanced decls are Archon proofs, not
  Mathlib re-exports). No `\notready` present in the chapter.

## Key findings / patterns
1. **The pre-dispatch analogist consult keeps paying off.** Two iters running (whisker252, now mapin255),
   the analogist consult dispatched BEFORE the prover disproved a load-bearing refactor belief and supplied
   a one-line fix. The D1′ close is the direct payoff.
2. **`.val`/`.obj` connecting-object boundary recipe** (new, reusable): `erw[assoc]` to right-assoc across
   the gap; `erw[Iso.cancel_iso_hom_left]` to peel iso prefixes; a `refine`-chain of `Functor.map_comp`
   TERMS for the two-sided `a_Y.map` merge (isDefEq beats erw's keyed matching); `tensorHom_comp_tensorHom (C:=…)`
   as a pinned TERM for bifunctoriality.
3. **Carrier-correct `map_smul`** (new, reusable): for section-level linearity over varying rings, use the
   Γ-level `Scheme.Modules.map_smul` (native module action), NOT `PresheafOfModules.map_smul` (bakes a wrong
   `restrictScalars e₁` over a different base ring). This narrowed the homOfLocalCompat wall from a
   different-base-ring mismatch to an identity-ring-map mismatch.

## Recommendations for next session
See `recommendations.md`. Headlines: (1) close `homOfLocalCompat` with the named `restrictScalars 𝟙` bridge
(bounded, ingredients verified — do NOT re-attempt `PresheafOfModules.map_smul`); (2) blueprint-writer pass
on `Picard_TensorObjSubstrate.tex` for the two lvb-dualinv255 gaps + the doctor's broken-ref corruption +
the `LineBundleCoherence` covers/missing-file; (3) D1′ done → the pullback-monoidality lane's next open is
`exists_tensorObj_inverse` (DEAD-END d.2; needs the gluing route, not a re-attempt).
