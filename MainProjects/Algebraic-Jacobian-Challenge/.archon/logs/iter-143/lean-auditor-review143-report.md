# Lean Audit Report

## Slug
review143

## Iteration
143

## Scope
- files audited: 14 (the 13 active `.lean` files in `AlgebraicJacobian/` + the top-level `AlgebraicJacobian.lean` import-aggregator + `references/challenge.lean` reference spec)
- files skipped (per directive): 0

Note: the directive listed `AlgebraicJacobian/Cohomology/MayerVietoris.lean` and `AlgebraicJacobian/Cotangent.lean`, neither of which exist in the project (split into `MayerVietorisCore.lean` + `MayerVietorisCover.lean`, and `Cotangent/GrpObj.lean` respectively). Path errors in the directive only — no files were skipped on this basis; all `.lean` files under the project (excluding `.lake/`, `.archon/lanes/`, archived snapshots) were audited.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import-aggregator. 12 imports for the 12 active source files; no body.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) project unconditionally through `(jacobianWitness C).isAlbaneseFor P`. No `sorry`. Header docstring (L15-29) correctly reflects the iter-073 refactor.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Cohort-1 of the iter-063 MV LES split. `Abelian.Ext.chgUnivLinearEquiv` (L101-110) is a legitimate Mathlib gap-fill (upgrades a bare `Equiv` to a `LinearEquiv`). Two `set_option backward.isDefEq.respectTransparency false in` uses (L354, L523, L539, L565) are documented and matched against the upstream Mathlib pattern. All proofs closed.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Cohort-2 of the iter-063 MV LES split. All declarations closed (no `sorry`). `HasCechToHModuleIso` (L490-498) bundles a `LinearEquiv`-valued comparison via `Nonempty`, consumed via `Classical.choice` (L514) — documented and authorised (L502-505 explicitly notes "no new axiom introduced"). `HasAffineCechAcyclicCover` (L675-682) is an iter-053 existence-bundled carrier — not yet populated by an instance for the structure sheaf, but the carrier itself is mathematically faithful and the iter-053 producer (L699-709) is honestly written.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single instance, 5-line body via `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`. Honest.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations (sheafify, Ext, toAbSheaf). All closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Largest file at 877 LOC; carries the bulk of the Phase A step 5 / 6 / cover-evaluation chain. No `sorry`. The four "Iter-046 (Mathlib gap-fill)" declarations (L61-111, `Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv`) are legitimate gap-fills with clean proofs. Class carriers `IsAffineHModuleVanishing` (L432-438), `IsHModuleHomFinite` (L487-492), `IsCechAcyclicCover` (L822-827) are each documented `Prop`-valued and have a matching consumer theorem. The iter-041 abandoned `IsAffineHModuleHomFinite` is correctly disclosed as removed (L41-49 + L470-481 — the geometric reason that affine-open Γ(U, O_C) is *not* finite over k is honest documentation, not an excuse-comment).

### AlgebraicJacobian/Cotangent/GrpObj.lean ⚠️ (focus file)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (unused `have hw` at L637-638 — see notes)
- **bad practices**: 1 (heavy in-Lean comment block — see notes)
- **excuse-comments**: none
- **notes**:
  - 3 declaration-level sorries + 3 inline sorries: `basechange_along_proj_two_inv_derivation` (L573, inline at L663), `basechange_along_proj_two_inv_app_isIso` (L745, inline at L751), `mulRight_globalises_cotangent` (L890, inline at L901). All three are gated, documented, with closure paths spelled out in docstrings or analogy files.
  - **L637-638 `have hw` is unused.** The 1-LOC iter-143 step `have hw : (fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom := by rw [(fst G G).w, (snd G G).w]` introduces a categorical equality and *never consumes it*: the proof falls through ~25 LOC of comments straight to `sorry` on L663. The hypothesis is dead-load. The surrounding comment (L656-662) honestly disclaims this as a scaffold step "beyond what fits in this iter's envelope", but a future maintainer reading the file sees a `have` with no consumer. This is a real audit-transparency cost. **MAJOR finding.**
  - **L602-662 in-Lean comment block (~60 LOC)**: the iter-143 d_app strategy chase is documented in-Lean rather than (or in addition to) in an analogy file. The block contains step-by-step recipe (3.a, 3.b, 3.c, 3.d) plus a "Status iter-143" sub-block. The content is honestly *deferred-work documentation*, **NOT excuse-comment**: phrases like "the bespoke nat-trans chase remains as a typed sorry…beyond what fits in this iter's envelope" describe scope honestly, with concrete Mathlib lemmas named (`PresheafedSpace.comp_c_app`, `Adjunction.homEquiv_naturality_right_symm`, `Pushforward.comp_eq`, `ModuleCat.Derivation.d_map`). The verdicts of `lean-auditor-review140` and `lean-auditor-review142` on the *earlier* analogous docstrings extend cleanly here. However, 60 LOC of strategy comments inside a tactic body is heavy — this content would normally live in an analogy file with a one-line in-Lean pointer. **MINOR code-smell, NOT a must-fix.**
  - **L745-751 `basechange_along_proj_two_inv_app_isIso`** (iter-143 NEW extraction):
    - **Naming**: `<def_name>_app_isIso` — standard Lean snake_case + descriptive suffix. ✓
    - **Signature**: takes `G, [GrpObj], n, [SmoothOfRelativeDimension n G.hom], [IsProper G.hom], [GeometricallyIrreducible G.hom], X` and concludes `IsIso ((basechange_along_proj_two_inv G).app X)`. Inherits all the smoothness instances from the parent `relativeDifferentialsPresheaf_basechange_along_proj_two` (L753-774). The `{n : ℕ}` plus the smoothness instances may not all be needed by the eventual closing proof (the chart-level `Algebra.IsPushout` route only requires affine charts existing locally, which follows from smoothness, so the instances are at least *available* to the closer). **Audit transparency is restored** — the previously-embedded `(fun _ => sorry)` is now a named, documented, sorry-bodied theorem, exactly as `lean-auditor-review142` MAJOR + `progress-critic-iter143` CHURNING recommended. ✓
    - **Docstring** (L727-744): correctly identifies the iter-143 refactor, the closure path (Route (b'2)), the LOC estimate (~195-365 LOC), the cross-reference to `analogies/isiso-basechange-along-proj-two-inv.md` Decision 2 and `RigidityKbar.tex:943-1073`. ✓
  - **`cotangentSpaceAtIdentity` (L162-201)**: body is the iter-131 pure-term `Classical.choose`-chain extraction. Per `lean-auditor-review140` + `lean-auditor-review142`, this body is mathematically faithful (chart-canonicity is not load-bearing for the rigidity argument); the chart-canonicity caveat is honestly documented in the docstring (L138-153) and is *not* an excuse-comment.
  - **Docstrings on L520-572, L702-710, L726-744**: re-confirmed proof-design analysis per directive (carry-over verdict from prior auditors). No new excuse-comment patterns introduced this iter.
  - **`mulRight_globalises_cotangent` (L890)**: docstring (L839-889) outlines Steps 1+2+3 → Compose. Body is `sorry`. Honest scaffold.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 5 declarations, all closed. `smooth_locally_free_omega` (L124-142) is the forward Jacobian criterion consumed by `Cotangent/GrpObj.lean`. The docstring (L118-123) explicitly discloses that the reverse direction is **mathematically false** without `Algebra.H1Cotangent`-vanishing input, with a counterexample reference. This is honest scope-documentation, *not* an excuse-comment.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single definition, body `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. Honest mathematical content.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (style-linter long-line warning, see notes)
- **excuse-comments**: none
- **notes**:
  - 2 declaration-level sorries (`genusZeroWitness` L193, `positiveGenusWitness` L219). Both have documented scaffold status; consumed by `nonempty_jacobianWitness` (L249-254) via a `by_cases h : genus C = 0` decomposition. Header docstring (L19-53) correctly enumerates the open inventory and the "forbidden shortcut" sanity check (L44-52: the `Jacobian C := 𝟙_ _` unconditional definition is correctly forbidden as it would force `genus C = 0`, contradicting `SmoothOfRelativeDimension (genus C)` for higher-genus curves).
  - **Style-linter warning at L275:101** — one declaration line exceeds 100 chars. Minor.
  - The `IsAlbanese.unique` proof (L102-128) is a clean Yoneda-style composition argument; no concerns.
  - `geometricallyIrreducible_id_Spec` (L134-140) is closed.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91-121) closed. The "Hypothesis history" docstring (L43-79) honestly records the iter-003 hypothesis strengthening (from pointwise to scheme-level equality) with a concrete counterexample (absolute Frobenius in char p) — this is mathematically substantive documentation, *not* a stale comment.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 declaration-level sorry (`rigidity_over_kbar` L75). Header docstring (L33-46) explicitly justifies the **Option B encoding** (smooth proper geom. irred. curve over k̄ of genus 0) over **Option A** (literal `Spec(MvPolynomial σ kbar)`, which would be the *affine* not projective line) — this is *correct* refactor-agent reasoning, not an excuse-comment. The deferred body is gated on the shared cotangent-vanishing pile and has a closure path documented in `RigidityKbar.tex`.

### references/challenge.lean
- **outdated comments**: none
- **suspect definitions**: none (intentionally `sorry`)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - This is the **upstream challenge spec** (Christian Merten, "Jacobians in algebraic geometry"), containing the target signatures with `sorry` bodies. Not project source code — read-only reference. All sorries are *intentional* (the challenge is to formalize these). No audit obligations.

## Must-fix-this-iter

(none — no excuse-comments, no weakened-wrong definitions, no parallel APIs, no suspect bodies on substantive claims, no unauthorized axioms.)

## Major

- `Cotangent/GrpObj.lean:637-638` — the iter-143 1-LOC `have hw : (fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom := by rw [(fst G G).w, (snd G G).w]` is **never consumed**. The proof on `sorry` at L663 means `hw` is dead-load; removing the `have` would not change what compiles. This pattern — a derived hypothesis followed only by a `sorry` — is a code smell: it documents intent (Step 3.a of the d_app chase recipe) without making logical progress. Either: (a) wire `hw` through to a partial closure of the goal (the comment block at L639-655 outlines how 3.b/3.c/3.d should consume it via `Adjunction.homEquiv_naturality_right_symm` + `Pushforward.comp_eq`), or (b) revert the `have hw` and keep the chase entirely as documentation until the full step can land. The current state leaves an unused hypothesis as a *progress signal* without code substance — a maintainer reading the file in 3 iterations cannot tell whether `hw` is being relied on by some downstream proof state or is dead.

## Minor

- `Cotangent/GrpObj.lean:602-662` — ~60 LOC of in-Lean comments document the d_app proof strategy. The content is honest deferred-work documentation (concrete Mathlib lemma names, step-by-step recipe), not excuse-comments. But 60 LOC of strategy comments inside a tactic body is heavy by Lean conventions; the same content would normally live in an analogy file (e.g. `analogies/d-app-d-map-recipe-shape.md`, which the comment block already references) with a one-line in-Lean pointer. Re-flag only if the trend continues to grow.
- `Jacobian.lean:275` — style-linter `linter.style.longLine` warning: 101 chars exceeds 100-char limit. One-line fix.
- `Cotangent/GrpObj.lean:745-751` `basechange_along_proj_two_inv_app_isIso` — signature inherits `{n : ℕ}`, `[SmoothOfRelativeDimension n G.hom]`, `[IsProper G.hom]`, `[GeometricallyIrreducible G.hom]` from the parent definition. Whether all four are needed by the eventual closing proof is unclear (the Route (b'2) chart-unfolding chain only obviously needs smoothness for affine-chart existence). Not a defect — preserving the parent's signature is the audit-transparent choice — but a follow-up could potentially drop unused instances once the body lands.

## Excuse-comments (always called out separately)

None found.

The directive's note that prior auditors (`lean-auditor-review140`, `lean-auditor-review142`) re-confirmed the three long docstrings on `Cotangent/GrpObj.lean` `basechange_along_proj_two_inv_derivation`/`basechange_along_proj_two_inv`/`relativeDifferentialsPresheaf_basechange_along_proj_two` as proof-design analysis (NOT excuse-comments) extends cleanly: the iter-143 changes around L602-662 introduce roadmap and strategy documentation, with phrases like "the bespoke nat-trans chase remains as a typed sorry... beyond what fits in this iter's envelope" — a scope-disclosure pattern, not an "it's wrong, will fix later" pattern.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (unused `have hw` at `Cotangent/GrpObj.lean:637-638` — dead-load hypothesis before sorry)
- **minor**: 3 (heavy in-Lean comment block; long-line lint; potentially-redundant instance arguments on new theorem)
- **excuse-comments**: 0

Overall verdict: The iter-143 Wave 2 refactor (extraction of `basechange_along_proj_two_inv_app_isIso` from an embedded `(fun _ => sorry)`) **restores audit transparency** as intended; the iter-143 d_app `have hw` step is **honest deferred-work documentation but mechanically dead** (unused before sorry) and warrants follow-up to either consume it or revert it.
