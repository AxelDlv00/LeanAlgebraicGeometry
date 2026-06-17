# Lean Audit Report

## Slug
review123

## Iteration
123

## Scope
- files audited: 9 (`.lean` files under `AlgebraicJacobian/`, including 5 in `Cohomology/`).
- files skipped (per directive): 0.

Files:

1. `AlgebraicJacobian/AbelJacobi.lean` (95 LOC)
2. `AlgebraicJacobian/Differentials.lean` (537 LOC)
3. `AlgebraicJacobian/Genus.lean` (71 LOC)
4. `AlgebraicJacobian/Jacobian.lean` (226 LOC)
5. `AlgebraicJacobian/Rigidity.lean` (117 LOC)
6. `AlgebraicJacobian/Cohomology/SheafCompose.lean` (50 LOC)
7. `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (64 LOC)
8. `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (934 LOC)
9. `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` (627 LOC)
10. `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (711 LOC)

(Total 10 files — `Cohomology/` had five rather than the four implied by the scope-list. All read.)

Sorries (project-wide, confirmed by grep):
- `Differentials.lean:362` — inside `appLE_isLocalization` (M1.b bridge milestone). Disclosed in directive.
- `Jacobian.lean:179` — `nonempty_jacobianWitness`. Disclosed in directive.

## Per-file checklist

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14–29 status block tagged "iteration 073 — Phase E closes by reduction" is historical iter-073 framing. The current state still matches what the block describes, but the iter tag is now ~50 iters stale.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 2 flagged (within the residual-sorry block)
- **bad practices**: 2 flagged
- **excuse-comments**: 0 (the two long TODO comments are roadmap content, not excuse-style)
- **notes**:
  - L105–110 — `@[reducible] noncomputable def appLE_colimAlgebra` is the project's reducible algebra-instance gateway. `@[reducible]` on an `Algebra`-valued `def` forces typeclass synthesis to unfold the body. The conventional alternative is to install via `letI := (appLE_colimRingHom f e).hom.toAlgebra` inline at use sites; the file currently does both (L168 / L184 / L287 / L304 / L459 all carry an additional `letI := appLE_colimAlgebra f e` even though the reducible def should already let synthesis find the structure). The duplication suggests `@[reducible]` is not actually load-bearing — either it is and the `letI` lines are redundant scaffolding, or it isn't and the attribute is unnecessary. Worth confirming and tightening either way.
  - L239 — `erw [hmc]` where `hmc` is just `Functor.map_comp`. `erw` is a code smell; if `rw` actually fails here the reason should be diagnosed (likely an `Opposite` unfolding gap), not papered over with `erw`. The surrounding L228–247 block also uses three `change` rewrites of fully unfolded compositions, which is brittle.
  - L302–305 — Inside `appLE_isLocalization`, `letI : Algebra ... := appLE_colimAlgebra f e` is re-installed on the body after already being installed in the statement's `letI`. With `appLE_colimAlgebra` reducible this should not be necessary; with it non-reducible the statement-side `letI` would not propagate. Either way the duplication is awkward.
  - L305 — `set M := appLE_unitSubmonoid f hU hV e with hM_def` — `hM_def` is never used. Bare `set M := …` would suffice.
  - L308–321 — `h_unit_ring`, `let forward`, `h_fwd_comp` are constructed but immediately stranded: the `suffices AE` jumps to the AlgEquiv obligation and the residual body is `sorry`. They are *staged* scaffolding for the unwritten backward construction (commented out at L350–357), so the unused-binding warning is benign — but it is also currently dead. When the sorry lands, these should be consumed; until then they are tutorial code.
  - L332–361 — Long expository comment + commented-out 8-line assembly recipe ("let RE : Localization M ≃+* A_colim := …") inside the body. Not an excuse-comment per the strict rubric (it documents a substantive next-step proof, not an admission of wrong content), but it is a multi-line dead-code block.
  - L78–80 — `def appLE_unitSubmonoid` takes `(_hU : IsAffineOpen U) (_hV : IsAffineOpen V)`. The carrier (units in `Γ(X,V)` under `appLE`) does not depend on affineness; the underscored args are placeholders for downstream uniformity with `appLE_isLocalization`. The convention is documented but it does mean the unit-submonoid definition is artificially over-typed.
  - L488–534 `smooth_locally_free_omega` — documentation honestly discloses that the reverse direction is mathematically false without deformation input, and the proof only attempts the forward direction. Positive note, no issue.
  - L362 `sorry` — disclosed; substantive comment at L322–361 gives the construction roadmap. The body before the sorry installs `forward`, `h_unit_ring`, `h_fwd_comp`, then reduces to `AE : Localization M ≃ₐ[Γ(S,U)] A_colim`.
  - L208–247 (the `hcompat` block inside `isUnit_appLE_unitSubmonoid_in_colim`) uses `change`, `erw`, `change`, `rw`, … in close sequence. The proof closes but is brittle to surface-syntax changes; consider refactoring to `simp only [Functor.map_comp]` + a single naturality `rw`.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (commented-out sketch block)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L39–61 — Large commented-out "Sketch of the route once Phase A is available" block (`OXAsAddCommGrpSheaf`, `H1OC`, with a `sorry` inside the comment at L52). Phase A *is* available now (per `Cohomology/StructureSheafAb.lean` status "closed iteration 004" and the working `Scheme.HModule` machinery used by the actual `genus` body L68). The sketch is historical, references a route that was not the one taken, and should be deleted.
  - L15–29 — Status block headed "## Status (iteration 011 — `genus` closure scheduled)". The closure has landed (L65–68); "scheduled" is stale. Either retitle to past-tense or strip the iter-block.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (`nonempty_jacobianWitness`, disclosed)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L162–179 `nonempty_jacobianWitness := sorry` — disclosed in directive. The docstring honestly states this is the single deferred mathematical sorry of the Phase-C scaffolding and explains why both routes (symmetric-powers / Picard scheme) require Mathlib infrastructure not yet available. Not an excuse-comment; an authorized hypothesis.
  - L30–38 "Forbidden shortcut (sanity check)" section explicitly forbids `Jacobian C := 𝟙_ ...` as a degenerate definition and explains why. Positive note — this is the right kind of guardrail.
  - L86–114 `IsAlbanese.unique` — the proof builds intermediate witnesses via uniqueness, computes `g ≫ h = 𝟙` and `h ≫ g = 𝟙`, but the final `refine ⟨g, hg_eq, fun g' hg' => hg_unique g' hg'⟩` produces an `∃!`-style witness and does NOT use `hgh`/`hhg` (the inverse identities). These two `have`s (L104, L113) are computed but unused. Mild dead-binding; harmless but extractable.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L38–69 — "Hypothesis correction (iter 003 prover)" block explicitly documents that the original point-wise topological hypothesis was mathematically wrong and was strengthened to scheme-level equality. This is good error-disclosure (a Frobenius counterexample is named) and not an excuse-comment.
  - L62–67 — Documents that several typeclass hypotheses (`[GrpObj X]`, `[GrpObj Y]`, `[SmoothOfRelativeDimension n X.hom]`, `[SmoothOfRelativeDimension m Y.hom]`, `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]`) are "now redundant with the strengthened hypothesis" but kept for forward-compatibility. Six unused class hypotheses on a load-bearing rigidity lemma is a smell — they impose proof obligations at every call site for no payoff. If forward-compat is the only reason, leave a single comment and remove them; if they may be tightened later, drop them and add back when the time comes.
  - L73–114 — The proof of `GrpObj.eq_of_eqOnOpen` is direct: separated + irreducible + dense-open-immersion → dominant, then `ext_of_isDominant_of_isSeparated'`. Clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Five-line file, single closed instance. No findings.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L34–37 — `instHasSheafify_Opens_AddCommGrp` body is `inferInstance`. This is a one-line passthrough that simply pins universes (per L26–32 comment); fine.
  - L43–47 — `instHasExt_Sheaf_Opens_AddCommGrp` is a `noncomputable instance` with body `CategoryTheory.HasExt.standard _`. Two `noncomputable instance`s on `HasExt` (here + the parallel in `StructureSheafModuleK.lean` L119) both invoke `HasExt.standard`. Standard-derived-category Ext is fine for an instance; no concern.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 3 flagged (consumers of the dead `IsAffineHModuleHomFinite` class)
- **bad practices**: 1 flagged
- **excuse-comments**: 1 flagged (substantive; see flag below)
- **notes**:
  - L17–35 — File-level status block is framed as "Phase A step 5". The file has since grown to 934 LOC covering iter-038 through iter-053 (Module.Finite ladder, IsCechAcyclicCover carrier, Čech-vs-derived comparison-iso class, HasAffineCechAcyclicCover producer). The "Phase A step 5" framing dramatically undersells the file's current scope; the iter-NNN section-headers function as historical landmarks rather than module organization.
  - **L518–543** — `IsAffineHModuleHomFinite` class. The docstring of `IsHModuleHomFinite` (L518–543) explicitly disowns the iter-041 carrier: *"On a proper smooth $k$-curve $C$ with $F = O_C$, $\Gamma(U, O_C)$ is NOT finite over $k$ for $U$ a proper affine open … The iter-041 class therefore admits no producer instance on a non-trivial proper curve — **dead scaffolding**."* This is an explicit author-acknowledged dead class. Yet:
    - L458–466 still defines `class IsAffineHModuleHomFinite`.
    - L476–487 still defines its immediate consumer `module_finite_HModule'_zero_of_isAffineHModuleHomFinite`.
    - L497–507 still defines the combined consumer `module_finite_HModule'_of_affine` that takes `[IsAffineHModuleHomFinite]` as an instance argument.
    - L512–519 still defines the curve specialisation `module_finite_HModule'_of_affine_curve`.
    Because these are all *consumers* parameterised by the dead class, they will never fire (no producer instance can be supplied without contradicting the cited counterexample on ℙ¹). They are *load-bearing in the wrong direction* — they sit in the import surface and clutter typeclass search but cannot be satisfied. **Strongly recommend deleting all four declarations** and noting in the file header that the H>0 affine carrier (iter-040 `IsAffineHModuleVanishing`) is the only surviving affine route, while H⁰ goes through the wholespace `IsHModuleHomFinite` (iter-043) per the iter-046 producer instance.
  - L43–101 — `Functor.const_additive`, `Functor.const_linear`, `left_adjoint_linear`, `right_adjoint_linear`, `homLinearEquiv` are five "iter-046 Mathlib gap-fill" declarations sitting at top level under `CategoryTheory`. Reasonable as project-local lifts of standard adjunction-linearity machinery. If they upstream, they should move; until then they belong here.
  - L295–301 — `HModule'` is a `noncomputable abbrev` whose body involves `(yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj X`. The same hideous expression recurs (with the explicit `(Functor.whiskeringRight _ _ _)` cast) at L362, L404, L466, L485, L497, L532, L548, L601, L631. Consider extracting a `private abbrev` for `yoneda.obj X ⋙ ModuleCat.free k` to reduce repetition; not blocking.
  - L765–777 `instIsHModuleHomFinite_toModuleKSheaf` — closed instance via the iter-044 → iter-045 → iter-046 chain. The four-step routing is well-documented and the body is a clean composition.
  - L879–933 `IsCechAcyclicCover` class + consumers — `Prop`-valued carrier with a `Subsingleton`-on-positive-degrees field, then an explicit comparison-iso argument to the consumer. Reasonable decoupling between the combinatorial vanishing and the substantive comparison theorem; producers are queued for iter-051+.
  - **Excuse-comment flag**: L538 "dead scaffolding" is itself an author admission. The directive's strict reading places admissions like *"this iteration's carrier therefore admits no producer instance — dead scaffolding"* in the excuse-comment bucket (the class and its consumers are wrong content kept alive by commentary). Critical severity is appropriate for the **class + three consumers** taken together, as the declarations remain in the file and are visible to typeclass search.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (`set_option backward.isDefEq.respectTransparency false`)
- **excuse-comments**: none
- **notes**:
  - L354, L523, L539, L565 — four uses of `set_option backward.isDefEq.respectTransparency false in`. This is the same option Mathlib's upstream `MayerVietoris.lean` uses at the same lemma positions (acknowledged in inline comments). Acceptable when mirroring upstream patterns; flag because the option is a deep defeq-search override and should not propagate beyond direct Mayer-Vietoris LES lemmas.
  - L60–110 — Three `Abelian.Ext.chgUniv_*` gap-fill lemmas + the `chgUnivLinearEquiv` upgrade. Marked `private` for `_add` and `_smul`; `chgUnivLinearEquiv` is public (used by `MayerVietorisCover.lean` iter-034 bridge). Clean.
  - L127–625 — Long sequence of "iter-016 → iter-026" MV-LES building blocks, each `noncomputable def`/`lemma` mirroring an upstream Mathlib declaration with `AddCommGrpCat.free → ModuleCat.free k`. The docstrings record the Mathlib line numbers being mirrored, which is useful for upstream-tracking. No findings; the file is well-organized.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (unused fields on `AffineCoverMVSquare`)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged (the iter-053 "asserted not constructed" framing)
- **notes**:
  - L50–62 — `AffineCoverMVSquare` carries three affineness fields: `isAffineOpen_U₁`, `isAffineOpen_U₂`, `isAffineOpen_inf`. Grep confirms they are **never read anywhere in the project** (their only occurrences are the structure's own field declarations). Only `cover` (the totality field) is consumed (by L101 `toMayerVietorisSquare_toSquare_X₄`). The structure name promises affineness; the structure does not propagate affineness anywhere. Either downstream consumers need to start using these fields (the docstring at L48 says affineness will support "Serre-finiteness use") or they should be dropped from the structure until needed. As-is, three of the four substantive fields are decorative.
  - L504–505 — Comment in `cechToHModuleIso` docstring claims *"no new axiom introduced … already in the kernel-only axiom set [propext, Classical.choice, Quot.sound] since iter-048."* This framing implies project-wide axiom hygiene at the listed three axioms, but the project transitively contains `sorryAx` via `Jacobian.lean:179` and `Differentials.lean:362`. The "no new axiom" claim is locally true for this declaration but the surrounding comment risks misleading readers about the project as a whole.
  - L658–682 — `HasAffineCechAcyclicCover` is a `Prop`-valued class whose single field `exists_cover` asserts the existence of a Čech-acyclic cover on every affine open. The iter-053 docstring explicitly states *"the existence is asserted, not constructed. The substantive iter-054+ work will instantiate"*. This is a hypothesis-mode sorry: as long as no producer instance lands, the iter-053 consumer (L699–710 `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`) never fires. Acceptable as a design pattern *iff* the producer instance is genuinely scheduled; the directive should treat the class itself as load-bearing for milestone H>0 affine vanishing.
  - L155–192 `HModule'_top_sourceIso` — three-step natural iso (terminal-collapse of the representable + const-comp + finsupp-unique). Correctly assembled; the universe choice of `PUnit.{u+1}` on L190 is load-bearing.
  - L243–308 `HModule'_top_linearEquiv` + `HModule'_eq_HModule_linearEquiv` — universe bridge `Ext.{u} → Ext.{u+1}` via the iter-034 gap-fill. Hypotheses `[HasExt.{u}]` and `[HasExt.{u+1}]` carried in parallel. Reasonable.

## Must-fix-this-iter

Per directive's strict rubric, the following warrant blocking attention. Both known-disclosed sorries (`Jacobian.lean:179`, `Differentials.lean:362`) are excluded from this list as they are tracked under the iter-122/123 prover trajectory; everything else lands here on its merits.

- `Cohomology/StructureSheafModuleK.lean:458–466` — Class `IsAffineHModuleHomFinite` retained despite the author's own L530–538 disclosure that it is "dead scaffolding" with no possible producer instance on a non-trivial proper curve. Why must-fix: the class plus three downstream consumers (L476–487, L497–507, L512–519) carry an unsatisfiable hypothesis through typeclass search; they should be deleted, not left as historical scaffold.
- `Cohomology/MayerVietorisCover.lean:50–62` — `AffineCoverMVSquare.isAffineOpen_U₁`, `isAffineOpen_U₂`, `isAffineOpen_inf` are declared but read by zero consumers in the project. Why must-fix: the structure's name and docstring promise affineness propagation; the implementation does not honor that promise. Either start using the fields downstream or drop them from the structure (and rename / re-doc accordingly).
- `Genus.lean:39–61` — Large commented-out "OXAsAddCommGrpSheaf / H1OC" sketch with an internal `sorry`. Why must-fix: Phase A is closed and the sketch describes a route the project did not take. Stale dead-code in the production file.
- `Differentials.lean:239` — `erw [hmc]` for `hmc := Functor.map_comp`. Why must-fix: `erw` is a defeq-stretching code smell, and the surrounding `change`-heavy proof block (L228–247) is brittle. If `rw` genuinely fails, the underlying mismatch (likely op-comp normalization) should be fixed at the source; if `rw` works, the `erw` is gratuitous.

## Major

- `Differentials.lean:105–110` — `@[reducible] noncomputable def appLE_colimAlgebra` plus redundant `letI := appLE_colimAlgebra f e` re-installs at L168, L184, L287, L304, L459. Either the attribute is load-bearing (drop the redundant `letI` lines) or it is not (drop the attribute). The duplication suggests neither author nor consumer is sure which it is.
- `Differentials.lean:308–321` — `h_unit_ring`, `let forward`, `have h_fwd_comp` are computed but stranded by the immediately-following `sorry` at L362. They are scaffolding for the unwritten backward construction; while not actively wrong, they signal pre-built dead bindings whose consumers don't exist yet.
- `Differentials.lean:332–361` — Multi-line commented-out assembly recipe inside the body, ending in `sorry`. Roadmap-level TODO with code shape (8 lines of executable-looking Lean inside a comment). Should be moved to a project blueprint chapter or a private-to-Lean comment outside the function body.
- `Rigidity.lean:62–67` — Six unused typeclass hypotheses on `GrpObj.eq_of_eqOnOpen` kept for "forward-compatibility with the informal Mumford statement". Each one is an obligation at every call site. Either drop them now or drop them when the symmetric form actually lands; do not keep them indefinitely on faith.
- `Cohomology/MayerVietorisCover.lean:658–710` — `HasAffineCechAcyclicCover` carrier + the conditional producer. Reasonable design but currently equivalent to a hypothesis-mode sorry on the entire H>0 affine vanishing chain.
- `Cohomology/StructureSheafModuleK.lean:17–35` — File-level status block frames the file as "Phase A step 5" while the file actually covers iter-038 through iter-053. Should be retitled or expanded.

## Minor

- `AbelJacobi.lean:14–29` — "Status (iteration 073 — Phase E closes by reduction)" — historical iter-073 framing, current state still matches but the tag is stale.
- `Genus.lean:15–29` — "Status (iteration 011 — `genus` closure scheduled)" — the closure has landed; "scheduled" no longer applies.
- `Differentials.lean:78–80` — `_hU`, `_hV` underscored unused parameters on `appLE_unitSubmonoid`. Carrier doesn't depend on affineness; over-typed for downstream uniformity.
- `Differentials.lean:305` — `set M := … with hM_def` where `hM_def` is unused.
- `Jacobian.lean:86–114` — `IsAlbanese.unique` builds `hgh` (L104) and `hhg` (L113) inverse-identity witnesses but does not consume them in the final `refine ⟨g, hg_eq, fun g' hg' => hg_unique g' hg'⟩`. Two dead `have` bindings.
- `Cohomology/MayerVietorisCover.lean:504–505` — "no new axiom introduced" framing in `cechToHModuleIso` docstring risks misleading readers about project-wide axiom status.
- `Cohomology/MayerVietorisCore.lean:354,523,539,565` — `set_option backward.isDefEq.respectTransparency false in` four times. Mirrors upstream Mathlib at the same lemma positions; tolerable.
- `Cohomology/StructureSheafModuleK.lean:295–301` and recurring — `(yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k))` appears verbatim ~10 times throughout the file. Candidate for a private abbrev.

## Excuse-comments (always called out separately)

By the strict definition of the audit rubric (`-- TODO replace with real def`, `-- placeholder`, `-- temporary`, `-- wrong but works`, `-- will fix later`), no comments in the project match the exact pattern. The known sorries (`Differentials.lean:362`, `Jacobian.lean:179`) carry substantive roadmap docstrings rather than excuse-style admissions.

However, one author-acknowledged dead-content disclosure qualifies under the spirit of the rubric:

- `Cohomology/StructureSheafModuleK.lean:537` (inside the docstring of `IsHModuleHomFinite` at L518–543): *"The iter-041 class therefore admits no producer instance on a non-trivial proper curve — **dead scaffolding**."* The author explicitly labels four declarations (the `IsAffineHModuleHomFinite` class at L458–466 and its three consumers at L476–487, L497–507, L512–519) as wrong / unreachable while leaving them in the source. Severity: **critical** (the class is consumed by typeclass search wherever it lands in scope, so the dead scaffolding is not inert).

Two near-misses that are *not* excuse-comments but are worth a glance from the plan agent:

- `Cohomology/MayerVietorisCover.lean:660–674` — `HasAffineCechAcyclicCover` docstring: *"Iter-053 is a thin scaffolding step — the existence is asserted, not constructed."* This is a transparent hypothesis-mode sorry, but the author is open about it; it is a design choice, not an excuse comment.
- `Genus.lean:39–61` — Commented-out sketch of an obsoleted construction route, with an internal `sorry` at L52. Dead-content disclosure (the route was not taken), but it sits inside a `/- … -/` block and is not active scaffolding. Should still be removed.

## Severity summary

- **must-fix-this-iter**: 4 — IsAffineHModuleHomFinite dead class + consumers (StructureSheafModuleK.lean), AffineCoverMVSquare unused fields (MayerVietorisCover.lean), Genus.lean stale sketch, Differentials.lean `erw [hmc]`.
- **major**: 6
- **minor**: 8
- **excuse-comments**: 1 (also counted under must-fix-this-iter; called out separately because it is an author admission that code is dead).

Overall verdict: the two disclosed sorries are the principal mathematical work, and the iter-122/123 `appLE_isLocalization` refactor has produced a clean reduction with explicit forward-map machinery — but the project carries several pieces of historical scaffolding (dead Cohomology classes, unused structure fields, stale headers, an `erw` brittle spot) that should be pruned this iter before they accumulate further.
