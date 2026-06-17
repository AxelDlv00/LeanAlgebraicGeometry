# Mathlib Analogist Report

## Mode
api-alignment

## Slug
dual252

## Iteration
252

## Question
For the Step-4 residual of `dual_restrict_iso` (`DualInverse.lean:254`):
`(pushforward β).obj (PresheafOfModules.dual M.val) ≅ PresheafOfModules.dual ((pushforward β).obj M.val)`
(β = sectionwise open-immersion ring iso `𝒪_Y(V) ≅ 𝒪_X(fV)`):
1. Does Mathlib have a "pushforward-along-a-ring-iso commutes with the internal-hom dual" idiom for `PresheafOfModules`?
2. Precise sectionwise `isoMk` skeleton, mirroring the closed H2 of `tensorObj_restrict_iso`.
3. Is `restrictScalarsRingIsoDualEquiv` the right ingredient, or is there a more direct `restrictScalars`-vs-`dual` commutation in Mathlib?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| D1. Mathlib supplies pushforward-vs-dual for `PresheafOfModules`? | NEEDS_MATHLIB_GAP_FILL | informational |
| D2. Prover's "sectionwise via `restrictScalarsRingIsoDualEquiv`" faithful & sufficient? | DIVERGE/GAP (under-scoped) | major |
| D3. Keep the project atom `restrictScalarsRingIsoDualEquiv`? | PROCEED | informational |

## Major

**D2 — the residual is NOT sectionwise-closable by `restrictScalarsRingIsoDualEquiv` alone; it under-scopes by one essential leg.**

The H2 step of the *tensor* lane closed sectionwise because **Mathlib's `tensorObj` is
sectionwise** (`(M⊗N)(X) = M(X)⊗N(X)`), so `restrictScalars β`'s tensorator reduced fiberwise to
`restrictScalarsRingIsoTensorEquiv`, packaged as `restrictScalarsMonoidalOfBijective`. The project
`dual` is **not** sectionwise: `(dual M)(U) = (restr U M ⟶ restr U 𝟙_)` (`PresheafInternalHom.lean:628-674`,
`893-896`) is a Hom of presheaves over the whole down-set `Over U`, not a fiber — and it is **not** a
single linear dual (it carries down-set-wide compatibility beyond the terminal functional
`M(U) →ₗ 𝒪(U)`).

So at section `V : (Opens Y)ᵒᵖ` the residual couples **two** transports:
- **(B) ring-iso reconciliation of the unit codomain** `𝒪_X(fV) ≅ 𝒪_Y(V)` — exactly
  `restrictScalarsRingIsoDualEquiv` (its codomain is hardcoded to the ground ring = `𝟙_`). ✓ the right atom.
- **(A) slice-site transport** of the *domain* presheaf: `restr V (pushβ M.val)` over `Over V ⊂ Opens Y`
  ↔ `restr fV M.val` over `Over fV ⊂ Opens X`, across the fully-faithful `f.opensFunctor` on the
  down-set of `fV`. A genuine non-sectionwise build; `restrictScalarsRingIsoDualEquiv` does not touch it.
  (The banned `overSliceSheafEquiv` was the natural-but-wrong-level tool for leg A — Sheaf cat, fixed
  value cat; the directive is right to forbid it. But the leg it addresses is real and still owed.)

Faithful naming: `restrictScalarsRingIsoDualEquiv` is the dual analogue of the **`ModuleCat`-level**
`restrictScalarsRingIsoTensorEquiv`, NOT of the **presheaf-level** `restrictScalarsMonoidalOfBijective`.
The presheaf-level dual analogue of `restrictScalarsMonoidalOfBijective` does **not** exist and cannot
(Mathlib has no `PresheafOfModules` internal hom; `dual` is not sectionwise). Leg A is what replaces it.

**Actionable**: scope leg (A) as a standalone verified lemma first — a presheaf-level
`restr`-vs-`f.opensFunctor` base-change (Beck–Chevalley) over the slice — then compose with
`restrictScalarsRingIsoDualEquiv` for leg (B). Skeleton:
```
PresheafOfModules.isoMk
  (app := fun V => (sliceDualTransport f M V).toModuleIso)   -- 𝒪_Y(V)-LinearEquiv
  (naturality := fun {V W} g => /- thin poset: Subsingleton.elim, as in dualUnitIsoGen -/)
-- sliceDualTransport f M V :
--   restrictScalars (β.app V) (restr fV M.val ⟶ restr fV 𝟙_X)
--     ≃ₗ[𝒪_Y(V)] (restr V (pushβ M.val) ⟶ restr V 𝟙_Y)
--   = (A) slice-equivalence Hom-transport  ≪ₗ  (B) restrictScalarsRingIsoDualEquiv
```
The load-bearing field is the construction of `sliceDualTransport` (leg A); the outer `isoMk`
naturality is thin-poset-trivial (mirror `dualUnitIsoGen` / `dualIsoOfIso`, `PresheafInternalHom.lean:103,1090`).

## Informational

**D1 — no upstream object to commute against.** Mathlib has `PresheafOfModules.pushforward₀`/`pushforward`
(`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward`) but **no internal hom, no dual, no
`MonoidalClosed`** for `PresheafOfModules` (`loogle "MonoidalClosed (PresheafOfModules ?R)"` → no
results). The whole `dual`/`internalHom`/`homModule`/`restr` block is project-local; the gap is
genuinely upstream, not a project defect.

The only abstract Mathlib route, `CategoryTheory.Monoidal.Rigid.OfEquivalence.hasRightDualOfEquivalence`
(transport a right dual along a strong-monoidal equivalence), requires the project `dual` to BE the
rigid right dual of a registered `MonoidalCategory`+rigid structure on `PresheafOfModules` — absent.
Porting cost prohibitive; not the path.

**D3 — keep `restrictScalarsRingIsoDualEquiv`.** Mathlib's `LinearMap.restrictScalars`/
`LinearEquiv.restrictScalars` (`Mathlib.Algebra.Module.LinearMap.Defs`,
`Mathlib.Algebra.Module.Equiv.Basic`) are gated on `LinearMap.CompatibleSMul` — a scalar-tower
situation with **unchanged codomain**. The dual swap `(M →ₗ[S] S) → (M →ₗ[R] R)` changes the codomain
`S ↝ R`, possible only through a ring iso. No `Module.Dual`-vs-`restrictScalars` commutation of this
codomain-swapping kind exists upstream. The project atom (CLOSED, axiom-clean, `PresheafInternalHom.lean:234-266`)
is correct and necessary.

**Possible shortcut to weigh before building leg A**: derive `dual_restrict_iso` from the already-closed
`tensorObj_restrict_iso` by **uniqueness of monoidal inverses** (dual = ⊗-inverse) via eval/coeval
naturality — sidesteps the slice transport entirely if the inverse-uniqueness glue is cheaper than leg A.
Flagged, not verified.

## Persistent file
- `analogies/dual252.md` — decisions, the (A)+(B) decomposition, the `isoMk`/`sliceDualTransport` skeleton.

Overall verdict: `restrictScalarsRingIsoDualEquiv` is the right ring-iso atom (leg B) but is NOT sufficient — the Step-4 residual additionally needs a slice-site transport (leg A) that the tensor lane never required because `tensorObj` is sectionwise and `dual` is not.
