# Lean Audit Report

## Slug
iter126

## Iteration
126

## Scope
- files audited: 11 (10 under `AlgebraicJacobian/` + umbrella `AlgebraicJacobian.lean`)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure umbrella — 11 imports lines, alphabetised within blocks (Cohomology/*, then differentials/rigidity/genus/jacobian/abel-jacobi). New `AlgebraicJacobian.RigidityKbar` import is present at L8, sits adjacent to `Rigidity`, consistent with file ordering. Clean.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File is 144 lines post-excise (down from 572 — confirmed). Header docstring (L15-29) describes what now actually exists: presheaf `Ω_{X/S}` and the smoothness characterisation. No residual headers referencing the removed bridge theorem `relativeDifferentialsPresheaf_equiv_kaehler_appLE` or the `appLE_isLocalization` Step 0 helper — the prior iter-124 concern is fully resolved.
  - Five retained declarations (L51, L60, L70, L86, L124) all carry mathematically substantive content: the presheaf constructor, the rfl identification of sections with Kähler, the localization-subsingleton lemma, the tower-cancellation `LinearEquiv`, and the forward-direction Jacobian criterion. Each has its own honest docstring and a closed body.
  - L111–123 docstring of `smooth_locally_free_omega` discloses that the reverse direction is mathematically false without extra deformation-theoretic input, naming the counterexample `Spec k → Spec k[t], t ↦ 0`. This is mathematical-honesty disclosure, NOT an excuse-comment — it correctly bounds the statement's scope and points to where the asymmetry comes from.
  - Imports remain non-trivial (`Mathlib.RingTheory.Kaehler.Basic`, `Mathlib.RingTheory.Unramified.Basic`, `Mathlib.RingTheory.Localization.Basic`, three `Mathlib.AlgebraicGeometry.*`, two `Mathlib.Algebra.Category.ModuleCat.Differentials.*`/`AlgebraicGeometry.Modules.Presheaf`). All five are actively used by the remaining declarations; no orphan imports.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (the new scaffold `sorry`, by directive design)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File is 89 lines (close to the directive's stated 87, accounting for the trailing newline / `end`). Single namespace `AlgebraicGeometry`. Single declaration `rigidity_over_kbar` (L75-87).
  - L32–46 "Encoding choice" note: directly addresses why the source `ℙ¹_{k̄}` is encoded abstractly (Option B: smooth proper geometrically irreducible curve of relative dimension 1 with `genus = 0`) rather than as the literal `Spec.map MvPolynomial.C` (Option A). The justification is mathematically sound: Option A would be the affine line, not projective — confirmed correct by reading. The disclosure that Mathlib `b80f227` has no `ProjectiveSpace n S` construction packaged as a `Scheme` is also accurate (Mathlib has `AlgebraicGeometry.Proj` of a graded ring, not specialised). This reads as an honest design disclosure, NOT excuse-prose.
  - Hypotheses (L76-85): `[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`, `_hgenus : genus C = 0`, then for the target `[GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]`, marked point `p`, hypothesis `_hf : p ≫ f = η[A]`. Conclusion: `f = toUnit C ≫ η[A]`. Signature is well-shaped and the `_`-prefixed hypotheses correctly mark the not-yet-used `genus = 0` and `p ≫ f = η[A]` facts in the scaffold body.
  - `sorry` body (L87) is documented in the docstring at L70-74 as a deferred closure gated on the cotangent-vanishing Mathlib pile (iter-129+). This is an honest deferral, not a "fix later" lie.
  - Minor wording concern: the docstring (L58-69) and the file header (L9-16) repeatedly frame the source field as "algebraically closed", but the signature requires only `[Field kbar]`, not `[IsAlgClosed kbar]`. The `[GeometricallyIrreducible …]` hypotheses on `C.hom` and `A.hom` arguably absorb the algebraic-closure content (they encode the geometric/post-base-change content), so the signature is mathematically defensible — and strictly stronger as written (it would apply over any base field). But future readers may find the framing-vs-hypothesis mismatch puzzling. Flag is minor, not blocking — see Major/Minor.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none flagged as actively misleading
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91-121) is honestly closed with a 4-step structured proof. The proof body looks correct: separatedness instance, `IrreducibleSpace` from `GeometricallyIrreducible` + `Spec k` subsingleton, dominance of the open immersion, and final reduction to Mathlib's `ext_of_isDominant_of_isSeparated'` via `Over.OverMorphism.ext`.
  - L43-78 "Hypothesis history" block: two sub-blocks documenting iter-003 (the Frobenius-counterexample justification for strengthening to scheme-level equality) and iter-125 (the unused-hypothesis cleanup). The iter-003 block contains substantive mathematical content (Frobenius-on-elliptic-curve counterexample explains why the symmetric pointwise rigidity statement is false in characteristic p) — defensible to retain. The iter-125 sub-block (L70-78) is iter-narrative bleed, recording which hypotheses were dropped and the renaming `GrpObj.eq_of_eqOnOpen → Scheme.Over.ext_of_eqOnOpen`. This is closer to changelog noise than to mathematical content; the actual rationale (mirroring Mathlib's `ext_of_isDominant_of_isSeparated'`) is already implicit in the proof body. See Major.
  - L24-31 Status block describes the closure state. Mostly accurate.
  - Imports `AlgebraicJacobian.Jacobian` — this is heavy (transitively pulls Genus/StructureSheafModuleK/MayerVietoris/etc.) but is justified because the `Spec (.of k)` ambient lifts plus `IsReduced` typeclass hooks come from there. Defensible.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 46-line file, single definition `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` (L40-43). Mathematically honest definition of dim_k H¹(C, O_C).
  - Status block (L15-28) explains iter-011's closure with the `noncomputable` modifier (user-authorised 2026-05-07) and the import dependency. The "closed iteration 011" framing is accurate.
  - `import Mathlib` is the heaviest possible import (whole-Mathlib umbrella). Could be reduced to a few targeted imports (`Mathlib.Algebra.Module.Finrank`, plus what `Scheme.HModule` / `Scheme.toModuleKSheaf` need from `Cohomology.StructureSheafModuleK`). Build-time / instance-search cost only — not a correctness issue. See Minor.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (`nonempty_jacobianWitness` sorry at L179, OFF-LIMITS per directive — counted but not blocked)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L31-39 "Forbidden shortcut (sanity check)" docstring: documents *why* the trivial terminal-object definition is rejected (it would force `genus C = 0`, mathematically wrong for genus ≥ 1). This is a sanity-check disclosure, NOT an excuse-comment — it warns future maintainers off a tempting but wrong simplification.
  - `IsAlbanese` (L57-63), `IsAlbanese.ofCurve` (L67-70), `IsAlbanese.comp_ofCurve` (L72-76), `IsAlbanese.exists_unique_ofCurve_comp` (L78-84), and `IsAlbanese.unique` (L88-114) are all closed declarations. `IsAlbanese.unique`'s proof (L93-114) is a long but routine ping-pong between the two universal-property witnesses; reads correctly.
  - `geometricallyIrreducible_id_Spec` (L120-126) is a small helper, closed.
  - `JacobianWitness` structure (L143-160) bundles 7 fields plus the `isAlbaneseFor` universal property over arbitrary marked points — well-shaped.
  - `nonempty_jacobianWitness` at L176-179: documented existence sorry. Directive explicitly says "OFF-LIMITS … stays". This is the single load-bearing Phase-C sorry, with the deferral honestly disclosed (Albanese existence via symmetric powers + FGA representability; infrastructure not yet in Mathlib).
  - `Jacobian C := (jacobianWitness C).J` plus 4 protected instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) — all project from witness, clean uniform design.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) all reduce to the corresponding projection from `(jacobianWitness C).isAlbaneseFor P` (L56, L68, L90). Clean witness-driven pattern.
  - Each declaration body uses 4 `letI` lines to surface the `grpObj`/`proper`/`smooth`/`geomIrred` instance fields of the witness. Verbose but mechanical.
  - Status block (L15-29) accurately describes the iter-073 refactor. Iter-narrative is factual and brief.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0 critically stale
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 0 blocking
- **excuse-comments**: none
- **notes**:
  - 878 lines, ~35 declarations spanning iter-005 through iter-053+. All closed (no sorries).
  - L37-49 Status block explicitly notes a *deleted* iter-041 "abandoned attempt" (the per-affine-open `IsAffineHModuleHomFinite` variant). Documenting that the wrong attempt was removed is good hygiene, not excuse-prose.
  - L462-486 docstring of `IsHModuleHomFinite` contains a "Historical note on the abandoned per-affine-open variant" sub-block, ~25 lines of inline narrative explaining why the per-open form was dropped and the wholespace form retained. Long, but mathematically substantive (explains the obstruction: `Γ(U, O_C)` is infinite over `k` for proper affine opens on a non-trivial curve). Acceptable historical disclosure; could be trimmed.
  - Many docstrings reference "queued for iter-049+ / iter-051 / iter-053+" forward-looking work. Some of those iterations have presumably landed (the file already contains iter-049 through iter-053 declarations); these forward references are now stale-but-harmless changelog noise. Not actively misleading.
  - L162: `algebraMap_eq_kToSection` is a `rfl`-bodied unfolding lemma — appropriate as a one-step unfold.
  - L240-252 `toModuleKSheaf_forgetCompare` uses `Iso.refl _` for what is claimed to be a non-trivial forget-and-recover natural iso. This is potentially suspect at first glance — but per the docstring (L240-246) the underlying presheaf is *definitionally* equal after the forget, so `Iso.refl _` is honest definitional content, not a `rfl`-on-substantive-claim red flag. (`@[simp]` lemma `toModuleKPresheaf_obj` at L220-223 supports this.)
  - L262-267 `HModule` is a `noncomputable abbrev` (deliberate — see L260-261 design rationale). Same pattern at L309-315 for `HModule'`. Justified for instance-synthesis reasons.
  - `instance instIsHModuleHomFinite_toModuleKSheaf` (L708-720) is a producer instance closing the iter-046 wholespace H⁰ Hom-finiteness carrier. Body chains `module_finite_gammaObj_of_isProper` + two LinearEquivs + `Module.Finite.equiv`. Looks honest; no shortcuts.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 50-line file. Single instance `instHasSheafCompose_forget_CommRing_AddCommGrp` (L39-47). Body uses `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`. Honest.
  - `import Mathlib` umbrella — could be narrowed. Minor.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 63-line file with three declarations: `instHasSheafify_Opens_AddCommGrp` (L34-37, `inferInstance`), `instHasExt_Sheaf_Opens_AddCommGrp` (L43-47, `HasExt.standard _`), and `toAbSheaf` (L56-61, builds the structure sheaf as `AddCommGrpCat`-valued via the iter-003 `HasSheafCompose`). All clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0 critically stale
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 0 blocking (see Minor)
- **excuse-comments**: none
- **notes**:
  - 628 lines. Two private `Abelian.Ext.chgUniv_add` / `chgUniv_smul` lemmas (L60-91) + public `Abelian.Ext.chgUnivLinearEquiv` LinearEquiv upgrade (L101-110). These are explicitly Mathlib gap-fills; the docstring (L33-51) marks them as such and explains the gap. Clean upstream-candidate code.
  - Mayer-Vietoris infrastructure (iter-016 → iter-026): `HModule'_cohomologyPresheafFunctor`, `HModule'_cohomologyPresheaf` (abbrev), `HModule'_toBiprod`, `HModule'_fromBiprod`, `HModule'_toBiprod_fromBiprod` (with `@[reassoc (attr := simp)]`), `HModule'_isPushoutModuleCatFreeSheaf`, `HModule'_shortComplex` (with `@[simps]`), Mono/Epi/Exact/ShortExact instances, `HModule'_δ` connecting hom, `HModule'_sequence`, `HModule'_sequenceIso`, `HModule'_sequence_exact`, plus simp companions. All closed and structured as direct mirrors of Mathlib's `MayerVietoris.lean` for the `ModuleCat k` flavor. Body shapes look honest.
  - `set_option backward.isDefEq.respectTransparency false in` appears at L354, L523, L539, L565. This is a recognised local workaround mirroring Mathlib's own use in the same Mayer-Vietoris context (per the doc-comments). Documented at each use site. Acceptable but worth a Minor note: scattered `set_option` usage is a smell that could be consolidated.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0 critically stale
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 712 lines. Contains `AffineCoverMVSquare` structure (L50-62, 6 fields), `toMayerVietorisSquare` bridge (L71-74), four corner-identification simp lemmas (L78-101), and iter-029 → iter-053 specialisations / consumers / producer instance.
  - `instance instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699-709) closes the producer-of-class chain. Body unbundles the `HasAffineCechAcyclicCover.exists_cover` existential, locally registers the `IsCechAcyclicCover` + `HasCechToHModuleIso` instances with `haveI`, and chains iter-052's rewrite-bridge. Looks honest.
  - Heavy use of `_curve` specialisations (iter-030, iter-035, iter-036, iter-037, iter-048, iter-049, iter-050, iter-051, iter-052) — thin dot-notation wrappers that save call-site re-typing. Boilerplate but consistent. Could be golfed/macro'd, not a correctness issue.
  - Many docstrings forward-reference "iter-054+ producer", "iter-055+ Module.Finite ladder" etc. — same forward-narrative drift as in `StructureSheafModuleK.lean`. Stale-but-harmless.

## Must-fix-this-iter

(None.)

The only two `sorry` bodies in the project are:
1. `AlgebraicJacobian/Jacobian.lean:179` (`nonempty_jacobianWitness`) — explicitly marked OFF-LIMITS in the iter-126 directive; it is the single load-bearing Phase-C deferral and is honestly documented (the Albanese existence via symmetric powers / Picard scheme, gated on Mathlib infrastructure that does not exist).
2. `AlgebraicJacobian/RigidityKbar.lean:87` (`rigidity_over_kbar`) — the iter-126 scaffold itself, gated per the directive on the cotangent-vanishing Mathlib pile (iter-129+).

Both have substantive mathematical justification in their docstrings, neither is an excuse-comment dressing up a wrong stand-in definition, and neither carries a weakened-wrong body. Per the directive both are authorised.

## Major

- `AlgebraicJacobian/RigidityKbar.lean:9-16, 58-64` — Docstring framing repeatedly says "algebraically closed field `k̄`" / "over `k̄`", but the signature requires only `[Field kbar]`, not `[IsAlgClosed kbar]`. The `GeometricallyIrreducible` hypotheses on `C.hom` and `A.hom` arguably absorb the algebraic-closure content for the proof to go through, and the resulting statement is mathematically *stronger* than the literally-Mumford-§4 form (it applies over any field), but a future reader of just the signature without the docstring may be confused. Either tighten the signature (add `[IsAlgClosed kbar]`) or soften the docstring framing to make explicit that the `[IsAlgClosed]` content is encoded via `GeometricallyIrreducible`.
- `AlgebraicJacobian/Rigidity.lean:70-78` — "Unused-hypothesis cleanup (iter 125)" sub-block: pure changelog narrative (which decorative hypotheses were dropped, which Mathlib naming idiom the rename mirrors). The mathematical rationale (Mathlib's `ext_of_isDominant_of_isSeparated'`) is already implicit in the proof body. Defensible to keep for traceability but a candidate for relocation to a chapter/release-notes file rather than the Lean source.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:462-486` — The "Historical note on the abandoned per-affine-open variant" inside the docstring of `IsHModuleHomFinite` is ~25 lines of inline iter-narrative explaining a *deleted* iter-041 attempt. The math is correct (the obstruction is `Γ(U, O_C)` infinite over `k` for proper affine opens on a non-trivial curve), but the volume is heavy for a single-field class. Consider trimming to one sentence + reference to a changelog.

## Minor

- `AlgebraicJacobian/Genus.lean:6` — `import Mathlib` (whole-Mathlib umbrella). Could be narrowed to the genuinely-used `Mathlib.Algebra.Module.Finrank` plus whatever transitively comes via `Cohomology/StructureSheafModuleK`. Build-time cost, not correctness.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean:6` — same `import Mathlib` umbrella for what could be a narrower import set (only the forget-composite preservation API + `HasSheafCompose`). Build-time cost.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:354, 523, 539, 565` — four occurrences of `set_option backward.isDefEq.respectTransparency false in`. Each is justified at the use site (mirrors Mathlib's identical workaround in the same MV setting); could potentially be consolidated to one local section-wide setting or be revisited once Lean's typeclass-elaboration on backward-reducible defs catches up.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (file-wide) — many docstrings forward-reference iterations (iter-049+, iter-051, iter-053+, iter-054+) that have since landed in the same file. These are now stale-but-harmless changelog crumbs. Same pattern in `MayerVietorisCover.lean`.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (file-wide) — heavy `_curve` boilerplate (~10 dot-notation specialisations) saving call-site re-typing. Routine in this codebase but a candidate for either macro abstraction or being inlined at the (few) actual use sites.
- `AlgebraicJacobian/AbelJacobi.lean` — three `noncomputable def` / `lemma` / `theorem` bodies each open with 4 identical `letI` lines (L52-55, L65-68, L86-89) to surface the witness field instances. Mild boilerplate; a private helper `withWitnessInstances` macro / `open` block could consolidate. Not blocking.

## Excuse-comments (always called out separately)

None found in any file. The two `sorry`-bearing declarations are both honest deferrals with substantive mathematical disclosure in their docstrings (deferred Albanese existence for `nonempty_jacobianWitness`, deferred cotangent-vanishing-pile closure for `rigidity_over_kbar`), not "TODO replace with real definition"-style admissions of wrong code.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The iter-126 structural refactors landed cleanly — `Differentials.lean` is correctly stripped to its 5 retained standalone declarations with no residual stale headers or orphan imports, and the new `RigidityKbar.lean` scaffold is well-shaped with an honest encoding-choice disclosure; the carry-over files compile clean with no excuse-comments anywhere, with only minor narrative-bleed and one docstring/signature-framing mismatch in `RigidityKbar.lean` worth flagging.
