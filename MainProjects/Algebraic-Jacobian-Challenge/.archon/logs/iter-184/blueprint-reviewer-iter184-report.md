# Blueprint Review Report

## Slug
iter184

## Iteration
184

## Top-level summaries

### Lean difficulty quality

- `Picard_RelativeSpec.tex` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}`:
  chapter prose pins a Yoneda-bijection
  $\Hom_X(T, \underline{\Spec}_X(\mathcal A)) \cong \Hom_{\mathcal O_X\text{-alg}}(\mathcal A, g_* \mathcal O_T)$,
  but the Lean target encodes the strictly weaker structural consequence
  `IsAffineHom (RelativeSpec.structureMorphism 𝒜)` (verified at
  `AlgebraicJacobian/Picard/RelativeSpec.lean:264`). Documented intentionally
  by an in-chapter `% NOTE (iter-173 review)` block at L162 + an
  iter-179 supersede note at L220. Treat as **soon** — Lane D (iter-184)
  is closing `pullback_iso_construction` body, NOT the drift signatures.
  Carried over verbatim from iter-183 review (re-verified).

- `Picard_RelativeSpec.tex` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}`:
  Lean name `affine_base_iff` is misleading — the encoded type is the
  weaker `IsAffine ((Spec R).RelativeSpec 𝒜)` (verified at L311 of
  `RelativeSpec.lean`), NOT an iff. Documented in-chapter at L253.
  **Soon**; carry over from iter-183.

- `Picard_RelativeSpec.tex` / `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}`:
  Lean type is the weaker existential
  `∃ 𝒜', Nonempty (pullback ≅ T.RelativeSpec 𝒜')` (verified at L639
  of `RelativeSpec.lean`) rather than the canonical iso with a named
  pullback `g^* 𝒜`. Documented in-chapter at L338. **Soon**; carry over
  from iter-183.

All three findings remain `% NOTE (iter-173 review)`-flagged inside the
chapter; they are documented signature-drift items, NOT blueprint
correctness errors. Iter-184 Lane D is intentionally NOT touching them.

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_IdentityComponent.tex`

**Covers**: `AlgebraicJacobian/Picard/IdentityComponent.lean` (file does not
yet exist; per `STRATEGY.md` L143 the skeleton is owed iter-185+; this chapter
is the authoritative spec).
**Strategy phase**: A.3 — `Pic⁰` identity + degree (status "chapter pending;
substrate unowned" per `STRATEGY.md` L40; ~16–28 iters remaining)
**Why now**: Plan-phase status — a blueprint-writer dispatch
`pic0-identity-component-chapter` is fired in parallel with this audit
(directive at `.archon/logs/iter-184/blueprint-writer-pic0-identity-component-directive.md`),
but the chapter file has NOT landed by the time of this audit
(`blueprint/src/chapters/Picard_IdentityComponent.tex` absent; writer
report `task_results/blueprint-writer-pic0-identity-component.md`
absent). Per directive item (4), the gate response is **deferred —
dispatched but not landed in time for this audit**. This is NOT a new
must-fix-this-iter; the iter-183 unstarted-phase proposal is being
addressed this plan-phase via the parallel writer dispatch. If the
writer lands the chapter during this iter's plan-phase before prover
objectives are written, the plan agent should re-dispatch
blueprint-reviewer scoped to `Picard_IdentityComponent.tex` only (the
same-iter fast path) before sending any A.3 prover. Otherwise the
chapter will be audited in iter-185's mandatory dispatch.

**Key declarations** (recap, in dependency order, from iter-183 proposal):
1. `\definition` `\label{def:identity_component_group_scheme}` —
   identity component of a group scheme `G/S` as open-and-closed subgroup
   scheme. `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent}`
   [expected]. Source: Stacks tag 0B7R / Milne III.6.
2. `\theorem` `\label{thm:identity_component_open_subgroup}` — for `G`
   locally of finite type over a field, `G⁰` is an open subgroup
   scheme. `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme}` [expected].
   Source: Milne III.6 / Stacks 0B7T.
3. `\definition` `\label{def:pic_zero_subscheme}` —
   `Pic⁰_{C/k} := (Pic_{C/k})⁰`. `\lean{AlgebraicGeometry.Scheme.Pic0Scheme}` [expected].
   Source: Milne III.6 Prop 6.1 / Kleiman §6.
4. `\definition` `\label{def:divisor_degree_pic}` — degree map
   `Pic_{C/k}(k) → ℤ` via Hilbert-polynomial stratification.
   `\lean{AlgebraicGeometry.Scheme.PicScheme.degree}` [expected].
   Source: Kleiman §5.
5. `\theorem` `\label{thm:pic_zero_is_abelian_variety}` — `Pic⁰_{C/k}`
   is a smooth proper geometrically irreducible group scheme of
   dimension `g(C)`. `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}` [expected].
   Source: Milne III.6 Thm 6.4 / Hartshorne IV.4.

**`\uses` skeleton**:
- `thm:identity_component_open_subgroup` uses `def:identity_component_group_scheme`
- `def:pic_zero_subscheme` uses `def:identity_component_group_scheme`, `def:pic_scheme`
- `def:divisor_degree_pic` uses `def:pic_scheme`, `def:hilbert_polynomial`
- `thm:pic_zero_is_abelian_variety` uses `def:pic_zero_subscheme`,
  `thm:identity_component_open_subgroup`, `def:divisor_degree_pic`,
  `def:genus`, `thm:fga_pic_representability`

**Main theorem proof strategy**: identity-component extracts the
open-and-closed subscheme containing `η_J` from the disjoint-union
representability of `Pic_{C/k}` (Theorem 4.1 of
`Picard_FGAPicRepresentability.tex`). Dimension `g` by Riemann–Roch /
Serre duality on `Pic⁰` (Milne III.6); smoothness in char $p$ requires
care (Milne IV §13–14), in char 0 automatic. Geometric irreducibility
by definition. Degree map is the index of the Hilbert-polynomial
component (Kleiman §5).

**References for writer**:
- `references/abelian-varieties.pdf` (Milne *Abelian Varieties* 2008), §III.6,
  Prop 6.1 + Thm 6.4 — primary source for items 3 and 5.
- `references/kleiman-picard.pdf` (Kleiman *The Picard scheme*, FGA Explained
  arXiv:math/0504020), §5–§6 — primary source for items 1 and 4.
- `references/mumford-abelian-varieties.pdf` (Mumford *Abelian Varieties*),
  §III.6 + §III.13 — smoothness in char-$p$.
- Stacks tags 0B7R / 0B7T for the abstract identity-component
  construction — retrieval needed if `references/stacks-*.md` cache does
  not yet cover them; writer's `--write-domain` allows the
  reference-retriever dispatch.
- Optional: `references/hartshorne-algebraic-geometry.pdf`, IV.4 (char-0
  Jacobian).

**Subphase choices exposed**:
- **Choice A vs Choice B**: Choice A (already committed in writer
  directive) builds `Pic⁰` as the abstract identity-component subgroup
  scheme via Stacks 0B7R/0B7T; Choice B would build it directly as a
  moduli functor of degree-zero line bundles. Trade-off: A inherits
  a substrate gap (`GroupScheme.IdentityComponent` ~200–300 LOC, NEW
  PROJECT MATERIAL); B couples `Pic⁰`-definition to the degree map.
  **Already decided in directive: Choice A.**
- **Substrate split**: substrate stays in this chapter (with
  `% NOTE: future split candidate` marker), not split off into a
  separate `GroupScheme_IdentityComponent.tex` sibling.
  **Already decided in directive: keep substrate in chapter.**

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Consolidated chapter covering 7 files via `% archon:covers` at L3
    (`AlgebraicJacobian.lean`, `Genus0BaseObjects.lean`,
    `Genus0BaseObjects/BareScheme.lean`, `Genus0BaseObjects/ChartIso.lean`,
    `Genus0BaseObjects/Points.lean`, `Genus0BaseObjects/GmScaling.lean`,
    `RigidityLemma.lean`). Iter-184 Lanes B (AVR) and the active
    `GmScaling` lane are both within this consolidated chapter — its
    single verdict gates BOTH iter-184 lane files. 39 `\lean{...}` pin
    occurrences across 42 declaration/section blocks (~98% pinning
    density). Citation discipline excellent (Milne + Mumford verbatim
    quotes, `% SOURCE: ... (read from references/...)` parentheticals
    correct against `references/abelian-varieties.pdf` and
    `references/mumford-abelian-varieties.pdf`). The iter-180 Lane A
    `respectTransparency` recipe is recorded in-chapter as the
    completed-status pin for `gmScalingP1_chart_PLB_eq`. No edits to
    this chapter since iter-181 close, when it cleared HARD GATE.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Standing-deferral chapter; not in iter-184 prover lanes. 7 pinned
    typed sorries; chapter prose well ahead of code. iter-174 Route C
    symmetric-power decision (theorem-of-cube EXCISED) recorded. Verdict
    unchanged from iter-183.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Landed iter-183 plan-phase (writer slug `coheightbridge-skeleton`);
    re-audited per iter-184 directive item (2) since iter-184 Lane M
    (`Albanese/CodimOneExtension.lean`) is downstream of this chapter.
    4 declarations pinned with `\lean{...}` blocks
    (`Order.coheight_eq_of_isOpenEmbedding` L104;
    `Order.coheight_spec_eq_height_primeSpectrum` L166;
    `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight` L227;
    `AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one` L307).
    Citation pattern uses Mathlib API pointers in lieu of
    `% SOURCE QUOTE:` blocks; this is explicitly documented in the
    chapter's prose at L29–30 ("blocks are packaged as Archon-original
    assembly lemmas with explicit Mathlib API pointers") and is
    acceptable for project-side assembly chapters. 5-step proof recipe
    for the headline `thm:ringKrullDim_stalk_eq_coheight` is clear and
    actionable. Out-of-scope section (Stacks 00TT, `RationalMap.order`
    refactor, general codim-$n$) properly carves out the work.
    HARD GATE clears for the Lane M prerequisite.

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
  - Lane F (iter-184). Comprehensive: 7+ declarations pinned with
    `\lean{...}`; Nitsure verbatim quotes with line ranges into
    `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`
    (file exists on disk). Reduction chain (boundedness → Grassmannian
    embedding → flattening stratum → valuative criterion) cleanly
    decomposed. `thm:flat_base_change_cohomology` honestly recorded as
    a `Mathlib-gap-or-project-bridge` candidate.
    `def:grassmannian_scheme` + `thm:grassmannian_representable` are
    blueprint-level substantial; still informational-only candidate for
    promotion to a separate `Picard_GrassmannianScheme.tex` chapter.
    HARD GATE passes — Lane F may fire.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane D (iter-184). Chapter prose and source-quote discipline are
    sound. See **Lean difficulty quality** above for the three
    documented Lean-target-vs-prose signature drift items
    (`UniversalProperty`, `affine_base_iff`, `base_change`), all
    `% NOTE (iter-173 review)`-flagged inside the chapter and verified
    against current Lean signatures at
    `AlgebraicJacobian/Picard/RelativeSpec.lean` (L264, L311, L639).
    These do NOT make the blueprint statements wrong. Iter-184 Lane D
    is closing `pullback_iso_construction` body, NOT touching the
    drift sigs. HARD GATE passes — Lane D may fire.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane A (iter-184). iter-182 added
    `def:lineBundleAtClosedPoint_toFunctionField` block consumed by
    Pin 2 of RR.4. Body gated on `def:lineBundleAtClosedPoint` body
    per prose. Citation discipline excellent (Hartshorne verbatim
    quotes, `% SOURCE: ... (read from references/hartshorne-algebraic-geometry.pdf, PDF page ...)`
    parentheticals correct). HARD GATE passes — Lane A may fire.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane K (iter-184). NEW chapter landed iter-182 plan-phase;
    re-audited per iter-184 directive item (2) since iter-184 Lane K
    plans to attempt body work. 4 declarations pinned with `\lean{...}`
    blocks (`sheafOf` L141, `sheafOf_zero` L257,
    `sheafOf_singlePoint` L294, `sheafOf_ses_single_add` L344).
    Citation discipline excellent: Hartshorne II.6 + IV.1.3 verbatim
    quotes with character-by-character transcription note ("the PDF
    has no text layer"), Cartier/Weil-divisor correspondence rationale
    stated, equivalence-with-Cartier-description sub-section spells out
    the project's $\mathcal O_C(D)$ recipe. SES proof follows
    Hartshorne IV.1.3 inductive step verbatim. Out-of-scope section
    properly carves out linear-equivalence iso, tensor
    multiplicativity, pullback, Serre duality. HARD GATE passes — Lane
    K may fire.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lane H (iter-184). Re-audited per iter-184 directive item (5):
    the iter-183 blueprint-doctor `\uses{\leanok thm:divisor_degree_hom}` /
    `\uses{\leanok thm:euler_char_eq_deg_plus_one_minus_genus}` issues
    are **FIXED** this plan-phase via the `rrformula-uses-fix` writer
    dispatch. Verified by direct inspection: no `\leanok` tokens
    appear inside any `\uses{...}` argument in the chapter (L192–193,
    L240–241, L347–349, L376–378 all clean). All 4 declarations pinned
    with `\lean{...}` (L93, L146, L191, L346). Hartshorne IV.1 verbatim
    quotes with correct `(read from references/hartshorne-algebraic-geometry.pdf, PDF page 312/313)`
    parentheticals. Genus-0 / general-g carve-out (L52–67) and
    chi-additivity gap (L321–335) documented honestly. HARD GATE
    passes — Lane H may fire.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Retained fallback-(a) artifact; carries `[CharZero]`; not consumed
    by iter-184 prover lanes (the genus-0 path uses
    `AbelianVarietyRigidity.tex`'s char-free
    `thm:rigidity_genus0_curve_to_AV`). Verdict unchanged from iter-183.

## Cross-chapter notes

- The `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` alias reserved
  in `AbelianVarietyRigidity.tex` (Route-A-only block
  `lem:rational_map_to_av_extends`) and the canonical home
  `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` of
  `Albanese_Thm32RationalMapExtension.tex`'s
  `thm:rational_map_to_av_extends` refer to the SAME mathematical
  statement under different Lean names. Informational only — the alias
  is preserved as a Route-A input pointer; plan agent may retarget at
  a future iter without urgency.

## Severity summary

- **must-fix-this-iter** (0 items):
  - The iter-183 unstarted-phase proposal for A.3
    (`Picard_IdentityComponent.tex`) is **NOT re-classified as a NEW
    must-fix this iter** — per directive item (4), the
    `blueprint-writer pic0-identity-component-chapter` is being
    dispatched in parallel this plan-phase. If the chapter does not
    land before prover dispatch, the iter-185 mandatory dispatch of
    blueprint-reviewer will re-audit. The unstarted-phase proposal
    block above is provided for continuity only; the planner has
    already discharged the action via the parallel writer dispatch.
- **soon** (3 items):
  - `Picard_RelativeSpec.tex` Lean-target-vs-prose signature drift on
    three declarations (`UniversalProperty`, `affine_base_iff`,
    `base_change`). All in-chapter NOTE-flagged; iter-184 Lane D is
    NOT touching them (iter-185+ work).
- **informational** (1 item):
  - `Picard_QuotScheme.tex` Grassmannian sub-chapter promotion
    candidate (carry-over from iter-183; non-gating).

Overall verdict: HARD GATE clears for all 10 iter-184 prover lanes
(Lanes A, B/E consolidated via AbelianVarietyRigidity.tex, Lanes
covering AuslanderBuchsbaum / CodimOneExtension / RelativeSpec /
QuotScheme / OCofP / OcOfD / RRFormula / RationalCurveIso); the
iter-183 A.3 unstarted-phase proposal is being addressed via a
parallel plan-phase writer dispatch (deferred to iter-185 mandatory
audit if not landed in time); the iter-183 RRFormula `\uses{\leanok}`
broken-cross-ref issue is FIXED this plan-phase and verified clean.
