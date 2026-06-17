# Blueprint Review Report

## Slug
iter183

## Iteration
183

## Top-level summaries

### Lean difficulty quality

- `Picard_RelativeSpec.tex` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}`:
  the chapter prose pins a Yoneda-bijection statement
  $\Hom_X(T, \underline{\Spec}_X(\mathcal A)) \cong
  \Hom_{\mathcal O_X\text{-alg}}(\mathcal A, g_* \mathcal O_T)$, but the
  iter-173 file-skeleton landed it as the strictly weaker structural
  consequence `IsAffineHom (structureMorphism 𝒜)` (acknowledged in
  iter-173 review NOTE inside the chapter). This is a documented
  intentional encoding gap, not a fabrication — the prose is correct, but
  Lane D consumers cannot rely on the natural-bijection conclusion until
  the Lean type is upgraded to `Functor.RepresentableBy`. Treat as **soon**
  (Lane D is iter-183-active but downstream of A.1.a, so the consequence
  is downstream slowdown, not a wrong proof).
- `Picard_RelativeSpec.tex` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}`:
  the Lean name `affine_base_iff` is misleading — the encoded type is the
  weaker `IsAffine ((Spec R).RelativeSpec 𝒜)` (acknowledged in the iter-173
  review NOTE in the chapter). Plan agent should track for the iter-174+
  signature refinement.
- `Picard_RelativeSpec.tex` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}`:
  the Lean type is the weaker existential `∃ 𝒜', Nonempty (pullback ≅ T.RelativeSpec 𝒜')`
  rather than the canonical iso with a named pullback `g^* 𝒜`
  (acknowledged in the iter-173 NOTE). Same soon-severity status.

All three findings are noted INSIDE the chapter prose by `% NOTE (iter-173 review)`
blocks — they are documented signature-drift items, not blueprint
correctness errors.

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_IdentityComponent.tex`

**Covers**: `AlgebraicJacobian/Picard/IdentityComponent.lean` (skeleton owed per
`STRATEGY.md` L143)
**Strategy phase**: A.3 — `Pic⁰` identity + degree (status "chapter pending; substrate unowned"
per `STRATEGY.md` L40)
**Why now**: A.3 has zero blueprint coverage at iter-183, blocking the
A.2.c → A.3 → A.4.d pipeline. Every other Route-A row has a chapter; A.3 is
the single missing node. Writing the chapter now lets the substrate
construction of `GroupScheme.IdentityComponent` (declared "NEW PROJECT
MATERIAL" by STRATEGY) be reviewed before any prover wastes work, and
unblocks the AlbaneseUP wiring downstream.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:identity_component_group_scheme}` —
   The identity component (connected component of the identity section)
   of a group scheme $G$ over a base $S$, as an open and closed subgroup
   scheme. `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent}` [expected].
   Source: Stacks tag 0B7R / Milne *Abelian Varieties* §III.6 opening +
   SGA 3, Exposé VI_B §3.10. Probably needs `references/stacks-*.md` consult
   if Stacks coverage absent at pinned commit.
2. `\theorem` `\label{thm:identity_component_open_subgroup}` — For a group
   scheme $G$ locally of finite type over a field $k$, the identity
   component $G^0$ is an open subgroup scheme.
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme}` [expected].
   Source: Milne *Abelian Varieties* §III.6 (the standing decomposition);
   Stacks tag 0B7T (open and closed subgroup scheme construction).
3. `\definition` `\label{def:pic_zero_subscheme}` —
   $\Pic^0_{C/k} := (\Pic_{C/k})^0$, the identity component of the Picard
   scheme of `Picard_FGAPicRepresentability.tex`. `\lean{AlgebraicGeometry.Scheme.Pic0Scheme}` [expected].
   Source: Milne *Abelian Varieties* §III.6 Proposition 6.1 standing setup;
   Kleiman *Picard Scheme* §6.
4. `\definition` `\label{def:divisor_degree_pic}` — The degree map
   $\deg \colon \Pic_{C/k}(k) \to \mathbb Z$ extracted from
   $\Pic_{C/k}$ via the Hilbert-polynomial stratification of the FGA proof.
   `\lean{AlgebraicGeometry.Scheme.PicScheme.degree}` [expected].
   Source: Kleiman *Picard Scheme* §5 (Hilbert-polynomial decomposition of
   $\Pic_{X/S}$).
5. `\theorem` `\label{thm:pic_zero_is_abelian_variety}` — $\Pic^0_{C/k}$ is a
   smooth proper geometrically irreducible group scheme of dimension $g(C)$ —
   i.e.\ an abelian variety of dimension $g$.
   `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}` [expected].
   Source: Milne *Abelian Varieties* §III.6 Theorem 6.4 (cf.\ Hartshorne IV.4).

**`\uses` skeleton**:
- `thm:identity_component_open_subgroup` uses `def:identity_component_group_scheme`
- `def:pic_zero_subscheme` uses `def:identity_component_group_scheme`,
  `def:pic_scheme` (from `Picard_FGAPicRepresentability.tex`)
- `def:divisor_degree_pic` uses `def:pic_scheme`, `def:hilbert_polynomial`
  (from `Picard_QuotScheme.tex`)
- `thm:pic_zero_is_abelian_variety` uses `def:pic_zero_subscheme`,
  `thm:identity_component_open_subgroup`, `def:divisor_degree_pic`,
  `def:genus` (from `Genus.tex`), `thm:fga_pic_representability`

**Main theorem proof strategy**: The identity-component construction
extracts the open-and-closed subscheme containing $\eta_J$ from
representability of $\Pic_{C/k}$ as a disjoint union of quasi-projectives
(Theorem 4.1 of `Picard_FGAPicRepresentability.tex` already pins this
disjoint-union structure). Dimension is $g$ by Riemann–Roch / Serre duality
on $\Pic^0$ (Milne III.6); smoothness in characteristic $p$ requires
care (Milne IV §13–14) but in char $0$ is automatic. Geometric irreducibility
follows because $\Pic^0_{C/k}$ is the connected component of the identity by
construction. The degree map is the index of the Hilbert-polynomial
component containing a given class (Kleiman §5).

**References for writer**:
- `references/abelian-varieties.md` → `mumford-abelian-varieties.pdf`, §III.6
  + §III.13 — the standing decomposition of $\Pic_{C/k}$ into $\Pic^0$ and
  the degree map; smoothness in char-$p$ case.
- `references/kleiman-picard.md` → `kleiman-picard.pdf`, §5 (Hilbert-polynomial
  decomposition) and §6 (the identity component).
- `references/stacks-*.md` consult: Stacks tag 0B7R / 0B7T for the abstract
  group-scheme identity-component construction; the writer should retrieve
  these if not already in the local `stacks-*.md` cache.
- Optional: `references/hartshorne-algebraic-geometry.md` → IV.4 (the
  Jacobian of a curve as an abelian variety, char-0 case).

**Subphase choices exposed**:
- **Choice A vs Choice B**: build $\Pic^0$ as the open and closed identity-component
  subgroup scheme of the abstract group scheme (clean, uses Stacks-tag
  abstract API), vs build $\Pic^0$ directly as the moduli functor of
  degree-zero line bundles modulo pullback (concrete, matches Milne's
  exposition). Trade-off: Choice A inherits an abstract substrate gap
  (`GroupScheme.IdentityComponent` is "NEW PROJECT MATERIAL" per STRATEGY,
  so needs its own ~100 LOC build); Choice B avoids that gap but couples
  $\Pic^0$ definition to the degree map, requiring degree to be set up
  before $\Pic^0$ even exists. **Recommendation**: Choice A — Stacks tag
  0B7R/0B7T is a self-contained standalone build, and the abstract
  identity-component API will be reusable for the future addition of
  $\Pic^0$'s dual $J^\vee$ (if ever needed for Albanese-UP variants).
- **Substrate split**: the underlying `GroupScheme.IdentityComponent`
  construction can be either part of this chapter or split off into a
  sibling `AlgebraicJacobian/GroupScheme/IdentityComponent.lean` (and a
  matching blueprint chapter). **Recommendation**: keep substrate in this
  chapter for iter-183 horizon, with a `% NOTE: future split candidate`
  marker — the substrate is small (~200–300 LOC per STRATEGY), and a
  separate chapter is premature until a second consumer materialises.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Consolidated chapter covering 7 files via `% archon:covers` (Lanes B + E).
    All seven `.lean` files have `\lean{...}` pin coverage somewhere in
    the chapter. Verified declarations matching iter-183 Lane B / Lane E
    needs: `gmScalingP1_chart`, `gmScalingP1_chart_agreement`,
    `gmScalingP1_chart_PLB_eq`, `gmScalingP1_over_coherence`,
    `gmScalingP1_collapse_at_zero` all pinned. Citation discipline excellent:
    Milne / Mumford verbatim quotes with `\textit{Source: ...}` lines and
    `% SOURCE QUOTE:` comments; the `% SOURCE: ... (read from references/...pdf...)`
    parentheticals match `references/abelian-varieties.pdf` and
    `references/mumford-abelian-varieties.pdf` (both exist on disk).
  - Iter-171 chart-glue scaffold pin coverage is dense and the iter-180 Lane
    A recipe (`respectTransparency`) is recorded in the chapter as a
    completed status of `gmScalingP1_chart_PLB_eq`. iter-182 Pin 2/3 edits
    do not touch this chapter — it is unchanged since iter-181 close,
    when it cleared `complete: true / correct: true`.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Per iter-183 directive, this chapter is iter-200+ work (standing-deferral).
    The 7 pinned typed sorries are intentional; chapter prose is well ahead of
    code. The iter-174 Route C decision (symmetric-power route, theorem-of-the-cube
    EXCISED) is recorded clearly. NOT in iter-183 prover lanes — no HARD GATE
    gating from this. Verdict `complete: partial / correct: true` reflects the
    Albanese-UP body being a multi-iter sub-build, not a fabrication.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **NEW chapter landed this iter (writer slug `coheightbridge-skeleton`)**.
    Audit per iter-183 directive item (2): 4 declarations pinned with
    `\lean{...}` blocks (`Order.coheight_eq_of_isOpenEmbedding`,
    `Order.coheight_spec_eq_height_primeSpectrum`,
    `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight`,
    `AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one`). Citation
    pattern uses Mathlib API pointers in lieu of `% SOURCE QUOTE:` blocks; this
    is documented explicitly in the chapter's prose ("blocks are packaged as
    Archon-original assembly lemmas with explicit Mathlib API pointers in lieu
    of `% SOURCE QUOTE:` blocks") and is acceptable for project-side assembly
    chapters. Proof sketches are clear, 5-step assembly recipe rationale named.
    Lean encoding section is explicit: target file
    `AlgebraicJacobian/Albanese/CoheightBridge.lean` does not yet exist;
    iter-183 Lane M creates it. Out-of-scope section properly carves out
    the Stacks 00TT smooth-to-regular sub-project.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane F (iter-183 PIVOT). Comprehensive: 7 declarations pinned with
    `\lean{...}`; Nitsure citations with line ranges into
    `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (file
    exists on disk, verified). The reduction chain (boundedness →
    Grassmannian embedding → flattening stratum → valuative criterion) is
    cleanly decomposed into sub-lemmas. The `thm:flat_base_change_cohomology`
    is honestly recorded as a `Mathlib-gap-or-project-bridge` candidate.
    `def:grassmannian_scheme` and `thm:grassmannian_representable` are
    flagged as candidate for promotion to a separate
    `Picard_GrassmannianScheme.tex` chapter — informational note, not a
    must-fix.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane D (iter-183). Chapter prose and source-quote discipline are sound.
    See **Lean difficulty quality** above for three documented
    Lean-target-vs-prose signature drift items (`UniversalProperty`,
    `affine_base_iff`, `base_change`). All three are flagged
    by `% NOTE (iter-173 review)` blocks INSIDE the chapter and acknowledged
    as iter-174+ upgrades; they do NOT make the blueprint statements wrong.
    HARD GATE passes — Lane D may fire.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane A (iter-183). iter-182 writer added `def:lineBundleAtClosedPoint_toFunctionField`
    block (`\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField}`)
    consumed by Pin 2 of the RR.4 sibling per the iter-182 plan-phase
    refactor — verified present at L185–L236. The body of the new def
    is gated on `def:lineBundleAtClosedPoint` body per the prose. Citation
    discipline excellent (Hartshorne verbatim quotes, all `% SOURCE: ... (read from references/hartshorne-algebraic-geometry.pdf...)`
    parentheticals correct). HARD GATE passes — Lane A may fire.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **NEW chapter landed iter-182 plan-phase** (Lane K seed). Audit per
    iter-183 directive item (1): 4 declarations pinned with `\lean{...}`
    blocks (`sheafOf`, `sheafOf_zero`, `sheafOf_singlePoint`,
    `sheafOf_ses_single_add`) targeting
    `AlgebraicGeometry.Scheme.WeilDivisor.*`. Citation discipline excellent:
    Hartshorne II.6 + IV.1.3 verbatim quotes with character-by-character
    transcription note ("the PDF has no text layer"), Cartier/Weil-divisor
    correspondence rationale stated, equivalence-with-Cartier-description
    sub-section spells out the project's $\mathcal O_C(D)$ recipe. SES proof
    follows Hartshorne IV.1.3 inductive step verbatim. Out-of-scope section
    properly carves out linear-equivalence iso, tensor multiplicativity,
    pullback, Serre duality. Per iter-183 directive's blueprint-doctor
    carve-out: `OcOfD.lean` does not yet exist — Lane K creates it this iter.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane H (iter-183). All 4 declarations pinned with `\lean{...}` blocks;
    Hartshorne IV.1 verbatim quotes with `(read from references/hartshorne-algebraic-geometry.pdf, PDF page 312/313)`
    parentheticals correct. The genus-0 / general-g carve-out and
    chi-additivity gap (project-side Lemma or candidate Mathlib upstream
    PR) are both documented honestly. HARD GATE passes — Lane H may fire.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane I (iter-183). Per iter-183 directive item (3) and prose audit:
    iter-182 Pin 2 sig-strengthen verified — `lem:degree_via_pole_divisor`
    now binds `D = φ^*[∞]` and `deg(D) = [K(C):k̄(ℙ¹)]` (i.e.\
    `Module.finrank K(ℙ¹) K(C)`) per the iter-182 refactor
    `pin2-sig-strengthen`. The new typed-sorry def
    `AlgebraicGeometry.Scheme.Hom.poleDivisor` is properly introduced via
    a prose `% NOTE` (L165–L178) following the same pattern as the iter-181
    `toFunctionField` typed-sorry def. iter-181 Pin 3 refinement to
    `Module.finrank C'.functionField C.functionField = 1` also verified.
    Citation discipline excellent: Hartshorne I.6.12 + IV.2 verbatim quotes
    with correct local-file parentheticals. HARD GATE passes — Lane I may fire.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Per project history, this chapter is the retained fallback-(a) artifact
    that still carries `[CharZero]`; iter-178 standing-deferral per memory
    [[kdm-lemma-false-as-stated]]. NOT consumed by iter-183 prover lanes
    (the genus-0 path now uses `AbelianVarietyRigidity.tex`'s char-free
    `thm:rigidity_genus0_curve_to_AV`). Verdict `partial / correct` reflects
    the partial body coverage in the fallback chapter (some pins still open);
    the chapter is intentionally not actively progressed.

## Cross-chapter notes

- The `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` alias reserved in
  `AbelianVarietyRigidity.tex` (Route-A-only block
  `lem:rational_map_to_av_extends`) and the canonical home
  `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` of
  `Albanese_Thm32RationalMapExtension.tex`'s `thm:rational_map_to_av_extends`
  refer to the SAME mathematical statement under different Lean names. The
  `AbelianVarietyRigidity.tex` chapter's `% STRATEGY NOTE` flags this as a
  Plan-Agent reconciliation pass; informational only — the alias was
  preserved as a Route-A input pointer. Plan agent may retarget at a future
  iter without urgency.
- The label `thm:quot_representable` (a `\uses{}` target inside
  `Picard_FGAPicRepresentability.tex`) is the canonical label inside
  `Picard_QuotScheme.tex` — verified present and consistent. No broken
  cross-reference.
- Similarly, `def:rel_pic_etale_sheafification` is the forward-reference
  target inside `Picard_RelPicFunctor.tex`. Verified.

## Severity summary

- **must-fix-this-iter** (1 item):
  - `unstarted-phase proposal: A.3 Pic⁰ identity + degree — dispatch blueprint-writer for blueprint/src/chapters/Picard_IdentityComponent.tex or record deferral`.
    See proposal block above.
- **soon** (3 items):
  - `Picard_RelativeSpec.tex` Lean-target-vs-prose signature drift on three
    declarations (`UniversalProperty`, `affine_base_iff`, `base_change`) —
    documented in chapter, but tracker hygiene wants iter-184+ upgrade or
    explicit drop of the prose pin in favour of the weaker structural
    Lean signature.
- **informational** (1 item):
  - `Picard_QuotScheme.tex` Grassmannian sub-chapter promotion candidate
    (`def:grassmannian_scheme` + `thm:grassmannian_representable` are
    blueprint-level substantial; promoting to a separate
    `Picard_GrassmannianScheme.tex` chapter would reduce QuotScheme load,
    but is not gating).

Overall verdict: HARD GATE clears for all 10 iter-183 prover lanes (Lanes
A, B, D, E, F, G, H, I, K, M); 1 unstarted-phase proposal (A.3) requires
blueprint-writer dispatch this iter to avoid further deferred-parallelism
cost.
