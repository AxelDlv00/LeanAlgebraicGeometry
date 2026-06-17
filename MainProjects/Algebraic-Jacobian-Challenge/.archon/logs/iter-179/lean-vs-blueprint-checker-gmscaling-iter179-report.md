# Lean ↔ Blueprint Check Report

## Slug
gmscaling-iter179

## Iteration
179

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (479 lines)
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (consolidated; the
  GmScaling-relevant `\lean{...}` blocks are at L1254, L1278, L1353, L1380, L1423,
  L1461, L1531, L1571)

## Per-declaration

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (chapter: `lem:projlinebar_isReduced`, L1254)
- **Lean target exists**: yes (L398)
- **Signature matches**: yes — `IsReduced (ProjectiveLineBar kbar).left` matches
  "the scheme underlying $\overline{\mathbb P^1}$ is reduced".
- **Proof follows sketch**: yes — chart cover `projectiveLineBarAffineCover` →
  per-chart `IsDomain` via `Function.Injective.isDomain` on
  `HomogeneousLocalization.val_injective` into `Localization.Away (X i)` →
  `IsReduced.of_openCover`. Mirrors the chapter's chart-by-chart prose.
- **notes**: axiom-clean iter-168; matches the chapter's footnote claim.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`, L1278)
- **Lean target exists**: yes (L319)
- **Signature matches**: yes —
  `ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar`, an Over morphism.
  The chapter explicitly names it as $\sigma_\times$.
- **Proof follows sketch**: yes (structurally) — the body uses
  `Over.homMk ((gmScalingP1_cover).glueMorphisms gmScalingP1_chart
  gmScalingP1_chart_agreement) gmScalingP1_over_coherence`, exactly as the iter-171
  inline-chart-glue commitment described.
- **notes**: laundering through the temp axiom propagates through
  `gmScalingP1_chart_agreement` (cocycle) and `gmScalingP1_over_coherence` (via
  `gmScalingP1_chart_PLB_eq`'s `sorry`). The chapter NOTE at L1280-1290 still
  accurately describes the body skeleton + three internal named scaffold sorries.

### `\lean{AlgebraicGeometry.gmScalingP1_cover}` (chapter: `def:gmscaling_cover`, L1353)
- **Lean target exists**: yes (L106)
- **Signature matches**: yes — `((ProjectiveLineBar kbar) ⊗ Gm kbar).left.OpenCover`
  via `projectiveLineBarAffineCover.openCover.pullback₁ (pullback.fst PLB.hom Gm.hom)`.
- **Proof follows sketch**: yes — the definition is a single
  `OpenCover.pullback₁` call; trivially matches the chapter prose.
- **notes**: axiom-clean.

### `\lean{AlgebraicGeometry.gmScalingP1_chart}` (chapter: `def:gmscaling_chart`, L1380)
- **Lean target exists**: yes (L156)
- **Signature matches**: yes — `(gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme kbar`.
- **Proof follows sketch**: partial — the construction recipe (chart-iso
  ≫ `Spec.map` of chart-ring eval₂Hom ≫ `Proj.awayι`) lines up with the chapter's
  "pullbackSpecIso ≫ Spec.map ≫ chart-ring iso ≫ Proj.awayι" prose. The Lean
  `match i with | ⟨0, _⟩ => invSelf | ⟨1, _⟩ => algebraMap (X())` branches mirror
  the chapter's "on chart 0 / on chart 1" prose split, with the chart-0 image
  being $\lambda^{-1}$ and chart-1 the algebra map of $\lambda$.
- **notes**: definition is fully built; downstream `chart_PLB_eq` body is where
  the chart-bridge mismatch lives.

### `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` (chapter: `lem:gmscaling_chart_agreement`, L1423)
- **Lean target exists**: yes (L261)
- **Signature matches**: yes — quantifies over `(gmScalingP1_cover).I₀`, asserts
  `pullback.fst ≫ chart x = pullback.snd ≫ chart y`. Matches the chapter equation
  verbatim.
- **Proof follows sketch**: NO — body is `exact (gmScalingP1_chart_data_temp kbar).2`,
  i.e. laundered through the temp axiom. The chapter prose (diagonal via
  `fst_eq_snd_of_mono_eq`; cross via the algebraic identity $\lambda \cdot u =
  (1/t) \cdot \lambda$ in $\mathrm{Localization.Away}\,t \otimes \mathtt{GmRing}$)
  is not actually implemented.
- **notes**: known iter-177 HARD STOP scaffold; per directive this is project-known
  and not newly laundered this iter.

### `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` (chapter: `lem:gmscaling_chart_PLB_eq`, L1461)
- **Lean target exists**: yes (L213)
- **Signature matches**: yes — exactly the chapter equation
  `chart kbar i ≫ PLB.hom = cover.f i ≫ (PLB ⊗ Gm).hom`.
- **Proof follows sketch**: partial — Steps (A) and (B) of the chapter's three-step
  reduction (apply `awayι_comp_PLB_hom`; merge `Spec.map`'s via
  `homogeneousLocalizationAwayIso_algebraMap` + `MvPolynomial.eval₂Hom_comp_C`)
  did land this iter as the `rw [h, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
  RingHom.comp_assoc, homogeneousLocalizationAwayIso_algebraMap,
  MvPolynomial.algebraMap_eq, MvPolynomial.eval₂Hom_comp_C]` chain. Step (C)
  remains an unsplit `sorry`.
- **notes**: see Blueprint adequacy comments below — the chapter's "Status
  (iter-174 → iter-175)" block (L1516-1523) is now STALE in two ways: (i) it
  reports "two residual scaffold sorrys on the i=0 and i=1 cases", but the
  current Lean body is uniform-in-`i` with ONE residual sorry; (ii) it
  attributes the residual to a "Fin-literal mismatch" between `X ⟨0,_⟩` and
  `X 0`, while the iter-179 Lean comment narrows the actual blocker to a
  `Spec`-middle-type elaboration discrepancy (same family as the
  `awayι_comp_PLB_hom` blocker that the body solved via `change`). Step (C)'s
  prescribed Mathlib weapons (`pullbackSpecIso_hom_base`,
  `pullbackRightPullbackFstIso_hom_fst`, `pullbackSymmetry_hom_comp_fst`) are
  in the Lean comment as having "silently refused to unify even with explicit
  `R, S, T`, even with `fin_cases i`, even with `Algebra.TensorProduct.algebraMap_def`
  unfolding" — the chapter recipe was attempted and failed.

### `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` (chapter: `lem:gmscaling_over_coherence`, L1531)
- **Lean target exists**: yes (L295)
- **Signature matches**: yes — `glueMorphisms _ _ ≫ PLB.hom = (PLB ⊗ Gm).hom`.
- **Proof follows sketch**: yes — `Scheme.Cover.hom_ext` + `ι_glueMorphisms_assoc`
  + per-chart certificate `gmScalingP1_chart_PLB_eq`. Mirrors the chapter's
  "Reduction" prose exactly.
- **notes**: structurally complete; `sorryAx` taint only propagates through the
  unsolved residual of `chart_PLB_eq`. The chapter's iter-174 status block
  accurately characterises this.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`, L1571)
- **Lean target exists**: yes (L358)
- **Signature matches**: yes — the lift/toUnit/zeroPt composite equals
  `toUnit ≫ zeroPt`, matching the chapter's "$\sigma_\times(0, \lambda) = 0$" prose.
- **Proof follows sketch**: NO — body is `gmScalingP1_collapse_at_zero_temp kbar`,
  laundered through the temp axiom. The chapter's `\begin{proof}` (chart-level
  reduction; chart-1 ring map sends `x ↦ 0`; chart-0 doesn't meet the section)
  is not implemented.
- **notes**: known iter-177 HARD STOP scaffold; per directive this is project-known
  and not newly laundered this iter.

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.gm_geomIrred` at L440: body is `:= by sorry`. The chapter
  prose (L1911) acknowledges this as a Mathlib scaffold gap, but no `\lean{...}`
  block in the blueprint pins this declaration, so the blueprint is silent about
  the scheme-level claim being made (and shipped as an `instance`). See
  blueprint-adequacy section.
- `AlgebraicGeometry.projGm_isReduced` at L470: body is `:= by sorry`. Same pattern
  as above — substantive instance shipped as scaffold-sorry with no `\lean{...}` pin.

### Excuse-comments

None found that are red flags. The L177-192 docstring for
`gmScalingP1_chart_data_temp` is a project-acknowledged HARD STOP corrective with a
specific TODO and a strategic-trace pointer (per the directive, these are
project-known and not newly introduced this iter). The L233-234 "PARTIAL —
iter-181 escalation will dispatch" inside `gmScalingP1_chart_PLB_eq` is a status
note, not an excuse: the body has real, landed progress (4 rewrite steps).

### Axioms / Classical.choice on non-trivial claims

- `AlgebraicGeometry.gmScalingP1_chart_data_temp` at L193: TEMP axiom packaging
  the per-chart over-coherence + chart cocycle agreement. Per directive this is
  iter-177 HARD STOP scaffold and project-known. The laundering through it
  (`gmScalingP1_chart_agreement` body and indirectly `gmScalingP1` body) has NOT
  spread to NEW declarations this iter — `gmScalingP1_chart_PLB_eq`'s partial
  body in particular does NOT consume the axiom.
- `AlgebraicGeometry.gmScalingP1_collapse_at_zero_temp` at L336: TEMP axiom for
  the fixed-point property. Per directive this is iter-177 HARD STOP scaffold
  and project-known. The laundering through it (`gmScalingP1_collapse_at_zero`
  body) has NOT spread to NEW declarations this iter.

The blueprint does NOT claim kernel-clean closure for any declaration whose Lean
body actually launders through these temp axioms — `\leanok` is the deterministic
syncer's job and reflects sorry-presence-only, not axiom-cleanliness.

## Unreferenced declarations (informational)

Substantive declarations in `GmScaling.lean` that no `\lean{...}` block in the
chapter pins:

- `awayι_comp_PLB_hom` (L54, `private`) — the chapter's per-chart Step (A)
  "chart-bridge" weapon. The chapter prose at L1487 and L1495 names it
  explicitly and assigns it a role, but there is no `\lean{...}` block; this is
  fine because it is `private`, but a pin would tie the prose to the symbol.
- `gmScalingP1_chart0_ringMap` / `gmScalingP1_chart1_ringMap` (L86, L95) — the
  chapter prose at L1395-1397 names both and asserts "axiom-clean iter-171". No
  `\lean{...}` blocks pin them. Mathematically substantive (they encode the
  chartwise ring maps); not the kind of pure helper that should remain
  invisible to the dependency graph.
- `gmScalingP1_cover_X_iso` (L124, `private`) — the chapter prose at L1506
  names it. `private`, so fine to leave un-pinned.
- `projGm_locallyOfFiniteType` (L387, `instance`) — proven, axiom-clean. Cited
  in the chapter's iter-167 NOTE at L1911 as a downstream `infer_instance`
  consumer. No `\lean{...}` block. Worth pinning — it's an exported product-stability
  instance, not a local helper.
- `gm_geomIrred` (L440, `instance`) — `sorry` body. No `\lean{...}` block.
- `projGm_geomIrred` (L452, `instance`) — proven via
  `GeometricallyIrreducible.comp _ _` (but transitively depends on
  `gm_geomIrred`'s sorry). No `\lean{...}` block.
- `projGm_isReduced` (L470, `instance`) — `sorry` body. No `\lean{...}` block.

## Blueprint adequacy for this file

- **Coverage**: 8/18 substantive declarations have a corresponding `\lean{...}`
  block in the chapter (the 8 pinned in "Per-declaration" above). Unreferenced
  declarations: 3 fine-as-helpers (`awayι_comp_PLB_hom`,
  `gmScalingP1_cover_X_iso`, both `private`; arguably `chart0_ringMap`/
  `chart1_ringMap`) + 4 substantive scheme-level claims missing pins
  (`projGm_locallyOfFiniteType`, `gm_geomIrred`, `projGm_geomIrred`,
  `projGm_isReduced`) + the 2 TEMP axioms (project-known, intentionally
  un-pinned).
- **Proof-sketch depth**: under-specified for `lem:gmscaling_chart_PLB_eq`.
  The chapter's Step (C) "chase the source-side pullback isos" prescribes
  `pullbackSpecIso_hom_base`, `pullbackRightPullbackFstIso_hom_fst`, and
  `pullbackSymmetry_hom_comp_fst` as the closing weapons, but the actual
  iter-179 prover finding (recorded in the Lean comment at L228-234) is that
  these lemmas "silently refused to unify even with explicit `R, S, T`, even
  with `fin_cases i`, even with `Algebra.TensorProduct.algebraMap_def`
  unfolding", and that the real blocker is a `Spec`-middle-type elaboration
  discrepancy (downstream of the same one that `awayι_comp_PLB_hom`'s body
  solved via `change`). The chapter recipe was attempted and is now known
  insufficient; the chapter still presents it as the route. Also, the
  "Status (iter-174 → iter-175)" block (L1516-1523) reports "two residual
  scaffold sorrys on the i=0 and i=1 cases", but the iter-179 refactor to the
  uniform-in-`i` `gmScalingP1_cover_X_iso` (directive's third "Known issue")
  flattened this to ONE generic-in-`i` `sorry`. Both items are stale prose.
- **Hint precision**: precise. Every `\lean{...}` hint in the chapter names a
  fully-qualified Lean declaration that exists with the right signature.
- **Generality**: matches need. No parallel-API mismatch detected.
- **Recommended chapter-side actions** (for a blueprint-writing follow-up; NOT
  must-fix-this-iter, since the chapter doesn't claim closure of these items):
  - Refresh `lem:gmscaling_chart_PLB_eq` "Status (iter-174 → iter-175)" block
    (L1516-1523) to (i) report 1 residual `sorry` (uniform-in-`i`), not 2 cases;
    (ii) describe the actual blocker as the `Spec`-middle-type elaboration
    discrepancy, not the Fin-literal mismatch (which was solved by the
    cover-bridge uniform-in-`i` refactor); (iii) note that the
    `pullbackSpecIso_hom_base` weapon family did not unify and a different
    Step-(C) approach is needed.
  - Optionally pin the 4 product-stability instances (`projGm_locallyOfFiniteType`,
    `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced`) with their own
    `\lean{...}` blocks under the existing iter-167 NOTE region (L1909-1934).
    Two of them ship as `sorry` and downstream consumers in
    `AbelianVarietyRigidity.lean` rely on them; the blueprint should expose
    them in the dependency graph so the sync_leanok phase can track them.
  - Optionally promote `gmScalingP1_chart0_ringMap` / `gmScalingP1_chart1_ringMap`
    to pinned `\lean{...}` blocks — the chapter already gives them roles in
    `def:gmscaling_chart`'s recipe, and they are axiom-clean and substantive.
  - Refresh `lem:gmScaling_fixes_zero` Status NOTE (L1573-1579) to clarify that
    the residual gate is the same `chart_PLB_eq` Step (C) blocker (the L578-579
    "Once `gmScalingP1_chart` has a concrete body, this collapse lemma reduces
    via chart-1 to the ring-level identity" reading is stale: `gmScalingP1_chart`
    has had a concrete body since iter-173, and the actual blocker is `chart_PLB_eq`).

## Severity summary

- **must-fix-this-iter**: none. The two TEMP axioms and their downstream
  laundering are project-known iter-177 scaffolds per the directive, with no
  new spread this iter; the blueprint does not claim kernel-cleanness on the
  laundered declarations.
- **major**: (1) stale "Status (iter-174 → iter-175)" prose in
  `lem:gmscaling_chart_PLB_eq` (L1516-1523) — it misreports the current
  iter-179 state (1 generic-in-`i` sorry, not 2 case-split sorrys; blocker
  reidentified as `Spec`-middle-type elaboration, not Fin-literal mismatch;
  Step (C) recipe shown ineffective). (2) 4 substantive
  exported-for-Lane-B instances (`projGm_locallyOfFiniteType`, `gm_geomIrred`,
  `projGm_geomIrred`, `projGm_isReduced`) are not pinned by `\lean{...}`
  blocks; two of the four ship with `sorry` bodies, and downstream
  consumers depend on them.
- **minor**: (1) `awayι_comp_PLB_hom`, `gmScalingP1_chart0_ringMap`, and
  `gmScalingP1_chart1_ringMap` named in chapter prose but not `\lean{...}`-pinned.
  (2) `lem:gmScaling_fixes_zero` Status NOTE references the wrong gate
  (`gmScalingP1_chart` body vs the actual `chart_PLB_eq` Step (C) blocker).

Overall verdict: 8 `\lean{...}` blocks all signature-correct and Lean-mapped;
file body matches the chapter mathematically; the chapter's iter-174/iter-175
status prose for `lem:gmscaling_chart_PLB_eq` has drifted enough this iter to
mislead and should be refreshed, and 4 substantive exported instances are
missing blueprint pins; no must-fix-this-iter findings.
