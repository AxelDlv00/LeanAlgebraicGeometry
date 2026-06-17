# Lean Audit Report

## Slug
review130

## Iteration
130

## Scope
- files audited: 12
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 1 flagged
- **bad practices**: 1 flagged (Classical.choice on a constructed Nonempty)
- **excuse-comments**: 1 flagged (Caveat on canonicity — misleading)
- **notes**:
  - L141–143: the in-body comment justifying the outer `Classical.choice` (`"...cannot be obtain-destructured directly inside a Type-valued definition, so we pass through Classical.choice on a Nonempty (ModuleCat k) witness"`) is honest about the technical workaround chosen, but the workaround itself is structurally broken (see L131–170 below).
  - L131–170: the body builds an explicit witness `X := (ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…⁄…])` and then wraps it with `Classical.choice (α := ModuleCat k) ⟨X⟩`. By definition of `Classical.choice`, the result is **not** definitionally equal to `X` — it is some unspecified inhabitant of `ModuleCat k`. The only content recoverable from this definition is `Nonempty (ModuleCat k)`, which is a trivial statement once `ModuleCat.of k k` exists. The advertised rank-`n`-free Kähler-module content does NOT carry over to `cotangentSpaceAtIdentity G`.
  - L118–123 (Caveat on canonicity): says "it is therefore not canonically attached to `G`" — but the canonical-vs-non-canonical framing understates the loss. The real defect is that **no** structural property of the witness (rank, freeness, finiteness) is recoverable from the resulting `ModuleCat k`, canonical or otherwise.
  - L128–130: docstring claim that "The structural properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are content for the iter-129+ rank lemma" is incompatible with the body chosen — those properties cannot be proven of `Classical.choice ⟨X⟩` from the fact that they hold of `X`.
  - Mismatch with `analogies/lieAlgebra-rank-bridge.md:51` (which the auditor read solely for the named-decl signature `cotangentSpaceAtIdentity_finrank_eq`): the divergence cost noted there ("the rank lemma cannot close against the iter-128 body") would re-apply to the iter-130 body for the same structural reason — the body is opaque past `Nonempty`.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: 2 flagged (the two `sorry`-bodied declarations)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none in the strict pattern (no "TODO replace", "placeholder", etc.)
- **notes**:
  - L19–30 (file-level docstring): correctly enumerates TWO `sorry`-bodied declarations (`genusZeroWitness`, `nonempty_jacobianWitness`). This block is internally consistent.
  - L188–192 (`genusZeroWitness`): scaffold-`sorry` declaration. Body `sorry`. Per-decl docstring (L176–187) is consistent with the file-level prose.
  - L195 (in `nonempty_jacobianWitness` docstring): "This is the single remaining mathematical sorry of the Phase-C Jacobian scaffolding" — **stale**. With the iter-127 split-off of `genusZeroWitness`, the file now carries TWO sorries, not one. The "single remaining" phrasing pre-dates the genus-0 split and should be revised to "one of two".
  - L226 (in `Jacobian` def docstring): "the existence of such a witness is the single remaining mathematical sorry of the Phase-C scaffolding" — **same staleness as L195**. The `Jacobian` def projects from `jacobianWitness`, but the genus-0 sorry `genusZeroWitness` is also part of the Phase-C scaffolding and is not absorbed into `nonempty_jacobianWitness` (it is a separately-stated declaration).
  - Body of `Jacobian` and the four protected `instGrpObj`/`smoothOfRelativeDimension_genus`/`instIsProper`/`instGeometricallyIrreducible` instances are clean projections from `jacobianWitness C`; no separate hygiene concerns.
  - `IsAlbanese.unique` (L102–128) has an honest, well-structured proof; no concerns.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (sorry-bodied)
- **dead-end proofs**: none (a single `sorry`, openly declared)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L87: `rigidity_over_kbar := sorry` is the one known scaffold sorry. Status block (L19–30) and per-decl status (L70) are consistent and honest.
  - L32–46 "Encoding choice": documents the Option-A-vs-B refactor decision. Includes the phrase "Option A is mathematically wrong as written" — this is honest *historical* documentation explaining why a candidate encoding was rejected. Not an excuse-comment on live code.
  - No drift between docstring claims and body.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `smooth_locally_free_omega` (L124–142): forward Jacobian criterion. Honest proof body. The `first | ... | ...` discharges both the `Module.Free` and `Module.rank = n` legs uniformly via `algebraize` + the standard-smooth API. Clean.
  - L119–123: explicit disclosure of the converse direction being "mathematically false" with a named counterexample (`Spec k → Spec k[t]`, `t ↦ 0`). Honest scientific documentation; not an excuse-comment.
  - `kaehler_quotient_localization_iso` (L86–109): solid proof; the inner `Subsingleton (TensorProduct L B Ω[L⁄A])` is established by induction. Clean.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three Phase-E declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) project uniformly from `jacobianWitness C`. Bodies are minimal and faithful to docstrings.
  - File-level docstring (L14–28) is consistent with the body. The iter-073 refactor narrative is documented as historical context, not as an excuse.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (iter-tag noise in docstrings)
- **excuse-comments**: none
- **notes**:
  - File is dense with iter-NNN tags ("iter-016", "iter-022", ...) in docstrings. This is project-internal narrative noise — not an audit-blocking issue, but reduces docstring signal for the next maintainer. (Minor severity; bookkeeping rather than mathematical.)
  - All declarations have honest proof bodies. The `Abelian.Ext.chgUnivLinearEquiv` Mathlib gap-fill at the top of the file (L101–110) is correctly built from `chgUniv_add` + `chgUniv_smul` lemmas above.
  - `HModule'_sequence_exact` (L592–601), `HModule'_δ_toBiprod` (L604–613), `HModule'_fromBiprod_δ` (L616–625) chain through `Ext.contravariantSequence` + `HModule'_sequenceIso` — standard MV-LES architecture, no concerns.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (same iter-tag noise as MayerVietorisCore)
- **excuse-comments**: none
- **notes**:
  - L502–514 (`cechToHModuleIso` extractor): the docstring's parenthetical "(already in the kernel-only axiom set `[propext, Classical.choice, Quot.sound]` since iter-048; no new axiom introduced)" is honest — `Classical.choice` here is on a `Prop`-valued `Nonempty`, which is its intended use and does not introduce a custom axiom.
  - `HasAffineCechAcyclicCover` class (L675–682) and the producer instance L699–709 are well-structured. The carrier predicate honestly admits (per docstring L658–674) that iter-053 only scaffolds the existence — the substantive cover construction is queued. Honest documentation, not an excuse.
  - `Opens.mayerVietorisSquare` body for `AffineCoverMVSquare.toMayerVietorisSquare`, corner-identification `rfl`s, and the `cover` field substitution at L101 are all standard.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (`import Mathlib` wholesale at L6 for a 50-line file with one instance)
- **excuse-comments**: none
- **notes**:
  - Single instance (`instHasSheafCompose_forget_CommRing_AddCommGrp`, L39–47). Honest 5-line body via `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three instances/defs, all closed honestly. The universe-pinning comment at L40–42 on `instHasExt_Sheaf_Opens_AddCommGrp` is precise and useful documentation, not an excuse.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (iter-tag noise in docstrings)
- **excuse-comments**: none
- **notes**:
  - L78 `include adj`: needed because `adj` is otherwise an unused-but-required binder in subsequent `lemma`/`def` bodies. Standard pattern.
  - L487–492 `IsHModuleHomFinite`: file-level docstring (L37–48) **honestly disclosed** the abandonment of the iter-041 per-affine-open variant and removed it from the file. The accompanying historical note in the class docstring (L472–483) explains the rejection with a concrete counterexample (`Γ(U, O_{ℙ¹}) = k[t]` is infinite over `k`). This is **good defensive documentation**, not an excuse.
  - All `theorem`/`def`/`instance` bodies in the H⁰ Hom-finiteness ladder (iter-044 to iter-046, L548–720) are honestly proved through `Module.Finite.equiv`, `RingHom.finite_algebraMap`, and the linearised `homLinearEquiv`. Long but clean.
  - `toModuleKSheaf_forgetCompare := Iso.refl _` (L246–252): probe-confirmed definitional iso. The docstring honestly states the two sheaves "agree on the nose at the underlying-presheaf level." Acceptable.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (`import Mathlib` wholesale at L6 for a one-decl file)
- **excuse-comments**: none
- **notes**:
  - `genus` (L40–43) body is the honest H¹ definition `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. Status block (L14–28) is consistent.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91–121) is a clean, well-organized proof. The four numbered comment steps inside the body are useful guideposts, not narrative noise.
  - "Hypothesis history" block (L43–79): unusually long, but every paragraph is honest documentation of an iteration-prior design decision with explicit *mathematical* justification (e.g. characteristic-`p` Frobenius counterexample for the original point-wise hypothesis). This is good archival documentation, not an excuse-comment on live code.

## Must-fix-this-iter

- `AlgebraicJacobian/Cotangent/GrpObj.lean:131-170` — `cotangentSpaceAtIdentity` body is `Classical.choice (α := ModuleCat k) ⟨X⟩` where `X` is the explicit chart-base-changed Kähler module. The result is **not definitionally equal to `X`**; only `Nonempty (ModuleCat k)` is structurally exposed by the definition. Therefore the advertised rank-`n`-free content of the chart construction cannot be transported to `cotangentSpaceAtIdentity G`, and the iter-129+ companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` will be **unprovable** against this body for the same reason its iter-128 predecessor was (analogies/lieAlgebra-rank-bridge.md:51). Why must-fix: this is a "suspect body on a substantive claim" — the construction passes Lean's type-checker but cannot support the downstream rank statement it was redesigned to support.

  Recommended fix-direction (audit-level, not prescriptive): replace `refine Classical.choice (α := ModuleCat k) ?_; obtain ⟨…⟩ := h; exact ⟨X⟩` with a direct `Classical.choose`-on-the-existential chain that exposes `U, V, e, hxV, hU, hV, hfree, hrank` as data (each via `Classical.choose` / `Classical.choose_spec`), and then return `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of Γ(G,V) Ω[…])` *directly* as the term — no outer `Classical.choice` wrapper. The downstream rank lemma can then `unfold cotangentSpaceAtIdentity` and reach the explicit Kähler module.

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:118-123` — "Caveat on canonicity" paragraph in `cotangentSpaceAtIdentity` docstring is misleading. It frames the loss as "not canonically attached to `G` in the strictest sense" and claims "canonicity is not load-bearing." The actual loss is stronger: **no** rank-`n`-free structural property of the witness transfers to the result, canonical or otherwise. Either the body needs fixing (must-fix above) or the docstring needs to be rewritten to disclose the full opacity.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:128-130` — Final docstring line "The structural properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are content for the iter-129+ rank lemma" is incompatible with the iter-130 body. Those properties hold of the *witness* `X`, not of `Classical.choice ⟨X⟩`. The line implicitly promises a follow-up proof that the body, as currently written, cannot support.
- `AlgebraicJacobian/Jacobian.lean:195` — `nonempty_jacobianWitness` docstring says "This is the single remaining mathematical sorry of the Phase-C Jacobian scaffolding". File currently carries TWO sorries (`genusZeroWitness` at L188–192 is the second). The "single remaining" phrasing predates the iter-127 split-off of `genusZeroWitness` and is now stale; should read "one of two" or be re-scoped.
- `AlgebraicJacobian/Jacobian.lean:226` — same staleness as L195: `Jacobian` def docstring repeats "the existence of such a witness is the single remaining mathematical sorry of the Phase-C scaffolding." Should be brought into alignment with the file-level docstring (L19–30) which correctly enumerates two sorries.

## Minor

- `AlgebraicJacobian/Genus.lean:6` — `import Mathlib` wholesale. The file's single declaration only needs `Module.finrank` and the project-local cohomology module. Tightening this import would reduce blast-radius on rebuilds.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean:6` — `import Mathlib` wholesale for a 50-line file with one instance. Same rebuild-cost minor as Genus.lean.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`, `…/MayerVietorisCover.lean`, `…/StructureSheafModuleK.lean` — heavy use of iter-NNN tags in docstrings (e.g. "Phase A step 6 *Path 2* (iter-019)..."). Not a hygiene defect, but the project-internal scheduling narrative bloats user-visible declaration docs. Cosmetic only.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Cotangent/GrpObj.lean:118-123` — the "Caveat on canonicity" paragraph in `cotangentSpaceAtIdentity`'s docstring functions as an excuse-comment in the strict directive sense: it pre-emptively softens the reader against a deficiency in the body without honestly disclosing the deficiency. The deficiency is not "non-canonical" — it is "structurally opaque". Severity: **major** (paired with the **critical** must-fix on the body). The in-body comment at L141–143 is honest about the workaround chosen and is not flagged.

## Severity summary

- **must-fix-this-iter**: 1
- **major**: 4
- **minor**: 3
- **excuse-comments**: 1 (also counted under major above; called out separately because it documents the project lying to itself)

Overall verdict: The iter-130 fix-up of `cotangentSpaceAtIdentity` does not deliver the structural content its docstring advertises — the outer `Classical.choice` wrapping the explicit chart-base-changed Kähler module discards the rank-`n`-free property and will block the iter-129+ companion rank lemma exactly as the iter-128 body did; otherwise the project is clean apart from stale "single remaining sorry" prose in `Jacobian.lean` and a few cosmetic minors.
