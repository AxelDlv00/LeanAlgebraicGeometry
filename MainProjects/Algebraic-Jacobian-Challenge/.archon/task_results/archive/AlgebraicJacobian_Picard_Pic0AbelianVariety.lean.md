# AlgebraicJacobian/Picard/Pic0AbelianVariety.lean (iter-193 NEW)

## Summary

**HARD BAR MET**: New file `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`
created with the 5 pinned theorem skeletons; file compiles cleanly; imports +
namespace correct; 5 sorries; 0 project axioms (only kernel
`propext`/`sorryAx`/`Classical.choice`/`Quot.sound`).

The file has been added to the root import in `AlgebraicJacobian.lean` (line 22,
right after `Picard.IdentityComponent`).

## Declarations shipped (all under `AlgebraicGeometry.Scheme.Pic0`)

1. **`tangentSpaceIso`** (theorem, ~10 LOC body) — A.3.iii. Kleiman §5
   Thm.~`thm:tgtsp`. Type: `Nonempty (Σ' (e : Spec k ⟶ (Pic0Scheme C).left),
   IsLocalRing.CotangentSpace ((Pic0Scheme C).left.presheaf.stalk
   (e.base default)) ≃+ Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. The
   substantive content packages a `k`-rational identity-section point `e` and
   an `AddEquiv` between the cotangent space at `e` and the project's
   first-cohomology `k`-module `H¹(C, 𝒪_C)` from `Genus.lean`. Body: `sorry`.

2. **`smooth`** (theorem, ~3 LOC body) — A.3.iv. Kleiman §5 Cor.~`cor:sm` +
   Cor.~`cor:ch0` + Ex.~`ex:jac`. Type: `Smooth (Pic0Scheme C).hom`. Body:
   `sorry`.

3. **`proper`** (theorem, ~3 LOC body) — A.3.v. Kleiman §5 Thm.~`th:qpp&p`.
   Type: `IsProper (Pic0Scheme C).hom`. Body: `sorry`.

4. **`geometricallyIrreducible`** (theorem, ~3 LOC body) — A.3.vi. Kleiman §5
   Prp.~`prp:pic0` (specialisation of abstract substrate). Type:
   `GeometricallyIrreducible (Pic0Scheme C).hom`. Body: `sorry`.

5. **`isAbelianVariety`** (theorem, ~5 LOC body) — A.3.vii **assembly**.
   Milne §I.1 p.~8 + Kleiman §5 Rmk.~`rmk:Jac`. Type: `IsProper
   (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧ GeometricallyIrreducible
   (Pic0Scheme C).hom ∧ Nonempty (GrpObj (Pic0Scheme C))`. Body: `sorry`.

## Mode

`formalize` mode (file-skeleton dispatch). Helper budget = 0; bodies are not
attempted this iter per planner directive.

## Status

| Decl | Compile? | Sorry? | Axioms |
|------|----------|--------|--------|
| `tangentSpaceIso` | ✓ | typed `sorry` | kernel-only |
| `smooth` | ✓ | typed `sorry` | kernel-only |
| `proper` | ✓ | typed `sorry` | kernel-only |
| `geometricallyIrreducible` | ✓ | typed `sorry` | kernel-only |
| `isAbelianVariety` | ✓ | typed `sorry` | kernel-only |

Build: `lake build AlgebraicJacobian.Picard.Pic0AbelianVariety` succeeds
(`Build completed successfully (8326 jobs).`). Only `declaration uses sorry`
warnings are emitted on the 5 new theorems.

`#print axioms` on each of the 5 theorems shows only the kernel axioms
`[propext, sorryAx, Classical.choice, Quot.sound]` — no custom project
axioms introduced.

## Type-expressivity notes (per "Never weaken the type" rule)

- `tangentSpaceIso` is not vacuous: the existential bundles a `k`-rational
  point `e` and an `AddEquiv` between the cotangent space at `e` and the
  named `Scheme.HModule k (Scheme.toModuleKSheaf C) 1` (the project's
  `H¹(C, 𝒪_C)`); both sides are substantive named constructions.
  Universe alignment (`Type u` vs `Type (u+1)`) is bypassed by using
  `AddEquiv` (which allows heterogeneous universes) instead of `LinearEquiv`
  on the file-skeleton; iter-194+ refinement may upgrade to k-LinearEquiv
  once the `k`-module structure on the cotangent space is threaded.
- `smooth`/`proper`/`geometricallyIrreducible` are direct `Prop`-valued
  statements on `(Pic0Scheme C).hom`, not tautological.
- `isAbelianVariety` is a 4-conjunct of named structural properties on
  `(Pic0Scheme C).hom` + `Pic0Scheme C`, mirroring the iter-185
  `Pic0Scheme.isAbelianVariety` pin in sibling
  `Picard/IdentityComponent.lean` (the two declarations coexist; the new
  file's `Pic0.isAbelianVariety` is the consolidated A.3.vii gate while the
  sibling iter-185 `Pic0Scheme.isAbelianVariety` was the earlier
  one-file-skeleton version — iter-194+ should decide whether to deprecate
  one in favour of the other).

## Blueprint markers (for review/sync_leanok)

All 5 declarations are pinned in `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`
via `\lean{AlgebraicGeometry.Scheme.Pic0.{tangentSpaceIso, smooth, proper,
geometricallyIrreducible, isAbelianVariety}}`. The deterministic `sync_leanok`
phase will pick them up automatically (all 5 sorry-bodied → statement-level
`\leanok` only; no proof-level `\leanok`).

## Coordination

- The underlying `k`-scheme `Pic⁰_{C/k}` is `Scheme.Pic0Scheme C` (already in
  sibling `Picard/IdentityComponent.lean`). The new file does NOT redefine
  the underlying scheme; the `Pic0` namespace in this file is purely a
  collector for the five curve-specific facts about `Pic0Scheme C`.
- The blueprint planner suggested optionally adding a `def Scheme.Pic0`
  alias for `Scheme.Pic0Scheme`. Skipped this iter to avoid a redundant
  alias; the blueprint `\lean{AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso}`
  cross-reference resolves correctly to a function inside the `Pic0`
  *namespace* (sibling to `Pic0Scheme`); both `Pic0Scheme C` and the
  `Pic0.*` functions live in the `Scheme` namespace, so the namespace name
  `Pic0` is enough — no top-level `Scheme.Pic0` def needed.
- The iter-185 sibling `IdentityComponent.lean` still hosts a separate
  `Pic0Scheme.isAbelianVariety` pin with the same structural content;
  iter-194+ should decide whether to unify these two (e.g. by having
  `Pic0Scheme.isAbelianVariety` simply re-export the new
  `Pic0.isAbelianVariety` from this file).

## Next steps (iter-194+)

1. **`tangentSpaceIso` body**: implement Kleiman §5 Thm.~`thm:tgtsp`. Needs:
   - dual-numbers tangent space encoding (`Hom_k(k[ε]/(ε²), -)` or
     `Module.Dual k (CotangentSpace stalk)`);
   - truncated exponential sequence on the étale site of `C`
     (`0 → 𝒪_C → 𝒪_{C_ε}^× → 𝒪_C^× → 1`, split);
   - identification of the kernel `H¹(C, 𝒪_C)` with `T₀ Pic_{C/k}` via the
     comparison map (FGA representability — needs sibling
     `Picard/FGAPicRepresentability.lean` body landed first).
2. **`proper` body**: implement Kleiman §5 Thm.~`th:qpp&p`. Needs:
   - Chevalley–Rosenlicht structure theorem for connected algebraic groups
     (substantive Mathlib gap, ~200-300 LOC project-side);
   - Hartshorne II Ex.~6.15 (invertible sheaves on normal integral schemes
     are sheaves of Cartier divisors — Mathlib partial coverage).
3. **`smooth` body**: implement Kleiman §5 Cor.~`cor:sm` after
   `tangentSpaceIso` lands. Needs:
   - tangent-space dimension bound for Noetherian local rings;
   - translation argument (smooth at 0 ⟹ smooth everywhere) via the group
     law on `Pic0Scheme C`.
4. **`geometricallyIrreducible` body**: should be the easiest — specialise
   `GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible`
   (sibling `Picard/IdentityComponent.lean`) to `G = PicScheme C` and
   identify `IdentityComponent (PicScheme C) ≅ Pic0Scheme C`. Gated on the
   third conjunct of that sibling theorem closing axiom-clean.
5. **`isAbelianVariety` body**: assemble `proper` + `smooth` +
   `geometricallyIrreducible` (this file) + `Nonempty (GrpObj
   (Pic0Scheme C))` (from `GroupScheme.IdentityComponent.isSubgroupHomomorphism`
   sibling). Should be ~10 LOC once the four conjunct theorems land
   axiom-clean.

## Iter-193 attempt log

### Attempt 1
- **Approach:** Read blueprint chapter `Picard_Pic0AbelianVariety.tex` for
  the informal proof sketch and exact `\lean{...}` pin names; mirror the
  iter-185 IdentityComponent file-skeleton style (substantive types with
  typed sorry bodies); create new file with 5 theorem skeletons under
  `AlgebraicGeometry.Scheme.Pic0` namespace; add root import.
- **Result:** RESOLVED — file compiles with 5 sorries, 0 project axioms.
  Build full project succeeds (8326 jobs). Each theorem's `#print axioms`
  shows only kernel axioms.
- **Key insights:**
  - `Scheme.HModule k F n` lives in `Type (u+1)` while the cotangent space
    `IsLocalRing.CotangentSpace stalk` lives in `Type u`; using `AddEquiv`
    (which allows different universes) instead of `LinearEquiv` sidesteps
    universe-alignment work for the file-skeleton.
  - `Pic0Scheme C` is already defined in sibling `IdentityComponent.lean`
    (sorry-bodied), so I reused it as the underlying scheme rather than
    redefining; the `Pic0` namespace collects the 5 curve-specific facts.
  - Adding a `def Scheme.Pic0` alias for `Pic0Scheme` was suggested by the
    plan agent as optional; skipped because the blueprint `\lean{...}`
    cross-references resolve via the namespace name alone, no alias needed.
