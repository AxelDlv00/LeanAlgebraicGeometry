# Lean Audit Report

## Slug
review121

## Iteration
121

## Scope
- files audited: 12
- files skipped (per directive): 0

Audit covered every `.lean` file under the project (excluding `.lake/` and
`.archon/` snapshot dirs). Per directive, the iter-121 focus areas
(`Differentials.lean`, `Jacobian.lean`, `Rigidity.lean`) were read with
extra care; the rest of the project was audited at full depth.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure top-level import file (10 imports). All match the existing
    file layout. No issues.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: 0
- **notes**:
  - L22, L59: lines >100 chars in module/decl docstrings (111 + 101).
    Minor cosmetic, doc text only.
  - L51–56, L62–68, L82–90: the four `letI := (jacobianWitness C).{grpObj,
    proper, smooth, geomIrred}` instance scaffolds are duplicated verbatim
    across `ofCurve`, `comp_ofCurve`, and `exists_unique_ofCurve_comp`.
    Could be extracted into a `section` `letI` block or helper; current
    triple-replication is mildly DRY-violating but not incorrect. Minor.
  - The three protected declarations all project trivially from
    `(jacobianWitness C).isAlbaneseFor P` (matches the file's status
    block). Bodies are honest, no shortcuts.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 2 flagged (minor)
- **excuse-comments**: 0
- **notes**:
  - L438: line at 117 chars (inside `HModule'_δ` connecting-hom decl).
    Minor cosmetic.
  - L354, L523, L539, L565: four occurrences of
    `set_option backward.isDefEq.respectTransparency false in`. Each
    documents in the surrounding comment that it transfers verbatim from
    Mathlib (`MayerVietorisSquare.lean` L85, etc.). Mathlib idiom rather
    than a project anti-pattern; acceptable.
  - `Abelian.Ext.chgUniv_add`, `chgUniv_smul`, `chgUnivLinearEquiv`
    (L60–110): Mathlib gap-fill declarations placed in the
    `Abelian.Ext` namespace via qualified-name pattern (intentional;
    comment L51 explains). Two `private`-qualified helpers, one public
    `noncomputable def`. Bodies are honest, proofs go through additive +
    smul preservation as documented.
  - Long file (627 LOC) but structurally coherent: every declaration is
    used downstream (verified by the cohort-1 → cohort-2 split design).

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 2 flagged (re-confirm of known finding)
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0
- **notes**:
  - L490–498 (`HasCechToHModuleIso`) and L675–682
    (`HasAffineCechAcyclicCover`): both classes have only **consumer**
    instances/theorems in-project (e.g. L699
    `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` consumes
    `HasAffineCechAcyclicCover`); no producer instance is provided
    anywhere in the project. Already documented as review118 major #1.
    Severity unchanged at iter-121 (cohomology scaffolding is not the
    iter-121 prover focus — see § "Known findings — re-confirmed").

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - One honest 5-line instance (`instHasSheafCompose_forget_CommRing_AddCommGrp`).
    Clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Three honest declarations (`instHasSheafify`, `instHasExt`,
    `Scheme.toAbSheaf`). Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 4 flagged (re-confirm of known finding)
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0
- **notes**:
  - L458–466 (`IsAffineHModuleHomFinite`): the class itself is
    self-acknowledged dead in the docstring of its **successor**
    `IsHModuleHomFinite` at L530–538 (text: *"The iter-041 class
    therefore admits no producer instance on a non-trivial proper curve
    — dead scaffolding."*). Consumers `module_finite_HModule'_zero_of_isAffineHModuleHomFinite`
    (L476), `module_finite_HModule'_of_affine` (L497), and
    `module_finite_HModule'_of_affine_curve` (L512) all take
    `[IsAffineHModuleHomFinite ..]` as an instance argument and therefore
    cannot fire without the dead class. Already documented as review118
    must-fix #1. Severity unchanged; see § "Known findings — re-confirmed".
  - All other declarations (helpers (1)–(8), `HModule`, `HModule'`,
    `module_finite_globalSections_of_isProper`, the iter-046 producer
    `instIsHModuleHomFinite_toModuleKSheaf`, etc.) are real definitions
    with honest bodies.
  - L504: comment mentioning `Classical.choice` as a "kernel-only axiom"
    is accurate; matches Mathlib's standard axiom set.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Two declarations: `relativeDifferentialsPresheaf` (L49–52) and
    `smooth_locally_free_omega` (L91–109). Both have honest bodies; no
    `sorry`.
  - Docstring of `smooth_locally_free_omega` (L73–90) honestly discloses
    (a) the bridge from algebra-Kähler to presheaf form is an unimplemented
    Mathlib gap declared out-of-scope, and (b) the reverse direction
    (`Module.Free Ω + rank n ⇒ Smooth`) is **mathematically false**
    without `H1Cotangent` vanishing input, with explicit counterexample
    cited. This is *not* an excuse-comment — the file states only the
    forward direction, which it then proves, and the disclosure is a
    mathematical scope statement.
  - Re iter-120 known-finding about line-length on L101+L106: under
    `awk 'length>100'` no line in this file exceeds 100 chars at
    iter-121. The finding either reflected a different tooling threshold
    (Mathlib linter default may flag at 100 chars including trailing
    newline) or has been silently resolved. Not re-flagged.
  - Proof of `smooth_locally_free_omega` uses `<;>` to dispatch both the
    `Free` and the `rank = n` goals with the same `algebraize / haveI /
    haveI / first | … | …` block. The `first` discriminates which
    `Algebra.IsStandardSmooth.*` lemma closes each goal. Reasonable.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L39–61: a 23-line commented-out block titled `Sketch of the route
    once Phase A is available:` outlining `OXAsAddCommGrpSheaf` and
    `H1OC` with an internal `sorry`. The block is dead code: the actual
    `genus` def at L65–68 takes the `HModule k (toModuleKSheaf C) 1`
    route via the iter-006/iter-009 infrastructure, not via the sketched
    `AddCommGrpCat` route. The sketch is labelled as historical context
    rather than active work, but it is now obsolete and adds reading
    noise. Minor — recommend deletion in a future tidy-up.
  - The actual `genus` definition is one honest line:
    `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
    Mathematically correct: `dim_k H¹(C, O_C)` matches the standard
    definition of arithmetic genus for proper geom-irred curves.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 1 flagged (the documented load-bearing
  `sorry`; see notes)
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: 0
- **notes**:
  - L176–179 (`nonempty_jacobianWitness`): a single `sorry` carrying
    Phase-C Albanese existence. The docstring (L162–175) and the
    file-header status block (L15–39) honestly document this as the
    intentional single deferred existence claim absorbing five protected
    instances + genus-0 rigidity. This is **not** an excuse-comment in
    the sense of § "Excuse-comments": the project openly acknowledges
    the sorry and bundles its reasoning. However, severity is
    **major (not must-fix)**: the project relies on this single `sorry`
    and any iter-121+ work depending on `Jacobian C` is morally
    `sorry`-laden via instance synthesis. Re-confirm of well-known
    project-wide state; not re-classified.
  - L96, L105, L199: three lines >100 chars. Cosmetic only.
  - L30–39: "Forbidden shortcut (sanity check)" block — useful
    self-documenting note about why the witness-based definition is
    chosen over `𝟙_ (Over (Spec (.of k)))`. Not an excuse-comment.
  - `IsAlbanese.ofCurve` (L67–70), `comp_ofCurve` (L72–76), and
    `exists_unique_ofCurve_comp` (L78–84) use `Classical.choose` /
    `.choose_spec` — authorised via the `noncomputable` modifier.
  - `Jacobian` is a protected declaration (`archon-protected.yaml` L8);
    signature is intact and matches the protection.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (re-confirm of known finding)
- **excuse-comments**: 0
- **notes**:
  - `GrpObj.eq_of_eqOnOpen` (L79–114): fully proved, no sorry. Mathematical
    content correct: scheme-level agreement on a dense open of a reduced
    irreducible source with separated target implies global agreement,
    via `ext_of_isDominant_of_isSeparated'`.
  - L62–67: six typeclass arguments (`[GrpObj X]`, `[GrpObj Y]`,
    `[SmoothOfRelativeDimension n X.hom]`, `[SmoothOfRelativeDimension m
    Y.hom]`, `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]`) are
    self-acknowledged redundant given the strengthened scheme-level
    hypothesis (comment block L40–69 documents this). Kept for "abelian
    variety intent and forward-compatibility". Already documented as
    review118 major #2. Severity unchanged; § "Known findings —
    re-confirmed".
  - The L38–70 "Hypothesis correction (iter 003 prover)" docstring
    captures a real mathematical correction (Frobenius counterexample to
    the original point-wise statement). Useful historical record, not an
    excuse-comment. Worth keeping.

### references/challenge.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 7 flagged (the reference-spec sorries)
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0
- **notes**:
  - This file is the **upstream challenge specification** (Christian
    Merten's reference statement of the challenge, version v0.1). It is
    not part of the build (`lakefile.toml` `defaultTargets =
    ["AlgebraicJacobian"]`; the file is under `references/` not
    `AlgebraicJacobian/`) and is not imported by any project module.
  - Contains seven `sorry`s at L54, L60, L69, L74, L78, L82, L89, L95,
    L107 (the canonical `genus`, `Jacobian`, four instances, `ofCurve`,
    `comp_ofCurve`, `exists_unique_ofCurve_comp`). All are placeholders
    by design — this file *is* the specification of what the project
    formalises.
  - No issues. Informational entry only.

## Must-fix-this-iter

(No new must-fix findings for iter-121. The previously-reported
`IsAffineHModuleHomFinite` chain remains must-fix per review118; it is
listed under § "Known findings — re-confirmed" rather than restated
here, per directive.)

## Major

(No new major findings for iter-121.)

## Minor

- `AlgebraicJacobian/Genus.lean:39-61` — 23-line commented-out
  `Sketch of the route` block (alternative `AddCommGrpCat`-based design
  abandoned in favour of the iter-006/iter-009 `HModule` route). Now
  pure reading noise; recommend deletion or compression to a single
  pointer-comment.
- `AlgebraicJacobian/AbelJacobi.lean:51-56,62-68,82-90` — the four
  `letI := (jacobianWitness C).{grpObj, proper, smooth, geomIrred}`
  instance-scaffolding lines are duplicated verbatim across all three
  Jacobian projections. Could be factored into a single `letI` block at
  the `namespace Jacobian` level (or via `attribute [local instance]`)
  to halve the file's letI count.
- `AlgebraicJacobian/AbelJacobi.lean:22` (111 chars),
  `AbelJacobi.lean:59` (101 chars),
  `AlgebraicJacobian/Jacobian.lean:96` (107 chars),
  `Jacobian.lean:105` (107 chars),
  `Jacobian.lean:199` (105 chars),
  `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:438` (117
  chars) — six lines over 100 chars across the project (Mathlib-style
  line-length lint, almost all in docstrings or long instance
  signatures). Pure cosmetic.

## Excuse-comments (always called out separately)

None found in this audit. The Lean comments most likely to draw an
auditor's eye on a casual read — the `nonempty_jacobianWitness` sorry
docstring, the `Differentials.lean` "out of autonomous-loop scope" note,
the `Rigidity.lean` "Hypothesis correction (iter 003 prover)" block,
the `IsAffineHModuleHomFinite` "dead scaffolding" disclosure — are all
**substantive mathematical disclosures**, not "TODO replace later"
hand-waves. The file headers and inline comments accurately characterise
their declarations.

(The `IsAffineHModuleHomFinite` disclosure at L530–538 of
`StructureSheafModuleK.lean` does explicitly describe the predecessor
class as "dead scaffolding". That is honest self-disclosure, but the
**predecessor class itself + its three consumers remain in the file**
unmodified — the issue is the lingering declarations, not the comment.
Already flagged at review118 as must-fix.)

## Known findings — re-confirmed

The directive lists four findings from prior audits to suppress
re-reporting unless their severity has changed. After this iteration's
audit, all four remain at their prior classifications:

- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` —
  `IsAffineHModuleHomFinite` (L458) + three consumers (L476, L497,
  L512). Severity: **must-fix** (review118 #1, re-noted review120).
  iter-121's strategic pivot is M1 Differentials + M2 Rigidity, neither
  of which touches the cohomology files; the dead chain is not unblocked
  or further evidenced by iter-121 work. **Severity unchanged**.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` —
  `HasCechToHModuleIso` (L490) + `HasAffineCechAcyclicCover` (L675),
  both producerless. Severity: **major** (review118 major #1). iter-121
  does not provide producers; cohomology Phase A remains parked.
  **Severity unchanged**.
- `AlgebraicJacobian/Rigidity.lean:62-67` — six redundant typeclass
  arguments on `GrpObj.eq_of_eqOnOpen`. Severity: **major** (review118
  major #2). Comment block L62–67 documents the redundancy as an
  intentional forward-compatibility choice. **Severity unchanged**.
- `AlgebraicJacobian/Differentials.lean:101` + `:106` — line-length
  warnings. Severity: **minor** (review120). At iter-121 head, neither
  L101 nor L106 exceeds 100 chars under raw `awk 'length>100'` (file is
  111 lines total, no flagged hits). Either the prior measurement used
  a stricter threshold (e.g. Mathlib `style.linter.lineLength` at 100
  chars including trailing whitespace) or the lines were lightly
  shortened. **Severity unchanged** (minor → effectively resolved at the
  stricter awk threshold; if the Mathlib linter still warns, classify
  cosmetic).

## Severity summary

- **must-fix-this-iter**: 0 new (1 re-confirmed from review118 — the
  `IsAffineHModuleHomFinite` chain; directive instructs not to
  re-classify).
- **major**: 0 new (2 re-confirmed from review118 — the cohomology
  scaffold producerless classes; the Rigidity typeclass redundancy).
- **minor**: 3 new (Genus.lean sketch-block cleanup; AbelJacobi.lean
  letI duplication; 6 line-length hits across 3 files).
- **excuse-comments**: 0.

Overall verdict: the iter-121 prover-target files (Differentials.lean,
Jacobian.lean, Rigidity.lean) read as clean honest Lean — no new
must-fix issues, no excuse-comments, the sole `sorry` is documented and
load-bearing-by-design; the only new findings are minor cosmetic
cleanups, and previously-flagged must-fix/major findings remain at their
prior severity without iter-121-driven change.
