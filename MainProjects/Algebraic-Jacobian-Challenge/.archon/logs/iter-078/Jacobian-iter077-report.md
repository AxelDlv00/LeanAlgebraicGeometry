# AlgebraicJacobian/Jacobian.lean — iter-077 Lane 3 REPAIR

**Result:** RESOLVED. File compiles cleanly (no errors). Sorry count: 1 → 1 (the single
`nonempty_jacobianWitness` sorry at L179 preserved). AbelJacobi.lean now also compiles
cleanly (cascade resolved).

## Errors repaired (6 → 0)

### L207 / noncomputable modifier
- **Approach:** Added `noncomputable` to `instance instGrpObj : GrpObj (Jacobian C) := (jacobianWitness C).grpObj`.
- **Result:** RESOLVED. The three Prop-valued instances (`smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) do NOT need `noncomputable` — only `instGrpObj` (which is data, since `GrpObj` is a data-carrying class) needs it. Verified by recompiling.

### L121 / intro pattern mismatch in `geometricallyIrreducible_id_Spec`
- **Approach 1 (initial):** Replaced the `constructor; intro x K _ y Z fst snd h` pattern with the structure-field syntax `GeometricallyIrreducible … where geometrically_irreducibleSpace := by intro K _ y Z fst snd h`. Removed one extra `intro` (the original code had 8 binders but the field type only has 7).
- **Issue:** The downstream `rw [ObjectProperty.prop_iff_of_iso (IrreducibleSpace ·) (asIso snd)]` then failed with `failed to synthesize TopologicalSpace x✝` because `(IrreducibleSpace ·)` couldn't be typed without an explicit `P : ObjectProperty Scheme` annotation.
- **Approach 2 (final):** Replaced `rw + infer_instance` with a direct `ObjectProperty.prop_of_iso` application carrying the explicit type annotation:
  ```lean
  exact ObjectProperty.prop_of_iso (P := (IrreducibleSpace · : ObjectProperty Scheme))
    (asIso snd).symm inferInstance
  ```
  The `.symm` is needed because `snd : Z ⟶ Spec K`, but we want to transfer `IrreducibleSpace (Spec K)` (the existing Mathlib instance for `Spec` of a field) to `IrreducibleSpace Z`.
- **Result:** RESOLVED.

### L57/L59/L67/L71 / `IsAlbanese` parser cascade + Field auto-binding
This was the trickiest. The **root cause** is NOT what the plan agent's hint guessed (variable propagation through namespace): it's that **`ι` is a Mathlib scoped notation** for `GrpObj.inv`, declared in `Mathlib.CategoryTheory.Monoidal.Grp_`:

```lean
@[inherit_doc] scoped notation "ι" => GrpObj.inv
```

Since our file opens `MonObj` (where this scoped notation lives), the binder `(ι : C ⟶ J)` in `IsAlbanese`'s body is reinterpreted as the notation, causing `unexpected token 'ι'; expected '_' or identifier`.

- **Fix 1 (`IsAlbanese`):** Renamed the existential binder `ι` to `α` (still mathematically meaningful — `α : C ⟶ J` for the universal Albanese morphism). Also changed `(P : 𝟙_ _ ⟶ C)` to `(P : 𝟙_ (Over (Spec (.of k))) ⟶ C)` (mirror of `AbelJacobi.lean`'s explicit form) and renamed the second-conjunct hypothesis `(hf : ...)` to `(_ : ...)` since it's only used by `∃!`.
- **Fix 2 (`namespace IsAlbanese` declarations):** Added explicit `{k : Type u} [Field k]` binders to `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`, and `unique`. The plan agent's hint was correct that the outer `variable {k : Type u} [Field k] (C : Over ...) ...` is not propagating into the namespace; the explicit binders fix the `Field ?m.38` stuck errors at L67/L71.
- **Result:** RESOLVED. All five `IsAlbanese`-related errors gone.

### L90/L91 / cascade from L57-L71
- **Result:** RESOLVED automatically once L57/L67/L71 were fixed.

### L101/L109/L113 / `Eq.symm` direction in `unique`
After the rest compiled, three new errors surfaced from the existing `unique` proof body (these were latent under the L57-L71 cascade and not previously visible):

- `hg₁_unique (g ≫ h) ?_ : g ≫ h = g₁` (NOT `g₁ = g ≫ h`). So `.symm` was reversing in the wrong direction. **Fix:** removed the three offending `.symm`s on L101, L109, L113.
- Additionally the `rw [Category.assoc, hg_eq, hh_eq]` was rewriting in the wrong direction — the unbeta-reduced goal had `h₁.ofCurve ≫ (g ≫ h)`, not `(_ ≫ _) ≫ _`. **Fix:** added `change h₁.ofCurve = h₁.ofCurve ≫ (g ≫ h)` (beta-reduces the lambda from `∃!` unfolding) and used `rw [← Category.assoc, ← hg_eq, ← hh_eq]`.
- **Variable shadowing**: the inner `have ⟨h₂, hh₂_eq, hh₂_unique⟩ := ...` shadowed the outer `h₂ : IsAlbanese C P J₂`. After the shadowing, `h₂.ofCurve` no longer resolved. **Fix:** renamed the inner morphism to `k₂` (with `hk₂_eq`, `hk₂_unique`, `hhg_eq_k₂`, `k₂_eq_id`).
- Switched the final `use g; refine ⟨..., ?_⟩; intro; exact ...` to a direct `exact ⟨g, hg_eq, fun g' hg' => hg_unique g' hg'⟩` to avoid `use`'s auto-closing behaviour.
- **Result:** RESOLVED.

## Protected signatures preserved

All five protected declarations are byte-for-byte unchanged at the signature level. The only body-level changes:
- `AlgebraicGeometry.Jacobian` (L199–201): unchanged.
- `AlgebraicGeometry.Jacobian.instGrpObj` (L209): added `noncomputable` prefix only (allowed per `archon-protected.yaml` — body-level change).
- `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus` (L213): unchanged.
- `AlgebraicGeometry.Jacobian.instIsProper` (L217): unchanged.
- `AlgebraicGeometry.Jacobian.instGeometricallyIrreducible` (L220): unchanged.

(The protected declarations in `AbelJacobi.lean` — `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` — were not touched.)

## Final state

- **Sorry count:** 1 (L179 `nonempty_jacobianWitness` — the deferred Phase-C-C3 existence).
- **Errors:** 0.
- **Warnings:** 1 (`declaration uses sorry` at L179) + 1 pre-existing long-line warning at L199 (inside the protected `Jacobian` signature — not introduced by this edit).
- **AbelJacobi.lean cascade:** RESOLVED. `lake env lean AlgebraicJacobian/AbelJacobi.lean` returns no output.

## Key insight for future iterations / plan agent

**The L59 parser-recovery error was NOT a cascade from L67/L71** as the plan agent guessed. It was a Mathlib namespace-collision issue: opening `MonObj` brings the scoped notation `ι` (for `GrpObj.inv`) into the parser, breaking any subsequent binder named `ι`. **Dead-end warning:** any future code in this file (or any other file opening `MonObj`) must avoid naming binders/variables `ι`. Use `α`, `φ`, `j`, or `i` instead.

The plan agent's hint about variable auto-binding was correct for L67/L71 only; the L59 error stood independently.

## Mathlib leverage used

- `ObjectProperty.prop_of_iso` (Mathlib `CategoryTheory.ObjectProperty.ClosedUnderIsomorphisms`) — replaced the `rw [prop_iff_of_iso]` chain.
- `IsClosedUnderIsomorphisms (C := Scheme) (IrreducibleSpace ·)` instance from `Mathlib.AlgebraicGeometry.Properties` — enables the transfer.
- `IrreducibleSpace (Spec R)` for `R : CommRingCat` `[IsDomain R]` — closes `inferInstance` for `Spec (CommRingCat.of K)` with `K` a field.
- `IsPullback.isIso_snd_of_isIso` — gives `IsIso snd` from the pullback against an iso `(𝟙 ...)`.
- `Category.assoc` (reverse direction, `← Category.assoc`) — for the universal-property chain.
