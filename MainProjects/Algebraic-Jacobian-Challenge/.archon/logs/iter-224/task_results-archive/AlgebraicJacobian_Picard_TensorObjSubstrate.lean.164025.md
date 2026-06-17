# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-224

## PRIMARY: `PresheafOfModules.internalHomEval` naturality `sorry` (L1463) — **RESOLVED**

### Headline
The iter-222/223 **`whnf` heartbeat-bomb diagnosis was STALE** (Mathlib update). There is
**no bomb anymore**: every default-transparency rewrite returns instantly. The naturality
`sorry` is CLOSED axiom-clean. **Neither ROUTE A (`with_reducible`) nor ROUTE B (`unit`-reshape)
was needed** — a plain `erw`-based six-step reduction goes straight through.

### Attempt 1 — ROUTE A probe (analogist recipe) → discovered the bomb is gone
- **Approach:** wrap rewrites in `with_reducible` per the ts224dual recipe.
- **Result:** `with_reducible simp only [...]` runs but the lemmas don't fire at reducible
  transparency (only beta-reduction). BUT: plain `rw [ModuleCat.hom_comp]` (default transparency,
  the supposedly-bombing tactic) **returns instantly with "pattern not found"** — NOT a heartbeat
  timeout. Confirmed: `erw [ModuleCat.hom_comp, ModuleCat.hom_comp]` splits the composition cleanly,
  no bomb. **The iter-223 bomb is gone** — the premise of the whole ts224dual escalation is stale.

### Attempt 2 — direct six-step reduction → RESOLVED
- **Approach:** the worked six-step reduction recorded in-source, run with `erw`.
- **Result:** RESOLVED, axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **Proof skeleton:**
  ```
  intro X Y f
  refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)
  erw [ModuleCat.hom_comp, ModuleCat.hom_comp, LinearMap.comp_apply, LinearMap.comp_apply,
    internalHomEvalApp_tmul, internalHomEvalApp_tmul]   -- splits comp; LHS ⇒ evalLin form
  simp only []                                          -- beta-reduce (s,φ).1/.2 ⇒ s, φ
  change M.evalLin Y ((M.dual.map f) φ) ((M.map f) s)
    = ((𝟙_ …).map f).hom (M.evalLin X φ s)              -- RHS reduces by defeq (tmul = rfl)
  have key := PresheafOfModules.naturality_apply
    (φ : restr X.unop M ⟶ restr X.unop (𝟙_ …))
    (Over.homMk f.unop : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op s
  rw [restr_map_homMk, restr_map_homMk] at key          -- (restr _).map (homMk).op = base map
  have hdt : M.evalLin Y ((M.dual.map f) φ) = (φ.app (op (Over.mk f.unop))).hom :=
    congrArg ModuleCat.Hom.hom
      (eq_of_heq (hom_app_heq (φ : …) (congrArg op (congrArg Over.mk (Category.id_comp f.unop)))))
  exact (DFunLike.congr_fun hdt _).trans key
  ```
- **Key insights:**
  - `erw [internalHomEvalApp_tmul]` collapses the LHS in one step — its defeq matching sees through
    `restrictScalars` and `tensorObj_map_tmul` automatically.
  - The RHS `((𝟙_).map f).hom ((internalHomEvalApp M X)(s ⊗ₜ φ))` reduces to
    `((𝟙_).map f).hom (evalLin M X φ s)` purely by **defeq** (`internalHomEvalApp_tmul := rfl`),
    so a single `change` exposes the clean goal — no unit-map `rw` (`tensorUnit_map`,
    `unit_map_apply` etc. were never needed; `PresheafOfModules.Monoidal.tensorUnit_map` and
    `unit_map_apply` are in fact unknown constants).
  - `restr_map_homMk` rewrites both further-restrictions to the base maps `M.map f` / `(𝟙_).map f`.
  - `hdt` identifies `(dual.map f φ).app(terminal Y)` with `φ.app(op (Over.mk f.unop))` — the
    over-objects `Over.mk (𝟙 Y.unop ≫ f.unop)` and `Over.mk f.unop` share source `Y.unop`, so the
    `app`s have defeq types and `eq_of_heq (hom_app_heq …)` extracts an honest `Eq`.

### Verification
- `lean_verify PresheafOfModules.internalHomEval` = `{propext, Classical.choice, Quot.sound}`.
- Zero errors in the file (`lean_diagnostic_messages severity=error` → `[]`).
- Project sorry 81 → 80. **Sub-step 3 RETIRED.**

## Ride-along comment updates (done, comment-only)
- (a) file-header `## Status` block: dropped to 3 residuals
  (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`, `isLocallyInjective_whiskerLeft_of_W`);
  replaced the iter-223 whnf-bomb narrative with the iter-224 close note.
- `internalHomEval` docstring: rewritten to record the close + the stale-bomb finding.
- in-body proof comment: replaced the bomb block with the iter-224 step comments.
- (b) `tensorObj_assoc_iso` docstring: "iter-212 typed sorry" → "CLOSED at direct-sorry level,
  sorry-transitive only via `isLocallyInjective_whiskerLeft_of_W`".
- (c) `tensorObjOnProduct` docstring: "iter-202 scaffold typed sorry" → "Complete (no sorry)".
- (d) `exists_tensorObj_inverse` inline: "no internal-hom" → "no **sheaf-level** internal-hom/dual/
  evaluation (the **presheaf-level** ones now exist axiom-clean)".

## Summary
- **Sorry count: 81 → 80** (file-local code sorries 4 → 3).
- **Closed:** `PresheafOfModules.internalHomEval` (naturality field).
- **Still open (per directive, FORBIDDEN to touch this iter):**
  `isLocallyInjective_whiskerLeft_of_W` (L641, route-e stalk residual),
  `exists_tensorObj_inverse` (sub-step 5, sheaf-level dual — genuinely Mathlib-absent),
  `addCommGroup_via_tensorObj` (RPF consumer, gated on the inverse).
- **Adjacent sorries:** not attempted — all three are explicitly FORBIDDEN this iter (sub-step 5 /
  RPF consumer / route-(e) which needs the d.2 stalk-⊗ commutation, a separate Mathlib-absent build).

## Why I stopped
**Real progress:** closed 1 sorry (`internalHomEval` naturality), axiom-clean, 81→80, sub-step 3
retired. The job is done at the assigned boundary.

**Important finding for the planner:** the entire iter-222/223/224 `whnf`-bomb premise (and the
ts224dual analogist escalation built on it) was **STALE** — a Mathlib update removed the bomb. No
transparency hack or `unit`-reshape was required; the plain six-step reduction the prior provers had
already worked out just compiles now. The blueprint `lem:internal_hom_eval` math was correct all
along; only the Lean-tactical obstacle was illusory by this iter.

The 3 remaining file sorries are all explicitly off-limits this iter. `exists_tensorObj_inverse` is
the genuine remaining infra block (sheaf-level dual/evaluation — `MonoidalClosed (SheafOfModules R)`
is Mathlib-absent; the presheaf-level `internalHom`/`dual`/`internalHomEval` now exist and are the
raw material, but the sheafification + sheaf-level counit + object descent are unbuilt). Sub-step 4
(sheaf condition `lem:internal_hom_isSheaf`) is the natural next frontier and does not depend on the
eval morphism.
