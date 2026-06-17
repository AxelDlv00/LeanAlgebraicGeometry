# Recommendations for iter-257 (from session 256 review)

## CRITICAL / must-fix-this-iter (HARD GATE on the two affected files)

These block prover dispatch on their files until the blueprint is corrected (the plan-phase HARD GATE).

1. **Blueprint-writer on `Picard_TensorObjSubstrate.tex` — D3′ (`lem:pullback_tensor_map_basechange`) BEFORE any
   prover pass on `TensorObjSubstrate.lean`.** (lvb-tensorobj256, 2 must-fix; the prover's own recommendation.)
   - The chapter statement is the open-immersion **base-change-square** form; the Lean decl
     `pullbackTensorMap_restrict` proves the **general composition coherence** (any `h : Z⟶Y`, `f : Y⟶X`).
     Realign the statement to the general form, noting the base-change square as a corollary.
   - Remove the "proved by the same mate calculus as `pullbackObjUnitToUnit_comp`" framing — it is
     **disproven** (`pullbackTensorMap` is NOT an adjunction transpose; the mirror's `homEquiv.injective`
     opening stalls). State explicitly that the route is a 4-square `comp_δ` build.
   - Name the two absent project sub-lemmas (Sq1 `sheafificationCompPullback`-composition-coherence,
     Sq4 `pullbackValIso`-composition-coherence) + the Sq2 ring-map reconcile
     (`toRingCatSheafHom (h≫f).hom = φ'_f ≫ whiskerLeft φ'_h`, defeq-not-syntactic via `Opens.map_comp`).
   - A `% NOTE:` flagging this is already in the chapter (review iter-256); the writer should resolve it.
   - **After the writer + green build**, re-run lean-vs-blueprint-checker scoped to this chapter (fast path) to
     clear the gate, then a prover may build Sq1/Sq4/Sq2. **Do NOT re-dispatch the "mirror" recipe.**
   - Optionally dispatch a **mathlib-analogist** (api-alignment) on the `PresheafOfModules.pullbackComp`
     composition-coherence pattern before the prover, to pre-verify the `comp_δ` decomposition path.

2. **Blueprint-writer on `Picard_LineBundleCoherence.tex` BEFORE the next prover pass on `LineBundleCoherence.lean`.**
   (lvb-linebundle256, 2 must-fix + 1 major; auditor 1 major.)
   - **Remove the false proof-block `\leanok` at tex:187** (chartPresentation proof block; Lean body is `sorry`).
     NOTE: this can only be durably corrected once the file is imported (item 3) so sync_leanok can manage it.
   - Specify the **finiteness route** for `isFinitePresentation`: `chartPresentation` returns a bare
     `(M.over U).Presentation` (no `IsFinite`). The chapter must say to build it via `Presentation.ofIsIso e.hom`
     applied to the canonical finite presentation of `SheafOfModules.unit`, so `(chartPresentation …).IsFinite`
     is inferred automatically — OR add a 6th declaration `chartPresentation_isFinite` / strengthen the return
     type. Decide and pin it.
   - Address `chart_free_rank_one` (`lem:lbc_rank_flat`): the Lean type is a pointwise restatement of
     `IsLocallyTrivial M` (proof `exact hM x`); the pin name claims rank/flatness content the type lacks.
     Either accept it as the trivial chart-iso record (and soften the prose) or strengthen the type.
   - Soften `cor:lbc_isFiniteType` prose: `IsQuasicoherent` follows from `isFinitePresentation` via a Mathlib
     instance — no separate named theorem needed.

## HIGH — planner mechanical action (no prover)

3. **Import `LineBundleCoherence.lean` into `AlgebraicJacobian.lean`** (currently absent — verified). This:
   - puts the file in the loop build and `blueprint/lean_decls`;
   - lets `sync_leanok` correctly manage the new chapter's markers (and strip the false proof-`\leanok` at tex:187);
   - clears the (prior) doctor `covers`→file lint for `Picard_LineBundleCoherence.tex`.

4. **Reflow the `\uses{}` at `Picard_RelPicFunctor.tex:144-146`** so the sync-inserted `\leanok` cannot land
   inside the braces (the recurring broken-cross-ref the doctor flags). The target label
   `thm:relative_pic_quotient_well_defined` is fine (`Picard_LineBundlePullback.tex:331`); the bug is purely the
   stray `\leanok` between the def list and the thm in the multiline `\uses`.

5. **Verify the `\leanok` sync gap** on the three closed axiom-clean proof blocks (`homOfLocalCompat`, D1′, D2′)
   — proof-`\leanok` is absent despite sorry-free axiom-clean Lean (verified first-hand). Likely the recurring
   race/stale-olean strip; a clean re-sync (post-import, item 3) should restore them. Not a Lean regression.

## MEDIUM

6. **`TensorObjSubstrate.lean:41-54` status block** undercounts open sorrys ("ONE residual" → actually TWO now
   that `pullbackTensorMap_restrict` is scaffolded). The prover owns this file; ask the next prover to correct it
   (cosmetic, but a planner reading the header miscounts obligations).

## Closest-to-completion / promising for iter-257

- **`exists_trivializing_cover` + `chart_free_rank_one`** (LineBundleCoherence) are near-trivial bodies
  (`I := X` repackaging; `exact hM x`) — easy first closes once the chapter is corrected + file imported.
- **`exists_tensorObj_inverse`** (TensorObjSubstrate.lean:715) now has its **A-bridge** (`homOfLocalCompat`)
  landed. Its remaining gate is the **C-bridge** `dual_restrict_iso` Step-4 (DualInverse.lean:259) — see below.

## Blocked / DO NOT re-assign the same approach without a structural change

- **`dual_restrict_iso` Step-4 (DualInverse.lean:259)** — the presheaf residual
  `(pushforward β)(dual M.val) ≅ dual((pushforward β) M.val)`. Long-standing structural hard wall (the
  open-immersion slice-site Hom base-change + ring-iso reconciliation). The prover correctly did NOT enter it
  this iter (guardrail). **Do NOT re-dispatch it bare** — it needs a recipe / mathlib-analogist consult first
  (the iter-257 escalation path the planner already armed). It is the sole remaining C-bridge for the ⊗-inverse.
- **D3′ "mirror `pullbackObjUnitToUnit_comp`" recipe** — DISPROVEN this iter. Do NOT re-issue it; use the
  comp_δ/Sq1/Sq4/Sq2 route after the blueprint fix (item 1).

## Reusable proof pattern discovered (also in PROJECT_STATUS Knowledge Base)

- **native ↔ `restrictScalars 𝟙` smul bridge** over buried `.val.obj` instances:
  `erw [ModuleCat.restrictScalars.smul_def']` (only this fires; `rw`/`simp [restrictScalars.smul_def]` do not)
  + **full** `simp [Scheme.Opens.ι_appIso]` to collapse `β → 𝟙` + `rfl`. Scalar reconcile on the thin `Opens`
  poset: `ConcreteCategory.congr_hom (congrArg X.presheaf.map (Subsingleton.elim _ (𝟙 (op W)))) _` as a TERM
  (`rw [Subsingleton.elim …]` fails, LHS metavar); kill `CommRingCat.Hom.hom (𝟙 R)` via `← X.presheaf.map_id`.
