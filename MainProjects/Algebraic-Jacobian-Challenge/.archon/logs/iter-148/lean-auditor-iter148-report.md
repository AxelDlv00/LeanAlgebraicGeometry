# Lean Audit Report

## Slug
iter148

## Iteration
148

## Scope

- files audited: 13 (every `.lean` actually present under `AlgebraicJacobian/`, plus the root `AlgebraicJacobian.lean`)
- files skipped (per directive): 0

### Directive ↔ filesystem mismatch (advisory)

The directive lists six files that do not exist on disk
(`Cotangent.lean`, `Cohomology.lean`, `Cotangent/Modules.lean`,
`Cohomology/Acyclic.lean`, `Cohomology/BasicOpenCech.lean`,
`Cohomology/MayerVietoris.lean`) and omits two that do exist
(`Cohomology/MayerVietorisCore.lean`, `Cohomology/MayerVietorisCover.lean`).
Per the descriptor's "List every `.lean` file under the project" rule
I audited the actual filesystem. The directive's file list appears to
be stale — the upstream caller (review agent) should refresh the
directive template from the current file tree.

## Per-file checklist

### AlgebraicJacobian.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import root. 13 `import AlgebraicJacobian.…` lines, no
    declarations. Imports list matches files actually present.

### AlgebraicJacobian/AbelJacobi.lean

- **outdated comments**: 1
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14: status block "Status (iteration 073 — Phase E closes by
    reduction)" — accurate in content but the iteration number is
    75 iters stale (project is at iter-148). Minor cosmetic; the
    structural content (witness projection chain) still matches the
    code below.
  - All three protected declarations (`ofCurve`, `comp_ofCurve`,
    `exists_unique_ofCurve_comp`) are honest one-line projections from
    `(jacobianWitness C).isAlbaneseFor P`; the `letI` instance dance
    discharging the `GrpObj`/`IsProper`/`Smooth`/`GeometricallyIrreducible`
    typeclass arguments is uniform and reasonable.

### AlgebraicJacobian/Genus.lean

- **outdated comments**: 1
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14: status block dated "iteration 011 — `genus`"; content still
    accurate (one-line `Module.finrank` definition over `HModule`).
    Minor cosmetic drift.
  - Definition matches the standard `dim_k H¹(C, O_C)` by reading the
    Lean alone.

### AlgebraicJacobian/Differentials.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Four honest declarations: `relativeDifferentialsPresheaf`
    (definition via Mathlib's pullback-pushforward adjunction);
    `relativeDifferentialsPresheaf_obj_kaehler` (`rfl`); the
    subsingleton-Kähler-of-localisation lemma; the tower-cancellation
    `LinearEquiv`; and `smooth_locally_free_omega` (forward Jacobian
    criterion, closed by `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`).
  - The disclaimer at L118–123 about the converse-direction being
    mathematically false is correctly stated as a directional remark,
    not as a defence of a wrong definition.

### AlgebraicJacobian/Jacobian.lean

- **outdated comments**: none
- **suspect definitions**: 2 (load-bearing `sorry` bodies — see
  must-fix below)
- **dead-end proofs**: 1
- **bad practices**: 1
- **excuse-comments**: none (the documented `sorry` bodies are
  explicit, well-scoped, and gated on named milestones — they are
  suspect-substance, not excuse-comments)
- **notes**:
  - L193–197 `genusZeroWitness` body is `sorry`; L219–223
    `positiveGenusWitness` body is `sorry`. Both bodies are documented
    as load-bearing scaffolding gated on M2 / M3 milestones; the
    `nonempty_jacobianWitness` theorem (L249–254) is genus-stratified
    delegation between the two scaffolds. The structure is honest
    (no inline `sorry` in `nonempty_jacobianWitness`'s body), but the
    two underlying witnesses still have `sorry` bodies. See must-fix.
  - L102–128 `IsAlbanese.unique` proof computes `g₁_eq_id`,
    `ggh_eq_g₁`, `hgh`, `k₂_eq_id`, `hhg_eq_k₂`, `hhg` (proofs that
    `g ≫ h = 𝟙` and `h ≫ g = 𝟙`, packaging `g` as an iso) but the
    return value only uses `g`, `hg_eq`, `hg_unique`. The
    inverse/identity proofs are dead in the proof body — this is a
    proof-golfing dead-end, classified as major.
  - L132–140 `geometricallyIrreducible_id_Spec` is closed honestly.
  - L259–262 `jacobianWitness` uses `Classical.choice
    (nonempty_jacobianWitness C)` — authorized by the bundling
    design, not a stealth axiom.
  - The "Forbidden shortcut (sanity check)" block at L44–53 is a
    good defensive comment — the auditor commends it. It documents
    *why* the obvious one-liner is mathematically wrong without
    silently relying on the reader to notice.

### AlgebraicJacobian/Rigidity.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91–121) closed honestly by
    delegating to Mathlib's `ext_of_isDominant_of_isSeparated'`.
    The "Hypothesis history" docstring is exemplary — it documents
    *why* the original point-wise hypothesis was strengthened to
    scheme-level equality on `U` (Frobenius counterexample in
    characteristic `p`). Good defensive documentation.

### AlgebraicJacobian/RigidityKbar.lean

- **outdated comments**: none
- **suspect definitions**: 1 (load-bearing `sorry` body — see
  must-fix below)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L75–87 `rigidity_over_kbar` body is a single `sorry`. The
    declaration is a substantive classical input (Mumford §4
    rigidity) and the body is explicitly gated on the cotangent-
    vanishing pile per the docstring at L20–29. Documented but
    still a `sorry` on a load-bearing claim — see must-fix.
  - The L32–46 "Encoding choice" block documents *why* the abstract
    "smooth proper geom-irred curve over `k̄` of genus 0" encoding
    was preferred over a literal `MvPolynomial`-based encoding; the
    author correctly flags the literal choice as "mathematically
    wrong as written". Good audit-trail.

### AlgebraicJacobian/Cohomology/SheafCompose.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single instance, closed by `Limits.comp_preservesLimits` +
    `hasSheafCompose_of_preservesLimitsOfSize`. Honest.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Two instances + one `noncomputable def` (the structure sheaf as
    an `AddCommGrp`-valued sheaf via `sheafCompose`); all closed
    via `inferInstance` / `HasExt.standard` / direct construction.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - ~880 LOC, no `sorry`. Contains:
    - Mathlib gap-fills: `Functor.const_additive`, `Functor.const_linear`,
      `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`,
      `Adjunction.homLinearEquiv` (genuine `Adjunction`-namespace
      contributions, well documented).
    - Phase A step 5 helpers (1)–(7) for the `ModuleCat k`-valued
      structure sheaf.
    - `HModule` / `HModule'` abbrevs (correctly `noncomputable abbrev`,
      not `def`, so instance synthesis sees through the wrapper).
    - Finite-length carrier classes (`IsAffineHModuleVanishing`,
      `IsHModuleHomFinite`) — `Prop`-classes, documented producer
      instances at iter-046.
    - Čech complex carriers (`cechCochain`, `cechCohomology`) +
      `IsCechAcyclicCover` class.
  - L463–486 historical note on the *abandoned* per-affine-open
    Hom-finiteness variant is exemplary: it documents *why* the
    earlier iter-041 attempt was deleted (the claim is
    mathematically false on a non-trivial proper curve because
    `Γ(U, O_C)` is not finite over `k` on a proper affine open).
    Author commends the "delete and explain" discipline.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 0 (the `set_option backward.isDefEq.respectTransparency false in` blocks are mirrors of the upstream Mathlib `MayerVietoris.lean` pattern, not project-side hacks)
- **excuse-comments**: none
- **notes**:
  - Mathlib gap-fill `Abelian.Ext.chgUnivLinearEquiv` (L101–110)
    upgrades the bare `Equiv` to a `LinearEquiv` — non-trivial
    additivity/scalar-multiplicativity helpers (L60–91) supplied.
  - Phase A step 6 *Path 2* infrastructure (`HModule'_cohomologyPresheafFunctor`,
    `HModule'_toBiprod`, `HModule'_fromBiprod`, `HModule'_δ`,
    `HModule'_sequence`, `HModule'_sequence_exact`, and the simp
    companions) — direct `ModuleCat k`-side mirrors of upstream
    Mathlib `MayerVietorisSquare.lean`, all closed honestly.
  - `ModuleCat_free_isLeftAdjoint` and `ModuleCat_free_preservesMonomorphisms`
    are genuine Mathlib gap-fills.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `AffineCoverMVSquare` structure + `toMayerVietorisSquare` bridge +
    corner-identification simp lemmas — honest bundling.
  - Cover-totality `LinearEquiv` chain (iter-031 → iter-034)
    constructs `HModule' k F n T ≃ₗ[k] HModule k F n` for a
    terminal `T`, closed honestly via `Abelian.Ext.precompOfLinear`
    + `Abelian.Ext.chgUnivLinearEquiv` (the iter-034 gap-fill in
    `MayerVietorisCore.lean`).
  - `HasCechToHModuleIso` is a `Prop`-class with a `Nonempty`-wrapped
    data field; `cechToHModuleIso` extracts via `Classical.choice`.
    This is the standard "data hidden inside `Prop`-class" pattern
    used to thread an iso through typeclass synthesis — fine.
  - `HasAffineCechAcyclicCover` (L675–682) and the producer
    `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`
    (L699–709) honestly chain through iter-052's rewrite-bridge
    consumer; no `sorry`.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean

- **outdated comments**: 0
- **suspect definitions**: 2 (one critically wrong-signature; one
  with a load-bearing `sorry` body)
- **dead-end proofs**: 1 (`df_zero_factors_through_constant_on_chart`
  inherits the wrong-signature defect of its callee)
- **bad practices**: 1 (decorative typeclasses on
  `df_zero_factors_through_constant_on_chart`)
- **excuse-comments**: 0 (the documentation is explicit about
  intentional `sorry` placement, but the wrong-signature admission
  on the KDM helper crosses into must-fix territory)
- **notes**:
  - L11–25 `iter-145 NOTE` / `iter-146 NOTE` blocks are honest
    audit-trail comments documenting an import substitution and a
    local-instance re-enabling. Fine as documentation.
  - L84–88 `GrpObj.algebra_isPushout_of_affine_product` closed by
    `inferInstance` after `Algebra.TensorProduct.rightAlgebra` is
    re-enabled as a local instance — honest one-liner.
  - L123–168 `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`:
    **the docstring openly admits the conclusion is mathematically
    false** under the stated hypotheses (L117–119: "The signature is
    honest: the conclusion is false in general for finite-type
    `k`-algebras in characteristic `p > 0` (e.g. `B = k[x]`, `b = x^p`
    has `D b = 0` but `b ∉ range (algebraMap k B)`)"). The body is
    `sorry`. **No amount of effort can close this `sorry` as
    long as the signature is unchanged** — the counterexample is
    valid. See must-fix.
  - L196–210 `GrpObj.df_zero_factors_through_constant_on_chart`
    carries four typeclasses on `C` (`[Smooth (C ↘ Spec k)]`,
    `[IsReduced C]`, `[IsProper (C ↘ Spec k)]`,
    `[GeometricallyIrreducible (C ↘ Spec k)]`) but the body merely
    calls the KDM helper above, which does not consume these
    typeclasses. So the four `C`-side typeclasses are **decorative**
    — they don't enter the proof. The docstring (L205–210) claims
    they are "the iter-146 disposition (B.preferred)'s standing
    premise for the char-p Frobenius-iteration step (p3) of the
    KDM helper above", but the KDM helper signature does not accept
    any `C`-side argument, so the bridge cannot fire. See must-fix.
  - L249–371 `constants_integral_over_base_field`: substep (1)+(2)
    of the chain are closed honestly; substep (3) is a documented
    structured `sorry` at L367 inside a `have ⟨hPI, hSep⟩ := by
    sorry`. The decomposition is sound, and the substep (3) sorry
    is on a legitimately deferred sub-claim — but it remains a
    `sorry` on a substantive geometric reduction. See must-fix.
  - L402–412 `Scheme.Over.ext_of_diff_zero` is closed honestly by
    delegating to `Scheme.Over.ext_of_eqOnOpen` (Rigidity.lean
    iter-125 packaging). The docstring (L386–401) is candid: the
    *current* signature does not yet take a `df = dg` chart-algebra
    hypothesis (only `eqOnOpen`), so the name "of_diff_zero" is
    aspirational rather than literal. The author flags this
    explicitly as iter-147+ work. Minor (the name doesn't yet match
    the signature) but the discrepancy is documented, not silenced.

### AlgebraicJacobian/Cotangent/GrpObj.lean

- **outdated comments**: 3 substantial blocks (stale section
  framing referring to excised iter-145 declarations)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `cotangentSpaceAtIdentity` (L162–201) is closed (no `sorry`)
    via a `Classical.choose`-chain on `smooth_locally_free_omega`.
    The "Caveat on canonicity" block (L138–153) is honest defensive
    documentation: the construction is non-canonical *as a value*
    (because `Classical.choose` is used), but the *structural shape*
    needed by the consumer (`rigidity_over_kbar`) is what's actually
    load-bearing.
  - `cotangentSpaceAtIdentity_eq_extendScalars` (L211–232) and
    `cotangentSpaceAtIdentity_finrank_eq` (L257–295) are companion
    lemmas, both honestly closed.
  - **Stale section comment L297–327** ("Piece (i.b) — shear-iso
    globalisation of the cotangent"): the comment block describes
    a three-step closure chain targeting a main lemma
    `mulRight_globalises_cotangent`. Step 2
    (`relativeDifferentialsPresheaf_basechange_along_proj_two`) was
    excised in iter-145 (see L552–560 EXCISE marker); the main
    lemma was excised in iter-145 (see L624–629 EXCISE marker).
    Only Step 1 (`shearMulRight`) and Step 3
    (`relativeDifferentialsPresheaf_restrict_along_identity_section`)
    survive, as orphans pointing at a removed target. The section
    framing is stale by ~13 iterations.
  - **Stale section comment L398–406** ("Helpers / main lemma for
    piece (i.b)"): references the same excised "main lemma".
  - **Stale section comment L428–451** ("Helper sub-lemmas and main
    lemma of piece (i.b)"): says "Status: Step 3 closed iter-136
    (no sorry); Step 2 PARTIAL iter-137 (body remains `sorry`)" —
    but Step 2 was excised in iter-145, not partial.
  - **Stale section comment L466–525** ("Piece (i.b) Step 2:
    base-change-along-`pr_2` iso (iter-138 PARTIAL skeleton)"):
    describes the now-excised Step 2 declaration in extensive
    detail. ~60 lines of stale documentation.
  - The L552–560 + L624–629 EXCISE markers are honest commit-style
    "what was here and why we removed it" comments — appropriate.
    The corresponding section framing above (L297–327 etc.) should
    be re-edited to match.
  - `isIso_of_app_iso_module` (L544–550) is a genuine Mathlib
    gap-fill (mirrors `Scheme.Modules.Hom.isIso_iff_isIso_app` for
    `PresheafOfModules` rather than `SheafOfModules`), upstream-PR
    candidate per the docstring. Good.
  - `shearMulRight` (L349–384) is `@[simps]`-tagged with full
    `hom_inv_id` / `inv_hom_id` proofs (no `sorry`). The
    "NEEDS_MATHLIB_GAP_FILL" annotation at L346 is *describing the
    Mathlib gap that this declaration fills locally*, not an
    excuse for a sorry — the declaration itself is closed.
  - `relativeDifferentialsPresheaf_restrict_along_identity_section`
    (L579–622) is closed honestly via `PresheafOfModules.pullbackComp`
    and the `section_snd_eq_identity_struct` helper.

## Must-fix-this-iter

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:123` —
  `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` has a
  signature whose conclusion is **mathematically false** in
  characteristic `p > 0` under the stated hypotheses; the docstring
  at L117–119 admits this openly, then ships the signature anyway
  with a `sorry` body at L168. Why must-fix: a signature that
  *cannot* be closed honestly is a permanent `sorry` — the body
  cannot be filled by future iterations without changing the
  signature. This is the "weakened-wrong definition" anti-pattern
  in its purest form (the author labels it "honest" but honesty
  about wrongness does not make the claim provable). Fix path:
  strengthen the signature (e.g.\ add `[CharZero k]` plus
  `[Algebra.IsStandardSmoothOfRelativeDimension k B]`, or take the
  char-p Cartier path with `[Algebra.IsStandardSmooth k B]` + a
  Frobenius hypothesis), or — equivalently — acknowledge that the
  blueprint's mandated entry-point name needs to migrate to a
  signature that can be proved.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:196` —
  `GrpObj.df_zero_factors_through_constant_on_chart` is a thin
  consumer of the above; it carries four `C`-side scheme typeclasses
  (`[Smooth]` / `[IsProper]` / `[IsReduced]` /
  `[GeometricallyIrreducible]`) that **never enter its body**, and
  its callee accepts none of them. Why must-fix: the consumer thus
  also cannot be closed honestly until its callee's signature is
  fixed. The decorative typeclasses make the call-site *look* like
  it has more context, but typeclass synthesis cannot bridge them
  to the helper. Same root cause as the line above.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:367` —
  `constants_integral_over_base_field` has substep (3) as a
  consolidated `have ⟨hPI, hSep⟩ : IsPurelyInseparable k Γ ∧
  Algebra.IsSeparable k Γ := by sorry`. Why must-fix: load-bearing
  `sorry` on a substantive geometric reduction. The decomposition
  (b.1)+(b.2) into named Mathlib sub-gaps is sound; this is the
  better-classified of the two ChartAlgebra sorries (the
  signature is provable in principle, just gated on Mathlib
  infrastructure that doesn't yet exist). Flag per descriptor rule
  on substantive load-bearing sorries.
- `AlgebraicJacobian/Jacobian.lean:197` — `genusZeroWitness` body
  is `sorry`. Why must-fix: load-bearing existence claim
  (Spec-`k`-Albanese witness for genus-0 curves) on which the
  whole `Jacobian` definition depends through
  `nonempty_jacobianWitness` → `jacobianWitness`. Documented and
  gated on iter-138+ pieces, but it's a `sorry` on a substantive
  claim, flagged per descriptor rule.
- `AlgebraicJacobian/Jacobian.lean:223` — `positiveGenusWitness`
  body is `sorry`. Why must-fix: same shape as `genusZeroWitness`
  (the positive-genus arm of the genus-stratified existence). Same
  flag basis.
- `AlgebraicJacobian/RigidityKbar.lean:87` — `rigidity_over_kbar`
  body is `sorry`. Why must-fix: load-bearing classical input
  (Mumford §4 keystone) feeding into the M2.a chain. Same flag
  basis.

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:297-327` — stale section
  framing comment "Piece (i.b) — shear-iso globalisation of the
  cotangent: three structural pieces" lists a main lemma
  `mulRight_globalises_cotangent` and a Step 2 declaration
  `relativeDifferentialsPresheaf_basechange_along_proj_two` that
  were both excised in iter-145. Only Step 1 (`shearMulRight`) and
  Step 3 (`relativeDifferentialsPresheaf_restrict_along_identity_section`)
  remain. Stale by ~13 iterations. Edit the section framing to
  reflect the current orphan-helper status of the survivors, or
  decide whether the survivors should themselves be excised.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:398-406` — same stale
  framing, different block.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:428-451` — section
  comment claims "Step 2 PARTIAL iter-137 (body remains `sorry`)"
  but the iter-145 EXCISE removed Step 2 entirely. Update or
  delete.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:466-525` — ~60-line
  documentation block describing the iter-138 PARTIAL skeleton of
  the now-excised Step 2. Substantively stale.
- `AlgebraicJacobian/Jacobian.lean:102-128` — `IsAlbanese.unique`
  proof body computes `g₁_eq_id`, `ggh_eq_g₁`, `hgh`, `k₂_eq_id`,
  `hhg_eq_k₂`, `hhg` (the inverse / identity proofs packaging `g`
  as a two-sided iso) but the return `⟨g, hg_eq, fun g' hg' =>
  hg_unique g' hg'⟩` only uses `g`, `hg_eq`, `hg_unique`. The
  iso-proof computations are dead in the proof body — they would
  belong if the statement returned the iso (which the `unique`
  declaration does not). Proof can be roughly halved by deleting
  them. Not blocking; classified as a proof-golfing dead-end.

## Minor

- `AlgebraicJacobian/AbelJacobi.lean:14` — status block dated
  "iteration 073" with current iteration 148. Content still
  accurate (witness-projection chain). Cosmetic refresh.
- `AlgebraicJacobian/Genus.lean:14` — status block dated
  "iteration 011". Content still accurate. Cosmetic refresh.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:402-412` — the
  name `Scheme.Over.ext_of_diff_zero` is currently aspirational:
  the signature takes an `eqOnOpen` hypothesis directly (not a
  `df = dg` chart-algebra hypothesis), so the "diff_zero" in the
  name doesn't yet match the data carried. The docstring openly
  flags this as iter-147+ refinement work, but the name-vs-shape
  discrepancy is a minor naming-drift smell until the planned
  refinement lands.

## Excuse-comments (always called out separately)

None flagged in the strict sense (no `-- TODO: replace with the
real def`, `-- placeholder`, `-- temporary`, `-- wrong but works`,
`-- will fix later` comments anywhere in the project source).

Distinct from excuse-comments — and explicitly NOT classified as
such here — are the documented-`sorry` blocks (Jacobian.lean,
RigidityKbar.lean, ChartAlgebra.lean substep 3). These have an
honest closure-path narrative and are gated on named milestones;
they go to must-fix as suspect bodies on substantive claims, but
not under the excuse-comment header.

The ChartAlgebra.lean `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
docstring (L117–122) is the borderline case. It openly admits the
signature's conclusion is false yet says "the lemma as stated
remains the blueprint-mandated entry point". This is not phrased
in the excuse-comment idiom of `-- TODO`, but it documents
*intentionally shipping a wrong signature with a permanent sorry*,
which is morally the same admission. Classified under must-fix
above as the more substantive finding rather than duplicating
here.

## Severity summary

- **must-fix-this-iter**: 6 (1 wrong-signature anti-pattern + 1
  decorative-typeclass consumer of same + 4 documented load-bearing
  `sorry` bodies)
- **major**: 5 (4 stale section-framing blocks in
  Cotangent/GrpObj.lean referring to iter-145-excised declarations
  + 1 dead-code computation in `IsAlbanese.unique`)
- **minor**: 3 (2 cosmetic iter-number drift in status blocks +
  1 aspirational name in Cotangent/ChartAlgebra.lean)
- **excuse-comments**: 0 (strict definition); the borderline case
  on the wrong-signature KDM helper is classified under must-fix.

Overall verdict: the project's load-bearing sorries are well-documented
and clearly gated, BUT `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
ships a signature whose conclusion the author admits is mathematically
false — fix the signature (strengthen hypotheses or rename the
blueprint anchor) rather than maintaining a permanent sorry under a
provable-looking name.
