# Refactor directive — slug `must-fix-demotions`

## Task

Demote three `:= sorry` carriers that silently propagate `sorryAx`
through typeclass synthesis. Each follows the iter-194 IdentityComponent
template (`private instance → private theorem`, callers thread via
`haveI := ...` / `letI := ...` / `letI := ⟨...⟩` as appropriate).

The build MUST remain GREEN after each step. Do NOT attempt to close the
sorries — only restructure so the `sorryAx` is no longer flowing through
typeclass synthesis silently. **Sorry count target**: unchanged (3
sorries swap from `:= sorry` carriers to named typed-sorry helpers; +0
or +1 net is acceptable, never close any sorry).

---

## Item 1 — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:746`

### Current state (L746-772)

```lean
instance instIsRegularInCodimOneProjectiveLineBar (kbar : Type u) [Field kbar]
    [IsIntegral (ProjectiveLineBar kbar).left] :
    Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left := by
  ...
  refine ⟨fun Y => ?_⟩
  sorry
```

Sole consumer site: `degree_positivePart_principal_eq_finrank` (L809)
which lists `[Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left]`
explicitly in its binder list at L817 — meaning the binder has been
required as a typeclass argument. The instance in this file synthesizes
it silently.

### Required change

1. Rename: `instance instIsRegularInCodimOneProjectiveLineBar` →
   `private theorem isRegularInCodimOneProjectiveLineBar` (drop the
   `instance` keyword; rename to drop the `inst` prefix).
2. Keep signature parameters identical: `(kbar : Type u) [Field kbar]
   [IsIntegral (ProjectiveLineBar kbar).left]`. Return type unchanged.
3. Body remains `sorry` (with the docstring + Routes 1/2 comments).
4. After demotion, the binder
   `[Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left]` at
   L817 still resolves via explicit typeclass argument supplied by
   callers; this is the goal (no implicit synthesis from the sorry-bodied
   instance).
5. There are NO consumers outside this file (verified via grep). The
   binder list at the call site at L817 will simply continue to require
   `IsRegularInCodimensionOne` as a typeclass argument that the caller
   supplies. The demotion does not require any consumer-site edits in
   this file.

### Verification step

After the change, run `lake build AlgebraicJacobian` to confirm GREEN.
Then run `lean_verify isRegularInCodimOneProjectiveLineBar` to confirm
the new lemma still propagates `sorryAx` *locally* (expected) but does
NOT propagate through typeclass synthesis to consumers.

---

## Item 2 — `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean:194`

### Current state (L168-195, inside `av_isIntegral_of_smooth_geomIrred`)

```lean
private theorem av_isIntegral_of_smooth_geomIrred
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (A : Over (Spec (.of kbar))) [SmoothOfRelativeDimension n A.hom]
    [IsProper A.hom] [GeometricallyIrreducible A.hom] :
    IsIntegral A.left := by
  ...
  haveI : IsReduced A.left := sorry
  exact isIntegral_of_irreducibleSpace_of_isReduced A.left
```

### Required change

Convert the inline `haveI : IsReduced A.left := sorry` to a named
file-private typed-sorry helper that takes the same hypotheses, and have
the proof call it explicitly. This isolates the `sorryAx` to a single
named declaration the lean-auditor can flag.

1. Insert (immediately above `av_isIntegral_of_smooth_geomIrred`) a new
   file-private typed-sorry helper:

   ```lean
   /-- **Mathlib gap (Stacks `034V`/`02G4`)**: a scheme smooth over a
   reduced base is reduced. Used to derive `IsReduced A.left` in
   `av_isIntegral_of_smooth_geomIrred` below. Typed sorry; the gap is
   the scheme-level packaging of the Stacks lemma. -/
   private theorem isReduced_of_smooth_over_field
       {kbar : Type u} [Field kbar]
       (A : Over (Spec (.of kbar))) {n : ℕ}
       [SmoothOfRelativeDimension n A.hom] :
       IsReduced A.left := sorry
   ```

2. Inside `av_isIntegral_of_smooth_geomIrred`, replace
   `haveI : IsReduced A.left := sorry` with
   `haveI : IsReduced A.left := isReduced_of_smooth_over_field A`.

3. Net sorry delta: +0 (1 sorry moves from inline to named helper).

### Verification step

`lake build AlgebraicJacobian` GREEN. `lean_verify
isReduced_of_smooth_over_field` confirms the typed sorry is present.
`lean_verify av_isIntegral_of_smooth_geomIrred` shows it still
propagates `sorryAx` but now from a *named* substrate dependency.

---

## Item 3 — `AlgebraicJacobian/Albanese/AlbaneseUP.lean:183`

### Current state (L158-201)

```lean
structure Bundle ... where
  scheme : Over ...
  grpObj : GrpObj scheme
  proper : IsProper scheme.hom
  smooth : Smooth scheme.hom
  geomIrred : GeometricallyIrreducible scheme.hom

noncomputable def bundle : Bundle C := sorry

noncomputable def jacobianScheme : Over (Spec (.of kbar)) := (bundle C).scheme

noncomputable instance instGrpObj : GrpObj (jacobianScheme C) := (bundle C).grpObj
instance instIsProper : IsProper (jacobianScheme C).hom := (bundle C).proper
instance instSmooth : Smooth (jacobianScheme C).hom := (bundle C).smooth
instance instGeomIrred : GeometricallyIrreducible (jacobianScheme C).hom :=
  (bundle C).geomIrred
```

External consumers (grep result): NONE outside `Albanese/AlbaneseUP.lean`.
The `Jacobian.lean` file uses an analogous `jacobianWitness` carrier
(separately tracked) but does NOT consume `jacobianScheme`.

### Required change

Demote the 4 typeclass instances to named lemmas/defs so the `sorryAx`
no longer silently propagates through typeclass synthesis. Internal
consumers within this file (if any) thread the instances explicitly.

1. Convert the 4 instances at L191-201 to named, file-private
   declarations. Keep `bundle` and `jacobianScheme` as-is (these
   are the carriers; the audit's complaint is about
   typeclass-synthesis propagation, not the `:= sorry` carrier per
   se):

   ```lean
   -- WAS: noncomputable instance instGrpObj ...
   /-- Group-object structure on `Pic⁰_{C/k̄}`. **Demoted from
   `instance` per lean-auditor iter-195 must-fix**: the silent
   propagation of `sorryAx` through `GrpObj`-typeclass synthesis is
   a soundness exposure until the `bundle` carrier closes.
   Consumers thread via `letI := jacobianScheme_grpObj C`. -/
   noncomputable def jacobianScheme_grpObj : GrpObj (jacobianScheme C) :=
     (bundle C).grpObj

   /-- (Demoted from `instance`; see `jacobianScheme_grpObj`.) -/
   theorem jacobianScheme_isProper : IsProper (jacobianScheme C).hom :=
     (bundle C).proper

   /-- (Demoted from `instance`; see `jacobianScheme_grpObj`.) -/
   theorem jacobianScheme_smooth : Smooth (jacobianScheme C).hom :=
     (bundle C).smooth

   /-- (Demoted from `instance`; see `jacobianScheme_grpObj`.) -/
   theorem jacobianScheme_geomIrred :
       GeometricallyIrreducible (jacobianScheme C).hom :=
     (bundle C).geomIrred
   ```

2. Internal consumers of `[GrpObj (jacobianScheme C)]`, etc. inside
   this file MUST be updated. Search the file for places that use any
   of these instances and add an explicit `letI :=
   jacobianScheme_grpObj C` / `haveI := jacobianScheme_isProper C`
   etc. The compiler errors will pinpoint these — fix each with a
   minimal `letI/haveI` insertion.

3. Net sorry delta: +0 (the `:= sorry` carrier `bundle` is untouched;
   only the *typeclass-propagation* shape changes).

### Verification step

`lake build AlgebraicJacobian` GREEN. `lean_verify
jacobianScheme_grpObj` confirms `sorryAx` is present (expected, via
the `bundle` carrier) but is no longer silently picked up by
typeclass synthesis.

---

## Out of scope this dispatch

- Do NOT attempt to close any of the 3 sorries.
- Do NOT modify the `bundle` carrier itself (it stays `:= sorry`; the
  audit's red flag was the *instance propagation*, not the carrier).
- Do NOT touch any other `:= sorry` carrier elsewhere in the project.
- Do NOT modify any blueprint chapter.
- Do NOT change Mathlib pin or `lakefile.lean`.

## Final checks before reporting done

1. `lake build AlgebraicJacobian` returns GREEN.
2. `wc -l` on each affected file is roughly unchanged (no spurious
   bulk additions).
3. The audit's three must-fix items are now isolated to named
   typed-sorry declarations.

Report in your task_results file:
- File diffs (just the changed regions).
- `lake build` status.
- Any consumer-site `letI/haveI` additions you had to make.
