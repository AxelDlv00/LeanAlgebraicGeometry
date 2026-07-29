Filed: I-1094, I-1095, I-1096 (issues), I-1097 (memory). No source files edited, nothing committed.

# VERDICT: CHURNING

The file is real, compiles, and has no `sorry`. But of its 8 declarations, **2 carry the claimed content, 4 are mathlib instantiations, and 2 are duplicates or generic**. The round's headline finding ("leaf B is ONE obligation, the smooth half absorbed") is a definitional unfolding presented as a reduction — and it has already been propagated to three other files, so the next round inherits it as a project fact. Leaf B is not measurably closer.

Build state for every probe below: `lake build AlgebraicJacobian` **EXIT=0, 8864 jobs** (two retries needed — genuine concurrent-write races, "object file does not exist" and "no such file or directory"). Control: a deliberately sorried theorem reports `[sorryAx]`, so the probe detects it.

## Claim 1 — CONFIRMED

`geometricallyReduced_of_leafB` is real, non-vacuous, and in the claimed direction. `SmoothOfRelativeDimension.geometricallyReduced` exists at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Curve/GeometricallyReduced.lean:159`, `#print axioms` on both new theorems gives `[propext, Classical.choice, Quot.sound]`. The "invisible from Pic0Et.lean's cone" justification checks out: I walked the import closure — `Pic0Et` reaches 196 modules and does **not** contain `Curve.GeometricallyReduced`; the root reaches 311 and does.

One caveat on novelty, not correctness: `git log -S "obligation 4 implies"` shows the same finding already at HEAD in `Pic0EtStructure.lean` via `4f4b38ca5c` (23:41), eleven minutes **before** commit `27127110a4` (23:52). The file's docstring and the release note both credit ajc-p3 as independent reproduction, which is fair.

## Claim 2 — REFUTED

`#print AlgebraicGeometry.Scheme.Pic0Et.leafB_of_chartwise` gives its entire body:

```
fun {k} [Field k] C ... hchart => (Scheme.Pic0Et.leafB_iff_appLE C).mpr hchart
```

and `#print` on `leafB_iff_appLE` gives `HasRingHomProperty.iff_appLE`. So it is exactly `iff_appLE.mpr` — the failure mode of I-1021/I-1023/I-1024. The docstring names `RingHom.IsStandardSmoothOfRelativeDimension.isStandardSmooth` as the absorption mechanism; that lemma is invoked by no declaration in the file. Smoothness is absent from the hypothesis because `iff_appLE`'s RHS *is* the class, not because absorption was proved.

Worse for the "reduction" reading: `#print AlgebraicGeometry.SmoothOfRelativeDimension` shows the class field is `∀ x : X, ∃ U, ∃ V affine, …` — pointwise-exists. `leafB_of_chartwise` demands the condition on **every** chart pair. Probe `leafB_from_pointwise` (`/tmp/revp/p9.lean`, EXIT=0) closes leaf B from the exists-form with the bare anonymous constructor `⟨h⟩`. The hypothesis is a strengthening, not a reduction.

## Claim 3 — REFUTED as stated

The synthesis failure is real: `infer_instance` for `HasRingHomProperty @Smooth (Locally IsStandardSmooth)` gives `synthInstanceFailed`. But the **proposition** is a mathlib theorem, proved in four lines at `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:88-91`; probe `smooth_does_carry_it` reproduces them, axiom-clean. And `RingHom.smooth_iff_locally_isStandardSmooth` is an **iff**, so `locally_isStandardSmooth_appLE_of_smooth` is one direction of an equivalence — probe `converse_probe` (`/tmp/revp/p4.lean`, EXIT=0, axiom-clean) recovers `Smooth` from precisely its conclusion. A synthesis result was written up as a mathematical one and copied into `Jacobian.lean:445-447`.

## Claim 4 — OVERSTATED, and unfair to the sibling

The equality itself is correct but wholly generic: probe `generic_eq` proves it for an **arbitrary** property `P` by the same single `rw`. `chart_comp_pointTranslation_eq` is closed by bare `simp`, and `GrpObj.pointTranslationIso_hom_comp_assoc` already exists (`@[reassoc]`-generated) — a duplicate.

The "circular" charge misreads `RelativeDimensionLocal.lean`. Its `:117-137` shows `smoothOfRelativeDimension_pointTranslationIso` feeds `smoothOfRelativeDimension_of_translation_cover`, whose antecedent is `∀ i, SmoothOfRelativeDimension n (𝒰.f i ≫ d.J.hom)` — a chart inclusion composed on the **left**, not the structure morphism precomposed with a translation. Different composite. The accurate verdict is "trivial by `rw` under its instance binder" (probe `sibling_shape`, two tactics), which their own docstring anticipates.

"Contributes nothing to the numeral" fails against the pointwise field: homogeneity is exactly what turns one chart at the identity into all points, and `SmoothOfRelativeDimension` **is** `IsLocalAtSource` for `zariskiPrecoverage` (`infer_instance`, EXIT=0). Section 3 dismisses the route the sibling correctly identified.

## Claim 5 — CONFIRMED, both halves

`#print axioms` on all 8 declarations: `[propext, Classical.choice, Quot.sound]`. At a use site with `[HasPicSchemeEt C]` dropped so the instance synthesizes, `useSite` and `useSite2` both report `[propext, sorryAx, Classical.choice, Quot.sound]`; `cleanControl` (no `HasPicSchemeEt`) stays clean. The header sentence at lines 95-97 is accurate as written.

## Claim 6 — two cited names do not exist

Lines 68-79 cite `leafB_of_affineCover_translationInvariant` ("records what that buys") and `translation_comp_eq` twice. `#check` on all three candidate spellings: unknown constant. Project-wide grep: the only occurrences are those three prose lines. Section 3 describes a two-lemma structure in which one lemma was never written and the other is misnamed. Everything else checks — `iff_of_isStandardSmooth`, `Smooth.locally_isStandardSmooth`, `iff_of_iSup_eq_top`, `pointTranslationIso_hom_comp`, blueprint labels `cor:sm`/`thm:tgtsp` — all resolve.

File audited: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0EtRelativeDimension.lean` (HEAD and disk byte-identical). Probes in `/tmp/revp/`.
