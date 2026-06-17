# blueprint-writer directive — AVR + BareScheme must-fix iter-197

## Chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

This is a CONSOLIDATED chapter (declares `% archon:covers
AlgebraicJacobian/AbelianVarietyRigidity.lean
AlgebraicJacobian/Genus0BaseObjects.lean
AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean ...`). It gates
prover re-dispatch on BOTH `AbelianVarietyRigidity.lean` and
`BareScheme.lean` per HARD GATE.

## Strategy context (slice that matters)

The genus-0 rigidity chapter underpins Route C: `J = Spec k` trivial,
every morphism `f : C → A` (`C` rational, `A` abelian variety) is
constant. The Lean development has TWO live Lane E sorries at
`AbelianVarietyRigidity.lean` (`kbarChart1Ring_specMap_fac` L326 +
`iotaGm_chart1_appIso_eval` L532), both blocked on the iter-196
analogist recipe `lane-e-proj-appiso-pivot` which prescribes 3
substrate primitives:

1. `Proj.awayι_eq_specMap_fromSpec` — LANDED iter-196 axiom-clean
   (Lean L203).
2. `Proj.awayι_app_basicOpen` — NOT YET LANDED; iter-196 prover hit
   the `Scheme.Hom.app` dependent-motive blocker.
3. `Proj.awayι_appIso_top_inv_apply_isLocElem` — gated on (2).

For BareScheme, two sorries: `projectiveLineBar_smoothOfRelDim` (L325)
— structurally reduced iter-196 to a per-chart aux gated on ChartIso
— and `projectiveLineBar_geomIrred` (L218) — bare sorry, ~200-350
LOC substrate gap unchanged.

The lean-vs-blueprint-checker `avr` (iter-196) flagged 1 must-fix +
4 majors; the lean-vs-blueprint-checker `barescheme` (iter-196)
flagged 1 must-fix + 2 majors. Both HARD-GATE the consolidated
chapter. Address all must-fixes + the majors that have a low-cost fix.

## Must-fix this iter

### M-1. Add a `\begin{lemma}` block for `Proj.basicOpenIsoSpec_inv_app_top`

This is the iter-196 prover's named missing intermediate helper that
caused the dependent-motive blocker. Insert immediately before
`lem:awayi_app_basicOpen`:

```latex
\begin{lemma}[Inversion of $\Proj.\basicOpenIsoSpec$ at $\top$]
  \label{lem:basicOpenIsoSpec_inv_app_top}
  \lean{AlgebraicGeometry.Proj.basicOpenIsoSpec_inv_app_top}
  For \(\AA : \mathbb N \to \sigma\), \(f \in \AA_d\), \(d > 0\),
  \begin{align*}
    (\Proj.\basicOpenIsoSpec\,\AA\,f\,f_{\deg}\,h_m).\inv.\app\,\top
    \;=\;\;
      &(\Proj.\basicOpen\,\AA\,f).\topIso.\hom\\
      &\quad\cc\;(\Proj.\basicOpenIsoAway\,\AA\,f\,f_{\deg}\,h_m).\inv\\
      &\quad\cc\;(\Scheme.\GammaSpecIso\,\_).\inv
  \end{align*}
  Equivalently: the inverse of \(\basicOpenIsoSpec\) evaluated on the
  whole space \(\top\) factors as the chain
  \(\topIso\)-followed-by-inversions of the two component isos.
\end{lemma}
\begin{proof}
  \uses{}
  Set \(\beta := \Proj.\basicOpenIsoSpec\,\AA\,f\,f_{\deg}\,h_m\).
  By \(\Scheme.\invApp\), \(\beta.\inv.\app\,\top\) equals
  \(\text{inv}\,(\beta.\hom.\app\,\top)\) under the inverse-of-iso
  lemma for scheme presheaf maps.  Substitute the explicit value
  \(\beta.\hom = \basicOpenToSpec\,\AA\,f\,f_{\deg}\,h_m\) via
  \(\Proj.\basicOpenIsoSpec\_\hom\).  Then evaluate
  \(\basicOpenToSpec.\app\,\top\) via
  \(\Proj.\basicOpenToSpec\_\app\_\top\), which gives the explicit
  factor chain
  \((\basicOpenIsoAway).\hom \cc (\Scheme.\GammaSpecIso\,\_).\hom
    \cc (\Proj.\basicOpen\,\AA\,f).\topIso.\inv\).
  Invert this composition (composition of isos reverses);
  the result is exactly the RHS of the lemma.
\end{proof}
```

Lean recipe (for the iter-197 prover):
- `Scheme.invApp` (Mathlib) — `f.invApp` for an iso `f`.
- `Proj.basicOpenIsoSpec_hom` (Mathlib `Proj.lean`) — identifies the
  forward map of `basicOpenIsoSpec` with `basicOpenToSpec`.
- `Proj.basicOpenToSpec_app_top` (Mathlib) — explicit value at `⊤`.
- The proof is mechanical (`~5–15 LOC`) once these three lemmas land
  in the local proof state.

This is the SINGLE most important must-fix. It is the missing
intermediate that the iter-196 prover's task report explicitly named.

### M-2. Update `lem:awayi_app_basicOpen` proof sketch Step 1

**Current state** (chapter L1364-1389): Step 1 references the
non-existent declaration `Proj.awayι_eq_isoSpec_ι_comp`. The
iter-196 prover landed `Proj.awayι_eq_specMap_fromSpec` as the
analogous primitive.

**Action**: Rewrite Step 1 to reference the landed declaration:

```
Step 1.  Apply \(\Proj.\awayι\_eq\_specMap\_fromSpec\) to rewrite
\(\Proj.\awayι\,\AA\,f\,f_{\deg}\,h_m\) on the LHS as
\(\Spec.\map\,(\basicOpenIsoAway\,\AA\,f\,f_{\deg}\,h_m).\inv
\cc (\text{isAffineOpen}\_\basicOpen\,\AA\,f\,f_{\deg}\,h_m).\fromSpec\).
Apply \(\Scheme.\Hom.\comp\_\app\) to split the section-level value
into the composition of the two scheme-map sections.
```

Then revise the rest of the proof sketch (Steps 2-4) to chain through
`fromSpec.app ⊤` (which evaluates explicitly via Mathlib's
`IsAffineOpen.fromSpec_app_self`) followed by
`Spec.map(basicOpenIsoAway.inv).app _` (evaluates via
`Spec.map_appTop` + the `basicOpenIsoAway.inv.hom` value). The
dependent-motive obstruction is **avoided** by this route — both sides
of the factorization keep the same `app`-codomain type.

### M-3. Expand the `lem:projectiveLineBar_geomIrred` proof sketch with explicit Helper A recipe

**Current state** (chapter L972-993): the proof sketch gives an
informal mathematical argument (Proj of base-changed graded ring,
integral domain, etc.) but does not name the load-bearing
isomorphism `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K`.

**Action**: Restructure the proof sketch into 5 named sub-helpers:

```latex
\begin{proof}
  \uses{def:genus0_base_objects, ...}
  Sub-helper A (load-bearing). Base-change of Proj. For
  \(\AA : \mathbb N \to R\) a graded ring and \(K\) an
  \(R\)-algebra, there is a natural iso of schemes over \(\Spec\,R\):
    \(\Proj\,(K \otimes_R \AA) \;\cong\; \Proj\,\AA \;\times_{\Spec\,R}\;\Spec\,K\).
  This is Stacks 0BLW (the base-change formula for relative Proj).
  Sub-helper B. Re-parameterise the chart-iso infrastructure
  (\(\text{homogeneousLocalizationAwayIso}\)) over an arbitrary field
  \(K\) extending \(\bar k\).
  Sub-helper C. The base-changed graded ring
  \(K \otimes_{\bar k} \bar k[X_0, X_1]\) is a (graded) integral
  domain, hence \(\Proj\,(K \otimes_{\bar k} \bar k[X_0, X_1])\)
  has an integral underlying scheme (sheaf of integral domains by
  pointwise check at generic points).
  Sub-helper D. The Proj of an integral graded domain over a field
  \(K\) is integral (Mathlib: \(\Proj.\instIsIntegral\) when the
  irrelevant ideal cofinality holds).
  Sub-helper E. Assemble via Helper A: for every field extension
  \(K / \bar k\), the base-changed
  \((\ProjectiveLineBar\,\bar k) \times_{\Spec\,\bar k} \Spec\,K\)
  is integral, hence irreducible. Combined with the alg-closure
  hypothesis on \(\bar k\), this yields
  \(\GeometricallyIrreducible\,(\ProjectiveLineBar\,\bar k).\hom\).
  Mathlib references:
  - Stacks 0BLW (base-change of Proj) — NOT in Mathlib `b80f227`;
    project-side substrate required (~100-200 LOC).
  - Mathlib has `Proj.instIsIntegral`, `Algebra.TensorProduct`
    machinery, but not the graded-tensor-product-of-polynomials
    integral-domain instance directly.
  Estimated total closure cost: 200-350 LOC across 5 helpers; Helper
  A (Stacks 0BLW) is the dominant cost. This sorry is acceptable as
  a Tier-3 named scaffold until the Proj base-change infrastructure
  lands.
\end{proof}
```

Pin each sub-helper with `\lean{...}` to future Lean targets:
- Sub-helper A: `\lean{AlgebraicGeometry.Proj.baseChangeIso}` (Mathlib
  upstreaming candidate or project supplement).
- Sub-helper B: `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso.baseChange}`.
- Sub-helper C, D, E: leave as un-pinned prose sub-claims for now (the
  iter-197+ prover will name them as it materialises them).

## Major (also fix this iter)

### J-1. Add `\lean{...}` blocks for iter-196 landed Proj supplements

Both `Proj.awayι_preimage_basicOpen_self` (Lean L190) and
`Proj.awayι_eq_specMap_fromSpec` (Lean L203) are axiom-clean
project supplements but have no blueprint pins. Add brief
`\begin{lemma}` + `\lean{...}` blocks for each in the appropriate
section. Keep them short (~5-10 LOC each, statement only, brief
proof note). These act as visible substrate documentation for
sync_leanok to track.

### J-2. Add `\lean{...}` block for `projectiveLineBar_isProper`

The properness instance at BareScheme.lean L106 has a non-trivial
40-line proof (bijectivity of algebraMap kbar ↥(𝒜 0) chain). Add a
brief `\begin{lemma}` block describing the instance with a short
proof sketch noting the `IsScalarTower` + `Algebra.FiniteType` chain
and the `Spec.map` iso composition. `\lean{}` pin to
`AlgebraicGeometry.projectiveLineBar_isProper`.

### J-3. Add `\lean{...}` block for `mvPolynomialFin_isStandardSmoothOfRelativeDimension`

This is the iter-196 5-declaration Mathlib supplement chain
(BareScheme.lean L165-211). Add a brief `\begin{lemma}` block under
`lem:projectiveLineBar_smoothOfRelDim` describing:

- Mathlib does not ship a direct
  `IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R)`
  instance at `b80f227`;
- the project builds it via the 5-declaration `Algebra.SubmersivePresentation`
  chain (`mvPolyGenerators → mvPolyPresentation → mvPolyPreSubmersivePresentation
  → mvPolySubmersivePresentation → mvPolynomialFin_isStandardSmoothOfRelativeDimension`);
- the chain terminates in
  `Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension`
  with dimension count `Nat.card (Fin n) - Nat.card PEmpty = n`.

`\lean{}` pin to
`AlgebraicGeometry.mvPolynomialFin_isStandardSmoothOfRelativeDimension`.

### J-4. Footnote on the `projectiveLineBar_smoothOfRelDim` per-chart gap

The Lean proof's per-chart auxiliary `projectiveLineBar_smooth_chart_aux`
(BareScheme.lean L316) is a private sorry pending the chart-ring iso
`homogeneousLocalizationAwayIso` (which lives in
`Genus0BaseObjects/ChartIso.lean` — downstream of BareScheme.lean,
hence the import barrier). The blueprint's proof sketch should add a
footnote / `% NOTE:` describing this dependency and naming the
recommended refactor: **relocate `projectiveLineBar_smoothOfRelDim`
to ChartIso.lean (or a new `Genus0BaseObjects/Smooth.lean`) where the
chart-ring iso is in scope, then close the per-chart gap via
`Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` (~10 LOC).**

This footnote is informational; the relocation refactor is being
dispatched separately to the refactor subagent this iter (slug
`barescheme-smoothness-relocation`).

### J-5. Correct the loose Lean API name in the smoothness sketch

Current sketch names `Smooth_iff_atOpens`; the actual Lean API the
prover used is `IsZariskiLocalAtSource.of_openCover` (and the
underlying chain through `HasRingHomProperty.iff_of_isAffine` +
`RingHom.locally_of`). Rewrite the sketch's API references to match.

## Required content shape

- Total chapter LOC growth: ≤ ~150 LOC.
- M-1 + M-2 are the load-bearing must-fixes; J-1 through J-5 are
  documentary/coverage edits.
- Do NOT add `\leanok` / `\mathlibok` markers anywhere — those are
  managed by `sync_leanok` / the review agent.
- Do NOT touch the existing `% archon:covers ...` declaration at the
  top of the chapter (line 4).
- Do NOT touch other chapters.

## References

- Lean files:
  - `AlgebraicJacobian/AbelianVarietyRigidity.lean`
  - `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`
- Reviewer reports:
  - `task_results/lean-vs-blueprint-checker-avr.md`
  - `task_results/lean-vs-blueprint-checker-barescheme.md`
- Iter-196 prover task results:
  - `task_results/AlgebraicJacobian/AbelianVarietyRigidity.md`
  - `task_results/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean.md`
- Strategic context: `STRATEGY.md`, Route C section.
- Analogist file: `analogies/lane-e-proj-appiso-pivot.md` (this is the
  validated recipe behind M-1 + M-2).

## Out of scope

- The geomIrred Helper A `Proj.baseChangeIso` Lean implementation —
  blueprint-side recipe only this iter; iter-197+ prover handles the
  Lean work.
- The relocation refactor of `projectiveLineBar_smoothOfRelDim` —
  separate refactor dispatch this iter.
- Anything in `RR.4` / `RationalCurveIso` blueprint — different
  chapter.
- Adding `\leanok` / `\mathlibok` markers anywhere.

## Verification (for you, the writer)

After your edits land:
- Confirm `\ref` / `\uses` resolve to existing labels.
- Confirm every `\lean{...}` you added or modified resolves to a Lean
  declaration that exists (J-1, J-2, J-3) OR is clearly marked as a
  future substrate target (M-1, M-3 sub-helpers).
- Confirm the new lemma block `lem:basicOpenIsoSpec_inv_app_top` is
  referenced from `lem:awayi_app_basicOpen`'s `\uses{...}`.

Report in `task_results/blueprint-writer-avr-barescheme-mustfix-iter197.md`:
- 1-paragraph summary of what changed
- List of must-fix + major items addressed (M-1, M-2, M-3; J-1
  through J-5)
- Any strategy-modifying findings (don't add them as edits; flag and
  return for the planner to handle)
