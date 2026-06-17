/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.PresheafCech

/-!
# Free-presheaf Čech complex (P3b bridge — free-complex side)

This file is the free-presheaf-complex side of the P3b bridge.  The section side lives in
`PresheafCech.lean`; this file owns the two free-complex declarations:

- `AlgebraicGeometry.cechFreePresheafComplex`  (`def:cech_free_presheaf_complex`)
  — the chain complex of free presheaves of `O_X`-modules whose degree-`p` term is
  `⨁_{σ : Fin(p+1) → ι} (PresheafOfModules.free X.ringCatSheaf.obj).obj`
  `  (yoneda.obj (⨅ k, U (σ k)))`.

- `AlgebraicGeometry.cechFreeComplex_quasiIso`  (`lem:cech_free_complex_quasi_iso`)
  — the free complex is a quasi-isomorphism / free resolution of `O_𝒰`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-
Planner strategy (P3b free-complex side; see analogies/p3b-presheafcech.md +
blueprint §Presheaf-level Čech machinery):

────────────────────────────────────────────────────────────────────────────────
`cechFreePresheafComplex`
────────────────────────────────────────────────────────────────────────────────
Goal: a `ChainComplex X.PresheafOfModules ℕ` whose degree-`p` term is
  `⨁_{σ : Fin(p+1) → ι} (PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj (⨅ k, U (σ k)))`
with the alternating-face differential.

Recommended build path — use the simplicial route so that d²=0 comes for free:
1. Construct a `SimplicialObject X.PresheafOfModules` whose `n`-simplices are the
   above direct sums.
2. Apply `AlgebraicTopology.alternatingFaceMapComplex` to obtain the chain complex.
   This gives d²=0 automatically via `SimplicialObject.boundarySquareZero`.

Key API:
- `PresheafOfModules.free X.ringCatSheaf.obj :`
  `  ((Opens ↥X)ᵒᵖ ⥤ Type u) ⥤ PresheafOfModules X.ringCatSheaf.obj`
  — the free-presheaf-of-modules functor.  Use it as `(PresheafOfModules.free _).obj` and
  `(PresheafOfModules.free _).map`.
- `yoneda.obj V : (Opens ↥X)ᵒᵖ ⥤ Type u` — the representable presheaf of sets at `V`.
  Do NOT introduce a bespoke `j_!`; `free ∘ yoneda` is the correct substitute.
- `AlgebraicTopology.alternatingFaceMapComplex` — turns a simplicial abelian group (or
  simplicial object in an abelian category) into a chain complex; d²=0 is a theorem.
- Direct sums: `⨁` is `DirectSum`; in `PresheafOfModules` use
  `Limits.biproduct` / `DirectSum.lof` / `DirectSum.desc`.

DEAD END — do NOT hand-roll the alternating-sum identity for d²=0.  Use the simplicial
path above.

────────────────────────────────────────────────────────────────────────────────
`cechFreeComplex_quasiIso`
────────────────────────────────────────────────────────────────────────────────
Goal: show that `cechFreePresheafComplex` → `O_𝒰[0]` is a quasi-isomorphism (i.e.,
the free complex is a free resolution of the structure sheaf restricted to the cover).

Recommended build path — objectwise contracting homotopy:
1. Homology in `X.PresheafOfModules` is computed objectwise (colimits are objectwise).
   So it suffices to exhibit, for each open `V : Opens ↥X`, a contracting homotopy on
   the sectionwise complex `cechFreePresheafComplex(V)`.
2. Sectionwise at `V`, degree `p` is `⨁_{σ : Fin(p+1) → ι} R(V)` for those multi-indices
   `σ` with `V ⊆ ⨅ k, U (σ k)`, and `0` otherwise.
3. Fix any `i_fix : ι` with `V ⊆ U i_fix` (if none exists, the complex is `0`).
   The homotopy `h : K_p(V) → K_{p+1}(V)` maps the `σ`-summand to the `(i_fix, σ)`-summand
   (prepend `i_fix`).  Check `dh + hd = id` at each degree.
4. Package as `HomologicalComplex.Homotopy`, then use `HomotopyEquiv.toQuasiIso`.

Key API:
- `HomologicalComplex.Homotopy` — `Mathlib.Algebra.Homology.Homotopy`.
- `HomotopyEquiv.toQuasiIso` (or `Homotopy.toQuasiIso`) — homotopy equivalence ⟹ quasi-iso.

DEAD END — do NOT route through `SimplicialObject.Augmented.ExtraDegeneracy`.  That
interface has a different index convention and is not directly applicable here.
-/

end AlgebraicGeometry
