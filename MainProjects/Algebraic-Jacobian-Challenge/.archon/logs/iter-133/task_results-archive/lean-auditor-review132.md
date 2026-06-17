# Lean Audit Report

## Slug
review132

## Iteration
132

## Scope
- files audited: 13
- files skipped (per directive): 0

Audited files:

- `AlgebraicJacobian.lean`
- `AlgebraicJacobian/AbelJacobi.lean`
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- `AlgebraicJacobian/Cohomology/SheafCompose.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- `AlgebraicJacobian/Cotangent/GrpObj.lean`
- `AlgebraicJacobian/Differentials.lean`
- `AlgebraicJacobian/Genus.lean`
- `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicJacobian/Rigidity.lean`
- `AlgebraicJacobian/RigidityKbar.lean`

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `## Status (iteration 073 — Phase E closes by reduction)` (line 14): still factually accurate; the three protected declarations project from `(jacobianWitness C).isAlbaneseFor P` as described.
  - `letI := (jacobianWitness C).grpObj` / `proper` / `smooth` / `geomIrred` chains in `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` (lines 52–55, 64–67, 86–89) are the explicit elaboration scaffolding that the project pattern requires; not anti-pattern.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `private lemma Abelian.Ext.chgUniv_add` / `chgUniv_smul` (lines 60, 79) under the `Abelian.Ext` namespace: declaring private gap-fill lemmas inside an external (Mathlib) namespace is mildly unconventional but justified by the wrapper-cohort comment block on lines 33–51; not a defect.
  - `set_option backward.isDefEq.respectTransparency false in` at lines 354, 523, 539, 565 is load-bearing for the iter-019/020/023 LES proofs (the file explains why); accepted pattern.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0 (forward-looking "iter-054+ producer" references at lines 666–669, 696–698 remain factually accurate — the project is at iter-132 but the producer instance for `HasAffineCechAcyclicCover (Scheme.toModuleKSheaf C)` is still not in tree; "iter-054+" is "after iter-054", which is satisfied)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - The `HasAffineCechAcyclicCover` class (line 675) is a scaffolding carrier with no producer instance yet supplied for the structure sheaf; the iter-053 producer `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (line 699) consumes it. This means the entire Phase-A Module.Finite chain on `HModule k (toModuleKSheaf C) 1` remains gated on a single unresolved producer. The state is documented honestly inline; not a defect of this file per se.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Iter-046 Mathlib gap-fill helpers `Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv` (lines 64–113) declared inside `namespace CategoryTheory` look like reasonable mathlib-bound infrastructure and not parallel APIs of an existing mathlib decl (mirror of `left_adjoint_additive`).
  - The "abandoned iter-041 per-affine-open variant" note on lines 463–486 is a useful historical audit annotation, not an excuse-comment — it documents a *removed* construction, not a suspect surviving one.
  - `set_option backward.isDefEq.respectTransparency false in` not used in this file (only `backward.isDefEq.respectTransparency false` appears in MV files).
  - `instIsHModuleHomFinite_toModuleKSheaf` (line 708) is fully closed and uses the iter-045/046 LinearEquiv chain; substantive proof, no `sorry`.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 4 (file-level header, `## Status` block, `cotangentSpaceAtIdentity` declaration docstring — all four sites assert the iter-132 rank lemma lives "in a follow-up declaration / not in this file", but it is at line 244 of this same file)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0 (the `Classical.choose`-chain `let`-binding pattern is the project's explicit body-shape choice per directive)
- **excuse-comments**: 0
- **notes**:
  - Line 28–30 (file-level header): "The companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (rank = relative dimension `n` from `[SmoothOfRelativeDimension n G.hom]`) is deferred to iter-132+ for blueprint-RHS-pinning work; not in this file." — **STALE**: the named theorem is at line 244 of the very same file.
  - Line 32 ("`## Status (iter-131 fix-up: pure-term body refactor)`") and the prose at lines 53–57 ("The companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` lives in a follow-up declaration (not in this file); the iter-131 body shape is the testable deliverable witnessed by `cotangentSpaceAtIdentity_eq_extendScalars` below.") — **STALE**: the status block frames the file as the iter-131 closure of *only* `cotangentSpaceAtIdentity` (+ the `_eq_extendScalars` defensive lemma); it does not mention that iter-132 has added the rank theorem to this same file.
  - Line 96–99 (`cotangentSpaceAtIdentity` declaration docstring): "the iter-132+ companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (in a follow-up declaration) pins the rank to `n`" — **STALE**: the parenthetical "in a follow-up declaration" is false post-iter-132; it now lives directly below at line 244.
  - Line 136–138 (`cotangentSpaceAtIdentity` docstring continuation): "This is formalized as `cotangentSpaceAtIdentity_eq_extendScalars` below, which the iter-132+ rank lemma can rewrite against." — **STALE wording**: the rank lemma now exists and is in this file; the future-tense "can rewrite against" should be past tense (it does, at line 279).
  - Line 144–148 (`cotangentSpaceAtIdentity` docstring footer): "The structural properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are content for the iter-132+ rank lemma `cotangentSpaceAtIdentity_finrank_eq`; the structural-shape accessibility needed by that lemma is witnessed here by `cotangentSpaceAtIdentity_eq_extendScalars`." — **STALE in scope**: `rank = n` is now closed by `cotangentSpaceAtIdentity_finrank_eq` (line 244); `Module.Free k` and `Module.Finite k` are not yet bundled (could be follow-ups). The current text implies all three are still future work.
  - Minor: `set U : (Spec (.of k)).Opens := h.choose with hU_def` (line 252) and the parallel `set V := ... with hV_def`, `set e := ... with he_def` (lines 253–254) bind hypothesis names `hU_def`, `hV_def`, `he_def` that are never consumed in the proof body. The `with` clauses could be dropped, or `let` could be used instead. (Style nit, not a defect.)
  - The `cotangentSpaceAtIdentity_finrank_eq` proof body (lines 244–282) reproduces the body's `Classical.choose`-chain — this is the directive's flagged `show → change` edit, used at line 276 (`change Module.finrank k (TensorProduct ...) = n`). The `change` correctly exposes the underlying tensor-product carrier; the proof closes via `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `smooth_locally_free_omega` docstring (lines 119–123) honestly discloses that the *reverse* direction of the Jacobian criterion is mathematically false without deformation-theoretic input; this is a useful audit annotation, not an excuse-comment (it documents what the lemma does *not* prove, with a concrete counterexample reference).
  - The proof of `kaehler_quotient_localization_iso` (lines 86–109) constructs a `LinearEquiv` via `LinearEquiv.ofBijective`; the body is substantive and `noncomputable` (which is correct because of the `Classical.choose`/`Subsingleton.elim` chain).
  - The `first | ... | ...` tactic in `smooth_locally_free_omega` (lines 140–142) inside the `refine` per-branch tactic is unusual but correct — both cases (free, rank) are closed by the same algebraize'd `Algebra.IsStandardSmooth*` lemmas.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - The `## Status (closed iteration 011 — `genus`)` block accurately describes the current body (`Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 0 (the two intentional `sorry`s have docstrings explicitly framing them as scaffolds gated on M2/M3; per directive these are tracked, not red flags)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `genusZeroWitness` (line 188) — body `sorry` (line 192). The docstring is honest about iter-127 scaffold status. Directive-marked known issue.
  - `nonempty_jacobianWitness` (line 210) — body `sorry` (line 213). The docstring is honest about M2+M3 gating. Directive-marked known issue.
  - `IsAlbanese.unique` proof (line 107–128) is substantive and complete.
  - The "Forbidden shortcut (sanity check)" block (lines 44–52) is a useful prophylactic audit comment guarding against the wrong-by-genus terminal-object definition.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - The `## Hypothesis history` block (lines 44–79) documents the iter-003 strengthening (point-wise → scheme-level) with a concrete counterexample (Frobenius on an elliptic curve in characteristic `p`) and the iter-125 unused-hypothesis cleanup. These are useful audit annotations, not excuse-comments.
  - The proof of `Scheme.Over.ext_of_eqOnOpen` (lines 99–121) is structured into four numbered steps; each consumes a concrete Mathlib lemma or instance derivation. No `sorry`.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 0 (the docstring honestly frames the `sorry` as an iter-126 scaffold gated on the cotangent-vanishing pile; per directive this is tracked)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `rigidity_over_kbar` (line 75) — body `sorry` (line 87). Directive-marked known issue.
  - The "Encoding choice (iter-126 refactor agent note)" block (lines 31–46) honestly discloses that the literal Option A encoding (`Spec(MvPolynomial σ kbar)`) would be *mathematically wrong* (affine, not projective line) and explains the choice of abstract Option B (genus-0 characterisation). This is a useful audit annotation, not an excuse-comment.
  - Unused-but-bound underscored hypotheses `_hgenus`, `_hf` (lines 80, 85) are appropriate scaffolding placeholders for a `sorry`-bodied theorem.

## Must-fix-this-iter

None.

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:28–30` — File-level docstring asserts `cotangentSpaceAtIdentity_finrank_eq` is "deferred to iter-132+ ... not in this file"; theorem is now at line 244 of this same file. Misleading prose.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:32–57` — The `## Status (iter-131 fix-up: pure-term body refactor)` block frames the file's current state as iter-131's closure with only the body refactor and `_eq_extendScalars` defensive lemma; the iter-132 addition of the rank theorem (line 244) is not mentioned and is in fact contradicted ("lives in a follow-up declaration (not in this file)").
- `AlgebraicJacobian/Cotangent/GrpObj.lean:96–99` — `cotangentSpaceAtIdentity` declaration docstring parenthetical "(in a follow-up declaration)" is now false.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:136–138` — `cotangentSpaceAtIdentity` declaration docstring future-tense "the iter-132+ rank lemma can rewrite against" should be past tense; the rank lemma exists and does rewrite at line 279.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:144–148` — `cotangentSpaceAtIdentity` declaration docstring footer lumps `rank = n` together with `Module.Free k` / `Module.Finite k` as content "for the iter-132+ rank lemma"; the `rank = n` half is now closed in this file at line 244. The Free/Finite halves remain genuinely future work — but the prose conflates them.

## Minor

- `AlgebraicJacobian/Cotangent/GrpObj.lean:252–254` — `set U := ... with hU_def`, `set V := ... with hV_def`, `set e := ... with he_def` introduce hypothesis names that are never consumed in the proof body of `cotangentSpaceAtIdentity_finrank_eq`. The `with` clauses could be dropped, or `let` used instead. Style nit; the proof is correct.

## Excuse-comments (always called out separately)

None found. The five "stale framing" findings in `Cotangent/GrpObj.lean` are *not* excuse-comments — they are docstring claims rendered inaccurate by the iter-132 addition that landed in the same file, not author admissions that the code is wrong. The remaining files contain no `TODO replace`, `placeholder`, `temporary`, `wrong but works`, or `will fix later` markers (verified via grep).

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 — all five are stale-framing findings in `AlgebraicJacobian/Cotangent/GrpObj.lean` docstrings, caused by the iter-132 addition of `cotangentSpaceAtIdentity_finrank_eq` to a file whose narrative was written assuming the rank lemma would live elsewhere.
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: The Lean compiles cleanly with three intentional, directive-acknowledged sorries; the only audit-actionable findings are five stale-narrative claims in `Cotangent/GrpObj.lean` that the iter-132 prover lane did not update after adding the rank theorem in-file.
