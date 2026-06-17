# Refactor directive — slug `carrier-soundness-fgapic`

## Task

Refactor `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` to
eliminate silent `sorryAx` propagation through the carrier `:= sorry`
pattern. This is the **iter-196 carrier-soundness probe** committed
by the iter-195 mathlib-analogist verdict
(`analogies/carrier-soundness-design.md`, Option A
`Functor.IsRepresentable` ALIGN_WITH_MATHLIB).

**This is a probe — 2-3 iter abort criterion applies.** If at iter-198
`lean_verify` on touched protected declarations still shows silent
`sorryAx` propagation through typeclass synthesis (i.e. consumers
implicitly synthesize an instance that uses the carrier sorry), the
strategy reverts. This iter's directive is the FIRST slice — only
`Picard/FGAPicRepresentability.lean` is in scope.

## Recipe (Option A `Functor.IsRepresentable` pattern)

Per `analogies/carrier-soundness-design.md` § Recommendation:

1. **Introduce a `Prop`-valued typeclass per carrier**. Mathlib's
   `CategoryTheory.Functor.IsRepresentable` is the canonical idiom
   (`Mathlib.CategoryTheory.Yoneda`):

   ```lean
   class Functor.IsRepresentable (F : Cᵒᵖ ⥤ Type v) : Prop where
     has_representation : ∃ Y, Nonempty (F.RepresentableBy Y)
   ```

2. **Define the carriers via `Classical.choose`** of the typeclass
   instance, mirroring `Functor.reprX`:

   ```lean
   noncomputable def Functor.reprX (F : Cᵒᵖ ⥤ Type v)
       [hF : F.IsRepresentable] : C :=
     hF.has_representation.choose
   ```

   This is `propext` + `Classical.choice` + `Quot.sound` only — the
   project's kernel-only target.

3. **Place the `sorry` in the instance constructor**:

   ```lean
   instance hasPicScheme (C ...) [SmoothOfRelativeDimension 1 C.hom]
       [IsProper C.hom] [GeometricallyIntegral C.hom] :
       HasPicScheme C := ⟨sorry⟩
   ```

   The sorry is now isolated to the instance constructor. Consumers
   that *quantify* over `[HasPicScheme C]` remain kernel-clean;
   consumers that *use* `PicScheme C` (extracting via `Classical.choose`)
   inherit `sorryAx` from the instance — but only via an EXPLICIT
   instance synthesis, not silent.

## Carriers in scope this iter

5 carriers in `FGAPicRepresentability.lean`:
- L132 `picSharp` (forward-reference functor stub).
- L147 `divFunctor` (forward-reference functor stub).
- L187 `PicScheme` (Picard scheme carrier).
- L226 `abelMap` (natural transformation stub).
- L324 `representable` (the `RepresentableBy` witness).
- L363 `groupSchemeStructure` (GrpObj instance).

**Out of scope this iter** (downstream slices iter-197+):
- `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` consumers.
- `AlgebraicJacobian/Picard/IdentityComponent.lean` consumers.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean` (`PicSharp`, `presheaf`,
  `etSheaf`, `addCommGroup`).
- `AlgebraicJacobian/Picard/QuotScheme.lean` (`QuotScheme`).

## Required change

### Step 1: Introduce typeclasses

Above each `:= sorry` carrier, introduce a `Prop`-valued typeclass
that quantifies the existence claim it currently asserts via the
sorry. Suggested names:

- `HasPicSharp C` for `picSharp`.
- `HasDivFunctor C` for `divFunctor`.
- `HasPicScheme C` for `PicScheme`.
- `HasAbelMap C` for `abelMap`.
- `PicSharpRepresentable C` for `representable` (the existence claim
  "`picSharp C` is representable by some scheme over `Spec k`").
- `PicSchemeGroupObject C` for `groupSchemeStructure` (the existence
  claim "`PicScheme C` carries a group-object structure").

Each typeclass body is a single `Prop` field whose `.choose` /
`.choose_spec` extracts the underlying data. Examples:

```lean
class HasPicScheme {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : Prop where
  has_pic_scheme : ∃ (X : Over (Spec (.of k))),
    Nonempty ((picSharp C).RepresentableBy X)

class HasPicSharp {k : Type u} [Field k] (C : Over (Spec (.of k))) :
    Prop where
  has_pic_sharp : Nonempty ((Over (Spec (.of k)))ᵒᵖ ⥤ Type u)
```

(For `picSharp` and `divFunctor`, the typeclass simply guarantees a
witness functor exists; the body is a `Nonempty` of the function
type. For carriers where there's substantive existence content, the
typeclass body is the existence claim itself.)

### Step 2: Convert the `:= sorry` carriers to `Classical.choose` extractions

Replace each carrier body. Example for `PicScheme`:

```lean
noncomputable def PicScheme {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    Over (Spec (.of k)) :=
  (HasPicScheme.has_pic_scheme (C := C)).choose
```

For carriers without subsumed existence content (e.g. `picSharp`),
extract via `Classical.choice`:

```lean
noncomputable def picSharp {k : Type u} [Field k]
    (_C : Over (Spec (.of k))) [HasPicSharp _C] :
    (Over (Spec (.of k)))ᵒᵖ ⥤ Type u :=
  Classical.choice (HasPicSharp.has_pic_sharp (C := _C))
```

### Step 3: Provide the existence instances (carrying the sorry)

For each typeclass introduced in Step 1, provide an `instance`
constructor that supplies the existence claim. The body is `sorry`:

```lean
noncomputable instance hasPicScheme_instance {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    HasPicScheme C :=
  ⟨sorry⟩
```

This is the SINGLE site per carrier where `sorryAx` enters. The audit
goal: when iter-196 prover runs `lean_verify` on a downstream
consumer that DOES NOT USE this instance, the result should be
kernel-only (`propext`, `Classical.choice`, `Quot.sound`).

### Step 4: Verify build is GREEN

After all 5 carriers refactored, run `lake build AlgebraicJacobian` and
ensure it compiles. Sorry count target: unchanged (5 `:= sorry`
carriers → 5 `instance ... := ⟨sorry⟩` constructors; +0 net).

### Step 5 (optional, time permitting): `lean_verify` smoke check

Run `lean_verify AlgebraicGeometry.Scheme.PicScheme` and
`lean_verify AlgebraicGeometry.Scheme.PicScheme.representable`. The
output should show `sorryAx` (the carrier instance's body) but the
*propagation path* should now be visible — the smoke check confirms
the audit signal is observable.

If `lean_verify` shows `sorryAx` is no longer in the path of a
consumer that doesn't explicitly use `[HasPicScheme C]` etc., the
refactor has succeeded structurally.

## Out of scope

- Do NOT close any of the 5 carriers' sorries (the existence claims).
  The probe goal is structural cleanup, not closure.
- Do NOT modify any external consumer file
  (`Pic0AbelianVariety.lean`, `IdentityComponent.lean`, etc.). The
  iter-196 probe is FGAPicRepresentability-only.
- Do NOT touch `QuotScheme.lean` or `RelPicFunctor.lean` carriers.

## Verification step

`lake build AlgebraicJacobian` GREEN. Sorry count unchanged.

## Report shape

In `task_results/refactor-carrier-soundness-fgapic.md`:
- Per-carrier before/after diff.
- 5 typeclass names introduced.
- `lake build` status.
- Any external consumer-site fallout (should be none; if there is, name the file + line).
- A short paragraph on whether the structural goal (sorryAx no longer
  silent) was achieved in this iter.

Out-of-scope items reported under `## Notes for plan agent`.
