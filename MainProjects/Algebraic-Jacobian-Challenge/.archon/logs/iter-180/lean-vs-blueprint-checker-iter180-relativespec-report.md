# Lean ↔ Blueprint Check Report

## Slug
iter180-relativespec

## Iteration
180

## Files audited
- Lean: `AlgebraicJacobian/Picard/RelativeSpec.lean`
- Blueprint: `blueprint/src/chapters/Picard_RelativeSpec.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (chapter: `def:qc_sheaf_of_algebras`)
- **Lean target exists**: yes (L143 `structure QcohAlgebra (X : Scheme.{u})`).
- **Signature matches**: partial. Prose pins "$\mathcal{O}_X$-module is quasi-coherent" (full `SheafOfModules.IsQuasicoherent`); Lean carries a weaker `NatTrans.Coequifibered` overlay (Stacks 01LL form). The chapter NOTE at L61-77 explicitly authorizes this Mathlib-alignment ("strictly weaker [...] equivalent under the dense-subsite equivalence `AffineZariskiSite.sheafEquiv`"). Acceptable per the documented review note, but the prose at L52-58 still pins the stronger form.
- **Proof follows sketch**: N/A (definition).
- **notes**: Carrier shape (3-field structure: `sheaf`/`unit`/`coequifibered`) matches the chapter NOTE verbatim.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (chapter: `thm:relative_spec_exists`)
- **Lean target exists**: yes (L192, `noncomputable def`).
- **Signature matches**: yes. Body is `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued` — canonical Mathlib value, non-tautological.
- **Proof follows sketch**: yes (definitionally — Mathlib's `relativeGluingData` is the chapter's `Scheme.GlueData`-via-affine-pieces).
- **notes**: Auxiliary `RelativeSpec.structureMorphism` at L208 (also Mathlib-backed) is not pinned but acknowledged in the docstring as a needed auxiliary; this is fine — it's helper-only.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (chapter: `thm:relative_spec_univ`)
- **Lean target exists**: yes (L264).
- **Signature matches**: partial. Prose pins the full Yoneda bijection `Hom_X(T, Spec_X(𝒜)) ≅ Hom_{O_X-alg}(𝒜, g_*O_T)`; Lean carries only the structural consequence `IsAffineHom (structureMorphism 𝒜)`. The chapter NOTE at L163-167 explicitly authorizes the iter-173 weaker form as a transitional encoding and pins the iter-174+ upgrade (still pending iter-180).
- **Proof follows sketch**: partial. Chapter sketch is a Yoneda-subfunctor argument (L233-244). Lean uses `isAffineHom_of_forall_exists_isAffineOpen` + `relativeGluingData.toBase_preimage_eq_opensRange_ι` + `isAffineOpen_opensRange`. The Lean proof is a structural-consequence proof of the weakened conclusion; given the weakened type, the proof is mathematically faithful but operates at a different level than the chapter sketch.
- **notes**: Acknowledged divergence; flagged for upgrade in the NOTE.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` (chapter: `thm:relative_spec_affine_base`)
- **Lean target exists**: yes (L311).
- **Signature matches**: no — name is misleading and the type is weaker. Prose pins the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`; Lean has `IsAffine ((Spec R).RelativeSpec 𝒜)`. Name suggests an iff but the type is a bare `IsAffine`. Chapter NOTE at L254-259 explicitly authorizes the iter-173 weaker form and pins iter-174+ for the canonical-iso upgrade.
- **Proof follows sketch**: partial. Chapter sketch covers the `Ã`-via-quasi-coherence argument and the universal-pair construction (L310-329). Lean proof is the cleaner "affine over affine is affine" derivation via `UniversalProperty 𝒜` + `isAffine_of_isAffineHom` — strictly weaker but consistent with the weakened conclusion.
- **notes**: The mismatch between the name `affine_base_iff` and the actual `IsAffine` body is a minor naming drift, called out in the chapter NOTE.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` (chapter: `thm:relative_spec_base_change`)
- **Lean target exists**: yes (L443).
- **Signature matches**: partial. Prose pins canonical iso `T ×_X Spec_X(𝒜) ≅ Spec_T(g^*𝒜)` with named `g^*𝒜`; Lean has `∃ 𝒜', Nonempty (pullback ≅ T.RelativeSpec 𝒜')` — existentially quantified rather than named. Chapter NOTE at L339-343 + L382-390 authorize the iter-173 existential as a transitional encoding; iter-179 Lane B explicitly named the witness as `QcohAlgebra.pullback g 𝒜` per L384-385.
- **Proof follows sketch**: partial. Chapter sketch is a Yoneda argument (L391-402). Lean proof packages the existential by `⟨QcohAlgebra.pullback g _𝒜, pullback_iso g _𝒜⟩` — a witness-and-helper pattern, with the substantive iso content deferred to the helper `pullback_iso` (which is currently `sorry`, L433). The chapter sketch's actual reasoning is not yet encoded.
- **notes**: Real content is now on the `pullback_iso` helper (which is the directive's off-target sorry). The iter-180 work (`pullback_fst_isAffineHom` + `pullback_coequifibered`) supplies the `coequifibered` field of `QcohAlgebra.pullback` kernel-clean; the canonical-iso body is still open.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` (chapter: `thm:relative_spec_functorial`)
- **Lean target exists**: yes (L471).
- **Signature matches**: no. Prose pins a contravariant `Functor (QcohAlg(X))^{op} → AffSch/X` packaging morphism action, identity/composition, AND the equivalence onto affine `X`-schemes via `π_* O_{Spec_X(𝒜)} ≅ 𝒜`. Lean has the bare object-level function `X.QcohAlgebra → Over X` — no morphism action, no equivalence claim, no `AffSch/X` (just `Over X`). Chapter NOTE at L412-417 explicitly authorizes the iter-173 object-level form and pins iter-174+ for the full `Functor` upgrade.
- **Proof follows sketch**: N/A (definition).
- **notes**: Body is `fun 𝒜 => Over.mk (structureMorphism 𝒜)` — concrete and non-tautological. The categorical upgrade is the pending iter-174+ commitment.

## Red flags

### Placeholder / suspect bodies
- `RelativeSpec.pullback_iso` (L429-433): body is `sorry`. This is the off-target sorry the iter-180 directive explicitly left in place. The chapter does NOT have a dedicated `\lean{...}` pin for `pullback_iso`; it is the substantive content of `base_change`'s canonical iso. Per the directive, this is **not** an iter-180 must-fix, but it IS a load-bearing sorry that consumers of `base_change` will silently propagate (`base_change` returns the existential via this helper). This is documented honestly in the chapter NOTE at L389-390 ("treat the iso witness as load-bearing-pending").

### Excuse-comments
None. The "iter-173 file-skeleton encodes this as..." NOTE blocks in the blueprint are honest workflow markers (acknowledging the prose vs. Lean type gap and pinning the upgrade iteration); they are not laundering wrong code.

### Axioms / Classical.choice on non-trivial claims
None observed in this file.

## Unreferenced declarations (informational)

The following declarations exist in the Lean file but have no `\lean{...}` reference. Most are legitimate iter-179/180 helpers, but they are now load-bearing for the pinned theorems and the blueprint should at least name them in the relevant proof NOTE blocks.

- `Scheme.RelativeSpec.structureMorphism` (L208) — auxiliary, referenced from 4 pinned declarations. Acknowledged in its own docstring at L195-207 ("not in the 6 blueprint pins").
- `Scheme.QcohAlgebra.pullback_fst_isAffineHom` (L335) — **NEW iter-180 helper.** Feeds `pullback_coequifibered`. Not referenced in the chapter at all.
- `Scheme.QcohAlgebra.pullback_coequifibered` (L358) — **NEW iter-180 helper.** Supplies the `coequifibered` field of `QcohAlgebra.pullback`. Not referenced in the chapter at all.
- `Scheme.QcohAlgebra.pullback` (L390) — iter-179 helper; referenced in the `base_change` proof-block NOTE at L384-385 but NOT pinned via `\lean{...}`. Now load-bearing for `base_change`.
- `Scheme.RelativeSpec.pullback_iso` (L429) — iter-179 helper; referenced in the `base_change` proof-block NOTE at L386 but NOT pinned via `\lean{...}`. Body is `sorry`; load-bearing for `base_change`.

The iter-180 reorganization (moving `QcohAlgebra.pullback` from before `namespace RelativeSpec` to after `RelativeSpec.UniversalProperty`) does **not** break any blueprint cross-references — all chapter `\lean{...}` pins use fully-qualified names (`AlgebraicGeometry.Scheme.X`) and are unaffected by namespace-block reorganization within the file.

## Blueprint adequacy for this file

- **Coverage**: 6/6 chapter `\lean{...}` pins are present in the Lean file. **5 unreferenced load-bearing declarations** (`structureMorphism`, `pullback_fst_isAffineHom`, `pullback_coequifibered`, `pullback`, `pullback_iso`) exist in the file. Two (`pullback`, `pullback_iso`) are already named in prose NOTE blocks of the `base_change` proof; **two of the iter-180 helpers (`pullback_fst_isAffineHom`, `pullback_coequifibered`) are not named anywhere in the chapter**. `structureMorphism` is documented in its Lean docstring as a deliberate helper, but the chapter does not acknowledge that the universal property and base-change proofs depend on a separately-extracted structure morphism.
- **Proof-sketch depth**: **under-specified for the iter-180 work and for `pullback_iso`.** The chapter proof of `thm:relative_spec_base_change` (L391-402) is a Yoneda-level argument with no mention of the Mathlib idiom the Lean is actually using:
  - No mention of `Scheme.AffineZariskiSite.coequifibered_iff_forall_isLocalizationAway`.
  - No mention of `IsAffineOpen.isLocalization_of_eq_basicOpen`.
  - No mention of `MorphismProperty.pullback_fst` (the "affineness stable under base change" instance derivation underlying `pullback_fst_isAffineHom`).
  - For `pullback_iso`: chapter sketches a Yoneda argument but the Lean docstring at L420-428 commits to a different proof strategy ("descends from the universal property of `Cover.RelativeGluingData.glued` applied to the directed affine cover of T") — a cocone-construction argument the chapter is silent on. Iter-181+ work on this body would have to invent the cocone strategy from the Lean docstring alone; the blueprint does not preview it.
- **Hint precision**: precise for the 6 pins (the `\lean{...}` namespaces are unambiguous), but **the §"Lean encoding" section at L486-509 is stale**. It names `Scheme.GlueData` / `AffineScheme.glueOpens` / `IsAffineOpen.toScheme` / `QuasiCoherent.tensorIso` / `CategoryTheory.Functor.RepresentableBy` as the planned Mathlib API, but the actual iter-179+ Lean uses `AffineZariskiSite.relativeGluingData` / `Cover.RelativeGluingData` / `NatTrans.Coequifibered` — a different (now-Mathlib-aligned) infrastructure. Section should be updated to reflect the iter-178 consult outcome.
- **Generality**: matches need for the 6 pins (the chapter explicitly authorizes the iter-173 weaker encodings via NOTE blocks and pins the upgrades). However, the iter-179/180 helper layer (`QcohAlgebra.pullback`, `pullback_iso`, and now the two `pullback_*` helpers) is a *parallel API* the project ended up writing because the chapter's Yoneda sketch did not factor through the `RelativeGluingData` Mathlib idiom. This is acceptable as an implementation strategy but the chapter should name the helpers it relies on.
- **Recommended chapter-side actions** (for a blueprint-writing subagent, **non-blocking** per the directive — the directive is read-only on Lean and asked us only to report):
  - Add an iter-180 NOTE inside the `thm:relative_spec_base_change` proof block (after the existing iter-179 NOTE at L382-390) naming the two new helpers `Scheme.QcohAlgebra.pullback_fst_isAffineHom` and `Scheme.QcohAlgebra.pullback_coequifibered`, plus the Mathlib idioms they use (`coequifibered_iff_forall_isLocalizationAway`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `MorphismProperty.pullback_fst`, `Scheme.Hom.preimage_basicOpen`).
  - Optionally promote `Scheme.QcohAlgebra.pullback` and `Scheme.RelativeSpec.pullback_iso` to dedicated `\lean{...}` blocks (they are now first-class helpers, not transient scaffolding) — at minimum a `\lemma`-block with a one-line description for each.
  - Refresh §"Lean encoding" (L486-509) to name `AffineZariskiSite.relativeGluingData` and the `Coequifibered`-overlay idiom as the chosen Mathlib backbone (replacing the stale `GlueData`/`AffineScheme.glueOpens` mention).
  - For iter-181+ work on the remaining `pullback_iso` sorry: either expand the `thm:relative_spec_base_change` proof block to sketch the cocone-on-`Cover.RelativeGluingData` argument the Lean docstring commits to, or add a dedicated `\lemma{pullback_iso_construction}` block previewing that construction. The current Yoneda sketch is silent on the chosen approach.

## Severity summary

Apply the verbatim rules:

- **must-fix-this-iter**: **none.**
  - The signature mismatches on `UniversalProperty`, `affine_base_iff`, `base_change`, and `functor` ARE prose-vs-Lean mismatches, but each is explicitly authorized by an iter-173-review NOTE in the chapter (L163-167, L254-259, L339-343, L412-417) pinning an iter-174+ upgrade commitment. The blueprint and Lean are *consistent* on the weakened encodings; this is a known/load-bearing-pending status, not a hidden defect.
  - The `pullback_iso` sorry is explicitly off-target per the directive ("off-target `pullback_iso` at L429 left as sorry per directive"), and is documented honestly in the chapter NOTE at L389-390.
- **major**:
  - §"Lean encoding" (L486-509) is stale and names Mathlib API that the Lean no longer uses. A future prover reading this section as a roadmap would be misled about the chosen infrastructure.
  - The iter-180 helpers `pullback_fst_isAffineHom` and `pullback_coequifibered` are unreferenced from the chapter despite being load-bearing for `base_change`. They should be named in the iter-180 NOTE block.
- **minor**:
  - `affine_base_iff` naming drift (Lean type is `IsAffine`, not `Iff`) is documented in the existing NOTE but the name itself remains; a rename to `affine_base_isAffine` would tighten consistency (acknowledged as iter-174+ work).
  - The §3 prose claim "$\mathcal{O}_X$-module is quasi-coherent" at L52-58 of `def:qc_sheaf_of_algebras` is now strictly stronger than the Lean's `NatTrans.Coequifibered`; the iter-179 NOTE handles this transparently but a one-line clarification in the definition prose itself would help future readers.

**Overall verdict**: The iter-180 Lane C edits to `RelativeSpec.lean` are internally consistent and the blueprint NOTE chain honestly tracks the iter-by-iter prose/Lean alignment status; no must-fix findings, but the chapter should be updated (major) to name the two new iter-180 helpers and refresh the stale §"Lean encoding" infrastructure summary, and is currently under-specified (major-bordering) on the proof strategy for the remaining `pullback_iso` sorry that iter-181+ will need to close.
