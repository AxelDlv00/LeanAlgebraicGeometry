# Lean Audit Report

## Slug
review134

## Iteration
134

## Scope
- files audited: 12 (all `.lean` files under `AlgebraicJacobian/`)
- files skipped (per directive): 0 — N/A

## Per-file checklist

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 3 flagged (the stale Lean-line-anchors at L28, L30, L31–32; already known per directive)
- **suspect definitions**: 3 flagged
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (using `theorem` keyword for declarations whose body is `Iso.refl _` on a Nonempty-wrapped reflexive iso)
- **excuse-comments**: 3 flagged (each is a `**Iter-134 placeholder**` docstring stanza on a load-bearing declaration; co-located in the same file at L473–475, L504–507, L561–565)
- **notes**:
  - L28, L30, L31–32: stale line-number anchors (`149`/`198`/`244` cited; actual `161`/`210`/`256`). Known per directive — iter-135 writer pass scheduled.
  - L50, L53, L204: pre-existing `opaque` warnings (known per directive — not introduced this iter).
  - L348–383: `shearMulRight` and its `_hom_fst`/`_hom_snd` companion `simp` lemmas are honest closures. The proof of `hom_inv_id` / `inv_hom_id` is via explicit `CartesianMonoidalCategory.hom_ext` + `lift_lift_assoc` chains; matches the named claim. No `sorry`, no excuse-comments. **Solid iter-134 substantive work.**
  - L417–419: `schemeHomRingCompatibility` is a small honest helper packaging the adjunction transpose of `f.c`. The type and body align.
  - **L476–482** (`relativeDifferentialsPresheaf_basechange_along_proj_two`): MUST-FIX. The actual type is `Nonempty (Ω_{G/k} ≅ Ω_{G/k})` — provable trivially by `Iso.refl _`. The docstring says: "**Iter-134 placeholder**: reflexive iso `Ω_{G/k} ≅ Ω_{G/k}`. The next iter is expected to (i) ... (ii) rephrase as the intended type." The intended type (per the docstring) is `Ω_{(G ⊗ G)/G} ≅ pr₂^* Ω_{G/k}`, which is mathematically distinct from `Ω_{G/k} ≅ Ω_{G/k}`. The name asserts a base-change identity that the body does not deliver. This is the weakened-wrong-definition + excuse-comment pattern from the auditor must-fix list.
  - **L508–514** (`relativeDifferentialsPresheaf_restrict_along_identity_section`): MUST-FIX. Same shape: actual type is `Nonempty (Ω_{G/k} ≅ Ω_{G/k})`, body is `⟨Iso.refl _⟩`, docstring labels it "**Iter-134 placeholder**" with the intended section-restriction iso recorded as a future-iter target. The name asserts a section-restriction identity that the body does not deliver.
  - **L566–572** (`mulRight_globalises_cotangent`): MUST-FIX, load-bearing. Same shape: actual type `Nonempty (Ω_{G/k} ≅ Ω_{G/k})`, body `⟨Iso.refl _⟩`, docstring labels it "**Iter-134 placeholder**". This is the *main lemma* of piece (i.b) per the file's own section header (L302). The name `mulRight_globalises_cotangent` asserts the central shear-iso globalisation result `Ω_{G/k} ≅ π_G^*(η_G^* Ω_{G/k})`; the body delivers nothing of the sort. A downstream importer of this name will get a hollow `Iso.refl` while the docstring claims the iso is the globalisation iso.
  - The four parameters `{n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom]` on all three placeholder theorems are **unused** by the `Iso.refl _` body — a Lean-side smoke signal that the body doesn't match the declared dependency surface.
  - L421–447: the section docstring before the three placeholders is itself an extended excuse-comment block ("the bodies are placeholders pending the multi-iter piece (i.b) lane closure", "intended type", "iter-134 placeholder type"). Honest, but the existence of a meta-docstring explaining why three named declarations are hollow is itself a project-health smell.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 0
- **suspect definitions**: 0 (the three `sorry` bodies are honest scaffolds; see notes)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L188–192 (`genusZeroWitness`): `noncomputable def ... := sorry`. Docstring openly labels `Status: iter-127 scaffold — body is sorry`. The type signature is the actual intended type (a `JacobianWitness C` under `genus C = 0`). The closure is correctly attributed to M2/M3 work. Honest scaffold.
  - L211–215 (`positiveGenusWitness`): NEW iter-134 scaffold, `noncomputable def ... := sorry`. Docstring openly labels `Status: iter-134 scaffold — body is sorry`. The type signature is the actual intended type (a `JacobianWitness C` under `0 < genus C`). The deferral is to M3 (OFF-CRITICAL-PATH), and the scaffolding rationale (unblocking a `by_cases h : genus C = 0` decomposition of `nonempty_jacobianWitness`) is recorded honestly. **Honest scaffold per the directive's explicit ask** — the docstring frames the sorry as deferred M3 work with the right intended type, and contains no excuse-comments.
  - L233–236 (`nonempty_jacobianWitness`): `theorem ... := sorry`, honest. Pre-existing Phase-C scaffolding.
  - L44–53 forbidden-shortcut disclosure: the "Forbidden shortcut (sanity check)" docstring block honestly records that defining `Jacobian C := 𝟙_ _` would compile but is mathematically wrong for genus ≥ 1. This is a positive sanity-check pattern, not an excuse-comment.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L75–87: `rigidity_over_kbar` is `:= sorry`. Type signature is the honest classical Mumford rigidity statement; docstring openly labels `Status: iter-126 scaffold — body is a single sorry` with the closure path correctly attributed to the cotangent-vanishing pile. Honest scaffold.
  - L31–46: the "Encoding choice" block honestly documents why Option B (abstract genus-0 curve) was chosen over the mathematically wrong Option A (literal `MvPolynomial.C`). Positive sanity-check pattern.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Single declaration `genus`, fully closed via `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. The mathematical definition $\dim_k H^1(C, \mathcal{O}_C)$. Honest.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` is fully closed via the Mathlib-derived 4-step proof. Excellent inline commentary that disambiguates topological vs scheme-level rigidity (Frobenius counterexample at L51–55). Honest declaration.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - All declarations closed. `relativeDifferentialsPresheaf`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`, `smooth_locally_free_omega` all have substantive bodies with honest disclosure of the converse-direction caveat (L117–123 explicitly notes the false-as-stated reverse direction).

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - All three protected declarations close uniformly via projection from `jacobianWitness C`. Honest.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- (already covered above)

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Single closed instance `instHasSheafCompose_forget_CommRing_AddCommGrp`. Honest.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Three closed declarations. All honest.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Large substantive file with honestly closed declarations: helpers (1)–(8), `HModule`/`HModule'`, the iter-038/iter-039 `Module.Finite` H⁰ transports, the iter-040/iter-043 carrier classes and consumers, iter-044 Stein finiteness, iter-045 LinearEquiv bridges, iter-046 producer instance `instIsHModuleHomFinite_toModuleKSheaf` (substantive 4-step closure via the Stein chain). The carrier classes `IsAffineHModuleVanishing`, `IsHModuleHomFinite` are honest scaffolds (one closed producer for the latter at iter-046; the former still awaits the iter-053+ producer through `HasAffineCechAcyclicCover`).
  - L41–48 historical note on the abandoned `IsAffineHModuleHomFinite` is positive disclosure (records a previous wrong-direction attempt and its removal).
  - L472–486 historical note on the abandoned per-affine-open `IsHModuleHomFinite` variant is similarly positive disclosure (records that `Γ(U, O_C)` is NOT finite over `k` for proper affine open `U`, which is the kind of dead-end the auditor should be on the lookout for — properly aborted and documented).

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - All declarations closed (iter-034 Mathlib gap-fill `chgUnivLinearEquiv`, iter-016 `HModule'_cohomologyPresheafFunctor`, iter-017–026 MV LES building blocks, etc.). The `set_option backward.isDefEq.respectTransparency false in` annotations at L355, L524, L539, L565 are flagged options but match the Mathlib mirror they reference (load-bearing transparency tweaks for typeclass synthesis); honest use.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - All declarations closed. `HasAffineCechAcyclicCover` is a carrier class introduced at iter-053 with the production instance `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699–709) chained off it; no producer for `HasAffineCechAcyclicCover (Scheme.toModuleKSheaf C)` has landed yet — that is queued multi-iter work. The class itself is honest scaffolding (no producer means it can't fire downstream); the iter-053 docstring (L658–673) records this clearly.

## Must-fix-this-iter

- `AlgebraicJacobian/Cotangent/GrpObj.lean:476-482` — `relativeDifferentialsPresheaf_basechange_along_proj_two`. Actual type `Nonempty (Ω_{G/k} ≅ Ω_{G/k})` is a trivial reflexive iso (body `⟨Iso.refl _⟩`); the docstring at L449–475 labels this an "**Iter-134 placeholder**" and records the substantive intended type `Ω_{(G ⊗ G)/G} ≅ pr₂^* Ω_{G/k}` as future-iter work. **Why must-fix:** weakened-wrong-definition pattern — the declaration's *name* asserts a base-change identity that the *body* does not deliver; downstream importers see a closed theorem with the right name and a hollow content. Excuse-comment pattern on a load-bearing piece (Step 2 of the central piece (i.b) lane).

- `AlgebraicJacobian/Cotangent/GrpObj.lean:508-514` — `relativeDifferentialsPresheaf_restrict_along_identity_section`. Same shape as above: actual type `Nonempty (Ω_{G/k} ≅ Ω_{G/k})`, body `⟨Iso.refl _⟩`, docstring at L484–507 labels this an "**Iter-134 placeholder**" with the intended section-restriction iso recorded as future-iter work. **Why must-fix:** same as above — name asserts content the body doesn't deliver; excuse-comment + weakened-wrong-definition.

- `AlgebraicJacobian/Cotangent/GrpObj.lean:566-572` — `mulRight_globalises_cotangent`. Same shape: actual type `Nonempty (Ω_{G/k} ≅ Ω_{G/k})`, body `⟨Iso.refl _⟩`. Docstring at L516–565 labels this the "**Iter-134 placeholder**" form of the *main lemma* of piece (i.b) (`lem:GrpObj_mulRight_globalises`); the intended type `Ω_{G/k} ≅ π_G^*(η_G^* Ω_{G/k})` is recorded as gated on iter-134+ multi-iter closure. **Why must-fix:** same shape + **load-bearing** (per the file's own section header at L302 and the docstring at L516–518, this is the main lemma the iter-134+ piece (i.b) lane is meant to deliver). A downstream consumer of this name will receive a hollow `Iso.refl` believing it is the globalisation iso. Excuse-comment + weakened-wrong-definition on the central declaration of the piece.

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:28,30,31-32` — stale Lean-line anchors in the file docstring (`149`/`198`/`244` cited; actual `161`/`210`/`256`). Already known per directive; iter-135 cleanup writer pass scheduled. Re-listed here for completeness but classified down to major since the file is still navigable and the names are correct.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:421-447` — the multi-paragraph section docstring justifying the three placeholder theorems below it. The block is honestly disclosing the placeholder status, but its existence amplifies the project-health smell that an entire helper section of the file is hollow. If the must-fix-this-iter items above are addressed (either by genuine bodies or by removal of the declarations until the bodies are available), this block should be revised in lockstep.

## Minor

- `AlgebraicJacobian/Cotangent/GrpObj.lean:476-572` — the three placeholder theorems declare `{n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom]` parameters that are unused by the `Iso.refl _` body. Lean would emit unused-variable hints under strict settings. The over-specified dependency surface is a smoke signal of the body/type mismatch flagged in must-fix.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:658-682` — the `HasAffineCechAcyclicCover` carrier class has been awaiting its producer instance since iter-053 (many iters). Not a defect — honest scaffold with no excuse-comment — but flag as a long-pending dependency that could benefit from a project-status review.

## Excuse-comments (always called out separately)

Listed verbatim with file:line. All three attached to load-bearing piece-(i.b) declarations in `AlgebraicJacobian/Cotangent/GrpObj.lean`:

- `AlgebraicJacobian/Cotangent/GrpObj.lean:473-475` (docstring of `relativeDifferentialsPresheaf_basechange_along_proj_two`):
  > "**Iter-134 placeholder**: reflexive iso `Ω_{G/k} ≅ Ω_{G/k}`. The next iter is expected to (i) construct the binary-product compatibility morphism `φ_pr₂` and (ii) rephrase as the intended type."

  Severity: **critical** (load-bearing — Step 2 of piece (i.b)).

- `AlgebraicJacobian/Cotangent/GrpObj.lean:504-507` (docstring of `relativeDifferentialsPresheaf_restrict_along_identity_section`):
  > "**Iter-134 placeholder**: reflexive iso `Ω_{G/k} ≅ Ω_{G/k}`. The next iter is expected to (i) construct φ_section, φ_pr₂, φ_str, φ_η and (ii) rephrase as the intended type via `PresheafOfModules.pullbackComp` applied to the categorical identity `pr_2 ∘ s = η_G ∘ π_G`."

  Severity: **critical** (load-bearing — Step 3 of piece (i.b)).

- `AlgebraicJacobian/Cotangent/GrpObj.lean:561-565` (docstring of `mulRight_globalises_cotangent`):
  > "**Iter-134 placeholder**: reflexive iso `Ω_{G/k} ≅ Ω_{G/k}` (wrapped in `Nonempty` to record that this is a non-constructive placeholder pending the sheaf-level RHS construction in subsequent iters). Step 1 (`shearMulRight`) is fully closed at this iter; Steps 2 and 3 are NEEDS_MATHLIB_GAP_FILL and gated on the iter-134+ multi-iter piece (i.b) lane closure."

  Severity: **critical** (load-bearing — main lemma of piece (i.b)).

Additionally, the section-introduction docstring at L421–447 amounts to a meta-excuse-comment over the three theorems below it; flagged as **major** above rather than re-listed here.

## Severity summary

- **must-fix-this-iter**: 3 — these block downstream work in `Cotangent/GrpObj.lean` (specifically the iter-134+ piece (i.b) lane closure) until the body/type mismatch is resolved (either by genuine bodies, or by replacing each placeholder theorem with an honest `sorry`-bodied scaffold whose *type signature is the intended type*, not a trivial reflexive iso).
- **major**: 2 (1 stale-anchor batch known per directive; 1 section-introduction docstring)
- **minor**: 2
- **excuse-comments**: 3 (also counted under must-fix-this-iter above; called out separately because they document the project lying to itself).

**Overall verdict**: One file (`Cotangent/GrpObj.lean`) carries the entire critical-severity issue surface — three iter-134-introduced placeholder theorems where the body does not match the named claim, each accompanied by a docstring that admits "placeholder" status; the rest of the project is honest scaffolding. The iter-134 prover lane delivered one solid piece (the `shearMulRight` shear iso + companion simp lemmas, lines 348–393) and three hollow placeholders that should either be (a) rewritten with intended-type signatures and `sorry` bodies (the same pattern `Jacobian.lean`'s `positiveGenusWitness` follows honestly), or (b) deleted until the substantive iter-135+ work can land.
