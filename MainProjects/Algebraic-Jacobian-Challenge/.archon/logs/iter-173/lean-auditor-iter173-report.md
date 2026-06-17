# Lean Audit Report

## Slug
iter173

## Iteration
173

## Scope
- files audited: 4 (per directive)
- files skipped: 0
- compilation: all 4 files clean on `lean_diagnostic_messages` (errors); only `declaration uses sorry` warnings.

Files audited (absolute paths from directive):
- `AlgebraicJacobian.lean`
- `AlgebraicJacobian/Genus0BaseObjects.lean`
- `AlgebraicJacobian/Picard/RelativeSpec.lean`
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

Sorry inventory verified by LSP:
- `Genus0BaseObjects.lean`: 8 sorries (L186, L193, L768, L944, L961, L1025, L1105, L1135).
- `Picard/RelativeSpec.lean`: 6 sorries (L98, L123, L134, L169, L193, L223).
- `RiemannRoch/WeilDivisor.lean`: 5 sorries (L141, L171, L233, L248, L269).
- `AlgebraicJacobian.lean`: 0.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Umbrella file: adds two new imports (`AlgebraicJacobian.Picard.RelativeSpec`, `AlgebraicJacobian.RiemannRoch.WeilDivisor`) consistent with the two new files. Confirmed no-op otherwise.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 8 (all top-level `sorry` instances/lemmas; classified below)
- **dead-end proofs**: 0
- **bad practices**: 1 (uncommon tactic `push Not` at L237)
- **excuse-comments**: 0 flagged in the new this-iter helpers; multiple "scaffold" / "Mathlib gap" rationale comments attached to pre-existing sorries (see below)
- **notes**:
  - L796–805 `awayι_comp_PLB_hom` (new this iter): substantive ring-rewrite proof using `Proj.awayι_toSpecZero`, `Spec.map_comp`, `CommRingCat.ofHom_comp`, then `rfl`. Body is generic in the homogeneous element `f`, used by `gmScalingP1_cover_X_iso` (both `i = 0` and `i = 1` branches) and referenced in the proof outline for `gmScalingP1_over_coherence`. **Load-bearing and clean.**
  - L862–893 `gmScalingP1_cover_X_iso` (new this iter): pattern-matches on `i : Fin 2` because `(![X 0, X 1]) i = X i` is not definitional and only reduces case-by-case via `Matrix.cons_val_zero/one`. The rationale is documented at L869–872. This is the standard Mathlib idiom (`OpenCover.pullbackCoverAffineRefinementObjIso`). **Substantive and used by `gmScalingP1_chart` (L908–928).**
  - L186 `projectiveLineBar_geomIrred := sorry` — substantive instance, scaffold rationale ("Mathlib does not ship `GeometricallyIrreducible` for `Proj` of a polynomial ring") — pre-existing.
  - L193 `projectiveLineBar_smoothOfRelDim := sorry` — substantive instance, scaffold rationale — pre-existing.
  - L237 `push Not at h` — uncommon spelling; compiles, but the conventional spelling is `push_neg at h`. Minor.
  - L768 `gm_grpObj : GrpObj (Gm kbar) := sorry` — substantive load-bearing instance (the docstring at L763–767 explicitly notes "this `GrpObj Gm` is the LIVE consumer of the iter-166 `morphism_P1_to_grpScheme_const` proof body"). Pre-existing scaffold; MEMORY index records it as the iter-168+ escalation watch.
  - L944 `gmScalingP1_chart_agreement := sorry` — substantive cocycle-agreement lemma; rationale at L935–943 explains why it is left as a top-level scaffold (per the directive's "no buried sorries" guidance).
  - L961 `gmScalingP1_over_coherence := by sorry` — substantive coherence lemma; L967–989 is a long proof-outline comment (~25 lines) describing the iter-174 closure plan. Acceptable as a top-level scaffold but the long sketch reads as a guarantee that must land soon.
  - L1025 `gmScalingP1_collapse_at_zero := by sorry` — load-bearing fixed-point lemma that the rigidity consumer requires (Cor 1.5's hypothesis `_hf`). Substantive.
  - L1105 `gm_geomIrred := sorry` — Mathlib-gap scaffold (pre-existing).
  - L1135 `projGm_isReduced := sorry` — Mathlib-gap scaffold (pre-existing).
  - The two genuinely new this-iter additions (`awayι_comp_PLB_hom`, `gmScalingP1_cover_X_iso`) are **both substantive, clean, and properly load-bearing**. The 8 sorry warnings are not new this iter (per the memory record and the docstrings' rationale fields, all are pre-existing scaffolds).

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: 0
- **suspect definitions**: 1 critical (TYPE-level sorry, L98) + 5 substantive-statement sorries (L123, L134, L169, L193, L223)
- **dead-end proofs**: 0 (no proof bodies of substance; all `:= sorry` or `:= by sorry`)
- **bad practices**: 1 (TYPE-level sorry on a load-bearing carrier type)
- **excuse-comments**: 11 occurrences of `iter-174+ ...` forward-looking promises (L21, L79, L90, L119, L130, L151, L164, L188, L190, L214, L218, L234, L245)
- **notes**:
  - L98 `noncomputable def QcohAlgebra (X : Scheme.{u}) : Type (u+1) := sorry` — **TYPE-level `sorry` on a carrier type**. The file's own docstring (L73–77) admits this: "we package this abstractly as a type-level placeholder: the iter-173 file-skeleton leaves this as a typed `sorry` at the type level because Mathlib `b80f227` does not yet provide a `QcohAlgebra` notion." This is "Stand-in definition until we figure out the right one" verbatim from the auditor rubric. Every theorem in the file quantifies over `X.QcohAlgebra`, so the entire file's substantive content rests on a `sorry`-defined carrier type. **Critical.**
  - L123 `RelativeSpec := sorry` (Scheme-valued) — substantive `sorry` on a load-bearing definition; reasonable as a scaffold given L98 is also `sorry`, but multiplies the same issue.
  - L134 `RelativeSpec.structureMorphism := sorry` — auxiliary, declared "not in the 6 blueprint pins" per the docstring (L128). This auxiliary is consumed by `UniversalProperty`, `base_change`, and `functor`. **Substantive.**
  - L169 `UniversalProperty := by sorry` (returns `IsAffineHom _`): substantive type (not `Iso.refl`-style) — affineness of the structure morphism is the *intended substantive consequence* of Stacks 01LQ representability. Acceptable as a downgrade per the directive's "intended substantive type" criterion, **but the docstring at L162–168 candidly admits the type is weaker than the full Yoneda-bijection** and promises iter-174+ refinement. The declaration name `UniversalProperty` overpromises relative to the type `IsAffineHom (structureMorphism 𝒜)`. **Major naming concern.**
  - L193 `affine_base_iff : IsAffine ((Spec R).RelativeSpec 𝒜) := by sorry` — substantive type, **but the name `_iff` is misleading**: the statement is a one-direction implication, not an iff. Minor naming issue plus the docstring acknowledges this is weaker than the full `Nonempty (RelativeSpec ≅ Spec Γ(_, 𝒜))` statement.
  - L223 `base_change : ∃ 𝒜', Nonempty (pullback ≅ T.RelativeSpec 𝒜') := by sorry` — substantive type via existential + `Nonempty (... ≅ ...)`. Acceptable as scaffold.
  - L251 `def functor := fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)` — NOT a sorry, but propagates `sorryAx` because the body invokes the `sorry`-defined `structureMorphism`. The docstring (L246) notes this explicitly. OK as a scaffold once `structureMorphism` lands.
  - The "References" docstring (L52–57) cites accurate Stacks tags and Hartshorne pointers.
  - The aggregate concern: every iter-174+ refinement comment names a concrete refinement target (e.g. "refine the signature to a `CategoryTheory.Functor.RepresentableBy` witness"), so the comments are forward-looking commitments, not vague TODOs. Still, by the auditor's strict-severity rule, these are excuse-comments documenting that the code is wrong.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: 1 (chapter-section docstring at L70–77 references the **old** field name `isCodim1AndIntegral`)
- **suspect definitions**: 5 (sorries at L141, L171, L233, L248, L269 — all substantive bodies)
- **dead-end proofs**: 0
- **bad practices**: 1 (`degree_hom` is marked `noncomputable` but its body `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` is computable)
- **excuse-comments**: 5 (`iter-173+ ...` at L30, L138, L168, L230, L245)
- **notes**:
  - L93–98 `Scheme.PrimeDivisor`: substantive structure with `point : X` (data) and `coheight : Order.coheight point = 1` (witness). **Replaces** the previous `isCodim1AndIntegral : True := trivial` placeholder per the directive. The field-level docstring (L96–98) is accurate. **Substantive.**
  - **L70–77 (section comment) is OUTDATED** — predicts that "iter-173+ will refine to the genuine `Order.coheight x = 1 ∧ IsIntegral (X.closedSubschemeOfPoint x)`" and names the field `isCodim1AndIntegral`. But (a) iter-173 has already landed the refinement and renamed the field to `coheight`, and (b) the refinement that landed is `Order.coheight point = 1` (no `IsIntegral` conjunct, since the docstring at L96 explains the integrality is automatic from irreducibility of `{point}̄`). **Major: outdated docstring that does not match the code below it.**
  - L106 `def Scheme.WeilDivisor := X.PrimeDivisor →₀ ℤ` — substantive, no sorry. ✓
  - L110, L113: trivial `AddCommGroup` + `Inhabited` instances via `inferInstanceAs`. Clean.
  - L141 `Scheme.RationalMap.order := sorry` — substantive sorry on the order-along-DVR construction. Pre-existing scaffold.
  - L171 `ofClosedPoint := sorry` — substantive scaffold.
  - L192–193 `degree` def: `(D : X.PrimeDivisor →₀ ℤ).sum (fun _ n => n)`. Substantive, no sorry. ✓
  - L207–208 `degree_hom : X.WeilDivisor →+ ℤ := Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)`. **Substantive, sorry-free, and the body matches the documented blueprint.** ✓
  - L210–213 `degree_hom_apply` connecting lemma: `Finsupp.liftAddHom_apply` directly. Clean. ✓
  - L207 `noncomputable` on `degree_hom` is **unnecessary** — `Finsupp.liftAddHom (AddMonoidHom.id ℤ)` is computable. Minor.
  - L233 `principal := sorry` — substantive scaffold.
  - L248 `principal_hom := sorry` — substantive scaffold.
  - L269–274 `principal_degree_zero := sorry` — substantive lemma (Hartshorne II.6.10). Body sketch in docstring.
  - L293–294 `LinearEquivalence` predicate: substantive `Prop`-valued definition via `∃ f hf, D - D' = principal f hf`. No sorry. ✓
  - The PrimeDivisor structure landed substantively, the degree map landed substantively, but the load-bearing `RationalMap.order` / `principal` / `principal_degree_zero` remain sorries. The directive's narrower question — *was `degree_hom` repaired and was `coheight` substantive?* — answers YES on both counts. No callers were broken (the only consumer of the structure at this stage is the file itself; verified by grep: `PrimeDivisor` is project-local to this file).

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/RelativeSpec.lean:98` — `noncomputable def QcohAlgebra (X : Scheme.{u}) : Type (u+1) := sorry`. Why must-fix: A **type-level `sorry`** on a load-bearing carrier type. The docstring explicitly labels it a "type-level placeholder" — verbatim the "Stand-in definition until we figure out the right one" red-flag pattern from the auditor rubric. Every theorem in the file quantifies over `QcohAlgebra X`, so the entire file's substantive content is built on `sorry` at the type level. Even if `Type`-level sorries do not contaminate `Prop`-level reasoning kernel-wise, the file's load-bearing role in the positive-genus arm makes this a critical placeholder.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:21, 79, 90, 119, 130, 151, 164, 188, 190, 214, 218, 234, 245` — 13 occurrences of forward-looking `iter-174+ ...` excuse-comments. Why must-fix: per the auditor rubric these document that the code is wrong; they should not be allowed to silence the alarm. The new file lands in a single iter with the full pin set still labelled "scaffold".
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:70–77` — section docstring references the **old** field name `isCodim1AndIntegral` and predicts an iter-173+ refinement that has already landed under a different name (`coheight`) and a different content (no `IsIntegral` conjunct). Why must-fix: the docstring actively misleads a reader about both the field name and the field content. This is an outdated comment of the type the auditor rubric flags as red-flag-grade.

## Major

- `AlgebraicJacobian/Picard/RelativeSpec.lean:169` — declaration name `UniversalProperty` overpromises relative to the type `IsAffineHom (RelativeSpec.structureMorphism 𝒜)`. The docstring (L162–168) candidly admits the type is weaker than the full universal property, but the name remains the strong one. Consider renaming to `structureMorphism_isAffineHom` until the full Yoneda statement lands.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:193` — declaration name `affine_base_iff` is misleading: the statement `IsAffine ((Spec R).RelativeSpec 𝒜)` is a one-direction implication, not an iff.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:251` — `functor` returns `X.QcohAlgebra → Over X` (a bare function), not a categorical `Functor`. The docstring acknowledges this but the symbol `functor` is misleading at the type level.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:30, 138, 168, 230, 245` — 5 `iter-173+ ...` excuse-comments. By the rubric these are red flags; downgraded to major because each one is attached to a *substantive* scaffold sorry (i.e., they document the same load-bearing gap that the `:= sorry` already announces, so they do not introduce *new* dishonesty beyond what the sorry already exposes).
- `AlgebraicJacobian/Genus0BaseObjects.lean:967–989` — `gmScalingP1_over_coherence` has a ~25-line proof outline in `--` comments above its `sorry`. The outline names 7 concrete intermediate steps and 2 named sub-lemmas (`gmScalingP1_chart_PLB_eq` part (a) and (b)). Outlines of this size in a comment are a form of soft commitment that the next iter will land them; if iter-174 does not, this becomes stale.

## Minor

- `AlgebraicJacobian/Genus0BaseObjects.lean:237` — `push Not at h` uses uncommon spelling. Compiles, but `push_neg at h` is the conventional Mathlib spelling.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:207` — `noncomputable def degree_hom` is unnecessary; `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` is computable.
- `AlgebraicJacobian/Genus0BaseObjects.lean:765–767` — the docstring for `gm_grpObj` calls itself "the LIVE consumer of the iter-166 `morphism_P1_to_grpScheme_const` proof body". This wording is informational, but the iter-number reference will drift; consider phrasing it without an iter pin once the consumer lands.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:101–114` — empty `namespace RelativeSpec ... end RelativeSpec` block with only a `/-! ## §2. ... -/` comment inside, opened and closed *before* the `RelativeSpec` definition is even introduced at L123. Reads as a no-op section header. Consider inlining the doc-comment into the definition's docstring instead.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/RelativeSpec.lean:74`: "abstractly as a type-level placeholder: the iter-173 file-skeleton leaves this as a typed `sorry` at the type level" — attached to `QcohAlgebra` (carrier type, load-bearing for the entire file). **Severity: critical.**
- `AlgebraicJacobian/Picard/RelativeSpec.lean:21`: "The bodies are iter-174+ work after the sibling chapters `A.1.b` ... and `A.1.c` ... land." Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:79`: "iter-174+ will instantiate this as a structure pairing ...". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:90–96`: code-block inside docstring describing the iter-174+ `structure QcohAlgebra` rewrite. Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:119`: "iter-174+: the body builds `Scheme.GlueData` from the affine-local pieces". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:130`: "iter-174+ will produce it from the `GlueData` of `RelativeSpec`". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:151`: "iter-174+: refine the signature to a `CategoryTheory.Functor.RepresentableBy` witness". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:164`: "iter-174+: refine the type signature to the full Yoneda-bijection statement". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:188`: "extracting `Γ(X, 𝒜) : CommRingCat` requires the unpacked structure of `QcohAlgebra`, which is iter-174+ work". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:190`: "iter-174+: refine to the full statement `Nonempty ((Spec R).RelativeSpec 𝒜 ≅ Spec (Γ((Spec R), 𝒜)))`". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:214`: "iter-174+ will refine to a named `pullbackQcoh g 𝒜` operation once `QcohAlgebra` is unpacked". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:218`: "iter-174+: the body invokes the universal property and unwinds the bijection ...". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:234`: "morphism-level action and full `Functor` packaging are iter-174+ work". Severity: major.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:245`: "iter-174+: the body is concrete via `Over.mk (RelativeSpec.structureMorphism 𝒜)` but is left as `sorry` here". Severity: major.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:30`: "The bodies are iter-173+ work after the sibling chapters `RR.2` ... `RR.3` ... and `RR.4` ... land." Severity: major.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:74`: "The skeleton's `isCodim1AndIntegral` field is a placeholder `True` that iter-173+ will refine ..." — **also outdated** (the refinement landed). Severity: major (under both the excuse-comment and outdated-comment rules).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:138`: "iter-173+: the body extracts the DVR ...". Severity: major.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:168`: "iter-173+: the body promotes the closed point ...". Severity: major.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:230`: "iter-173+: the body invokes Hartshorne 6.1 ...". Severity: major.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:245`: "iter-173+: closes coordinate-wise from the DVR identities ...". Severity: major.

## Severity summary

- **must-fix-this-iter**: 3 — `QcohAlgebra := sorry` type-level placeholder (Picard/RelativeSpec.lean:98), the 13 forward-looking `iter-174+` excuse-comments in Picard/RelativeSpec.lean (counted as a single must-fix item against the file), and the outdated `isCodim1AndIntegral` section docstring in WeilDivisor.lean:70–77.
- **major**: 9 — 3 naming/structural concerns in Picard/RelativeSpec.lean (`UniversalProperty`, `affine_base_iff`, `functor`), 5 excuse-comments in WeilDivisor.lean (`iter-173+` series), 1 long proof-outline comment soft-commitment in Genus0BaseObjects.lean (gmScalingP1_over_coherence).
- **minor**: 4 — `push Not` spelling, redundant `noncomputable` on `degree_hom`, iter-number-pin in `gm_grpObj` docstring, empty `RelativeSpec` namespace block.
- **excuse-comments**: 20 individually listed (1 critical, 19 major). Counted under must-fix-this-iter as 1 aggregate item against Picard/RelativeSpec.lean and 1 against WeilDivisor.lean.

**Overall verdict**: The two new this-iter helpers in `Genus0BaseObjects.lean` (`awayι_comp_PLB_hom`, `gmScalingP1_cover_X_iso`) and the `WeilDivisor.lean` `PrimeDivisor.coheight` / `degree_hom` substantive landings are clean and substantively typed; the file-skeleton `Picard/RelativeSpec.lean` lands with a critical type-level `:= sorry` on its carrier type `QcohAlgebra` and a heavy load of forward-looking excuse-comments that the auditor rubric treats as red flags regardless of project-side scaffolding rationale.
