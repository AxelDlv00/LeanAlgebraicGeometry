# Lean Audit Report

## Slug
review120

## Iteration
120

## Scope
- files audited: 11 (`AlgebraicJacobian.lean` + every `.lean` under `AlgebraicJacobian/`)
- files skipped (per directive): 0
- out-of-scope per directive (not audited): `references/challenge.lean`

Build hygiene cross-checks performed (read-only LSP):
- `lean_diagnostic_messages` for every file in scope: only **one error/warning class** present — the intentional `sorry` on `nonempty_jacobianWitness` (`Jacobian.lean:176`, recorded as `sorry` at L179). Two `linter.style.longLine` warnings: `Jacobian.lean:199`, `AbelJacobi.lean:22`.
- `lean_verify AlgebraicGeometry.Scheme.smooth_locally_free_omega`: `axioms = [propext, Classical.choice, Quot.sound]` — kernel-only. **No `sorryAx` and no custom axiom dependencies introduced by the new forward-smoothness proof.**
- `lean_verify AlgebraicGeometry.nonempty_jacobianWitness`: `axioms = [propext, sorryAx, Classical.choice, Quot.sound]` — `sorryAx` matches the single intentional sorry; no other axioms leak in.

## Per-file checklist

### AlgebraicJacobian.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: none
- excuse-comments: none
- notes:
  - Pure import aggregator. 10 imports, all of files present in scope. No declarations.

### AlgebraicJacobian/AbelJacobi.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: 1 (minor)
- excuse-comments: none
- notes:
  - L22 long-line warning (`linter.style.longLine`, the `(jacobianWitness C).isAlbaneseFor P` example line in the module docstring) — cosmetic.
  - The four `letI := (jacobianWitness C).*` re-introduction lines repeat verbatim three times (L52–55, L65–68, L86–89). Light DRY pressure but not a finding (each lives in its own declaration body and dot-resolution differs).
  - All three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) project cleanly from the witness via `(jacobianWitness C).isAlbaneseFor P`. Signatures match `archon-protected.yaml`.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: none
- excuse-comments: none
- notes:
  - File compiles clean. Heavy use of `set_option backward.isDefEq.respectTransparency false in` (L354, L523, L539, L565) — each is anchored to a single declaration that genuinely needs reduced-transparency unification (structure-literal `.f` projection or `precompOfLinear` bridging). Justified.
  - The `private` namespace-spanning helpers `Abelian.Ext.chgUniv_add` / `_smul` (L60, L79) are honestly Mathlib gap-fills; the universe-bridge `chgUnivLinearEquiv` (L101) is the consumer.
  - `HModule'_shortComplex` `@[simps]` (L302) — fine.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: none
- excuse-comments: none
- notes:
  - **Polish-stage backlog confirmed (per directive, not re-reported as new):**
    - `HasCechToHModuleIso` (L490): `Prop`-class with a single `Nonempty (∀ n, …)` field. Still has no producer instance in the project. The docstring claims a producer will be supplied "Once iter-051+ proves the substantive comparison theorem" — this iter-051+ producer is still absent. Class fate: dormant scaffolding.
    - `HasAffineCechAcyclicCover` (L675): existence-bundled `Prop`-class quantifying over affine opens. Producer instance for `Scheme.toModuleKSheaf C` (the only relevant downstream sheaf) is still absent. The downstream `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699) fires only when the carrier is supplied. Class fate: dormant scaffolding, but unlike `IsAffineHModuleHomFinite` this one is *producibly correct* — the Koszul/Čech-comparison route the docstring sketches genuinely produces it for affine opens of a curve.
  - The `_curve` thin wrappers (L451, L548, L597, L647) faithfully specialise the abstract sheaf forms to `Scheme.toModuleKSheaf C`. No semantic divergence.
  - Comments at L504–505 reference "axiom set" in prose; matched by my `axiom` grep but not a Lean `axiom` declaration. False positive on that grep.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: none
- excuse-comments: none
- notes:
  - Single instance (L39) honestly closed via `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`.
  - File-level `import Mathlib` is the only `import Mathlib` in the project (everything else routes through this); intentional choice for transitivity. Not a finding.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: none
- excuse-comments: none
- notes:
  - Three honest instances/defs. `instHasSheafify_Opens_AddCommGrp` (L34) is `inferInstance` — Mathlib provides this via concrete-category sheafification, the project-side declaration only pins the universe. Acceptable.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- outdated comments: 0
- suspect definitions: 0
- dead-end proofs: 0
- bad practices: 0
- excuse-comments: none
- notes:
  - **Polish-stage backlog confirmed (per directive, not re-reported as new):**
    - `IsAffineHModuleHomFinite` (L458) + consumer `module_finite_HModule'_zero_of_isAffineHModuleHomFinite` (L476) + downstream `module_finite_HModule'_of_affine` / `_curve` (L497, L512): the *iter-118 dead-chain*. The iter-043 docstring (L521+) explicitly documents *why* iter-041's class is dead — `Γ(U, O_C)` is infinite over `k` for a proper affine open, so no producer instance can exist. The replacement carrier `IsHModuleHomFinite` (L544) IS supplied with a producer (`instIsHModuleHomFinite_toModuleKSheaf`, L765). The dead chain (iter-040 producer side `module_finite_HModule'_of_affine` still references `IsAffineHModuleHomFinite` as an instance hypothesis) thus cannot fire on any concrete curve. Still present, unchanged from review118 (auditor confirms fate).
  - Heavy file (935 lines), but every iter-NN docstring tracks a single closed substantive step. No suspect bodies on the main path; the Stein-finiteness producer at L765 honestly chains iter-044 (`module_finite_globalSections_of_isProper`, L605) → iter-045 (`SheafGammaObj_linearEquiv_top`, L660) → iter-046 (`constantSheafGammaHom_linearEquiv` + `homFromOne_linearEquiv`) into the `Module.Finite` conclusion.
  - The `letI alg2 : Algebra ... := RingHom.toAlgebra C.hom.appTop.hom` (L611) is used implicitly through `RingHom.finite_algebraMap` even though `alg2` is never named again — Lean's instance synthesis picks it up. The named-but-otherwise-unused `letI` is intentional; non-finding.

### AlgebraicJacobian/Differentials.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: none
- excuse-comments: none
- notes:
  - **Audit of the newly-closed forward smoothness criterion `smooth_locally_free_omega` (L91–L109):**
    - Signature (L91–98): Forward direction only (smooth-of-relative-dimension ⇒ ∃ local affine charts with free Ω of rank n). The reverse direction is documented as **mathematically false** in the docstring (counterexample `Spec k → Spec k[t]`, `t ↦ 0`). Honest scope.
    - Proof body (L99–109):
      - `intro x; obtain ⟨U, hU, V, hV, hxV, e, hRing⟩ := SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension …` — destructures the Mathlib API to standard-smooth local chart data.
      - `refine ⟨U, V, e, hxV, hU, hV, ?_, ?_⟩` produces two goals (Free, rank).
      - `<;> · algebraize [CommRingCat.Hom.hom (Scheme.Hom.appLE f U V e)] ; haveI : Algebra.IsStandardSmooth … ; haveI : Nonempty V := ⟨⟨x, hxV⟩⟩ ; first | exact … | exact …`
      - The shared tactic body uses `algebraize` to re-register the algebra structure created by the signature's `letI`, then introduces the `IsStandardSmooth` and `Nonempty V` hypotheses, then `first` discharges each goal with the appropriate `Algebra.IsStandardSmooth.free_kaehlerDifferential` / `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential n`.
      - The `first | exact A | exact B` pattern after `<;>` is slightly unusual (a more explicit `· … · …` would name each goal) but is semantically clean — the `first` branch that fits each goal succeeds. No correctness concern.
    - Axiom hygiene (verified): `[propext, Classical.choice, Quot.sound]` only — no `sorryAx`. Honestly closed.
    - Docstring "Mathlib gap" disclosure (L73–90): names `KaehlerDifferential.isLocalizedModule_map`, presheaf cofinality machinery. Per directive, these are honest scope statements describing an unbuilt bridge, not excuse-comments. They do NOT claim that a Lean declaration in this file is wrong — they describe what the *presheaf-form* bridge would require but is deferred. Verified the existing declarations (`relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`, `smooth_locally_free_omega`) all type-check and have no `sorry`.

### AlgebraicJacobian/Genus.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: none
- excuse-comments: none
- notes:
  - The commented-out scaffold block at L39–61 is the historical Phase-A route sketch (with a commented `sorry⟩`). Per directive, this is intentional historical scaffolding and not flagged.
  - `genus` (L65–68) is honestly closed: `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.

### AlgebraicJacobian/Jacobian.lean
- outdated comments: none
- suspect definitions: none
- dead-end proofs: none
- bad practices: 1 (minor)
- excuse-comments: none
- notes:
  - **Single sorry at L179 inside `nonempty_jacobianWitness`** — the only intentional foundational existence claim. Per directive, NOT flagged.
  - L199 long-line warning (style only).
  - "Forbidden shortcut (sanity check)" comment block (L30–39) is a *positive* design note explaining why `Jacobian C := 𝟙_ _` is wrong for genus > 0 — this is the opposite of an excuse-comment.
  - The four protected `instance`s (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) project uniformly from `(jacobianWitness C).{grpObj,smoothGenus,proper,geomIrred}`. Signatures match `archon-protected.yaml`.
  - `geometricallyIrreducible_id_Spec` (L120) is a tiny self-contained helper, honestly closed.

### AlgebraicJacobian/Rigidity.lean
- outdated comments: 0
- suspect definitions: 0
- dead-end proofs: 0
- bad practices: 1 (minor)
- excuse-comments: none
- notes:
  - **Polish-stage backlog confirmed (per directive, not re-reported as new):** The "redundant typeclass args" comment block at L62–67 of `GrpObj.eq_of_eqOnOpen` explicitly admits `[GrpObj X]`, `[GrpObj Y]`, both `SmoothOfRelativeDimension`, `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]` are now unused with the strengthened hypothesis but kept "to preserve the declaration's 'abelian-variety' intent". Confirmed still present, unchanged from prior auditor flagging.
  - `eq_of_eqOnOpen` body (L90–114) is honestly closed: it sets up `IsSeparated` (via `IsProper.toIsSeparated`), `IrreducibleSpace X.left` (via `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`), `IsDominant U.ι` (via density of nonempty opens in irreducible spaces), and concludes through `Over.OverMorphism.ext` + Mathlib `ext_of_isDominant_of_isSeparated'`. No suspicious bodies.
  - The `## Hypothesis correction (iter 003 prover)` block (L38–70) is a substantive design memo explaining why the iter-002 hypothesis was strengthened; not an excuse-comment.

## Must-fix-this-iter

(empty)

## Major

(empty)

## Minor

- `AlgebraicJacobian/Jacobian.lean:199` — line exceeds the 100-character style limit (`linter.style.longLine`).
- `AlgebraicJacobian/AbelJacobi.lean:22` — line exceeds the 100-character style limit (`linter.style.longLine`).

## Excuse-comments (always called out separately)

None found.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 2 (both are style-linter long-line warnings; cosmetic)
- **excuse-comments**: 0

Overall verdict: clean iteration — the new `smooth_locally_free_omega` proof body is honestly closed with kernel-only axioms; the only sorry is the project-external `nonempty_jacobianWitness`; the three known polish-backlog items (dead `IsAffineHModuleHomFinite` chain, dormant `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` scaffolding-classes, redundant typeclass args in `GrpObj.eq_of_eqOnOpen`) are all confirmed still present and unchanged from the prior iterations' findings — per directive, not re-classified.
