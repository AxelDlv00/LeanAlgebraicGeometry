Audit complete. Findings below.

## 1. Import closure of AJCR `RiemannRoch/FLVVanishing.lean` (59 `AlgebraicJacobian.*` modules)

(a) **Already in AJC's Ledger under the same basename — 35 modules, 9087 lines.** `Algebra/DedekindColength`, `Algebra/TwoLattice`, `Cohomology/{AffineCech, AffineVanishing, Finiteness, FinitenessP1, MayerVietoris, ModuleKSheaf, OverOpen, TwoCover}`, `Curve/{Basic, DedekindSections, MapToP1, P1, P1Charts, P1Points, RationalToP1, Sections, StalksDVR}`, `RiemannRoch/{Chi, ChiCurve, ChiFiniteness, ChiLedger, ChiSlice, ClosedPoint, Devissage, DevissageExact, Divisor, DivisorSheaf, DivisorSheafZero, JumpDimension, MulEquiv, PrincipalDivisor, ResidueDegree, Skyscraper}`.

(b) **Present elsewhere in AJC at the same module path — 1:** `AlgebraicJacobian.Curve.GeometricallyReduced` (178 lines). AJC's `Ledger/ChiCurve.lean` and `Ledger/MapToP1.lean` already import it unqualified, so it needs no port.

(c) **MISSING — 23 modules, 6806 lines** (list in §3).

One deviation worth flagging: AJC `Ledger/ChiCurve.lean` is *not* byte-identical. It replaces AJCR's `genus` (from `AlgebraicJacobian.Challenge`) with a local `ledgerGenus`, precisely to keep `Challenge.lean` out of the tree. That decision is already made and holds for this port.

## 2. Load-bearing verdict per missing module

**LOAD-BEARING (7 modules, 2477 lines)** — verified by extracting every declaration block and computing the transitive name closure from the two target theorems, then re-checking each cross-module edge by direct grep:

| module | declarations actually reached |
|---|---|
| `Cohomology/QcohSections` (264) | `secRes`, `secRes_secRes`, `secRes_naturality`, `secRes_moduleKSheaf`, class `Scheme.QcohOn` (all 10 fields), `qsmul_zero`, `qsmul_sub`, `sum_qsmul`, `Scheme.moduleKSheaf.instQcohOn` |
| `Cohomology/AffineVanishingQcoh` (365) | `exists_cech_cobounding_of_qcoh`, `cokernel_app_surjective_of_qcoh`, `subsingleton_hModule'_one_of_qcoh` |
| `RiemannRoch/FiberTwist` (403) | **only 7 of 31**: `fiberChart₀`, `fiberChart₁`, `fiberCoord`, `preimage_inf_eq_basicOpen_fiberCoord`, `isUnit_fiberCoord_res_inf`, `genericPoint_mem_preimage_inf`, `germ_fiberCoord_{ne_zero, mem_nonZeroDivisors}` |
| `RiemannRoch/FLVFiberToolkit` (370) | 19 of 23, incl. `fiberCoord₁`, `fiberCoordUnit`(+4 order lemmas), `fiberWeilDivisor`(+3 `coeffAt` lemmas), `fiberCoord_mul_fiberCoord₁_res` |
| `RiemannRoch/FLVLattice` (311) | `fiberLattice`, `fiberLattice_mono`, `iSup_fiberLattice`, `divisorSections_add_nsmul_fiberWeilDivisor_overlap`, `coeffAt_nsmul`, `coeffAt_add_nsmul_chart₀/_of_mem_chart₁`, `divisorBound_congr/_le_iff`, `mem_boundedSections_unit_iff` |
| `RiemannRoch/FLVQcoh` (449) | `Scheme.divisorSheaf.instQcohOn` and `IsAffineOpen.subsingleton_hModule'_divisorSheaf_one` plus their private support |
| `RiemannRoch/FLVVanishing` (315) | the two targets, `fiberLatticeOverlap`(+2), `fiberLatticeH1Equiv`, `divisorVal_{sub,moduleDiff}`, `range_moduleDiff_eq_comap`, `map_ofEq_comap_subtype`, `Submodule.eventually_eq_top_of_monotone_of_iSup_eq_top` |

**NOT LOAD-BEARING (16 modules, 4329 lines).** The entire `Picard.*` chain plus `Challenge` and `RiemannRoch/Degree` contribute **zero** referenced declarations, with one exception:

- `Picard/PresentationDivisor` (206) contributes exactly 4 one-line `Finsupp` wrappers: `CurveDivisor.coeffAt_{zero, add, neg, sub}` and `coeffAt_divOf` (which is `rfl`). Absent from AJC. These are 5 trivial lemmas, not a file to port.
- `Picard/{MeromorphicPresentation, DivisorClass, Pic, UnitsCocycle, CechH1, UnitsPresheaf}` (1988 lines) enter solely as the transitive prefix of that one import line, `FLVQcoh.lean:9 import AlgebraicJacobian.Picard.PresentationDivisor`.
- `RiemannRoch/Degree` (244) + `Picard/{DivisorClassCompat, DivisorClassMeromorphic, PointDivisor, PointPresentation, PresentationCalculus, PresentationClassLaw, PresentationExtraction}` + `AlgebraicJacobian.Challenge` (1798 lines) enter solely via `FiberTwist.lean:8 import AlgebraicJacobian.RiemannRoch.Degree`, needed only by `classDeg_fiberTwist` and the `fiberDivisor`/`fiberTwist`/`fiberCocycle` Picard-class block — none of it reached from the targets. `Challenge` enters one level further, via `Degree -> ChiCurve -> Challenge`.

Direct confirmation: grepping the 6 cone files for `unitsCocycle`, `unitsH1`, `unitsAppLE`, `unitsEvInf`, `CechPic`, `picClass`, `classDeg`, `MeromorphicPresentation`, `presentationDivisor`, `PointedCover`, `LocalEquations`, `ratioUnit`, `OneCocycle`, `divisorClass`, `pointDivisor`, `genus` returns **nothing** in any of them (comments stripped). Every Picard hit in the automated pass traced through generic short names (`map_comp`, `res_ev`, `ext`, `of`).

I also verified the converse direction: every Ledger-side name referenced by the 7 load-bearing files already exists in AJC (`twoCoverH1LinearEquiv`, `moduleFinite_hModule_one_of_isFinite_toP1`, `isAffineOpen_preimage_chartOpen`, `preimage_chartOpen_sup`, `divisorSections/Bound/Val`, `mulByUnit`, `ordZ`, `divOf`, `coeffAt`, `ord_algebraMap_stalk_le_one`, `ord_eq_one_of_mem_basicOpen`, `genericPoint_mem_of_nonempty`, `basicOpen_awayToSection_chartCoord`, `chartOpen`/`chartCoord`/`X_mul_X_mem`). No gaps.

## 3. Line counts

- Total missing: **6806** lines (23 modules).
- Load-bearing missing: **2477** lines (7 modules), of which `FiberTwist` only needs its first ~245 lines.
- Discardable: **4329** lines (63.6%), all `Picard.*` + `Challenge` + `Degree`.

## 4. `AffineVanishingQcoh` / `QcohSections` counterparts in AJC — partial, and not usable as-is

- `QcohSections`: AJC has `secRes`, `secRes_secRes`, `secRes_naturality`, `secRes_moduleKSheaf` at `Ledger/AffineVanishing.lean:137-159`, byte-identical bodies, but **declared `private`** — invisible outside that file. The class `Scheme.QcohOn` and the entire `qsmul` layer do **not exist anywhere in AJC** (`grep QcohOn` across `AJC/AlgebraicJacobian/` = 0 hits).
- `AffineVanishingQcoh`: AJC's closest is `Cohomology/StructureSheafModuleK/QuasicoherentDegreeOneVanishing.lean:719` `subsingleton_hModule'_one_of_isAffineOpen_of_isQuasicoherent`. **Different carrier**: it is stated for `M : C.left.Modules` with `[M.IsQuasicoherent]` via `toModuleKSheafOfModules`, on `Scheme.HModule'` from `StructureSheafModuleK/Carriers.lean:88` (sheafified-representable `Ext`, `Field k`, indices `(F)(n)(X)`). AJCR/Ledger `HModule'` is `Sheaf.HModule'` from `Ledger/OverOpen.lean:272`, `Abelian.Ext (freeModuleSheaf J R U) F n`, `CommRing R`, indices `(F)(U)(n)`. Two different `Ext` modules with no comparison lemma in the tree. The Ledger `divisorSheaf` is a bare `Sheaf … (ModuleCat K)`, not a `Scheme.Modules`, so the AJC theorem cannot even be applied to it. `AffineVanishingQcoh` must be ported.
- `Ledger/{AffineVanishing, AffineCech, TwoCover, TwoLattice}` are the *structure-sheaf* half and are already the right carrier; `AffineVanishingQcoh` is exactly their generalization from `moduleKSheaf` to any `QcohOn` sheaf.

## 5. Name collisions

**Live and material:**
- `secRes`, `secRes_secRes`, `secRes_naturality`, `secRes_moduleKSheaf` — same names, same namespace `AlgebraicGeometry`, same bodies, `private` in `AJC/…/Ledger/AffineVanishing.lean`. Same meaning, so no soundness risk, but a public port will shadow/clash inside `AffineVanishing.lean`'s own scope only if both are imported into one file. Cheapest resolution: put the public copies in the new port and leave the privates alone (Lean tolerates this since the AJC ones are private).
- **`Ledger/FiberChart.lean` landed mid-audit** (timestamp after my initial listing; 171 lines) and already contains 7 of the 8 `fiberChart₀/fiberChart₁/fiberCoord/preimage_inf_eq_basicOpen_fiberCoord/isUnit_fiberCoord_res_inf/genericPoint_mem_preimage_inf/germ_fiberCoord_*` declarations, bodies unchanged, with a docstring making the same load-bearing argument as this audit. **A `FiberTwist` port would now be a duplicate — drop it from the plan and import `Ledger/FiberChart` instead.** Its docstring also forward-references `Ledger/FiberVanishing.lean`, which does not exist yet; another lane may be mid-port. Coordinate before writing.
- `preimage_overlap_eq` / `preimage_overlap_le` — `private` on both sides (AJCR `FLVFiberToolkit:71,75`; AJC `Ledger/Finiteness.lean:81,86`). Harmless.

**Priority names, all clear:**
- `Scheme.CurveDivisor.deg` — one definition per project, both at `…/Divisor.lean:61`, identical. No divergence.
- `fiberWeilDivisor` — **zero occurrences in AJC.** No collision.
- `*Degree*` — AJC has `PicScheme.ClassDegree` / `classDegree` (`Picard/IdentityComponent.lean`), a *relative* degree homomorphism on a Picard scheme; AJCR's `classDeg` (`RiemannRoch/Degree.lean`) is the absolute Čech-Pic degree. Different objects, different names, and neither is load-bearing here — no action needed.
- `subsingleton_hModule'_divisorSheaf_one`, `instQcohOn`, `fiberLattice*`, `fiberCoordUnit`, `divisorQsmul`, `coeffAt_nsmul`, `divisorBound_le_iff`, `mem_boundedSections_unit_iff`, `coeffAt_divOf_inv`, `divisorBound_congr`, `eventually_eq_top_of_monotone_of_iSup_eq_top` — all 0 hits in AJC.
- `Challenge.lean`'s `genus`/`Jacobian`/`ofCurve`/`functor`/`congr` **do** collide with AJC's `Genus.lean:41`, `Jacobian.lean:737/172`, etc. This is the collision that `ledgerGenus` was invented to avoid, and it is a second reason not to port `Challenge`.

## Recommended minimal port list, in order

1. `Ledger/QcohSections.lean` ← AJCR `Cohomology/QcohSections.lean` (264). Imports `Ledger.ModuleKSheaf`, `Ledger.AffineCech`. Publishes `secRes` + `Scheme.QcohOn` + `moduleKSheaf.instQcohOn`.
2. `Ledger/AffineVanishingQcoh.lean` ← AJCR `Cohomology/AffineVanishingQcoh.lean` (365). Imports 1 + `Ledger.AffineVanishing`.
3. **Nothing** — `Ledger/FiberChart.lean` already covers the FiberTwist need (verify at HEAD before relying on it).
4. Five `coeffAt` wrappers from AJCR `Picard/PresentationDivisor.lean:64-103` (`coeffAt_{zero,add,neg,sub}`, `coeffAt_divOf`) — inline into step 5's file or add to `Ledger/Devissage.lean` next to `coeffAt`. ~15 lines. **Do not port `PresentationDivisor.lean`.**
5. `Ledger/FLVFiberToolkit.lean` ← AJCR (370), minus nothing; imports `Ledger.FiberChart`, `Ledger.MulEquiv`, `Ledger.ResidueDegree`.
6. `Ledger/FLVLattice.lean` ← AJCR (311); imports 5, `Ledger.TwoCover`, 2.
7. `Ledger/FLVQcoh.lean` ← AJCR (449); imports `Ledger.MulEquiv`, `Ledger.DivisorSheafZero`, `Ledger.Devissage`, 2, and step 4's lemmas in place of `Picard.PresentationDivisor`.
8. `Ledger/FLVVanishing.lean` ← AJCR (315); imports 6, 7, `Ledger.ChiFiniteness`, `Ledger.Finiteness`.

Total to write: **~2075 lines** across 6 files (2477 minus FiberTwist's 403, plus ~15 for the `coeffAt` wrappers). The only edits to AJCR bodies are the 8 import-line rewrites and replacing `Picard.PresentationDivisor` with the local `coeffAt` lemmas in two files (`FLVQcoh`, `FLVLattice`/`FLVFiberToolkit`).

Key paths:
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/FLVVanishing.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/QcohSections.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishingQcoh.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/FiberChart.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/AffineVanishing.lean` (private `secRes`, lines 137-171)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK/QuasicoherentDegreeOneVanishing.lean:719` (wrong-carrier near-miss)

No files were modified. No builds were run.
