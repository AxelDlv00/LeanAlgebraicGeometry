# Lean Audit Report

## Slug
review117

## Iteration
117

## Scope
- files audited: 10 (1 umbrella + 9 module files)
- files skipped (per directive): 0
- deleted files acknowledged (not on disk): `Cohomology/BasicOpenCech.lean`, `Modules/Monoidal.lean`, `Picard/{LineBundle,Functor,FunctorAb}.lean`

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none (umbrella `import`s only)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 10 imports, one per surviving module file. `MayerVietorisCover` imports `MayerVietorisCore` transitively, so both umbrella imports together are mildly redundant but harmless (Lean dedupes).

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14–28: file-overview "Status (iteration 073 — Phase E closes by reduction)" narrates a multi-iteration refactor history. Historical narrative, not actively misleading; the body actually matches the description (`((jacobianWitness C).isAlbaneseFor P).ofCurve` etc.). Could be trimmed to ≤3 lines once the witness-based design stabilises.
  - L48–56, L62–68, L82–90: each protected projection introduces four `letI` bindings (`grpObj`, `proper`, `smooth`, `geomIrred`). These are necessary because `IsAlbanese.ofCurve` / `.comp_ofCurve` / `.exists_unique_ofCurve_comp` quantify `[GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]` over the *witness* scheme `(jacobianWitness C).J`, and the witness fields are terms, not instances — `letI` is the correct Lean idiom here.
  - The three surviving declarations carry the exact protected signatures the directive specifies and reduce uniformly to the `JacobianWitness.isAlbaneseFor` projection. No fake content.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: 0 substantive (1 acknowledged inline sorry — directive-noted)
- **dead-end proofs**: none
- **bad practices**: 1 minor (see notes)
- **excuse-comments**: none
- **notes**:
  - L49–52 `relativeDifferentialsPresheaf`: builds the relative-differentials presheaf via Mathlib's `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'` applied to the unit of the inverse-image / direct-image adjunction. Signature and body are well-formed.
  - L58–64 `relativeDifferentialsPresheaf_obj_kaehler`: definitional identity, body `rfl`. Honest.
  - L74–81 `smooth_iff_locally_free_omega`: load-bearing theorem with inline `sorry` body. **Directive-acknowledged** (preserved per protected signature); not re-flagged. The doctring (L66–73) is non-misleading and gives the two-direction proof sketch.
  - L76 uses `AlgebraicGeometry.IsSmoothOfRelativeDimension` which Mathlib lists as deprecated. **Directive-acknowledged**: preserved because the signature is protected.
  - **Minor stylistic observation (L80)**: the conclusion clause `Module.rank (↑R) (↑M) = n` compares a `Cardinal` to `ℕ : Cardinal` via coercion. This is mathematically correct (for a free module of finite rank, the Cardinal `rank` equals `(n : Cardinal)`), but Mathlib's idiomatic Jacobian-criterion theorems usually state finiteness with `Module.finrank R M = n` returning `ℕ` directly. Not wrong, just stylistically heavier. Flag only because consumers will need a `Cardinal`-to-`ℕ` translation step.
  - Surviving declaration count = 3 (matches directive). File trimmed from ~1100 LOC → 83 LOC as directive states.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L39–61: large commented-out "Sketch of the route once Phase A is available" block. The included text `sorry⟩` at L52 is inside a `--` comment line (verified: prefix `--     sorry⟩`), not an active `sorry`. **Directive-acknowledged**.
  - The sketch references "Phase A" infrastructure that the current Cohomology files now provide (`HModule`, `toModuleKSheaf`). It is *historical alternative-route documentation* rather than a TODO. **Minor**: could be deleted now that the chosen route (`Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`, L66–68) is in place.
  - L14–29 file-overview "Status (iteration 011 — `genus` closure scheduled)" narrates the iter-011 close. The narrative is consistent with the body. Could be trimmed.
  - The body of `genus` (L65–68) is the honest definition `dim_k H^1(C, O_C)` via `Module.finrank` of `Scheme.HModule k (Scheme.toModuleKSheaf C) 1`. Coherent.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: 0 substantive (1 acknowledged inline sorry — directive-noted)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L30–38 "Forbidden shortcut (sanity check)" docstring uses the phrase "mathematically wrong" to describe a *counterexample* (the would-be `Jacobian C := 𝟙_ _` shortcut). **Directive-acknowledged**: this is mathematical commentary, not an excuse-comment. The witness-based design that is actually adopted avoids the shortcut precisely as described.
  - L57–64 `IsAlbanese`: universal-property predicate; well-formed `Prop`-valued definition with the standard ∃! shape.
  - L67–84 `IsAlbanese.ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp`: standard `Classical.choose` / `Classical.choose_spec` projection from the existential `IsAlbanese` predicate. Honest.
  - L88–114 `IsAlbanese.unique`: a real proof, ~20 lines, factoring two universal-property witnesses against each other and using the identity-uniqueness clause. No sorries, no shortcuts.
  - L120–126 `geometricallyIrreducible_id_Spec`: small honest 5-line proof.
  - L143–160 `JacobianWitness` structure: 7 fields (`J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor`) packaging the Albanese witness uniformly over choice of pointed marked point. Signatures coherent with consumer (`AbelJacobi.lean`).
  - L176–179 `nonempty_jacobianWitness`: load-bearing existence theorem with inline `sorry` body. **Directive-acknowledged**: this is the *single foundational existence hypothesis* gating Phase E. Docstring (L162–175) honestly states the mathematical content (Albanese variety via symmetric powers / Picard scheme) and acknowledges Mathlib lacks the prerequisites.
  - L184–187 `jacobianWitness`: `Classical.choice (nonempty_jacobianWitness C)`. Standard `Nonempty`-extraction, no spurious axiom.
  - L199–221: `Jacobian C := (jacobianWitness C).J` plus four protected instances `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`, each projecting the corresponding witness field. Signatures match protected list; bodies are honest single projections.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L19–26 status section truthfully describes the closed state.
  - L38–69 long block "Hypothesis correction (iter 003 prover)" — explanatory documentation of why the iter-002 scaffold's point-wise hypothesis was replaced by scheme-level equality on `U` (Frobenius counterexample in char `p`). This is **honest mathematical documentation**, not an excuse-comment: the body actually consumes the strengthened hypothesis correctly.
  - L79–114 `GrpObj.eq_of_eqOnOpen`: closed proof, well-formed; uses `IsProper.toIsSeparated`, `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, `Scheme.PartialMap.Opens.isDominant_ι`, `ext_of_isDominant_of_isSeparated'`. Tactic chain reasonable for the goal.
  - The "unused but kept" hypotheses block (L62–67) is acknowledged in the docstring and forward-compatibility-motivated; not load-bearing.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 50 LOC; single instance `instHasSheafCompose_forget_CommRing_AddCommGrp`. Honest 5-line body via `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`. Status section accurately describes "closed iteration 003".

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 64 LOC, three declarations: `instHasSheafify_Opens_AddCommGrp`, `instHasExt_Sheaf_Opens_AddCommGrp`, `toAbSheaf`. All honestly closed (status text matches: "closed iteration 004").

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0 flagged (verbose-but-accurate)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 934 LOC; large file but every declaration carries a real body, no sorries, no axioms beyond `[propext, Classical.choice, Quot.sound]`. Scans clean.
  - Heavy density of "iter-NNN" docstrings (most decls cite their iteration of origin and a Mathlib mirror line range, e.g. `Mathlib L156–160`). Useful as a build narrative; mildly stale as Mathlib line numbers may drift across bumps. Not actionable now.
  - L417–446 `IsAffineHModuleVanishing` and L457–466 `IsAffineHModuleHomFinite`: `Prop`-valued carrier classes. Each has a docstring noting the producer instance is "queued for iter-041+". For `IsAffineHModuleHomFinite`, L530–543 explicitly acknowledges that the iter-041 carrier "admits no producer instance on a non-trivial proper curve — dead scaffolding" and that the wholespace `IsHModuleHomFinite` class (L544–549, *with* a producer at L765–778) is what downstream chains actually use. **Coherent — the "dead scaffolding" comment is documenting a corrected design choice, not an admission of present-day broken code.**
  - L546–778 chain `IsHModuleHomFinite` carrier + Stein-via-`finite_appTop_of_universallyClosed` + `constantSheafΓAdj.homLinearEquiv` + `homFromOne_linearEquiv` + producer instance `instIsHModuleHomFinite_toModuleKSheaf` — every step has an honest body.
  - L867–933 `IsCechAcyclicCover` class + `subsingleton_HModule'_supr_of_isCechAcyclicCover` consumer. Class is `Prop`-valued, consumer is closed.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 628 LOC. Header (L9–25) lists the file's contents and references the sibling split `MayerVietorisCover.lean`. **No stale references to deleted `BasicOpenCech.lean` survive in this header** — verified by `Grep`. (Mentioned by directive as a focus area.)
  - L60–73 `Abelian.Ext.chgUniv_add` and L79–91 `chgUniv_smul`: project-local Mathlib gap-fills; each has an honest tactic body.
  - L101–110 `Abelian.Ext.chgUnivLinearEquiv`: the LinearEquiv upgrade. Structure literal, no sorries.
  - L128–625 `HModule'_*` chain: every decl mirrors a specific Mathlib `MayerVietorisSquare.*` declaration with `AddCommGrpCat.free → ModuleCat.free k`; bodies honest.
  - Two `set_option backward.isDefEq.respectTransparency false in` attributes on L354 and L523/L539/L565 — these are scoped, well-documented as required for typeclass-search behaviour at structure-literal projections, and standard idiom in Mathlib's own `MayerVietorisSquare.lean`.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 712 LOC. Header (L9–27) lists the file's contents and references the sibling split `MayerVietorisCore.lean`. **No stale references to deleted `BasicOpenCech.lean` survive in this header** — verified by `Grep`. (Mentioned by directive as a focus area.)
  - L50–62 `AffineCoverMVSquare` structure with six fields (two opens, three affineness witnesses, one cover-totality). Coherent.
  - L71–151 conversion to `MayerVietorisSquare` + four `@[simp]` corner identifications + sequence/exactness specialisations. All honestly closed.
  - L173–192, L215–240, L264–288, L300–308 `HModule'_top_sourceIso` / `HModule_top_linearEquiv` / `HModule'_top_linearEquiv` / `HModule'_eq_HModule_linearEquiv`: the universe-bridge chain. Each has a real, well-structured body using Mathlib's `precompOfLinear`, `mk₀_comp_mk₀`, `chgUnivLinearEquiv`, etc.
  - L490–505 `HasCechToHModuleIso` class + L506–514 `cechToHModuleIso` extractor: extractor uses `Classical.choice` on a `Nonempty` field. Standard, no new axiom.
  - L675–710 `HasAffineCechAcyclicCover` class + `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` consumer instance. The producer instance for `HasAffineCechAcyclicCover (Scheme.toModuleKSheaf C)` is not present anywhere in the project — but the class is `Prop`-valued and *no consumer of `IsAffineHModuleVanishing` is required by Phase A's currently-closed declarations* (the genus carrier currently routes via the wholespace H⁰ side `instIsHModuleHomFinite_toModuleKSheaf` only, which is independently closed). So this is **scaffolding pending iter-054+ producer**, not broken code today.

## Must-fix-this-iter

(None.) The two extant sorries (`Differentials.lean:81` and `Jacobian.lean:179`) are both directive-acknowledged as known/by-design and are NOT re-flagged here per the directive's "Known issues" exclusion. The auditor confirms they sit on the load-bearing declarations the directive names (`smooth_iff_locally_free_omega`, `nonempty_jacobianWitness`) and that the documentation around them is honest about their deferred status. No new must-fix findings.

## Major

(None.)

## Minor

- `AlgebraicJacobian/Differentials.lean:80` — conclusion `Module.rank (↑R) (↑M) = n` mixes `Cardinal` with `ℕ` via coercion. Mathematically correct but stylistically heavier than the idiomatic `Module.finrank R M = n`. Worth considering once the proof body is filled and the natural consumer's preferred shape is known. Body is sorry; statement otherwise reasonable.
- `AlgebraicJacobian/Genus.lean:39-61` — the large commented-out "Sketch of the route once Phase A is available" block predates the current `genus` body (which is closed at L65–68 using Phase A infrastructure). The sketch documents a *different alternative route* via `OXAsAddCommGrpSheaf` / `H1OC` which the project did not in the end take. Now historical; could be removed to reduce file noise.
- `AlgebraicJacobian/AbelJacobi.lean:14–28`, `Genus.lean:14–29`, `Jacobian.lean:14–28`, `Rigidity.lean:19–26` — each file's "Status (iteration NNN — …)" block is verbose. The content is accurate but per-iteration narrative drifts in usefulness as the iteration counter advances (we're at iter-117). Routine cleanup candidate.
- `AlgebraicJacobian.lean` umbrella imports both `MayerVietorisCore` and `MayerVietorisCover` even though Cover transitively imports Core. Harmless; Lean dedupes.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` and `MayerVietorisCover.lean` — many docstrings cite Mathlib mirror line ranges (e.g. "Mathlib L156–160", "L48–64"). These will silently drift across Mathlib bumps. Useful today, but consider relying on declaration names rather than line numbers.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:535,609,615` — `IsAffineHModuleHomFinite` is described in `StructureSheafModuleK.lean:530-543` as "dead scaffolding" (no producer can exist). The class and its consumer are still on disk; the producer that fires `IsAffineHModuleVanishing` via `HasAffineCechAcyclicCover` (L699–710) is also present without a producer. The status documentation is honest, and the scaffolding does not contradict the codebase — but if the chosen route never lands these producers, the unused classes are cleanup candidates for a future trim.

## Excuse-comments (always called out separately)

(None.) Verified by negative grep for `TODO`, `FIXME`, `HACK`, `placeholder`, `temporary`, `will fix`, `stand-in`, `wrong but works` over `AlgebraicJacobian/**/*.lean` — zero matches. The two acknowledged sorries (`Differentials.lean:81`, `Jacobian.lean:179`) are gated by *honest* docstrings that name the missing infrastructure (Jacobian criterion / Albanese construction respectively) rather than promise a near-term fix.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: the iter-117 trim left the surviving Lean coherent — all 10 files parse as honest mathematics with two directive-acknowledged sorries on `smooth_iff_locally_free_omega` and `nonempty_jacobianWitness`, no excuse-comments, no axioms beyond the standard kernel set, and no stale references to the deleted Picard / Monoidal / BasicOpenCech files.
