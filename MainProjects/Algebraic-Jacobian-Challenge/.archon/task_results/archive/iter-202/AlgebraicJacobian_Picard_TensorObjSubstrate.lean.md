# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

Lane TS-Scaffold (iter-202). Mode: `prove` (file-skeleton dispatch).
Helper budget = 0. **Critical directive: do NOT attempt proofs — scaffold only.**

## Deliverable

Created the new file `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
from scratch (did not previously exist) with the 4 blueprint-pinned
declarations as clean typed `:= sorry` stubs, plus PUSH-BEYOND supporting
helpers, and registered the import in `AlgebraicJacobian.lean`.

### 4 pinned declarations (HARD BAR)

| # | Declaration | Kind | Line | Body |
|---|---|---|---|---|
| 1 | `AlgebraicGeometry.Scheme.Modules.tensorObj` | `noncomputable def` | 113 | `:= sorry` |
| 2 | `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` | `noncomputable def` | 127 | `:= sorry` |
| 3 | `AlgebraicGeometry.Scheme.Modules.monoidalCategory` | `noncomputable instance` | 146 | `:= sorry` |
| 4 | `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` | `noncomputable def` | 217 | `:= sorry` |

Signature decisions:
- `tensorObj {X : Scheme.{u}} (M N : X.Modules) : X.Modules` — binary op,
  matching `Scheme.Modules X : Type (u+1)` (verified via hover on
  `LineBundlePullback.lean:115`).
- `tensorObj_functoriality {M M' N N'} (f : M ⟶ M') (g : N ⟶ N') :
  tensorObj M N ⟶ tensorObj M' N'` — the morphism action `f ⊗ g` (the
  substantive content of the bifunctoriality lemma; clean typed shape).
- `monoidalCategory {X} : MonoidalCategory (X.Modules)` — the
  `CategoryTheory.MonoidalCategory` instance. (Blueprint says "symmetric";
  the pin name is `monoidalCategory : MonoidalCategory`, so the symmetric
  upgrade is left for the body iter.)
- `addCommGroup_via_tensorObj {S C T} (πC πT) :
  AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))` —
  **deliberately a `def`, not a global `instance`**, to avoid an instance
  diamond with the existing typed-sorry `PicSharp.addCommGroup` instance in
  `RelPicFunctor.lean:235` (same type). This is the iter-204+ closure target
  for the Lane RPF residual sorry.

### PUSH-BEYOND supporting helpers (no `\lean{}` pins in blueprint)

- `Scheme.Modules.tensorObj_isLocallyTrivial` (line 165, `:= sorry`) —
  `lem:tensorobj_preserves_locally_trivial`.
- `Scheme.Modules.exists_tensorObj_inverse` (line 178, `:= sorry`) —
  `lem:tensorobj_inverse_invertible` (stated as existence of a dual + a
  `≅ 𝟙_ (X.Modules)` tensor iso, since no `dual` op is defined yet).
- `Scheme.Modules.tensorObjOnProduct` (line ~190) —
  `lem:tensorobj_lift_onproduct`. This one has a **genuine body** (not a
  sorry): `⟨tensorObj L.carrier L'.carrier, tensorObj_isLocallyTrivial …⟩`,
  reusing the `IsLocallyTrivial` helper from `LineBundlePullback.lean`.

Did NOT scaffold `lem:pullback_compatible_with_tensorobj` (Piece 3d): a clean
typed signature for "π_T^* is a strong monoidal functor" needs the monoidal
unit / pullback-tensor compatibility data that is itself sorry-gated; deferred
to the body iter to avoid a circular/unstable stub. The 3 helpers above plus
the 4 pins cover the PUSH-BEYOND intent.

## Verification

- `lean_diagnostic_messages` on the file: `success: true`,
  `failed_dependencies: []`. Only warnings are the expected
  `declaration uses sorry` (×7) and one benign linter note on
  `addCommGroup_via_tensorObj` ("class-type def should be `@[reducible]`" —
  harmless; left as a plain `def` intentionally per the diamond-avoidance
  decision above).
- Imports: `import Mathlib` + `import AlgebraicJacobian.Picard.RelPicFunctor`
  (the latter transitively supplies `LineBundlePullback`'s
  `RelPicPresheaf.preimage_subgroup`, `LineBundle.OnProduct`,
  `LineBundle.IsLocallyTrivial`).
- Registered in `AlgebraicJacobian.lean`: new line
  `import AlgebraicJacobian.Picard.TensorObjSubstrate` after the
  `RelPicFunctor` import (HARD BAR requirement; AlgebraicJacobian.lean is the
  root manifest, not a prover-owned proof file — single import line added per
  explicit objectives directive).

## Blueprint markers (for review agent — provers must NOT edit `\leanok`)

The following blueprint environments in
`chapters/Picard_TensorObjSubstrate.tex` now have a formalized
(typed-sorry) Lean declaration on disk; ready for `sync_leanok` to mark
statement-level `\leanok` (proofs are still open, so proof-level `\leanok`
should NOT be applied):
- `def:scheme_modules_tensorobj` → `tensorObj`
- `lem:scheme_modules_tensorobj_functoriality` → `tensorObj_functoriality`
- `thm:scheme_modules_monoidal` → `monoidalCategory`
- `thm:rel_pic_addcommgroup_via_tensorobj` → `addCommGroup_via_tensorObj`

## Summary

- **Sorry count**: before = 0 (file did not exist) → after = 6 typed-sorry
  stubs (4 pinned + `tensorObj_isLocallyTrivial` + `exists_tensorObj_inverse`).
  This lane **adds sorries by design** — the scaffold's deliverable is
  compiling typed stubs awaiting iter-203+ body fill.
- **Sorries closed**: none expected (scaffold lane).
- **Sorries still open**: all 6, intentionally — bodies are iter-203+ work.
- **Adjacent sorries**: not attempted — the lane directive explicitly forbids
  proof attempts ("do NOT attempt proofs … producing compiling stub
  signatures is the entire deliverable"). This overrides the general
  keep-going guidance for this scaffold lane.
- **Axioms**: zero `axiom` declarations introduced (sorries produce `sorryAx`,
  which is the intended typed-stub state).

## Why I stopped

**Real progress (scaffold deliverable complete).** Created the file with all
4 blueprint-pinned typed-sorry declarations matching the pin signatures, 3 of
the 4 PUSH-BEYOND supporting helpers, registered the import, and verified GREEN
compilation. This fully meets the HARD BAR (file compiles GREEN with ≥4 typed
sorries matching blueprint pins + import in `AlgebraicJacobian.lean`) and most
of the PUSH-BEYOND (supporting helper stubs). I stopped at the scaffold boundary
because the lane directive is explicit and repeated that proof attempts are
out of scope for this lane; the bodies (`tensorObj` via
`PresheafOfModules.Monoidal.tensorObj` + sheafification, the monoidal coherence
axioms, and the consumer `AddCommGroup`) are the iter-203+ body-fill targets.

## Next step (iter-203+)

1. Body of `tensorObj`: lift `PresheafOfModules.Monoidal.tensorObj` on the
   underlying presheaves through the sheafification functor on the small
   Zariski site of `X` (`Mathlib.CategoryTheory.Monoidal.PresheafOfModules`).
2. Body of `monoidalCategory`: assemble `MonoidalCategoryStruct` (tensorHom
   from `tensorObj_functoriality`, unit = structure sheaf, associator/unitors
   from the presheaf-level data) then discharge pentagon/triangle/hexagon.
3. Body of `addCommGroup_via_tensorObj`: descend the tensor group law through
   `QuotientAddGroup` on the `π_T^*`-image subgroup (consumes pieces 1–3 +
   the lift helpers), then swap it into `RelPicFunctor.lean:235`'s
   `addCommGroup` instance body (Lane RPF, iter-204+).
