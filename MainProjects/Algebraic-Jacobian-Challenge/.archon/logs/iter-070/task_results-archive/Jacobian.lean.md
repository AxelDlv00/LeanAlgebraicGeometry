# Iteration 069 — Jacobian.lean task results

## Summary

Phase C scaffolding landed. The genus-0 case of `Jacobian C` is now fully closed (all four instances discharge automatically). For genus `> 0`, the five protected sorries are decomposed into conditional `if-then-else` blocks with clear mathematical commentary.

New definitions:
- `IsAlbanese` — the Albanese universal property for a pointed smooth proper curve.
- `IsAlbanese.unique` — uniqueness of the Albanese object up to a unique compatible isomorphism (standard abstract-nonsense proof via the universal property, no rigidity needed).
- `geometricallyIrreducible_id_Spec` — helper proving `GeometricallyIrreducible (𝟙 (Spec k))`, needed for the genus-0 case.

## What was proved

### `IsAlbanese` predicate and uniqueness theorem

**Location:** `AlgebraicJacobian/Jacobian.lean` lines 55–109

**Definition:**
```lean
def IsAlbanese (C : Over (Spec (.of k))) (P : 𝟙_ _ ⟶ C) (J : Over (Spec (.of k)))
    [GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom] : Prop
```
bundles the data of a universal pointed morphism `ι : C ⟶ J` (`P ≫ ι = η[J]`) together with the universal property: for every abelian variety `A` over `k` and every pointed morphism `f : C ⟶ A` (`P ≫ f = η[A]`), there exists a unique `g : J ⟶ A` with `f = ι ≫ g`.

**Helper lemmas:**
- `IsAlbanese.ofCurve` — extracts the universal morphism (non-computable via `Classical.choose`).
- `IsAlbanese.comp_ofCurve` — `P ≫ ofCurve = η[J]`.
- `IsAlbanese.exists_unique_ofCurve_comp` — the universal property.

**Uniqueness proof (`IsAlbanese.unique`):**
Given two Albanese objects `J₁, J₂` for the same pointed curve `(C, P)`, the universal property yields unique morphisms `g : J₁ ⟶ J₂` and `h : J₂ ⟶ J₁` compatible with the universal curves. Applying the universal property of `J₁` to `ofCurve` itself shows `g ≫ h = 𝟙 J₁`; similarly `h ≫ g = 𝟙 J₂`. Hence `g` is the unique isomorphism witnessing `J₁ ≅ J₂`.

### Genus-0 case closure

**Location:** `AlgebraicJacobian/Jacobian.lean` lines 127–171

`Jacobian C` is now defined by a case split on `genus C`:
- `genus C = 0` → `𝟙_ (Over (Spec (.of k)))` (terminal object / `Spec k`).
- `genus C > 0` → `sorry` (Albanese construction deferred).

In the genus-0 branch, all four required instances discharge automatically:

| Instance | Genus-0 proof | Mathlib infrastructure used |
|----------|---------------|----------------------------|
| `GrpObj (Jacobian C)` | `infer_instance` | `instTensorUnit` on the monoidal unit |
| `SmoothOfRelativeDimension (genus C) (Jacobian C).hom` | `rw [h]; infer_instance` | `𝟙 (Spec k)` is an iso → open immersion → smooth of rel. dim. 0 |
| `IsProper (Jacobian C).hom` | `infer_instance` | `IsProper` is multiplicative, hence contains identities |
| `GeometricallyIrreducible (Jacobian C).hom` | `exact geometricallyIrreducible_id_Spec k` | explicit proof: pullback along `𝟙 (Spec k)` is `Spec K` (irreducible for any field `K`) |

The helper `geometricallyIrreducible_id_Spec` uses `IsPullback.isIso_snd_of_isIso` (the identity is an isomorphism, so the projection from the pullback is an iso) and the fact that `IrreducibleSpace` respects isomorphisms. `Spec K` is irreducible because `K` is a domain.

## Remaining sorries in the file

After iter-069, the following `sorry`s remain in `Jacobian.lean`:

1. **Line 135** — `Jacobian C` for `genus C > 0`: the Albanese construction. Blocked on: symmetric powers of schemes, quotients by finite group actions, or Picard-scheme representability.
2. **Line 147** — `instGrpObj` for `genus C > 0`: group law on the Albanese variety.
3. **Line 156** — `smoothOfRelativeDimension_genus` for `genus C > 0`: smoothness and dimension of the Albanese variety (tangent space at identity is `H¹(C, O_C)`, dimension `genus C`).
4. **Line 163** — `instIsProper` for `genus C > 0`: properness of the Albanese variety.
5. **Line 170** — `instGeometricallyIrreducible` for `genus C > 0`: geometric irreducibility of the Albanese variety.

## Net change

- **Before:** 5 syntactic sorries (all bare `sorry`s with commentary).
- **After:** 5 syntactic sorries, but 4 of them are now in the `genus C > 0` branch of a conditional definition; the `genus C = 0` branch is fully closed for all 4 instances.
- **New definitions:** 3 (`IsAlbanese`, `IsAlbanese.unique`, `geometricallyIrreducible_id_Spec`).
- **No new axioms.**

## Forward-compatibility notes

- The `IsAlbanese` predicate matches the expected interface of `AbelJacobi.lean`: `ofCurve P`, `comp_ofCurve`, and `exists_unique_ofCurve_comp` are exactly the components of `IsAlbanese`.
- Once an existence theorem `∃ J, IsAlbanese C P J` is proved (e.g. via symmetric powers), `Jacobian C` for `genus C > 0` can be defined as `Classical.choose` of that existential, and the four instances can be extracted from the existential witness.
- The uniqueness theorem will be needed in `AbelJacobi.lean` to show that the Abel–Jacobi map is independent of auxiliary choices in the construction.
