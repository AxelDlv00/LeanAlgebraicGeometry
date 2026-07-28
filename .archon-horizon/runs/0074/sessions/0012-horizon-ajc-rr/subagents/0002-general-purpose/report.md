All clean. The earlier failures were my probe writing the `haveI` inside a statement where Lean elaborates the type before the `haveI` binds — a probe artifact, not a carrier problem.

## Bottom line: **(b) a bounded port — carriers match exactly, no comparison isomorphism needed**

The single most important question is settled favorably: **the carriers are `rfl`-identical, not merely isomorphic.** AJC's `ExtensionUniformity.lean:77-81` explicitly flags this as unsettled ("Whether those agree up to defeq or need a comparison isomorphism is a real question and is **not** settled in this file"). It is now settled: they agree by `rfl`.

### 3. Carrier match (verified by elaboration, not by reading)

AJCR's definitions, verbatim:
- `overSpec` — `/…/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/SectionsBaseChange.lean:97`
  ```lean
  noncomputable abbrev overSpec : Over (Spec (.of k)) :=
    Over.mk (Spec.map (CommRingCat.ofHom (algebraMap k A)))
  ```
- `baseChangeBundle` — `/…/Cohomology/TransitionSectionsBaseChange.lean:116`
  ```lean
  noncomputable abbrev baseChangeBundle (K : Type u) [Field K] [Algebra k K] :
      Over (Spec (.of K)) := Over.mk (snd C (overSpec k K)).left
  ```
- The `⊗` is **not** a project notation. It is Mathlib's cartesian-monoidal product on `Over S`, activated by a *global* instance at `Mathlib/AlgebraicGeometry/Pullbacks.lean:705`. Mathlib provides `Over.tensorObj_left : (R ⊗ S).left = Limits.pullback R.hom S.hom := rfl` and `Over.snd_left : (snd R S).left = pullback.snd _ _ := rfl` (`Mathlib/CategoryTheory/Monoidal/Cartesian/Over.lean:60,79`).

So AJCR's `baseChangeBundle C K` unfolds by `rfl` to `Over.mk (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k K))))`, which *is* AJC's `Scheme.baseChangeField C κ`. I confirmed by elaboration that `(baseChangeBundle C K).left`, `.hom`, and the bundled `Over`-objects are each `rfl`-equal to AJC's, and that AJC's `IsProper` / `SmoothOfRelativeDimension 1` / `GeometricallyIrreducible` instances are accepted on the AJCR spelling via `inferInstanceAs`.

There is a **second** carrier axis, which AJC has already bridged. AJC's frozen `genus` (`AlgebraicJacobian/Genus.lean:41`) uses `Scheme.HModule k (Scheme.toModuleKSheaf C) 1` at `Type (u+1)`; AJCR uses `Sheaf.HModule (C.left.moduleKSheaf k) 1` at `Type u`. These are *not* defeq. But AJC already owns `ledgerGenus` (`Ledger/ChiCurve.lean:131`, AJCR's `genus` verbatim) and `ledgerGenus_eq_genus` (`Ledger/GenusBridge.lean:103`), proved sorry-free via `Abelian.Ext.chgUnivLinearEquiv`. I verified `ledgerGenus_eq_genus` elaborates on `Scheme.baseChangeField C K`. Also `Ledger/ModuleKSheaf.lean` is **byte-identical** to AJCR's `Cohomology/ModuleKSheaf.lean` (`diff` empty).

### 1. Incremental closure

Transitive `AlgebraicJacobian.*` closure: **67 modules** (all resolve in AJCR). Applying the direct-or-`RiemannRoch/Ledger/` rule: **38 present** (37 via Ledger, 1 direct: `Curve/GeometricallyReduced.lean`), **29 absent, 7852 lines**.

Absent, by cluster:
- **Head chain (5 files, 1541 lines)**: `Cohomology/H1BaseFieldInvariance` 384, `Cohomology/RelativeH1BaseChange` 373, `Cohomology/TransitionSectionsBaseChange` 300, `Curve/BaseChangeInstances` 197, `Cohomology/RelativeTwoCover` 175 (+ `Cohomology/RelativeSectionsLinear` 287, `Cohomology/SectionsBaseChange` 360, `Cohomology/TwistedSheaf` 500 — engine, 2688 total for all 8)
- **Picard cluster (18 files, 4394 lines)**: `CechH1` 501, `DivisorClass` 466, `PointDivisor` 382, `PointPresentation` 368, `UnitsCocycle` 371, `Pic` 279, `MeromorphicPresentation` 238, `RelPic` 233, `PresentationDivisor` 206, `UniversalSections` 195, `PresentationCalculus` 193, `DivisorClassMeromorphic` 191, `PresentationClassLaw` 173, `AffineTwoCover` 161, `DivisorClassCompat` 157, `PresentationExtraction` 130, `RelPicAlgebra` 105
- **Other**: `Challenge` 287, `Curve/BaseFieldTransition` 253, `RiemannRoch/Degree` 244

### 2. Dependency vs bundling

By namespace-qualified declaration reference, all 29 are formally reachable — but two edges are thin and cut the port roughly in half:

- **`Challenge.lean` (287 lines) is bundling for the math.** Only `genus` (lines 89-92) is used, and AJC already has it twice over (`genus`, `ledgerGenus`). Do not port this file.
- **The 4394-line Picard cluster hangs on two narrow edges:**
  1. `Curve/BaseFieldTransition` → `Picard/RelPicAlgebra` for `Over.overSpecMap`. I read `RelPicAlgebra.lean` in full: `Over.overSpecMap` and its three lemmas are lines 37-78, **entirely self-contained** (only `Spec.map`, `CommRingCat.ofHom`, `Over.homMk`). The `relPicAlgMap` half (lines 80-103) is what imports `RelPic` and drags in the cluster. Extracting ~40 lines severs it.
  2. `Curve/BaseChangeInstances` → `RiemannRoch/Degree` for `classDeg`, used **only** in `classDegBaseChangeSmoke` (line 193), a `private` smoke test. Deleting it severs `Degree` → `DivisorClassCompat` → the entire divisor-class subtree.
- Also: `H1BaseFieldInvariance` needs from the 300-line `TransitionSectionsBaseChange` **only** the 3-line `baseChangeBundle` abbrev; it references nothing built on `isPullback_baseFieldTransition` (grep count: 0). And AJC's `baseChangeField` already supersedes it.
- `Picard/AffineTwoCover` (161) and `Picard/UniversalSections` (195) are genuine: `RelativeTwoCover` needs `AffineTwoCover` and `Over.universalSectionsEquiv`. `Picard/CechH1` is needed only for `H1.resHom` plumbing.

### 4. Does AJC already have it? No.

AJC has **zero** H¹/section-space base-change statements along a field extension. `overSpec` appears in 2 files, both in prose only. `sectionsBaseChange`, `relSectionsBaseChange`, `relCurve`, `relTwoCoverH1`, `twistSubmodule`, `universalSectionsEquiv`, `AffineTwoCover`: **0 files each**.

What AJC does have, sorry-free:
- `Scheme.baseChangeField` + 9 stability instances (`RiemannRoch/CurveBaseChange.lean:250-340`)
- `Scheme.geometricallyIrreducible_hom_baseChangeField` (`Ledger/ExtensionUniformity.lean:124`)
- `ledgerGenus_eq_genus`, `moduleKSheaf_eq_toModuleKSheaf` (`Ledger/GenusBridge.lean` — grep for `sorry`: NONE)
- `uniformVanishing_of_genus_invariant` — **conditional**, taking `hgenus : ∀ κ, genus C_κ = genus C` as a hypothesis. This is the consumer waiting on the port.

### 5. Sorry/axiom honesty

`lean_verify` on the built oleans: both `AlgebraicGeometry.finrank_h1_baseField` and `AlgebraicGeometry.genus_baseField` depend on exactly `[propext, Classical.choice, Quot.sound]` — **no `sorryAx`**. Genuinely sorry-free.

Across all load-bearing absent modules, the **only** real sorries are 15 in `Challenge.lean` (lines 99, 108, 113, 117, 121, 126, 134, 147, 156-158, 248, 259, 272, 283) — all in `Jacobian`, `instGrpObj`, `ofCurve`, `functor` etc., i.e. the Jacobian challenge statement itself. `genus` at lines 89-92 is sorry-free, and it is the only thing needed. 3 further `sorry` occurrences in that file are inside docstrings. **Every other load-bearing module: 0 sorries, 0 axioms.**

### Sizing

Naive: 29 files / 7852 lines. After dropping `Challenge.lean` and severing the two thin edges, the realistic port is **~9-11 files / ~2700-2900 lines**: the 8 head+engine files (2688), plus a ~40-line `overSpecMap` extraction, plus `Picard/AffineTwoCover` (161) and `Picard/UniversalSections` (195), minus `TransitionSectionsBaseChange`'s 297 non-`baseChangeBundle` lines. Two known frictions, both mechanical: instances must be re-keyed onto whichever carrier spelling the ported statements use (`inferInstanceAs` works, verified), and the final statement must route through `ledgerGenus_eq_genus` to reach AJC's frozen `genus`. No comparison isomorphism is required anywhere.
