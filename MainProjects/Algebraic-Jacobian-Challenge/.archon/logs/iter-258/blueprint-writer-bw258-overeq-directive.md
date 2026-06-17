# blueprint-writer bw258-overeq

## Task
Author a NEW chapter `blueprint/src/chapters/Picard_SheafOverEquivalence.tex` for the SHARED-ROOT
construction `SheafOfModules.overEquivalence` and its corollaries. Add `\input` to
`blueprint/src/content.tex` in the Picard arc (near `Picard_TensorObjSubstrate`/`Picard_LineBundleCoherence`).

Put a coverage declaration at the top:
```
% archon:covers AlgebraicJacobian/Picard/SheafOverEquivalence.lean
```

## Strategy context (the slice that matters)
Two independent prover lanes (the `LineBundleCoherence` engine and the `DualInverse` dual chain)
reduce to ONE missing construction: the **modules-level lift** of the site equivalence
`TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U` with the **structure ring sheaf
transported** (the base ring genuinely varies between the two sides). The project already has the
fixed-value-category, Sheaf-of-Ab cousin `overSliceSheafEquiv` (in `Picard/TensorObjSubstrate.lean`),
built via `Functor.IsDenseSubsite.sheafEquiv` — it is INAPPLICABLE here because the ring varies.

A read-only Mathlib analogist (api-alignment, `analogies/overeq258.md`) established that **Mathlib
already provides the exact idiom**: `SheafOfModules.pushforwardPushforwardEquivalence`
(`Mathlib/Algebra/Category/ModuleCat/Sheaf/PushforwardContinuous.lean:305`) — "equivalence of
`SheafOfModules` categories from a site equivalence `e : C ≌ D` + a morphism of the two (different)
structure ring sheaves + coherences." The continuity hypotheses resolve by inference (the project's
`overEquivInverseIsDenseSubsite` + Mathlib auto-instances), so the apparent Mathlib-scale wall is much
smaller than feared: only the open-immersion structure-sheaf ring iso `φ` is genuine content. Estimate
~120–220 LOC, standalone file.

**READ `analogies/overeq258.md` (full construction skeleton, all Mathlib names confirmed with file:line)
and `informal/chartOverIso.md` (the engine's problem statement) before writing.** Also the blueprint
reviewer br258's outline (below) is your declaration scaffold.

## Declarations to blueprint (dependency order)

1. **`\definition` `def:sheafofmodules_over_equivalence`** —
   `\lean{AlgebraicGeometry.Scheme.Modules.overEquivalence}` [expected].
   The equivalence `SheafOfModules ((↑U).ringCatSheaf) ≌ SheafOfModules (X.ringCatSheaf.over U)`
   (for `X : Scheme`, `U : X.Opens`), the modules-level lift of `Opens.overEquivalence U` transporting
   the ring sheaf. Built as `SheafOfModules.pushforwardPushforwardEquivalence` applied to
   `e := Opens.overEquivalence U` with the open-immersion structure-sheaf ring morphism `φ` (sectionwise
   the `U.ι.appIso` open-immersion iso) and its inverse `ψ`, coherences `H₁ H₂`. Note in the prose that
   the two continuity legs resolve by inference (Mathlib `IsDenseSubsite ⇒ IsContinuous` + the project's
   `overEquivInverseIsDenseSubsite`), and that the only genuine content is `φ` (mirrors the project's
   inline `restrictFunctor` ring datum). Source: Archon-original assembling Mathlib primitives —
   provenance only, NO external literature, so NO `% SOURCE QUOTE`; carry a `% SOURCE:` code-location
   comment citing `Mathlib .../PushforwardContinuous.lean:305` (the same provenance style the existing
   `overSliceSheafEquiv` block uses).

2. **`\lemma` `lem:sheafofmodules_restrict_over_iso`** —
   `\lean{AlgebraicGeometry.Scheme.Modules.restrictOverIso}` [expected].
   For `M : X.Modules`: `overEquivalence.functor.obj (M.restrict U.ι) ≅ M.over U`, i.e. the equivalence
   carries `restrict ↦ over`. Proof: `M.restrict U.ι` is itself a `pushforward` along `U.ι.opensFunctor`;
   compose with `pushforward φ` via `SheafOfModules.pushforwardComp` (`= Iso.refl`), then `pushforwardNatIso`
   along the `eqToIso` of the two underlying `Over U ⥤ Opens X` functors (both `V ↦ V.left`). This mirrors
   the project's `restrictFunctorAdjCounitIso` verbatim. (`\uses{def:sheafofmodules_over_equivalence}`.)

3. **`\lemma` `lem:sheafofmodules_unit_over_iso`** —
   `\lean{AlgebraicGeometry.Scheme.Modules.unitOverIso}` [expected].
   `overEquivalence.functor.obj (SheafOfModules.unit (↑U).ringCatSheaf) ≅ SheafOfModules.unit (X.ringCatSheaf.over U)`,
   i.e. the equivalence carries `unit ↦ unit` (pushforward-of-unit up to `φ`). (`\uses{def:sheafofmodules_over_equivalence}`.)

4. **`\lemma` `lem:chart_over_iso`** —
   `\lean{AlgebraicGeometry.Scheme.Modules.chartOverIso}` [expected].
   The engine corollary: for `M : X.Modules`, `U : X.Opens`, and a trivialisation
   `e : M.restrict U.ι ≅ SheafOfModules.unit (↑U).ringCatSheaf`, build
   `chartOverIso M U e : M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U)` as the composite
   `(restrictOverIso).symm ≪≫ overEquivalence.functor.mapIso e ≪≫ unitOverIso`. This is the SOLE
   remaining sorry of `LineBundleCoherence.lean`'s engine (currently a local sorry-def there); making it
   a general lemma here lets the engine close by a one-liner next iter. NOTE in prose: the engine's
   local `chartOverIso` will be redirected to this general lemma next iter (naming caution — keep this
   one general in `M, U, e`). (`\uses{lem:sheafofmodules_restrict_over_iso, lem:sheafofmodules_unit_over_iso}`.)

Mention (prose only, no separate block needed unless natural) that the dual lane's `sliceDualTransport`
is a further consumer of the same equivalence (the internal-Hom commutes with the slice-site change),
to be wired in `DualInverse.lean` once the API lands.

## Out of scope
- Do NOT write the consumers' proofs (`LineBundleCoherence`/`DualInverse` close them in their own files).
- Do NOT add or remove `\leanok`/`\mathlibok` markers (the deterministic sync owns `\leanok`).
- Do NOT touch any other chapter.
